From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 3/3] md: Add support for Raid0->Raid10 takeover
Date: Fri, 29 Jan 2010 14:54:21 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01D16228@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid10.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d119b7b..5b7cda6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2177,13 +2177,20 @@ static int run(mddev_t *mddev)
 	 * bookkeeping area. [whatever we allocate in run(),
 	 * should be freed in stop()]
 	 */
-	conf = kzalloc(sizeof(conf_t), GFP_KERNEL);
-	mddev->private = conf;
-	if (!conf) {
-		printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
-			mdname(mddev));
-		goto out;
-	}
+
+	if (mddev->private == NULL)
+	{
+		conf = kzalloc(sizeof(conf_t), GFP_KERNEL);
+		mddev->private = conf;
+		if (!conf) {
+			printk(KERN_ERR "raid10: couldn't allocate memory for %s\n",
+				   mdname(mddev));
+			goto out;
+		}
+	} else 
+	    conf = mddev->private;
+	
+	
 	conf->mirrors = kzalloc(sizeof(struct mirror_info)*mddev->raid_disks,
 				 GFP_KERNEL);
 	if (!conf->mirrors) {
@@ -2377,6 +2384,80 @@ static void raid10_quiesce(mddev_t *mddev, int state)
 	}
 }
 
+static conf_t *setup_conf(mddev_t *mddev)
+{
+	conf_t *conf;
+	
+	conf = kzalloc(sizeof(conf_t), GFP_KERNEL);
+	if (conf == NULL)
+		goto abort;
+	
+	return conf;
+	
+ abort:
+	if (conf) {
+		kfree(conf);
+		return ERR_PTR(-EIO);
+	} else
+		return ERR_PTR(-ENOMEM);
+}
+
+static void *raid10_takeover_raid0(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+
+	if (mddev->degraded > 0)
+	{
+	    printk(KERN_ERR "error: degraded raid0!\n");
+		return ERR_PTR(-EINVAL);
+	}
+	
+	/* Update slot numbers to obtain 
+	 * degraded raid10 with missing mirrors
+	 */
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		rdev->raid_disk *= 2;
+	}
+	
+	/* Set new parameters */
+	mddev->new_level = 10;
+	/* new layout: far_copies = 1, 
+       near_copies = raid0->raid_disks */
+	mddev->new_layout = (1<<8) + mddev->raid_disks;
+	mddev->delta_disks = mddev->raid_disks;
+	mddev->degraded = mddev->raid_disks;
+	mddev->raid_disks *= 2;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	return setup_conf(mddev);
+}
+
+static void *raid10_takeover(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	sector_t sectors, dev_sectors;
+
+	/* raid10 can take over:
+	 *  raid0 - providing it has only two drives
+	 */
+	if (mddev->level == 0) {
+		/* make sure all devices are the same (only one zone is supported) */
+		sectors = mddev->dev_sectors;
+		sector_div(sectors, mddev->chunk_sectors);
+		list_for_each_entry(rdev, &mddev->disks, same_set) {
+			dev_sectors = rdev->sectors;
+			sector_div(dev_sectors, mddev->chunk_sectors);
+			if (dev_sectors != sectors) {
+				printk("error: cannot takeover raid 0 with different dev sizes.\n");
+				return ERR_PTR(-EINVAL);
+			}
+		}
+	    return raid10_takeover_raid0(mddev);
+	}	
+	return ERR_PTR(-EINVAL);
+}
+
 static struct mdk_personality raid10_personality =
 {
 	.name		= "raid10",
@@ -2393,6 +2474,7 @@ static struct mdk_personality raid10_personality =
 	.sync_request	= sync_request,
 	.quiesce	= raid10_quiesce,
 	.size		= raid10_size,
+	.takeover	= raid10_takeover,
 };
 
 static int __init raid_init(void)
-- 
1.6.3.3



