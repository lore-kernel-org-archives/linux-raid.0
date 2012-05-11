From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 6/7] bcache: uplevel allocation of 'cached_dev' and
 'cache'
Date: Fri, 11 May 2012 12:46:42 -0700
Message-ID: <20120511194641.25770.25821.stgit@dwillia2-linux.jf.intel.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

This is prepartion to enable a container_of() relationship between these
and a 'rdev' for the md conversion (or a dm_dev for an eventual dm
skin).

Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/md/bcache/super.c |   46 +++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3289db9..c1fe44d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1057,11 +1057,9 @@ static void cached_dev_flush(struct closure *cl)
 	continue_at(cl, cached_dev_free, system_wq);
 }
 
-static struct cached_dev *cached_dev_alloc(unsigned block_size)
+static int cached_dev_init(struct cached_dev *d, unsigned block_size)
 {
-	struct cached_dev *d = kzalloc(sizeof(struct cached_dev), GFP_KERNEL);
-	if (!d)
-		return NULL;
+	int err;
 
 	closure_init(&d->disk.cl, NULL);
 	set_closure_fn(&d->disk.cl, cached_dev_flush, system_wq);
@@ -1093,29 +1091,28 @@ static struct cached_dev *cached_dev_alloc(unsigned block_size)
 
 	bcache_writeback_init_cached_dev(d);
 
+	err = -ENOMEM;
 	d->bio_passthrough = mempool_create_slab_pool(32, passthrough_cache);
 	if (!d->bio_passthrough)
 		goto err;
 
-	return d;
+	return 0;
 err:
 	bcache_device_stop(&d->disk);
-	return NULL;
+	return err;
 }
 
 /* Cached device - bcache superblock */
 
 static const char *register_bdev(struct cache_sb *sb, struct page *sb_page,
-				 struct block_device *bdev)
+				 struct block_device *bdev, struct cached_dev *d)
 {
 	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
 	struct gendisk *g;
 	struct cache_set *c;
 
-	struct cached_dev *d = cached_dev_alloc(sb->block_size << 9);
-
-	if (!d)
+	if (!d || cached_dev_init(d, sb->block_size << 9) != 0)
 		return err;
 
 	memcpy(&d->sb, sb, sizeof(struct cache_sb));
@@ -1729,13 +1726,13 @@ static void cache_free(struct kobject *kobj)
 	module_put(THIS_MODULE);
 }
 
-static struct cache *cache_alloc(struct cache_sb *sb)
+static int cache_alloc(struct cache_sb *sb, struct cache *c)
 {
 	size_t free;
 	struct bucket *b;
-	struct cache *c = kzalloc(sizeof(struct cache), GFP_KERNEL);
+
 	if (!c)
-		return NULL;
+		return -ENOMEM;
 
 	__module_get(THIS_MODULE);
 	cache_kobject_init(c);
@@ -1779,19 +1776,19 @@ static struct cache *cache_alloc(struct cache_sb *sb)
 	if (alloc_discards(c))
 		goto err;
 
-	return c;
+	return 0;
 err:
 	kobject_put(&c->kobj);
-	return NULL;
+	return -ENOMEM;
 }
 
 static const char *register_cache(struct cache_sb *sb, struct page *sb_page,
-				  struct block_device *bdev)
+				  struct block_device *bdev, struct cache *c)
 {
 	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
-	struct cache *c = cache_alloc(sb);
-	if (!c)
+
+	if (cache_alloc(sb, c) != 0)
 		return err;
 
 	c->sb_bio.bi_io_vec[0].bv_page = sb_page;
@@ -1867,10 +1864,15 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (err)
 		goto err_close;
 
-	if (sb->version == CACHE_BACKING_DEV)
-		err = register_bdev(sb, sb_page, bdev);
-	else
-		err = register_cache(sb, sb_page, bdev);
+	if (sb->version == CACHE_BACKING_DEV) {
+		struct cached_dev *d = kzalloc(sizeof(*d), GFP_KERNEL);
+
+		err = register_bdev(sb, sb_page, bdev, d);
+	} else {
+		struct cache *c = kzalloc(sizeof(*c), GFP_KERNEL);
+
+		err = register_cache(sb, sb_page, bdev, c);
+	}
 
 	if (err) {
 		/* register_(bdev|cache) will only return an error if they
