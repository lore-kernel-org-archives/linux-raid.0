From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] imsm: Do not mark resync during reshape
Date: Thu, 29 Sep 2011 17:45:45 +0200
Message-ID: <20110929154545.22094.64680.stgit@gklab-128-013.igk.intel.com>
References: <20110929154250.22094.48754.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929154250.22094.48754.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

During reshape, resync/rebuild in the same container is not possible
due to fact that all arrays in container has to share the same disks set.

Block new resync/rebuild process initialization and setting resync_start
to 0 while any reshape in container is active. This avoids breaking
container reshape and doesn't allow for starting multiple processes
/resync/rebuild and reshape/ at the same time in md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5504c17..4c546ac 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2375,8 +2375,9 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 
 	info->reshape_progress = 0;
 	info->resync_start = MaxSector;
-	if (map_to_analyse->map_state == IMSM_T_STATE_UNINITIALIZED ||
-	    dev->vol.dirty) {
+	if ((map_to_analyse->map_state == IMSM_T_STATE_UNINITIALIZED ||
+	    dev->vol.dirty) &&
+	    imsm_reshape_blocks_arrays_changes(super) == 0) {
 		info->resync_start = 0;
 	}
 	if (dev->vol.migr_state) {
@@ -6232,7 +6233,8 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			super->updates_pending++;
 			a->last_checkpoint = 0;
 		}
-	} else if (!is_resyncing(dev) && !failed) {
+	} else if ((!is_resyncing(dev) && !failed) &&
+		   (imsm_reshape_blocks_arrays_changes(super) == 0)) {
 		/* mark the start of the init process if nothing is failed */
 		dprintf("imsm: mark resync start\n");
 		if (map->map_state == IMSM_T_STATE_UNINITIALIZED)

