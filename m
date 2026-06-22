Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D696E39A801
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782130423; cv=none; b=XzeI03wy/syMT3HAvhVHdNwXPBKhCCNkm4AVxEuRdtnkXFs2Rc3ACtjLs4nVUkzucn8/EoT8jw9YKaPOuls92MyBKNq6nhZjmdmqdbDycV7fGPJhydoi9in+NU75R9FdhLEtNHur6u7iSKJyiLRPfFXfq5MHUsLr4Dk6yWDcEbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782130423; c=relaxed/simple;
	bh=qwEUA7XDk8z3M5QHfsT6jwXVWZ86E0HnXh9RQusCIMw=;
	h=Cc:From:To:In-Reply-To:Content-Type:Subject:Mime-Version:
	 References:Date:Message-Id; b=IAJYnmVBDXqYnrOz6m7z5a25MUj/zkm3A9VVWDSp4f/7AieorfYIi4QWks7OYAoitfGA3uatozPzBW4EkhiQ8VhbBjNCRE0G0djB6GUiMMM2ggT13RsRNgzAwuoE4LTKRJZdxS8ddRkRNM2YFqy/CkPxWkf2+bxjCGqAmbswg/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=bK7d60dB; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="bK7d60dB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782130410;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=/DQJZQiJzelC15TCNmUo4ptzyXXKJA9yd/uuu97H8SQ=;
 b=bK7d60dB8BdL2W05TuhmWx7OSoXcUYY/NLUpphbMvPICJJjtICxAKM1UAvzrDDZsFKCfIw
 3DLVmV6c2ZaHDUuwUWnWU8m6XdkzqesiV6Y0BStJvK7V+wenv18vLmWShWKbTnWBFspJJ+
 OgphdFar+ty/htqxmWKuT0+dyWhaVgPIAdKXvZEQXr6oIlov6YRWnpesvs2MqnmDeb2uG4
 nwzOY7+1A1zlaFmw7yak7rZ0R4LhPl3PuYONJUtrEQ97BsbA077diD0h1eS681wcq6/IqA
 /fCSWJGy36xDBePutNE40bHZbR4P+bwNuj1mO3Zn9V+zA2puii1Qlg/S+RmavA==
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26a3926e8+1998a4+vger.kernel.org+chencheng@fnnas.com>
In-Reply-To: <20260622121312.1775322-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.54.0
Subject: [PATCH v5 2/3] md/raid10: resize r10bio_pool for reshape
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260622121312.1775322-1-chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 20:13:26 +0800
Date: Mon, 22 Jun 2026 20:13:11 +0800
Message-Id: <20260622121312.1775322-3-chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

When reshape changes raid_disks, the pool must also switch to new geometry
object size.

Allocate a new geometry size pool and replace the old.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 44 +++++++++++++++++++++++++++++++++-----------
 drivers/md/raid10.h |  2 +-
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cee5a253a281..d740744a9746 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -101,14 +101,25 @@ static void end_reshape(struct r10conf *conf);
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
+
+	return mempool_create_kmalloc_pool(NR_RAID_BIOS, size);
+}
+
+static struct r10bio *alloc_r10bio(unsigned int raid_disks, gfp_t gfp_flags)
+{
+	int size = calc_r10bio_size(raid_disks);
 
 	/* allocate a r10bio with room for raid_disks entries in the
 	 * bios array */
 	return kzalloc(size, gfp_flags);
 }
@@ -135,11 +146,11 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
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
@@ -275,11 +286,11 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
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
@@ -1537,11 +1548,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
 	r10_bio->sectors = sectors;
 
 	r10_bio->mddev = mddev;
@@ -1729,11 +1740,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
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
@@ -3830,11 +3841,11 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
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
@@ -3877,13 +3888,12 @@ static struct r10conf *setup_conf(struct mddev *mddev)
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
@@ -4373,10 +4383,11 @@ static int raid10_start_reshape(struct mddev *mddev)
 	struct geom new;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
 	int spares = 0;
 	int ret;
+	mempool_t *new_pool = NULL;
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
 	if (setup_geo(&new, mddev, geo_start) != conf->copies)
@@ -4409,10 +4420,15 @@ static int raid10_start_reshape(struct mddev *mddev)
 
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
@@ -4509,10 +4525,14 @@ static int raid10_start_reshape(struct mddev *mddev)
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
@@ -4531,10 +4551,12 @@ static int raid10_start_reshape(struct mddev *mddev)
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
