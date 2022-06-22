Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F80CCA47F
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 20:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiFVUZs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 16:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiFVUZc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 16:25:32 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C013D369DB
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 13:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=9XsLn8P/ZHyuehC/8bpzEu5IbWvJqS53bLSU/ZPvPKU=; b=Sw6rNfj40OpjQvdSgrFGrhOWDp
        gxd0kMTFTApkJmVOiP4IOT9aFTO6t3FxqHcNj7T7D8Z4IzJ0gN5FyLICa2VG19Xytq+HfSwjQcOJ3
        lVX77cJ3pNHY2SOS3h3/B5EwkWwE9luBrrKWEZzmTecDvk7LVJ4R0iWzpqgZ+NEDwzQdkNhqHd73H
        gPF5w/wGjC4j4PyDtMB/Ubf4QT4Y61nV4xVKUn6nfyQiAJ/H4/lTMorHRinggO0z85+x+vzoShLKq
        QzLY3NMWmuELxzD6mG9gCHukc22eaQCze4tBmTd29ocsuJYL6oS83zgvcbxsJyOMvnkeDqjWF/Nyt
        NwPLr3eg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46un-00EGyX-H6; Wed, 22 Jun 2022 14:25:30 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o46uh-0009Ma-P9; Wed, 22 Jun 2022 14:25:23 -0600
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
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 22 Jun 2022 14:25:14 -0600
Message-Id: <20220622202519.35905-10-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622202519.35905-1-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, himanshu.madhani@oracle.com, sudhakar.panneerselvam@oracle.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v2 09/14] tests: fix raid0 tests for 0.90 metadata
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

Some of the test cases fail because raid0 creation fails with the error,
"0.90 metadata does not support layouts for RAID0" added by commit,
329dfc28debb. Fix some of the test cases by switching from raid0 to
linear level for 0.9 metadata where possible.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 tests/00raid0           | 4 ++--
 tests/00readonly        | 4 ++++
 tests/03r0assem         | 6 +++---
 tests/04r0update        | 4 ++--
 tests/04update-metadata | 2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tests/00raid0 b/tests/00raid0
index e6b21cc419eb..9b8896cbdc52 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -20,8 +20,8 @@ mdadm -S $md0
 # now same again with different chunk size
 for chunk in 4 32 256
 do
-  mdadm -CR $md0 -e0.90 -l raid0 --chunk $chunk -n3 $dev0 $dev1 $dev2
-  check raid0
+  mdadm -CR $md0 -e0.90 -l linear --chunk $chunk -n3 $dev0 $dev1 $dev2
+  check linear
   testdev $md0 3 $mdsize0 $chunk
   mdadm -S $md0
 
diff --git a/tests/00readonly b/tests/00readonly
index 28b0fa13f815..39202487f614 100644
--- a/tests/00readonly
+++ b/tests/00readonly
@@ -4,6 +4,10 @@ for metadata in 0.9 1.0 1.1 1.2
 do
 	for level in linear raid0 raid1 raid4 raid5 raid6 raid10
 	do
+		if [[ $metadata == "0.9" && $level == "raid0" ]];
+		then
+			continue
+		fi
 		mdadm -CR $md0 -l $level -n 4 --metadata=$metadata \
 			$dev1 $dev2 $dev3 $dev4 --assume-clean
 		check nosync
diff --git a/tests/03r0assem b/tests/03r0assem
index 6744e3221062..44df06456233 100644
--- a/tests/03r0assem
+++ b/tests/03r0assem
@@ -68,9 +68,9 @@ mdadm -S $md2
 ### Now for version 0...
 
 mdadm --zero-superblock $dev0 $dev1 $dev2
-mdadm -CR $md2 -l0 --metadata=0.90 -n3 $dev0 $dev1 $dev2
-check raid0
-tst="testdev $md2 3 $mdsize0 512"
+mdadm -CR $md2 -llinear --metadata=0.90 -n3 $dev0 $dev1 $dev2
+check linear
+tst="testdev $md2 3 $mdsize0 1"
 $tst
 
 uuid=`mdadm -Db $md2 | sed 's/.*UUID=//'`
diff --git a/tests/04r0update b/tests/04r0update
index 73ee3b9fed91..b95efb06c761 100644
--- a/tests/04r0update
+++ b/tests/04r0update
@@ -1,7 +1,7 @@
 
 # create a raid0, re-assemble with a different super-minor
-mdadm -CR -e 0.90 $md0 -l0 -n3 $dev0 $dev1 $dev2
-testdev $md0 3 $mdsize0 512
+mdadm -CR -e 0.90 $md0 -llinear -n3 $dev0 $dev1 $dev2
+testdev $md0 3 $mdsize0 1
 minor1=`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
 mdadm -S /dev/md0
 
diff --git a/tests/04update-metadata b/tests/04update-metadata
index 232fc1ffff4b..08c14af7ed29 100644
--- a/tests/04update-metadata
+++ b/tests/04update-metadata
@@ -8,7 +8,7 @@ set -xe
 
 dlist="$dev0 $dev1 $dev2 $dev3"
 
-for ls in raid0/4 linear/4 raid1/1 raid5/3 raid6/2
+for ls in linear/4 raid1/1 raid5/3 raid6/2
 do
   s=${ls#*/} l=${ls%/*}
   mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
-- 
2.30.2

