Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC61C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347808AbiEJRN0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347797AbiEJRNW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E928FEAC
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AEtbuA023549
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=26868VK88rRzITNPJxL2+fPpeL7xfrpZas0s8f1Ex8g=;
 b=uGksTZIX0IeTWD4X/E89wxlx1dF5gQctQs221paNsakrX0JSuXOh43JUcX0Ghg9ipi0o
 3kg+ojF9lOMm77mw81r3qctAx1fRbPZC56yv1mN/IKfJpwDkoU+1JCMSDNfrTLdUg1LZ
 3zY8fyXH4Gag8bSLi3S9FQ0URt7fnSemz5/LIsDZzbbsOFPdhP7bTCgl/iECPIk7fHJf
 hAusY3F31DMCZOCHilcE4dt0mCzmkjzrWJLgaQJjnO7tFy4bL4WGZH1szftjd6GokWDK
 dYhpcqIYp07NRf1kofXXrWD7L7Hfqb4yxbcDiP3QXDJmAgy36J8LE9yynzn/VGDwumyb +A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsqfym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqH016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-6
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 5/7] tests: Add a test for write-intent bitmap support for imsm
Date:   Tue, 10 May 2022 10:09:18 -0700
Message-Id: <20220510170920.18730-6-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.33.0.69.gc4203212e360
In-Reply-To: <20220510170920.18730-1-himanshu.madhani@oracle.com>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_04:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=992 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100074
X-Proofpoint-GUID: u4n892VVOlBA2d5zmZFuU9diKcboMiu1
X-Proofpoint-ORIG-GUID: u4n892VVOlBA2d5zmZFuU9diKcboMiu1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

imsm now supports write-intent bitmaps introduced by commit
fbc425562c57 ("imsm: Write-intent bitmap support").
This new test case performs some basic test using
bitmaps with imsm.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 tests/09imsm-bitmap | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 tests/09imsm-bitmap

diff --git a/tests/09imsm-bitmap b/tests/09imsm-bitmap
new file mode 100644
index 000000000000..447662f2594b
--- /dev/null
+++ b/tests/09imsm-bitmap
@@ -0,0 +1,18 @@
+. tests/env-imsm-template
+
+num_disks=2
+size=$((10*1024))
+mdadm -CR $container -e imsm -n $num_disks $dev0 $dev1
+imsm_check container $num_disks
+
+mdadm -CR $member0 -n $num_disks -l 1 --bitmap=internal $dev0 $dev1 -z $size
+check bitmap
+testdev $member0 1 $size 64
+mdadm -Ss
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm -A $container $dev0 $dev1
+mdadm -IR $container
+check bitmap
+testdev ${member0}_0 1 $size 64
+mdadm -Ss
-- 
2.27.0

