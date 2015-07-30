From: Shaohua Li <shli@fb.com>
Subject: [PATCH 8/9] raid5: enable log for raid array with cache disk
Date: Wed, 29 Jul 2015 17:38:48 -0700
Message-ID: <95a6f4870cf351a0b05b681e358da7182e0c59a8.1438215986.git.shli@fb.com>
References: <cover.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Now log is safe to enable for raid array with cache disk

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b694d06..26ea100 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6309,8 +6309,11 @@ static void raid5_free_percpu(struct r5conf *conf)
 
 static void free_conf(struct r5conf *conf)
 {
+	if (conf->log)
+		r5l_exit_log(conf->log);
 	if (conf->shrinker.seeks)
 		unregister_shrinker(&conf->shrinker);
+
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
@@ -6954,6 +6957,16 @@ static int run(struct mddev *mddev)
 						mddev->queue);
 	}
 
+	rdev_for_each(rdev, mddev) {
+		if (test_bit(WriteCache, &rdev->flags)) {
+			char b[BDEVNAME_SIZE];
+			printk(KERN_INFO"md/raid:%s: using device %s as cache\n",
+				mdname(mddev), bdevname(rdev->bdev, b));
+			r5l_init_log(conf, rdev);
+			break;
+		}
+	}
+
 	return 0;
 abort:
 	md_unregister_thread(&mddev->thread);
-- 
1.8.5.6

