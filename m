Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654E3C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347795AbiEJRNX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347791AbiEJRNV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D06E28FE9E
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AEtbu8023549
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=Yn6UxefRJ9uFaso7xy255Y3klo/iiLgDJIIPlE22EWs=;
 b=wEwDiTCCfiVR2lDuotzG4jndSWt6PgoBUSH5PO3q/7cAhlWiRCSaImt0DTZf5hRUleeB
 j9Txrpq41i6I4BhH0YkTg7eL9ftMhbH3mlEZ0yMF9niqGvq57eDM7DOBmH81gCNGzKwX
 Nia4zd59ttegP2P8RpaX897xpOp1/IrGCHWIeAIYl1z0lE6J+XyVXbDGYqL1cyyeiHsj
 YhowOHhkOBnyNCajH+zZ4eYFkriFRjEAR0LIU1Gr6cTRIktCh4Wz5V2SgxRYGaMZxEyG
 lwVetJEVCC59UfeJtLQtJI4p/NRKM/fdNMZ9zGgyI80bH/0uOHZ+IE73hLt63XPKMvq9 FA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsqfyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqE016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-3
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 2/7] tests: fix raid0 tests for 0.90 metadata
Date:   Tue, 10 May 2022 10:09:15 -0700
Message-Id: <20220510170920.18730-3-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.33.0.69.gc4203212e360
In-Reply-To: <20220510170920.18730-1-himanshu.madhani@oracle.com>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_04:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100074
X-Proofpoint-GUID: _dlUEImjegC67YZGKTOEGfDaGgB2Pi0V
X-Proofpoint-ORIG-GUID: _dlUEImjegC67YZGKTOEGfDaGgB2Pi0V
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
2.27.0

