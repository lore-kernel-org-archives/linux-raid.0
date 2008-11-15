From: crquan@gmail.com
Subject: [PATCH] md: make use of list_for_each_entry_safe
Date: Sat, 15 Nov 2008 14:06:14 +0800
Message-ID: <1226729174-1315-1-git-send-email-crquan@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
List-Id: linux-raid.ids

From: Cheng Renquan <crquan@gmail.com>

The rdev_for_each_list defined in <linux/raid/md_k.h> is really a reinvented
wheel of list_for_each_entry_safe, and replaced in this patch.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/md/bitmap.c       |    3 +-
 drivers/md/faulty.c       |    3 +-
 drivers/md/linear.c       |    3 +-
 drivers/md/md.c           |   80 ++++++++++++++++----------------------------
 drivers/md/multipath.c    |    3 +-
 drivers/md/raid0.c        |    6 +--
 drivers/md/raid1.c        |    3 +-
 drivers/md/raid10.c       |    3 +-
 drivers/md/raid5.c        |    6 +--
 include/linux/raid/md_k.h |   11 ++----
 10 files changed, 43 insertions(+), 78 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index ac89a5d..1eae625 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -212,8 +212,7 @@ static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long inde
 {
 	/* choose a good rdev and read the page from there */
 
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 	struct page *page = alloc_page(GFP_KERNEL);
 	sector_t target;
 
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index f26c1f9..a0b269e 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -282,8 +282,7 @@ static int reconfig(mddev_t *mddev, int layout, int chunk_size)
 
 static int run(mddev_t *mddev)
 {
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 	int i;
 
 	conf_t *conf = kmalloc(sizeof(*conf), GFP_KERNEL);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 3b90c5c..9e0aee4 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -101,11 +101,10 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 {
 	linear_conf_t *conf;
 	dev_info_t **table;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *tmp;
 	int i, nb_zone, cnt;
 	sector_t min_sectors;
 	sector_t curr_sector;
-	struct list_head *tmp;
 
 	conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(dev_info_t),
 			GFP_KERNEL);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1b1d326..c62a20a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -307,8 +307,7 @@ static inline void mddev_unlock(mddev_t * mddev)
 
 static mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
 {
-	mdk_rdev_t * rdev;
-	struct list_head *tmp;
+	mdk_rdev_t * rdev, *tmp;
 
 	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->desc_nr == nr)
@@ -319,8 +318,7 @@ static mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
 
 static mdk_rdev_t * find_rdev(mddev_t * mddev, dev_t dev)
 {
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *tmp;
 
 	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->bdev->bd_dev == dev)
@@ -861,8 +859,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	mdp_super_t *sb;
-	struct list_head *tmp;
-	mdk_rdev_t *rdev2;
+	mdk_rdev_t *rdev2, *tmp;
 	int next_spare = mddev->raid_disks;
 
 
@@ -1259,8 +1256,7 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	struct mdp_superblock_1 *sb;
-	struct list_head *tmp;
-	mdk_rdev_t *rdev2;
+	mdk_rdev_t *rdev2, *tmp;
 	int max_dev, i;
 	/* make rdev->sb match mddev and rdev data. */
 
@@ -1571,8 +1567,7 @@ static void kick_rdev_from_array(mdk_rdev_t * rdev)
 
 static void export_array(mddev_t *mddev)
 {
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *tmp;
 
 	rdev_for_each(rdev, tmp, mddev) {
 		if (!rdev->mddev) {
@@ -1643,8 +1638,8 @@ static void print_rdev(mdk_rdev_t *rdev)
 
 static void md_print_devices(void)
 {
-	struct list_head *tmp, *tmp2;
-	mdk_rdev_t *rdev;
+	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp2;
 	mddev_t *mddev;
 	char b[BDEVNAME_SIZE];
 
@@ -1678,8 +1673,7 @@ static void sync_sbs(mddev_t * mddev, int nospares)
 	 * (which would mean they aren't being marked as dirty
 	 * with the rest of the array)
 	 */
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 
 	rdev_for_each(rdev, tmp, mddev) {
 		if (rdev->sb_events == mddev->events ||
@@ -1699,8 +1693,7 @@ static void sync_sbs(mddev_t * mddev, int nospares)
 
 static void md_update_sb(mddev_t * mddev, int force_change)
 {
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *tmp;
 	int sync_req;
 	int nospares = 0;
 
@@ -1998,8 +1991,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
 	} else if (rdev->mddev->pers) {
-		mdk_rdev_t *rdev2;
-		struct list_head *tmp;
+		mdk_rdev_t *rdev2, *tmp;
 		/* Activating a spare .. or possibly reactivating
 		 * if we every get bitmaps working here.
 		 */
@@ -2125,11 +2117,11 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		 */
 		mddev_t *mddev;
 		int overlap = 0;
-		struct list_head *tmp, *tmp2;
+		struct list_head *tmp;
 
 		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
-			mdk_rdev_t *rdev2;
+			mdk_rdev_t *rdev2, *tmp2;
 
 			mddev_lock(mddev);
 			rdev_for_each(rdev2, tmp2, mddev)
@@ -2328,8 +2320,7 @@ abort_free:
 static void analyze_sbs(mddev_t * mddev)
 {
 	int i;
-	struct list_head *tmp;
-	mdk_rdev_t *rdev, *freshest;
+	mdk_rdev_t *rdev, *freshest, *tmp;
 	char b[BDEVNAME_SIZE];
 
 	freshest = NULL;
@@ -3501,8 +3492,7 @@ static int do_md_run(mddev_t * mddev)
 {
 	int err;
 	int chunk_size;
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *tmp, *rtmp;
 	struct gendisk *disk;
 	struct mdk_personality *pers;
 	char b[BDEVNAME_SIZE];
@@ -3629,8 +3619,7 @@ static int do_md_run(mddev_t * mddev)
 		 * configuration.
 		 */
 		char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
-		mdk_rdev_t *rdev2;
-		struct list_head *tmp2;
+		mdk_rdev_t *rdev2, *tmp2;
 		int warned = 0;
 		rdev_for_each(rdev, tmp, mddev) {
 			rdev_for_each(rdev2, tmp2, mddev) {
@@ -3725,7 +3714,6 @@ static int do_md_run(mddev_t * mddev)
 	 * it will remove the drives and not do the right thing
 	 */
 	if (mddev->degraded && !mddev->sync_thread) {
-		struct list_head *rtmp;
 		int spares = 0;
 		rdev_for_each(rdev, rtmp, mddev)
 			if (rdev->raid_disk >= 0 &&
@@ -3882,8 +3870,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 	 * Free resources if final stop
 	 */
 	if (mode == 0) {
-		mdk_rdev_t *rdev;
-		struct list_head *tmp;
+		mdk_rdev_t *rdev, *tmp;
 
 		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
@@ -3955,8 +3942,7 @@ out:
 #ifndef MODULE
 static void autorun_array(mddev_t *mddev)
 {
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 	int err;
 
 	if (list_empty(&mddev->disks))
@@ -3991,8 +3977,7 @@ static void autorun_array(mddev_t *mddev)
  */
 static void autorun_devices(int part)
 {
-	struct list_head *tmp;
-	mdk_rdev_t *rdev0, *rdev;
+	mdk_rdev_t *rdev0, *rdev, *tmp;
 	mddev_t *mddev;
 	char b[BDEVNAME_SIZE];
 
@@ -4007,7 +3992,7 @@ static void autorun_devices(int part)
 		printk(KERN_INFO "md: considering %s ...\n",
 			bdevname(rdev0->bdev,b));
 		INIT_LIST_HEAD(&candidates);
-		rdev_for_each_list(rdev, tmp, pending_raid_disks)
+		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
 				printk(KERN_INFO "md:  adding %s ...\n",
 					bdevname(rdev->bdev,b));
@@ -4053,7 +4038,7 @@ static void autorun_devices(int part)
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
 			mddev->persistent = 1;
-			rdev_for_each_list(rdev, tmp, candidates) {
+			rdev_for_each_list(rdev, tmp, &candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
 					export_rdev(rdev);
@@ -4064,7 +4049,7 @@ static void autorun_devices(int part)
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
-		rdev_for_each_list(rdev, tmp, candidates) {
+		rdev_for_each_list(rdev, tmp, &candidates) {
 			list_del_init(&rdev->same_set);
 			export_rdev(rdev);
 		}
@@ -4092,8 +4077,7 @@ static int get_array_info(mddev_t * mddev, void __user * arg)
 {
 	mdu_array_info_t info;
 	int nr,working,active,failed,spare;
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 
 	nr=working=active=failed=spare=0;
 	rdev_for_each(rdev, tmp, mddev) {
@@ -4614,9 +4598,8 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 
 static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
-	mdk_rdev_t * rdev;
+	mdk_rdev_t * rdev, *tmp;
 	int rv;
-	struct list_head *tmp;
 	int fit = (num_sectors == 0);
 
 	if (mddev->pers->resize == NULL)
@@ -5186,12 +5169,11 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 static void status_unused(struct seq_file *seq)
 {
 	int i = 0;
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 
 	seq_printf(seq, "unused devices: ");
 
-	rdev_for_each_list(rdev, tmp, pending_raid_disks) {
+	rdev_for_each_list(rdev, tmp, &pending_raid_disks) {
 		char b[BDEVNAME_SIZE];
 		i++;
 		seq_printf(seq, "%s ",
@@ -5350,8 +5332,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 {
 	mddev_t *mddev = v;
 	sector_t size;
-	struct list_head *tmp2;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *tmp2;
 	struct mdstat_info *mi = seq->private;
 	struct bitmap *bitmap;
 
@@ -5694,8 +5675,7 @@ void md_do_sync(mddev_t *mddev)
 	struct list_head *tmp;
 	sector_t last_check;
 	int skipped = 0;
-	struct list_head *rtmp;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *rtmp;
 	char *desc;
 
 	/* just incase thread restarts... */
@@ -5984,8 +5964,7 @@ EXPORT_SYMBOL_GPL(md_do_sync);
 
 static int remove_and_add_spares(mddev_t *mddev)
 {
-	mdk_rdev_t *rdev;
-	struct list_head *rtmp;
+	mdk_rdev_t *rdev, *rtmp;
 	int spares = 0;
 
 	rdev_for_each(rdev, rtmp, mddev)
@@ -6055,8 +6034,7 @@ static int remove_and_add_spares(mddev_t *mddev)
  */
 void md_check_recovery(mddev_t *mddev)
 {
-	mdk_rdev_t *rdev;
-	struct list_head *rtmp;
+	mdk_rdev_t *rdev, *rtmp;
 
 
 	if (mddev->bitmap)
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index d4ac47d..9221f1f 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -407,8 +407,7 @@ static int multipath_run (mddev_t *mddev)
 	multipath_conf_t *conf;
 	int disk_idx;
 	struct multipath_info *disk;
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 
 	if (mddev->level != LEVEL_MULTIPATH) {
 		printk("multipath: %s: raid level not set to multipath IO (%d)\n",
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8ac6488..0ef0104 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -56,8 +56,7 @@ static int create_strip_zones (mddev_t *mddev)
 	sector_t current_offset, curr_zone_offset;
 	sector_t min_spacing;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
-	struct list_head *tmp1, *tmp2;
+	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev, *tmp1, *tmp2;
 	struct strip_zone *zone;
 	int cnt;
 	char b[BDEVNAME_SIZE];
@@ -264,8 +263,7 @@ static int raid0_run (mddev_t *mddev)
 	unsigned  cur=0, i=0, nb_zone;
 	s64 size;
 	raid0_conf_t *conf;
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 
 	if (mddev->chunk_size == 0) {
 		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9c788e2..2987b22 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1918,8 +1918,7 @@ static int run(mddev_t *mddev)
 	conf_t *conf;
 	int i, j, disk_idx;
 	mirror_info_t *disk;
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 
 	if (mddev->level != 1) {
 		printk("raid1: %s: raid level not set to mirroring (%d)\n",
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 970a96e..3d975fa 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2024,8 +2024,7 @@ static int run(mddev_t *mddev)
 	conf_t *conf;
 	int i, disk_idx;
 	mirror_info_t *disk;
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev, *tmp;
 	int nc, fc, fo;
 	sector_t stride, size;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a36a743..58cfeda 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3996,9 +3996,8 @@ static int run(mddev_t *mddev)
 {
 	raid5_conf_t *conf;
 	int raid_disk, memory;
-	mdk_rdev_t *rdev;
+	mdk_rdev_t *rdev, *tmp;
 	struct disk_info *disk;
-	struct list_head *tmp;
 	int working_disks = 0;
 
 	if (mddev->level != 5 && mddev->level != 4 && mddev->level != 6) {
@@ -4532,8 +4531,7 @@ static int raid5_check_reshape(mddev_t *mddev)
 static int raid5_start_reshape(mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
-	mdk_rdev_t *rdev;
-	struct list_head *rtmp;
+	mdk_rdev_t *rdev, *rtmp;
 	int spares = 0;
 	int added_devices = 0;
 	unsigned long flags;
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 8fc909e..2a29d3c 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -334,17 +334,14 @@ static inline char * mdname (mddev_t * mddev)
  * iterates through some rdev ringlist. It's safe to remove the
  * current 'rdev'. Dont touch 'tmp' though.
  */
-#define rdev_for_each_list(rdev, tmp, list)				\
-									\
-	for ((tmp) = (list).next;					\
-		(rdev) = (list_entry((tmp), mdk_rdev_t, same_set)),	\
-			(tmp) = (tmp)->next, (tmp)->prev != &(list)	\
-		; )
+#define rdev_for_each_list(rdev, tmp, head)				\
+	list_for_each_entry_safe(rdev, tmp, head, same_set)
+
 /*
  * iterates through the 'same array disks' ringlist
  */
 #define rdev_for_each(rdev, tmp, mddev)				\
-	rdev_for_each_list(rdev, tmp, (mddev)->disks)
+	list_for_each_entry_safe(rdev, tmp, &((mddev)->disks), same_set)
 
 #define rdev_for_each_rcu(rdev, mddev)				\
 	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
-- 
1.6.0.2

