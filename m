From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2 4/9] imsm: record new bad block in bad block log
Date: Tue, 29 Nov 2016 14:02:30 +0100
Message-ID: <1480424555-31509-5-git-send-email-tomasz.majchrzak@intel.com>
References: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Check for a duplicate first or try to merge it with existing bad block.
If block range exceeds BBM_LOG_MAX_LBA_ENTRY_VAL (256) blocks, it must
be split into multiple ranges. Fail if maximum number of bad blocks has
been already reached.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 142 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 134 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b2afdff..2af44d9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -843,6 +843,86 @@ static __u32 get_imsm_bbm_log_size(struct bbm_log *log)
 		sizeof(log->entry_count) +
 		log->entry_count * sizeof(struct bbm_log_entry);
 }
+
+/* check if bad block is not partially stored in bbm log */
+static int is_stored_in_bbm(struct bbm_log *log, const __u8 idx, const unsigned
+			    long long sector, const int length, __u32 *pos)
+{
+	__u32 i;
+
+	for (i = *pos; i < log->entry_count; i++) {
+		struct bbm_log_entry *entry = &log->marked_block_entries[i];
+		unsigned long long bb_start;
+		unsigned long long bb_end;
+
+		bb_start = __le48_to_cpu(&entry->defective_block_start);
+		bb_end = bb_start + (entry->marked_count + 1);
+
+		if ((entry->disk_ordinal == idx) && (bb_start >= sector) &&
+		    (bb_end <= sector + length)) {
+			*pos = i;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/* record new bad block in bbm log */
+static int record_new_badblock(struct bbm_log *log, const __u8 idx, unsigned
+			       long long sector, int length)
+{
+	int new_bb = 0;
+	__u32 pos = 0;
+	struct bbm_log_entry *entry = NULL;
+
+	while (is_stored_in_bbm(log, idx, sector, length, &pos)) {
+		struct bbm_log_entry *e = &log->marked_block_entries[pos];
+
+		if ((e->marked_count + 1 == BBM_LOG_MAX_LBA_ENTRY_VAL) &&
+		    (__le48_to_cpu(&e->defective_block_start) == sector)) {
+			sector += BBM_LOG_MAX_LBA_ENTRY_VAL;
+			length -= BBM_LOG_MAX_LBA_ENTRY_VAL;
+			pos = pos + 1;
+			continue;
+		}
+		entry = e;
+		break;
+	}
+
+	if (entry) {
+		int cnt = (length <= BBM_LOG_MAX_LBA_ENTRY_VAL) ? length :
+			BBM_LOG_MAX_LBA_ENTRY_VAL;
+		entry->defective_block_start = __cpu_to_le48(sector);
+		entry->marked_count = cnt - 1;
+		if (cnt == length)
+			return 1;
+		sector += cnt;
+		length -= cnt;
+	}
+
+	new_bb = ROUND_UP(length, BBM_LOG_MAX_LBA_ENTRY_VAL) /
+		BBM_LOG_MAX_LBA_ENTRY_VAL;
+	if (log->entry_count + new_bb > BBM_LOG_MAX_ENTRIES)
+		return 0;
+
+	while (length > 0) {
+		int cnt = (length <= BBM_LOG_MAX_LBA_ENTRY_VAL) ? length :
+			BBM_LOG_MAX_LBA_ENTRY_VAL;
+		struct bbm_log_entry *entry =
+			&log->marked_block_entries[log->entry_count];
+
+		entry->defective_block_start = __cpu_to_le48(sector);
+		entry->marked_count = cnt - 1;
+		entry->disk_ordinal = idx;
+
+		sector += cnt;
+		length -= cnt;
+
+		log->entry_count++;
+	}
+
+	return new_bb;
+}
 #endif /* MDASSEMBLE */
 
 /* allocate and load BBM log from metadata */
@@ -7734,6 +7814,25 @@ skip_mark_checkpoint:
 	return consistent;
 }
 
+static int imsm_disk_slot_to_ord(struct active_array *a, int slot)
+{
+	int inst = a->info.container_member;
+	struct intel_super *super = a->container->sb;
+	struct imsm_dev *dev = get_imsm_dev(super, inst);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+
+	if (slot > map->num_members) {
+		pr_err("imsm: imsm_disk_slot_to_ord %d out of range 0..%d\n",
+		       slot, map->num_members - 1);
+		return -1;
+	}
+
+	if (slot < 0)
+		return -1;
+
+	return get_imsm_ord_tbl_ent(dev, slot, MAP_0);
+}
+
 static void imsm_set_disk(struct active_array *a, int n, int state)
 {
 	int inst = a->info.container_member;
@@ -7744,19 +7843,14 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 	struct mdinfo *mdi;
 	int recovery_not_finished = 0;
 	int failed;
-	__u32 ord;
+	int ord;
 	__u8 map_state;
 
-	if (n > map->num_members)
-		pr_err("imsm: set_disk %d out of range 0..%d\n",
-			n, map->num_members - 1);
-
-	if (n < 0)
+	ord = imsm_disk_slot_to_ord(a, n);
+	if (ord < 0)
 		return;
 
 	dprintf("imsm: set_disk %d:%x\n", n, state);
-
-	ord = get_imsm_ord_tbl_ent(dev, n, MAP_0);
 	disk = get_imsm_disk(super, ord_to_idx(ord));
 
 	/* check for new failures */
@@ -9653,6 +9747,37 @@ int validate_container_imsm(struct mdinfo *info)
 }
 #ifndef MDASSEMBLE
 /*******************************************************************************
+* Function:   imsm_record_badblock
+* Description: This routine stores new bad block record in BBM log
+*
+* Parameters:
+*     a		: array containing a bad block
+*     slot	: disk number containing a bad block
+*     sector	: bad block sector
+*     length	: bad block sectors range
+* Returns:
+*     1 : Success
+*     0 : Error
+******************************************************************************/
+static int imsm_record_badblock(struct active_array *a, int slot,
+			  unsigned long long sector, int length)
+{
+	struct intel_super *super = a->container->sb;
+	int ord;
+	int ret;
+
+	ord = imsm_disk_slot_to_ord(a, slot);
+	if (ord < 0)
+		return 0;
+
+	ret = record_new_badblock(super->bbm_log, ord_to_idx(ord), sector,
+				   length);
+	if (ret)
+		super->updates_pending++;
+
+	return ret;
+}
+/*******************************************************************************
  * Function:	init_migr_record_imsm
  * Description:	Function inits imsm migration record
  * Parameters:
@@ -11205,5 +11330,6 @@ struct superswitch super_imsm = {
 	.activate_spare = imsm_activate_spare,
 	.process_update = imsm_process_update,
 	.prepare_update = imsm_prepare_update,
+	.record_bad_block = imsm_record_badblock,
 #endif /* MDASSEMBLE */
 };
-- 
1.8.3.1

