From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 17/22] imsm: Prepare checkpoint update for general migration
Date: Thu, 02 Jun 2011 16:50:33 +0200
Message-ID: <20110602145032.27355.76208.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

mdadm has to prepare checkpoint information update and send it to mdmon.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2a11879..fa4e15d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1953,6 +1953,51 @@ out:
 }
 
 /*******************************************************************************
+ * function: imsm_create_metadata_checkpoint_update
+ * Description: It creates update for checkpoint change.
+ * Parameters:
+ *	super	: imsm internal array info
+ *	u	: pointer to prepared update
+ * Returns:
+ *	Uptate length.
+ *	If length is equal to 0, input pointer u contains no update
+ ******************************************************************************/
+static int imsm_create_metadata_checkpoint_update(
+	struct intel_super *super,
+	struct imsm_update_general_migration_checkpoint **u)
+{
+
+	int update_memory_size = 0;
+
+	dprintf("imsm_create_metadata_checkpoint_update(enter)\n");
+
+	if (u == NULL)
+		return 0;
+	*u = NULL;
+
+	/* size of all update data without anchor */
+	update_memory_size =
+		sizeof(struct imsm_update_general_migration_checkpoint);
+
+	*u = calloc(1, update_memory_size);
+	if (*u == NULL) {
+		dprintf("error: cannot get memory for "
+			"imsm_create_metadata_checkpoint_update update\n");
+		return 0;
+	}
+	(*u)->type = update_general_migration_checkpoint;
+	(*u)->curr_migr_unit = __le32_to_cpu(super->migr_rec->curr_migr_unit);
+	dprintf("imsm_create_metadata_checkpoint_update: prepared for %u\n",
+		(*u)->curr_migr_unit);
+
+	return update_memory_size;
+}
+
+
+static void imsm_update_metadata_locally(struct supertype *st,
+					 void *buf, int len);
+
+/*******************************************************************************
  * Function:	write_imsm_migr_rec
  * Description:	Function writes imsm migration record
  *		(at the last sector of disk)
@@ -1970,6 +2015,8 @@ static int write_imsm_migr_rec(struct supertype *st)
 	int fd = -1;
 	int retval = -1;
 	struct dl *sd;
+	int len;
+	struct imsm_update_general_migration_checkpoint *u;
 
 	for (sd = super->disks ; sd ; sd = sd->next) {
 		/* write to 2 first slots only */
@@ -1995,6 +2042,26 @@ static int write_imsm_migr_rec(struct supertype *st)
 		close(fd);
 		fd = -1;
 	}
+	/* update checkpoint information in metadata */
+	len = imsm_create_metadata_checkpoint_update(super, &u);
+
+	if (len <= 0) {
+		dprintf("imsm: Cannot prepare update\n");
+		goto out;
+	}
+	/* update metadata locally */
+	imsm_update_metadata_locally(st, u, len);
+	/* and possibly remotely */
+	if (st->update_tail) {
+		append_metadata_update(st, u, len);
+		/* during reshape we do all work inside metadata handler
+		 * manage_reshape(), so metadata update has to be triggered
+		 * insida it
+		 */
+		flush_metadata_updates(st);
+		st->update_tail = &st->updates;
+	} else
+		free(u);
 
 	retval = 0;
  out:

