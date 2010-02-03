From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 4/4] md: Enable takeover for external metadata
Date: Wed, 3 Feb 2010 12:29:53 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01DCD389@irsmsx002.ger.corp.intel.com>
References: <F2A46F4A087B8547923AD59C289DC90E01D16228@irsmsx002.ger.corp.intel.com>
 <20100201110829.5516c80e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100201110829.5516c80e@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


This is one more patch for md takeover that was accidentally skipped while sending...
Please, apply it together with the rest of md takeover patches.

Now md will notify mdmon about the level change.
Also sysfs redundancy_group specific to non-raid0 is now handled when switching personalities.

Regards,
Maciek Trela.


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/md.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index dd3dfe4..ea1aeb4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2358,6 +2358,10 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			return err;
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		sysfs_remove_link(&rdev->mddev->kobj, nm);
+
+		/* indicate disk removal */
+		rdev->raid_disk = -1;
+
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
 	} else if (rdev->mddev->pers) {
@@ -2887,6 +2891,9 @@ level_show(mddev_t *mddev, char *page)
 		return 0;
 }
 
+
+static struct attribute_group md_redundancy_group;
+
 static ssize_t
 level_store(mddev_t *mddev, const char *buf, size_t len)
 {
@@ -2980,6 +2987,26 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 			rdev->raid_disk = -1;
 			clear_bit(In_sync, &rdev->flags);
 		}
+
+	/* if changed from Raid0 to other personality 
+	 * show the redundancy group
+	 */
+	if ((mddev->level == 0) && (pers->sync_request))
+	{
+		if (sysfs_create_group(&mddev->kobj, &md_redundancy_group))
+			printk(KERN_WARNING
+			       "md: cannot register extra attributes for %s\n",
+			       mdname(mddev));
+		mddev->sysfs_action = sysfs_get_dirent(mddev->kobj.sd, "sync_action");
+	} 
+	
+	/* if changed from other personality to Raid0
+	 * remove the redundancy group
+	 */
+	if (mddev->new_level == 0) {
+		sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
+	}
+
 	mddev->pers = pers;
 	mddev->private = priv;
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
@@ -2987,11 +3014,21 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	mddev->layout = mddev->new_layout;
 	mddev->chunk_sectors = mddev->new_chunk_sectors;
 	mddev->delta_disks = 0;
+
+	/* FIXME: For external metadata max_disks are not supported now
+	 * so in this case set this to some resonable value.
+	 */
+	if (mddev->max_disks == 0) {	
+		mddev->max_disks = 32;
+	}
+	
 	pers->run(mddev);
 	mddev_resume(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->thread);	
+	sysfs_notify(&mddev->kobj, NULL, "level");	
+
 	return rv;
 }
 
-- 
1.6.3.3

