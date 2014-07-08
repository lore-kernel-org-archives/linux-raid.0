From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/2]raid5: add a sysfs entry to change stripe size
Date: Tue, 8 Jul 2014 09:01:33 +0800
Message-ID: <20140708010133.GB8941@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


Add a sysfs entry to change stripe size.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 98 insertions(+), 11 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-07-08 08:48:02.788106833 +0800
+++ linux/drivers/md/raid5.c	2014-07-08 08:48:02.780106934 +0800
@@ -1906,10 +1906,10 @@ static void init_stripe_pointer(struct r
 	}
 }
 
-static int grow_one_stripe(struct r5conf *conf, int hash)
+static int grow_one_stripe(struct r5conf *conf, int hash, gfp_t gfp)
 {
 	struct stripe_head *sh;
-	sh = kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
+	sh = kmem_cache_zalloc(conf->slab_cache, gfp);
 	if (!sh)
 		return 0;
 
@@ -1932,7 +1932,7 @@ static int grow_one_stripe(struct r5conf
 	return 1;
 }
 
-static int grow_stripes(struct r5conf *conf, int num)
+static int grow_stripes(struct r5conf *conf, int num, gfp_t gfp)
 {
 	struct kmem_cache *sc;
 	int devs = max(conf->raid_disks, conf->previous_raid_disks);
@@ -1956,7 +1956,7 @@ static int grow_stripes(struct r5conf *c
 	conf->pool_size = devs;
 	hash = conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
 	while (num--) {
-		if (!grow_one_stripe(conf, hash))
+		if (!grow_one_stripe(conf, hash, gfp))
 			return 1;
 		conf->max_nr_stripes++;
 		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
@@ -5537,7 +5537,7 @@ raid5_set_cache_size(struct mddev *mddev
 		return err;
 	hash = conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
 	while (size > conf->max_nr_stripes) {
-		if (grow_one_stripe(conf, hash))
+		if (grow_one_stripe(conf, hash, GFP_KERNEL))
 			conf->max_nr_stripes++;
 		else break;
 		hash = (hash + 1) % NR_STRIPE_HASH_LOCKS;
@@ -5729,12 +5729,97 @@ raid5_group_thread_cnt = __ATTR(group_th
 				raid5_show_group_thread_cnt,
 				raid5_store_group_thread_cnt);
 
+static ssize_t
+raid5_show_stripe_size(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf)
+		return sprintf(page, "%ld\n", PAGE_SIZE << conf->stripe_size_order);
+	else
+		return 0;
+}
+
+static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu);
+static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu,
+	gfp_t gfp);
+static ssize_t
+raid5_store_stripe_size(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new, chunk_size;
+	int err = 0;
+	int cpu;
+	int nr_stripes;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+
+	new = ilog2(new);
+	if (new == (PAGE_SIZE << conf->stripe_size_order))
+		return len;
+	chunk_size = conf->chunk_sectors * 512;
+	if ((1 << new) > chunk_size || (1 << new) < PAGE_SIZE)
+		return -EINVAL;
+	new -= PAGE_SHIFT;
+
+	mddev_suspend(mddev);
+
+	if (conf->worker_groups)
+		flush_workqueue(raid5_wq);
+
+	nr_stripes = conf->max_nr_stripes;
+	shrink_stripes(conf);
+	conf->max_nr_stripes = 0;
+
+	get_online_cpus();
+	for_each_possible_cpu(cpu) {
+		struct raid5_percpu *percpu;
+
+		percpu = per_cpu_ptr(conf->percpu, cpu);
+		free_scratch_buffer(conf, percpu);
+	}
+
+	conf->stripe_size_order = new;
+
+	conf->scribble_len = scribble_len(conf, conf->pool_size);
+	for_each_present_cpu(cpu) {
+		struct raid5_percpu *percpu;
+
+		percpu = per_cpu_ptr(conf->percpu, cpu);
+		err = alloc_scratch_buffer(conf, percpu, GFP_NOIO);
+		if (err)
+			break;
+	}
+
+	put_online_cpus();
+
+	if (!err)
+		err = grow_stripes(conf, nr_stripes, GFP_NOIO);
+
+	mddev_resume(mddev);
+
+	if (err)
+		return err;
+	return len;
+}
+static struct md_sysfs_entry
+raid5_stripe_size = __ATTR(stripe_size, S_IRUGO | S_IWUSR,
+				raid5_show_stripe_size,
+				raid5_store_stripe_size);
+
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
 	&raid5_group_thread_cnt.attr,
 	&raid5_skip_copy.attr,
+	&raid5_stripe_size.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -5822,12 +5907,13 @@ static void free_scratch_buffer(struct r
 	percpu->scribble = NULL;
 }
 
-static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
+static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu,
+	gfp_t gfp)
 {
 	if (conf->level == 6 && !percpu->spare_page)
-		percpu->spare_page = alloc_pages(GFP_KERNEL, conf->stripe_size_order);
+		percpu->spare_page = alloc_pages(gfp, conf->stripe_size_order);
 	if (!percpu->scribble)
-		percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
+		percpu->scribble = kmalloc(conf->scribble_len, gfp);
 
 	if (!percpu->scribble || (conf->level == 6 && !percpu->spare_page)) {
 		free_scratch_buffer(conf, percpu);
@@ -5877,7 +5963,7 @@ static int raid456_cpu_notify(struct not
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (alloc_scratch_buffer(conf, percpu)) {
+		if (alloc_scratch_buffer(conf, percpu, GFP_KERNEL)) {
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
 			return notifier_from_errno(-ENOMEM);
@@ -5913,7 +5999,8 @@ static int raid5_alloc_percpu(struct r5c
 
 	get_online_cpus();
 	for_each_present_cpu(cpu) {
-		err = alloc_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
+		err = alloc_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu),
+			GFP_KERNEL);
 		if (err) {
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
@@ -6073,7 +6160,7 @@ static struct r5conf *setup_conf(struct
 	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
-	if (grow_stripes(conf, NR_STRIPES)) {
+	if (grow_stripes(conf, NR_STRIPES, GFP_KERNEL)) {
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate %dkB for buffers\n",
 		       mdname(mddev), memory);
