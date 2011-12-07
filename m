From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/9] imsm: FIX: Mark failure for rebuild
Date: Wed, 07 Dec 2011 13:58:22 +0100
Message-ID: <20111207125822.25279.14182.stgit@gklab-128-013.igk.intel.com>
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

Allow for marking failures in second map during rebuild and initialization
also (not during migration only)

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 217a196..de07f66 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6158,7 +6158,11 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 
 	disk->status |= FAILED_DISK;
 	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
-	if (is_gen_migration(dev)) {
+	/* mark failures in second map if second map exists and this disk
+	 * in this slot.
+	 * This is valid for migration, initialization and rebuild
+	 */
+	if (dev->vol.migr_state) {
 		struct imsm_map *map2 = get_imsm_map(dev, 1);
 		if (slot < map2->num_members)
 			set_imsm_ord_tbl_ent(map2, slot,

