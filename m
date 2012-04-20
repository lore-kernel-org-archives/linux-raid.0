From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: rebuild does not continue after reboot
Date: Fri, 20 Apr 2012 13:45:02 +0200
Message-ID: <20120420114502.2484.68027.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If system is rebooted during rebuild, md driver changes sync_action
from 'recover' to 'idle' (during stopping all md devices).
If mdmon is still running then, it detects the change of sync_action state,
finishes rebuild and writes metadata to disks. After computer's restart
the RAID volume is in Normal state in OROM and rebuild seems to be finished.
After system's start-up RAID volume is in auto-read-only state
and metadata is in Dirty state. Rebuild seems to be finished but it is not.
Data is inconsistent (out-of-sync).

When mdmon detects the change of sync_action from 'recover' to 'idle',
it has to check if rebuild is really finished. Appropriate test was added.
Now mdmon examines each volume's member if it is being rebuilt.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e405d97..1ad5e47 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7273,6 +7273,8 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 	struct imsm_dev *dev = get_imsm_dev(super, inst);
 	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	struct imsm_disk *disk;
+	struct mdinfo *mdi;
+	int recovery_not_finished = 0;
 	int failed;
 	__u32 ord;
 	__u8 map_state;
@@ -7313,6 +7315,21 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		dprintf("normal: ");
 		if (is_rebuilding(dev)) {
 			dprintf("while rebuilding");
+			/* check if recovery is really finished */
+			for (mdi = a->info.devs; mdi ; mdi = mdi->next)
+				if (mdi->recovery_start != MaxSector) {
+					recovery_not_finished = 1;
+					break;
+				}
+			if (recovery_not_finished) {
+				dprintf("\nimsm: Rebuild has not finished yet, "
+						"state not changed");
+				if (a->last_checkpoint < mdi->recovery_start) {
+					a->last_checkpoint = mdi->recovery_start;
+					super->updates_pending++;
+				}
+				break;
+			}
 			end_migration(dev, super, map_state);
 			map = get_imsm_map(dev, MAP_0);
 			map->failed_disk_num = ~0;

