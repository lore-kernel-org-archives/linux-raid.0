From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 2] Remove attempt to use dynamic names in sysfs for component devices on an MD array.
Date: Mon, 31 Oct 2005 16:58:57 +1100
Message-ID: <1051031055857.8201@suse.de>
References: <20051031165552.8151.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


With version-0.90 superblock, component devices on an md device to not have any
stable name related to the array -(version-1 assigns a fixed index when a
device is added to an array, and this remains despit any hot-swap).

The intial code for making these devices appear in sysfs used
dynamic names, which would change whenever a hot-spare was swapped
for a failed or missing device.
This turns out not to be practical in sysfs for a number of reasons.

This patch changes then naming of component devices to be based on
the result of 'bdevname'.  This is stable and should be unique.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-31 15:48:07.000000000 +1100
+++ ./drivers/md/md.c	2005-10-31 15:54:59.000000000 +1100
@@ -762,7 +762,7 @@ static void super_90_sync(mddev_t *mddev
 	struct list_head *tmp;
 	mdk_rdev_t *rdev2;
 	int next_spare = mddev->raid_disks;
-	char nm[20];
+
 
 	/* make rdev->sb match mddev data..
 	 *
@@ -776,7 +776,6 @@ static void super_90_sync(mddev_t *mddev
 	 */
 	int i;
 	int active=0, working=0,failed=0,spare=0,nr_disks=0;
-	unsigned int fixdesc=0;
 
 	rdev->sb_size = MD_SB_BYTES;
 
@@ -830,16 +829,7 @@ static void super_90_sync(mddev_t *mddev
 			desc_nr = rdev2->raid_disk;
 		else
 			desc_nr = next_spare++;
-		if (desc_nr != rdev2->desc_nr) {
-			fixdesc |= (1 << desc_nr);
-			rdev2->desc_nr = desc_nr;
-			if (rdev2->raid_disk >= 0) {
-				sprintf(nm, "rd%d", rdev2->raid_disk);
-				sysfs_remove_link(&mddev->kobj, nm);
-			}
-			sysfs_remove_link(&rdev2->kobj, "block");
-			kobject_del(&rdev2->kobj);
-		}
+		rdev2->desc_nr = desc_nr;
 		d = &sb->disks[rdev2->desc_nr];
 		nr_disks++;
 		d->number = rdev2->desc_nr;
@@ -866,25 +856,6 @@ static void super_90_sync(mddev_t *mddev
 		if (test_bit(WriteMostly, &rdev2->flags))
 			d->state |= (1<<MD_DISK_WRITEMOSTLY);
 	}
-	if (fixdesc)
-		ITERATE_RDEV(mddev,rdev2,tmp)
-			if (fixdesc & (1<<rdev2->desc_nr)) {
-				snprintf(rdev2->kobj.name, KOBJ_NAME_LEN, "dev%d",
-					 rdev2->desc_nr);
-				/* kobject_add gets a ref on the parent, so
-				 * we have to drop the one we already have
-				 */
-				kobject_add(&rdev2->kobj);
-				kobject_put(rdev->kobj.parent);
-				sysfs_create_link(&rdev2->kobj,
-						  &rdev2->bdev->bd_disk->kobj,
-						  "block");
-				if (rdev2->raid_disk >= 0) {
-					sprintf(nm, "rd%d", rdev2->raid_disk);
-					sysfs_create_link(&mddev->kobj,
-							  &rdev2->kobj, nm);
-				}
-			}
 	/* now set the "removed" and "faulty" bits on any missing devices */
 	for (i=0 ; i < mddev->raid_disks ; i++) {
 		mdp_disk_t *d = &sb->disks[i];
@@ -1237,13 +1208,14 @@ static int bind_rdev_to_array(mdk_rdev_t
 		if (find_rdev_nr(mddev, rdev->desc_nr))
 			return -EBUSY;
 	}
+	bdevname(rdev->bdev,b);
+	if (kobject_set_name(&rdev->kobj, "dev-%s", b) < 0)
+		return -ENOMEM;
 			
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
-	printk(KERN_INFO "md: bind<%s>\n", bdevname(rdev->bdev,b));
+	printk(KERN_INFO "md: bind<%s>\n", b);
 
-	rdev->kobj.k_name = NULL;
-	snprintf(rdev->kobj.name, KOBJ_NAME_LEN, "dev%d", rdev->desc_nr);
 	rdev->kobj.parent = &mddev->kobj;
 	kobject_add(&rdev->kobj);
 
