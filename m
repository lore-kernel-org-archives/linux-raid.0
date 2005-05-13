From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 2] Cause md/raid1 to "repack" working devices when number of drives is changed.
Date: Fri, 13 May 2005 14:51:35 +1000
Message-ID: <E1DWS99-00014K-DW@notabene.cse.unsw.edu.au>
References: <20050513144946.4066.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


i.e. missing or failed drives are moved to the end of the list.
The means a 3 drive md array with the first drive missing can be shrunk
to a two drive array.  Currently that isn't possible.

Also, the "last_used" device number might be out-of-range after the number
of devices is reduced, so we set it to 0.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-05-13 14:47:35.000000000 +1000
+++ ./drivers/md/raid1.c	2005-05-13 14:47:44.000000000 +1000
@@ -1485,17 +1485,26 @@ static int raid1_reshape(mddev_t *mddev,
 	 * We allocate a new r1bio_pool if we can.
 	 * Then raise a device barrier and wait until all IO stops.
 	 * Then resize conf->mirrors and swap in the new r1bio pool.
+	 *
+	 * At the same time, we "pack" the devices so that all the missing
+	 * devices have the higher raid_disk numbers.
 	 */
 	mempool_t *newpool, *oldpool;
 	struct pool_info *newpoolinfo;
 	mirror_info_t *newmirrors;
 	conf_t *conf = mddev_to_conf(mddev);
+	int cnt;
 
-	int d;
+	int d, d2;
 
-	for (d= raid_disks; d < conf->raid_disks; d++)
-		if (conf->mirrors[d].rdev)
+	if (raid_disks < conf->raid_disks) {
+		cnt=0;
+		for (d= 0; d < conf->raid_disks; d++)
+			if (conf->mirrors[d].rdev)
+				cnt++;
+		if (cnt > raid_disks)
 			return -EBUSY;
+	}
 
 	newpoolinfo = kmalloc(sizeof(*newpoolinfo), GFP_KERNEL);
 	if (!newpoolinfo)
@@ -1526,8 +1535,12 @@ static int raid1_reshape(mddev_t *mddev,
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
-	for (d=0; d < raid_disks && d < conf->raid_disks; d++)
-		newmirrors[d] = conf->mirrors[d];
+
+	for (d=d2=0; d < conf->raid_disks; d++)
+		if (conf->mirrors[d].rdev) {
+			conf->mirrors[d].rdev->raid_disk = d2;
+			newmirrors[d2++].rdev = conf->mirrors[d].rdev;
+		}
 	kfree(conf->mirrors);
 	conf->mirrors = newmirrors;
 	kfree(conf->poolinfo);
@@ -1536,6 +1549,7 @@ static int raid1_reshape(mddev_t *mddev,
 	mddev->degraded += (raid_disks - conf->raid_disks);
 	conf->raid_disks = mddev->raid_disks = raid_disks;
 
+	conf->last_used = 0; /* just make sure it is in-range */
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier--;
 	spin_unlock_irq(&conf->resync_lock);
