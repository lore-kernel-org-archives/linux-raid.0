Received: from sg-1-31.ptr.blmpb.com (sg-1-31.ptr.blmpb.com [118.26.132.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A36366568
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 06:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772606034; cv=none; b=L0J8TpN0vfFeF1ZuGZYSOYyf5KUFVkpmqejeEOzGDTieKyno1C7uShqVgpmqTP+dXuoI1+8r6nYS+uG+zpglFpoJJszh1lvpS5aDVEH11xtjUvCdSor5QRLoS7j/UGt6j5083LBtCRM6GQQ670JXZfDMLVey6OZa12av7JtnCiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772606034; c=relaxed/simple;
	bh=WKd1wX5oWQFacnqnRN+G0kyS84bYGlgJJCndY2aN7E8=;
	h=Content-Type:To:Date:Mime-Version:Cc:From:Message-Id:Subject; b=YDjRjQ1MD5DH56XFr/ERtOpZQXWT8lFgCnZaK7pAg38JrNJ0FwA/4vcN1B7NkiHebM9mm7ZPLqR64rUC+YM+Y0MYQUAqee/p1ocfC0upF5CgCKAqVJj9QzkzyAqN5rUkGJZhc/jk3PL4Rx7U8qOASnZ0StLRQM9CMw7Oi0WyJpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=g265wKbE; arc=none smtp.client-ip=118.26.132.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="g265wKbE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772606025;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=hSjrbHho5ekd2ZnNMmhV0P8so7P9W/oN41CqZGXubw0=;
 b=g265wKbES2vGAaJI92NHCwUmj/mJVMcisFEQn6pUhA1jR4tKqF17cuEXlwTCsej713WMfI
 jos5N1KnXYgbeXdNp3TVsWlpcdtKVBcZiEKkuoyJio5Rjg407USnPEFC9BniQjHiCs/kcU
 dRHQddq3qo2eKxS1fjW+up0aGH2krPDnq/AZHYNC5Gez/lVSVxJDaoCzOn/rsMBxVub/By
 1yT3CaV6IB/K+cJDAPb4xDETaP7pyqIiIorILaI02nPlWUYGV+wAi5kuCo24/ftKyAaSH8
 HvENSjBWc/9vhZUx/aQP390eEjP9Fa89mTWikcouHZlQozVutPEvLWQ6rTIQug==
X-Lms-Return-Path: <lba+269a7d247+615755+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
Date: Wed,  4 Mar 2026 22:29:07 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from c ([113.111.185.142]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 14:33:42 +0800
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	"Chen Cheng" <chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260304142907.3791-1-chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Subject: [PATCH] md/raid0,linear: move error handling from make_request to IO completion
X-Mailer: git-send-email 2.51.0

raid0 and linear call md_error() in the submission path after checking
is_rdev_broken() (i.e. disk_live() =3D=3D false). This was intended as a
safety fast-fail for removed disks, but is unnecessary: the block layer
already handles GD_DEAD disks in __bio_queue_enter() and fails IO
immediately without hanging. More importantly, it misses the offline
case where the disk still exists but rejects IO =E2=80=94 in that scenario,=
 IO
fails silently and md_error() is never called.

Remove the submission-path check and instead call md_error() from
md_end_clone_io() on any IO failure. Store the target rdev in
md_io_clone so the completion handler knows which device failed. This
uniformly handles disk removal, offline status, and any other IO error.

Since raid0 and linear have no redundancy, any disk IO failure means
data is already lost, so marking the array broken on any error is
correct.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md-linear.c |  7 +------
 drivers/md/md.c        |  5 +++++
 drivers/md/md.h        | 11 ++++++-----
 drivers/md/raid0.c     |  7 +------
 4 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index fdff250d0d51..2ba181a1297d 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -251,12 +251,6 @@ static bool linear_make_request(struct mddev *mddev, s=
truct bio *bio)
 		     bio_sector < start_sector))
 		goto out_of_bounds;
=20
-	if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
-		md_error(mddev, tmp_dev->rdev);
-		bio_io_error(bio);
-		return true;
-	}
-
 	if (unlikely(bio_end_sector(bio) > end_sector)) {
 		/* This bio crosses a device boundary, so we have to split it */
 		bio =3D bio_submit_split_bioset(bio, end_sector - bio_sector,
@@ -269,6 +263,7 @@ static bool linear_make_request(struct mddev *mddev, st=
ruct bio *bio)
 	bio_set_dev(bio, tmp_dev->rdev->bdev);
 	bio->bi_iter.bi_sector =3D bio->bi_iter.bi_sector -
 		start_sector + data_offset;
+	md_set_clone_rdev((struct md_io_clone *)bio->bi_private, tmp_dev->rdev);
=20
 	if (unlikely((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
 		     !bdev_max_discard_sectors(bio->bi_bdev))) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e..7caa24c4919d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9218,6 +9218,7 @@ static void md_end_clone_io(struct bio *bio)
 	struct md_io_clone *md_io_clone =3D bio->bi_private;
 	struct bio *orig_bio =3D md_io_clone->orig_bio;
 	struct mddev *mddev =3D md_io_clone->mddev;
+	enum md_submodule_id id =3D mddev->pers->head.id;
=20
 	if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(mddev, false=
))
 		md_bitmap_end(mddev, md_io_clone);
@@ -9225,6 +9226,10 @@ static void md_end_clone_io(struct bio *bio)
 	if (bio->bi_status && !orig_bio->bi_status)
 		orig_bio->bi_status =3D bio->bi_status;
=20
+	if (bio->bi_status && md_io_clone->rdev &&
+	    (id =3D=3D ID_LINEAR || id =3D=3D ID_RAID0))
+		md_error(mddev, md_io_clone->rdev);
+
 	if (md_io_clone->start_time)
 		bio_end_io_acct(orig_bio, md_io_clone->start_time);
=20
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..625f8304de3b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -872,6 +872,7 @@ struct md_thread {
=20
 struct md_io_clone {
 	struct mddev	*mddev;
+	struct md_rdev	*rdev;
 	struct bio	*orig_bio;
 	unsigned long	start_time;
 	sector_t	offset;
@@ -917,6 +918,11 @@ extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
 void md_account_bio(struct mddev *mddev, struct bio **bio);
+static inline void md_set_clone_rdev(struct md_io_clone *clone,
+				     struct md_rdev *rdev)
+{
+	clone->rdev =3D rdev;
+}
 void md_free_cloned_bio(struct bio *bio);
=20
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio =
*bio);
@@ -961,11 +967,6 @@ extern void mddev_destroy_serial_pool(struct mddev *md=
dev,
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
=20
-static inline bool is_rdev_broken(struct md_rdev *rdev)
-{
-	return !disk_live(rdev->bdev->bd_disk);
-}
-
 static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *md=
dev)
 {
 	int faulty =3D test_bit(Faulty, &rdev->flags);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ef0045db409f..e933abeb0d70 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -576,15 +576,10 @@ static void raid0_map_submit_bio(struct mddev *mddev,=
 struct bio *bio)
 		return;
 	}
=20
-	if (unlikely(is_rdev_broken(tmp_dev))) {
-		bio_io_error(bio);
-		md_error(mddev, tmp_dev);
-		return;
-	}
-
 	bio_set_dev(bio, tmp_dev->bdev);
 	bio->bi_iter.bi_sector =3D sector + zone->dev_start +
 		tmp_dev->data_offset;
+	md_set_clone_rdev((struct md_io_clone *)bio->bi_private, tmp_dev);
 	mddev_trace_remap(mddev, bio, bio_sector);
 	mddev_check_write_zeroes(mddev, bio);
 	submit_bio_noacct(bio);
--=20
2.51.0
