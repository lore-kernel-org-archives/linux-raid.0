From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2 9/9] imsm: 4kn support for bad block log
Date: Tue, 29 Nov 2016 14:02:35 +0100
Message-ID: <1480424555-31509-10-git-send-email-tomasz.majchrzak@intel.com>
References: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index ab14fce..04f14ee 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1547,6 +1547,7 @@ void convert_to_4k(struct intel_super *super)
 	struct imsm_super *mpb = super->anchor;
 	struct imsm_disk *disk;
 	int i;
+	__u32 bbm_log_size = __le32_to_cpu(mpb->bbm_log_size);
 
 	for (i = 0; i < mpb->num_disks ; i++) {
 		disk = __get_imsm_disk(mpb, i);
@@ -1575,6 +1576,24 @@ void convert_to_4k(struct intel_super *super)
 			set_pba_of_lba0(map, pba_of_lba0(map)/IMSM_4K_DIV);
 		}
 	}
+	if (bbm_log_size) {
+		struct bbm_log *log = (void *)mpb +
+			__le32_to_cpu(mpb->mpb_size) - bbm_log_size;
+		__u32 i;
+
+		for (i = 0; i < log->entry_count; i++) {
+			struct bbm_log_entry *entry =
+				&log->marked_block_entries[i];
+
+			__u8 count = entry->marked_count + 1;
+			unsigned long long sector =
+				__le48_to_cpu(&entry->defective_block_start);
+
+			entry->defective_block_start =
+				__cpu_to_le48(sector/IMSM_4K_DIV);
+			entry->marked_count = max(count/IMSM_4K_DIV, 1) - 1;
+		}
+	}
 
 	mpb->check_sum = __gen_imsm_checksum(mpb);
 }
@@ -1656,6 +1675,7 @@ void convert_from_4k(struct intel_super *super)
 	struct imsm_super *mpb = super->anchor;
 	struct imsm_disk *disk;
 	int i;
+	__u32 bbm_log_size = __le32_to_cpu(mpb->bbm_log_size);
 
 	for (i = 0; i < mpb->num_disks ; i++) {
 		disk = __get_imsm_disk(mpb, i);
@@ -1685,6 +1705,24 @@ void convert_from_4k(struct intel_super *super)
 			set_pba_of_lba0(map, pba_of_lba0(map)*IMSM_4K_DIV);
 		}
 	}
+	if (bbm_log_size) {
+		struct bbm_log *log = (void *)mpb +
+			__le32_to_cpu(mpb->mpb_size) - bbm_log_size;
+		__u32 i;
+
+		for (i = 0; i < log->entry_count; i++) {
+			struct bbm_log_entry *entry =
+				&log->marked_block_entries[i];
+
+			__u8 count = entry->marked_count + 1;
+			unsigned long long sector =
+				__le48_to_cpu(&entry->defective_block_start);
+
+			entry->defective_block_start =
+				__cpu_to_le48(sector*IMSM_4K_DIV);
+			entry->marked_count = count*IMSM_4K_DIV - 1;
+		}
+	}
 
 	mpb->check_sum = __gen_imsm_checksum(mpb);
 }
-- 
1.8.3.1

