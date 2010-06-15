From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 1/3] md: fix raid10 takeover: use new_layout for setup_conf
Date: Tue, 15 Jun 2010 09:34:51 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E8734AA@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

When performing raid0->raid10 takeover setup_conf() is called for initializing private raid10 config.
setup_conf() should use a new layout instead of
mddev->layout when taking over.
Added a new parameter layout to setup_conf().
---
 drivers/md/raid10.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c index 0372499..a027672 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2154,7 +2154,7 @@ raid10_size(mddev_t *mddev, sector_t sectors, int raid_disks)  }
 
 
-static conf_t *setup_conf(mddev_t *mddev)
+static conf_t *setup_conf(mddev_t *mddev, int layout)
 {
 	conf_t *conf = NULL;
 	int nc, fc, fo;
@@ -2169,14 +2169,14 @@ static conf_t *setup_conf(mddev_t *mddev)
 		goto out;
 	}
 
-	nc = mddev->layout & 255;
-	fc = (mddev->layout >> 8) & 255;
-	fo = mddev->layout & (1<<16);
+	nc = layout & 255;
+	fc = (layout >> 8) & 255;
+	fo = layout & (1<<16);
 
 	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
-	    (mddev->layout >> 17)) {
+	    (layout >> 17)) {
 		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
-		       mdname(mddev), mddev->layout);
+		       mdname(mddev), layout);
 		goto out;
 	}
 
@@ -2273,7 +2273,7 @@ static int run(mddev_t *mddev)
 	 */
 
 	if (mddev->private == NULL) {
-		conf = setup_conf(mddev);
+		conf = setup_conf(mddev, mddev->layout);
 		if (IS_ERR(conf))
 			return PTR_ERR(conf);
 		mddev->private = conf;
@@ -2453,7 +2453,7 @@ static void *raid10_takeover_raid0(mddev_t *mddev)
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
 
-	conf = setup_conf(mddev);
+	conf = setup_conf(mddev, mddev->new_layout);
 	conf->scale_disks = 2;
 	return conf;
 }

