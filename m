From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2 6/9] imsm: clear bad blocks if disk becomes unavailable
Date: Tue, 29 Nov 2016 14:02:32 +0100
Message-ID: <1480424555-31509-7-git-send-email-tomasz.majchrzak@intel.com>
References: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If a disk fails or goes missing, clear the bad blocks associated with it
from metadata. If necessary, update disk ordinals.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ec592c2..731878c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -924,6 +924,24 @@ static int record_new_badblock(struct bbm_log *log, const __u8 idx, unsigned
 	return new_bb;
 }
 
+/* clear all bad blocks for given disk */
+static void clear_disk_badblocks(struct bbm_log *log, const __u8 idx)
+{
+	__u32 i = 0;
+
+	while (i < log->entry_count) {
+		struct bbm_log_entry *entries = log->marked_block_entries;
+
+		if (entries[i].disk_ordinal == idx) {
+			if (i < log->entry_count - 1)
+				entries[i] = entries[log->entry_count - 1];
+			log->entry_count--;
+		} else {
+			i++;
+		}
+	}
+}
+
 /* clear given bad block */
 static int clear_badblock(struct bbm_log *log, const __u8 idx, const unsigned
 			  long long sector, const int length) {
@@ -7505,7 +7523,8 @@ static int is_resyncing(struct imsm_dev *dev)
 }
 
 /* return true if we recorded new information */
-static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
+static int mark_failure(struct intel_super *super,
+			struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 {
 	__u32 ord;
 	int slot;
@@ -7547,12 +7566,16 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	}
 	if (map->failed_disk_num == 0xff)
 		map->failed_disk_num = slot;
+
+	clear_disk_badblocks(super->bbm_log, ord_to_idx(ord));
+
 	return 1;
 }
 
-static void mark_missing(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
+static void mark_missing(struct intel_super *super,
+			 struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 {
-	mark_failure(dev, disk, idx);
+	mark_failure(super, dev, disk, idx);
 
 	if (disk->scsi_id == __cpu_to_le32(~(__u32)0))
 		return;
@@ -7588,7 +7611,7 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 			end_migration(dev, super, map_state);
 	}
 	for (dl = super->missing; dl; dl = dl->next)
-		mark_missing(dev, &dl->disk, dl->index);
+		mark_missing(super, dev, &dl->disk, dl->index);
 	super->updates_pending++;
 }
 
@@ -7877,7 +7900,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 
 	/* check for new failures */
 	if (state & DS_FAULTY) {
-		if (mark_failure(dev, disk, ord_to_idx(ord)))
+		if (mark_failure(super, dev, disk, ord_to_idx(ord)))
 			super->updates_pending++;
 	}
 
@@ -8947,7 +8970,7 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 	for (du = super->missing; du; du = du->next)
 		if (du->index >= 0) {
 			set_imsm_ord_tbl_ent(map, du->index, du->index);
-			mark_missing(dv->dev, &du->disk, du->index);
+			mark_missing(super, dv->dev, &du->disk, du->index);
 		}
 
 	return 1;
@@ -9521,8 +9544,9 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 	struct dl *iter;
 	struct imsm_dev *dev;
 	struct imsm_map *map;
-	int i, j, num_members;
+	unsigned int i, j, num_members;
 	__u32 ord;
+	struct bbm_log *log = super->bbm_log;
 
 	dprintf("deleting device[%d] from imsm_super\n", index);
 
@@ -9555,6 +9579,14 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 		}
 	}
 
+	for (i = 0; i < log->entry_count; i++) {
+		struct bbm_log_entry *entry = &log->marked_block_entries[i];
+
+		if (entry->disk_ordinal <= index)
+			continue;
+		entry->disk_ordinal--;
+	}
+
 	mpb->num_disks--;
 	super->updates_pending++;
 	if (*dlp) {
-- 
1.8.3.1

