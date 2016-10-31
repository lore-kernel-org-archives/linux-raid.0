From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 5/8] imsm: clear bad block from bad block log
Date: Mon, 31 Oct 2016 15:50:51 +0100
Message-ID: <1477925454-16809-5-git-send-email-tomasz.majchrzak@intel.com>
References: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 5c54b8c..0b84012 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -920,6 +920,28 @@ static int record_new_badblock(struct bbm_log *log, const __u8 idx, unsigned
 
 	return new_bb;
 }
+
+/* clear given bad block */
+static int clear_badblock(struct bbm_log *log, const __u8 idx, const unsigned
+			  long long sector, const int length) {
+	__u32 i = 0;
+
+	while (i < log->entry_count) {
+		struct bbm_log_entry *entries = log->marked_block_entries;
+
+		if ((entries[i].disk_ordinal == idx) &&
+		    (__le48_to_cpu(&entries[i].defective_block_start) ==
+		     sector) && (entries[i].marked_count + 1 == length)) {
+			if (i < log->entry_count - 1)
+				entries[i] = entries[log->entry_count - 1];
+			log->entry_count--;
+			break;
+		}
+		i++;
+	}
+
+	return 1;
+}
 #endif /* MDASSEMBLE */
 
 /* allocate and load BBM log from metadata */
@@ -9602,6 +9624,36 @@ static int imsm_record_badblock(struct active_array *a, int slot,
 	return ret;
 }
 /*******************************************************************************
+* Function:   imsm_clear_badblock
+* Description: This routine clears bad block record from BBM log
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
+static int imsm_clear_badblock(struct active_array *a, int slot,
+			unsigned long long sector, int length)
+{
+	struct intel_super *super = a->container->sb;
+	int ord;
+	int ret;
+
+	ord = imsm_disk_slot_to_ord(a, slot);
+	if (ord < 0)
+		return 0;
+
+	ret = clear_badblock(super->bbm_log, ord_to_idx(ord), sector, length);
+	if (ret)
+		super->updates_pending++;
+
+	return ret;
+}
+/*******************************************************************************
  * Function:	init_migr_record_imsm
  * Description:	Function inits imsm migration record
  * Parameters:
@@ -11152,5 +11204,6 @@ struct superswitch super_imsm = {
 	.process_update = imsm_process_update,
 	.prepare_update = imsm_prepare_update,
 	.record_bad_block = imsm_record_badblock,
+	.clear_bad_block  = imsm_clear_badblock,
 #endif /* MDASSEMBLE */
 };
-- 
1.8.3.1

