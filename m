From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 28/54] md/raid5: Rename a jump label in setup_conf()
Date: Thu, 6 Oct 2016 11:28:02 +0200
Message-ID: <2737d401-3606-d4c7-c930-5d7a425e5e84@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 08:18:38 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 17f50a6..b624ba6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6490,8 +6490,10 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		conf->group_cnt = group_cnt;
 		conf->worker_cnt_per_group = worker_cnt_per_group;
 		conf->worker_groups = new_group;
-	} else
-		goto abort;
+	} else {
+		goto free_conf;
+	}
+
 	spin_lock_init(&conf->device_lock);
 	seqcount_init(&conf->gen_lock);
 	mutex_init(&conf->cache_size_mutex);
@@ -6518,12 +6520,12 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	max_disks = max(conf->raid_disks, conf->previous_raid_disks);
 	conf->disks = kcalloc(max_disks, sizeof(*conf->disks), GFP_KERNEL);
 	if (!conf->disks)
-		goto abort;
+		goto free_conf;
 
 	conf->mddev = mddev;
 
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
-		goto abort;
+		goto free_conf;
 
 	/* We init hash_locks[0] separately to that it can be used
 	 * as the reference lock in the spin_lock_nest_lock() call
@@ -6543,7 +6545,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	conf->level = mddev->new_level;
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	if (raid5_alloc_percpu(conf) != 0)
-		goto abort;
+		goto free_conf;
 
 	pr_debug("raid456: run(%s) called.\n", mdname(mddev));
 
@@ -6556,11 +6558,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 		if (test_bit(Replacement, &rdev->flags)) {
 			if (disk->replacement)
-				goto abort;
+				goto free_conf;
 			disk->replacement = rdev;
 		} else {
 			if (disk->rdev)
-				goto abort;
+				goto free_conf;
 			disk->rdev = rdev;
 		}
 
@@ -6613,7 +6615,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate %dkB for buffers\n",
 		       mdname(mddev), memory);
-		goto abort;
+		goto free_conf;
 	} else
 		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
 		       mdname(mddev), memory);
@@ -6631,7 +6633,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't register shrinker.\n",
 		       mdname(mddev));
-		goto abort;
+		goto free_conf;
 	}
 
 	sprintf(pers_name, "raid%d", mddev->new_level);
@@ -6640,12 +6642,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		printk(KERN_ERR
 		       "md/raid:%s: couldn't allocate thread.\n",
 		       mdname(mddev));
-		goto abort;
+		goto free_conf;
 	}
 
 	return conf;
-
- abort:
+free_conf:
 	free_conf(conf);
 	return ERR_PTR(-EIO);
 }
-- 
2.10.1
