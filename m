From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: 0001-md-FIX-raid5-should-accept-slot-set-by-mdadm
Date: Wed, 12 Jan 2011 14:49:22 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1ACEB@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

When reshape process is invoked in mdadm, new disks are added with set slot information.
raid5_start_reshape() should count devices with slot set as spares when slot is set outside array.
Those disks has to be added to array for reshape process also.

Changes allows to accept spares with slot set to raid5 configuration.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 drivers/md/raid5.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc574f3..fa2b085 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5528,8 +5528,9 @@ static int raid5_start_reshape(mddev_t *mddev)
 		return -ENOSPC;
 
 	list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk < 0 &&
-		    !test_bit(Faulty, &rdev->flags))
+		if (((rdev->raid_disk < 0) ||
+		    ((mddev->raid_disks -1 -mddev->degraded) < rdev->raid_disk)) &&
+		      !test_bit(Faulty, &rdev->flags))
 			spares++;
 
 	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
@@ -5574,8 +5575,9 @@ static int raid5_start_reshape(mddev_t *mddev)
 	 */
 	if (mddev->delta_disks >= 0)
 	    list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk < 0 &&
-		    !test_bit(Faulty, &rdev->flags)) {
+		if (((rdev->raid_disk < 0) ||
+		    ((mddev->raid_disks -1 -mddev->degraded) < rdev->raid_disk)) &&
+		      !test_bit(Faulty, &rdev->flags)) {
 			if (raid5_add_disk(mddev, rdev) == 0) {
 				char nm[20];
 				if (rdev->raid_disk >= conf->previous_raid_disks) {
-- 
1.6.0.2

