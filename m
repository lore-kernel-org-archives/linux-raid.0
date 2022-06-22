Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A21CCA479
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiFVUZi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiFVUZb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:31 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D5E369F6
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=Izv7CasWdRxZdbqaq8iettcLBBTlXt66MwXBRskp2P0=; b=lSBKK7+CgtnGIs2cSUi08zf1mF
        b7LDh7WmAwXLTB6W4A3Ccc9ltgQMHPgLpfQPJINELdGZ/l1o7SG/SdSQP9El/5NHObuIyg2IAe/4Q
        i9kBXBW/Pxmto8SWU9qelV8wYHO6qTB1AX7GDXm8zuKViFTtn9K1cOAqs/WgNiCmRDsBBppLPnrFa
        UIBIuHPi5q6zEvJItlHeBNUXVPTgMLJkj1KtM5sB3gOwzedcZU1f3HrZ22pXdGAsp1YbKBIngrTIg
        +KYKjbHxlwRqRdFztuan2lP0mq6/fPOi/UGKv1SccQroAJXtdhXdQMCPLW3WOgw9SRd9fzGkrdr/f
        YUQAW3Pg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46um-00EGyX-85; Wed, 22 Jun 2022 14:25:29 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46ui-0009Mr-Du; Wed, 22 Jun 2022 14:25:24 -0600
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
Date:   Wed, 22 Jun 2022 14:25:18 -0600
Message-Id: <20220622202519.35905-14-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 13/14] mdadm/test: Mark and ignore broken test failures
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

