From: Jinzc <zhenchengjin@gmail.com>
Subject: [PATCH] md: set the md raid 4,5,6  thead name by its level
Date: Wed, 16 Sep 2009 16:54:57 +0800
Message-ID: <1253091297-3889-1-git-send-email-zhenchengjin@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757980AbZIPIyA@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jinzc <zhenchengjin@gmail.com>
List-Id: linux-raid.ids

the current edition, if you create a md raid 4,5,6
the name of md thread is mdx_raid5. If you create a raid 4,6
the name mdx_raid4, mdx_raid6 are better than mdx_raid5.

Signed-off-by: Jinzc <zhenchengjin@gmail.com>
---
 drivers/md/raid5.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b8a2c5d..f78f711 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4334,6 +4334,7 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 	int raid_disk, memory;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
+	char thread_name[64];
 
 	if (mddev->new_level != 5
 	    && mddev->new_level != 4
@@ -4447,10 +4448,12 @@ static raid5_conf_t *setup_conf(mddev_t *mddev)
 		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
 			memory, mdname(mddev));
 
-	conf->thread = md_register_thread(raid5d, mddev, "%s_raid5");
+	sprintf(thread_name, "%%s_raid%d", conf->level);
+	conf->thread = md_register_thread(raid5d, mddev, thread_name);
+
 	if (!conf->thread) {
 		printk(KERN_ERR
-		       "raid5: couldn't allocate thread for %s\n",
+		       "raid%d: couldn't allocate thread for %s\n", conf->level,
 		       mdname(mddev));
 		goto abort;
 	}
-- 
1.6.1.3
