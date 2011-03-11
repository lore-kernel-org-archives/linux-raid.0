From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] imsm: FIX: Store checkpoint in per disk units
Date: Fri, 11 Mar 2011 12:59:20 +0100
Message-ID: <20110311115920.12324.99662.stgit@gklab-128-013.igk.intel.com>
References: <20110311115051.12324.75830.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110311115051.12324.75830.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

While last_checkpoint is counter in per disk units, checkpoints
should be stored in the same manner.
Restoring from checkpoint should should recalculate checkpoint in to
array position (reshape_progress).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5b4a38d..f18f16c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1702,8 +1702,6 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
 		migr_chunk = migr_strip_blocks_resync(dev);
 		disks = imsm_num_data_members(dev, 0);
 		blocks_per_unit = stripes_per_unit * migr_chunk * disks;
-		if (migr_type(dev) == MIGR_GEN_MIGR)
-			return blocks_per_unit;
 		stripe = __le32_to_cpu(map->blocks_per_strip) * disks;
 		segment = blocks_per_unit / stripe;
 		block_rel = blocks_per_unit - segment * stripe;
@@ -1854,6 +1852,12 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			int used_disks;
 
 			info->reshape_progress = blocks_per_unit * units;
+
+			/* checkpoint is written per disks unit
+			 * recalculate it to reshape position
+			 */
+			used_disks = imsm_num_data_members(dev, 0);
+			info->reshape_progress *= used_disks;
 			dprintf("IMSM: General Migration checkpoint : %llu "
 			       "(%llu) -> read reshape progress : %llu\n",
 				units, blocks_per_unit, info->reshape_progress);

