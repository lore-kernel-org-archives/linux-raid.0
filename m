Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29D1C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbiG1MWF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbiG1MVt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45D66A4BB
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:48 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6DEF61FD87;
        Thu, 28 Jul 2022 12:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1OsrSWjE8J9wun/qKNlUPTe5wDyPDxeW+GZHrVKVIY=;
        b=kwZ2LrQh0QxptdoaidDdaZwN6pc+AwyB5HAhB7RoJ10xIDEsCbP/jXzBQxHBKSK1Y1lFJ4
        9myzhIisVwxFiFmAspByoJwKBXQKYL+dnZ6NbZODB0KCoj8p/EPiA4UaDaDnsuAm64vKTu
        yIg8sE1p2spYpIt8Wdh7qFLa6xIH5Pk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010907;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C1OsrSWjE8J9wun/qKNlUPTe5wDyPDxeW+GZHrVKVIY=;
        b=eW0bHew2knxHLiL9GZgctOP0uREpvRojgKHbWWwpg6CdVwKpQtM6700O4OK510iXVThTCY
        WWylB9ORwPFZeSAA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 43F2D2C141;
        Thu, 28 Jul 2022 12:21:43 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 09/23] tests: fix raid0 tests for 0.90 metadata
Date:   Thu, 28 Jul 2022 20:20:47 +0800
Message-Id: <20220728122101.28744-10-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Acked-by: Coly Li <colyli@suse.de>
---
 tests/00raid0           | 4 ++--
 tests/00readonly        | 4 ++++
 tests/03r0assem         | 6 +++---
 tests/04r0update        | 4 ++--
 tests/04update-metadata | 2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tests/00raid0 b/tests/00raid0
index e6b21cc4..9b8896cb 100644
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
index 28b0fa13..39202487 100644
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
index 6744e322..44df0645 100644
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
index 73ee3b9f..b95efb06 100644
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
index 232fc1ff..08c14af7 100644
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
2.35.3

