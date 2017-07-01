From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 4/5] raid10: add a 'r10_numa_node' module parameter
Date: Sat,  1 Jul 2017 15:20:57 +0800
Message-ID: <1498893658-18409-4-git-send-email-liuzhengyuan@kylinos.cn>
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
 drivers/md/raid10.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 305b0db..f49ab2a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -97,6 +97,8 @@
  */
 static int max_queued_requests = 1024;
 
+static int r10_numa_node = NUMA_NO_NODE;
+
 static void allow_barrier(struct r10conf *conf);
 static void lower_barrier(struct r10conf *conf);
 static int _enough(struct r10conf *conf, int previous, int ignore);
@@ -135,7 +137,7 @@ static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 
 	/* allocate a r10bio with room for raid_disks entries in the
 	 * bios array */
-	return kzalloc(size, gfp_flags);
+	return kzalloc_node(size, gfp_flags, r10_numa_node);
 }
 
 static void r10bio_pool_free(void *r10_bio, void *data)
@@ -179,7 +181,8 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 		nalloc_rp = nalloc;
 	else
 		nalloc_rp = nalloc * 2;
-	rps = kmalloc(sizeof(struct resync_pages) * nalloc_rp, gfp_flags);
+	rps = kmalloc_node(sizeof(struct resync_pages) * nalloc_rp, gfp_flags,
+							r10_numa_node);
 	if (!rps)
 		goto out_free_r10bio;
 
@@ -2801,7 +2804,8 @@ static int init_resync(struct r10conf *conf)
 	for (i = 0; i < conf->geo.raid_disks; i++)
 		if (conf->mirrors[i].replacement)
 			conf->have_replacement = 1;
-	conf->r10buf_pool = mempool_create(buffs, r10buf_pool_alloc, r10buf_pool_free, conf);
+	conf->r10buf_pool = mempool_create_node(buffs, r10buf_pool_alloc, r10buf_pool_free,
+						conf, GFP_KERNEL, r10_numa_node);
 	if (!conf->r10buf_pool)
 		return -ENOMEM;
 	conf->next_resync = 0;
@@ -3532,14 +3536,14 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	}
 
 	err = -ENOMEM;
-	conf = kzalloc(sizeof(struct r10conf), GFP_KERNEL);
+	conf = kzalloc_node(sizeof(struct r10conf), GFP_KERNEL, r10_numa_node);
 	if (!conf)
 		goto out;
 
 	/* FIXME calc properly */
-	conf->mirrors = kzalloc(sizeof(struct raid10_info)*(mddev->raid_disks +
+	conf->mirrors = kzalloc_node(sizeof(struct raid10_info)*(mddev->raid_disks +
 							    max(0,-mddev->delta_disks)),
-				GFP_KERNEL);
+				GFP_KERNEL, r10_numa_node);
 	if (!conf->mirrors)
 		goto out;
 
@@ -3549,8 +3553,9 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	conf->geo = geo;
 	conf->copies = copies;
-	conf->r10bio_pool = mempool_create(NR_RAID10_BIOS, r10bio_pool_alloc,
-					   r10bio_pool_free, conf);
+	conf->r10bio_pool = mempool_create_node(NR_RAID10_BIOS, r10bio_pool_alloc,
+					   r10bio_pool_free, conf,
+					   GFP_KERNEL, r10_numa_node);
 	if (!conf->r10bio_pool)
 		goto out;
 
@@ -3971,11 +3976,11 @@ static int raid10_check_reshape(struct mddev *mddev)
 	conf->mirrors_new = NULL;
 	if (mddev->delta_disks > 0) {
 		/* allocate new 'mirrors' list */
-		conf->mirrors_new = kzalloc(
+		conf->mirrors_new = kzalloc_node(
 			sizeof(struct raid10_info)
 			*(mddev->raid_disks +
 			  mddev->delta_disks),
-			GFP_KERNEL);
+			GFP_KERNEL, r10_numa_node);
 		if (!conf->mirrors_new)
 			return -ENOMEM;
 	}
@@ -4728,6 +4733,11 @@ static struct md_personality raid10_personality =
 
 static int __init raid_init(void)
 {
+	if (r10_numa_node < NUMA_NO_NODE)
+		r10_numa_node = NUMA_NO_NODE;
+	else if (r10_numa_node > (num_online_nodes() - 1))
+		r10_numa_node = num_online_nodes() - 1;
+
 	return register_md_personality(&raid10_personality);
 }
 
@@ -4745,3 +4755,5 @@ MODULE_ALIAS("md-raid10");
 MODULE_ALIAS("md-level-10");
 
 module_param(max_queued_requests, int, S_IRUGO|S_IWUSR);
+module_param(r10_numa_node, int, S_IRUGO);
+MODULE_PARM_DESC(r10_numa_node, "NUMA node for raid10 memory allocations");
-- 
2.7.4



