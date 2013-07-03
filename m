From: mwilck@arcor.de
Subject: [PATCH 16/27] DDF: use LBA_OFFSET macro instead of lba_offset field
Date: Wed,  3 Jul 2013 22:27:56 +0200
Message-ID: <1372883287-8859-17-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Remove the lba_offset field from struct vcl. This field acted as
a "cache" for the address of the lba_offset field in the vd_config
structure. This isn't useful any more if there are multiple
vd_configs in a vcl.

This patch also adds __cpu_to_be64 in two places where it has been
quite obviously forgotten (ddf_set_disk, ddf_activate_spare).

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 1893f45..f22c0e3 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -311,6 +311,7 @@ struct vd_config {
       /*__u64	lba_offset[0];  LBA offset in each phys.  Note extents in a
 				bvd are always the same size */
 };
+#define LBA_OFFSET(ddf, vd) ((__u64 *) &(vd)->phys_refnum[(ddf)->mppe])
 
 /* vd_config.cache_pol[7] is a bitmap */
 #define	DDF_cache_writeback	1	/* else writethrough */
@@ -407,8 +408,6 @@ struct ddf_super {
 			char space[512];
 			struct {
 				struct vcl	*next;
-				__u64		*lba_offset; /* location in 'conf' of
-							      * the lba table */
 				unsigned int	vcnum; /* index into ->virt */
 				struct vd_config **other_bvds;
 				__u64		*block_sizes; /* NULL if all the same */
@@ -1034,9 +1033,6 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 			dl->vlist[vnum++] = vcl;
 		}
 		memcpy(&vcl->conf, vd, super->conf_rec_len*512);
-		vcl->lba_offset = (__u64*)
-			&vcl->conf.phys_refnum[super->mppe];
-
 		for (i=0; i < max_virt_disks ; i++)
 			if (memcmp(super->virt->entries[i].guid,
 				   vcl->conf.guid, DDF_GUID_LEN)==0)
@@ -1844,7 +1840,8 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	info->custom_array_size	  = 0;
 
 	if (cd >= 0 && (unsigned)cd < ddf->mppe) {
-		info->data_offset	  = __be64_to_cpu(vc->lba_offset[cd]);
+		info->data_offset =
+			__be64_to_cpu(LBA_OFFSET(ddf, &vc->conf)[cd]);
 		if (vc->block_sizes)
 			info->component_size = vc->block_sizes[cd];
 		else
@@ -2303,7 +2300,8 @@ static struct extent *get_extents(struct ddf_super *ddf, struct dl *dl)
 		for (j = 0; j < v->conf.prim_elmnt_count; j++)
 			if (v->conf.phys_refnum[j] == dl->disk.refnum) {
 				/* This device plays role 'j' in  'v'. */
-				rv[n].start = __be64_to_cpu(v->lba_offset[j]);
+				rv[n].start = __be64_to_cpu(
+					LBA_OFFSET(ddf, &v->conf)[j]);
 				rv[n].size = __be64_to_cpu(v->conf.blocks);
 				n++;
 				break;
@@ -2371,7 +2369,6 @@ static int init_super_ddf_bvd(struct supertype *st,
 		pr_err("%s could not allocate vd_config\n", __func__);
 		return 0;
 	}
-	vcl->lba_offset = (__u64*) &vcl->conf.phys_refnum[ddf->mppe];
 	vcl->vcnum = venum;
 	vcl->block_sizes = NULL; /* FIXME not for CONCAT */
 	vc = &vcl->conf;
@@ -2472,7 +2469,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 		return;
 
 	vc = &ddf->currentconf->conf;
-	lba_offset = ddf->currentconf->lba_offset;
+	lba_offset = LBA_OFFSET(ddf, &ddf->currentconf->conf);
 
 	ex = get_extents(ddf, dl);
 	if (!ex)
@@ -3572,7 +3569,6 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			struct dl *d;
 			const struct vd_config *bvd;
 			unsigned int iphys;
-			__u64 *lba_offset;
 			int stt;
 
 			if (ddf->phys->entries[pd].refnum == 0xFFFFFFFF)
@@ -3611,8 +3607,8 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			dev->recovery_start = MaxSector;
 
 			dev->events = __be32_to_cpu(ddf->primary.seq);
-			lba_offset =  (__u64 *)&bvd->phys_refnum[ddf->mppe];
-			dev->data_offset = __be64_to_cpu(lba_offset[iphys]);
+			dev->data_offset =
+				__be64_to_cpu(LBA_OFFSET(ddf, bvd)[iphys]);
 			dev->component_size = __be64_to_cpu(bvd->blocks);
 			if (d->devname)
 				strcpy(dev->name, d->devname);
@@ -3784,8 +3780,6 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 			free(vl1);
 			return 3;
 		}
-		vl1->lba_offset = (__u64 *)
-			&vl1->conf.phys_refnum[first->mppe];
 		for (vd = 0; vd < max_vds; vd++)
 			if (!memcmp(first->virt->entries[vd].guid,
 				    vl1->conf.guid, DDF_GUID_LEN))
@@ -4046,11 +4040,10 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 		dprintf("%s: array %u disk %u ref %08x pd %d\n",
 			__func__, inst, n_bvd, vc->phys_refnum[n_bvd], pd);
 		if ((state & DS_INSYNC) && ! (state & DS_FAULTY)) {
-			__u64 *lba_offset;
 			pd = dl->pdnum; /* FIXME: is this really correct ? */
 			vc->phys_refnum[n_bvd] = dl->disk.refnum;
-			lba_offset = (__u64 *)&vc->phys_refnum[ddf->mppe];
-			lba_offset[n_bvd] = mdi->data_offset;
+			LBA_OFFSET(ddf, vc)[n_bvd] =
+				__cpu_to_be64(mdi->data_offset);
 			ddf->phys->entries[pd].type &=
 				~__cpu_to_be16(DDF_Global_Spare);
 			ddf->phys->entries[pd].type |=
@@ -4244,8 +4237,6 @@ static void ddf_process_update(struct supertype *st,
 			update->space = NULL;
 			vcl->next = ddf->conflist;
 			memcpy(&vcl->conf, vc, update->len);
-			vcl->lba_offset = (__u64*)
-				&vcl->conf.phys_refnum[mppe];
 			ent = find_vde_by_guid(ddf, vc->guid);
 			if (ent == DDF_NOTFOUND)
 				return;
@@ -4568,7 +4559,8 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	for (di = rv ; di ; di = di->next) {
 		vc->phys_refnum[di->disk.raid_disk] =
 			ddf->phys->entries[dl->pdnum].refnum;
-		lba[di->disk.raid_disk] = di->data_offset;
+		LBA_OFFSET(ddf, vc)[di->disk.raid_disk]
+			= __cpu_to_be64(di->data_offset);
 	}
 	*updates = mu;
 	return rv;
-- 
1.7.1
