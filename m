From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/34] imsm: FIX: support general migration by
	getinfo_super_imsm_volume
Date: Tue, 04 Jan 2011 15:37:13 +0100
Message-ID: <20110104143713.6697.70539.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Add support for reading volume information during migration process.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 6d76205..de3585e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1563,26 +1563,39 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct imsm_map *prev_map = get_imsm_map(dev, 1);
+	struct imsm_map *map_to_analyse = map;
 	struct dl *dl;
 	char *devname;
 	int map_disks = info->array.raid_disks;
 
+	if (prev_map)
+		map_to_analyse = prev_map;
+
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->raiddisk == info->disk.raid_disk)
 			break;
 	info->container_member	  = super->current_vol;
-	info->array.raid_disks    = map->num_members;
-	info->array.level	  = get_imsm_raid_level(map);
+	info->array.raid_disks    = map_to_analyse->num_members;
+	info->array.level	  = get_imsm_raid_level(map_to_analyse);
 	info->array.layout	  = imsm_level_to_layout(info->array.level);
 	info->array.md_minor	  = -1;
 	info->array.ctime	  = 0;
 	info->array.utime	  = 0;
-	info->array.chunk_size	  = __le16_to_cpu(map->blocks_per_strip) << 9;
+	info->array.chunk_size	  =
+		__le16_to_cpu(map_to_analyse->blocks_per_strip) << 9;
 	info->array.state	  = !dev->vol.dirty;
 	info->custom_array_size   = __le32_to_cpu(dev->size_high);
 	info->custom_array_size   <<= 32;
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
-
+	if (prev_map) {
+		info->new_level = get_imsm_raid_level(map);
+		info->new_layout = imsm_level_to_layout(info->new_level);
+		info->new_chunk = __le16_to_cpu(map->blocks_per_strip) << 9;
+	} else {
+		info->new_level = UnSet;
+		info->new_layout = UnSet;
+		info->new_chunk = info->array.chunk_size;
+	}
 	info->disk.major = 0;
 	info->disk.minor = 0;
 	if (dl) {
@@ -1590,8 +1603,9 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 		info->disk.minor = dl->minor;
 	}
 
-	info->data_offset	  = __le32_to_cpu(map->pba_of_lba0);
-	info->component_size	  = __le32_to_cpu(map->blocks_per_member);
+	info->data_offset	  = __le32_to_cpu(map_to_analyse->pba_of_lba0);
+	info->component_size	  =
+		__le32_to_cpu(map_to_analyse->blocks_per_member);
 	memset(info->uuid, 0, sizeof(info->uuid));
 	info->recovery_start = MaxSector;
 	info->reshape_active = (prev_map != NULL);
@@ -1600,7 +1614,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	else
 		info->delta_disks = 0;
 
-	if (map->map_state == IMSM_T_STATE_UNINITIALIZED || dev->vol.dirty) {
+	if (map_to_analyse->map_state == IMSM_T_STATE_UNINITIALIZED ||
+	    dev->vol.dirty) {
 		info->resync_start = 0;
 	} else if (dev->vol.migr_state) {
 		switch (migr_type(dev)) {

