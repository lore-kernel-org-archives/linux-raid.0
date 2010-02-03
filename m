From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 1/3] md:Add support for Raid0->Raid5 takeover
Date: Wed, 3 Feb 2010 11:59:44 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01DCD35B@irsmsx002.ger.corp.intel.com>
References: <F2A46F4A087B8547923AD59C289DC90E01D16226@irsmsx002.ger.corp.intel.com>
 <20100201105806.62e4dd94@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100201105806.62e4dd94@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> 
> This is wrong.  The chunksize for RAID5 must be exactly the same as the
> chunksize for RAID0.  There is no place for guessing.
> 
> 
> 
> I would rather you just look inside the raid0_private_data to see tha
> nr_strip_zones is zero.
>

Both are fixed now.

Maciek Trela.
 


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid5.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e84204e..2b99ad8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -52,6 +52,7 @@
 #include <linux/cpu.h>
 #include "md.h"
 #include "raid5.h"
+#include "raid0.h"
 #include "bitmap.h"
 
 /*
@@ -5614,6 +5615,27 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 }
 
 
+static void *raid5_takeover_raid0(mddev_t *mddev)
+{
+
+	if (mddev->degraded > 0) {
+	    printk(KERN_ERR "ERROR: Raid0 with degraded disks!: %d\n", mddev->degraded);
+		return ERR_PTR(-EINVAL);
+	}
+	
+	mddev->new_level = 5;
+	mddev->new_layout = ALGORITHM_PARITY_N;
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	mddev->degraded++;
+	mddev->raid_disks++;
+	mddev->delta_disks++;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	return setup_conf(mddev);
+}
+
+
 static void *raid5_takeover_raid1(mddev_t *mddev)
 {
 	int chunksect;
@@ -5737,12 +5759,23 @@ static int raid6_check_reshape(mddev_t *mddev)
 
 static void *raid5_takeover(mddev_t *mddev)
 {
+	struct raid0_private_data *raid0_priv;
+
 	/* raid5 can take over:
 	 *  raid0 - if all devices are the same - make it a raid4 layout
 	 *  raid1 - if there are two drives.  We need to know the chunk size
 	 *  raid4 - trivial - just use a raid4 layout.
 	 *  raid6 - Providing it is a *_6 layout
 	 */
+	if (mddev->level == 0) {
+		/* for raid0 takeover only one zone is supported */
+		raid0_priv = (struct raid0_private_data*)(mddev->private);
+		if (raid0_priv->nr_strip_zones > 1) {
+				printk("error: cannot takeover raid 0 with more than one zone.\n");
+				return ERR_PTR(-EINVAL);
+		}
+		return raid5_takeover_raid0(mddev);
+	}
 
 	if (mddev->level == 1)
 		return raid5_takeover_raid1(mddev);
-- 
1.6.3.3

