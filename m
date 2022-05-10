Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D630C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 17:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347807AbiEJRNZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 13:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347793AbiEJRNV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 13:13:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E047028F7EC
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 10:09:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AGCvjH010450
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=W9NbwvhdnrXXNzLuxYLdnIAcDlLDbDCyCov2gvZdk7M=;
 b=vYHeFMkid1eTzgDhvpH1y8cPVGMgYC+6wvm2j00ppsexgoBW9NC8pYDPgbys1RyW6Z1S
 SSxTDbeoCZTDHdEYIXVJyeQy90Bs0c4yS8GWlqboGtKVPW8Tl216thhjf6ZwSQMvCWx8
 0QaDwuDr1OgkUTJHaI5u+dRQGcY3UnG52rzdc5f0enrOl4HxkLOX2Jb1UDzAZHKuMrpQ
 GY6IHWmYp5C8NsYRieBasTfHaSM3rxOAt+xLhMXrNiZgFkRLW1kjcrq12bo2JL6DqbiJ
 krw1iVM9WVypUm+UPMOUJOg6zf9XFtLZen09y+J8WP+6kSbU2T5iFAHEykgwM6y384nS AQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwf6c78q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AH5dqC016348
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:20 GMT
Received: from coruscant.us.oracle.com (dhcp-10-159-252-166.vpn.oracle.com [10.159.252.166])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf739t3p-1
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 17:09:20 +0000
From:   himanshu.madhani@oracle.com
To:     linux-raid@vger.kernel.org
Subject: [PATCH v3 0/7] Resurrect mdadm test cases
Date:   Tue, 10 May 2022 10:09:13 -0700
Message-Id: <20220510170920.18730-1-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.33.0.69.gc4203212e360
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_04:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=821 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100074
X-Proofpoint-ORIG-GUID: Z71A1Zf5irxlg_gRP8NweSYSNSLXT4QG
X-Proofpoint-GUID: Z71A1Zf5irxlg_gRP8NweSYSNSLXT4QG
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@oracle.com>

Hi, 

I am picking up patches that were submitted earlier [1] and received
comments which were addressed in [2]. This series is an attempt to
resurrect the review request with combined patchset that resolves error
encountered while running test cases for each of the raid types.

I've tested this series with latest 5.18.0-rc4+ kernel. 

[1] https://marc.info/?l=linux-raid&m=162697853622376&w=2

[2] https://marc.info/?l=linux-raid&m=163907488120973&w=2

Thanks,
Himanshu

Sudhakar Panneerselvam (7):
  tests: add a test that validates raid0 with layout fails for 0.9
    version
  tests: fix raid0 tests for 0.90 metadata
  Revert "mdadm: fix coredump of mdadm --monitor -r"
  test: clear the superblock at every iteration in 02lineargrow
  tests: Add a test for write-intent bitmap support for imsm
  tests: fix $dir path
  tests: avoid passing chunk size to raid1

 ReadMe.c                |  6 +++---
 test                    |  1 +
 tests/00raid0           | 10 ++++------
 tests/00readonly        |  4 ++++
 tests/02lineargrow      |  2 ++
 tests/03r0assem         |  6 +++---
 tests/04r0update        |  4 ++--
 tests/04update-metadata |  9 +++++++--
 tests/05r1-re-add       |  1 +
 tests/09imsm-bitmap     | 18 ++++++++++++++++++
 10 files changed, 45 insertions(+), 16 deletions(-)
 create mode 100644 tests/09imsm-bitmap

-- 
2.27.0

