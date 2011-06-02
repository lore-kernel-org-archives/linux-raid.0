From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 08/22] imsm: Implement imsm_manage_reshape(), reshape workhorse
Date: Thu, 02 Jun 2011 16:49:17 +0200
Message-ID: <20110602144917.27355.71066.stgit@gklab-128-111.igk.intel.com>
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

Before reshape is started, mdadm should check again if there is only one
array (in container) under reshape. Then function "divides" array in to
"migration units" that can fits migration copy area and enters main loop.
It checks if current "migration unit" requires to be backed up.
If necessary mdadm saves it to copy area and updates migration record.
Then MD-driver is directed to perform reshape step (by "migration unit" size)
and checkpoint is moved forward. In this way reshape is executed until
array ends.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 mdadm.h       |    1 
 super-intel.c |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 206 insertions(+), 5 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index e97cab0..a1ae2b9 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1189,6 +1189,7 @@ extern int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
 			 struct supertype *st, unsigned long stripes,
 			 int *fds, unsigned long long *offsets,
 			 int dests, int *destfd, unsigned long long *destoffsets);
+void abort_reshape(struct mdinfo *sra);
 
 extern char *devnum2devname(int num);
 extern void fmt_devname(char *name, int num);
diff --git a/super-intel.c b/super-intel.c
index c395a48..b4038d3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8309,16 +8309,216 @@ int wait_for_reshape_imsm(struct mdinfo *sra, unsigned long long to_complete,
 
 }
 
+/*******************************************************************************
+ * Function:	imsm_manage_reshape
+ * Description:	Function finds array under reshape and it manages reshape
+ *		process. It creates stripes backups (if required) and sets
+ *		checheckpoits.
+ * Parameters:
+ *	afd		: Backup handle (nattive) - not used
+ *	sra		: general array info
+ *	reshape		: reshape parameters - not used
+ *	st		: supertype structure
+ *	blocks		: size of critical section [blocks]
+ *	fds		: table of source device descriptor
+ *	offsets		: start of array (offest per devices)
+ *	dests		: not used
+ *	destfd		: table of destination device descriptor
+ *	destoffsets	: table of destination offsets (per device)
+ * Returns:
+ *	1 : success, reshape is done
+ *	0 : fail
+ ******************************************************************************/
 static int imsm_manage_reshape(
 	int afd, struct mdinfo *sra, struct reshape *reshape,
-	struct supertype *st, unsigned long stripes,
+	struct supertype *st, unsigned long backup_blocks,
 	int *fds, unsigned long long *offsets,
 	int dests, int *destfd, unsigned long long *destoffsets)
 {
-	/* Just use child_monitor for now */
-	return child_monitor(
-		afd, sra, reshape, st, stripes,
-		fds, offsets, dests, destfd, destoffsets);
+	int ret_val = 0;
+	struct intel_super *super = st->sb;
+	struct intel_dev *dv = NULL;
+	struct imsm_dev *dev = NULL;
+	struct imsm_map *map_src, *map_dest;
+	int migr_vol_qan = 0;
+	int ndata, odata; /* [bytes] */
+	int chunk; /* [bytes] */
+	struct migr_record *migr_rec;
+	char *buf = NULL;
+	unsigned int buf_size; /* [bytes] */
+	unsigned long long max_position; /* array size [bytes] */
+	unsigned long long next_step; /* [blocks]/[bytes] */
+	unsigned long long old_data_stripe_length;
+	unsigned long long new_data_stripe_length;
+	unsigned long long start_src; /* [bytes] */
+	unsigned long long start; /* [bytes] */
+	unsigned long long start_buf_shift; /* [bytes] */
+
+	if (!fds || !offsets || !destfd || !destoffsets || !sra)
+		goto abort;
+
+	/* Find volume during the reshape */
+	for (dv = super->devlist; dv; dv = dv->next) {
+		if (dv->dev->vol.migr_type == MIGR_GEN_MIGR
+		    && dv->dev->vol.migr_state == 1) {
+			dev = dv->dev;
+			migr_vol_qan++;
+		}
+	}
+	/* Only one volume can migrate at the same time */
+	if (migr_vol_qan != 1) {
+		fprintf(stderr, Name " : %s", migr_vol_qan ?
+			"Number of migrating volumes greater than 1\n" :
+			"There is no volume during migrationg\n");
+		goto abort;
+	}
+
+	map_src = get_imsm_map(dev, 1);
+	if (map_src == NULL)
+		goto abort;
+	map_dest = get_imsm_map(dev, 0);
+
+	ndata = imsm_num_data_members(dev, 0);
+	odata = imsm_num_data_members(dev, 1);
+
+	chunk = map_src->blocks_per_strip * 512;
+	old_data_stripe_length = odata * chunk;
+
+	migr_rec = super->migr_rec;
+
+	/* [bytes] */
+	sra->new_chunk = __le16_to_cpu(map_dest->blocks_per_strip) * 512;
+	sra->new_level = map_dest->raid_level;
+	new_data_stripe_length = sra->new_chunk * ndata;
+
+	/* initialize migration record for start condition */
+	if (sra->reshape_progress == 0)
+		init_migr_record_imsm(st, dev, sra);
+
+	/* size for data */
+	buf_size = __le32_to_cpu(migr_rec->blocks_per_unit) * 512;
+	/* extend  buffer size for parity disk */
+	buf_size += __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
+	/* add space for stripe aligment */
+	buf_size += old_data_stripe_length;
+	if (posix_memalign((void **)&buf, 4096, buf_size)) {
+		dprintf("imsm: Cannot allocate checpoint buffer\n");
+		goto abort;
+	}
+
+	max_position =
+		__le32_to_cpu(migr_rec->post_migr_vol_cap) +
+		((unsigned long long)__le32_to_cpu(
+			 migr_rec->post_migr_vol_cap_hi) << 32);
+
+	while (__le32_to_cpu(migr_rec->curr_migr_unit) <
+		__le32_to_cpu(migr_rec->num_migr_units)) {
+		/* current reshape position [blocks] */
+		unsigned long long current_position =
+			__le32_to_cpu(migr_rec->blocks_per_unit)
+			* __le32_to_cpu(migr_rec->curr_migr_unit);
+		unsigned long long border;
+
+		next_step = __le32_to_cpu(migr_rec->blocks_per_unit);
+
+		if ((current_position + next_step) > max_position)
+			next_step = max_position - current_position;
+
+		start = (map_src->pba_of_lba0 + dev->reserved_blocks +
+			 current_position) * 512;
+
+		/* allign reading start to old geometry */
+		start_buf_shift = start % old_data_stripe_length;
+		start_src = start - start_buf_shift;
+
+		border = (start_src / odata) - (start / ndata);
+		border /= 512;
+		if (border <= __le32_to_cpu(migr_rec->dest_depth_per_unit)) {
+			/* save critical stripes to buf
+			 * start     - start address of current unit
+			 *             to backup [bytes]
+			 * start_src - start address of current unit
+			 *             to backup alligned to source array
+			 *             [bytes]
+			 */
+			unsigned long long next_step_filler = 0;
+			unsigned long long copy_length = next_step * 512;
+
+			/* allign copy area length to stripe in old geometry */
+			next_step_filler = (copy_length + start_buf_shift)
+					   % old_data_stripe_length;
+			if (next_step_filler)
+				next_step_filler = old_data_stripe_length
+						   - next_step_filler;
+			dprintf("save_stripes() parameters: start = %llu,"
+				"\tstart_src = %llu,\tnext_step*512 = %llu,"
+				"\tstart_in_buf_shift = %llu,"
+				"\tnext_step_filler = %llu\n",
+				start, start_src, copy_length,
+				start_buf_shift, next_step_filler);
+
+			if (save_stripes(fds, offsets, map_src->num_members,
+					 chunk, sra->array.level,
+					 sra->array.layout, 0, NULL, start_src,
+					 copy_length +
+					 next_step_filler + start_buf_shift,
+					 buf)) {
+				dprintf("imsm: Cannot save stripes"
+					" to buffer\n");
+				goto abort;
+			}
+			/* Convert data to destination format and store it
+			 * in backup general migration area
+			 */
+			if (save_backup_imsm(st, dev, sra,
+				buf + start_buf_shift,
+				ndata, copy_length)) {
+				dprintf("imsm: Cannot save stripes to "
+					"target devices\n");
+				goto abort;
+			}
+			if (save_checkpoint_imsm(st, sra,
+						 UNIT_SRC_IN_CP_AREA)) {
+				dprintf("imsm: Cannot write checkpoint to "
+					"migration record (UNIT_SRC_IN_CP_AREA)\n");
+				goto abort;
+			}
+			/* decrease backup_blocks */
+			if (backup_blocks > (unsigned long)next_step)
+				backup_blocks -= next_step;
+			else
+				backup_blocks = 0;
+		}
+		/* When data backed up, checkpoint stored,
+		 * kick the kernel to reshape unit of data
+		 */
+		next_step = next_step + sra->reshape_progress;
+		sysfs_set_num(sra, NULL, "suspend_lo", sra->reshape_progress);
+		sysfs_set_num(sra, NULL, "suspend_hi", next_step);
+
+		/* wait until reshape finish */
+		if (wait_for_reshape_imsm(sra, next_step, ndata) < 0)
+			dprintf("wait_for_reshape_imsm returned error,"
+				" but we ignore it!\n");
+
+		sra->reshape_progress = next_step;
+
+		if (save_checkpoint_imsm(st, sra, UNIT_SRC_NORMAL)) {
+				dprintf("imsm: Cannot write checkpoint to "
+					"migration record (UNIT_SRC_NORMAL)\n");
+				goto abort;
+		}
+
+	}
+
+	/* return '1' if done */
+	ret_val = 1;
+abort:
+	if (buf)
+		free(buf);
+	abort_reshape(sra);
+
+	return ret_val;
 }
 #endif /* MDASSEMBLE */
 

