From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2 8/9] imsm: implement "--examine-badblocks" command
Date: Tue, 29 Nov 2016 14:02:34 +0100
Message-ID: <1480424555-31509-9-git-send-email-tomasz.majchrzak@intel.com>
References: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Implement "--examine-badblocks" command to provide list of bad blocks in
metadata for a disk.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index fd2145c..ab14fce 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9900,6 +9900,61 @@ static struct md_bb *imsm_get_badblocks(struct active_array *a, int slot)
 	return &super->bb;
 }
 /*******************************************************************************
+* Function:   examine_badblocks_imsm
+* Description: Prints list of bad blocks on a disk to the standard output
+*
+* Parameters:
+*     st	: metadata handler
+*     fd	: open file descriptor for device
+*     devname	: device name
+* Returns:
+*     0 : Success
+*     1 : Error
+******************************************************************************/
+static int examine_badblocks_imsm(struct supertype *st, int fd, char *devname)
+{
+	struct intel_super *super = st->sb;
+	struct bbm_log *log = super->bbm_log;
+	struct dl *d = NULL;
+	int any = 0;
+
+	for (d = super->disks; d ; d = d->next) {
+		if (strcmp(d->devname, devname) == 0)
+			break;
+	}
+
+	if ((d == NULL) || (d->index < 0)) { /* serial mismatch probably */
+		pr_err("%s doesn't appear to be part of a raid array\n",
+		       devname);
+		return 1;
+	}
+
+	if (log != NULL) {
+		unsigned int i;
+		struct bbm_log_entry *entry = &log->marked_block_entries[0];
+
+		for (i = 0; i < log->entry_count; i++) {
+			if (entry[i].disk_ordinal == d->index) {
+				unsigned long long sector = __le48_to_cpu(
+					&entry[i].defective_block_start);
+				int cnt = entry[i].marked_count + 1;
+
+				if (!any) {
+					printf("Bad-blocks on %s:\n", devname);
+					any = 1;
+				}
+
+				printf("%20llu for %d sectors\n", sector, cnt);
+			}
+		}
+	}
+
+	if (!any)
+		printf("No bad-blocks list configured on %s\n", devname);
+
+	return 0;
+}
+/*******************************************************************************
  * Function:	init_migr_record_imsm
  * Description:	Function inits imsm migration record
  * Parameters:
@@ -11420,6 +11475,7 @@ struct superswitch super_imsm = {
 	.manage_reshape = imsm_manage_reshape,
 	.recover_backup = recover_backup_imsm,
 	.copy_metadata = copy_metadata_imsm,
+	.examine_badblocks = examine_badblocks_imsm,
 #endif
 	.match_home	= match_home_imsm,
 	.uuid_from_super= uuid_from_super_imsm,
-- 
1.8.3.1

