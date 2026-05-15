Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE25947F2C5
	for <linux-raid@vger.kernel.org>; Fri, 15 May 2026 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778846439; cv=none; b=WTmSUU/hVCk5cm8n8SGN+Tuwm9VwPmCl71VR2TmEbm11FqvejgPSK+C7fFTLUuaXwX0R9ybHiq8b/16vXAI4Mq59D6UijR4YYIH82sKCYWx6NSwYNr4oFF806yMAJZEOpYYfhz1oBWK1jbMSRaBk4bt8ik/BmcS1MxCrtexwFpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778846439; c=relaxed/simple;
	bh=dBbmBbCH39fVoDhoF4GuQJMtnosegOiB2IgKtZPTsug=;
	h=Mime-Version:To:Cc:Date:Content-Type:From:Subject:Message-Id; b=qf2pq9xUIE1CwIuMW51ZDxYy9bDkm39/bqkyC4bnwenxczBnsdK1CMJF2za99Rz2RFvLTcbNtDzEnszAske3/RMNjYvxZGefwM5Z9fNsyaAeLMaO769AzxzEm1VEulgJTLhMFgPLs/supVvbRTOXU3YkWMcN+SV5z2o1QL7CDK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=qWCQ3Mf7; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="qWCQ3Mf7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1778846426;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bd8WBUO65NIB6/OM5Q2OwXdEedlVvVGaZw+07ktBsKs=;
 b=qWCQ3Mf71+96ChxMJoxo9Txy4/BmV7tIsGPVHKqVDMCFSn+CpABfgc8ehOW0ET+YB4Qtqc
 m53dKb6O5AhsgE+/8OJ8N7zyMUTUltgx0w4TMfsi0a96gbgInoh60fK9a7DpcU5C36jPnZ
 yBwf0zIMEQP5/USov8SIMYk+k9F/2Uiq1ZE76Avq/nfbwVIm9kANxwpZNeyMolYCuSfke3
 YRw6wCkvvOrdB/OP0fD7e97ebTE5lPCZTv+n4J7UfgB8NWI07bNVqLlkWJ7JaYd2MjKaAw
 t2A7UmlX6h5j4Z6qbrvKIIJmFv64fRQcRu3nJBm47rU50uZDM/qfreN/Nu2UpA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Yu Kuai" <yukuai@fnnas.com>, <linux-raid@vger.kernel.org>
X-Mailer: git-send-email 2.54.0
X-Lms-Return-Path: <lba+26a070ad8+1916cb+vger.kernel.org+chencheng@fnnas.com>
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Fri, 15 May 2026 20:00:12 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([113.111.244.134]) by smtp.feishu.cn with ESMTPS; Fri, 15 May 2026 20:00:24 +0800
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md/linear,raid0: introduce badblocks handling
Message-Id: <20260515120012.3699839-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit

From: Chen Cheng <chencheng@fnnas.com>

md/linear and raid0 do not currently consult rdev badblocks, so I/O
can still be submitted to ranges that are already known to be bad.

The existing submit-path disk_live() fast-fail only covers removed
devices. It does not help when a member device is still present but a
mapped read fails, and immediately calling md_error() for every I/O
failure would make these arrays unnecessarily fragile.

Add badblocks handling for both raid-0 and md-linear personalities.

Before submitting a mapped bio, check the target rdev badblocks. If the
bio starts on a known bad range, fail it immediately. If it crosses into
a bad range, split it so that only the leading good sectors are submitted.

Also remember the mapped target rdev and sector range in md_io_clone, so
md_end_clone_io() can record badblocks for linear/raid0 failures.
This allows later I/O to fail fast on known bad sectors while avoiding
escalation to md_error() on every read failure. If badblocks cannot be
recorded, rdev_set_badblocks() will still trigger md_error().

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md-linear.c | 33 +++++++++++++++++++++++++++------
 drivers/md/md.c        | 16 ++++++++++++++++
 drivers/md/md.h        | 11 +++++++++--
 drivers/md/raid0.c     | 32 ++++++++++++++++++++++++++------
 4 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index fdff250d0d51..c6695658b698 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -237,6 +237,12 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 	struct dev_info *tmp_dev;
 	sector_t start_sector, end_sector, data_offset;
 	sector_t bio_sector = bio->bi_iter.bi_sector;
+	sector_t first_bad, bad_sectors, good_sectors;
+	sector_t target_start_sector, bio_start_sector;
+	struct md_io_clone *md_io_clone;
+	unsigned int target_nr_sectors;
+	enum req_op op = bio_op(bio);
+	bool is_rw = (op == REQ_OP_READ || op == REQ_OP_WRITE);
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)
 	    && md_flush_request(mddev, bio))
@@ -251,12 +257,6 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		     bio_sector < start_sector))
 		goto out_of_bounds;
 
-	if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
-		md_error(mddev, tmp_dev->rdev);
-		bio_io_error(bio);
-		return true;
-	}
-
 	if (unlikely(bio_end_sector(bio) > end_sector)) {
 		/* This bio crosses a device boundary, so we have to split it */
 		bio = bio_submit_split_bioset(bio, end_sector - bio_sector,
@@ -265,10 +265,31 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 			return true;
 	}
 
+	bio_start_sector = bio->bi_iter.bi_sector - start_sector;
+
+	if (is_rw && is_badblock(tmp_dev->rdev, bio_start_sector,
+				 bio_sectors(bio), &first_bad, &bad_sectors)) {
+		if (first_bad == bio_start_sector) {
+			bio_io_error(bio);
+			return true;
+		}
+
+		good_sectors = first_bad - bio_start_sector;
+		bio = bio_submit_split_bioset(bio, good_sectors, &mddev->bio_set);
+		if (!bio)
+			return true;
+	}
+
+	target_start_sector = bio->bi_iter.bi_sector - start_sector;
+	target_nr_sectors = bio_sectors(bio);
+
 	md_account_bio(mddev, &bio);
 	bio_set_dev(bio, tmp_dev->rdev->bdev);
 	bio->bi_iter.bi_sector = bio->bi_iter.bi_sector -
 		start_sector + data_offset;
+	md_io_clone = bio->bi_private;
+	md_set_clone_target(md_io_clone, tmp_dev->rdev,
+			    target_start_sector, target_nr_sectors);
 
 	if (unlikely((bio_op(bio) == REQ_OP_DISCARD) &&
 		     !bdev_max_discard_sectors(bio->bi_bdev))) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e..995a8fa5f6a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9218,6 +9218,13 @@ static void md_end_clone_io(struct bio *bio)
 	struct md_io_clone *md_io_clone = bio->bi_private;
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
+	struct md_rdev *target_rdev = md_io_clone->target_rdev;
+	sector_t target_start_sector = md_io_clone->target_start_sector;
+	unsigned int target_nr_sectors = md_io_clone->target_nr_sectors;
+	enum md_submodule_id id = mddev->pers->head.id;
+	bool is_raid0_or_linear = (id == ID_LINEAR || id == ID_RAID0);
+	enum req_op op = bio_op(orig_bio);
+	bool is_rw = (op == REQ_OP_READ || op == REQ_OP_WRITE);
 
 	if (bio_data_dir(orig_bio) == WRITE && md_bitmap_enabled(mddev, false))
 		md_bitmap_end(mddev, md_io_clone);
@@ -9225,6 +9232,12 @@ static void md_end_clone_io(struct bio *bio)
 	if (bio->bi_status && !orig_bio->bi_status)
 		orig_bio->bi_status = bio->bi_status;
 
+	if (bio->bi_status && target_rdev && target_nr_sectors &&
+	    is_raid0_or_linear && is_rw) {
+		rdev_set_badblocks(target_rdev, target_start_sector,
+				   target_nr_sectors, 0);
+	}
+
 	if (md_io_clone->start_time)
 		bio_end_io_acct(orig_bio, md_io_clone->start_time);
 
@@ -9243,6 +9256,9 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
 	md_io_clone->orig_bio = *bio;
 	md_io_clone->mddev = mddev;
+	md_io_clone->target_rdev = NULL;
+	md_io_clone->target_start_sector = 0;
+	md_io_clone->target_nr_sectors = 0;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..3122c66ef379 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -872,6 +872,9 @@ struct md_thread {
 
 struct md_io_clone {
 	struct mddev	*mddev;
+	struct md_rdev	*target_rdev;
+	sector_t	target_start_sector;
+	unsigned int	target_nr_sectors;
 	struct bio	*orig_bio;
 	unsigned long	start_time;
 	sector_t	offset;
@@ -961,9 +964,13 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev,
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
 
-static inline bool is_rdev_broken(struct md_rdev *rdev)
+static inline void
+md_set_clone_target(struct md_io_clone *clone, struct md_rdev *rdev,
+		    sector_t start_sector, unsigned int nr_sectors)
 {
-	return !disk_live(rdev->bdev->bd_disk);
+	clone->target_rdev = rdev;
+	clone->target_start_sector = start_sector;
+	clone->target_nr_sectors = nr_sectors;
 }
 
 static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ef0045db409f..b95a16139fcd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -559,8 +559,12 @@ static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
 	struct md_rdev *tmp_dev;
 	sector_t bio_sector = bio->bi_iter.bi_sector;
 	sector_t sector = bio_sector;
-
-	md_account_bio(mddev, &bio);
+	sector_t bio_start_sector, target_start_sector;
+	sector_t first_bad, bad_sectors, good_sectors;
+	unsigned int target_nr_sectors;
+	struct md_io_clone *md_io_clone;
+	enum req_op op = bio_op(bio);
+	bool is_rw = (op == REQ_OP_READ || op == REQ_OP_WRITE);
 
 	zone = find_zone(mddev->private, &sector);
 	switch (conf->layout) {
@@ -576,13 +580,29 @@ static void raid0_map_submit_bio(struct mddev *mddev, struct bio *bio)
 		return;
 	}
 
-	if (unlikely(is_rdev_broken(tmp_dev))) {
-		bio_io_error(bio);
-		md_error(mddev, tmp_dev);
-		return;
+	bio_start_sector = sector + zone->dev_start;
+
+	if (is_rw && is_badblock(tmp_dev, bio_start_sector, bio_sectors(bio),
+				 &first_bad, &bad_sectors)) {
+		if (first_bad == bio_start_sector) {
+			bio_io_error(bio);
+			return;
+		}
+
+		good_sectors = first_bad - bio_start_sector;
+		bio = bio_submit_split_bioset(bio, good_sectors, &mddev->bio_set);
+		if (!bio)
+			return;
 	}
 
+	target_start_sector = sector + zone->dev_start;
+	target_nr_sectors = bio_sectors(bio);
+
+	md_account_bio(mddev, &bio);
 	bio_set_dev(bio, tmp_dev->bdev);
+	md_io_clone = bio->bi_private;
+	md_set_clone_target(md_io_clone, tmp_dev, target_start_sector,
+			    target_nr_sectors);
 	bio->bi_iter.bi_sector = sector + zone->dev_start +
 		tmp_dev->data_offset;
 	mddev_trace_remap(mddev, bio, bio_sector);
-- 
2.54.0
