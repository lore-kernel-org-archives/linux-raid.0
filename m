From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/11] imsm: FIX: Return longer map for failure setting
Date: Thu, 24 Nov 2011 13:17:18 +0100
Message-ID: <20111124121718.5254.16301.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When 2 maps are present, IMSM can use shorter map for setting disk
in to degraded state. It can happen that degraded disk can be not present
in shorter map.
We should use longer map for setting disk in to degraded state.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a0672bf..5f2c4a2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -665,18 +665,35 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 	 *    0   - we return the first map
 	 *    1   - we return the second map if it exists, else NULL
 	 *   -1   - we return the second map if it exists, else the first
+	 *   -2   - we return longer map /excluding uninitialized state/
 	 */
 	struct imsm_map *map = &dev->vol.map[0];
+	void *map2 = NULL;
 
-	if (second_map == 1 && !dev->vol.migr_state)
-		return NULL;
-	else if (second_map == 1 ||
-		 (second_map < 0 && dev->vol.migr_state)) {
-		void *ptr = map;
+	if (dev->vol.migr_state)
+		map2 = (void *)map + sizeof_imsm_map(map);
 
-		return ptr + sizeof_imsm_map(map);
-	} else
-		return map;
+	switch (second_map) {
+	case 0:
+		break;
+	case 1:
+		map = map2;
+		break;
+	case -1:
+		if (map2)
+			map = map2;
+		break;
+	case -2:
+		if (map2 &&
+		    (((struct imsm_map *)map2)->num_members > map->num_members)
+		    && (((struct imsm_map *)map2)->map_state !=
+						   IMSM_T_STATE_UNINITIALIZED))
+			map = map2;
+		break;
+	default:
+		map = NULL;
+	}
+	return map;
 
 }
 
@@ -6343,7 +6360,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 
 	dprintf("imsm: set_disk %d:%x\n", n, state);
 
-	ord = get_imsm_ord_tbl_ent(dev, n, -1);
+	ord = get_imsm_ord_tbl_ent(dev, n, -2);
 	disk = get_imsm_disk(super, ord_to_idx(ord));
 
 	/* check for new failures */

