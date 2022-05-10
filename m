Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E35C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347789AbiEJRNU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347787AbiEJRNT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF2428ED2D
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AFf2EX024475
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=xfBMBoRWbNiiHLgCJPE4mw0kvr8Pzhr+BgFjq9pElew=;
 b=kt8qj4NgPzvo6D4iP7sDCSAefoX2KlspEbJ+DYbf+qGXA0GDP4QhmImRHOx9yi/dXj9f
 Lktqv6hm23ZRVQdkFr5QoCCNEEJYok+9YHW/H7K4V9FacuuR4Tw/p0cKOJ1DhZoPXU9c
 F7ZlEF4rbbVI/sGKXX7ph0fdhCSSLbt/g6DRWp0TVs9bg67l8qlpxWDnxXj3PsswnED4
 aDYya5n4i0nb86iEo7yy0l7zOrdw50/qiR77bHIQN5S/JqmM7S0BoC0aIHJBinA7ZdRd
 75x7u/NSyUCgSr6Vklgv4IpXwgogjy5UbbardVEZq2VTjdUC2K739QNyPGvBetcfjj8x Fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfc0qdvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqD016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-2
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 1/7] tests: add a test that validates raid0 with layout fails for 0.9 version
Date:   Tue, 10 May 2022 10:09:14 -0700
Message-Id: <20220510170920.18730-2-himanshu.madhani@oracle.com>
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
X-Proofpoint-ORIG-GUID: 7R4gyZlIshNYtmyePj8TG10ke1upovc2
X-Proofpoint-GUID: 7R4gyZlIshNYtmyePj8TG10ke1upovc2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

329dfc28debb disallows the creation of raid0 with layouts for 0.9
metadata. This test confirms the new behavior.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 tests/00raid0 | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tests/00raid0 b/tests/00raid0
index 8bc18985f91a..e6b21cc419eb 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -6,11 +6,9 @@ check raid0
 testdev $md0 3 $mdsize2_l 512
 mdadm -S $md0
 
-# now with version-0.90 superblock
+# verify raid0 with layouts fail for 0.90
 mdadm -CR $md0 -e0.90 -l0 -n4 $dev0 $dev1 $dev2 $dev3
-check raid0
-testdev $md0 4 $mdsize0 512
-mdadm -S $md0
+check opposite_result
 
 # now with no superblock
 mdadm -B $md0 -l0 -n5 $dev0 $dev1 $dev2 $dev3 $dev4
-- 
2.27.0

