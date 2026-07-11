Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0922D358384
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 10:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764262; cv=none; b=PQbzyzCc1VJgvVW8nny0nWfbyMSgSXQWElKhWokKRhpFWhxBia530UY5G5L0NMC3G5UWDJpPLAgqaWFqiIefbEOqAwIqP2FYeduUyTZftlZyq6/nx5cFClNFZGyxXJx0llqRHAL5V8RsOE3h3OqqOrxcTh4Tfx6uvMspYquyT4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764262; c=relaxed/simple;
	bh=OkdnJ0d7xdGEvgkIP+6m7nFrO3UvDaoAn/l+lzOFzo8=;
	h=To:Cc:In-Reply-To:Subject:Date:Message-Id:Mime-Version:From:
	 Content-Type:References; b=AloO4CYMoyRQi75OUC6cn9Ti7bPW+Wi07h8moerWhyP2a5Gk+mff4kCnWINbAUKd8PMqdzg+E8pc+WNPnnyBRlt6iYmcodA9EPH/X/vB7MCLFVnpjefZ8pBdnI/LXj0omqA2UWkRbr+JeJuXfc4JMHQXB/wD7aQgMRmEfanwzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=dBUppYe5; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="dBUppYe5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783764252;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CZ4XJeXDz6R2be7oeLfzhGTSsj9mIXxjuuxV/Ds5cW4=;
 b=dBUppYe5j+ULiS1UkpToidDNhkUiFyB/CAaad7vaKYKFq5GG//jc0/j1g8tBMYg6pIndHF
 ETSAmfFZ4JFM/2VifOEiYYzi0KaFSvaUMiv3W6qINhItEQUGQG6zSTK/c+o+a3WHFDwIgR
 49GBHpb4DjWlplTxnQspwtdM+bj31qirlH28rZ7GuKQ5xVmTQcNO71AhHhZMBBEFNVs+YQ
 Nw0Iv2xM3R7hL2UHpQL5iMokgl7IrqlBEHboab6Y4oO2F1npktFIU4TpqSyvZns/UQsgmG
 /jRRKH5qwC3uRu/wNnW+1vEMxAU+B13WDIOGhJjIbD9p28hjJvY3vKJuoiwWOg==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260711100352.425177-1-chencheng@fnnas.com>
Subject: [PATCH v7 2/3] md/raid10: resize r10bio_pool for reshape
Date: Sat, 11 Jul 2026 18:03:51 +0800
Message-Id: <20260711100352.425177-3-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Chen Cheng" <chencheng@fnnas.com>
Received: from fedora ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 18:04:10 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: chencheng@fnnas.com
References: <20260711100352.425177-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a52151a+88a576+vger.kernel.org+chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

When reshape grows raid_disks, the pool must also switch to new geometry
object size , and allocate a new geometry size pool and replace the old.

But not for shrinking reshape, because regular I/O can still use the
prev geo for sectors that have not crossed reshape_progress yet.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++-------------
 drivers/md/raid10.h |  2 +-
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cee5a253a281..db68fcc9e9be 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -101,17 +101,27 @@ static void end_reshape(struct r10conf *conf);
 static inline struct r10bio *get_resync_r10bio(struct bio *bio)
 {
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
+static inline int calc_r10bio_size(unsigned int raid_disks)
 {
-	struct r10conf *conf = data;
-	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
+	return offsetof(struct r10bio, devs[raid_disks]);
+}
+
+static mempool_t *create_r10bio_pool(unsigned int raid_disks)
+{
+	int size = calc_r10bio_size(raid_disks);
 
-	/* allocate a r10bio with room for raid_disks entries in the
-	 * bios array */
+	return mempool_create_kmalloc_pool(NR_RAID_BIOS, size);
+}
+
+static struct r10bio *alloc_r10bio(unsigned int raid_disks, gfp_t gfp_flags)
+{
+	int size = calc_r10bio_size(raid_disks);
+
+	/* allocate a r10bio sized for current geometry */
 	return kzalloc(size, gfp_flags);
 }
 
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 /* amount of memory to reserve for resync requests */
@@ -135,11 +145,11 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	struct bio *bio;
 	int j;
 	int nalloc, nalloc_rp;
 	struct resync_pages *rps;
 
-	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
+	r10_bio = alloc_r10bio(conf->geo.raid_disks, gfp_flags);
 	if (!r10_bio)
 		return NULL;
 
 	if (test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery) ||
 	    test_bit(MD_RECOVERY_RESHAPE, &conf->mddev->recovery))
@@ -275,11 +285,11 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
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
@@ -1537,11 +1547,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
 	r10_bio->sectors = sectors;
 
 	r10_bio->mddev = mddev;
@@ -1729,11 +1739,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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
@@ -3830,11 +3840,11 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
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
@@ -3877,13 +3887,12 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	if (!conf->tmppage)
 		goto out;
 
 	conf->geo = geo;
 	conf->copies = copies;
-	err = mempool_init(&conf->r10bio_pool, NR_RAID_BIOS, r10bio_pool_alloc,
-			   rbio_pool_free, conf);
-	if (err)
+	conf->r10bio_pool = create_r10bio_pool(conf->geo.raid_disks);
+	if (!conf->r10bio_pool)
 		goto out;
 
 	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (err)
 		goto out;
@@ -4373,10 +4382,11 @@ static int raid10_start_reshape(struct mddev *mddev)
 	struct geom new;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
 	int spares = 0;
 	int ret;
+	mempool_t *new_pool = NULL;
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
 	if (setup_geo(&new, mddev, geo_start) != conf->copies)
@@ -4409,10 +4419,15 @@ static int raid10_start_reshape(struct mddev *mddev)
 
 	if (spares < mddev->delta_disks)
 		return -EINVAL;
 
 	conf->offset_diff = min_offset_diff;
+	if (mddev->delta_disks > 0) {
+		new_pool = create_r10bio_pool(new.raid_disks);
+		if (!new_pool)
+			return -ENOMEM;
+	}
 	spin_lock_irq(&conf->device_lock);
 	if (conf->mirrors_new) {
 		memcpy(conf->mirrors_new, conf->mirrors,
 		       sizeof(struct raid10_info)*conf->prev.raid_disks);
 		smp_mb();
@@ -4509,10 +4524,14 @@ static int raid10_start_reshape(struct mddev *mddev)
 	mddev->degraded = calc_degraded(conf);
 	spin_unlock_irq(&conf->device_lock);
 	mddev->raid_disks = conf->geo.raid_disks;
 	mddev->reshape_position = conf->reshape_progress;
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+	if (new_pool) {
+		mempool_destroy(conf->r10bio_pool);
+		conf->r10bio_pool = new_pool;
+	}
 
 	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
@@ -4531,10 +4550,12 @@ static int raid10_start_reshape(struct mddev *mddev)
 	smp_wmb();
 	conf->reshape_progress = MaxSector;
 	conf->reshape_safe = MaxSector;
 	mddev->reshape_position = MaxSector;
 	spin_unlock_irq(&conf->device_lock);
+	if (new_pool)
+		mempool_destroy(new_pool);
 	return ret;
 }
 
 /* Calculate the last device-address that could contain
  * any block from the chunk that includes the array-address 's'
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
