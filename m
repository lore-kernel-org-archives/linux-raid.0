From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/23] md/raid5: removed unused 'added_devices' variable.
Date: Wed, 14 Mar 2012 15:40:39 +1100
Message-ID: <20120314044039.7978.32964.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

commit 908f4fbd265733 removed the last user of this variable,
so we should discard it completely.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8b3eb41..3f55145 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5547,16 +5547,14 @@ static int raid5_start_reshape(struct mddev *mddev)
 	 * such devices during the reshape and confusion could result.
 	 */
 	if (mddev->delta_disks >= 0) {
-		int added_devices = 0;
 		list_for_each_entry(rdev, &mddev->disks, same_set)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
 				if (raid5_add_disk(mddev, rdev) == 0) {
 					if (rdev->raid_disk
-					    >= conf->previous_raid_disks) {
+					    >= conf->previous_raid_disks)
 						set_bit(In_sync, &rdev->flags);
-						added_devices++;
-					} else
+					else
 						rdev->recovery_offset = 0;
 
 					if (sysfs_link_rdev(mddev, rdev))
@@ -5566,7 +5564,6 @@ static int raid5_start_reshape(struct mddev *mddev)
 				   && !test_bit(Faulty, &rdev->flags)) {
 				/* This is a spare that was manually added */
 				set_bit(In_sync, &rdev->flags);
-				added_devices++;
 			}
 
 		/* When a reshape changes the number of devices,


