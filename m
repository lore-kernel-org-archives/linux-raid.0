From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH RFC 4/4] md: delayed stripe activation
Date: Tue, 10 Apr 2007 23:00:41 -0700
Message-ID: <20070411060041.15745.24375.stgit@dwillia2-linux.ch.intel.com>
References: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

based on a patch by: Raz Ben-Jehuda(caro) <raziebe@gmail.com>
---

 drivers/md/raid5.c         |   92 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/raid/raid5.h |    5 ++
 2 files changed, 90 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1a2d6b5..1b3db16 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -226,6 +226,8 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 	sh->sector = sector;
 	sh->pd_idx = pd_idx;
 	sh->state = 0;
+	sh->active_preread_jiffies = msecs_to_jiffies(
+		atomic_read(&conf->cache_policy->deadline_ms))+jiffies;
 
 	sh->disks = disks;
 
@@ -1172,6 +1174,7 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 	
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
+	sh->active_preread_jiffies = jiffies;
 	release_stripe(sh);
 	return 0;
 }
@@ -1741,8 +1744,10 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		bip = &sh->dev[dd_idx].towrite;
 		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
 			firstwrite = 1;
-	} else
+	} else {
 		bip = &sh->dev[dd_idx].toread;
+		sh->active_preread_jiffies = jiffies;
+	}
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
@@ -2160,7 +2165,7 @@ raid5_wt_cache_handle_new_writes(struct stripe_head *sh, struct stripe_head_stat
 	}
 }
 
-static void raid5_wt_cache_activate_delayed(raid5_conf_t *conf)
+static struct stripe_head *raid5_wt_cache_activate_delayed(raid5_conf_t *conf)
 {
 	struct stripe_cache_policy *cp = conf->cache_policy;
 	if (atomic_read(&cp->preread_active_stripes) < IO_THRESHOLD) {
@@ -2168,6 +2173,20 @@ static void raid5_wt_cache_activate_delayed(raid5_conf_t *conf)
 			struct list_head *l = cp->delayed_list.next;
 			struct stripe_head *sh;
 			sh = list_entry(l, struct stripe_head, lru);
+
+			if (time_before(jiffies,sh->active_preread_jiffies)) {
+				PRINTK("deadline: no expire sec=%lld %8u %8u\n",
+		               		(unsigned long long) sh->sector,
+               			jiffies_to_msecs(sh->active_preread_jiffies),
+               			jiffies_to_msecs(jiffies));
+				return sh;
+      			} else {
+			      PRINTK("deadline: expire:sec=%lld %8u %8u\n",
+	               			(unsigned long long)sh->sector,
+        	       			jiffies_to_msecs(sh->active_preread_jiffies),
+               			jiffies_to_msecs(jiffies));
+			}
+
 			list_del_init(l);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
@@ -2175,9 +2194,11 @@ static void raid5_wt_cache_activate_delayed(raid5_conf_t *conf)
 			list_add_tail(&sh->lru, &conf->handle_list);
 		}
 	}
+
+	return NULL;
 }
 
-static void raid5_wt_cache_raid5d(mddev_t *mddev, raid5_conf_t *conf)
+static struct stripe_head *raid5_wt_cache_raid5d(mddev_t *mddev, raid5_conf_t *conf)
 {
 	struct stripe_cache_policy *cp = conf->cache_policy;
 
@@ -2185,7 +2206,9 @@ static void raid5_wt_cache_raid5d(mddev_t *mddev, raid5_conf_t *conf)
 	    atomic_read(&cp->preread_active_stripes) < IO_THRESHOLD &&
 	    !blk_queue_plugged(mddev->queue) &&
 	    !list_empty(&cp->delayed_list))
-		raid5_wt_cache_activate_delayed(conf);
+		return raid5_wt_cache_activate_delayed(conf);
+
+	return NULL;
 }
 
 static void raid5_wt_cache_init(raid5_conf_t *conf)
@@ -4339,7 +4362,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
  */
 static void raid5d (mddev_t *mddev)
 {
-	struct stripe_head *sh;
+	struct stripe_head *sh,*delayed_sh=NULL;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	int handled;
 
@@ -4363,7 +4386,10 @@ static void raid5d (mddev_t *mddev)
 		}
 
 		if (conf->cache_policy->raid5d)
-			conf->cache_policy->raid5d(mddev, conf);
+			delayed_sh = conf->cache_policy->raid5d(mddev, conf);
+
+		if (delayed_sh)
+			break;
 
 		while ((bio = remove_bio_from_retry(conf))) {
 			int ok;
@@ -4401,8 +4427,60 @@ static void raid5d (mddev_t *mddev)
 	unplug_slaves(mddev);
 
 	PRINTK("--- raid5d inactive\n");
+
+ 	if (delayed_sh) {
+		unsigned long local_jiffies = jiffies, wakeup;
+		if (delayed_sh->active_preread_jiffies > local_jiffies) {
+	   		wakeup = delayed_sh->active_preread_jiffies - local_jiffies;
+	   		PRINTK("--- raid5d inactive sleep for %d\n",
+	            		jiffies_to_msecs(wakeup) );
+	     		mddev->thread->timeout = wakeup;
+		}
+  	}
+}
+
+static ssize_t
+raid5_show_stripe_deadline(mddev_t *mddev, char *page)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	if (conf)
+		return sprintf(page, "%d\n",
+			atomic_read(&conf->cache_policy->deadline_ms));
+	else
+		return 0;
+}
+ 
+static ssize_t
+raid5_store_stripe_deadline(mddev_t *mddev, const char *page, size_t len)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	char *end;
+	int new;
+	
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+	
+	new = simple_strtoul(page, &end, 10);
+	
+	if (!*page || (*end && *end != '\n') )
+		return -EINVAL;
+	
+	if (new < 0 || new > 10000)
+		return -EINVAL;
+	
+	atomic_set(&conf->cache_policy->deadline_ms,new);
+	
+	return len;
 }
 
+static struct md_sysfs_entry
+raid5_stripe_deadline = __ATTR(stripe_deadline, S_IRUGO | S_IWUSR,
+                                raid5_show_stripe_deadline,
+                               raid5_store_stripe_deadline);
+
+
 static ssize_t
 raid5_show_stripe_cache_size(mddev_t *mddev, char *page)
 {
@@ -4465,6 +4543,7 @@ raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
+	&raid5_stripe_deadline.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -4581,6 +4660,7 @@ static int run(mddev_t *mddev)
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
 	conf->cache_policy->init(conf);
+	atomic_set(&conf->cache_policy->deadline_ms, 0);
 
 	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
 
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 560d460..d447807 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -166,6 +166,7 @@ struct stripe_head {
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
 	int			write_requests_pending;
+	unsigned long   	active_preread_jiffies;
 	struct stripe_operations {
 		unsigned long	   pending;  /* pending operations (set for request->issue->complete) */
 		unsigned long	   ack;	     /* submitted operations (set for issue->complete */
@@ -353,7 +354,8 @@ struct stripe_cache_policy {
 	 * wt: check for stripes that can be taken off the delayed list
 	 * wb: n/a
 	 */
-	void (*raid5d)(mddev_t *mddev, struct raid5_private_data *conf);
+	struct stripe_head *(*raid5d)(mddev_t *mddev,
+		struct raid5_private_data *conf);
 	/* init
 	 * wt: initialize 'delayed_list' and 'preread_active_stripes'
 	 * wb: initialize 'dirty_list' and 'dirty_stripes'
@@ -380,6 +382,7 @@ struct stripe_cache_policy {
 		atomic_t preread_active_stripes;
 		atomic_t evict_active_stripes;
 	};
+	atomic_t deadline_ms;
 };
 
 struct raid5_private_data {
