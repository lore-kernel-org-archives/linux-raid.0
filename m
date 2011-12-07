From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/9] imsm: Function imsm_set_disk() rework
Date: Wed, 07 Dec 2011 13:57:59 +0100
Message-ID: <20111207125759.25279.86612.stgit@gklab-128-013.igk.intel.com>
References: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Rework is needed to map state transition part to allow easier code reading.
After rework it is easy to find out what can happen in what map state
transition.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   98 ++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8f075e0..c6509af 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6446,49 +6446,83 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 	map_state = imsm_check_degraded(super, dev, failed, MAP_0);
 
 	/* check if recovery complete, newly degraded, or failed */
-	if (map_state == IMSM_T_STATE_NORMAL && is_rebuilding(dev)) {
-		end_migration(dev, super, map_state);
-		map = get_imsm_map(dev, 0);
-		map->failed_disk_num = ~0;
-		super->updates_pending++;
-		a->last_checkpoint = 0;
-	} else if (map_state == IMSM_T_STATE_DEGRADED &&
-		   map->map_state != map_state &&
-		   !dev->vol.migr_state) {
-		dprintf("imsm: mark degraded\n");
-		map->map_state = map_state;
-		super->updates_pending++;
-		a->last_checkpoint = 0;
-	} else if (map_state == IMSM_T_STATE_FAILED &&
-		   map->map_state != map_state) {
-		dprintf("imsm: mark failed\n");
-		end_migration(dev, super, map_state);
-		super->updates_pending++;
-		a->last_checkpoint = 0;
-	} else if (is_gen_migration(dev)) {
-		dprintf("imsm: Detected General Migration in state: ");
-
-		switch (map_state) {
-		case IMSM_T_STATE_NORMAL:
-			dprintf("normal\n");
+	dprintf("imsm: Detected transition to state ");
+	switch (map_state) {
+	case IMSM_T_STATE_NORMAL: /* transition to normal state */
+		dprintf("normal: ");
+		if (is_rebuilding(dev)) {
+			dprintf("while rebuilding");
+			end_migration(dev, super, map_state);
+			map = get_imsm_map(dev, 0);
+			map->failed_disk_num = ~0;
+			super->updates_pending++;
+			a->last_checkpoint = 0;
+			break;
+		}
+		if (is_gen_migration(dev)) {
+			dprintf("while general migration");
 			if (a->last_checkpoint >= a->info.component_size)
 				end_migration(dev, super, map_state);
+			else
+				map->map_state = map_state;
 			map = get_imsm_map(dev, 0);
 			map->failed_disk_num = ~0;
+			super->updates_pending++;
 			break;
-		case IMSM_T_STATE_DEGRADED:
-			dprintf("degraded\n");
+		}
+	break;
+	case IMSM_T_STATE_DEGRADED: /* transition to degraded state */
+		dprintf("degraded: ");
+		if ((map->map_state != map_state) &&
+		    !dev->vol.migr_state) {
+			dprintf("mark degraded");
+			map->map_state = map_state;
+			super->updates_pending++;
+			a->last_checkpoint = 0;
+			break;
+		}
+		if (is_rebuilding(dev)) {
+			dprintf("while rebuilding.");
+			if (map->map_state != map_state)  {
+				dprintf(" Map state change");
+				end_migration(dev, super, map_state);
+				super->updates_pending++;
+			}
+			break;
+		}
+		if (is_gen_migration(dev)) {
+			dprintf("while general migration");
 			if (a->last_checkpoint >= a->info.component_size)
 				end_migration(dev, super, map_state);
-			else
+			else {
+				map->map_state = map_state;
 				manage_second_map(super, dev);
+			}
+			super->updates_pending++;
 			break;
-		default:
-			dprintf("failed\n");
 		}
-		map->map_state = map_state;
-		super->updates_pending++;
+	break;
+	case IMSM_T_STATE_FAILED: /* transition to failed state */
+		dprintf("failed: ");
+		if (is_gen_migration(dev)) {
+			dprintf("while general migration");
+			map->map_state = map_state;
+			super->updates_pending++;
+			break;
+		}
+		if (map->map_state != map_state) {
+			dprintf("mark failed");
+			end_migration(dev, super, map_state);
+			super->updates_pending++;
+			a->last_checkpoint = 0;
+			break;
+		}
+	break;
+	default:
+		dprintf("state %i\n", map_state);
 	}
+	dprintf("\n");
+
 }
 
 static int store_imsm_mpb(int fd, struct imsm_super *mpb)

