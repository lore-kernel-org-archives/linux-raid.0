From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH] md: raid0: Kfree() strip_zone and devlist in create_strip_zones().
Date: Thu, 14 May 2009 12:43:52 +0200
Message-ID: <1242297833-13908-6-git-send-email-maan@systemlinux.org>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

It's cleaner to kfree() these in the same function where they are
allocated. This allows to simplify raid0_run() a bit which will be
done in the next patch.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0f4330f..5ff6290 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -110,8 +110,10 @@ static int create_strip_zones (mddev_t *mddev)
 	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
 				conf->nr_strip_zones*mddev->raid_disks,
 				GFP_KERNEL);
-	if (!conf->devlist)
+	if (!conf->devlist) {
+		kfree(conf->strip_zone);
 		return -ENOMEM;
+	}
 
 	/* The first zone must contain all devices, so here we check that
 	 * there is a proper alignment of slots to devices and find them all
@@ -212,6 +214,8 @@ static int create_strip_zones (mddev_t *mddev)
 	printk(KERN_INFO "raid0: done.\n");
 	return 0;
 abort:
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
 	return -EINVAL;
 }
 
@@ -276,9 +280,7 @@ static int raid0_run(mddev_t *mddev)
 	if (!conf)
 		return -ENOMEM;
 	mddev->private = (void *)conf;
- 
-	conf->strip_zone = NULL;
-	conf->devlist = NULL;
+
 	ret = create_strip_zones(mddev);
 	if (ret < 0)
 		goto out_free_conf;
@@ -308,8 +310,6 @@ static int raid0_run(mddev_t *mddev)
 	return 0;
 
 out_free_conf:
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
 	kfree(conf);
 	mddev->private = NULL;
 	return ret;
-- 
1.5.4.3

