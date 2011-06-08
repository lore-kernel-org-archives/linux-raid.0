From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/21] imsm: FIX: Max position could not be rounded to MB
Date: Wed, 08 Jun 2011 18:10:14 +0200
Message-ID: <20110608161014.24327.81807.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When rounded array size information from metadata is used for number
of migration units calculation it can occurs that result of units
can be smaller (-1) than required due to used (rounded) array size).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3afa913..2468968 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7621,10 +7621,7 @@ void init_migr_record_imsm(struct supertype *st, struct imsm_dev *dev,
 	struct imsm_map *map_dest = get_imsm_map(dev, 0);
 	struct imsm_map *map_src = get_imsm_map(dev, 1);
 	unsigned long long num_migr_units;
-
-	unsigned long long array_blocks =
-		(((unsigned long long)__le32_to_cpu(dev->size_high)) << 32) +
-		__le32_to_cpu(dev->size_low);
+	unsigned long long array_blocks;
 
 	memset(migr_rec, 0, sizeof(struct migr_record));
 	migr_rec->family_num = __cpu_to_le32(super->anchor->family_num);
@@ -7640,7 +7637,7 @@ void init_migr_record_imsm(struct supertype *st, struct imsm_dev *dev,
 		__cpu_to_le32(migr_rec->dest_depth_per_unit * new_data_disks);
 	migr_rec->dest_depth_per_unit =
 		__cpu_to_le32(migr_rec->dest_depth_per_unit);
-
+	array_blocks = info->component_size * new_data_disks;
 	num_migr_units =
 		array_blocks / __le32_to_cpu(migr_rec->blocks_per_unit);
 
@@ -8737,10 +8734,7 @@ static int imsm_manage_reshape(
 		goto abort;
 	}
 
-	max_position =
-		__le32_to_cpu(migr_rec->post_migr_vol_cap) +
-		((unsigned long long)__le32_to_cpu(
-			 migr_rec->post_migr_vol_cap_hi) << 32);
+	max_position = sra->component_size * ndata;
 
 	while (__le32_to_cpu(migr_rec->curr_migr_unit) <
 	       __le32_to_cpu(migr_rec->num_migr_units)) {

