Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72162673B0
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 01:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779674149; cv=none; b=h/AF89SSPPAnGppMBd3T3cHG6RNPtP8IOoiEiO12+zDQ5wTsO0npK6f6Y+o4Mb8+yYp7LYOvNW9wxpokRUS7+exS9liwogkg9MyJn5/WnLD0l6uXv3YrL2o1HsxfdY2f+2cZX2SFTUmKeOHF39UDWv4rfIg5IbIcPJHlXatcXRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779674149; c=relaxed/simple;
	bh=j+P5RR25TjpmzCOmqCmil0swp/wB7oytipMPUcGp+/g=;
	h=Cc:Date:Mime-Version:Content-Type:To:From:Subject:Message-Id:
	 References:In-Reply-To; b=J635KvDKX4G2Dxek1YwEybEf3/PH6ut94mbvGBxVnDSyKGQ292bj1nzfXHuYI/p86YvHKsffK6heRsLvKYXKTGaiazto/qc+KNQF7OIIlb9EWX5NYUTy5lCOX4k4CscRwaRH750QGV7peoEdAVQd0FDD41RbBPv7Cm7yFD9C4Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=XaIk+TaX; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="XaIk+TaX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779674137;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+smOMbNrxZJFkl+/dG8EeZBhxjYpYu0uEADK96Q6rG4=;
 b=XaIk+TaXxfNJad2qPTVIssAm4RM3bRmFYxzelHjoi8eBoURI3sRepx2stldcaN0sHC+0Mw
 xTscU/JSulimAevfqIQR6U9UlxDRiykE+6/Z1wF/08QqYybROi5IRIFoaCJp7kNxVFGfRD
 u4o2r/Tpj1rD1AI97RqmYpNCcGb5S5GbB+jK50KnDhE1Tn6tcmKnZPcC1jCrEjDVnyeh0l
 ib1NaGHILUd3RGWoofZPlBnVxtGPLrSmApjXXdB9gCaWuurBJ8c/c6FTUVWjrPTJ9p2K6e
 5GYnIq1CGJ+F4VcngVzkdEvikN3eP8jDDBBw1ZG2eRCExkfle9P7XJPHEzE03w==
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Mon, 25 May 2026 09:55:19 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: chencheng@fnnas.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: "Yu Kuai" <yukuai@fnnas.com>, <linux-raid@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH v3 1/2] md/raid10: make r10bio_pool use fixed-size objects
Message-Id: <20260525015520.2565423-2-chencheng@fnnas.com>
References: <20260525015520.2565423-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a13ac17+228b09+vger.kernel.org+chencheng@fnnas.com>
In-Reply-To: <20260525015520.2565423-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Received: from localhost.localdomain ([113.111.141.72]) by smtp.feishu.cn with ESMTPS; Mon, 25 May 2026 09:55:34 +0800

From: Chen Cheng <chencheng@fnnas.com>

raid10 currently allocates r10bio_pool objects with conf->geo.raid_disks,
which makes regular r10bio objects geometry-dependent.

That model breaks down across reshape. mempool objects are preallocated and
reused, so a reshape that changes the number of raid disks can leave old
r10bio objects in the regular I/O pool with a devs[] array sized for the
previous geometry. After the geometry switch, those stale objects may be
reused or later freed under the new layout, creating a width mismatch
between the reused r10bio and the current array geometry.

For example, during a 4-disk to 5-disk reshape, an r10bio allocated before
the geometry switch has room for only 4 devs[] entries. After reshape
updates conf->geo.raid_disks to 5, that stale object can be reused under
the new geometry. Code such as __make_request(), put_all_bios(), and
find_bio_disk() may then access devs[] using the new geometry and step
past the end of the old 4-slot object, leading to slab out-of-bounds
accesses.

The root problem is that regular r10bio pool objects are geometry-dependent,
while mempool elements are preallocated and reused across requests.

Switch r10bio_pool to a fixed-size kmalloc mempool so regular I/O objects no
longer carry an allocation width tied to the current geometry. Use the same
fixed-size allocation rule for the standalone r10bio allocated from
r10buf_pool_alloc().

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 57 ++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid10.h |  2 +-
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 39085e7dd6d2..64677dbe5152 100644
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
@@ -1529,11 +1544,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
 	r10_bio->sectors = sectors;
 
 	r10_bio->mddev = mddev;
@@ -1721,11 +1736,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		last_stripe_index *= geo->far_copies;
 	end_disk_offset = (bio_end & geo->chunk_mask) +
 				(last_stripe_index << geo->chunk_shift);
 
 retry_discard:
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
@@ -3821,11 +3836,11 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
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
@@ -3868,13 +3883,12 @@ static struct r10conf *setup_conf(struct mddev *mddev)
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
@@ -4363,10 +4377,11 @@ static int raid10_start_reshape(struct mddev *mddev)
 	struct geom new;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
 	int spares = 0;
 	int ret;
+	mempool_t *new_pool;
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
 	if (setup_geo(&new, mddev, geo_start) != conf->copies)
@@ -4398,11 +4413,23 @@ static int raid10_start_reshape(struct mddev *mddev)
 		return -EINVAL;
 
 	if (spares < mddev->delta_disks)
 		return -EINVAL;
 
+	mddev_unlock(mddev);
+	mddev_suspend_and_lock_nointr(mddev);
 	conf->offset_diff = min_offset_diff;
+	if (mddev->delta_disks > 0) {
+		new_pool = create_r10bio_pool(mddev);
+		if (!new_pool) {
+			mddev_unlock_and_resume(mddev);
+			mddev_lock_nointr(mddev);
+			return -ENOMEM;
+		}
+		mempool_destroy(conf->r10bio_pool);
+		conf->r10bio_pool = new_pool;
+	}
 	spin_lock_irq(&conf->device_lock);
 	if (conf->mirrors_new) {
 		memcpy(conf->mirrors_new, conf->mirrors,
 		       sizeof(struct raid10_info)*conf->prev.raid_disks);
 		smp_mb();
@@ -4415,20 +4442,24 @@ static int raid10_start_reshape(struct mddev *mddev)
 	smp_mb();
 	if (mddev->reshape_backwards) {
 		sector_t size = raid10_size(mddev, 0, 0);
 		if (size < mddev->array_sectors) {
 			spin_unlock_irq(&conf->device_lock);
+			mddev_unlock_and_resume(mddev);
+			mddev_lock_nointr(mddev);
 			pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
 				mdname(mddev));
 			return -EINVAL;
 		}
 		mddev->resync_max_sectors = size;
 		conf->reshape_progress = size;
 	} else
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
 	spin_unlock_irq(&conf->device_lock);
+	mddev_unlock_and_resume(mddev);
+	mddev_lock_nointr(mddev);
 
 	if (mddev->delta_disks && mddev->bitmap) {
 		struct mdp_superblock_1 *sb = NULL;
 		sector_t oldsize, newsize;
 
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
