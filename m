Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22043C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347814AbiEJRNd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347799AbiEJRNW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D5C296BFD
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AEtbuB023549
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=/rNr9y8d7xMKQGNpjyHiXZxKLCbbsBRecnr1QZQbSvg=;
 b=V7ehxo2tpmz4lt+o60B/vl9UByjm2N7wf22yv3SocKbFRYuMgXoC0zdegHpnvU+JaMF/
 wMZPCrEpHwlB7ImVDUmE1w263bwNcWDzn1RbN3FhJz3s4DeCdertJ1L8hy6JpsbeB1RJ
 4MS0lx71wMPXXt1Ff1qxvby5rJsjP0wvB4SVKkb4OJq9NNmJg+XLEdXelfIv+SkWegdm
 6veMRLBIzHUOpOuep6E+3qBQYL4iuq5NJiq/dpy2A9WCtrkfGuTvDztbequLz/EjSzqF
 pxWo4Sea/IjRAwZNPCovgl1WFxOLTrZeXaaXAJCf2XlAwAZDdk+8MJ/CLF1/B5XHle9p sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsqfyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqI016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:23 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-7
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 6/7] tests: fix $dir path
Date:   Tue, 10 May 2022 10:09:19 -0700
Message-Id: <20220510170920.18730-7-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.33.0.69.gc4203212e360
In-Reply-To: <20220510170920.18730-1-himanshu.madhani@oracle.com>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_04:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=965 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100074
X-Proofpoint-GUID: F2Y7cKefIsB702usauCuZDqpYb2uLptL
X-Proofpoint-ORIG-GUID: F2Y7cKefIsB702usauCuZDqpYb2uLptL
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>

Some of the test cases use $dir to refer to the location of mdadm and
other test binaries. But $dir was never initialized anywhere in the test
sequence.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 test | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test b/test
index 711a3c7a2076..91b0a98d593c 100755
--- a/test
+++ b/test
@@ -6,6 +6,7 @@ targetdir="/var/tmp"
 logdir="$targetdir"
 config=/tmp/mdadm.conf
 testdir=$PWD/tests
+dir=$PWD
 devlist=
 
 savelogs=0
-- 
2.27.0

