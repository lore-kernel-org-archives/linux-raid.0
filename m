Received: from sg-3-27.ptr.tlmpb.com (sg-3-27.ptr.tlmpb.com [101.45.255.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1FE3E3DBE
	for <linux-raid@vger.kernel.org>; Fri, 15 May 2026 09:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778837296; cv=none; b=EuyZBbydh7XfDR2kTv6kzu5jBgyO7gA+L7TIZ1MOOnb7VH/Bhs6HvgU1hw2M1mpY+FXL+ckQd3YAPzgPO6+11At6H/e0DEvsA/QH6lymES229yXY3nQvadn2TllBgN0Vpb3eio2xYD5bzq9qRW1E+woC0j+CJDMymynwtQMdC/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778837296; c=relaxed/simple;
	bh=XYnGiWsaN649d0/7XY25+jqzHGVQHN5Xjv2seepneMI=;
	h=To:From:Mime-Version:Cc:Message-Id:References:Content-Type:
	 Subject:Date:In-Reply-To; b=p3ILigxW8tk9ElMqWo04UhrRECePVH8DmYfkbmAaU3OwUkS3YMRN9sEjAv0TLRBswT8ertzciie7VJuZZiYzs4zUMqfz+9PBC62yaSaxUXWf18ap8/XVEwuTAoQ2Ys0NIDvtKf+e39Cb9RiX1Y3Iindlp0vN2hBcaiV+bmfTBdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=1gLItB+g; arc=none smtp.client-ip=101.45.255.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="1gLItB+g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1778837243;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8diOLyWpYEtCsYStK3Oq539ZHqPLb2+WJkzbvQI1Q+4=;
 b=1gLItB+gzyB9VFySHuxocxH88B8u4+bucH4LR9mtZZmuZ8behk4Q79H4U2VCtQMxaH9CKv
 nFse0oTOJtR5aa1OIZFIUbNsc74xzp/hMlG2dpr3XTYbjm8oOyniH+w3IZ/aJUTCIxXRcR
 +jLV7QMoXejzidBtMczRCkFZ0BFYemRiXUtsAjyER2ng2DolcRzk+4b4PyrNijV4MONCsP
 hP9D0ah/AG0/G4+H97OIUadn15SQqh/JL0WuXeSWARSEVAblbX8EOMzS+2G2CccDG74sYc
 dH7O10H5I1i2oEvvESNwKvdeKlSrDyDT47p5yzjlrmTLx1FZ8y4+hL7jDeBR7A==
To: "Yu Kuai" <yukuai@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Message-Id: <20260515092707.3436464-2-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
References: <20260515092707.3436464-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Received: from localhost.localdomain ([113.111.244.134]) by smtp.feishu.cn with ESMTPS; Fri, 15 May 2026 17:27:20 +0800
X-Lms-Return-Path: <lba+26a06e6f9+58670c+vger.kernel.org+chencheng@fnnas.com>
Subject: [PATCH v2 1/2] md/raid10: make r10bio_pool use fixed-size objects
Date: Fri, 15 May 2026 17:27:06 +0800
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515092707.3436464-1-chencheng@fnnas.com>

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

Because reshape updates live array state such as conf->mirrors, conf->geo,
reshape_progress, and reshape_safe, the geometry switch must happen only
after normal I/O has gone fully quiet. raise_barrier() alone is not strong
enough here: freeze_array() also marks that an array freeze is in progress,
flushes pending writes, and waits until in-flight I/O has either completed
or been queued.

Freeze the array before switching reshape geometry, rebuild r10bio_pool for
the new width inside that freeze window, and switch raid10_quiesce() to use
freeze_array()/unfreeze_array() as well. This keeps new requests from reusing
stale-width regular I/O objects after the geometry change.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 57 +++++++++++++++++++++++++++++++++------------
 drivers/md/raid10.h |  2 +-
 2 files changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 39085e7dd6d2..886bbe6b1ebc 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -103,13 +103,28 @@ static inline struct r10bio *get_resync_r10bio(struct bio *bio)
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
 
@@ -137,7 +152,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	int nalloc, nalloc_rp;
 	struct resync_pages *rps;
 
-	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
+	r10_bio = alloc_r10bio(conf->mddev, gfp_flags);
 	if (!r10_bio)
 		return NULL;
 
@@ -277,7 +292,7 @@ static void free_r10bio(struct r10bio *r10_bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 
 	put_all_bios(conf, r10_bio);
-	mempool_free(r10_bio, &conf->r10bio_pool);
+	mempool_free(r10_bio, conf->r10bio_pool);
 }
 
 static void put_buf(struct r10bio *r10_bio)
@@ -1531,7 +1546,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
 	r10_bio->sectors = sectors;
@@ -1723,7 +1738,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 				(last_stripe_index << geo->chunk_shift);
 
 retry_discard:
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
@@ -3823,7 +3838,7 @@ static void raid10_free_conf(struct r10conf *conf)
 	if (!conf)
 		return;
 
-	mempool_exit(&conf->r10bio_pool);
+	mempool_destroy(conf->r10bio_pool);
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
@@ -3870,9 +3885,8 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	conf->geo = geo;
 	conf->copies = copies;
-	err = mempool_init(&conf->r10bio_pool, NR_RAID_BIOS, r10bio_pool_alloc,
-			   rbio_pool_free, conf);
-	if (err)
+	conf->r10bio_pool = create_r10bio_pool(mddev);
+	if (!conf->r10bio_pool)
 		goto out;
 
 	err = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
@@ -4131,9 +4145,9 @@ static void raid10_quiesce(struct mddev *mddev, int quiesce)
 	struct r10conf *conf = mddev->private;
 
 	if (quiesce)
-		raise_barrier(conf, 0);
+		freeze_array(conf, 0);
 	else
-		lower_barrier(conf);
+		unfreeze_array(conf);
 }
 
 static int raid10_resize(struct mddev *mddev, sector_t sectors)
@@ -4365,6 +4379,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	struct md_rdev *rdev;
 	int spares = 0;
 	int ret;
+	mempool_t *new_pool;
 
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
@@ -4400,7 +4415,17 @@ static int raid10_start_reshape(struct mddev *mddev)
 	if (spares < mddev->delta_disks)
 		return -EINVAL;
 
+	freeze_array(conf, 0);
 	conf->offset_diff = min_offset_diff;
+	if (mddev->delta_disks > 0) {
+		new_pool = create_r10bio_pool(mddev);
+		if (!new_pool) {
+			unfreeze_array(conf);
+			return -ENOMEM;
+		}
+		mempool_destroy(conf->r10bio_pool);
+		conf->r10bio_pool = new_pool;
+	}
 	spin_lock_irq(&conf->device_lock);
 	if (conf->mirrors_new) {
 		memcpy(conf->mirrors_new, conf->mirrors,
@@ -4417,6 +4442,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		sector_t size = raid10_size(mddev, 0, 0);
 		if (size < mddev->array_sectors) {
 			spin_unlock_irq(&conf->device_lock);
+			unfreeze_array(conf);
 			pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
 				mdname(mddev));
 			return -EINVAL;
@@ -4427,6 +4453,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
 	spin_unlock_irq(&conf->device_lock);
+	unfreeze_array(conf);
 
 	if (mddev->delta_disks && mddev->bitmap) {
 		struct mdp_superblock_1 *sb = NULL;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index ec79d87fb92f..b711626a5db7 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -87,7 +87,7 @@ struct r10conf {
 						   */
 	wait_queue_head_t	wait_barrier;
 
-	mempool_t		r10bio_pool;
+	mempool_t		*r10bio_pool;
 	mempool_t		r10buf_pool;
 	struct page		*tmppage;
 	struct bio_set		bio_split;
-- 
2.54.0
