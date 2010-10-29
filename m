From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [PATCH] IMSM: update to function generating unique volume id.
Date: Fri, 29 Oct 2010 16:59:09 +0200
Message-ID: <20101029145909.19391.85293.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Intel metadata now contains the information of total number of volumes
created within the given container. The current value of this number is used
as volume' serial number. Intel metadata does not track uuid's and metadata
handler synthesizes one using sha1 on signature, orig_family_number (these
does not change from the original algorithm) and raid_dev_num (new filed in
imsm_dev structure representing volume' serial number).

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---
 super-intel.c |   92 +++++++++++++++++++--------------------------------------
 1 files changed, 30 insertions(+), 62 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b880a74..71e99ef 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -142,7 +142,9 @@ struct imsm_dev {
 	__u16 cache_policy;
 	__u8  cng_state;
 	__u8  cng_sub_state;
-#define IMSM_DEV_FILLERS 10
+	__u16 raid_dev_num;
+	__u16 filler1;
+#define IMSM_DEV_FILLERS 9
 	__u32 filler[IMSM_DEV_FILLERS];
 	struct imsm_vol vol;
 } __attribute__ ((packed));
@@ -163,8 +165,10 @@ struct imsm_super {
 	__u32 orig_family_num;		/* 0x40 - 0x43 original family num */
 	__u32 pwr_cycle_count;		/* 0x44 - 0x47 simulated power cycle count for array */
 	__u32 bbm_log_size;		/* 0x48 - 0x4B - size of bad Block Mgmt Log in bytes */
-#define IMSM_FILLERS 35
-	__u32 filler[IMSM_FILLERS];	/* 0x4C - 0xD7 RAID_MPB_FILLERS */
+	__u16 raid_devs_created;	/* 0x4C - 0x4D - number of RaidDevs created within the given */
+	__u16 fill1;				/* container (used for generating unique volume id) */
+#define IMSM_FILLERS 34
+	__u32 filler[IMSM_FILLERS];	/* 0x50 - 0xD7 RAID_MPB_FILLERS */
 	struct imsm_disk disk[1];	/* 0xD8 diskTbl[numDisks] */
 	/* here comes imsm_dev[num_raid_devs] */
 	/* here comes BBM logs */
@@ -718,6 +722,7 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 	}
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
+	printf("  Serial Number : %u\n", __le16_to_cpu(dev->raid_dev_num));
 }
 
 static void print_imsm_disk(struct imsm_super *mpb, int index, __u32 reserved)
@@ -762,6 +767,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("    Orig Family : %08x\n", __le32_to_cpu(mpb->orig_family_num));
 	printf("         Family : %08x\n", __le32_to_cpu(mpb->family_num));
 	printf("     Generation : %08x\n", __le32_to_cpu(mpb->generation_num));
+	printf("  Total Created : %u\n", __le16_to_cpu(mpb->raid_devs_created));
 	getinfo_super_imsm(st, &info);
 	fname_from_uuid(st, &info, nbuf, ':');
 	printf("           UUID : %s\n", nbuf + 5);
@@ -1186,9 +1192,9 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	/* imsm does not track uuid's so we synthesis one using sha1 on
 	 * - The signature (Which is constant for all imsm array, but no matter)
 	 * - the orig_family_num of the container
-	 * - the index number of the volume
-	 * - the 'serial' number of the volume.
-	 * Hopefully these are all constant.
+	 * - the raid_dev_num of device is the serial number of volume
+	 *   created within the current container,
+         * - the pba_of_lba0 - the start address of partition.
 	 */
 	struct intel_super *super = st->sb;
 
@@ -1210,12 +1216,13 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	if (super->current_vol >= 0)
 		dev = get_imsm_dev(super, super->current_vol);
 	if (dev) {
-		__u32 vol = super->current_vol;
-		sha1_process_bytes(&vol, sizeof(vol), &ctx);
-		sha1_process_bytes(dev->volume, MAX_RAID_SERIAL_LEN, &ctx);
+		__u32 vol = dev->raid_dev_num;
+		sha1_process_bytes(&vol, sizeof(__u32), &ctx);
+		vol = dev->vol.map[0].pba_of_lba0;
+		sha1_process_bytes(&vol, sizeof(__u32), &ctx);
 	}
 	sha1_finish_ctx(&ctx, buf);
-	memcpy(uuid, buf, 4*4);
+	memcpy(uuid, buf, 4 * sizeof(int));
 }
 
 #if 0
@@ -3148,6 +3155,12 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		/* initialized in add_to_super */
 		set_imsm_ord_tbl_ent(map, i, IMSM_ORD_REBUILD);
 	}
+	mpb->raid_devs_created++;
+	if (mpb->raid_devs_created == 0)
+		mpb->raid_devs_created++;
+
+	dev->raid_dev_num = mpb->raid_devs_created;
+
 	mpb->num_raid_devs++;
 
 	dv->dev = dev;
@@ -3205,6 +3218,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 		return 0;
 	}
 
+	mpb->raid_devs_created = 0;
 	mpb->attributes = MPB_ATTRIB_CHECKSUM_VERIFY;
 
 	version = (char *) mpb->sig;
@@ -3379,6 +3393,7 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 	spare->attributes = MPB_ATTRIB_CHECKSUM_VERIFY;
 	spare->num_disks = 1,
 	spare->num_raid_devs = 0,
+	spare->raid_devs_created = mpb->raid_devs_created;
 	spare->cache_size = mpb->cache_size,
 	spare->pwr_cycle_count = __cpu_to_le32(1),
 
@@ -4130,7 +4145,6 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev);
 static int kill_subarray_imsm(struct supertype *st)
 {
 	/* remove the subarray currently referenced by ->current_vol */
-	__u8 i;
 	struct intel_dev **dp;
 	struct intel_super *super = st->sb;
 	__u8 current_vol = super->current_vol;
@@ -4140,27 +4154,6 @@ static int kill_subarray_imsm(struct supertype *st)
 		return 2;
 	super->current_vol = -1; /* invalidate subarray cursor */
 
-	/* block deletions that would change the uuid of active subarrays
-	 *
-	 * FIXME when immutable ids are available, but note that we'll
-	 * also need to fixup the invalidated/active subarray indexes in
-	 * mdstat
-	 */
-	for (i = 0; i < mpb->num_raid_devs; i++) {
-		char subarray[4];
-
-		if (i < current_vol)
-			continue;
-		sprintf(subarray, "%u", i);
-		if (is_subarray_active(subarray, st->devname)) {
-			fprintf(stderr,
-				Name ": deleting subarray-%d would change the UUID of active subarray-%d, aborting\n",
-				current_vol, i);
-
-			return 2;
-		}
-	}
-
 	if (st->update_tail) {
 		struct imsm_update_kill_array *u = malloc(sizeof(*u));
 
@@ -5317,6 +5310,10 @@ static void imsm_process_update(struct supertype *st,
 		dv->next = super->devlist;
 		super->devlist = dv;
 		mpb->num_raid_devs++;
+		mpb->raid_devs_created++;
+		if (mpb->raid_devs_created == 0)
+			mpb->raid_devs_created++;
+		dev->raid_dev_num = mpb->raid_devs_created;
 
 		imsm_update_version_info(super);
 		break;
@@ -5333,29 +5330,7 @@ static void imsm_process_update(struct supertype *st,
 	case update_kill_array: {
 		struct imsm_update_kill_array *u = (void *) update->buf;
 		int victim = u->dev_idx;
-		struct active_array *a;
 		struct intel_dev **dp;
-		struct imsm_dev *dev;
-
-		/* sanity check that we are not affecting the uuid of
-		 * active arrays, or deleting an active array
-		 *
-		 * FIXME when immutable ids are available, but note that
-		 * we'll also need to fixup the invalidated/active
-		 * subarray indexes in mdstat
-		 */
-		for (a = st->arrays; a; a = a->next)
-			if (a->info.container_member >= victim)
-				break;
-		/* by definition if mdmon is running at least one array
-		 * is active in the container, so checking
-		 * mpb->num_raid_devs is just extra paranoia
-		 */
-		dev = get_imsm_dev(super, victim);
-		if (a || !dev || mpb->num_raid_devs == 1) {
-			dprintf("failed to delete subarray-%d\n", victim);
-			break;
-		}
 
 		for (dp = &super->devlist; *dp;)
 			if ((*dp)->index == (unsigned)super->current_vol) {
@@ -5373,19 +5348,12 @@ static void imsm_process_update(struct supertype *st,
 		struct imsm_update_rename_array *u = (void *) update->buf;
 		char name[MAX_RAID_SERIAL_LEN+1];
 		int target = u->dev_idx;
-		struct active_array *a;
 		struct imsm_dev *dev;
 
-		/* sanity check that we are not affecting the uuid of
-		 * an active array
-		 */
 		snprintf(name, MAX_RAID_SERIAL_LEN, "%s", (char *) u->name);
 		name[MAX_RAID_SERIAL_LEN] = '\0';
-		for (a = st->arrays; a; a = a->next)
-			if (a->info.container_member == target)
-				break;
 		dev = get_imsm_dev(super, u->dev_idx);
-		if (a || !dev || !check_name(super, name, 1)) {
+		if (!dev || !check_name(super, name, 1)) {
 			dprintf("failed to rename subarray-%d\n", target);
 			break;
 		}

