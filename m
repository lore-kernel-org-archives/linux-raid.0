From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 20] Use correct size of raid5 stripe cache when measuring how full it is.
Date: Mon, 12 Dec 2005 14:10:18 +1100
Message-ID: <1051212031018.4874@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The raid5 stripe cache was recently changed from fixed size
(NR_STRIPES) to variable size (conf->max_nr_stripes).  However there
are two places that still use the constant and as a result, reducing
the size of the stripe cache can result in a deadlock.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-12-12 10:45:16.000000000 +1100
+++ ./drivers/md/raid5.c	2005-12-12 10:45:24.000000000 +1100
@@ -96,7 +96,7 @@ static inline void __release_stripe(raid
 			list_add_tail(&sh->lru, &conf->inactive_list);
 			atomic_dec(&conf->active_stripes);
 			if (!conf->inactive_blocked ||
-			    atomic_read(&conf->active_stripes) < (NR_STRIPES*3/4))
+			    atomic_read(&conf->active_stripes) < (conf->max_nr_stripes*3/4))
 				wake_up(&conf->wait_for_stripe);
 		}
 	}
@@ -255,7 +255,8 @@ static struct stripe_head *get_active_st
 				conf->inactive_blocked = 1;
 				wait_event_lock_irq(conf->wait_for_stripe,
 						    !list_empty(&conf->inactive_list) &&
-						    (atomic_read(&conf->active_stripes) < (NR_STRIPES *3/4)
+						    (atomic_read(&conf->active_stripes)
+						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
 						    conf->device_lock,
 						    unplug_slaves(conf->mddev);
@@ -1915,7 +1916,7 @@ static int run(mddev_t *mddev)
 			goto abort;
 		}
 	}
-memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
+	memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
 		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	if (grow_stripes(conf, conf->max_nr_stripes)) {
 		printk(KERN_ERR 
