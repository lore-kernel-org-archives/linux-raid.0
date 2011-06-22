From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/5] md/raid5: use kmem_cache_zalloc()
Date: Wed, 22 Jun 2011 13:50:26 +0900
Message-ID: <1308718230-2536-2-git-send-email-namhyung@gmail.com>
References: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308718230-2536-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Replace kmem_cache_alloc + memset(,0,) to kmem_cache_zalloc.
I think it's not harmful since @conf->slab_cache already knows
actual size of struct stripe_head.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b72edf35ec54..0f71aa9a07c5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1315,10 +1315,10 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
-	sh = kmem_cache_alloc(conf->slab_cache, GFP_KERNEL);
+	sh = kmem_cache_zalloc(conf->slab_cache, GFP_KERNEL);
 	if (!sh)
 		return 0;
-	memset(sh, 0, sizeof(*sh) + (conf->pool_size-1)*sizeof(struct r5dev));
+
 	sh->raid_conf = conf;
 	spin_lock_init(&sh->lock);
 	#ifdef CONFIG_MULTICORE_RAID456
@@ -1435,12 +1435,10 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 		return -ENOMEM;
 
 	for (i = conf->max_nr_stripes; i; i--) {
-		nsh = kmem_cache_alloc(sc, GFP_KERNEL);
+		nsh = kmem_cache_zalloc(sc, GFP_KERNEL);
 		if (!nsh)
 			break;
 
-		memset(nsh, 0, sizeof(*nsh) + (newsize-1)*sizeof(struct r5dev));
-
 		nsh->raid_conf = conf;
 		spin_lock_init(&nsh->lock);
 		#ifdef CONFIG_MULTICORE_RAID456
-- 
1.7.5.2

