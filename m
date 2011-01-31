From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: map coping causes mdmon crash
Date: Mon, 31 Jan 2011 17:05:48 +0100
Message-ID: <20110131160547.5126.57753.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Too big map was copied (outside allocated memory) and this causes
mdmon crash for 2 raid0 arrays in container.
Map of correct (smaller) size should be copied,
to not overwrite any internal data.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0c988d6..3de4132 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5074,6 +5074,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 	struct imsm_super *mpb = super->anchor;
 	int prev_disks = -1;
 	int i;
+	int copy_map_size;
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
@@ -5094,6 +5095,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		 * i.e it needs a migr_state
 		 */
 
+		copy_map_size = sizeof_imsm_map(map);
 		prev_num_members = map->num_members;
 		map->num_members = prev_disks;
 		dev->vol.migr_state = 1;
@@ -5104,7 +5106,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 			set_imsm_ord_tbl_ent(map, i, i);
 		map2 = get_imsm_map(dev, 1);
 		/* Copy the current map */
-		memcpy(map2, map, sizeof_imsm_map(map));
+		memcpy(map2, map, copy_map_size);
 		map2->num_members = prev_num_members;
 
 		/* calculate new size

