From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 3/8] imsm: give md list of known bad blocks on startup
Date: Mon, 31 Oct 2016 15:50:49 +0100
Message-ID: <1477925454-16809-3-git-send-email-tomasz.majchrzak@intel.com>
References: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

On create set bad block support flag for each drive. On assmble also
provide a list of known bad blocks. Bad blocks are stored in metadata
per disk so they have to be checked against volume boundaries
beforehand.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 0591c55..77a2ca9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -880,6 +880,56 @@ static int load_bbm_log(struct intel_super *super)
 	return 0;
 }
 
+/* checks if bad block is within volume boundaries */
+static int is_bad_block_in_volume(const struct bbm_log_entry *entry,
+			const unsigned long long start_sector,
+			const unsigned long long size)
+{
+	unsigned long long bb_start;
+	unsigned long long bb_end;
+
+	bb_start = __le48_to_cpu(&entry->defective_block_start);
+	bb_end = bb_start + (entry->marked_count + 1);
+
+	if (((bb_start >= start_sector) && (bb_start < start_sector + size)) ||
+	    ((bb_end >= start_sector) && (bb_end <= start_sector + size)))
+		return 1;
+
+	return 0;
+}
+
+/* get list of bad blocks on a drive for a volume */
+static void get_volume_badblocks(const struct bbm_log *log, const __u8 idx,
+			const unsigned long long start_sector,
+			const unsigned long long size,
+			struct md_bb *bbs)
+{
+	__u32 count = 0;
+	__u32 i;
+
+	for (i = 0; i < log->entry_count; i++) {
+		const struct bbm_log_entry *ent =
+			&log->marked_block_entries[i];
+		struct md_bb_entry *bb;
+
+		if ((ent->disk_ordinal == idx) &&
+		    is_bad_block_in_volume(ent, start_sector, size)) {
+
+			if (!bbs->entries) {
+				bbs->entries = xmalloc(BBM_LOG_MAX_ENTRIES *
+						     sizeof(*bb));
+				if (!bbs->entries)
+					break;
+			}
+
+			bb = &bbs->entries[count++];
+			bb->sector = __le48_to_cpu(&ent->defective_block_start);
+			bb->length = ent->marked_count + 1;
+		}
+	}
+	bbs->count = count;
+}
+
 /*
  * for second_map:
  *  == MAP_0 get first map
@@ -2887,6 +2937,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 							info->array.level,
 							info->array.chunk_size,
 							info->component_size);
+	info->bb.supported = 0;
 
 	memset(info->uuid, 0, sizeof(info->uuid));
 	info->recovery_start = MaxSector;
@@ -3053,6 +3104,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	info->name[0] = 0;
 	info->recovery_start = MaxSector;
 	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
+	info->bb.supported = 0;
 
 	/* do we have the all the insync disks that we expect? */
 	mpb = super->anchor;
@@ -6986,6 +7038,12 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			info_d->events = __le32_to_cpu(mpb->generation_num);
 			info_d->data_offset = pba_of_lba0(map);
 			info_d->component_size = blocks_per_member(map);
+
+			info_d->bb.supported = 0;
+			get_volume_badblocks(super->bbm_log, ord_to_idx(ord),
+					     info_d->data_offset,
+					     info_d->component_size,
+					     &info_d->bb);
 		}
 		/* now that the disk list is up-to-date fixup recovery_start */
 		update_recovery_start(super, dev, this);
@@ -7989,6 +8047,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		di->data_offset = pba_of_lba0(map);
 		di->component_size = a->info.component_size;
 		di->container_member = inst;
+		di->bb.supported = 0;
 		super->random = random32();
 		di->next = rv;
 		rv = di;
-- 
1.8.3.1

