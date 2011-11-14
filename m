From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: correct checking newly missing disks
Date: Mon, 14 Nov 2011 15:52:52 +0100
Message-ID: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The problem occurs when RAID10 array under rebuild
(after one disk fails) is assembled incrementally.
Mdadm tries to start array just after adding the third disk
and the volume is assembled incorrectly (in degraded state).

The cause is that container_enough depends on
newly missing disks which are checked incorrectly now.
They should be checked using always the first map.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4ebee78..511a32a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2529,13 +2529,13 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 		failed = imsm_count_failed(super, dev);
 		state = imsm_check_degraded(super, dev, failed);
-		map = get_imsm_map(dev, dev->vol.migr_state);
+		map = get_imsm_map(dev, 0);
 
 		/* any newly missing disks?
 		 * (catches single-degraded vs double-degraded)
 		 */
 		for (j = 0; j < map->num_members; j++) {
-			__u32 ord = get_imsm_ord_tbl_ent(dev, i, -1);
+			__u32 ord = get_imsm_ord_tbl_ent(dev, i, 0);
 			__u32 idx = ord_to_idx(ord);
 
 			if (!(ord & IMSM_ORD_REBUILD) &&

