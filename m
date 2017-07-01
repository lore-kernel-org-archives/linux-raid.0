From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 5/5] raid5: add a 'r5_numa_node' module parameter
Date: Sat,  1 Jul 2017 15:20:58 +0800
Message-ID: <1498893658-18409-5-git-send-email-liuzhengyuan@kylinos.cn>
References: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com, colyli@suse.de, liuyun01@kylinos.cn
List-Id: linux-raid.ids

This module parameter allows user to control which numa node
the memory for mainly structures is allocated from.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/raid5.c | 54 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 547d5fa..b61417f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -75,6 +75,11 @@ static bool devices_handle_discard_safely = false;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
 		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
+
+static int r5_numa_node = NUMA_NO_NODE;
+module_param(r5_numa_node, int, S_IRUGO);
+MODULE_PARM_DESC(r5_numa_node, "NUMA node for raid5 memory allocations");
+
 static struct workqueue_struct *raid5_wq;
 
 static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
@@ -484,7 +489,7 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 	for (i = 0; i < num; i++) {
 		struct page *page;
 
-		if (!(page = alloc_page(gfp))) {
+		if (!(page = alloc_pages_node(r5_numa_node, gfp, 0))) {
 			return 1;
 		}
 		sh->dev[i].page = page;
@@ -2135,7 +2140,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 	struct stripe_head *sh;
 	int i;
 
-	sh = kmem_cache_zalloc(sc, gfp);
+	sh = kmem_cache_alloc_node(sc, gfp | __GFP_ZERO, r5_numa_node);
 	if (sh) {
 		spin_lock_init(&sh->stripe_lock);
 		spin_lock_init(&sh->batch_lock);
@@ -2154,7 +2159,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		}
 
 		if (raid5_has_ppl(conf)) {
-			sh->ppl_page = alloc_page(gfp);
+			sh->ppl_page = alloc_pages_node(r5_numa_node, gfp, 0);
 			if (!sh->ppl_page) {
 				free_stripe(sc, sh);
 				sh = NULL;
@@ -2383,13 +2388,15 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 	 * is completely stalled, so now is a good time to resize
 	 * conf->disks and the scribble region
 	 */
-	ndisks = kzalloc(newsize * sizeof(struct disk_info), GFP_NOIO);
+	ndisks = kzalloc_node(newsize * sizeof(struct disk_info), GFP_NOIO,
+							r5_numa_node);
 	if (ndisks) {
 		for (i = 0; i < conf->pool_size; i++)
 			ndisks[i] = conf->disks[i];
 
 		for (i = conf->pool_size; i < newsize; i++) {
-			ndisks[i].extra_page = alloc_page(GFP_NOIO);
+			ndisks[i].extra_page = alloc_pages_node(r5_numa_node,
+							GFP_NOIO, 0);
 			if (!ndisks[i].extra_page)
 				err = -ENOMEM;
 		}
@@ -2418,7 +2425,8 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 
 		for (i=conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
-				struct page *p = alloc_page(GFP_NOIO);
+				struct page *p = alloc_pages_node(r5_numa_node,
+								GFP_NOIO, 0);
 				nsh->dev[i].page = p;
 				nsh->dev[i].orig_page = p;
 				if (!p)
@@ -3921,7 +3929,8 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 			    dev->page == dev->orig_page &&
 			    !test_bit(R5_LOCKED, &sh->dev[sh->pd_idx].flags)) {
 				/* alloc page for prexor */
-				struct page *p = alloc_page(GFP_NOIO);
+				struct page *p = alloc_pages_node(r5_numa_node,
+								GFP_NOIO, 0);
 
 				if (p) {
 					dev->orig_page = p;
@@ -6653,9 +6662,9 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt,
 	}
 	*group_cnt = num_possible_nodes();
 	size = sizeof(struct r5worker) * cnt;
-	workers = kzalloc(size * *group_cnt, GFP_NOIO);
-	*worker_groups = kzalloc(sizeof(struct r5worker_group) *
-				*group_cnt, GFP_NOIO);
+	workers = kzalloc_node(size * *group_cnt, GFP_NOIO, r5_numa_node);
+	*worker_groups = kzalloc_node(sizeof(struct r5worker_group) *
+				*group_cnt, GFP_NOIO, r5_numa_node);
 	if (!*worker_groups || !workers) {
 		kfree(workers);
 		kfree(*worker_groups);
@@ -6720,7 +6729,8 @@ static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu
 static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
 {
 	if (conf->level == 6 && !percpu->spare_page)
-		percpu->spare_page = alloc_page(GFP_KERNEL);
+		percpu->spare_page = alloc_pages_node(r5_numa_node,
+							GFP_KERNEL, 0);
 	if (!percpu->scribble)
 		percpu->scribble = scribble_alloc(max(conf->raid_disks,
 						      conf->previous_raid_disks),
@@ -6880,13 +6890,13 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	conf = kzalloc(sizeof(struct r5conf), GFP_KERNEL);
+	conf = kzalloc_node(sizeof(struct r5conf), GFP_KERNEL, r5_numa_node);
 	if (conf == NULL)
 		goto abort;
 	INIT_LIST_HEAD(&conf->free_list);
 	INIT_LIST_HEAD(&conf->pending_list);
-	conf->pending_data = kzalloc(sizeof(struct r5pending_data) *
-		PENDING_IO_MAX, GFP_KERNEL);
+	conf->pending_data = kzalloc_node(sizeof(struct r5pending_data) *
+		PENDING_IO_MAX, GFP_KERNEL, r5_numa_node);
 	if (!conf->pending_data)
 		goto abort;
 	for (i = 0; i < PENDING_IO_MAX; i++)
@@ -6935,14 +6945,15 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		conf->previous_raid_disks = mddev->raid_disks - mddev->delta_disks;
 	max_disks = max(conf->raid_disks, conf->previous_raid_disks);
 
-	conf->disks = kzalloc(max_disks * sizeof(struct disk_info),
-			      GFP_KERNEL);
+	conf->disks = kzalloc_node(max_disks * sizeof(struct disk_info),
+			      GFP_KERNEL, r5_numa_node);
 
 	if (!conf->disks)
 		goto abort;
 
 	for (i = 0; i < max_disks; i++) {
-		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
+		conf->disks[i].extra_page = alloc_pages_node(r5_numa_node,
+							GFP_KERNEL, 0);
 		if (!conf->disks[i].extra_page)
 			goto abort;
 	}
@@ -6952,7 +6963,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	conf->mddev = mddev;
 
-	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
+	if ((conf->stripe_hashtbl = kzalloc_node(PAGE_SIZE, GFP_KERNEL, r5_numa_node))
+									== NULL)
 		goto abort;
 
 	/* We init hash_locks[0] separately to that it can be used
@@ -8445,6 +8457,12 @@ static int __init raid5_init(void)
 		destroy_workqueue(raid5_wq);
 		return ret;
 	}
+
+	if (r5_numa_node < NUMA_NO_NODE)
+		r5_numa_node = NUMA_NO_NODE;
+	else if (r5_numa_node > (num_online_nodes() - 1))
+		r5_numa_node = num_online_nodes() - 1;
+
 	register_md_personality(&raid6_personality);
 	register_md_personality(&raid5_personality);
 	register_md_personality(&raid4_personality);
-- 
2.7.4



