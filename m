From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 7 - Move the test in preferred_minor to where it is used.
Date: Fri, 23 Jan 2004 11:14:23 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ajoxr-0000jQ-00@notabene>
References: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


A RAID superblock can indicate which minor number the array should be 
assembled under.  As this is only meaningful when doing auto-start,
we move the test for it being in the valid range to the place where
auto-start happens.  When an array is started any other way, it 
doesn't matter what value is here.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-23 10:32:24.000000000 +1100
+++ ./drivers/md/md.c	2004-01-23 10:32:51.000000000 +1100
@@ -512,11 +512,6 @@ static int super_90_load(mdk_rdev_t *rde
 		goto abort;
 	}
 
-	if (sb->md_minor >= MAX_MD_DEVS) {
-		printk(KERN_ERR "md: %s: invalid raid minor (%x)\n",
-			b, sb->md_minor);
-		goto abort;
-	}
 	if (sb->raid_disks <= 0)
 		goto abort;
 
@@ -1829,7 +1824,7 @@ static void autorun_devices(void)
 				"md: md%d already running, cannot run %s\n",
 				mdidx(mddev), bdevname(rdev0->bdev,b));
 			mddev_unlock(mddev);
-		} else {
+		} else if (rdev0->preferred_minor >= 0 && rdev0->preferred_minor < MAX_MD_DEVS) {
 			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
 			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
 				list_del_init(&rdev->same_set);
@@ -1838,7 +1833,9 @@ static void autorun_devices(void)
 			}
 			autorun_array(mddev);
 			mddev_unlock(mddev);
-		}
+		} else
+			printk(KERN_WARNING "md: %s had invalid preferred minor %d\n",
+			       bdevname(rdev->bdev, b), rdev0->preferred_minor);
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
