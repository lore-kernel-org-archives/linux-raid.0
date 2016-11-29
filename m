From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2 7/9] imsm: provide list of bad blocks for an array
Date: Tue, 29 Nov 2016 14:02:33 +0100
Message-ID: <1480424555-31509-8-git-send-email-tomasz.majchrzak@intel.com>
References: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Provide list of bad blocks using memory allocated in advance so it's
safe to call it from monitor.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 731878c..fd2145c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -393,6 +393,7 @@ struct intel_super {
 	struct intel_hba *hba; /* device path of the raid controller for this metadata */
 	const struct imsm_orom *orom; /* platform firmware support */
 	struct intel_super *next; /* (temp) list for disambiguating family_num */
+	struct md_bb bb;	/* memory for get_bad_blocks call */
 };
 
 struct intel_disk {
@@ -4298,6 +4299,7 @@ static void __free_imsm(struct intel_super *super, int free_disks)
 static void free_imsm(struct intel_super *super)
 {
 	__free_imsm(super, 1);
+	free(super->bb.entries);
 	free(super);
 }
 
@@ -4318,6 +4320,14 @@ static struct intel_super *alloc_super(void)
 
 	super->current_vol = -1;
 	super->create_offset = ~((unsigned long long) 0);
+
+	super->bb.entries = malloc(BBM_LOG_MAX_ENTRIES *
+				   sizeof(struct md_bb_entry));
+	if (!super->bb.entries) {
+		free(super);
+		return NULL;
+	}
+
 	return super;
 }
 
@@ -9862,6 +9872,34 @@ static int imsm_clear_badblock(struct active_array *a, int slot,
 	return ret;
 }
 /*******************************************************************************
+* Function:   imsm_get_badblocks
+* Description: This routine get list of bad blocks for an array
+*
+* Parameters:
+*     a		: array
+*     slot	: disk number
+* Returns:
+*     bb	: structure containing bad blocks
+*     NULL	: error
+******************************************************************************/
+static struct md_bb *imsm_get_badblocks(struct active_array *a, int slot)
+{
+	int inst = a->info.container_member;
+	struct intel_super *super = a->container->sb;
+	struct imsm_dev *dev = get_imsm_dev(super, inst);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+	int ord;
+
+	ord = imsm_disk_slot_to_ord(a, slot);
+	if (ord < 0)
+		return NULL;
+
+	get_volume_badblocks(super->bbm_log, ord_to_idx(ord), pba_of_lba0(map),
+			     blocks_per_member(map), &super->bb);
+
+	return &super->bb;
+}
+/*******************************************************************************
  * Function:	init_migr_record_imsm
  * Description:	Function inits imsm migration record
  * Parameters:
@@ -11416,5 +11454,6 @@ struct superswitch super_imsm = {
 	.prepare_update = imsm_prepare_update,
 	.record_bad_block = imsm_record_badblock,
 	.clear_bad_block  = imsm_clear_badblock,
+	.get_bad_blocks   = imsm_get_badblocks,
 #endif /* MDASSEMBLE */
 };
-- 
1.8.3.1

