From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 12/13] raid5: enable cache for raid array with cache disk
Date: Tue, 23 Jun 2015 14:38:02 -0700
Message-ID: <61dae8778a7a6ba6ee0f87298af6127c24503eef.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Now cache is safe to enable for raid array with cache disk, let's do it.
We set the raid array sector size to 4k, so there is no partial write
which current cache code can't handling. This should not a big problem
because main filesystems are ok with 4k sector size.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 75964e9..9faa5c6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6340,6 +6340,9 @@ static void free_conf(struct r5conf *conf)
 {
 	if (conf->shrinker.seeks)
 		unregister_shrinker(&conf->shrinker);
+	if (conf->cache)
+		r5c_exit_cache(conf->cache);
+
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
@@ -6980,6 +6983,23 @@ static int run(struct mddev *mddev)
 						mddev->queue);
 	}
 
+	rdev_for_each(rdev, mddev) {
+		if (test_bit(WriteCache, &rdev->flags)) {
+			char b[BDEVNAME_SIZE];
+			printk(KERN_INFO"md/raid:%s: using device %s as cache\n",
+				mdname(mddev), bdevname(rdev->bdev, b));
+			conf->cache = r5c_init_cache(conf, rdev);
+			break;
+		}
+	}
+
+	if (conf->cache) {
+		/* Make sure all write do overwite in current stage */
+		if (mddev->queue)
+			blk_queue_logical_block_size(mddev->queue, STRIPE_SIZE);
+		conf->skip_copy = 1;
+	}
+
 	return 0;
 abort:
 	md_unregister_thread(&mddev->thread);
-- 
1.8.1

