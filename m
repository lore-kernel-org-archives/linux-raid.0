From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 22/22] md: integrate spares into array at earliest
	opportunity.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.89008.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As v1.x metadata can record that a member of the array is
not completely recovered, it make sense to record that a
spare has become a regular member of the array at the earliest
opportunity.
So remove the tests on "recovery_offset > 0" in super_1_sync
as they really aren't needed, and schedule a metadata update
immediately after adding spares to a degraded array.

This means that if a crash happens immediately after a recovery
starts, the new device will be included in the array and recovery will
continue from wherever it was up to.  Previously this didn't happen
unless recovery was at least 1/16 of the way through.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c4a0e59..8f70166 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1523,12 +1523,10 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 
 	if (rdev->raid_disk >= 0 &&
 	    !test_bit(In_sync, &rdev->flags)) {
-		if (rdev->recovery_offset > 0) {
-			sb->feature_map |=
-				cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
-			sb->recovery_offset =
-				cpu_to_le64(rdev->recovery_offset);
-		}
+		sb->feature_map |=
+			cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
+		sb->recovery_offset =
+			cpu_to_le64(rdev->recovery_offset);
 	}
 
 	if (mddev->reshape_position != MaxSector) {
@@ -1562,7 +1560,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
-		else if (rdev2->raid_disk >= 0 && rdev2->recovery_offset > 0)
+		else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] = cpu_to_le16(0xffff);
@@ -6777,6 +6775,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 						       nm, mdname(mddev));
 					spares++;
 					md_new_event(mddev);
+					set_bit(MD_CHANGE_DEVS, &mddev->flags);
 				} else
 					break;
 			}


