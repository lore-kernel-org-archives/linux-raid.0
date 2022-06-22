Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F80C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiFVUZm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiFVUZb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:31 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D6036B41
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=+JRZ9g54SAu+siTWbS9T+HaWBQFQ+/nBsrVAy1s0Bnw=; b=XUqlfRYaDoq0qEjymJuj5XK6Wh
        UynPOnaNrWUxErWibzvStLIn4uE90kKzkkE6ZGns4Lz3G8dQXIG3mI1/XsE+LWdcIEQEO2N32xz/T
        n24TM1J6Yn37rQ1OWKJFBXuMwpH5G5dAfjbo9K+BQMJX4Drd3KXs0TEATIdcljNyodgKIFEZw8bkg
        zbl0Oe27dy75JC1IXecdXQ/9ER3qQIBWqeShbC+qWiw6W/3q1ZL0YUVpY/HNm5sCetRAe8+Gb5g0l
        fkbRVYVa0Q/jbiZClNAMBnqykad1UeySktkk9zCxpLOj9DXUdaFwrFGGQC28P3J/a35bqQIFVqeQV
        RxrJmuUQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46um-00EGya-F5; Wed, 22 Jun 2022 14:25:29 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46ui-0009Mn-9r; Wed, 22 Jun 2022 14:25:24 -0600
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
Date:   Wed, 22 Jun 2022 14:25:17 -0600
Message-Id: <20220622202519.35905-13-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 12/14] mdadm/test: Add a mode to repeat specified tests
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Many tests fail infrequently or rarely. To help find these, add
an option to run the tests multiple times by specifying --loop=N.

If --loop=0 is specified, the test will be looped forever.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 test | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/test b/test
index 711a3c7a2076..da6db5e0f631 100755
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
2.30.2

