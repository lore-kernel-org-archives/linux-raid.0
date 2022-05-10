Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFB6C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbiEJRNe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347790AbiEJRNX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611D528ED3F
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AEtXBk011683
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=IdNcVy/AkWa/wZRpDZxUw1QyXwKG6Cp0zVAv9eMrzW8=;
 b=nI+QHpRBL40kQ2zTgl+rqfskmTOWStKg5Ldc62WQunmTx6iyKAfHVqFPpk9jEzuP/rbH
 I6csf+yxrsAdLBOHeTKpSI5n+Tc4yMX51C9WA5Y/QLZI8G3zo+kJBFJ/U7x24gi8m89F
 N2vpfaHLmewwJ9dMXSeVrZ9fe837lwm8j7PMpbPYSm1ncjtYpyzuxIL3Zyy+gSFtgoqE
 2DQQE/XxcK0v512C8GWoE7CcMqhE1VHCGieqqiJdPLRfhEUVhVmC4OUqMTn70B66ifra
 ibWnsvdMmsjRPVQnDXO0xIq8jf607XsEX8xShiOi/wfS9eRjq33vwoDv0SsyiholU5Hi Zg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsqfyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqJ016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:23 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-8
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:23 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 7/7] tests: avoid passing chunk size to raid1
Date:   Tue, 10 May 2022 10:09:20 -0700
Message-Id: <20220510170920.18730-8-himanshu.madhani@oracle.com>
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
X-Proofpoint-GUID: e8Am7OS0I8lU-eOiWbUlZbgW08b3_L-y
X-Proofpoint-ORIG-GUID: e8Am7OS0I8lU-eOiWbUlZbgW08b3_L-y
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

'04update-metadata' test fails with error, "specifying chunk size is
forbidden for this level" added by commit, 5b30a34aa4b5e. Hence,
correcting the test to ignore passing chunk size to raid1.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 tests/04update-metadata | 7 ++++++-
 tests/05r1-re-add       | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/04update-metadata b/tests/04update-metadata
index 08c14af7ed29..ef4c973198e0 100644
--- a/tests/04update-metadata
+++ b/tests/04update-metadata
@@ -11,7 +11,12 @@ dlist="$dev0 $dev1 $dev2 $dev3"
 for ls in linear/4 raid1/1 raid5/3 raid6/2
 do
   s=${ls#*/} l=${ls%/*}
-  mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  if [[ $l == 'raid1' ]]
+  then
+	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 $dlist
+  else
+	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  fi
   testdev $md0 $s 19904 64
   mdadm -S $md0
   mdadm -A $md0 --update=metadata $dlist
diff --git a/tests/05r1-re-add b/tests/05r1-re-add
index fa6bbcb421e5..12da5644dee5 100644
--- a/tests/05r1-re-add
+++ b/tests/05r1-re-add
@@ -14,6 +14,7 @@ sleep 4
 mdadm $md0 -f $dev2
 sleep 1
 mdadm $md0 -r $dev2
+cat /proc/mdstat
 mdadm $md0 -a $dev2
 #cat /proc/mdstat
 check nosync
-- 
2.27.0

