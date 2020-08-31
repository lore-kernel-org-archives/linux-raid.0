Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82E3C433E6
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 22:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A682083E
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 22:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="Mq4XhLOX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgHaW1p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Aug 2020 18:27:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57602 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728113AbgHaW1o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 Aug 2020 18:27:44 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VMNMu9016071
        for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2020 15:27:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3/qO9hKgMLtNVpJ/qjz2/Lrd1LgKB861yWJf8rT5enU=;
 b=Mq4XhLOXIXwHN2yfUNPIOriU7f+BaNxi8JJ01m6wrvoAL5WLPIDhda9Qx8HVEyUpUfhQ
 OR2FVQwGyWCvgrmB9lf8R8t2R9Bk7QqlBBZDwEgiC0Ync3blR8tIQfzB3kHug2BG+IWQ
 wBdzAc1opx6jyuxY+bMd8aWCkPtmvJbbx5M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33879nf93y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2020 15:27:44 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 15:27:42 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 6FF8662E51BC; Mon, 31 Aug 2020 15:27:39 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, <hch@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/3] md: use part_[begin|end]_io_acct instead of disk_[begin|end]_io_acct
Date:   Mon, 31 Aug 2020 15:27:24 -0700
Message-ID: <20200831222725.3860186-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200831222725.3860186-1-songliubraving@fb.com>
References: <20200831222725.3860186-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_10:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=853 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008310132
X-FB-Internal: deliver
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This enables proper statistics in /proc/diskstats for md partitions.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6072782070230..8d310d90001c8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -464,6 +464,7 @@ struct md_io {
 	bio_end_io_t *orig_bi_end_io;
 	void *orig_bi_private;
 	unsigned long start_time;
+	struct hd_struct *part;
 };
=20
 static void md_end_io(struct bio *bio)
@@ -471,7 +472,7 @@ static void md_end_io(struct bio *bio)
 	struct md_io *md_io =3D bio->bi_private;
 	struct mddev *mddev =3D md_io->mddev;
=20
-	disk_end_io_acct(mddev->gendisk, bio_op(bio), md_io->start_time);
+	part_end_io_acct(md_io->part, bio, md_io->start_time);
=20
 	bio->bi_end_io =3D md_io->orig_bi_end_io;
 	bio->bi_private =3D md_io->orig_bi_private;
@@ -517,9 +518,8 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		bio->bi_end_io =3D md_end_io;
 		bio->bi_private =3D md_io;
=20
-		md_io->start_time =3D disk_start_io_acct(mddev->gendisk,
-						       bio_sectors(bio),
-						       bio_op(bio));
+		md_io->start_time =3D part_start_io_acct(mddev->gendisk,
+						       &md_io->part, bio);
 	}
=20
 	/* bio could be mergeable after passing to underlayer */
--=20
2.24.1

