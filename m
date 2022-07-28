Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97298C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiG1MWS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238415AbiG1MWB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4A66BD57
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A3541373CB;
        Thu, 28 Jul 2022 12:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pw7cIdXr7WAsVBHq9uKGVT6njF+0x3bEjM5vqVAU99E=;
        b=u3AJYwhNQ+wwK5gIKd0Ip5ZS+54HS5k/9CiyUeDiViSuO1RxcApo5eiqJ6FWtT2FdKslUm
        AnHFU4JrkN+YmGcNOGmvq+/xpo0cvFdztrHSfRofJcvapGdv5QH0ZMl1QQDFRzOWxGuYwx
        zSISPsEVAabpssX/BdC5Iv7lxKwCl4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010918;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pw7cIdXr7WAsVBHq9uKGVT6njF+0x3bEjM5vqVAU99E=;
        b=0o1dm9aUUqq7ywvHZ9236kKAmoPBfdPK6N1jB8DerP4NKRj4ynBvW5H5IiG0oQRkrOGqXe
        BjKIDFE0PqzHkcDw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 7A10B2C141;
        Thu, 28 Jul 2022 12:21:56 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 12/23] mdadm/test: Add a mode to repeat specified tests
Date:   Thu, 28 Jul 2022 20:20:50 +0800
Message-Id: <20220728122101.28744-13-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

Many tests fail infrequently or rarely. To help find these, add
an option to run the tests multiple times by specifying --loop=N.

If --loop=0 is specified, the test will be looped forever.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Coly Li <colyli@suse.de>
---
 test | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/test b/test
index 711a3c7a..da6db5e0 100755
--- a/test
+++ b/test
@@ -10,6 +10,7 @@ devlist=
 
 savelogs=0
 exitonerror=1
+loop=1
 prefix='[0-9][0-9]'
 
 # use loop devices by default if doesn't specify --dev
@@ -117,6 +118,7 @@ do_help() {
 		--logdir=directory          Directory to save all logfiles in
 		--save-logs                 Usually use with --logdir together
 		--keep-going | --no-error   Don't stop on error, ie. run all tests
+		--loop=N                    Run tests N times (0 to run forever)
 		--dev=loop|lvm|ram|disk     Use loop devices (default), LVM, RAM or disk
 		--disks=                    Provide a bunch of physical devices for test
 		--volgroup=name             LVM volume group for LVM test
@@ -211,6 +213,9 @@ parse_args() {
 		--keep-going | --no-error )
 			exitonerror=0
 			;;
+		--loop=* )
+			loop="${i##*=}"
+			;;
 		--disable-multipath )
 			unset MULTIPATH
 			;;
@@ -263,19 +268,26 @@ main() {
 	echo "Testing on linux-$(uname -r) kernel"
 	[ "$savelogs" == "1" ] &&
 		echo "Saving logs to $logdir"
-	if [ "x$TESTLIST" != "x" ]
-	then
-		for script in ${TESTLIST[@]}
-		do
-			do_test $testdir/$script
-		done
-	else
-		for script in $testdir/$prefix $testdir/$prefix*[^~]
-		do
-			do_test $script
-		done
-	fi
 
+	while true; do
+		if [ "x$TESTLIST" != "x" ]
+		then
+			for script in ${TESTLIST[@]}
+			do
+				do_test $testdir/$script
+			done
+		else
+			for script in $testdir/$prefix $testdir/$prefix*[^~]
+			do
+				do_test $script
+			done
+		fi
+
+		let loop=$loop-1
+		if [ "$loop" == "0" ]; then
+			break
+		fi
+	done
 	exit 0
 }
 
-- 
2.35.3

