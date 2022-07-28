Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2DBC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiG1MWV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbiG1MWD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1333E6BD7A
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:03 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BAA731FD0B;
        Thu, 28 Jul 2022 12:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jg1IFJTt84YwAFCH5S32ONlsMDe/eB+/zGp4cZok4UA=;
        b=ukBc176mOghJ/hj71TjB/Dc6ASzgbUZOKTFwhcDb9cEjShhFcYRsoWisun1ggqOvRTQA2D
        rdDoMfPkXwTOzHIdVvwai8rs9uYSgmORdP/BI/MWWFOcZJoK8BoBTWKWUuWiTtWj6Azo/d
        UpJFgu3Xvc7jBdB28U95TbpvAAZBZNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010921;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jg1IFJTt84YwAFCH5S32ONlsMDe/eB+/zGp4cZok4UA=;
        b=1sVQefrRx6HAqUCS+ke1g5EjEAC11+e73Y1Xbh4lwLp4u6OD6LNsQR+TjctRyJfaqTanjw
        YAPBYStJtOjvjEBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 464AB2C141;
        Thu, 28 Jul 2022 12:21:58 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 13/23] mdadm/test: Mark and ignore broken test failures
Date:   Thu, 28 Jul 2022 20:20:51 +0800
Message-Id: <20220728122101.28744-14-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

Add functionality to continue if a test marked as broken fails.

To mark a test as broken, a file with the same name but with the suffix
'.broken' should exist. The first line in the file will be printed with
a KNOWN BROKEN message; the rest of the file can describe the how the
test is broken.

Also adds --skip-broken and --skip-always-broken to skip all the tests
that have a .broken file or to skip all tests whose .broken file's first
line contains the keyword always.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Coly Li <colyli@suse.de>
---
 test | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/test b/test
index da6db5e0..61d9ee83 100755
--- a/test
+++ b/test
@@ -10,6 +10,8 @@ devlist=
 
 savelogs=0
 exitonerror=1
+ctrl_c_error=0
+skipbroken=0
 loop=1
 prefix='[0-9][0-9]'
 
@@ -36,6 +38,7 @@ die() {
 
 ctrl_c() {
 	exitonerror=1
+	ctrl_c_error=1
 }
 
 # mdadm always adds --quiet, and we want to see any unexpected messages
@@ -80,8 +83,21 @@ mdadm() {
 do_test() {
 	_script=$1
 	_basename=`basename $_script`
+	_broken=0
+
 	if [ -f "$_script" ]
 	then
+		if [ -f "${_script}.broken" ]; then
+			_broken=1
+			_broken_msg=$(head -n1 "${_script}.broken" | tr -d '\n')
+			if [ "$skipbroken" == "all" ]; then
+				return
+			elif [ "$skipbroken" == "always" ] &&
+			     [[ "$_broken_msg" == *always* ]]; then
+				return
+			fi
+		fi
+
 		rm -f $targetdir/stderr
 		# this might have been reset: restore the default.
 		echo 2000 > /proc/sys/dev/raid/speed_limit_max
@@ -98,10 +114,15 @@ do_test() {
 		else
 			save_log fail
 			_fail=1
+			if [ "$_broken" == "1" ]; then
+				echo "  (KNOWN BROKEN TEST: $_broken_msg)"
+			fi
 		fi
 		[ "$savelogs" == "1" ] &&
 			mv -f $targetdir/log $logdir/$_basename.log
-		[ "$_fail" == "1" -a "$exitonerror" == "1" ] && exit 1
+		[ "$ctrl_c_error" == "1" ] && exit 1
+		[ "$_fail" == "1" -a "$exitonerror" == "1" \
+		  -a "$_broken" == "0" ] && exit 1
 	fi
 }
 
@@ -119,6 +140,8 @@ do_help() {
 		--save-logs                 Usually use with --logdir together
 		--keep-going | --no-error   Don't stop on error, ie. run all tests
 		--loop=N                    Run tests N times (0 to run forever)
+		--skip-broken               Skip tests that are known to be broken
+		--skip-always-broken        Skip tests that are known to always fail
 		--dev=loop|lvm|ram|disk     Use loop devices (default), LVM, RAM or disk
 		--disks=                    Provide a bunch of physical devices for test
 		--volgroup=name             LVM volume group for LVM test
@@ -216,6 +239,12 @@ parse_args() {
 		--loop=* )
 			loop="${i##*=}"
 			;;
+		--skip-broken )
+			skipbroken=all
+			;;
+		--skip-always-broken )
+			skipbroken=always
+			;;
 		--disable-multipath )
 			unset MULTIPATH
 			;;
@@ -279,7 +308,11 @@ main() {
 		else
 			for script in $testdir/$prefix $testdir/$prefix*[^~]
 			do
-				do_test $script
+				case $script in
+				 *.broken) ;;
+				 *)
+				     do_test $script
+				 esac
 			done
 		fi
 
-- 
2.35.3

