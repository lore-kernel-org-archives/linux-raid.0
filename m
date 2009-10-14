From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 01/12] imsm: cleanup disk status tests
Date: Tue, 13 Oct 2009 19:10:21 -0700
Message-ID: <20091014021021.31570.90976.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Add is_failed(), is_configured(), and is_spare() helpers to clean up
disk status flag testing.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   53 +++++++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 07b0b90..9f57a68 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -612,6 +612,21 @@ static __u32 imsm_reserved_sectors(struct intel_super *super, struct dl *dl)
 }
 
 #ifndef MDASSEMBLE
+static int is_spare(struct imsm_disk *disk)
+{
+	return (disk->status & SPARE_DISK) == SPARE_DISK;
+}
+
+static int is_configured(struct imsm_disk *disk)
+{
+	return (disk->status & CONFIGURED_DISK) == CONFIGURED_DISK;
+}
+
+static int is_failed(struct imsm_disk *disk)
+{
+	return (disk->status & FAILED_DISK) == FAILED_DISK;
+}
+
 static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 {
 	__u64 sz;
@@ -676,7 +691,6 @@ static void print_imsm_disk(struct imsm_super *mpb, int index, __u32 reserved)
 {
 	struct imsm_disk *disk = __get_imsm_disk(mpb, index);
 	char str[MAX_RAID_SERIAL_LEN + 1];
-	__u32 s;
 	__u64 sz;
 
 	if (index < 0)
@@ -685,10 +699,9 @@ static void print_imsm_disk(struct imsm_super *mpb, int index, __u32 reserved)
 	printf("\n");
 	snprintf(str, MAX_RAID_SERIAL_LEN + 1, "%s", disk->serial);
 	printf("  Disk%02d Serial : %s\n", index, str);
-	s = disk->status;
-	printf("          State :%s%s%s\n", s&SPARE_DISK ? " spare" : "",
-					      s&CONFIGURED_DISK ? " active" : "",
-					      s&FAILED_DISK ? " failed" : "");
+	printf("          State :%s%s%s\n", is_spare(disk) ? " spare" : "",
+					    is_configured(disk) ? " active" : "",
+					    is_failed(disk) ? " failed" : "");
 	printf("             Id : %08x\n", __le32_to_cpu(disk->scsi_id));
 	sz = __le32_to_cpu(disk->total_blocks) - reserved;
 	printf("    Usable Size : %llu%s\n", (unsigned long long)sz,
@@ -1298,7 +1311,6 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 {
 	struct intel_super *super = st->sb;
 	struct imsm_disk *disk;
-	__u32 s;
 
 	if (super->current_vol >= 0) {
 		getinfo_super_imsm_volume(st, info);
@@ -1334,14 +1346,13 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 		disk = &super->disks->disk;
 		info->data_offset = __le32_to_cpu(disk->total_blocks) - reserved;
 		info->component_size = reserved;
-		s = disk->status;
-		info->disk.state  = s & CONFIGURED_DISK ? (1 << MD_DISK_ACTIVE) : 0;
+		info->disk.state  = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
 		/* we don't change info->disk.raid_disk here because
 		 * this state will be finalized in mdmon after we have
 		 * found the 'most fresh' version of the metadata
 		 */
-		info->disk.state |= s & FAILED_DISK ? (1 << MD_DISK_FAULTY) : 0;
-		info->disk.state |= s & SPARE_DISK ? 0 : (1 << MD_DISK_SYNC);
+		info->disk.state |= is_failed(disk) ? (1 << MD_DISK_FAULTY) : 0;
+		info->disk.state |= is_spare(disk) ? 0 : (1 << MD_DISK_SYNC);
 	}
 
 	/* only call uuid_from_super_imsm when this disk is part of a populated container,
@@ -3444,7 +3455,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			struct dl *d;
 			int idx;
 			int skip;
-			__u32 s;
 			__u32 ord;
 
 			skip = 0;
@@ -3456,9 +3466,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 
 			if (d == NULL)
 				skip = 1;
-
-			s = d ? d->disk.status : 0;
-			if (s & FAILED_DISK)
+			if (d && is_failed(&d->disk))
 				skip = 1;
 			if (ord & IMSM_ORD_REBUILD)
 				skip = 1;
@@ -3565,8 +3573,7 @@ static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
 				insync = 2;
 
 			disk = get_imsm_disk(super, idx);
-			if (!disk || disk->status & FAILED_DISK ||
-			    ord & IMSM_ORD_REBUILD)
+			if (!disk || is_failed(disk) || ord & IMSM_ORD_REBUILD)
 				insync--;
 
 			/* no in-sync disks left in this mirror the
@@ -3616,8 +3623,7 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev)
 		idx = ord_to_idx(ord);
 
 		disk = get_imsm_disk(super, idx);
-		if (!disk || disk->status & FAILED_DISK ||
-		    ord & IMSM_ORD_REBUILD)
+		if (!disk || is_failed(disk) || ord & IMSM_ORD_REBUILD)
 			failed++;
 	}
 
@@ -3676,7 +3682,7 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 		return 0;
 
 	ord = __le32_to_cpu(map->disk_ord_tbl[slot]);
-	if ((disk->status & FAILED_DISK) && (ord & IMSM_ORD_REBUILD))
+	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
 		return 0;
 
 	disk->status |= FAILED_DISK;
@@ -3877,7 +3883,7 @@ static struct dl *imsm_readd(struct intel_super *super, int idx, struct active_a
 		if (dl->index == i)
 			break;
 
-	if (dl && dl->disk.status & FAILED_DISK)
+	if (dl && is_failed(&dl->disk))
 		dl = NULL;
 
 	if (dl)
@@ -3915,11 +3921,10 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 			continue;
 
 		/* skip in use or failed drives */
-		if (dl->disk.status & FAILED_DISK || idx == dl->index ||
+		if (is_failed(&dl->disk) || idx == dl->index ||
 		    dl->index == -2) {
 			dprintf("%x:%x status (failed: %d index: %d)\n",
-				dl->major, dl->minor,
-				(dl->disk.status & FAILED_DISK) == FAILED_DISK, idx);
+				dl->major, dl->minor, is_failed(&dl->disk), idx);
 			continue;
 		}
 
@@ -4221,7 +4226,7 @@ static void imsm_process_update(struct supertype *st,
 			if (i == u->slot)
 				continue;
 			disk = get_imsm_disk(super, get_imsm_disk_idx(dev, i));
-			if (!disk || disk->status & FAILED_DISK)
+			if (!disk || is_failed(disk))
 				failed++;
 		}
 

