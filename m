From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [RFC PATCH 1/4] md: complete bio accounting and add io_latency extension
Date: Wed,  4 Jun 2014 19:09:59 +0200
Message-ID: <1401901802-16296-2-git-send-email-sebastian.riemer@profitbricks.com>
References: <20140602202050.14903534@notabene.brown>
 <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

From: Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>

The md layer only accounts the number of I/Os and sectors per bio.
So account in-flight and ticks as well. Also maintain an I/O latency
statistic by counting I/Os in power of 2 latency areas starting at
< 8 ms and ending at >= 65536 ms. Determine the maximum latency as
well. This I/O latency statistic can be read and reset to 0 with the
md sysfs file 'io_latency'.

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@profitbricks.com>
[spars: added a description, replaced gcc atomics with atomic64_t,
 merged commits, fixed checkpatch warnings]
Signed-off-by: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
---
 drivers/md/md.c |  175 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |   18 ++++++
 2 files changed, 193 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 237b7e0..8c653f9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -54,6 +54,32 @@
 #include "md.h"
 #include "bitmap.h"
 
+#ifdef BIO_ACCOUNTING_EXTENSION
+
+#include <linux/ratelimit.h>
+
+struct md_bio_private {
+	void		(*orig_bio_endio)(struct bio *, int);
+	void		*orig_bio_private;
+	struct mddev	*mddev;
+	unsigned int	sectors;
+	unsigned long	ticks;
+};
+
+static struct kmem_cache *md_bio_private_cache __read_mostly;
+
+static DEFINE_RATELIMIT_STATE(md_ratelimit_state,
+			DEFAULT_RATELIMIT_INTERVAL,
+			DEFAULT_RATELIMIT_BURST);
+
+static inline int __must_check md_valid_ptr(const void *p)
+{
+	return !ZERO_OR_NULL_PTR(p) && !IS_ERR(p);
+}
+#define VALID_PTR(p)	md_valid_ptr(p)
+
+#endif	/* BIO_ACCOUNTING_EXTENSION */
+
 #ifndef MODULE
 static void autostart_arrays(int part);
 #endif
@@ -241,6 +267,64 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
 		_tmp = _tmp->next;})					\
 		)
 
+#ifdef BIO_ACCOUNTING_EXTENSION
+
+static inline long atomic64_set_if_greater(atomic64_t *v, long val)
+{
+	long act, old;
+
+	old = atomic64_read(v);
+	for (;;) {
+		if (val <= old)
+			break;
+		act = atomic64_cmpxchg(v, old, val);
+		if (likely(act == old))
+			break;
+		old = act;
+	}
+	return old;
+}
+
+static void md_bio_endio(struct bio *bio, int err)
+{
+	struct md_bio_private *mbp = bio->bi_private;
+	struct mddev *mddev = mbp->mddev;
+	struct md_stats *sp = &mddev->stats;
+
+	unsigned int sectors = mbp->sectors;
+	int cpu, idx, rw = bio_data_dir(bio);
+	unsigned long ms, ticks;
+
+	BUILD_BUG_ON(ARRAY_SIZE(sp->latency_table[0]) != 2);
+	BUILD_BUG_ON(ARRAY_SIZE(sp->max_latency) != 2);
+
+	ticks = (long)jiffies - (long)mbp->ticks;
+
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw], sectors);
+	part_stat_add(cpu, &mddev->gendisk->part0, ticks[rw], ticks);
+	part_dec_in_flight(&mddev->gendisk->part0, rw);
+	part_round_stats(cpu, &mddev->gendisk->part0);
+	part_stat_unlock();
+
+	ms = jiffies_to_msecs(ticks);
+	if (likely(ticks > 0) && ms > 0) {
+		idx = ilog2(ms) - MD_LATENCY_LOGBASE + 1;
+		idx = clamp(idx, 0, (int)ARRAY_SIZE(sp->latency_table) - 1);
+	} else {
+		idx = 0;
+	}
+	atomic64_set_if_greater(&sp->max_latency[rw], ticks);
+	atomic64_inc(&sp->latency_table[idx][rw]);
+
+	bio->bi_private = mbp->orig_bio_private;
+	bio->bi_end_io = mbp->orig_bio_endio;
+	kmem_cache_free(md_bio_private_cache, mbp);
+	bio_endio_nodec(bio, err);  /* >= 3.14, bio_endio() otherwise */
+}
+
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 
 /* Rather than calling directly into the personality make_request function,
  * IO requests come here first so that we can check if the device is
@@ -255,6 +339,9 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 	struct mddev *mddev = q->queuedata;
 	int cpu;
 	unsigned int sectors;
+#ifdef BIO_ACCOUNTING_EXTENSION
+	struct md_bio_private *mbp;
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
@@ -288,12 +375,36 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 	 * go away inside make_request
 	 */
 	sectors = bio_sectors(bio);
+#ifdef BIO_ACCOUNTING_EXTENSION
+	mbp = kmem_cache_alloc(md_bio_private_cache, GFP_NOIO);
+	if (unlikely(!VALID_PTR(mbp))) {
+		if (__ratelimit(&md_ratelimit_state))
+			pr_warn("%s: [%s] kmem_cache_alloc failed\n",
+				__func__, mdname(mddev));
+		cpu = part_stat_lock();
+		part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+		part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+			      sectors);
+		part_stat_unlock();
+	} else {
+		part_inc_in_flight(&mddev->gendisk->part0, rw);
+		mbp->orig_bio_private = bio->bi_private;
+		mbp->orig_bio_endio = bio->bi_end_io;
+		mbp->sectors = sectors;
+		mbp->ticks = jiffies;
+		mbp->mddev = mddev;
+		bio->bi_end_io = md_bio_endio;
+		bio->bi_private = mbp;
+	}
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 	mddev->pers->make_request(mddev, bio);
 
+#ifndef BIO_ACCOUNTING_EXTENSION
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
 	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw], sectors);
 	part_stat_unlock();
+#endif	/* !BIO_ACCOUNTING_EXTENSION */
 
 	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
 		wake_up(&mddev->sb_wait);
@@ -4652,6 +4763,52 @@ static struct md_sysfs_entry md_array_size =
 __ATTR(array_size, S_IRUGO|S_IWUSR, array_size_show,
        array_size_store);
 
+#ifdef BIO_ACCOUNTING_EXTENSION
+
+static ssize_t
+md_io_latency_show(struct mddev *mddev, char *page)
+{
+	struct md_stats *sp = &mddev->stats;
+	ssize_t cnt;
+	int i;
+
+	for (cnt = i = 0; i < (ARRAY_SIZE(sp->latency_table) - 1); i++) {
+		cnt += scnprintf(page + cnt, PAGE_SIZE - cnt,
+			"<  %5d ms: %lu %lu\n",
+			(1 << (i + MD_LATENCY_LOGBASE)),
+			atomic64_read(&sp->latency_table[i][0]),
+			atomic64_read(&sp->latency_table[i][1]));
+	}
+	cnt += scnprintf(page + cnt, PAGE_SIZE - cnt, ">= %5d ms: %lu %lu\n",
+		(1 << ((i - 1) + MD_LATENCY_LOGBASE)),
+		atomic64_read(&sp->latency_table[i][0]),
+		atomic64_read(&sp->latency_table[i][1]));
+	cnt += scnprintf(page + cnt, PAGE_SIZE - cnt, " maximum ms: %u %u\n",
+		jiffies_to_msecs(atomic64_read(&sp->max_latency[0])),
+		jiffies_to_msecs(atomic64_read(&sp->max_latency[1])));
+	return cnt;
+}
+
+static ssize_t
+md_io_latency_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	struct md_stats *sp = &mddev->stats;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(sp->max_latency); i++)
+		atomic64_set(&sp->max_latency[i], 0);
+	for (i = 0; i < ARRAY_SIZE(sp->latency_table); i++) {
+		for (j = 0; j < ARRAY_SIZE(sp->latency_table[i]); j++)
+			atomic64_set(&sp->latency_table[i][j], 0);
+	}
+	return len;
+}
+
+static struct md_sysfs_entry md_io_latency =
+__ATTR(io_latency, S_IRUGO|S_IWUSR, md_io_latency_show, md_io_latency_store);
+
+#endif	/* BIO_ACCOUNTING_EXTENSION */
+
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_layout.attr,
@@ -4667,6 +4824,9 @@ static struct attribute *md_default_attrs[] = {
 	&md_reshape_direction.attr,
 	&md_array_size.attr,
 	&max_corr_read_errors.attr,
+#ifdef BIO_ACCOUNTING_EXTENSION
+	&md_io_latency.attr,
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 	NULL,
 };
 
@@ -8551,6 +8711,14 @@ static int __init md_init(void)
 {
 	int ret = -ENOMEM;
 
+#ifdef BIO_ACCOUNTING_EXTENSION
+	md_bio_private_cache = KMEM_CACHE(md_bio_private, 0);
+	if (unlikely(!VALID_PTR(md_bio_private_cache))) {
+		pr_err("%s: KMEM_CACHE failed\n", __func__);
+		return -ENOMEM;
+	}
+#endif	/* BIO_ACCOUNTING_EXTENSION */
+
 	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
 		goto err_wq;
@@ -8687,6 +8855,13 @@ static __exit void md_exit(void)
 	}
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_wq);
+
+#ifdef BIO_ACCOUNTING_EXTENSION
+	if (likely(VALID_PTR(md_bio_private_cache))) {
+		kmem_cache_destroy(md_bio_private_cache);
+		md_bio_private_cache = NULL;
+	}
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 }
 
 subsys_initcall(md_init);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a49d991..f0e9171 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -24,6 +24,10 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
+#if 1
+#define BIO_ACCOUNTING_EXTENSION
+#endif
+
 #define MaxSector (~(sector_t)0)
 
 /* Bad block numbers are stored sorted in a single page.
@@ -202,6 +206,17 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 				int is_new);
 extern void md_ack_all_badblocks(struct badblocks *bb);
 
+#ifdef BIO_ACCOUNTING_EXTENSION
+
+#define MD_LATENCY_LOGBASE	3
+
+struct md_stats {
+	atomic64_t			latency_table[15][2];
+	atomic64_t			max_latency[2];
+};
+
+#endif /* BIO_ACCOUNTING_EXTENSION */
+
 struct mddev {
 	void				*private;
 	struct md_personality		*pers;
@@ -437,6 +452,9 @@ struct mddev {
 	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
+#ifdef BIO_ACCOUNTING_EXTENSION
+	struct md_stats stats;
+#endif	/* BIO_ACCOUNTING_EXTENSION */
 };
 
 
-- 
1.7.9.5

