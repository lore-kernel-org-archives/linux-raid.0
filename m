From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 14/22] imsm: Implement recover_backup_imsm() for imsm metadata
Date: Thu, 02 Jun 2011 16:50:08 +0200
Message-ID: <20110602145008.27355.98018.stgit@gklab-128-111.igk.intel.com>
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

Add ability to restore data backed up in General Migration Copy Area
in case of unexpected reshape interruption.
Function restores data during an array assembly and then reshape
is continues from next checkpoint.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |  129 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 129 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d80e530..8ebc1e4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5299,6 +5299,7 @@ static void update_recovery_start(struct intel_super *super,
 	rebuild->recovery_start = units * blocks_per_migr_unit(super, dev);
 }
 
+static int recover_backup_imsm(struct supertype *st, struct mdinfo *info);
 
 static struct mdinfo *container_content_imsm(struct supertype *st, char *subarray)
 {
@@ -5462,6 +5463,11 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		/* now that the disk list is up-to-date fixup recovery_start */
 		update_recovery_start(super, dev, this);
 		this->array.spare_disks += spare_disks;
+
+		/* check for reshape */
+		if (this->reshape_active == 1)
+			recover_backup_imsm(st, this);
+
 		rest = this;
 	}
 
@@ -7684,6 +7690,127 @@ int save_checkpoint_imsm(struct supertype *st, struct mdinfo *info, int state)
 	return 0;
 }
 
+static __u64 blocks_per_migr_unit(struct intel_super *super,
+				  struct imsm_dev *dev);
+
+/*******************************************************************************
+ * Function:	recover_backup_imsm
+ * Description:	Function recovers critical data from the Migration Copy Area
+ *		while assembling an array.
+ * Parameters:
+ *	super	: imsm internal array info
+ *	info	: general array info
+ * Returns:
+ *	0 : success (or there is no data to recover)
+ *	1 : fail
+ ******************************************************************************/
+int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
+{
+	struct intel_super *super = st->sb;
+	struct migr_record *migr_rec = super->migr_rec;
+	struct imsm_map *map_dest = NULL;
+	struct intel_dev *id = NULL;
+	unsigned long long read_offset;
+	unsigned long long write_offset;
+	unsigned unit_len;
+	int *targets = NULL;
+	int new_disks, i, err;
+	char *buf = NULL;
+	int retval = 1;
+	unsigned long curr_migr_unit = __le32_to_cpu(migr_rec->curr_migr_unit);
+	unsigned long num_migr_units = __le32_to_cpu(migr_rec->num_migr_units);
+	int ascending = __le32_to_cpu(migr_rec->ascending_migr);
+	char buffer[20];
+
+	err = sysfs_get_str(info, NULL, "array_state", (char *)buffer, 20);
+	if (err < 1)
+		return 1;
+
+	/* recover data only during assemblation */
+	if (strncmp(buffer, "inactive", 8) != 0)
+		return 0;
+	/* no data to recover */
+	if (__le32_to_cpu(migr_rec->rec_status) == UNIT_SRC_NORMAL)
+		return 0;
+	if (curr_migr_unit >= num_migr_units)
+		return 1;
+
+	/* find device during reshape */
+	for (id = super->devlist; id; id = id->next)
+		if (is_gen_migration(id->dev))
+			break;
+	if (id == NULL)
+		return 1;
+
+	map_dest = get_imsm_map(id->dev, 0);
+	new_disks = map_dest->num_members;
+
+	read_offset = (unsigned long long)
+			__le32_to_cpu(migr_rec->ckpt_area_pba) * 512;
+
+	write_offset = ((unsigned long long)
+			__le32_to_cpu(migr_rec->dest_1st_member_lba) +
+			info->data_offset) * 512;
+
+	unit_len = __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
+	if (posix_memalign((void **)&buf, 512, unit_len) != 0)
+		goto abort;
+	targets = malloc(new_disks * sizeof(int));
+	if (!targets)
+		goto abort;
+
+	open_backup_targets(info, new_disks, targets);
+
+	for (i = 0; i < new_disks; i++) {
+		if (lseek64(targets[i], read_offset, SEEK_SET) < 0) {
+			fprintf(stderr,
+				Name ": Cannot seek to block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+		if (read(targets[i], buf, unit_len) != unit_len) {
+			fprintf(stderr,
+				Name ": Cannot read copy area block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+		if (lseek64(targets[i], write_offset, SEEK_SET) < 0) {
+			fprintf(stderr,
+				Name ": Cannot seek to block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+		if (write(targets[i], buf, unit_len) != unit_len) {
+			fprintf(stderr,
+				Name ": Cannot restore block: %s\n",
+				strerror(errno));
+			goto abort;
+		}
+	}
+
+	if (ascending && curr_migr_unit < (num_migr_units-1))
+		curr_migr_unit++;
+
+	migr_rec->curr_migr_unit = __le32_to_cpu(curr_migr_unit);
+	super->migr_rec->rec_status = __cpu_to_le32(UNIT_SRC_NORMAL);
+	if (write_imsm_migr_rec(st) == 0) {
+		__u64 blocks_per_unit = blocks_per_migr_unit(super, id->dev);
+		info->reshape_progress = curr_migr_unit * blocks_per_unit;
+		retval = 0;
+	}
+
+abort:
+	if (targets) {
+		for (i = 0; i < new_disks; i++)
+			if (targets[i])
+				close(targets[i]);
+		free(targets);
+	}
+	if (buf)
+		free(buf);
+	return retval;
+}
+
 static char disk_by_path[] = "/dev/disk/by-path/";
 
 static const char *imsm_get_disk_controller_domain(const char *path)
@@ -8701,6 +8828,8 @@ struct superswitch super_imsm = {
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,
 
+	.recover_backup = recover_backup_imsm,
+
 	.external	= 1,
 	.name = "imsm",
 

