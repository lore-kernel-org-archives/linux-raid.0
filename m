Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6A2C4361B
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 22:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C92823D1C
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 22:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388410AbgLIWFC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:05:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5736 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388429AbgLIWE7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Dec 2020 17:04:59 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9LwuTA007349
        for <linux-raid@vger.kernel.org>; Wed, 9 Dec 2020 14:04:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=Kt4gFE5XwRUbIun+h1fyNNxFgIka9LB8tZNlBDhL61w=;
 b=QN8bXjjMa/3Oq1mMdLd367L3cCecd/KrPnu81vEMgP+BIB2aI6pIIaArBbbVMosgRTqy
 PJpBeXx+GVeyfpwkNADz0S5C+/q67hKKrCRHRPZ3txLXYjp+16xcwTDW4r1mxERGRMRF
 Kwq5XrH7/l9e+cvOOCIDxPFAbMq01wohkt4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ak7a7vrp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 09 Dec 2020 14:04:18 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 13:58:45 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9C5F362E51F1; Wed,  9 Dec 2020 13:58:22 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dm-devel@redhat.com>
CC:     Song Liu <songliubraving@fb.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Xiao Ni <xni@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] Revert "dm raid: remove unnecessary discard limits for raid10"
Date:   Wed, 9 Dec 2020 13:58:14 -0800
Message-ID: <20201209215814.2623617-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_18:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=824
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012090151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit f0e90b6c663a7e3b4736cb318c6c7c589f152c28.

Matthew Ruffell reported data corruption in raid10 due to the changes
in discard handling [1]. Revert these changes before we find a proper fix.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/
Cc: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Xiao Ni <xni@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/dm-raid.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9c1f7c4de65b3..dc8568ab96f24 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3728,6 +3728,17 @@ static void raid_io_hints(struct dm_target *ti, stru=
ct queue_limits *limits)
=20
 	blk_limits_io_min(limits, chunk_size_bytes);
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
+
+	/*
+	 * RAID10 personality requires bio splitting,
+	 * RAID0/1/4/5/6 don't and process large discard bios properly.
+	 */
+	if (rs_is_raid10(rs)) {
+		limits->discard_granularity =3D max(chunk_size_bytes,
+						  limits->discard_granularity);
+		limits->max_discard_sectors =3D min_not_zero(rs->md.chunk_sectors,
+							   limits->max_discard_sectors);
+	}
 }
=20
 static void raid_postsuspend(struct dm_target *ti)
--=20
2.24.1

