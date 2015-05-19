From: Shaohua Li <shli@fb.com>
Subject: [PATCH v2 4/6] raid5: add some sysfs entries
Date: Mon, 18 May 2015 19:57:32 -0700
Message-ID: <ebd302fda8ff48f3578cd509c3d62993155631e3.1432003804.git.shli@fb.com>
References: <cover.1432003804.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1432003804.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Add some sysfs entries.
-cache_memory. Control the cache memory size.
-cache_reclaim_batch. Control how many stripes reclaim should run in one
time.
-cache_memory_watermark. The background reclaim runs if cache memory
hits the watermark and stops after hit 1.5x of the watermark.
-cache_disk_watermark. The background reclaim runs if cache disk space
hits the watermark and stops after hit 1.5x of the watermark.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 253 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c       |   3 +
 drivers/md/raid5.h       |   1 +
 3 files changed, 256 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 4ea24cb..b93d29a 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -314,6 +314,12 @@ static inline int r5l_page_blocks(struct r5l_log *log, int pages)
 	return pages << log->page_block_shift;
 }
 
+static inline int r5l_max_flush_stripes(struct r5l_log *log)
+{
+	return (log->block_size - sizeof(struct r5l_flush_block)) /
+		sizeof(__le64);
+}
+
 static u32 r5l_calculate_checksum(struct r5l_log *log, u32 crc,
 	void *buf, size_t size, bool data)
 {
@@ -3124,6 +3130,247 @@ static int r5c_shrink_cache_memory(struct r5c_cache *cache, unsigned long size)
 	return 0;
 }
 
+static ssize_t r5c_show_cache_memory(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+
+	return sprintf(page, "%lld\n", cache->max_pages << PAGE_SHIFT);
+}
+
+static ssize_t r5c_store_cache_memory(struct mddev *mddev, const char *page,
+	size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+	unsigned long new;
+	LIST_HEAD(page_list);
+	u64 i;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtoul(page, 0, &new))
+		return -EINVAL;
+	new >>= PAGE_SHIFT;
+
+	if (new > cache->max_pages) {
+		i = cache->max_pages;
+		while (i < new) {
+			struct page *page = alloc_page(GFP_KERNEL);
+
+			if (!page)
+				break;
+			list_add(&page->lru, &page_list);
+			i++;
+		}
+
+		spin_lock_irq(&cache->pool_lock);
+		list_splice(&page_list, &cache->page_pool);
+		cache->free_pages += i - cache->max_pages;
+		cache->max_pages = i;
+		cache->total_pages = i;
+		r5c_calculate_watermark(cache);
+		spin_unlock_irq(&cache->pool_lock);
+		return len;
+	}
+	r5c_shrink_cache_memory(cache, new);
+	return len;
+}
+
+static struct md_sysfs_entry r5c_cache_memory = __ATTR(cache_memory,
+	S_IRUGO | S_IWUSR, r5c_show_cache_memory, r5c_store_cache_memory);
+
+int r5c_min_stripe_cache_size(struct r5c_cache *cache)
+{
+	struct r5conf *conf = cache->mddev->private;
+	return (conf->chunk_sectors >> PAGE_SECTOR_SHIFT) *
+		cache->reclaim_batch;
+}
+
+static void r5c_set_reclaim_batch(struct r5c_cache *cache, int batch)
+{
+	struct mddev *mddev = cache->mddev;
+	struct r5conf *conf = mddev->private;
+	int size;
+
+	size = (cache->stripe_parity_pages << PAGE_SECTOR_SHIFT) * batch;
+	if (size > cache->reserved_space) {
+		cache->reserved_space = size;
+		mutex_lock(&cache->log.io_mutex);
+		cache->log.reserved_blocks = r5l_sector_to_block(&cache->log,
+			cache->reserved_space) + 1;
+		mutex_unlock(&cache->log.io_mutex);
+		r5c_wake_wait_reclaimer(cache,
+				RECLAIM_DISK_BACKGROUND);
+	} else {
+		mutex_lock(&cache->log.io_mutex);
+		cache->log.reserved_blocks -= r5l_sector_to_block(&cache->log,
+			cache->reserved_space - size);
+		mutex_unlock(&cache->log.io_mutex);
+		cache->reserved_space = size;
+	}
+
+	size = (conf->chunk_sectors >> PAGE_SECTOR_SHIFT) * batch;
+
+	mddev_lock(mddev);
+	if (size > conf->max_nr_stripes)
+		raid5_set_cache_size(mddev, size);
+	mddev_unlock(mddev);
+
+	cache->reclaim_batch = batch;
+}
+
+static ssize_t r5c_show_cache_reclaim_batch(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+
+	return sprintf(page, "%d\n", cache->reclaim_batch);
+}
+
+static ssize_t r5c_store_cache_reclaim_batch(struct mddev *mddev,
+	const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+	unsigned long new;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtoul(page, 0, &new))
+		return -EINVAL;
+
+	if (new > r5l_max_flush_stripes(&cache->log))
+		new = r5l_max_flush_stripes(&cache->log);
+
+	if (new != cache->reclaim_batch)
+		r5c_set_reclaim_batch(cache, new);
+	return len;
+}
+
+static struct md_sysfs_entry r5c_cache_reclaim_batch =
+	__ATTR(cache_reclaim_batch, S_IRUGO | S_IWUSR,
+	r5c_show_cache_reclaim_batch, r5c_store_cache_reclaim_batch);
+
+static ssize_t r5c_show_cache_disk_watermark(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+
+	return sprintf(page, "%lld\n", cache->log.low_watermark *
+		cache->log.block_size);
+}
+
+static ssize_t r5c_store_cache_disk_watermark(struct mddev *mddev,
+	const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+	struct r5l_log *log = &cache->log;
+	unsigned long new;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtoul(page, 0, &new))
+		return -EINVAL;
+	new /= log->block_size;
+
+	if (new * 3 / 2 >= log->total_blocks)
+		return -EINVAL;
+
+	mutex_lock(&log->io_mutex);
+	log->low_watermark = new;
+	log->high_watermark = new * 3 / 2;
+	mutex_unlock(&log->io_mutex);
+	return len;
+}
+
+static struct md_sysfs_entry r5c_cache_disk_watermark =
+	__ATTR(cache_disk_watermark, S_IRUGO | S_IWUSR,
+	r5c_show_cache_disk_watermark, r5c_store_cache_disk_watermark);
+
+static ssize_t r5c_show_cache_memory_watermark(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+
+	return sprintf(page, "%lld\n", cache->low_watermark << PAGE_SHIFT);
+}
+
+static ssize_t r5c_store_cache_memory_watermark(struct mddev *mddev,
+	const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+	unsigned long new;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtoul(page, 0, &new))
+		return -EINVAL;
+	new >>= PAGE_SHIFT;
+
+	if (new * 3 / 2 >= cache->max_pages)
+		return -EINVAL;
+
+	spin_lock_irq(&cache->pool_lock);
+	cache->low_watermark = new;
+	cache->high_watermark = new * 3 / 2;
+	spin_unlock_irq(&cache->pool_lock);
+	return len;
+}
+
+static struct md_sysfs_entry r5c_cache_memory_watermark =
+	__ATTR(cache_memory_watermark, S_IRUGO | S_IWUSR,
+	r5c_show_cache_memory_watermark, r5c_store_cache_memory_watermark);
+
+static int r5c_init_sysfs(struct r5c_cache *cache)
+{
+	struct mddev *mddev = cache->mddev;
+	int ret;
+
+	ret = sysfs_add_file_to_group(&mddev->kobj, &r5c_cache_memory.attr,
+				      NULL);
+	if (ret)
+		return ret;
+	ret = sysfs_add_file_to_group(&mddev->kobj,
+				      &r5c_cache_reclaim_batch.attr, NULL);
+	if (ret)
+		goto err_reclaim;
+	ret = sysfs_add_file_to_group(&mddev->kobj,
+				      &r5c_cache_disk_watermark.attr, NULL);
+	if (ret)
+		goto disk_watermark;
+	ret = sysfs_add_file_to_group(&mddev->kobj,
+				      &r5c_cache_memory_watermark.attr, NULL);
+	if (ret)
+		goto memory_watermark;
+	return 0;
+memory_watermark:
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_disk_watermark.attr, NULL);
+disk_watermark:
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_reclaim_batch.attr, NULL);
+err_reclaim:
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_memory.attr, NULL);
+	return ret;
+}
+
+static void r5c_exit_sysfs(struct r5c_cache *cache)
+{
+	struct mddev *mddev = cache->mddev;
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_reclaim_batch.attr, NULL);
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_memory.attr, NULL);
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_disk_watermark.attr, NULL);
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_memory_watermark.attr, NULL);
+}
+
 static void r5c_free_cache_data(struct r5c_cache *cache)
 {
 	struct r5c_stripe *stripe;
@@ -3234,8 +3481,11 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 	cache->reclaim_thread->timeout = CHECKPOINT_TIMEOUT;
 
 	r5c_shrink_cache_memory(cache, cache->max_pages);
-
+	if (r5c_init_sysfs(cache))
+		goto err_sysfs;
 	return cache;
+err_sysfs:
+	md_unregister_thread(&cache->reclaim_thread);
 err_page:
 	r5c_free_cache_data(cache);
 
@@ -3254,6 +3504,7 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 
 void r5c_exit_cache(struct r5c_cache *cache)
 {
+	r5c_exit_sysfs(cache);
 	md_unregister_thread(&cache->reclaim_thread);
 	r5l_exit_log(&cache->log);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4eb6e99..772b65f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5876,6 +5876,9 @@ raid5_set_cache_size(struct mddev *mddev, int size)
 	if (size <= 16 || size > 32768)
 		return -EINVAL;
 
+	if (conf->cache && size < r5c_min_stripe_cache_size(conf->cache))
+		size = r5c_min_stripe_cache_size(conf->cache);
+
 	conf->min_nr_stripes = size;
 	while (size < conf->max_nr_stripes &&
 	       drop_one_stripe(conf))
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index e4e93bb..899ec79 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -614,4 +614,5 @@ void r5c_exit_cache(struct r5c_cache *cache);
 void r5c_write_start(struct mddev *mddev, struct bio *bi);
 void r5c_write_end(struct mddev *mddev, struct bio *bi);
 void r5c_quiesce(struct r5conf *conf, int state);
+int r5c_min_stripe_cache_size(struct r5c_cache *cache);
 #endif
-- 
1.8.1

