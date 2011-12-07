From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/9] imsm: FIX: Remove longer map request
Date: Wed, 07 Dec 2011 13:57:43 +0100
Message-ID: <20111207125743.25279.10593.stgit@gklab-128-013.igk.intel.com>
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

We shouldn't use longer map. mdadm should know what map is accessed
at the moment.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 21aa516..9b3d6be 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -667,12 +667,9 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 {
 	/* A device can have 2 maps if it is in the middle of a migration.
 	 * If second_map is:
-	 *    MAP_0 or
-	 *    0   - we return the first map
-	 *    MAP_1 or
-	 *    1   - we return the second map if it exists, else NULL
+	 *    MAP_0 or 0   - we return the first map
+	 *    MAP_1 or 1   - we return the second map if it exists, else NULL
 	 *   -1   - we return the second map if it exists, else the first
-	 *   -2   - we return longer map /excluding uninitialized state/
 	 */
 	struct imsm_map *map = &dev->vol.map[0];
 	struct imsm_map *map2 = NULL;
@@ -692,12 +689,6 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 		if (map2)
 			map = map2;
 		break;
-	case -2:
-		if (map2
-		    && map2->map_state != IMSM_T_STATE_UNINITIALIZED
-		    && map2->num_members > map->num_members)
-			map = map2;
-		break;
 	default:
 		map = NULL;
 	}
@@ -6421,7 +6412,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 
 	dprintf("imsm: set_disk %d:%x\n", n, state);
 
-	ord = get_imsm_ord_tbl_ent(dev, n, -2);
+	ord = get_imsm_ord_tbl_ent(dev, n, 0);
 	disk = get_imsm_disk(super, ord_to_idx(ord));
 
 	/* check for new failures */

