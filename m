From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 3/3] md: Add support for Raid0->Raid10 takeover
Date: Wed, 3 Feb 2010 12:16:49 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01DCD373@irsmsx002.ger.corp.intel.com>
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

> 
> You are confusing raid_disk with near_copies.  They are very different
> things.
> 
> Presumably you want to make 'near_copies' always be 2.
> 

Fixed.
Also I've changed the check for multiply zones as in raid5 patch.

Maciek Trela.


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid10.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d119b7b..9e2068c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -23,6 +23,7 @@
 #include <linux/seq_file.h>
 #include "md.h"
 #include "raid10.h"
+#include "raid0.h"
 #include "bitmap.h"
 
 /*
@@ -2177,13 +2178,20 @@ static int run(mddev_t *mddev)
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
@@ -2377,6 +2385,74 @@ static void raid10_quiesce(mddev_t *mddev, int state)
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
+	/* new layout: far_copies = 1, near_copies = 2 */
+	mddev->new_layout = (1<<8) + 2;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
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
+	struct raid0_private_data *raid0_priv;
+
+	/* raid10 can take over:
+	 *  raid0 - providing it has only two drives
+	 */
+	if (mddev->level == 0) {
+		/* for raid0 takeover only one zone is supported */
+		raid0_priv = (struct raid0_private_data*)(mddev->private);
+		if (raid0_priv->nr_strip_zones > 1) {
+				printk("error: cannot takeover raid 0 with more than one zone.\n");
+				return ERR_PTR(-EINVAL);
+		}
+	    return raid10_takeover_raid0(mddev);
+	}	
+	return ERR_PTR(-EINVAL);
+}
+
 static struct mdk_personality raid10_personality =
 {
 	.name		= "raid10",
@@ -2393,6 +2469,7 @@ static struct mdk_personality raid10_personality =
 	.sync_request	= sync_request,
 	.quiesce	= raid10_quiesce,
 	.size		= raid10_size,
+	.takeover	= raid10_takeover,
 };
 
 static int __init raid_init(void)
-- 
1.6.3.3

