From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/5] MD: attach data to each bio
Date: Tue, 7 Feb 2017 08:55:58 -0800
Message-ID: <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com>
References: <cover.1486485935.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1486485935.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids

Currently MD is rebusing some bio fields. To remove the hack, we attach
extra data to each bio. Each personablity can attach extra data to the
bios, so we don't need to rebuse bio fields.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h | 18 +++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 67a1854..6f23964 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -248,6 +248,47 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
 		_tmp = _tmp->next;})					\
 		)
 
+#define MD_MEMPOOL_SIZE (32)
+static mempool_t *md_alloc_per_bio_pool(struct md_personality *per)
+{
+	mempool_t *p;
+
+	if (!per->per_bio_data_size)
+		return NULL;
+	p = mempool_create_kmalloc_pool(MD_MEMPOOL_SIZE,
+				MD_PER_BIO_DATA_SIZE(per));
+	if (p)
+		return p;
+	return ERR_PTR(-ENOMEM);
+}
+
+static void md_bio_end_io(struct bio *bio)
+{
+	struct md_per_bio_data *data = bio->bi_private;
+
+	bio->bi_private = data->orig_private;
+	bio->bi_end_io = data->orig_endio;
+	bio_endio(bio);
+
+	mempool_free(data, data->mddev->per_bio_pool);
+}
+
+void md_bio_attach_data(struct mddev *mddev, struct bio *bio)
+{
+	struct md_per_bio_data *data;
+
+	if (!mddev->per_bio_pool)
+		return;
+	data = mempool_alloc(mddev->per_bio_pool, GFP_NOIO);
+	data->orig_endio = bio->bi_end_io;
+	data->orig_private = bio->bi_private;
+	data->mddev = mddev;
+
+	bio->bi_private = data;
+	bio->bi_end_io = md_bio_end_io;
+}
+EXPORT_SYMBOL(md_bio_attach_data);
+
 /* Rather than calling directly into the personality make_request function,
  * IO requests come here first so that we can check if the device is
  * being suspended pending a reconfiguration.
@@ -274,6 +315,8 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 		bio_endio(bio);
 		return BLK_QC_T_NONE;
 	}
+	md_bio_attach_data(mddev, bio);
+
 	smp_rmb(); /* Ensure implications of  'active' are visible */
 	rcu_read_lock();
 	if (mddev->suspended) {
@@ -3513,6 +3556,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	long level;
 	void *priv, *oldpriv;
 	struct md_rdev *rdev;
+	mempool_t *new_pool;
 
 	if (slen == 0 || slen >= sizeof(clevel))
 		return -EINVAL;
@@ -3580,7 +3624,15 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		rv = len;
 		goto out_unlock;
 	}
+	new_pool = md_alloc_per_bio_pool(pers);
+	if (IS_ERR(new_pool)) {
+		module_put(pers->owner);
+		rv = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (!pers->takeover) {
+		mempool_destroy(new_pool);
 		module_put(pers->owner);
 		pr_warn("md: %s: %s does not support personality takeover\n",
 			mdname(mddev), clevel);
@@ -3596,6 +3648,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	 */
 	priv = pers->takeover(mddev);
 	if (IS_ERR(priv)) {
+		mempool_destroy(new_pool);
 		mddev->new_level = mddev->level;
 		mddev->new_layout = mddev->layout;
 		mddev->new_chunk_sectors = mddev->chunk_sectors;
@@ -3660,6 +3713,9 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 
 	module_put(oldpers->owner);
 
+	mempool_destroy(mddev->per_bio_pool);
+	mddev->per_bio_pool = new_pool;
+
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk < 0)
 			continue;
@@ -5209,6 +5265,7 @@ int md_run(struct mddev *mddev)
 	int err;
 	struct md_rdev *rdev;
 	struct md_personality *pers;
+	mempool_t *new_pool;
 
 	if (list_empty(&mddev->disks))
 		/* cannot run an array with no devices.. */
@@ -5299,6 +5356,13 @@ int md_run(struct mddev *mddev)
 		return -EINVAL;
 	}
 
+	new_pool = md_alloc_per_bio_pool(pers);
+	if (IS_ERR(new_pool)) {
+		module_put(pers->owner);
+		return -EINVAL;
+	}
+	mddev->per_bio_pool = new_pool;
+
 	if (pers->sync_request) {
 		/* Warn if this is a potentially silly
 		 * configuration.
@@ -5364,6 +5428,8 @@ int md_run(struct mddev *mddev)
 
 	}
 	if (err) {
+		mempool_destroy(new_pool);
+		mddev->per_bio_pool = NULL;
 		mddev_detach(mddev);
 		if (mddev->private)
 			pers->free(mddev, mddev->private);
@@ -5619,6 +5685,8 @@ static void __md_stop(struct mddev *mddev)
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
 	pers->free(mddev, mddev->private);
+	mempool_destroy(mddev->per_bio_pool);
+	mddev->per_bio_pool = NULL;
 	mddev->private = NULL;
 	if (pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 968bbe7..3d2fe21 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -450,6 +450,7 @@ struct mddev {
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
 	unsigned int			good_device_nr;	/* good device num within cluster raid */
+	mempool_t			*per_bio_pool;
 };
 
 enum recovery_flags {
@@ -540,8 +541,25 @@ struct md_personality
 	/* congested implements bdi.congested_fn().
 	 * Will not be called while array is 'suspended' */
 	int (*congested)(struct mddev *mddev, int bits);
+	size_t per_bio_data_size;
 };
 
+struct md_per_bio_data {
+	bio_end_io_t *orig_endio;
+	void *orig_private;
+	struct mddev *mddev;
+};
+
+#define MD_PER_BIO_DATA_SIZE(per) (sizeof(struct md_per_bio_data) + \
+	roundup(per->per_bio_data_size, __alignof__(struct md_per_bio_data)))
+
+static inline void *md_get_per_bio_data(struct bio *bio)
+{
+	return ((struct md_per_bio_data *)bio->bi_private) + 1;
+}
+
+extern void md_bio_attach_data(struct mddev *mddev, struct bio *bio);
+
 struct md_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct mddev *, char *);
-- 
2.9.3

