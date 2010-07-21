From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 10/10] mdadm: migration restart for external meta
Date: Wed, 21 Jul 2010 12:22:25 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A49CF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Add support for assembling partially migrated arrays with external meta.
Note that if Raid0 was used while migration it should be changed to
Raid4 while assembling (see check_mpb_migr_compatibility and switch_raid0_configuration).

getinfo_super_imsm_volume() reads migration record and initializes mdadm reshape specific structures.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 Assemble.c    |    8 ++
 super-intel.c |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 195 insertions(+), 4 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 1504f1f..8912bf9 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1310,6 +1310,14 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			close(mdfd);
 			return 1;
 		}
+
+	if (content->reshape_active) {
+		sysfs_set_num(sra, NULL, "reshape_position", content->reshape_progress);
+		sysfs_set_num(sra, NULL, "chunk_size", content->new_chunk);
+		sysfs_set_num(sra, NULL, "layout", content->new_layout);
+		sysfs_set_num(sra, NULL, "raid_disks", content->array.raid_disks + content->delta_disks);
+	}
+
 	if (sra)
 		sysfs_free(sra);
 
diff --git a/super-intel.c b/super-intel.c index 35c6e61..69b55fc 100755
--- a/super-intel.c
+++ b/super-intel.c
@@ -1583,6 +1583,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	struct imsm_map *map;
 	struct dl *dl;
 	char *devname;
+	__u32 blocks_per_member;
+	__u32 blocks_per_strip;
 
 	if (dev == NULL)
 		return;
@@ -1595,7 +1597,13 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	info->container_member	  = super->current_vol;
 	info->array.raid_disks    = map->num_members;
 	info->array.level	  = get_imsm_raid_level(map);
-	info->array.layout	  = imsm_level_to_layout(info->array.level);
+	if (info->array.level == 4) {
+		map->raid_level = 5;
+		info->array.level = 5;
+		info->array.layout = ALGORITHM_PARITY_N;
+	} else {
+		info->array.layout	  = imsm_level_to_layout(info->array.level);
+	}
 	info->array.md_minor	  = -1;
 	info->array.ctime	  = 0;
 	info->array.utime	  = 0;
@@ -1613,7 +1621,15 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	}
 
 	info->data_offset	  = __le32_to_cpu(map->pba_of_lba0);
-	info->component_size	  = __le32_to_cpu(map->blocks_per_member);
+	/* FIXME: For some unknown reason sometimes in a volume created by
+	 * IMSM blocks_per_member is not a multiple of blocks_per strip.
+	 * Fix blocks_per_member here:
+	 */
+	blocks_per_member = __le32_to_cpu(map->blocks_per_member);
+	blocks_per_strip = __le16_to_cpu(map->blocks_per_strip);
+	blocks_per_member &= ~(blocks_per_strip - 1);
+	info->component_size = blocks_per_member;
+
 	memset(info->uuid, 0, sizeof(info->uuid));
 	info->recovery_start = MaxSector;
 	info->reshape_active = 0;
@@ -1637,9 +1653,45 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 			 */
 		case MIGR_REBUILD:
 			/* this is handled by container_content_imsm() */
-		case MIGR_GEN_MIGR:
+		case MIGR_GEN_MIGR: {
+			struct imsm_map *prev_map;
+			int data_members;
+
+			load_imsm_migr_rec(super, info);
+
+			info->reshape_progress = (unsigned long long)
+			  __le32_to_cpu(super->migr_rec->blocks_per_unit) *
+			  __le32_to_cpu(super->migr_rec->curr_migr_unit);
+
+			/* set previous and new map configurations */
+			prev_map = get_imsm_map(dev, 1);
+			info->reshape_active = 1;
+			info->array.raid_disks = prev_map->num_members;
+			info->delta_disks = map->num_members - prev_map->num_members;
+			info->new_level = info->array.level;
+			info->array.level = get_imsm_raid_level(prev_map);
+			info->new_layout = info->array.layout;
+			info->array.layout = imsm_level_to_layout(info->array.level);
+			info->array.chunk_size = __le16_to_cpu(prev_map->blocks_per_strip) << 9;
+			info->new_chunk = __le16_to_cpu(map->blocks_per_strip) << 9;
+
+			if (info->array.level == 4) {
+				prev_map->raid_level = 5;
+				info->array.level = 5;
+				info->array.layout = ALGORITHM_PARITY_N;
+			}
+
+			/* IMSM FIX for blocks_per_member */
+			blocks_per_strip = __le16_to_cpu(prev_map->blocks_per_strip);
+			blocks_per_member &= ~(blocks_per_strip - 1);
+			info->component_size = blocks_per_member;
+
+			/* Calculate previous array size */
+			data_members = imsm_num_data_members(dev, 1);
+			info->custom_array_size = blocks_per_member * data_members;
+		}
 		case MIGR_STATE_CHANGE:
-			/* FIXME handle other migrations */
+		  /* FIXME handle other migrations */
 		default:
 			/* we are not dirty, so... */
 			info->resync_start = MaxSector;
@@ -2588,6 +2640,115 @@ struct bbm_log *__get_imsm_bbm_log(struct imsm_super *mpb)
 	return ptr;
 }
 
+/* Switches N-disk Raid0 map configuration (N+1)disk Raid4  */ void 
+switch_raid0_configuration(struct imsm_super *mpb, struct imsm_map 
+*map) {
+	__u8 *src, *dst;
+	int bytes_to_copy;
+
+	/* get the pointer to the rest of the metadata */
+	src = (__u8 *)map + sizeof_imsm_map(map);
+
+	/* change the level and disk number to be compatible with IMSM */
+	map->raid_level = 4;
+	map->num_members++;
+
+	/* get the updated pointer to the rest of the metadata */
+	dst = (__u8 *)map + sizeof_imsm_map(map);
+	/* Now move the rest of the metadata to be properly aligned */
+	bytes_to_copy = mpb->mpb_size - (src - (__u8 *)mpb);
+	if (bytes_to_copy > 0)
+		memmove(dst, src, bytes_to_copy);
+	/* Now insert new entry to the map */
+	set_imsm_ord_tbl_ent(map, map->num_members - 1/*slot*/,
+			     mpb->num_disks | IMSM_ORD_REBUILD);
+	/* update size */
+	mpb->mpb_size += sizeof(__u32);
+}
+
+/* Make sure that in case of migration in progress we'll convert raid
+ * personalities so we could continue migrating  */ void 
+convert_raid_personalities(struct intel_super *super) {
+	struct imsm_super *mpb = super->anchor;
+	struct imsm_map *map;
+	struct imsm_disk *newMissing;
+	int i, map_modified = 0;
+	int bytes_to_copy;
+	__u8 *src, *dst;
+
+	for (i = 0; i < super->anchor->num_raid_devs; i++) {
+		struct imsm_dev *dev_iter = __get_imsm_dev(super->anchor, i);
+
+		map_modified = 0;
+		if (dev_iter->vol.migr_state == 1 &&
+		    dev_iter->vol.migr_type == MIGR_GEN_MIGR) {
+			/* This device is migrating, check for raid0 levels */
+			map = get_imsm_map(dev_iter, 0);
+			if (map->raid_level == 0) {
+				/* Map0: Migrating raid0 detected - lets switch it to level4 */
+				switch_raid0_configuration(mpb, map);
+				map_modified++;
+			}
+			map = get_imsm_map(dev_iter, 1);
+			if (map->raid_level == 0) {
+				/* Map1: Migrating raid0 detected - lets switch it to level4 */
+				switch_raid0_configuration(mpb, map);
+				map_modified++;
+			}
+		}
+	}
+
+	if (map_modified > 0) {
+		/* Add missing device to the MPB disk table */
+		src = (__u8 *)mpb->disk + sizeof(struct imsm_disk) * mpb->num_disks;
+		mpb->num_disks++;
+		dst = (__u8 *)mpb->disk + sizeof(struct imsm_disk) * mpb->num_disks;
+
+		/* Now move the rest of the metadata to be properly aligned */
+		bytes_to_copy = mpb->mpb_size - (src - (__u8 *)mpb);
+		if (bytes_to_copy > 0)
+			memmove(dst, src, bytes_to_copy);
+
+		/* Update mpb size */
+		mpb->mpb_size += sizeof(struct imsm_disk);
+
+		/* Now fill in the new missing disk fields */
+		newMissing = (struct imsm_disk *)src;
+		sprintf((char *)newMissing->serial, "%s", "MISSING DISK");
+		/* copy the device size from the first disk */
+		newMissing->total_blocks = mpb->disk[0].total_blocks;
+		newMissing->scsi_id = 0x0;
+		newMissing->status = FAILED_DISK;
+	}
+}
+
+/* Check for unsupported migration features:
+ *  migration optimization area
+ */
+int check_mpb_migr_compatibility(struct intel_super *super) {
+	struct imsm_map *map0, *map1;
+	int i;
+
+	for (i = 0; i < super->anchor->num_raid_devs; i++) {
+		struct imsm_dev *dev_iter = __get_imsm_dev(super->anchor, i);
+
+		if (dev_iter->vol.migr_state == 1 &&
+		    dev_iter->vol.migr_type == MIGR_GEN_MIGR) {
+			/* This device is migrating */
+			map0 = get_imsm_map(dev_iter, 0);
+			map1 = get_imsm_map(dev_iter, 1);
+			if (map0->pba_of_lba0 != map1->pba_of_lba0)
+				/* migration optimization area was used */
+				return -1;
+		}
+	}
+	return 0;
+}
+
 static void __free_imsm(struct intel_super *super, int free_disks);
 
 /* load_imsm_mpb - read matrix metadata @@ -2700,6 +2861,21 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 		return 3;
 	}
 
+	/* Check for unsupported migration features */
+	if (check_mpb_migr_compatibility(super) != 0) {
+		if (devname)
+			fprintf(stderr,
+				Name ": Unsupported migration detected on %s\n",
+				devname);
+
+		return 4;
+	}
+
+	/* Now make sure that in case of migration
+	 * we'll convert raid personalities
+	 */
+	convert_raid_personalities(super);
+
 	/* FIXME the BBM log is disk specific so we cannot use this global
 	 * buffer for all disks.  Ok for now since we only look at the global
 	 * bbm_log_size parameter to gate assembly @@ -4559,6 +4735,8 @@ static void update_recovery_start(struct imsm_dev *dev, struct mdinfo *array)
 	rebuild->recovery_start = units * blocks_per_migr_unit(dev);  }
 
+int recover_backup_imsm(struct supertype *st, struct mdinfo *info,
+			void *ptr, int length);
 
 static struct mdinfo *container_content_imsm(struct supertype *st)  { @@ -4678,6 +4856,11 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 		}
 		/* now that the disk list is up-to-date fixup recovery_start */
 		update_recovery_start(dev, this);
+
+		/* check for reshape */
+		if (this->reshape_active == 1)
+			recover_backup_imsm(st, this, NULL, 0);
+
 		rest = this;
 	}
 

