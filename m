From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 7] md: Give userspace control over removing failed devices when external metdata in use
Date: Fri, 14 Dec 2007 17:26:16 +1100
Message-ID: <1071214062616.1835@suse.de>
References: <20071214171950.1308.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When a device fails, we must not allow an further writes to the array
until the device failure has been recorded in array metadata.
When metadata is managed externally, this requires some synchronisation...

Allow/require userspace to explicitly remove failed devices
from active service in the array by writing 'none' to the 'slot'
attribute.  If this reduces the number of failed devices to 0,
the write block will automatically be lowered.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-12-14 16:08:28.000000000 +1100
+++ ./drivers/md/md.c	2007-12-14 16:08:52.000000000 +1100
@@ -1894,20 +1894,44 @@ static ssize_t
 slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	char *e;
+	int err;
+	char nm[20];
 	int slot = simple_strtoul(buf, &e, 10);
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
 	else if (e==buf || (*e && *e!= '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
-		/* Cannot set slot in active array (yet) */
-		return -EBUSY;
-	if (slot >= rdev->mddev->raid_disks)
-		return -ENOSPC;
-	rdev->raid_disk = slot;
-	/* assume it is working */
-	rdev->flags = 0;
-	set_bit(In_sync, &rdev->flags);
+	if (rdev->mddev->pers) {
+		/* Setting 'slot' on an active array requires also
+		 * updating the 'rd%d' link, and communicating
+		 * with the personality with ->hot_*_disk.
+		 * For now we only support removing
+		 * failed/spare devices.  This normally happens automatically,
+		 * but not when the metadata is externally managed.
+		 */
+		if (slot != -1)
+			return -EBUSY;
+		if (rdev->raid_disk == -1)
+			return -EEXIST;
+		/* personality does all needed checks */
+		if (rdev->mddev->pers->hot_add_disk == NULL)
+			return -EINVAL;
+		err = rdev->mddev->pers->
+			hot_remove_disk(rdev->mddev, rdev->raid_disk);
+		if (err)
+			return err;
+		sprintf(nm, "rd%d", rdev->raid_disk);
+		sysfs_remove_link(&rdev->mddev->kobj, nm);
+		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
+		md_wakeup_thread(rdev->mddev->thread);
+	} else {
+		if (slot >= rdev->mddev->raid_disks)
+			return -ENOSPC;
+		rdev->raid_disk = slot;
+		/* assume it is working */
+		rdev->flags = 0;
+		set_bit(In_sync, &rdev->flags);
+	}
 	return len;
 }
 
@@ -5551,6 +5575,7 @@ static int remove_and_add_spares(mddev_t
 
 	ITERATE_RDEV(mddev,rdev,rtmp)
 		if (rdev->raid_disk >= 0 &&
+		    !mddev->external &&
 		    (test_bit(Faulty, &rdev->flags) ||
 		     ! test_bit(In_sync, &rdev->flags)) &&
 		    atomic_read(&rdev->nr_pending)==0) {
