From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 1/1] IMSM: Update num_data_stripes during migration
Date: Thu, 24 Nov 2016 09:48:24 +0100
Message-ID: <20161124084824.28155-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>, Maksymilian Kunt <maksymilian.kunt@intel.com>
List-Id: linux-raid.ids

This patch adds updataing num_data_stripes during reshape.
Previously this field once set during creation was never updated.
Also, num_data_strips value multipied by chunk_size is used
for set proper component size for RAID5.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
---
 super-intel.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5740088..3d21f31 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -910,14 +910,12 @@ static unsigned long long blocks_per_member(struct imsm_map *map)
 	return join_u32(map->blocks_per_member_lo, map->blocks_per_member_hi);
 }
 
-#ifndef MDASSEMBLE
 static unsigned long long num_data_stripes(struct imsm_map *map)
 {
 	if (map == NULL)
 		return 0;
 	return join_u32(map->num_data_stripes_lo, map->num_data_stripes_hi);
 }
-#endif
 
 static void set_total_blocks(struct imsm_disk *disk, unsigned long long n)
 {
@@ -2916,7 +2914,13 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	}
 
 	info->data_offset	  = pba_of_lba0(map_to_analyse);
-	info->component_size	  = blocks_per_member(map_to_analyse);
+
+	if (info->array.level == 5) {
+		info->component_size = num_data_stripes(map_to_analyse) *
+				       map_to_analyse->blocks_per_strip;
+	} else {
+		info->component_size = blocks_per_member(map_to_analyse);
+	}
 
 	info->component_size = imsm_component_size_aligment_check(
 							info->array.level,
@@ -7065,7 +7069,14 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 
 			info_d->events = __le32_to_cpu(mpb->generation_num);
 			info_d->data_offset = pba_of_lba0(map);
-			info_d->component_size = blocks_per_member(map);
+
+			if (map->raid_level == 5) {
+				info_d->component_size =
+						num_data_stripes(map) *
+						map->blocks_per_strip;
+			} else {
+				info_d->component_size = blocks_per_member(map);
+			}
 		}
 		/* now that the disk list is up-to-date fixup recovery_start */
 		update_recovery_start(super, dev, this);
@@ -8271,9 +8282,23 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 
 			/* update chunk size
 			 */
-			if (u->new_chunksize > 0)
+			if (u->new_chunksize > 0) {
+				unsigned long long num_data_stripes;
+				int used_disks =
+					imsm_num_data_members(dev, MAP_0);
+
+				if (used_disks == 0)
+					return ret_val;
+
 				map->blocks_per_strip =
 					__cpu_to_le16(u->new_chunksize * 2);
+				num_data_stripes =
+					(join_u32(dev->size_low, dev->size_high)
+					/ used_disks);
+				num_data_stripes /= map->blocks_per_strip;
+				num_data_stripes /= map->num_domains;
+				set_num_data_stripes(map, num_data_stripes);
+			}
 
 			/* add disk
 			 */
@@ -8340,13 +8365,19 @@ static int apply_size_change_update(struct imsm_update_size_change *u,
 			struct imsm_map *map = get_imsm_map(dev, MAP_0);
 			int used_disks = imsm_num_data_members(dev, MAP_0);
 			unsigned long long blocks_per_member;
+			unsigned long long num_data_stripes;
 
 			/* calculate new size
 			 */
 			blocks_per_member = u->new_size / used_disks;
-			dprintf("(size: %llu, blocks per member: %llu)\n",
-				u->new_size, blocks_per_member);
+			num_data_stripes = blocks_per_member /
+					   map->blocks_per_strip;
+			num_data_stripes /= map->num_domains;
+			dprintf("(size: %llu, blocks per member: %llu, num_data_stipes: %llu)\n",
+				u->new_size, blocks_per_member,
+				num_data_stripes);
 			set_blocks_per_member(map, blocks_per_member);
+			set_num_data_stripes(map, num_data_stripes);
 			imsm_set_array_size(dev, u->new_size);
 
 			ret_val = 1;
@@ -8597,6 +8628,14 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 	map = get_imsm_map(dev, MAP_0);
 
 	if (u->direction == R10_TO_R0) {
+		unsigned long long num_data_stripes;
+
+		map->num_domains = 1;
+		num_data_stripes = blocks_per_member(map);
+		num_data_stripes /= map->blocks_per_strip;
+		num_data_stripes /= map->num_domains;
+		set_num_data_stripes(map, num_data_stripes);
+
 		/* Number of failed disks must be half of initial disk number */
 		if (imsm_count_failed(super, dev, MAP_0) !=
 				(map->num_members / 2))
-- 
2.9.3

