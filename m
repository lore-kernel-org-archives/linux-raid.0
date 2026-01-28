Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE50E337B81;
	Wed, 28 Jan 2026 08:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587580; cv=none; b=ZlGWoG6X5tXmZ3ojCPZGjXSpZZbM1Ip5hu3qYdBJ33T2+e/0Dteogd7BwJ4MgsTIVFJXsR8rxvn8sxNOvos7OdOQJu5TmwIQ+1RnBUgcsi3zAYubd0/U/GCsOXnsv0JtgRskeJ7IThWR3NLJ8unnSrXdw0awcPJnH8VU+D8OcDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587580; c=relaxed/simple;
	bh=NH2nuKU/lF/0yIGYleLfgzoAlBVTO0Wk+yBBtj+0hsU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VIwaSrDHOZQWogcfhB7kwoZa8hYpE2nY5652oldin4u1icF6EnqK9aEp471/AdwpeWAEjI6jDcE+DX/275zLINtwEnsxBj+qFoyiq152E4i9aRAv/t8aEiyR7lLCnHUegwWwmqXI6wi1uY71tZLKwQGy7kkSbMHtUfG2zb4oHpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFY3NC0zYQv0Z;
	Wed, 28 Jan 2026 16:05:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 64F3340539;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S9;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 05/14] md/raid1,raid10: use folio for sync path IO
Date: Wed, 28 Jan 2026 15:56:59 +0800
Message-Id: <20260128075708.2259525-6-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260128075708.2259525-1-linan666@huaweicloud.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S9
X-Coremail-Antispam: 1UD129KBjvAXoWfCFWkJryxtr4DWF48WFyUJrb_yoW5AFy3Go
	Z3Jr4Sk3WrWr1rurWktr1xtFsrWan8Zw1fJF1xCrWqvFsruw15Kw47Jry5XrW2qF4aqF4a
	kr9agw1fXFZ2vr1xn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUOD7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s0DM28Irc
	Ia0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l
	84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJV
	WxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2
	IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWx
	Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2
	IErcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYVyIDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Convert all IO on the sync path to use folios. Rename page-related
identifiers to match folio.

Retain some now-unnecessary while and for loops to minimize code
changes, clean them up in a subsequent patch.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c       |   2 +-
 drivers/md/raid1-10.c |  60 ++++--------
 drivers/md/raid1.c    | 173 +++++++++++++++------------------
 drivers/md/raid10.c   | 219 +++++++++++++++++++-----------------------
 4 files changed, 196 insertions(+), 258 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b8c8a16cf037..5b42b157263d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9450,7 +9450,7 @@ static bool sync_io_within_limit(struct mddev *mddev)
 {
 	/*
 	 * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
-	 * RESYNC_PAGES(64k) per IO.
+	 * RESYNC_BLOCK_SIZE(64k) per IO.
 	 */
 	return atomic_read(&mddev->recovery_active) <
 	       (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 260d7fd7ccbe..300fbe9dc02e 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -25,9 +25,9 @@
 #define MAX_PLUG_BIO 32
 
 /* for managing resync I/O pages */
-struct resync_pages {
+struct resync_folio {
 	void		*raid_bio;
-	struct page	*pages[RESYNC_PAGES];
+	struct folio	*folio;
 };
 
 struct raid1_plug_cb {
@@ -41,77 +41,55 @@ static void rbio_pool_free(void *rbio, void *data)
 	kfree(rbio);
 }
 
-static inline int resync_alloc_pages(struct resync_pages *rp,
+static inline int resync_alloc_folio(struct resync_folio *rf,
 				     gfp_t gfp_flags)
 {
-	int i;
-
-	for (i = 0; i < RESYNC_PAGES; i++) {
-		rp->pages[i] = alloc_page(gfp_flags);
-		if (!rp->pages[i])
-			goto out_free;
-	}
+	rf->folio = folio_alloc(gfp_flags, get_order(RESYNC_BLOCK_SIZE));
+	if (!rf->folio)
+		return -ENOMEM;
 
 	return 0;
-
-out_free:
-	while (--i >= 0)
-		put_page(rp->pages[i]);
-	return -ENOMEM;
 }
 
-static inline void resync_free_pages(struct resync_pages *rp)
+static inline void resync_free_folio(struct resync_folio *rf)
 {
-	int i;
-
-	for (i = 0; i < RESYNC_PAGES; i++)
-		put_page(rp->pages[i]);
+	folio_put(rf->folio);
 }
 
-static inline void resync_get_all_pages(struct resync_pages *rp)
+static inline void resync_get_folio(struct resync_folio *rf)
 {
-	int i;
-
-	for (i = 0; i < RESYNC_PAGES; i++)
-		get_page(rp->pages[i]);
+	folio_get(rf->folio);
 }
 
-static inline struct page *resync_fetch_page(struct resync_pages *rp,
-					     unsigned idx)
+static inline struct folio *resync_fetch_folio(struct resync_folio *rf)
 {
-	if (WARN_ON_ONCE(idx >= RESYNC_PAGES))
-		return NULL;
-	return rp->pages[idx];
+	return rf->folio;
 }
 
 /*
- * 'strct resync_pages' stores actual pages used for doing the resync
+ * 'strct resync_folio' stores actual pages used for doing the resync
  *  IO, and it is per-bio, so make .bi_private points to it.
  */
-static inline struct resync_pages *get_resync_pages(struct bio *bio)
+static inline struct resync_folio *get_resync_folio(struct bio *bio)
 {
 	return bio->bi_private;
 }
 
 /* generally called after bio_reset() for reseting bvec */
-static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
+static void md_bio_reset_resync_folio(struct bio *bio, struct resync_folio *rf,
 			       int size)
 {
-	int idx = 0;
-
 	/* initialize bvec table again */
 	do {
-		struct page *page = resync_fetch_page(rp, idx);
-		int len = min_t(int, size, PAGE_SIZE);
+		struct folio *folio = resync_fetch_folio(rf);
+		int len = min_t(int, size, RESYNC_BLOCK_SIZE);
 
-		if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
+		if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
 			bio->bi_status = BLK_STS_RESOURCE;
 			bio_endio(bio);
 			return;
 		}
-
-		size -= len;
-	} while (idx++ < RESYNC_PAGES && size > 0);
+	} while (0);
 }
 
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 43453f1a04f4..d9c106529289 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -120,11 +120,11 @@ static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
 
 /*
  * for resync bio, r1bio pointer can be retrieved from the per-bio
- * 'struct resync_pages'.
+ * 'struct resync_folio'.
  */
 static inline struct r1bio *get_resync_r1bio(struct bio *bio)
 {
-	return get_resync_pages(bio)->raid_bio;
+	return get_resync_folio(bio)->raid_bio;
 }
 
 static void *r1bio_pool_alloc(gfp_t gfp_flags, struct r1conf *conf)
@@ -146,70 +146,69 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	struct r1conf *conf = data;
 	struct r1bio *r1_bio;
 	struct bio *bio;
-	int need_pages;
+	int need_folio;
 	int j;
-	struct resync_pages *rps;
+	struct resync_folio *rfs;
 
 	r1_bio = r1bio_pool_alloc(gfp_flags, conf);
 	if (!r1_bio)
 		return NULL;
 
-	rps = kmalloc_array(conf->raid_disks * 2, sizeof(struct resync_pages),
+	rfs = kmalloc_array(conf->raid_disks * 2, sizeof(struct resync_folio),
 			    gfp_flags);
-	if (!rps)
+	if (!rfs)
 		goto out_free_r1bio;
 
 	/*
 	 * Allocate bios : 1 for reading, n-1 for writing
 	 */
 	for (j = conf->raid_disks * 2; j-- ; ) {
-		bio = bio_kmalloc(RESYNC_PAGES, gfp_flags);
+		bio = bio_kmalloc(1, gfp_flags);
 		if (!bio)
 			goto out_free_bio;
-		bio_init_inline(bio, NULL, RESYNC_PAGES, 0);
+		bio_init_inline(bio, NULL, 1, 0);
 		r1_bio->bios[j] = bio;
 	}
 	/*
-	 * Allocate RESYNC_PAGES data pages and attach them to
-	 * the first bio.
+	 * Allocate data folio and attach it to the first bio.
 	 * If this is a user-requested check/repair, allocate
-	 * RESYNC_PAGES for each bio.
+	 * folio for each bio.
 	 */
 	if (test_bit(MD_RECOVERY_REQUESTED, &conf->mddev->recovery))
-		need_pages = conf->raid_disks * 2;
+		need_folio = conf->raid_disks * 2;
 	else
-		need_pages = 1;
+		need_folio = 1;
 	for (j = 0; j < conf->raid_disks * 2; j++) {
-		struct resync_pages *rp = &rps[j];
+		struct resync_folio *rf = &rfs[j];
 
 		bio = r1_bio->bios[j];
 
-		if (j < need_pages) {
-			if (resync_alloc_pages(rp, gfp_flags))
-				goto out_free_pages;
+		if (j < need_folio) {
+			if (resync_alloc_folio(rf, gfp_flags))
+				goto out_free_folio;
 		} else {
-			memcpy(rp, &rps[0], sizeof(*rp));
-			resync_get_all_pages(rp);
+			memcpy(rf, &rfs[0], sizeof(*rf));
+			resync_get_folio(rf);
 		}
 
-		rp->raid_bio = r1_bio;
-		bio->bi_private = rp;
+		rf->raid_bio = r1_bio;
+		bio->bi_private = rf;
 	}
 
 	r1_bio->master_bio = NULL;
 
 	return r1_bio;
 
-out_free_pages:
+out_free_folio:
 	while (--j >= 0)
-		resync_free_pages(&rps[j]);
+		resync_free_folio(&rfs[j]);
 
 out_free_bio:
 	while (++j < conf->raid_disks * 2) {
 		bio_uninit(r1_bio->bios[j]);
 		kfree(r1_bio->bios[j]);
 	}
-	kfree(rps);
+	kfree(rfs);
 
 out_free_r1bio:
 	rbio_pool_free(r1_bio, data);
@@ -221,17 +220,17 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 	struct r1conf *conf = data;
 	int i;
 	struct r1bio *r1bio = __r1_bio;
-	struct resync_pages *rp = NULL;
+	struct resync_folio *rf = NULL;
 
 	for (i = conf->raid_disks * 2; i--; ) {
-		rp = get_resync_pages(r1bio->bios[i]);
-		resync_free_pages(rp);
+		rf = get_resync_folio(r1bio->bios[i]);
+		resync_free_folio(rf);
 		bio_uninit(r1bio->bios[i]);
 		kfree(r1bio->bios[i]);
 	}
 
-	/* resync pages array stored in the 1st bio's .bi_private */
-	kfree(rp);
+	/* resync folio stored in the 1st bio's .bi_private */
+	kfree(rf);
 
 	rbio_pool_free(r1bio, data);
 }
@@ -2095,10 +2094,10 @@ static void end_sync_write(struct bio *bio)
 	put_sync_write_buf(r1_bio);
 }
 
-static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			   int sectors, struct page *page, blk_opf_t rw)
+static int r1_sync_folio_io(struct md_rdev *rdev, sector_t sector, int sectors,
+			    int off, struct folio *folio, blk_opf_t rw)
 {
-	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
+	if (sync_folio_io(rdev, sector, sectors << 9, off, folio, rw, false))
 		/* success */
 		return 1;
 	if (rw == REQ_OP_WRITE) {
@@ -2129,10 +2128,10 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
 	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
-	struct page **pages = get_resync_pages(bio)->pages;
+	struct folio *folio = get_resync_folio(bio)->folio;
 	sector_t sect = r1_bio->sector;
 	int sectors = r1_bio->sectors;
-	int idx = 0;
+	int off = 0;
 	struct md_rdev *rdev;
 
 	rdev = conf->mirrors[r1_bio->read_disk].rdev;
@@ -2162,9 +2161,8 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				 * active, and resync is currently active
 				 */
 				rdev = conf->mirrors[d].rdev;
-				if (sync_page_io(rdev, sect, s<<9,
-						 pages[idx],
-						 REQ_OP_READ, false)) {
+				if (sync_folio_io(rdev, sect, s<<9, off, folio,
+						  REQ_OP_READ, false)) {
 					success = 1;
 					break;
 				}
@@ -2197,7 +2195,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			/* Try next page */
 			sectors -= s;
 			sect += s;
-			idx++;
+			off += s << 9;
 			continue;
 		}
 
@@ -2210,8 +2208,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
-			if (r1_sync_page_io(rdev, sect, s,
-					    pages[idx],
+			if (r1_sync_folio_io(rdev, sect, s, off, folio,
 					    REQ_OP_WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
@@ -2225,14 +2222,13 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
-			if (r1_sync_page_io(rdev, sect, s,
-					    pages[idx],
+			if (r1_sync_folio_io(rdev, sect, s, off, folio,
 					    REQ_OP_READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
 		sect += s;
-		idx ++;
+		off += s << 9;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
 	bio->bi_status = 0;
@@ -2252,14 +2248,12 @@ static void process_checks(struct r1bio *r1_bio)
 	struct r1conf *conf = mddev->private;
 	int primary;
 	int i;
-	int vcnt;
 
 	/* Fix variable parts of all bios */
-	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		blk_status_t status;
 		struct bio *b = r1_bio->bios[i];
-		struct resync_pages *rp = get_resync_pages(b);
+		struct resync_folio *rf = get_resync_folio(b);
 		if (b->bi_end_io != end_sync_read)
 			continue;
 		/* fixup the bio for reuse, but preserve errno */
@@ -2269,11 +2263,11 @@ static void process_checks(struct r1bio *r1_bio)
 		b->bi_iter.bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		b->bi_end_io = end_sync_read;
-		rp->raid_bio = r1_bio;
-		b->bi_private = rp;
+		rf->raid_bio = r1_bio;
+		b->bi_private = rf;
 
 		/* initialize bvec table again */
-		md_bio_reset_resync_pages(b, rp, r1_bio->sectors << 9);
+		md_bio_reset_resync_folio(b, rf, r1_bio->sectors << 9);
 	}
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
@@ -2284,44 +2278,39 @@ static void process_checks(struct r1bio *r1_bio)
 		}
 	r1_bio->read_disk = primary;
 	for (i = 0; i < conf->raid_disks * 2; i++) {
-		int j = 0;
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
 		blk_status_t status = sbio->bi_status;
-		struct page **ppages = get_resync_pages(pbio)->pages;
-		struct page **spages = get_resync_pages(sbio)->pages;
-		struct bio_vec *bi;
-		int page_len[RESYNC_PAGES] = { 0 };
-		struct bvec_iter_all iter_all;
+		struct folio *pfolio = get_resync_folio(pbio)->folio;
+		struct folio *sfolio = get_resync_folio(sbio)->folio;
 
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
 		/* Now we can 'fixup' the error value */
 		sbio->bi_status = 0;
 
-		bio_for_each_segment_all(bi, sbio, iter_all)
-			page_len[j++] = bi->bv_len;
-
-		if (!status) {
-			for (j = vcnt; j-- ; ) {
-				if (memcmp(page_address(ppages[j]),
-					   page_address(spages[j]),
-					   page_len[j]))
-					break;
-			}
-		} else
-			j = 0;
-		if (j >= 0)
+		/*
+		 * Copy data and submit write in two cases:
+		 * - IO error (non-zero status)
+		 * - Data inconsistency and not a CHECK operation.
+		 */
+		if (status) {
 			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
-		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-			      && !status)) {
-			/* No need to write to this device. */
-			sbio->bi_end_io = NULL;
-			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
+			bio_copy_data(sbio, pbio);
 			continue;
+		} else if (memcmp(folio_address(pfolio),
+			folio_address(sfolio),
+			r1_bio->sectors << 9)) {
+			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
+			if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
+				bio_copy_data(sbio, pbio);
+				continue;
+			}
 		}
 
-		bio_copy_data(sbio, pbio);
+		/* No need to write to this device. */
+		sbio->bi_end_io = NULL;
+		rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 	}
 }
 
@@ -2446,9 +2435,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			if (rdev &&
 			    !test_bit(Faulty, &rdev->flags)) {
 				atomic_inc(&rdev->nr_pending);
-				r1_sync_page_io(rdev, sect, s,
-						folio_page(conf->tmpfolio, 0),
-						REQ_OP_WRITE);
+				r1_sync_folio_io(rdev, sect, s, 0,
+						conf->tmpfolio, REQ_OP_WRITE);
 				rdev_dec_pending(rdev, mddev);
 			}
 		}
@@ -2461,9 +2449,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			if (rdev &&
 			    !test_bit(Faulty, &rdev->flags)) {
 				atomic_inc(&rdev->nr_pending);
-				if (r1_sync_page_io(rdev, sect, s,
-						folio_page(conf->tmpfolio, 0),
-						REQ_OP_READ)) {
+				if (r1_sync_folio_io(rdev, sect, s, 0,
+						conf->tmpfolio, REQ_OP_READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
 						mdname(mddev), s,
@@ -2759,15 +2746,15 @@ static int init_resync(struct r1conf *conf)
 static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
 {
 	struct r1bio *r1bio = mempool_alloc(&conf->r1buf_pool, GFP_NOIO);
-	struct resync_pages *rps;
+	struct resync_folio *rfs;
 	struct bio *bio;
 	int i;
 
 	for (i = conf->raid_disks * 2; i--; ) {
 		bio = r1bio->bios[i];
-		rps = bio->bi_private;
+		rfs = bio->bi_private;
 		bio_reset(bio, NULL, 0);
-		bio->bi_private = rps;
+		bio->bi_private = rfs;
 	}
 	r1bio->master_bio = NULL;
 	return r1bio;
@@ -2799,7 +2786,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	int good_sectors = RESYNC_SECTORS;
 	int min_bad = 0; /* number of sectors that are bad in all devices */
 	int idx = sector_to_idx(sector_nr);
-	int page_idx = 0;
 
 	if (!mempool_initialized(&conf->r1buf_pool))
 		if (init_resync(conf))
@@ -3003,8 +2989,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	nr_sectors = 0;
 	sync_blocks = 0;
 	do {
-		struct page *page;
-		int len = PAGE_SIZE;
+		struct folio *folio;
+		int len = RESYNC_BLOCK_SIZE;
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
@@ -3020,24 +3006,19 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
-			struct resync_pages *rp;
+			struct resync_folio *rf;
 
 			bio = r1_bio->bios[i];
-			rp = get_resync_pages(bio);
+			rf = get_resync_folio(bio);
 			if (bio->bi_end_io) {
-				page = resync_fetch_page(rp, page_idx);
-
-				/*
-				 * won't fail because the vec table is big
-				 * enough to hold all these pages
-				 */
-				__bio_add_page(bio, page, len, 0);
+				folio = resync_fetch_folio(rf);
+				bio_add_folio_nofail(bio, folio, len, 0);
 			}
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
 		sync_blocks -= (len>>9);
-	} while (++page_idx < RESYNC_PAGES);
+	} while (0);
 
 	r1_bio->sectors = nr_sectors;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 09238dc9cde6..7533aeb23819 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -96,11 +96,11 @@ static void end_reshape(struct r10conf *conf);
 
 /*
  * for resync bio, r10bio pointer can be retrieved from the per-bio
- * 'struct resync_pages'.
+ * 'struct resync_folio'.
  */
 static inline struct r10bio *get_resync_r10bio(struct bio *bio)
 {
-	return get_resync_pages(bio)->raid_bio;
+	return get_resync_folio(bio)->raid_bio;
 }
 
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
@@ -133,8 +133,8 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	struct r10bio *r10_bio;
 	struct bio *bio;
 	int j;
-	int nalloc, nalloc_rp;
-	struct resync_pages *rps;
+	int nalloc, nalloc_rf;
+	struct resync_folio *rfs;
 
 	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
 	if (!r10_bio)
@@ -148,66 +148,65 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 	/* allocate once for all bios */
 	if (!conf->have_replacement)
-		nalloc_rp = nalloc;
+		nalloc_rf = nalloc;
 	else
-		nalloc_rp = nalloc * 2;
-	rps = kmalloc_array(nalloc_rp, sizeof(struct resync_pages), gfp_flags);
-	if (!rps)
+		nalloc_rf = nalloc * 2;
+	rfs = kmalloc_array(nalloc_rf, sizeof(struct resync_folio), gfp_flags);
+	if (!rfs)
 		goto out_free_r10bio;
 
 	/*
 	 * Allocate bios.
 	 */
 	for (j = nalloc ; j-- ; ) {
-		bio = bio_kmalloc(RESYNC_PAGES, gfp_flags);
+		bio = bio_kmalloc(1, gfp_flags);
 		if (!bio)
 			goto out_free_bio;
-		bio_init_inline(bio, NULL, RESYNC_PAGES, 0);
+		bio_init_inline(bio, NULL, 1, 0);
 		r10_bio->devs[j].bio = bio;
 		if (!conf->have_replacement)
 			continue;
-		bio = bio_kmalloc(RESYNC_PAGES, gfp_flags);
+		bio = bio_kmalloc(1, gfp_flags);
 		if (!bio)
 			goto out_free_bio;
-		bio_init_inline(bio, NULL, RESYNC_PAGES, 0);
+		bio_init_inline(bio, NULL, 1, 0);
 		r10_bio->devs[j].repl_bio = bio;
 	}
 	/*
-	 * Allocate RESYNC_PAGES data pages and attach them
-	 * where needed.
+	 * Allocate data folio and attach it where needed.
 	 */
 	for (j = 0; j < nalloc; j++) {
 		struct bio *rbio = r10_bio->devs[j].repl_bio;
-		struct resync_pages *rp, *rp_repl;
+		struct resync_folio *rf, *rf_repl;
 
-		rp = &rps[j];
+		rf = &rfs[j];
 		if (rbio)
-			rp_repl = &rps[nalloc + j];
+			rf_repl = &rfs[nalloc + j];
 
 		bio = r10_bio->devs[j].bio;
 
 		if (!j || test_bit(MD_RECOVERY_SYNC,
 				   &conf->mddev->recovery)) {
-			if (resync_alloc_pages(rp, gfp_flags))
-				goto out_free_pages;
+			if (resync_alloc_folio(rf, gfp_flags))
+				goto out_free_folio;
 		} else {
-			memcpy(rp, &rps[0], sizeof(*rp));
-			resync_get_all_pages(rp);
+			memcpy(rf, &rfs[0], sizeof(*rf));
+			resync_get_folio(rf);
 		}
 
-		rp->raid_bio = r10_bio;
-		bio->bi_private = rp;
+		rf->raid_bio = r10_bio;
+		bio->bi_private = rf;
 		if (rbio) {
-			memcpy(rp_repl, rp, sizeof(*rp));
-			rbio->bi_private = rp_repl;
+			memcpy(rf_repl, rf, sizeof(*rf));
+			rbio->bi_private = rf_repl;
 		}
 	}
 
 	return r10_bio;
 
-out_free_pages:
+out_free_folio:
 	while (--j >= 0)
-		resync_free_pages(&rps[j]);
+		resync_free_folio(&rfs[j]);
 
 	j = 0;
 out_free_bio:
@@ -219,7 +218,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 			bio_uninit(r10_bio->devs[j].repl_bio);
 		kfree(r10_bio->devs[j].repl_bio);
 	}
-	kfree(rps);
+	kfree(rfs);
 out_free_r10bio:
 	rbio_pool_free(r10_bio, conf);
 	return NULL;
@@ -230,14 +229,14 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 	struct r10conf *conf = data;
 	struct r10bio *r10bio = __r10_bio;
 	int j;
-	struct resync_pages *rp = NULL;
+	struct resync_folio *rf = NULL;
 
 	for (j = conf->copies; j--; ) {
 		struct bio *bio = r10bio->devs[j].bio;
 
 		if (bio) {
-			rp = get_resync_pages(bio);
-			resync_free_pages(rp);
+			rf = get_resync_folio(bio);
+			resync_free_folio(rf);
 			bio_uninit(bio);
 			kfree(bio);
 		}
@@ -250,7 +249,7 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 	}
 
 	/* resync pages array stored in the 1st bio's .bi_private */
-	kfree(rp);
+	kfree(rf);
 
 	rbio_pool_free(r10bio, conf);
 }
@@ -2342,8 +2341,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	struct r10conf *conf = mddev->private;
 	int i, first;
 	struct bio *tbio, *fbio;
-	int vcnt;
-	struct page **tpages, **fpages;
+	struct folio *tfolio, *ffolio;
 
 	atomic_set(&r10_bio->remaining, 1);
 
@@ -2359,14 +2357,13 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	fbio = r10_bio->devs[i].bio;
 	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
 	fbio->bi_iter.bi_idx = 0;
-	fpages = get_resync_pages(fbio)->pages;
+	ffolio = get_resync_folio(fbio)->folio;
 
-	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
-		int  j, d;
+		int  d;
 		struct md_rdev *rdev;
-		struct resync_pages *rp;
+		struct resync_folio *rf;
 
 		tbio = r10_bio->devs[i].bio;
 
@@ -2375,31 +2372,23 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		if (i == first)
 			continue;
 
-		tpages = get_resync_pages(tbio)->pages;
+		tfolio = get_resync_folio(tbio)->folio;
 		d = r10_bio->devs[i].devnum;
 		rdev = conf->mirrors[d].rdev;
 		if (!r10_bio->devs[i].bio->bi_status) {
 			/* We know that the bi_io_vec layout is the same for
 			 * both 'first' and 'i', so we just compare them.
-			 * All vec entries are PAGE_SIZE;
 			 */
-			int sectors = r10_bio->sectors;
-			for (j = 0; j < vcnt; j++) {
-				int len = PAGE_SIZE;
-				if (sectors < (len / 512))
-					len = sectors * 512;
-				if (memcmp(page_address(fpages[j]),
-					   page_address(tpages[j]),
-					   len))
-					break;
-				sectors -= len/512;
+			if (memcmp(folio_address(ffolio),
+				   folio_address(tfolio),
+				   r10_bio->sectors << 9)) {
+				atomic64_add(r10_bio->sectors,
+					     &mddev->resync_mismatches);
+				if (test_bit(MD_RECOVERY_CHECK,
+					     &mddev->recovery))
+					/* Don't fix anything. */
+					continue;
 			}
-			if (j == vcnt)
-				continue;
-			atomic64_add(r10_bio->sectors, &mddev->resync_mismatches);
-			if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
-				/* Don't fix anything. */
-				continue;
 		} else if (test_bit(FailFast, &rdev->flags)) {
 			/* Just give up on this device */
 			md_error(rdev->mddev, rdev);
@@ -2410,13 +2399,13 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		 * First we need to fixup bv_offset, bv_len and
 		 * bi_vecs, as the read request might have corrupted these
 		 */
-		rp = get_resync_pages(tbio);
+		rf = get_resync_folio(tbio);
 		bio_reset(tbio, conf->mirrors[d].rdev->bdev, REQ_OP_WRITE);
 
-		md_bio_reset_resync_pages(tbio, rp, fbio->bi_iter.bi_size);
+		md_bio_reset_resync_folio(tbio, rf, fbio->bi_iter.bi_size);
 
-		rp->raid_bio = r10_bio;
-		tbio->bi_private = rp;
+		rf->raid_bio = r10_bio;
+		tbio->bi_private = rf;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
 		tbio->bi_end_io = end_sync_write;
 
@@ -2476,10 +2465,9 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 	struct bio *bio = r10_bio->devs[0].bio;
 	sector_t sect = 0;
 	int sectors = r10_bio->sectors;
-	int idx = 0;
 	int dr = r10_bio->devs[0].devnum;
 	int dw = r10_bio->devs[1].devnum;
-	struct page **pages = get_resync_pages(bio)->pages;
+	struct folio *folio = get_resync_folio(bio)->folio;
 
 	while (sectors) {
 		int s = sectors;
@@ -2492,19 +2480,21 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 
 		rdev = conf->mirrors[dr].rdev;
 		addr = r10_bio->devs[0].addr + sect;
-		ok = sync_page_io(rdev,
-				  addr,
-				  s << 9,
-				  pages[idx],
-				  REQ_OP_READ, false);
+		ok = sync_folio_io(rdev,
+				   addr,
+				   s << 9,
+				   sect << 9,
+				   folio,
+				   REQ_OP_READ, false);
 		if (ok) {
 			rdev = conf->mirrors[dw].rdev;
 			addr = r10_bio->devs[1].addr + sect;
-			ok = sync_page_io(rdev,
-					  addr,
-					  s << 9,
-					  pages[idx],
-					  REQ_OP_WRITE, false);
+			ok = sync_folio_io(rdev,
+					   addr,
+					   s << 9,
+					   sect << 9,
+					   folio,
+					   REQ_OP_WRITE, false);
 			if (!ok) {
 				set_bit(WriteErrorSeen, &rdev->flags);
 				if (!test_and_set_bit(WantReplacement,
@@ -2539,7 +2529,6 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 
 		sectors -= s;
 		sect += s;
-		idx++;
 	}
 }
 
@@ -3068,7 +3057,7 @@ static int init_resync(struct r10conf *conf)
 static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
 {
 	struct r10bio *r10bio = mempool_alloc(&conf->r10buf_pool, GFP_NOIO);
-	struct rsync_pages *rp;
+	struct resync_folio *rf;
 	struct bio *bio;
 	int nalloc;
 	int i;
@@ -3081,14 +3070,14 @@ static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
 
 	for (i = 0; i < nalloc; i++) {
 		bio = r10bio->devs[i].bio;
-		rp = bio->bi_private;
+		rf = bio->bi_private;
 		bio_reset(bio, NULL, 0);
-		bio->bi_private = rp;
+		bio->bi_private = rf;
 		bio = r10bio->devs[i].repl_bio;
 		if (bio) {
-			rp = bio->bi_private;
+			rf = bio->bi_private;
 			bio_reset(bio, NULL, 0);
-			bio->bi_private = rp;
+			bio->bi_private = rf;
 		}
 	}
 	return r10bio;
@@ -3174,7 +3163,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	int max_sync = RESYNC_SECTORS;
 	sector_t sync_blocks;
 	sector_t chunk_mask = conf->geo.chunk_mask;
-	int page_idx = 0;
 
 	/*
 	 * Allow skipping a full rebuild for incremental assembly
@@ -3642,25 +3630,26 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	if (sector_nr + max_sync < max_sector)
 		max_sector = sector_nr + max_sync;
 	do {
-		struct page *page;
-		int len = PAGE_SIZE;
+		int len = RESYNC_BLOCK_SIZE;
+
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
-			struct resync_pages *rp = get_resync_pages(bio);
-			page = resync_fetch_page(rp, page_idx);
-			if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
+			struct resync_folio *rf = get_resync_folio(bio);
+			struct folio *folio = resync_fetch_folio(rf);
+
+			if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
 				bio->bi_status = BLK_STS_RESOURCE;
 				bio_endio(bio);
 				*skipped = 1;
-				return max_sync;
+				return len;
 			}
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
-	} while (++page_idx < RESYNC_PAGES);
+	} while (0);
 	r10_bio->sectors = nr_sectors;
 
 	if (mddev_is_clustered(mddev) &&
@@ -4578,7 +4567,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 				int *skipped)
 {
 	/* We simply copy at most one chunk (smallest of old and new)
-	 * at a time, possibly less if that exceeds RESYNC_PAGES,
+	 * at a time, possibly less if that exceeds RESYNC_BLOCK_SIZE,
 	 * or we hit a bad block or something.
 	 * This might mean we pause for normal IO in the middle of
 	 * a chunk, but that is not a problem as mddev->reshape_position
@@ -4618,14 +4607,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	struct r10bio *r10_bio;
 	sector_t next, safe, last;
 	int max_sectors;
-	int nr_sectors;
 	int s;
 	struct md_rdev *rdev;
 	int need_flush = 0;
 	struct bio *blist;
 	struct bio *bio, *read_bio;
 	int sectors_done = 0;
-	struct page **pages;
+	struct folio *folio;
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
@@ -4741,7 +4729,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		return sectors_done;
 	}
 
-	read_bio = bio_alloc_bioset(rdev->bdev, RESYNC_PAGES, REQ_OP_READ,
+	read_bio = bio_alloc_bioset(rdev->bdev, 1, REQ_OP_READ,
 				    GFP_KERNEL, &mddev->bio_set);
 	read_bio->bi_iter.bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
 			       + rdev->data_offset);
@@ -4805,32 +4793,23 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		blist = b;
 	}
 
-	/* Now add as many pages as possible to all of these bios. */
+	/* Now add folio to all of these bios. */
 
-	nr_sectors = 0;
-	pages = get_resync_pages(r10_bio->devs[0].bio)->pages;
-	for (s = 0 ; s < max_sectors; s += PAGE_SIZE >> 9) {
-		struct page *page = pages[s / (PAGE_SIZE >> 9)];
-		int len = (max_sectors - s) << 9;
-		if (len > PAGE_SIZE)
-			len = PAGE_SIZE;
-		for (bio = blist; bio ; bio = bio->bi_next) {
-			if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
-				bio->bi_status = BLK_STS_RESOURCE;
-				bio_endio(bio);
-				return sectors_done;
-			}
+	folio = get_resync_folio(r10_bio->devs[0].bio)->folio;
+	for (bio = blist; bio ; bio = bio->bi_next) {
+		if (WARN_ON(!bio_add_folio(bio, folio, max_sectors, 0))) {
+			bio->bi_status = BLK_STS_RESOURCE;
+			bio_endio(bio);
+			return sectors_done;
 		}
-		sector_nr += len >> 9;
-		nr_sectors += len >> 9;
 	}
-	r10_bio->sectors = nr_sectors;
+	r10_bio->sectors = max_sectors >> 9;
 
 	/* Now submit the read */
 	atomic_inc(&r10_bio->remaining);
 	read_bio->bi_next = NULL;
 	submit_bio_noacct(read_bio);
-	sectors_done += nr_sectors;
+	sectors_done += max_sectors;
 	if (sector_nr <= last)
 		goto read_more;
 
@@ -4932,8 +4911,8 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10b;
 	int slot = 0;
-	int idx = 0;
-	struct page **pages;
+	int sect = 0;
+	struct folio *folio;
 
 	r10b = kmalloc(struct_size(r10b, devs, conf->copies), GFP_NOIO);
 	if (!r10b) {
@@ -4941,8 +4920,8 @@ static int handle_reshape_read_error(struct mddev *mddev,
 		return -ENOMEM;
 	}
 
-	/* reshape IOs share pages from .devs[0].bio */
-	pages = get_resync_pages(r10_bio->devs[0].bio)->pages;
+	/* reshape IOs share folio from .devs[0].bio */
+	folio = get_resync_folio(r10_bio->devs[0].bio)->folio;
 
 	r10b->sector = r10_bio->sector;
 	__raid10_find_phys(&conf->prev, r10b);
@@ -4958,19 +4937,19 @@ static int handle_reshape_read_error(struct mddev *mddev,
 		while (!success) {
 			int d = r10b->devs[slot].devnum;
 			struct md_rdev *rdev = conf->mirrors[d].rdev;
-			sector_t addr;
 			if (rdev == NULL ||
 			    test_bit(Faulty, &rdev->flags) ||
 			    !test_bit(In_sync, &rdev->flags))
 				goto failed;
 
-			addr = r10b->devs[slot].addr + idx * PAGE_SIZE;
 			atomic_inc(&rdev->nr_pending);
-			success = sync_page_io(rdev,
-					       addr,
-					       s << 9,
-					       pages[idx],
-					       REQ_OP_READ, false);
+			success = sync_folio_io(rdev,
+						r10b->devs[slot].addr +
+						sect,
+						s << 9,
+						sect << 9,
+						folio,
+						REQ_OP_READ, false);
 			rdev_dec_pending(rdev, mddev);
 			if (success)
 				break;
@@ -4989,7 +4968,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			return -EIO;
 		}
 		sectors -= s;
-		idx++;
+		sect += s;
 	}
 	kfree(r10b);
 	return 0;
-- 
2.39.2

