Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEFBC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347809AbiEJRN2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347794AbiEJRNV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A514228ED2D
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:23 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AFg6pC022886
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=+jhuPB4ojyPCs/5HKBTOvNU+xVtwrIvFftEVtvqByqQ=;
 b=g+c9MurcKjFKpHNfQzfxQkscZKrEjo5v69NP2FO7L6yP37gG63uW3MK1u3KBDXeZuNfJ
 3lqX4SxW5eBVVhb5+E6cNomv7Id8AHyZ5RiBBTUkJWqMrtQDUb8QqHcttBstIKdLGiCx
 cmFnl6pEhrZeOf+HwmoqdUlAYbC1XySl/IbxQOzTibP39ZW40cW5XmaoY/w/marcAZeu
 A59qy6s9dm71pthNVFApRYAgM4PDfGH1HGwHp/sau4qLIdcrZla7A51T1Z6y2t1h+otc
 Pi1PEelKPOMoaOOUGxIwBlNMwKQULnnPrR5zkOt4vzyzDQyjXd3haZaOdQkH93berOpH +Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwhatfd9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqG016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-5
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 4/7] test: clear the superblock at every iteration in 02lineargrow
Date:   Tue, 10 May 2022 10:09:17 -0700
Message-Id: <20220510170920.18730-5-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.33.0.69.gc4203212e360
In-Reply-To: <20220510170920.18730-1-himanshu.madhani@oracle.com>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_04:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=905 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100074
X-Proofpoint-GUID: BrikDvKbiaGjvU9gv_qSvZMh7diwEgoP
X-Proofpoint-ORIG-GUID: BrikDvKbiaGjvU9gv_qSvZMh7diwEgoP
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

This fixes 02lineargrow test as prior metadata causes --add operation
to misbehave.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 tests/02lineargrow | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/02lineargrow b/tests/02lineargrow
index e05c219d113a..595bf9f20802 100644
--- a/tests/02lineargrow
+++ b/tests/02lineargrow
@@ -20,4 +20,6 @@ do
   testdev $md0 3 $sz 1
 
   mdadm -S $md0
+  mdadm --zero /dev/loop2
+  mdadm --zero /dev/loop3
 done
-- 
2.27.0

