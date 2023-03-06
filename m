Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAB7C6FD1B
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjCFV3m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjCFV3G (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DC23CE38
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XpToghQSjgzSgXjyhKu5/BZhl8JK6+XRkcHTiVxJmIY=;
        b=YmK3zgeKWvVdXo9ikTB5lZBOI7VSizfA+U2/q19Qj/GpLWew5V0JQTYncunO5KcR1C3EKD
        8dYtYqMVdQOVtS4sRgLuR8TcQSj2WjLKzAWlFEi++WeyKVjG/MG2Shy1OOfIEN1wpHBB24
        NMX5S31O9YrAoFKPr50ig6HFaCLOnLQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-cGt7v6UnMJm-29e2V4zYaw-1; Mon, 06 Mar 2023 16:28:11 -0500
X-MC-Unique: cGt7v6UnMJm-29e2V4zYaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87A94100F914
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:11 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 859F740C83B6;
        Mon,  6 Mar 2023 21:28:10 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 12/34] md: add missing blank line after declaration [WARNING]
Date:   Mon,  6 Mar 2023 22:27:35 +0100
Message-Id: <aebc2c7b9d431fff0b4b214d430d72585d926186.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md-autodetect.c |  1 +
 drivers/md/md-bitmap.c     | 26 +++++++++++++++++
 drivers/md/md-cluster.c    |  7 +++++
 drivers/md/md-faulty.c     |  3 ++
 drivers/md/md-multipath.c  |  3 ++
 drivers/md/md.c            | 49 +++++++++++++++++++++++++++++++-
 drivers/md/raid0.c         |  1 +
 drivers/md/raid1.c         | 32 ++++++++++++++++++++-
 drivers/md/raid10.c        | 44 +++++++++++++++++++++++++++++
 drivers/md/raid5-cache.c   |  1 +
 drivers/md/raid5-ppl.c     |  1 +
 drivers/md/raid5.c         | 58 ++++++++++++++++++++++++++++++++++++--
 include/linux/raid/pq.h    |  1 +
 13 files changed, 222 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index e8acb3021094..ff60c2272919 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -235,6 +235,7 @@ static int __init raid_setup(char *str)
 	while (pos < len) {
 		char *comma = strchr(str+pos, ',');
 		int wlen;
+
 		if (comma)
 			wlen = (comma-str)-pos;
 		else
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index f2192aa8b826..3cee70340024 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -226,6 +226,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 
 		if (page->index == store->file_pages-1) {
 			int last_page_size = store->bytes & (PAGE_SIZE-1);
+
 			if (last_page_size == 0)
 				last_page_size = PAGE_SIZE;
 			size = roundup(last_page_size,
@@ -333,6 +334,7 @@ static void free_buffers(struct page *page)
 	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
+
 		free_buffer_head(bh);
 		bh = next;
 	}
@@ -849,6 +851,7 @@ static void md_bitmap_file_unmap(struct bitmap_storage *store)
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		fput(file);
 	}
@@ -1102,6 +1105,7 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 	for (i = 0; i < chunks; i++) {
 		int b;
+
 		index = file_page_index(&bitmap->storage, i);
 		bit = file_page_offset(&bitmap->storage, i);
 		if (index != oldindex) { /* this is a new page, read it in */
@@ -1198,6 +1202,7 @@ static void md_bitmap_count_page(struct bitmap_counts *bitmap,
 {
 	sector_t chunk = offset >> bitmap->chunkshift;
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
+
 	bitmap->bp[page].count += inc;
 	md_bitmap_checkfree(bitmap, page);
 }
@@ -1268,6 +1273,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 		/* Arrange for superblock update as well as
 		 * other changes */
 		bitmap_super_t *sb;
+
 		bitmap->need_sync = 0;
 		if (bitmap->storage.filemap) {
 			sb = kmap_atomic(bitmap->storage.sb_page);
@@ -1381,6 +1387,7 @@ __acquires(bitmap->lock)
 		/* should we use the first or second counter field
 		 * of the hijacked pointer? */
 		int hi = (pageoff > PAGE_COUNTER_MASK);
+
 		return  &((bitmap_counter_t *)
 			  &bitmap->bp[page].map)[hi];
 	} else /* page is allocated */
@@ -1395,6 +1402,7 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
 
 	if (behind) {
 		int bw;
+
 		atomic_inc(&bitmap->behind_writes);
 		bw = atomic_read(&bitmap->behind_writes);
 		if (bw > bitmap->behind_writes_used)
@@ -1510,6 +1518,7 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
 {
 	bitmap_counter_t *bmc;
 	int rv;
+
 	if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
 		*blocks = 1024;
 		return 1; /* always resync if no bitmap */
@@ -1596,6 +1605,7 @@ void md_bitmap_close_sync(struct bitmap *bitmap)
 	 */
 	sector_t sector = 0;
 	sector_t blocks;
+
 	if (!bitmap)
 		return;
 	while (sector < bitmap->mddev->resync_max_sectors) {
@@ -1665,6 +1675,7 @@ static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, in
 
 	sector_t secs;
 	bitmap_counter_t *bmc;
+
 	spin_lock_irq(&bitmap->counts.lock);
 	bmc = md_bitmap_get_counter(&bitmap->counts, offset, &secs, 1);
 	if (!bmc) {
@@ -1689,6 +1700,7 @@ void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long
 
 	for (chunk = s; chunk <= e; chunk++) {
 		sector_t sec = (sector_t)chunk << bitmap->counts.chunkshift;
+
 		md_bitmap_set_memory_bits(bitmap, sec, 1);
 		md_bitmap_file_set_bit(bitmap, sec);
 		if (sec < bitmap->mddev->recovery_cp)
@@ -1917,6 +1929,7 @@ int md_bitmap_load(struct mddev *mddev)
 	 */
 	while (sector < mddev->resync_max_sectors) {
 		sector_t blocks;
+
 		md_bitmap_start_sync(bitmap, sector, &blocks, 0);
 		sector += blocks;
 	}
@@ -2158,6 +2171,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	/* For cluster raid, need to pre-allocate bitmap */
 	if (mddev_is_clustered(bitmap->mddev)) {
 		unsigned long page;
+
 		for (page = 0; page < pages; page++) {
 			ret = md_bitmap_checkpage(&bitmap->counts, page, 1, 1);
 			if (ret) {
@@ -2219,6 +2233,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 	if (bitmap->counts.bp != old_counts.bp) {
 		unsigned long k;
+
 		for (k = 0; k < old_counts.pages; k++)
 			if (!old_counts.bp[k].hijacked)
 				kfree(old_counts.bp[k].map);
@@ -2227,8 +2242,10 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 	if (!init) {
 		int i;
+
 		while (block < (chunks << chunkshift)) {
 			bitmap_counter_t *bmc;
+
 			bmc = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
 			if (bmc) {
 				/* new space.  It needs to be resynced, so
@@ -2261,6 +2278,7 @@ static ssize_t
 location_show(struct mddev *mddev, char *page)
 {
 	ssize_t len;
+
 	if (mddev->bitmap_info.file)
 		len = sprintf(page, "file");
 	else if (mddev->bitmap_info.offset)
@@ -2305,12 +2323,14 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
+
 			mddev->bitmap_info.file = NULL;
 			fput(f);
 		}
 	} else {
 		/* No bitmap, OK to set a location */
 		long long offset;
+
 		if (strncmp(buf, "none", 4) == 0)
 			/* nothing to be done */;
 		else if (strncmp(buf, "file:", 5) == 0) {
@@ -2337,6 +2357,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev->bitmap_info.offset = offset;
 			if (mddev->pers) {
 				struct bitmap *bitmap;
+
 				bitmap = md_bitmap_create(mddev, -1);
 				mddev_suspend(mddev);
 				if (IS_ERR(bitmap))
@@ -2431,6 +2452,7 @@ timeout_store(struct mddev *mddev, const char *buf, size_t len)
 	/* timeout can be set at any time */
 	unsigned long timeout;
 	int rv = strict_strtoul_scaled(buf, &timeout, 4);
+
 	if (rv)
 		return rv;
 
@@ -2475,6 +2497,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	struct md_rdev *rdev;
 	bool has_write_mostly = false;
 	int rv = kstrtoul(buf, 10, &backlog);
+
 	if (rv)
 		return rv;
 	if (backlog > COUNTER_MAX)
@@ -2528,6 +2551,7 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	/* Can only be changed when no bitmap is active */
 	int rv;
 	unsigned long csize;
+
 	if (mddev->bitmap)
 		return -EBUSY;
 	rv = kstrtoul(buf, 10, &csize);
@@ -2576,6 +2600,7 @@ __ATTR(metadata, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 static ssize_t can_clear_show(struct mddev *mddev, char *page)
 {
 	int len;
+
 	spin_lock(&mddev->lock);
 	if (mddev->bitmap)
 		len = sprintf(page, "%s\n", (mddev->bitmap->need_sync ?
@@ -2608,6 +2633,7 @@ static ssize_t
 behind_writes_used_show(struct mddev *mddev, char *page)
 {
 	ssize_t ret;
+
 	spin_lock(&mddev->lock);
 	if (mddev->bitmap == NULL)
 		ret = sprintf(page, "0\n");
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 760b3ba37854..b61b1fba1c77 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -353,6 +353,7 @@ static void recover_prep(void *arg)
 {
 	struct mddev *mddev = arg;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+
 	set_bit(MD_CLUSTER_SUSPEND_READ_BALANCING, &cinfo->state);
 }
 
@@ -432,6 +433,7 @@ static void ack_bast(void *arg, int mode)
 static void remove_suspend_info(struct mddev *mddev, int slot)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+
 	mddev->pers->quiesce(mddev, 1);
 	spin_lock_irq(&cinfo->suspend_lock);
 	cinfo->suspend_hi = 0;
@@ -527,6 +529,7 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
 {
 	int got_lock = 0;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+
 	mddev->good_device_nr = le32_to_cpu(msg->raid_slot);
 
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
@@ -1099,6 +1102,7 @@ static int metadata_update_finish(struct mddev *mddev)
 static void metadata_update_cancel(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+
 	clear_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
 	unlock_comm(cinfo);
 }
@@ -1317,6 +1321,7 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 static int resync_start(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+
 	return dlm_lock_sync_interruptible(cinfo->resync_lockres, DLM_LOCK_EX, mddev);
 }
 
@@ -1448,6 +1453,7 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 static void add_new_disk_cancel(struct mddev *mddev)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+
 	clear_bit(MD_CLUSTER_SEND_LOCKED_ALREADY, &cinfo->state);
 	unlock_comm(cinfo);
 }
@@ -1471,6 +1477,7 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct cluster_msg cmsg = {0};
 	struct md_cluster_info *cinfo = mddev->cluster_info;
+
 	cmsg.type = cpu_to_le32(REMOVE);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
 	return sendmsg(cinfo, &cmsg, 1);
diff --git a/drivers/md/md-faulty.c b/drivers/md/md-faulty.c
index 7ac286e28fcb..d6dbca5edab8 100644
--- a/drivers/md/md-faulty.c
+++ b/drivers/md/md-faulty.c
@@ -101,6 +101,7 @@ static int check_sector(struct faulty_conf *conf, sector_t start, sector_t end,
 {
 	/* If we find a ReadFixable sector, we fix it ... */
 	int i;
+
 	for (i = 0; i < conf->nfaults; i++)
 		if (conf->faults[i] >= start &&
 		    conf->faults[i] < end) {
@@ -125,6 +126,7 @@ static void add_sector(struct faulty_conf *conf, sector_t start, int mode)
 {
 	int i;
 	int n = conf->nfaults;
+
 	for (i = 0; i < conf->nfaults; i++) {
 		if (conf->faults[i] == start) {
 			switch (mode) {
@@ -273,6 +275,7 @@ static int faulty_reshape(struct mddev *mddev)
 		conf->nfaults = 0;
 	else if (mode == ClearErrors) {
 		int i;
+
 		for (i = 0; i < Modes ; i++) {
 			conf->period[i] = 0;
 			atomic_set(&conf->counters[i], 0);
diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index dd180199479b..a26ed5a3643b 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -35,6 +35,7 @@ static int multipath_map (struct mpconf *conf)
 	rcu_read_lock();
 	for (i = 0; i < disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->multipaths[i].rdev);
+
 		if (rdev && test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
@@ -141,6 +142,7 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->multipaths[i].rdev);
+
 		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
@@ -169,6 +171,7 @@ static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 	 */
 	if (test_and_clear_bit(In_sync, &rdev->flags)) {
 		unsigned long flags;
+
 		spin_lock_irqsave(&conf->device_lock, flags);
 		mddev->degraded++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a48fbc80fc64..918565c03279 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -549,6 +549,7 @@ static void submit_flushes(struct work_struct *ws)
 			 * we reclaim rcu_read_lock
 			 */
 			struct bio *bi;
+
 			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
@@ -602,6 +603,7 @@ static void md_submit_flush_data(struct work_struct *ws)
 bool md_flush_request(struct mddev *mddev, struct bio *bio)
 {
 	ktime_t req_start = ktime_get_boottime();
+
 	spin_lock_irq(&mddev->lock);
 	/* flush requests wait until ongoing flush completes,
 	 * hence coalescing all the pending requests.
@@ -794,6 +796,7 @@ void mddev_unlock(struct mddev *mddev)
 		 * is seen.
 		 */
 		const struct attribute_group *to_remove = mddev->to_remove;
+
 		mddev->to_remove = NULL;
 		mddev->sysfs_active = 1;
 		mutex_unlock(&mddev->reconfig_mutex);
@@ -867,6 +870,7 @@ EXPORT_SYMBOL_GPL(md_find_rdev_rcu);
 static struct md_personality *find_pers(int level, char *clevel)
 {
 	struct md_personality *pers;
+
 	list_for_each_entry(pers, &pers_list, list) {
 		if (level != LEVEL_NONE && pers->level == level)
 			return pers;
@@ -1233,6 +1237,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
+
 		if (!md_uuid_equal(refsb, sb)) {
 			pr_warn("md: %pg has different UUID to %pg\n",
 				rdev->bdev, refdev->bdev);
@@ -1521,6 +1526,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 	/* now set the "removed" and "faulty" bits on any missing devices */
 	for (i = 0; i < mddev->raid_disks; i++) {
 		mdp_disk_t *d = &sb->disks[i];
+
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
 			d->raid_disk = i;
@@ -1702,6 +1708,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		__le64 *bbp;
 		int i;
 		int sectors = le16_to_cpu(sb->bblog_size);
+
 		if (sectors > (PAGE_SIZE / 512))
 			return -EINVAL;
 		offset = le32_to_cpu(sb->bblog_offset);
@@ -1717,6 +1724,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			u64 bb = le64_to_cpu(*bbp);
 			int count = bb & (0x3ff);
 			u64 sector = bb >> 10;
+
 			sector <<= sb->bblog_shift;
 			count <<= sb->bblog_shift;
 			if (bb + 1 == 0)
@@ -1901,6 +1909,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 	}
 	if (mddev->level != LEVEL_MULTIPATH) {
 		int role;
+
 		if (rdev->desc_nr < 0 ||
 		    rdev->desc_nr >= le32_to_cpu(sb->max_dev)) {
 			role = MD_DISK_ROLE_SPARE;
@@ -2051,6 +2060,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		struct badblocks *bb = &rdev->badblocks;
 		__le64 *bbp = (__le64 *)page_address(rdev->bb_page);
 		u64 *p = bb->page;
+
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
 		if (bb->changed) {
 			unsigned seq;
@@ -2083,6 +2093,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (max_dev > le32_to_cpu(sb->max_dev)) {
 		int bmask;
+
 		sb->max_dev = cpu_to_le32(max_dev);
 		rdev->sb_size = max_dev * 2 + 256;
 		bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;
@@ -2147,6 +2158,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 {
 	struct mdp_superblock_1 *sb;
 	sector_t max_sectors;
+
 	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
 		return 0; /* component must fit device */
 	if (rdev->data_offset != rdev->new_data_offset)
@@ -2198,6 +2210,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 {
 	/* All necessary checks on new >= old have been done */
 	struct bitmap *bitmap;
+
 	if (new_offset >= rdev->data_offset)
 		return 1;
 
@@ -2409,6 +2422,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	rcu_read_lock();
 	if (rdev->desc_nr < 0) {
 		int choice = 0;
+
 		if (mddev->pers)
 			choice = mddev->raid_disks;
 		while (md_find_rdev_nr_rcu(mddev, choice))
@@ -2465,6 +2479,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 static void rdev_delayed_delete(struct work_struct *ws)
 {
 	struct md_rdev *rdev = container_of(ws, struct md_rdev, del_work);
+
 	kobject_del(&rdev->kobj);
 	kobject_put(&rdev->kobj);
 }
@@ -2559,6 +2574,7 @@ static void sync_sbs(struct mddev *mddev, int nospares)
 	 * with the rest of the array)
 	 */
 	struct md_rdev *rdev;
+
 	rdev_for_each(rdev, mddev) {
 		if (rdev->sb_events == mddev->events ||
 		    (nospares &&
@@ -3216,6 +3232,7 @@ static ssize_t
 offset_store(struct md_rdev *rdev, const char *buf, size_t len)
 {
 	unsigned long long offset;
+
 	if (kstrtoull(buf, 10, &offset) < 0)
 		return -EINVAL;
 	if (rdev->mddev->pers && rdev->raid_disk >= 0)
@@ -3596,6 +3613,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 static void rdev_free(struct kobject *ko)
 {
 	struct md_rdev *rdev = container_of(ko, struct md_rdev, kobj);
+
 	kfree(rdev);
 }
 static const struct sysfs_ops rdev_sysfs_ops = {
@@ -3791,11 +3809,13 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
 {
 	unsigned long result = 0;
 	long decimals = -1;
+
 	while (isdigit(*cp) || (*cp == '.' && decimals < 0)) {
 		if (*cp == '.')
 			decimals = 0;
 		else if (decimals < scale) {
 			unsigned int value;
+
 			value = *cp - '0';
 			result = result * 10 + value;
 			if (decimals >= 0)
@@ -3817,6 +3837,7 @@ static ssize_t
 safe_delay_show(struct mddev *mddev, char *page)
 {
 	int msec = (mddev->safemode_delay*1000)/HZ;
+
 	return sprintf(page, "%d.%03d\n", msec/1000, msec%1000);
 }
 static ssize_t
@@ -3853,6 +3874,7 @@ level_show(struct mddev *mddev, char *page)
 {
 	struct md_personality *p;
 	int ret;
+
 	spin_lock(&mddev->lock);
 	p = mddev->pers;
 	if (p)
@@ -4320,6 +4342,7 @@ static char *array_states[] = {
 static int match_word(const char *word, char **list)
 {
 	int n;
+
 	for (n = 0; list[n]; n++)
 		if (cmd_match(word, list[n]))
 			break;
@@ -4718,6 +4741,7 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
 		size_t namelen = len-9;
+
 		if (namelen >= sizeof(mddev->metadata_type))
 			namelen = sizeof(mddev->metadata_type)-1;
 		strncpy(mddev->metadata_type, buf+9, namelen);
@@ -4759,6 +4783,7 @@ action_show(struct mddev *mddev, char *page)
 {
 	char *type = "idle";
 	unsigned long recovery = mddev->recovery;
+
 	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
 		type = "frozen";
 	else if (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
@@ -4824,6 +4849,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	} else if (cmd_match(page, "reshape")) {
 		int err;
+
 		if (mddev->pers->start_reshape == NULL)
 			return -EINVAL;
 		err = mddev_lock(mddev);
@@ -4981,6 +5007,7 @@ static ssize_t
 sync_speed_show(struct mddev *mddev, char *page)
 {
 	unsigned long resync, dt, db;
+
 	if (mddev->curr_resync == MD_RESYNC_NONE)
 		return sprintf(page, "none\n");
 	resync = mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active);
@@ -5067,6 +5094,7 @@ static ssize_t
 max_sync_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err;
+
 	spin_lock(&mddev->lock);
 	if (strncmp(buf, "max", 3) == 0)
 		mddev->resync_max = MaxSector;
@@ -5634,6 +5662,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		/* Need to ensure that 'name' is not a duplicate.
 		 */
 		struct mddev *mddev2;
+
 		spin_lock(&all_mddevs_lock);
 
 		list_for_each_entry(mddev2, &all_mddevs, all_mddevs)
@@ -6247,6 +6276,7 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
+
 	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
@@ -6409,6 +6439,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
+
 			spin_lock(&mddev->lock);
 			mddev->bitmap_info.file = NULL;
 			spin_unlock(&mddev->lock);
@@ -6472,6 +6503,7 @@ static void autorun_devices(int part)
 		int unit;
 		dev_t dev;
 		LIST_HEAD(candidates);
+
 		rdev0 = list_entry(pending_raid_disks.next,
 					 struct md_rdev, same_set);
 
@@ -6734,6 +6766,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 	 */
 	if (mddev->pers) {
 		int err;
+
 		if (!mddev->pers->hot_add_disk) {
 			pr_warn("%s: personality does not support diskops!\n",
 				mdname(mddev));
@@ -6851,6 +6884,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 
 	if (!(info->state & (1<<MD_DISK_FAULTY))) {
 		int err;
+
 		rdev = md_import_device(dev, -1, 0);
 		if (IS_ERR(rdev)) {
 			pr_warn("md: error, md_import_device() returned %ld\n",
@@ -7083,6 +7117,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	}
 	if (fd < 0) {
 		struct file *f = mddev->bitmap_info.file;
+
 		if (f) {
 			spin_lock(&mddev->lock);
 			mddev->bitmap_info.file = NULL;
@@ -7656,6 +7691,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		 */
 		if (mddev->pers) {
 			mdu_disk_info_t info;
+
 			if (copy_from_user(&info, argp, sizeof(info)))
 				err = -EFAULT;
 			else if (!(info.state & (1<<MD_DISK_SYNC)))
@@ -7697,6 +7733,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 	case ADD_NEW_DISK:
 	{
 		mdu_disk_info_t info;
+
 		if (copy_from_user(&info, argp, sizeof(info)))
 			err = -EFAULT;
 		else
@@ -8091,6 +8128,7 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	per_milli = res;
 	{
 		int i, x = per_milli/50, y = 20-x;
+
 		seq_printf(seq, "[");
 		for (i = 0; i < x; i++)
 			seq_printf(seq, "=");
@@ -8235,7 +8273,8 @@ static int md_seq_show(struct seq_file *seq, void *v)
 
 	if (v == (void *)1) {
 		struct md_personality *pers;
-		seq_printf(seq, "Personalities : ");
+
+		seq_puts(seq, "Personalities : ");
 		spin_lock(&pers_lock);
 		list_for_each_entry(pers, &pers_list, list)
 			seq_printf(seq, "[%s] ", pers->name);
@@ -8396,6 +8435,7 @@ int register_md_cluster_operations(struct md_cluster_operations *ops,
 				   struct module *module)
 {
 	int ret = 0;
+
 	spin_lock(&pers_lock);
 	if (md_cluster_ops != NULL)
 		ret = -EALREADY;
@@ -8420,6 +8460,7 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
 int md_setup_cluster(struct mddev *mddev, int nodes)
 {
 	int ret;
+
 	if (!md_cluster_ops)
 		request_module("md-cluster");
 	spin_lock(&pers_lock);
@@ -8455,6 +8496,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_disk;
+
 		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
 			      atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
@@ -8775,6 +8817,7 @@ void md_do_sync(struct md_thread *thread)
 
 	do {
 		int mddev2_minor = -1;
+
 		mddev->curr_resync = MD_RESYNC_DELAYED;
 
 	try_again:
@@ -8790,6 +8833,7 @@ void md_do_sync(struct md_thread *thread)
 			&&  mddev2->curr_resync
 			&&  match_mddev_units(mddev, mddev2)) {
 				DEFINE_WAIT(wq);
+
 				if (mddev < mddev2 &&
 				    mddev->curr_resync == MD_RESYNC_DELAYED) {
 					/* arbitrarily yield */
@@ -9316,6 +9360,7 @@ void md_check_recovery(struct mddev *mddev)
 
 		if (!md_is_rdwr(mddev)) {
 			struct md_rdev *rdev;
+
 			if (!mddev->external && mddev->in_sync)
 				/* 'Blocked' flag not needed as failed devices
 				 * will be recorded if array switched to read/write.
@@ -9545,6 +9590,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 {
 	struct mddev *mddev = rdev->mddev;
 	int rv;
+
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
@@ -9568,6 +9614,7 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 			 int is_new)
 {
 	int rv;
+
 	if (is_new)
 		s += rdev->new_data_offset;
 	else
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 11b9815f153d..73da2534da88 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -39,6 +39,7 @@ static void dump_zones(struct mddev *mddev)
 	sector_t zone_start = 0;
 	struct r0conf *conf = mddev->private;
 	int raid_disks = conf->strip_zone[0].nb_dev;
+
 	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
 		 mdname(mddev),
 		 conf->nr_strip_zones, conf->nr_strip_zones == 1 ? "" : "s");
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 809a46dbbaef..be86333104fe 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -244,6 +244,7 @@ static void put_all_bios(struct r1conf *conf, struct r1bio *r1_bio)
 
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct bio **bio = r1_bio->bios + i;
+
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
@@ -266,6 +267,7 @@ static void put_buf(struct r1bio *r1_bio)
 
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct bio *bio = r1_bio->bios[i];
+
 		if (bio->bi_end_io)
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
 	}
@@ -387,6 +389,7 @@ static void raid1_end_read_request(struct bio *bio)
 		 * Here we redefine "uptodate" to mean "Don't want to retry"
 		 */
 		unsigned long flags;
+
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (r1_bio->mddev->degraded == conf->raid_disks ||
 		    (r1_bio->mddev->degraded == conf->raid_disks-1 &&
@@ -541,6 +544,7 @@ static void raid1_end_write_request(struct bio *bio)
 			/* Maybe we can return now */
 			if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
 				struct bio *mbio = r1_bio->master_bio;
+
 				pr_debug("raid1: behind end write sectors"
 					 " %llu-%llu\n",
 					 (unsigned long long) mbio->bi_iter.bi_sector,
@@ -689,6 +693,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 
 			} else {
 				sector_t good_sectors = first_bad - this_sector;
+
 				if (good_sectors > best_good_sectors) {
 					best_good_sectors = good_sectors;
 					best_disk = disk;
@@ -800,6 +805,7 @@ static void flush_bio_list(struct r1conf *conf, struct bio *bio)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		struct md_rdev *rdev = (void *)bio->bi_bdev;
+
 		bio->bi_next = NULL;
 		bio_set_dev(bio, rdev->bdev);
 		if (test_bit(Faulty, &rdev->flags)) {
@@ -1237,6 +1243,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	if (r1bio_existed) {
 		/* Need to get the block device name carefully */
 		struct md_rdev *rdev;
+
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->mirrors[r1_bio->read_disk].rdev);
 		if (rdev)
@@ -1351,8 +1358,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
 		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
-
 		DEFINE_WAIT(w);
+
 		if (bio->bi_opf & REQ_NOWAIT) {
 			bio_wouldblock_error(bio);
 			return;
@@ -1460,6 +1467,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			}
 			if (is_bad) {
 				int good_sectors = first_bad - r1_bio->sector;
+
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -1517,6 +1525,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio = NULL;
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
+
 		if (!r1_bio->bios[i])
 			continue;
 
@@ -1632,6 +1641,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+
 		seq_printf(seq, "%s",
 			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
@@ -1704,6 +1714,7 @@ static void print_conf(struct r1conf *conf)
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+
 		if (rdev)
 			pr_debug(" disk %d, wo:%d, o:%d, dev:%pg\n",
 				 i, !test_bit(In_sync, &rdev->flags),
@@ -1743,6 +1754,7 @@ static int raid1_spare_active(struct mddev *mddev)
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
 		struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
+
 		if (repl
 		    && !test_bit(Candidate, &repl->flags)
 		    && repl->recovery_offset == MaxSector
@@ -2157,6 +2169,7 @@ static void process_checks(struct r1bio *r1_bio)
 		blk_status_t status;
 		struct bio *b = r1_bio->bios[i];
 		struct resync_pages *rp = get_resync_pages(b);
+
 		if (b->bi_end_io != end_sync_read)
 			continue;
 		/* fixup the bio for reuse, but preserve errno */
@@ -2279,6 +2292,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			   sector_t sect, int sectors)
 {
 	struct mddev *mddev = conf->mddev;
+
 	while (sectors) {
 		int s = sectors;
 		int d = read_disk;
@@ -2319,6 +2333,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		if (!success) {
 			/* Cannot read from anywhere - mark it bad */
 			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
+
 			if (!rdev_set_badblocks(rdev, sect, s, 0))
 				md_error(mddev, rdev);
 			break;
@@ -2405,6 +2420,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 
 	while (sect_to_write) {
 		struct bio *wbio;
+
 		if (sectors > sect_to_write)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors'*/
@@ -2443,9 +2459,11 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 {
 	int m;
 	int s = r1_bio->sectors;
+
 	for (m = 0; m < conf->raid_disks * 2 ; m++) {
 		struct md_rdev *rdev = conf->mirrors[m].rdev;
 		struct bio *bio = r1_bio->bios[m];
+
 		if (bio->bi_end_io == NULL)
 			continue;
 		if (!bio->bi_status &&
@@ -2470,6 +2488,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 	for (m = 0; m < conf->raid_disks * 2 ; m++)
 		if (r1_bio->bios[m] == IO_MADE_GOOD) {
 			struct md_rdev *rdev = conf->mirrors[m].rdev;
+
 			rdev_clear_badblocks(rdev,
 					     r1_bio->sector,
 					     r1_bio->sectors, 0);
@@ -2565,6 +2584,7 @@ static void raid1d(struct md_thread *thread)
 	if (!list_empty_careful(&conf->bio_end_io_list) &&
 	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		LIST_HEAD(tmp);
+
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 			list_splice_init(&conf->bio_end_io_list, &tmp);
@@ -2761,6 +2781,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct md_rdev *rdev;
+
 		bio = r1_bio->bios[i];
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
@@ -2831,9 +2852,11 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * need to mark them bad on all write targets
 		 */
 		int ok = 1;
+
 		for (i = 0 ; i < conf->raid_disks * 2 ; i++)
 			if (r1_bio->bios[i]->bi_end_io == end_sync_write) {
 				struct md_rdev *rdev = conf->mirrors[i].rdev;
+
 				ok = rdev_set_badblocks(rdev, sector_nr,
 							min_bad, 0
 					) && ok;
@@ -2870,6 +2893,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * drives must be failed - so we are finished
 		 */
 		sector_t rv;
+
 		if (min_bad > 0)
 			max_sector = sector_nr + min_bad;
 		rv = max_sector - sector_nr;
@@ -2887,6 +2911,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	do {
 		struct page *page;
 		int len = PAGE_SIZE;
+
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
@@ -3028,6 +3053,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	spin_lock_init(&conf->device_lock);
 	rdev_for_each(rdev, mddev) {
 		int disk_idx = rdev->raid_disk;
+
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
 			continue;
@@ -3221,11 +3247,13 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 	 * worth it.
 	 */
 	sector_t newsize = raid1_size(mddev, sectors, 0);
+
 	if (mddev->external_size &&
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 	if (mddev->bitmap) {
 		int ret = md_bitmap_resize(mddev->bitmap, newsize, 0, 0);
+
 		if (ret)
 			return ret;
 	}
@@ -3318,6 +3346,7 @@ static int raid1_reshape(struct mddev *mddev)
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
+
 		if (rdev && rdev->raid_disk != d2) {
 			sysfs_unlink_rdev(mddev, rdev);
 			rdev->raid_disk = d2;
@@ -3367,6 +3396,7 @@ static void *raid1_takeover(struct mddev *mddev)
 	 */
 	if (mddev->level == 5 && mddev->raid_disks == 2) {
 		struct r1conf *conf;
+
 		mddev->new_level = 1;
 		mddev->new_layout = 0;
 		mddev->new_chunk_sectors = 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8f3339e73f55..b9dbe22818bf 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -262,6 +262,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 
 	for (i = 0; i < conf->geo.raid_disks; i++) {
 		struct bio **bio = &r10_bio->devs[i].bio;
+
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
@@ -619,6 +620,7 @@ static void __raid10_find_phys(struct geom *geo, struct r10bio *r10bio)
 		int d = dev;
 		int set;
 		sector_t s = sector;
+
 		r10bio->devs[slot].devnum = d;
 		r10bio->devs[slot].addr = s;
 		slot++;
@@ -689,6 +691,7 @@ static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
 	offset = sector & geo->chunk_mask;
 	if (geo->far_offset) {
 		int fc;
+
 		chunk = sector >> geo->chunk_shift;
 		fc = sector_div(chunk, geo->far_copies);
 		dev -= fc * geo->near_copies;
@@ -910,6 +913,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		while (bio) { /* submit pending writes */
 			struct bio *next = bio->bi_next;
 			struct md_rdev *rdev = (void *)bio->bi_bdev;
+
 			bio->bi_next = NULL;
 			bio_set_dev(bio, rdev->bdev);
 			if (test_bit(Faulty, &rdev->flags)) {
@@ -1125,6 +1129,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	while (bio) { /* submit pending writes */
 		struct bio *next = bio->bi_next;
 		struct md_rdev *rdev = (void *)bio->bi_bdev;
+
 		bio->bi_next = NULL;
 		bio_set_dev(bio, rdev->bdev);
 		if (test_bit(Faulty, &rdev->flags)) {
@@ -1516,6 +1521,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			}
 			if (is_bad) {
 				int good_sectors = first_bad - dev_sector;
+
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
 			}
@@ -1845,6 +1851,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		 */
 		if (r10_bio->devs[disk].bio) {
 			struct md_rdev *rdev = conf->mirrors[disk].rdev;
+
 			mbio = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 			mbio->bi_end_io = raid10_end_discard_request;
@@ -1859,6 +1866,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		}
 		if (r10_bio->devs[disk].repl_bio) {
 			struct md_rdev *rrdev = conf->mirrors[disk].replacement;
+
 			rbio = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 			rbio->bi_end_io = raid10_end_discard_request;
@@ -1951,6 +1959,7 @@ static void raid10_status(struct seq_file *seq, struct mddev *mddev)
 	rcu_read_lock();
 	for (i = 0; i < conf->geo.raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+
 		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
@@ -1967,6 +1976,7 @@ static int _enough(struct r10conf *conf, int previous, int ignore)
 	int first = 0;
 	int has_enough = 0;
 	int disks, ncopies;
+
 	if (previous) {
 		disks = conf->prev.raid_disks;
 		ncopies = conf->prev.near_copies;
@@ -1980,8 +1990,10 @@ static int _enough(struct r10conf *conf, int previous, int ignore)
 		int n = conf->copies;
 		int cnt = 0;
 		int this = first;
+
 		while (n--) {
 			struct md_rdev *rdev;
+
 			if (this != ignore) {
 				rdev = rcu_dereference(conf->mirrors[this].rdev);
 				if (rdev && test_bit(In_sync, &rdev->flags))
@@ -2167,6 +2179,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		mirror = first;
 	for ( ; mirror <= last ; mirror++) {
 		struct raid10_info *p = &conf->mirrors[mirror];
+
 		if (p->recovery_disabled == mddev->recovery_disabled)
 			continue;
 		if (p->rdev) {
@@ -2318,6 +2331,7 @@ static void end_sync_request(struct r10bio *r10_bio)
 		if (r10_bio->master_bio == NULL) {
 			/* the primary of several recovery bios */
 			sector_t s = r10_bio->sectors;
+
 			if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
 			    test_bit(R10BIO_WriteError, &r10_bio->state))
 				reschedule_retry(r10_bio);
@@ -2327,6 +2341,7 @@ static void end_sync_request(struct r10bio *r10_bio)
 			break;
 		} else {
 			struct r10bio *r10_bio2 = (struct r10bio *)r10_bio->master_bio;
+
 			if (test_bit(R10BIO_MadeGood, &r10_bio->state) ||
 			    test_bit(R10BIO_WriteError, &r10_bio->state))
 				reschedule_retry(r10_bio);
@@ -2439,8 +2454,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			 * All vec entries are PAGE_SIZE;
 			 */
 			int sectors = r10_bio->sectors;
+
 			for (j = 0; j < vcnt; j++) {
 				int len = PAGE_SIZE;
+
 				if (sectors < (len / 512))
 					len = sectors * 512;
 				if (memcmp(page_address(fpages[j]),
@@ -2584,6 +2601,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 			if (rdev != conf->mirrors[dw].rdev) {
 				/* need bad block on destination too */
 				struct md_rdev *rdev2 = conf->mirrors[dw].rdev;
+
 				addr = r10_bio->devs[1].addr + sect;
 				ok = rdev_set_badblocks(rdev2, addr, s, 0);
 				if (!ok) {
@@ -2789,6 +2807,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			 * reads.
 			 */
 			int dn = r10_bio->devs[r10_bio->read_slot].devnum;
+
 			rdev = conf->mirrors[dn].rdev;
 
 			if (!rdev_set_badblocks(
@@ -2925,6 +2944,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 	while (sect_to_write) {
 		struct bio *wbio;
 		sector_t wsector;
+
 		if (sectors > sect_to_write)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors' */
@@ -2999,6 +3019,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 	    test_bit(R10BIO_IsRecover, &r10_bio->state)) {
 		for (m = 0; m < conf->copies; m++) {
 			int dev = r10_bio->devs[m].devnum;
+
 			rdev = conf->mirrors[dev].rdev;
 			if (r10_bio->devs[m].bio == NULL ||
 				r10_bio->devs[m].bio->bi_end_io == NULL)
@@ -3036,9 +3057,11 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 		put_buf(r10_bio);
 	} else {
 		bool fail = false;
+
 		for (m = 0; m < conf->copies; m++) {
 			int dev = r10_bio->devs[m].devnum;
 			struct bio *bio = r10_bio->devs[m].bio;
+
 			rdev = conf->mirrors[dev].rdev;
 			if (bio == IO_MADE_GOOD) {
 				rdev_clear_badblocks(
@@ -3099,6 +3122,7 @@ static void raid10d(struct md_thread *thread)
 	if (!list_empty_careful(&conf->bio_end_io_list) &&
 	    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		LIST_HEAD(tmp);
+
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 			while (!list_empty(&conf->bio_end_io_list)) {
@@ -3416,6 +3440,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		/* recovery... the complicated one */
 		int j;
+
 		r10_bio = NULL;
 
 		for (i = 0 ; i < conf->geo.raid_disks; i++) {
@@ -3521,6 +3546,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					rcu_dereference(conf->mirrors[d].rdev);
 				sector_t sector, first_bad;
 				int bad_sectors;
+
 				if (!rdev ||
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
@@ -3606,6 +3632,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					 * on other device(s)
 					 */
 					int k;
+
 					for (k = 0; k < conf->copies; k++)
 						if (r10_bio->devs[k].devnum == i)
 							break;
@@ -3649,8 +3676,10 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				 * readable copy.
 				 */
 				int targets = 1;
+
 				for (; j < conf->copies; j++) {
 					int d = r10_bio->devs[j].devnum;
+
 					if (conf->mirrors[d].rdev &&
 					    test_bit(In_sync,
 						      &conf->mirrors[d].rdev->flags))
@@ -3664,6 +3693,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (biolist == NULL) {
 			while (r10_bio) {
 				struct r10bio *rb2 = r10_bio;
+
 				r10_bio = (struct r10bio *) rb2->master_bio;
 				rb2->master_bio = NULL;
 				put_buf(rb2);
@@ -3778,6 +3808,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (count < 2) {
 			for (i = 0; i < conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;
+
 				if (r10_bio->devs[i].bio->bi_end_io)
 					rdev_dec_pending(conf->mirrors[d].rdev,
 							 mddev);
@@ -3799,12 +3830,14 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	do {
 		struct page *page;
 		int len = PAGE_SIZE;
+
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
 		for (bio = biolist; bio; bio = bio->bi_next) {
 			struct resync_pages *rp = get_resync_pages(bio);
+
 			page = resync_fetch_page(rp, page_idx);
 			/*
 			 * won't fail because the vec table is big enough
@@ -3954,6 +3987,7 @@ static int setup_geo(struct geom *geo, struct mddev *mddev, enum geo_type new)
 {
 	int nc, fc, fo;
 	int layout, chunk, disks;
+
 	switch (new) {
 	case geo_old:
 		layout = mddev->layout;
@@ -4347,6 +4381,7 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 		return -EINVAL;
 	if (mddev->bitmap) {
 		int ret = md_bitmap_resize(mddev->bitmap, size, 0, 0);
+
 		if (ret)
 			return ret;
 	}
@@ -4493,6 +4528,7 @@ static int calc_degraded(struct r10conf *conf)
 	/* 'prev' section first */
 	for (i = 0; i < conf->prev.raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+
 		if (!rdev || test_bit(Faulty, &rdev->flags))
 			degraded++;
 		else if (!test_bit(In_sync, &rdev->flags))
@@ -4509,6 +4545,7 @@ static int calc_degraded(struct r10conf *conf)
 	degraded2 = 0;
 	for (i = 0; i < conf->geo.raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
+
 		if (!rdev || test_bit(Faulty, &rdev->flags))
 			degraded2++;
 		else if (!test_bit(In_sync, &rdev->flags)) {
@@ -4597,6 +4634,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	smp_mb();
 	if (mddev->reshape_backwards) {
 		sector_t size = raid10_size(mddev, 0, 0);
+
 		if (size < mddev->array_sectors) {
 			spin_unlock_irq(&conf->device_lock);
 			pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
@@ -4958,6 +4996,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		struct bio *b;
 		int d = r10_bio->devs[s/2].devnum;
 		struct md_rdev *rdev2;
+
 		if (s&1) {
 			rdev2 = rcu_dereference(conf->mirrors[d].replacement);
 			b = r10_bio->devs[s/2].repl_bio;
@@ -4984,6 +5023,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	for (s = 0 ; s < max_sectors; s += PAGE_SIZE >> 9) {
 		struct page *page = pages[s / (PAGE_SIZE >> 9)];
 		int len = (max_sectors - s) << 9;
+
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
 		for (bio = blist; bio ; bio = bio->bi_next) {
@@ -5049,6 +5089,7 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		struct bio *b;
 		int d = r10_bio->devs[s/2].devnum;
 		struct md_rdev *rdev;
+
 		rcu_read_lock();
 		if (s&1) {
 			rdev = rcu_dereference(conf->mirrors[d].replacement);
@@ -5138,6 +5179,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			int d = r10b->devs[slot].devnum;
 			struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
 			sector_t addr;
+
 			if (rdev == NULL ||
 			    test_bit(Faulty, &rdev->flags) ||
 			    !test_bit(In_sync, &rdev->flags))
@@ -5228,11 +5270,13 @@ static void raid10_finish_reshape(struct mddev *mddev)
 		mddev->resync_max_sectors = mddev->array_sectors;
 	} else {
 		int d;
+
 		rcu_read_lock();
 		for (d = conf->geo.raid_disks ;
 		     d < conf->geo.raid_disks - mddev->delta_disks;
 		     d++) {
 			struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
+
 			if (rdev)
 				clear_bit(In_sync, &rdev->flags);
 			rdev = rcu_dereference(conf->mirrors[d].replacement);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 46182b955aef..123cc38d4a02 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2148,6 +2148,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 			}
 			if (!sh) {
 				int new_size = conf->min_nr_stripes * 2;
+
 				pr_debug("md/raid:%s: Increasing stripe cache size to %d to recovery data on journal.\n",
 					mdname(mddev),
 					new_size);
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index e495939bb3e0..3ba595ec6ad8 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -182,6 +182,7 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 		/* rcw: xor data from all not updated disks */
 		for (i = disks; i--;) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (test_bit(R5_UPTODATE, &dev->flags))
 				srcs[count++] = dev->page;
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4bdfbe1f8fcf..fb18598e81d3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -73,6 +73,7 @@ static struct workqueue_struct *raid5_wq;
 static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 {
 	int hash = (sect >> RAID5_STRIPE_SHIFT(conf)) & HASH_MASK;
+
 	return &conf->stripe_hashtbl[hash];
 }
 
@@ -99,6 +100,7 @@ static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
 	__acquires(&conf->device_lock)
 {
 	int i;
+
 	spin_lock_irq(conf->hash_locks);
 	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
 		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
@@ -109,6 +111,7 @@ static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
 	__releases(&conf->device_lock)
 {
 	int i;
+
 	spin_unlock(&conf->device_lock);
 	for (i = NR_STRIPE_HASH_LOCKS - 1; i; i--)
 		spin_unlock(conf->hash_locks + i);
@@ -185,6 +188,7 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
 
 	if (list_empty(&sh->lru)) {
 		struct r5worker_group *group;
+
 		group = conf->worker_groups + cpu_to_group(cpu);
 		if (stripe_is_lowprio(sh))
 			list_add_tail(&sh->lru, &group->loprio_list);
@@ -697,6 +701,7 @@ int raid5_calc_degraded(struct r5conf *conf)
 	degraded = 0;
 	for (i = 0; i < conf->previous_raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
+
 		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = rcu_dereference(conf->disks[i].replacement);
 		if (!rdev || test_bit(Faulty, &rdev->flags))
@@ -723,6 +728,7 @@ int raid5_calc_degraded(struct r5conf *conf)
 	degraded2 = 0;
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
+
 		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = rcu_dereference(conf->disks[i].replacement);
 		if (!rdev || test_bit(Faulty, &rdev->flags))
@@ -986,6 +992,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
+
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
 		    sh->batch_head->bm_seq > seq)
 			seq = sh->batch_head->bm_seq;
@@ -1490,8 +1497,10 @@ static void ops_run_biofill(struct stripe_head *sh)
 
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
+
 			spin_lock_irq(&sh->stripe_lock);
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
@@ -2088,6 +2097,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (head_sh->dev[i].written ||
 			    test_bit(R5_InJournal, &head_sh->dev[i].flags)) {
 				off_srcs[count] = dev->offset;
@@ -2099,6 +2109,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		off_dest = sh->dev[pd_idx].offset;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (i != pd_idx) {
 				off_srcs[count] = dev->offset;
 				xor_srcs[count++] = dev->page;
@@ -2345,6 +2356,7 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	if (overlap_clear && !sh->batch_head) {
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&sh->raid_conf->wait_for_overlap);
 		}
@@ -2679,6 +2691,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		for (i = conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
 				struct page *p = alloc_page(GFP_NOIO);
+
 				nsh->dev[i].page = p;
 				nsh->dev[i].orig_page = p;
 				nsh->dev[i].offset = 0;
@@ -2957,6 +2970,7 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
 	unsigned long flags;
+
 	pr_debug("raid456: error called\n");
 
 	pr_crit("md/raid:%s: Disk failure on %pg, disabling device.\n",
@@ -3428,6 +3442,7 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (i == pd_idx || i == qd_idx)
 				continue;
 
@@ -3570,6 +3585,7 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
+
 		for (bi = sh->dev[dd_idx].towrite;
 		     sector < sh->dev[dd_idx].sector + RAID5_STRIPE_SECTORS(conf) &&
 			     bi && bi->bi_iter.bi_sector <= sector;
@@ -3656,13 +3672,16 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		     struct stripe_head_state *s, int disks)
 {
 	int i;
+
 	BUG_ON(sh->batch_head);
+
 	for (i = disks; i--; ) {
 		struct bio *bi;
 		int bitmap_end = 0;
 
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			struct md_rdev *rdev;
+
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->disks[i].rdev);
 			if (rdev && test_bit(In_sync, &rdev->flags) &&
@@ -3792,6 +3811,7 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 		rcu_read_lock();
 		for (i = 0; i < conf->raid_disks; i++) {
 			struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
+
 			if (rdev
 			    && !test_bit(Faulty, &rdev->flags)
 			    && !test_bit(In_sync, &rdev->flags)
@@ -3989,6 +4009,7 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 			 * do it if failed >= 2
 			 */
 			int other;
+
 			for (other = disks; other--; ) {
 				if (other == disk_idx)
 					continue;
@@ -4083,6 +4104,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 			     test_bit(R5_SkipCopy, &dev->flags))) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
+
 				pr_debug("Return write for disc %d\n", i);
 				if (test_and_clear_bit(R5_Discard, &dev->flags))
 					clear_bit(R5_UPTODATE, &dev->flags);
@@ -4126,6 +4148,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
 		int hash;
+
 		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
 		clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
 		if (sh->qd_idx >= 0) {
@@ -4209,6 +4232,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 		for (i = disks; i--; ) {
 			/* would I have to read this buffer for read_modify_write */
 			struct r5dev *dev = &sh->dev[i];
+
 			if (((dev->towrite && !delay_towrite(conf, dev, s)) ||
 			     i == sh->pd_idx || i == sh->qd_idx ||
 			     test_bit(R5_InJournal, &dev->flags)) &&
@@ -4246,6 +4270,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (test_bit(R5_InJournal, &dev->flags) &&
 			    dev->page == dev->orig_page &&
 			    !test_bit(R5_LOCKED, &sh->dev[sh->pd_idx].flags)) {
@@ -4276,6 +4301,7 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (((dev->towrite && !delay_towrite(conf, dev, s)) ||
 			     i == sh->pd_idx || i == sh->qd_idx ||
 			     test_bit(R5_InJournal, &dev->flags)) &&
@@ -4298,9 +4324,11 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 	if ((rcw < rmw || (rcw == rmw && conf->rmw_level != PARITY_PREFER_RMW)) && rcw > 0) {
 		/* want reconstruct write, but need to get some data */
 		int qread = 0;
+
 		rcw = 0;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
 			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
@@ -4620,11 +4648,11 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 {
 	int i;
-
 	/* We have read all the blocks in this stripe and now we need to
 	 * copy some of them into a target stripe for expand.
 	 */
 	struct dma_async_tx_descriptor *tx = NULL;
+
 	BUG_ON(sh->batch_head);
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
@@ -4892,6 +4920,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 static int clear_batch_ready(struct stripe_head *sh)
 {
 	struct stripe_head *tmp;
+
 	if (!test_and_clear_bit(STRIPE_BATCH_READY, &sh->state))
 		return (sh->batch_head && sh->batch_head != sh);
 	spin_lock(&sh->stripe_lock);
@@ -5107,6 +5136,7 @@ static void handle_stripe(struct stripe_head *sh)
 		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (test_bit(R5_LOCKED, &dev->flags) &&
 				(i == sh->pd_idx || i == sh->qd_idx ||
 				 dev->written || test_bit(R5_InJournal,
@@ -5256,6 +5286,7 @@ static void handle_stripe(struct stripe_head *sh)
 	if (s.failed <= conf->max_degraded && !conf->mddev->ro)
 		for (i = 0; i < s.failed; i++) {
 			struct r5dev *dev = &sh->dev[s.failed_num[i]];
+
 			if (test_bit(R5_ReadError, &dev->flags)
 			    && !test_bit(R5_LOCKED, &dev->flags)
 			    && test_bit(R5_UPTODATE, &dev->flags)
@@ -5337,6 +5368,7 @@ static void handle_stripe(struct stripe_head *sh)
 		for (i = disks; i--; ) {
 			struct md_rdev *rdev;
 			struct r5dev *dev = &sh->dev[i];
+
 			if (test_and_clear_bit(R5_WriteError, &dev->flags)) {
 				/* We own a safe reference to the rdev */
 				rdev = rdev_pend_deref(conf->disks[i].rdev);
@@ -5387,8 +5419,8 @@ static void raid5_activate_delayed(struct r5conf *conf)
 	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
 		while (!list_empty(&conf->delayed_list)) {
 			struct list_head *l = conf->delayed_list.next;
-			struct stripe_head *sh;
-			sh = list_entry(l, struct stripe_head, lru);
+			struct stripe_head *sh = list_entry(l, struct stripe_head, lru);
+
 			list_del_init(l);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
@@ -5404,11 +5436,13 @@ static void activate_bit_delay(struct r5conf *conf,
 	__must_hold(&conf->device_lock)
 {
 	struct list_head head;
+
 	list_add(&head, &conf->bitmap_list);
 	list_del_init(&conf->bitmap_list);
 	while (!list_empty(&head)) {
 		struct stripe_head *sh = list_entry(head.next, struct stripe_head, lru);
 		int hash;
+
 		list_del_init(&sh->lru);
 		atomic_inc(&sh->count);
 		hash = sh->hash_lock_index;
@@ -5603,6 +5637,7 @@ static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
 
 	if (sectors < bio_sectors(raid_bio)) {
 		struct r5conf *conf = mddev->private;
+
 		split = bio_split(raid_bio, sectors, GFP_NOIO, &conf->bio_split);
 		bio_chain(split, raid_bio);
 		submit_bio_noacct(raid_bio);
@@ -5648,6 +5683,7 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 		wg = &conf->worker_groups[group];
 	} else {
 		int i;
+
 		for (i = 0; i < conf->group_cnt; i++) {
 			handle_list = try_loprio ? &conf->worker_groups[i].loprio_list :
 				&conf->worker_groups[i].handle_list;
@@ -5780,6 +5816,7 @@ static void release_stripe_plug(struct mddev *mddev,
 
 	if (cb->list.next == NULL) {
 		int i;
+
 		INIT_LIST_HEAD(&cb->list);
 		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
 			INIT_LIST_HEAD(cb->temp_inactive_list + i);
@@ -6367,6 +6404,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	for (i = 0; i < reshape_sectors; i += RAID5_STRIPE_SECTORS(conf)) {
 		int j;
 		int skipped_disk = 0;
+
 		sh = raid5_get_active_stripe(conf, NULL, stripe_addr+i,
 					     R5_GAS_NOQUIESCE);
 		set_bit(STRIPE_EXPANDING, &sh->state);
@@ -6376,6 +6414,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		 */
 		for (j = sh->disks; j--; ) {
 			sector_t s;
+
 			if (j == sh->pd_idx)
 				continue;
 			if (conf->level == 6 &&
@@ -6771,6 +6810,7 @@ static void raid5d(struct md_thread *thread)
 
 		while ((bio = remove_bio_from_retry(conf, &offset))) {
 			int ok;
+
 			spin_unlock_irq(&conf->device_lock);
 			ok = retry_aligned_read(conf, bio, offset);
 			spin_lock_irq(&conf->device_lock);
@@ -6830,6 +6870,7 @@ raid5_show_stripe_cache_size(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf;
 	int ret = 0;
+
 	spin_lock(&mddev->lock);
 	conf = mddev->private;
 	if (conf)
@@ -6902,6 +6943,7 @@ static ssize_t
 raid5_show_rmw_level(struct mddev  *mddev, char *page)
 {
 	struct r5conf *conf = mddev->private;
+
 	if (conf)
 		return sprintf(page, "%d\n", conf->rmw_level);
 	else
@@ -7040,6 +7082,7 @@ raid5_show_preread_threshold(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf;
 	int ret = 0;
+
 	spin_lock(&mddev->lock);
 	conf = mddev->private;
 	if (conf)
@@ -7085,6 +7128,7 @@ raid5_show_skip_copy(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf;
 	int ret = 0;
+
 	spin_lock(&mddev->lock);
 	conf = mddev->private;
 	if (conf)
@@ -7136,6 +7180,7 @@ static ssize_t
 stripe_cache_active_show(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf = mddev->private;
+
 	if (conf)
 		return sprintf(page, "%d\n", atomic_read(&conf->active_stripes));
 	else
@@ -7150,6 +7195,7 @@ raid5_show_group_thread_cnt(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf;
 	int ret = 0;
+
 	spin_lock(&mddev->lock);
 	conf = mddev->private;
 	if (conf)
@@ -7266,6 +7312,7 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt, int *group_cnt,
 
 		for (j = 0; j < cnt; j++) {
 			struct r5worker *worker = group->workers + j;
+
 			worker->group = group;
 			INIT_WORK(&worker->work, raid5_do_work);
 
@@ -8108,6 +8155,7 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
+
 		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
@@ -8379,6 +8427,7 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 		return -EINVAL;
 	if (mddev->bitmap) {
 		int ret = md_bitmap_resize(mddev->bitmap, sectors, 0, 0);
+
 		if (ret)
 			return ret;
 	}
@@ -8404,6 +8453,7 @@ static int check_stripe_cache(struct mddev *mddev)
 	 * stripe_heads first.
 	 */
 	struct r5conf *conf = mddev->private;
+
 	if (((mddev->chunk_sectors << 9) / RAID5_STRIPE_SIZE(conf)) * 4
 	    > conf->min_nr_stripes ||
 	    ((mddev->new_chunk_sectors << 9) / RAID5_STRIPE_SIZE(conf)) * 4
@@ -8436,6 +8486,7 @@ static int check_reshape(struct mddev *mddev)
 		 * Otherwise 2 is the minimum
 		 */
 		int min = 2;
+
 		if (mddev->level == 6)
 			min = 4;
 		if (mddev->raid_disks + mddev->delta_disks < min)
@@ -8639,6 +8690,7 @@ static void raid5_finish_reshape(struct mddev *mddev)
 
 		if (mddev->delta_disks <= 0) {
 			int d;
+
 			spin_lock_irq(&conf->device_lock);
 			mddev->degraded = raid5_calc_degraded(conf);
 			spin_unlock_irq(&conf->device_lock);
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index c629bfae826f..9e7088e03852 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -180,6 +180,7 @@ static inline void cpu_relax(void)
 static inline uint32_t raid6_jiffies(void)
 {
 	struct timeval tv;
+
 	gettimeofday(&tv, NULL);
 	return tv.tv_sec*1000 + tv.tv_usec/1000;
 }
-- 
2.39.2

