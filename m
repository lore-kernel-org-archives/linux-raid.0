From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] md/raid5: FIX: reshape on degraded devices has wrong
	configuration
Date: Thu, 27 Jan 2011 15:27:05 +0100
Message-ID: <20110127142705.5062.55043.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When we performing expansion on degraded array (takeovered raid0),
and we are adding i.e. 2 disks, one disk is added only.

this is due to fact that parity (missing) disk is on the array end
and added disk index is smaller than number disks in array.

To resolve this situation array degradation should be used for adding
disk(s) on reshape start. We have to make sure if there is not working
disks after slot used by tested disks. If no, such disk can be treated
as spare. This check can be used for degraded arrays only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 drivers/md/raid5.c |   37 ++++++++++++++++++++++++++++++++++---
 1 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc574f3..46e423a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5527,10 +5527,41 @@ static int raid5_start_reshape(mddev_t *mddev)
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk < 0 &&
-		    !test_bit(Faulty, &rdev->flags))
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		/* don't look at faulty disks */
+		if (test_bit(Faulty, &rdev->flags))
+			continue;
+		/* slot is not set - this is spare */
+		if (rdev->raid_disk < 0) {
 			spares++;
+			continue;
+		}
+		/* if this is degraded array and
+		 * if current disk is placed on the array end
+		 * (in array doesn't exist any healthy disk on higher slot)
+		 * current disk can be a spare device
+		 */
+		if (rdev->raid_disk >= (conf->raid_disks - mddev->degraded)) {
+			mdk_rdev_t *rdev2;
+			int faulty_counter = 0;
+			list_for_each_entry(rdev2, &mddev->disks, same_set) {
+				/* skip current disk
+				 * and all with smaller slot number
+				 */
+				if ((rdev == rdev2) ||
+				    (rdev->raid_disk < rdev2->raid_disk))
+					continue;
+				if (test_bit(Faulty, &rdev2->flags)) {
+					faulty_counter++;
+					break;
+				}
+			}
+			if (faulty_counter == 0) {
+				spares++;
+				continue;
+			}
+		}
+	}
 
 	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
 		/* Not enough devices even to make a degraded array

