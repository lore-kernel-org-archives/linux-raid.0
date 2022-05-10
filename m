Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A23CC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347800AbiEJRNW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347787AbiEJRNV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE32D28F1CA
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AFMkd1024581
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=aZF4vjl0f3Yr18BWPSUCcs7zqiUm07022sWUV/MkL8I=;
 b=bjukxLPSeV96CU8ivNzADI9+V3qE1RpIXT3a+svRFLUlLqOzwKw0FMEknWg8vtM+/ITw
 OhIByTDumE9DUmqnRi83xYExxLyi0SjYhbfT4UIAtHDUheNWu6UXR87sMLc1zFR2qdv0
 lNE8LDsFIK119iVHmYSYGzIRd42KS32xS83ZEFNUAScOnAE1RLhV0tM+ugbmXbSODdkZ
 HySfCO153aAQnRLjb6uyO3F04wWx3pmqXIsSqkn7SafdWJSVYzIYzQLwnZxCOQix2+PT
 LA8EoegO3Itkw3SRjPzkC/iOPkBziCXs2mc5Ud52KGpYolJV/cewMxmTDHN3mFGphqr9 uQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfc0qdvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqF016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-4
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 3/7] Revert "mdadm: fix coredump of mdadm --monitor -r"
Date:   Tue, 10 May 2022 10:09:16 -0700
Message-Id: <20220510170920.18730-4-himanshu.madhani@oracle.com>
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
X-Proofpoint-ORIG-GUID: zJuJFXCP_tHw9C67dpLHMNfUdWEGnFdd
X-Proofpoint-GUID: zJuJFXCP_tHw9C67dpLHMNfUdWEGnFdd
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

This reverts commit 546047688e1c64638f462147c755b58119cabdc8.

546047688e1c made -r require parameter in monitor mode but this
inadvertently broke -r option in "manage" mode which is used for
removing devices that are either spare or in faulty mode resulting in
some of the test cases to fail.

Reverting 546047688e1c is safe as the core dump issue that was fixed by
this commit is addressed by 60815698c0ac where parsing failures are
handled better.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 ReadMe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 8f873c4895da..bec1be9ab26f 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
  *     found, it is started.
  */
 
-char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
+char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_auto_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
 
 struct option long_options[] = {
     {"manage",    0, 0, ManageOpt},
-- 
2.27.0

