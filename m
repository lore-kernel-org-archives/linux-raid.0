Return-Path: <SRS0=fBal=B4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E60C433DF
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 22:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C82E220738
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 22:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="nX/wfNqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgHRW1G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:27:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726807AbgHRW1G (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 Aug 2020 18:27:06 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMG7mV018178
        for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2020 15:27:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8f4kr5Czb0VesxF+8CSsJ+KlmEBTDneNu0mABhqLnaI=;
 b=nX/wfNqVjFHtn//FM7lyurKGdt/gFqo0DD+TwQ4BOb/+pNtjarMXYY6eodUZ8RO0x6MA
 dqcSdB2FxL6+da8AEvD2Ln8tyyEVDehJj6nZlSLooeE8+h5GSZUGrPoz+MeHqQ5zY9jY
 S7Je1jMmj28DPIAmmXd2gwgodFEne2zSMKU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304prnen1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2020 15:27:05 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:27:02 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9388962E4B8C; Tue, 18 Aug 2020 15:27:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, <hch@infradead.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 1/3] block: introduce part_[begin|end]_io_acct
Date:   Tue, 18 Aug 2020 15:26:43 -0700
Message-ID: <20200818222645.952219-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818222645.952219-1-songliubraving@fb.com>
References: <20200818222645.952219-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=806 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

These functions can be used to enable iostat for partitions on devices
like md, bcache.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 block/blk-core.c       | 39 +++++++++++++++++++++++++++++++++------
 include/linux/blkdev.h |  5 +++++
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93104c7470e8a..02953e9db3dd0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1455,10 +1455,9 @@ void blk_account_io_start(struct request *rq)
 	part_stat_unlock();
 }
=20
-unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sect=
ors,
-		unsigned int op)
+static unsigned long __part_start_io_acct(struct hd_struct *part,
+					  unsigned int sectors, unsigned int op)
 {
-	struct hd_struct *part =3D &disk->part0;
 	const int sgrp =3D op_stat_group(op);
 	unsigned long now =3D READ_ONCE(jiffies);
=20
@@ -1471,12 +1470,26 @@ unsigned long disk_start_io_acct(struct gendisk *=
disk, unsigned int sectors,
=20
 	return now;
 }
+
+unsigned long part_start_io_acct(struct gendisk *disk, struct hd_struct =
**part,
+				 struct bio *bio)
+{
+	*part =3D disk_map_sector_rcu(disk, bio->bi_iter.bi_sector);
+
+	return __part_start_io_acct(*part, bio_sectors(bio), bio_op(bio));
+}
+EXPORT_SYMBOL(part_start_io_acct);
+
+unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sect=
ors,
+				 unsigned int op)
+{
+	return __part_start_io_acct(&disk->part0, sectors, op);
+}
 EXPORT_SYMBOL(disk_start_io_acct);
=20
-void disk_end_io_acct(struct gendisk *disk, unsigned int op,
-		unsigned long start_time)
+static void __part_end_io_acct(struct hd_struct *part, unsigned int op,
+			       unsigned long start_time)
 {
-	struct hd_struct *part =3D &disk->part0;
 	const int sgrp =3D op_stat_group(op);
 	unsigned long now =3D READ_ONCE(jiffies);
 	unsigned long duration =3D now - start_time;
@@ -1487,6 +1500,20 @@ void disk_end_io_acct(struct gendisk *disk, unsign=
ed int op,
 	part_stat_local_dec(part, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 }
+
+void part_end_io_acct(struct hd_struct *part, struct bio *bio,
+		      unsigned long start_time)
+{
+	__part_end_io_acct(part, bio_op(bio), start_time);
+	hd_struct_put(part);
+}
+EXPORT_SYMBOL(part_end_io_acct);
+
+void disk_end_io_acct(struct gendisk *disk, unsigned int op,
+		      unsigned long start_time)
+{
+	__part_end_io_acct(&disk->part0, op, start_time);
+}
 EXPORT_SYMBOL(disk_end_io_acct);
=20
 /*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 285b59cfc0646..d2ee868b16a51 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1931,6 +1931,11 @@ unsigned long disk_start_io_acct(struct gendisk *d=
isk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
=20
+unsigned long part_start_io_acct(struct gendisk *disk, struct hd_struct =
**part,
+				 struct bio *bio);
+void part_end_io_acct(struct hd_struct *part, struct bio *bio,
+		      unsigned long start_time);
+
 /**
  * bio_start_io_acct - start I/O accounting for bio based drivers
  * @bio:	bio to start account for
--=20
2.24.1

