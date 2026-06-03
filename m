Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2BA3EDAAE
	for <linux-raid@vger.kernel.org>; Wed,  3 Jun 2026 04:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780459313; cv=none; b=Ja0WdPoYmsR5W6OE/BeNqQZU2IvkTNNTZuZLzMcgzRd4k6+Ujc1d6EVKjFVHExopIjna57S1IcN3q6blhGis+Mi2eVm6Uxzwe80HuM4wl8ts14ytQcTXJS/PJ+MbmzgYFpOkXu/+AWBAt46BNSCaUAuj22UoJ9pdVGZxSLhIj8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780459313; c=relaxed/simple;
	bh=dngVXY/Qf1Rg2F39aEyQlAaD9iic53HYsdKk3HDT1bY=;
	h=To:References:Mime-Version:Message-Id:In-Reply-To:Content-Type:
	 Subject:Date:Cc:From; b=SkamLA4eorfrB3Mr2enAdlm65+51EDBclNlsVT5QEPQ3UyeijSNqOjObDjLdVeOh6UIBVsnBlimUkxWEJ+yl1ViXY/gdqHAU6QXIr/ipx5q8F/yQ1ll8km27m20K2s3vY8+GqrKbgWVrknjkiTQjzEhfbyxkkIaHW7CFvMI1qZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=P89aTiOT; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="P89aTiOT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780459186;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rp1ZNRgyfojlQ5/e3lweNUa6nJunZToOQ7CDEDBOUuE=;
 b=P89aTiOTuHfesyhtCSd85/dliwog/rdeHRiD8L1AcQTpxC1QxW9SzZt/lr6W2DpwZvwpzg
 WXzC2WQ+QNfHQtPXCG/BwENfuxyNVAeD6dfQO1kx5TZUC6zexFQdND7tfpW4pQXZ3n5xS7
 dft6YFoaOo4x9zVMJkyuzFvdwRav+PfIrDUPM6gndw69aZEO/L4+8rEdZfy3ukOgg32U/b
 E2lgaZJJExy4bKf1rIeNgH+vOJXG5wTSi3K8z9DJHcuMDLWz+ibv8KyXYJ5UUmZHrUhKPg
 NYHgYIi4Y+YFDjdFAxhv1TvfvjoVRVj1+QrKey+wO00EvAajAXgr7QkYOnzcjA==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
References: <20260603035925.217847-1-chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.161.59]) by smtp.feishu.cn with ESMTPS; Wed, 03 Jun 2026 11:59:43 +0800
X-Original-From: chencheng@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0
Message-Id: <20260603035925.217847-3-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a1fa6b0+95469e+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260603035925.217847-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v4 2/3] md/raid10: make r10bio_pool use fixed-size objects
Date: Wed,  3 Jun 2026 11:59:24 +0800
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

raid10 currently sizes regular r10bio_pool objects from
conf->geo.raid_disks, which makes the mempool element width depend on
the current geometry.

That breaks across reshape. Regular r10bio objects are preallocated and
reused, so after a geometry change the pool may still contain objects
allocated for the old width. A later request under the new geometry can
then reuse an r10bio whose devs[] array is still sized for the previous
raid_disks value.

Fix this by backing r10bio_pool with a fixed-size kmalloc mempool sized
for the maximum width needed across the current reshape transition.
Apply the same sizing rule to standalone r10bio objects allocated from
r10buf_pool_alloc().

This removes the geometry-dependent allocation width from regular
r10bio_pool objects and prevents reshape from reusing pool entries that
are too small for the new layout.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 48 +++++++++++++++++++++++++++++++++------------
 drivers/md/raid10.h |  2 +-
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cee5a253a281..5eca34432e63 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -101,17 +101,32 @@ static void end_reshape(struct r10conf *conf);
 static inline struct r10bio *get_resync_r10bio(struct bio *bio)
 {
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
+static inline unsigned int calc_r10bio_pool_disks(struct mddev *mddev)
 {
-	struct r10conf *conf = data;
-	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
+	/* If delta_disks < 0, use bigger r10bio->devs[] is ok. */
+	return mddev->raid_disks + max(0, mddev->delta_disks);
+}
+
+static inline int calc_r10bio_size(struct mddev *mddev)
+{
+	return offsetof(struct r10bio, devs[calc_r10bio_pool_disks(mddev)]);
+}
+
+static mempool_t *create_r10bio_pool(struct mddev *mddev)
+{
+	int size = calc_r10bio_size(mddev);
+
+	return mempool_create_kmalloc_pool(NR_RAID_BIOS, size);
+}
+
+static struct r10bio *alloc_r10bio(struct mddev *mddev, gfp_t gfp_flags)
+{
+	int size = calc_r10bio_size(mddev);
 
-	/* allocate a r10bio with room for raid_disks entries in the
-	 * bios array */
 	return kzalloc(size, gfp_flags);
 }
 
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 /* amount of memory to reserve for resync requests */
@@ -135,11 +150,11 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	struct bio *bio;
 	int j;
 	int nalloc, nalloc_rp;
 	struct resync_pages *rps;
 
-	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
+	r10_bio = alloc_r10bio(conf->mddev, gfp_flags);
 	if (!r10_bio)
 		return NULL;
 
 	if (test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery) ||
 	    test_bit(MD_RECOVERY_RESHAPE, &conf->mddev->recovery))
@@ -275,11 +290,11 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 static void free_r10bio(struct r10bio *r10_bio)
 {
 	struct r10conf *conf = r10_bio->mddev->private;
 
 	put_all_bios(conf, r10_bio);
-	mempool_free(r10_bio, &conf->r10bio_pool);
+	mempool_free(r10_bio, conf->r10bio_pool);
 }
 
 static void put_buf(struct r10bio *r10_bio)
 {
 	struct r10conf *conf = r10_bio->mddev->private;
@@ -1537,11 +1552,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
 	r10_bio->sectors = sectors;
 
 	r10_bio->mddev = mddev;
@@ -1729,11 +1744,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		last_stripe_index *= geo->far_copies;
 	end_disk_offset = (bio_end & geo->chunk_mask) +
 				(last_stripe_index << geo->chunk_shift);
 
 retry_discard:
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
 	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
@@ -3830,11 +3845,11 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 static void raid10_free_conf(struct r10conf *conf)
 {
 	if (!conf)
 		return;
 
-	mempool_exit(&conf->r10bio_pool);
+	mempool_destroy(conf->r10bio_pool);
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
 	safe_put_page(conf->tmppage);
 	bioset_exit(&conf->bio_split);
@@ -3877,13 +3892,12 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	if (!conf->tmppage)
 		goto out;
 
 	conf->geo = geo;
 	conf->copies = copies;
-	err = mempool_init(&conf->r10bio_pool, NR_RAID_BIOS, r10bio_pool_alloc,
-			   rbio_pool_free, conf);
-	if (err)
+	conf->r10bio_pool = create_r10bio_pool(mddev);
+	if (!conf->r10bio_pool)
 		goto out;
 
 	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (err)
 		goto out;
@@ -4373,10 +4387,11 @@ static int raid10_start_reshape(struct mddev *mddev)
 	struct geom new;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
 	int spares = 0;
 	int ret;
+	mempool_t *new_pool;
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
 	if (setup_geo(&new, mddev, geo_start) != conf->copies)
@@ -4409,10 +4424,17 @@ static int raid10_start_reshape(struct mddev *mddev)
 
 	if (spares < mddev->delta_disks)
 		return -EINVAL;
 
 	conf->offset_diff = min_offset_diff;
+	if (mddev->delta_disks > 0) {
+		new_pool = create_r10bio_pool(mddev);
+		if (!new_pool)
+			return -ENOMEM;
+		mempool_destroy(conf->r10bio_pool);
+		conf->r10bio_pool = new_pool;
+	}
 	spin_lock_irq(&conf->device_lock);
 	if (conf->mirrors_new) {
 		memcpy(conf->mirrors_new, conf->mirrors,
 		       sizeof(struct raid10_info)*conf->prev.raid_disks);
 		smp_mb();
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index ec79d87fb92f..b711626a5db7 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -85,11 +85,11 @@ struct r10conf {
 	int			have_replacement; /* There is at least one
 						   * replacement device.
 						   */
 	wait_queue_head_t	wait_barrier;
 
-	mempool_t		r10bio_pool;
+	mempool_t		*r10bio_pool;
 	mempool_t		r10buf_pool;
 	struct page		*tmppage;
 	struct bio_set		bio_split;
 
 	/* When taking over an array from a different personality, we store
-- 
2.54.0
