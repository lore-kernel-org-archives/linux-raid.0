From: Shaohua Li <shli@fb.com>
Subject: [patch v2 11/11] raid5: enable log for raid array with cache disk
Date: Thu, 13 Aug 2015 14:32:04 -0700
Message-ID: <277d6d42c96535c4aa2f0c8970c1551f2a27a8ca.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Now log is safe to enable for raid array with cache disk

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c             | 10 ++++++++++
 include/uapi/linux/raid/md_p.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 343536d..28cccfa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6325,8 +6325,11 @@ static void raid5_free_percpu(struct r5conf *conf)
 
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
@@ -6990,6 +6993,13 @@ static int run(struct mddev *mddev)
 						mddev->queue);
 	}
 
+	if (journal_dev) {
+		char b[BDEVNAME_SIZE];
+		printk(KERN_INFO"md/raid:%s: using device %s as journal\n",
+			mdname(mddev), bdevname(journal_dev->bdev, b));
+		r5l_init_log(conf, journal_dev);
+	}
+
 	return 0;
 abort:
 	md_unregister_thread(&mddev->thread);
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 3553a72..1de9e17 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -320,6 +320,7 @@ struct mdp_superblock_1 {
 					|MD_FEATURE_RESHAPE_BACKWARDS	\
 					|MD_FEATURE_NEW_OFFSET		\
 					|MD_FEATURE_RECOVERY_BITMAP	\
+					|MD_FEATURE_JOURNAL		\
 					)
 
 struct r5l_payload_header {
-- 
1.8.1

