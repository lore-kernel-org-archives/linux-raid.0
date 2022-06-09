Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40EE7C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 21:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244861AbiFIVLo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 17:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiFIVLn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 17:11:43 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD9A26D900
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 14:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=Izv7CasWdRxZdbqaq8iettcLBBTlXt66MwXBRskp2P0=; b=NiI29QKEYM5oZC23Gqb86KMAlI
        sCQJlM+i9a147xre/oOVZqBTACaCyhsQ3akWTmXERY7yiMk9BwRaPtNdSe63faZc+e+0RkjtSrjJ5
        BZ9vgs89WJietnI+iwoTdniUlhTWQ4nbjXtNYZ7O7zVe6Heremt8o6akqiAkK/zu8CgFaoFMkPNol
        tA6E0+js0WtBHCAZziLDR2rnlqGAN0ralAi2I1rS3HhKvqNcng2HSkv+tF1XsvnKLBgsEWwWDAd0C
        f7qivPck8KrASVW4bxWTCp/wsk+MGXFwxFqRVJAGfIQz9YmUyXr0n5GKuJJkokv6vN86i5XnNMen/
        uM8ZvFZw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRL-0037Xk-1x; Thu, 09 Jun 2022 15:11:39 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1nzPRF-0001M8-V8; Thu, 09 Jun 2022 15:11:34 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu,  9 Jun 2022 15:11:29 -0600
Message-Id: <20220609211130.5108-14-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220609211130.5108-1-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v1 13/14] mdadm/test: Mark and ignore broken test failures
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add functionality to continue if a test marked as broken fails.

To mark a test as broken, a file with the same name but with the suffix
'.broken' should exist. The first line in the file will be printed with
a KNOWN BROKEN message; the rest of the file can describe the how the
test is broken.

Also adds --skip-broken and --skip-always-broken to skip all the tests
that have a .broken file or to skip all tests whose .broken file's first
line contains the keyword always.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 test | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/test b/test
index da6db5e0f631..61d9ee83226e 100755
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
2.30.2

