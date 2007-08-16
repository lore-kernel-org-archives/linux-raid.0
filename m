From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 2] md: Correctly update sysfs when a raid1 is reshaped.
Date: Thu, 16 Aug 2007 10:38:45 +1000
Message-ID: <1070816003845.32736@suse.de>
References: <20070816103626.32539.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When a raid1 array is reshaped (number of drives changed),
the list of devices is compacted, so that slots for missing
devices are filled with working devices from later slots.
This requires the "rd%d" symlinks in sysfs to be updated.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-08-16 10:27:57.000000000 +1000
+++ ./drivers/md/raid1.c	2007-08-16 10:29:58.000000000 +1000
@@ -2154,11 +2154,25 @@ static int raid1_reshape(mddev_t *mddev)
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
 
-	for (d=d2=0; d < conf->raid_disks; d++)
-		if (conf->mirrors[d].rdev) {
-			conf->mirrors[d].rdev->raid_disk = d2;
-			newmirrors[d2++].rdev = conf->mirrors[d].rdev;
+	for (d = d2 = 0; d < conf->raid_disks; d++) {
+		mdk_rdev_t *rdev = conf->mirrors[d].rdev;
+		if (rdev && rdev->raid_disk != d2) {
+			char nm[20];
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			sysfs_remove_link(&mddev->kobj, nm);
+			rdev->raid_disk = d2;
+			sprintf(nm, "rd%d", rdev->raid_disk);
+			sysfs_remove_link(&mddev->kobj, nm);
+			if (sysfs_create_link(&mddev->kobj,
+					      &rdev->kobj, nm))
+				printk(KERN_WARNING
+				       "md/raid1: cannot register "
+				       "%s for %s\n",
+				       nm, mdname(mddev));
 		}
+		if (rdev)
+			newmirrors[d2++].rdev = rdev;
+	}
 	kfree(conf->mirrors);
 	conf->mirrors = newmirrors;
 	kfree(conf->poolinfo);
