From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 1/1] unblock the creation of an external metadata RAID if
 native one exists
Date: Tue, 25 Jan 2011 15:23:47 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176F91B9C@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

From aa169142c6dde0a7c1dc1b91dec0973474661036 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Tue, 25 Jan 2011 15:57:20 +0100
Subject: [PATCH 1/1] md: unblock the creation of an external metadata RAID if native one exists

Native metadata reserves a parent disk device for exclusive use by setting
AllReserved in rdev->flags. Now if a member device has AllReserved flag set
on its block device then creation of any external metadata array/container on
is unreasonably blocked.
Solution:
When creating a new external RAID device we must check that the new
device is not using a partition of a disk, when there is another array
using another partition of the same disk calming exclusive usage for the
disk. Exclusive usage is enforced by setting AllReserved in rdev->flags.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 drivers/md/md.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 175c424..1bb309f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2603,15 +2603,30 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
-
+			
 			mddev_lock(mddev);
+			 
 			list_for_each_entry(rdev2, &mddev->disks, same_set)
-				if (test_bit(AllReserved, &rdev2->flags) ||
+				if ((test_bit(AllReserved, &rdev2->flags) &&
+				     rdev->bdev->bd_contains == rdev2->bdev->bd_contains) ||
 				    (rdev->bdev == rdev2->bdev &&
 				     rdev != rdev2 &&
 				     overlaps(rdev->data_offset, rdev->sectors,
 					      rdev2->data_offset,
 					      rdev2->sectors))) {
+					char b[BDEVNAME_SIZE];
+
+					dprintk(KERN_INFO "rdev: %p %s\n", rdev, bdevname(rdev->bdev,b));
+					dprintk(KERN_INFO "rdev tested: %p %s\n", rdev2, bdevname(rdev2->bdev,b));
+					dprintk(KERN_INFO "my_mddev: %p tested: %p if: %d, %d, %d, %d, %d \n",
+						my_mddev,
+						mddev,
+						test_bit(AllReserved, &rdev2->flags),
+						rdev->bdev->bd_contains == rdev2->bdev->bd_contains,
+						rdev->bdev == rdev2->bdev,
+						rdev != rdev2,
+						overlaps(rdev->data_offset, rdev->sectors,
+							 rdev2->data_offset,  rdev2->sectors));
 					overlap = 1;
 					break;
 				}
-- 
1.6.4.2

