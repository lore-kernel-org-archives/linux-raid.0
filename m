From: mwilck@arcor.de
Subject: [PATCH 13/27] DDF: Simplify allocation of "other BVDs"
Date: Wed,  3 Jul 2013 22:27:53 +0200
Message-ID: <1372883287-8859-14-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Instead of allocating the other_bvds array and every element
separately, allocate all in a single chunk. Also, move allocation
in a subroutine as it's used in several places.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   86 ++++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 933485d..1ff8a28 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -863,13 +863,35 @@ static int load_ddf_global(int fd, struct ddf_super *super, char *devname)
 	return 0;
 }
 
+#define DDF_UNUSED_BVD 0xff
+static int alloc_other_bvds(const struct ddf_super *ddf, struct vcl *vcl)
+{
+	unsigned int n_vds = vcl->conf.sec_elmnt_count - 1;
+	unsigned int i, vdsize;
+	void *p;
+	if (n_vds == 0) {
+		vcl->other_bvds = NULL;
+		return 0;
+	}
+	vdsize = ddf->conf_rec_len * 512;
+	if (posix_memalign(&p, 512, n_vds *
+			   (vdsize +  sizeof(struct vd_config *))) != 0)
+		return -1;
+	vcl->other_bvds = (struct vd_config **) (p + n_vds * vdsize);
+	for (i = 0; i < n_vds; i++) {
+		vcl->other_bvds[i] = p + i * vdsize;
+		memset(vcl->other_bvds[i], 0, vdsize);
+		vcl->other_bvds[i]->sec_elmnt_seq = DDF_UNUSED_BVD;
+	}
+	return 0;
+}
+
 static void add_other_bvd(struct vcl *vcl, struct vd_config *vd,
 			  unsigned int len)
 {
 	int i;
 	for (i = 0; i < vcl->conf.sec_elmnt_count-1; i++)
-		if (vcl->other_bvds[i] != NULL &&
-		    vcl->other_bvds[i]->sec_elmnt_seq == vd->sec_elmnt_seq)
+		if (vcl->other_bvds[i]->sec_elmnt_seq == vd->sec_elmnt_seq)
 			break;
 
 	if (i < vcl->conf.sec_elmnt_count-1) {
@@ -877,18 +899,13 @@ static void add_other_bvd(struct vcl *vcl, struct vd_config *vd,
 			return;
 	} else {
 		for (i = 0; i < vcl->conf.sec_elmnt_count-1; i++)
-			if (vcl->other_bvds[i] == NULL)
+			if (vcl->other_bvds[i]->sec_elmnt_seq == DDF_UNUSED_BVD)
 				break;
 		if (i == vcl->conf.sec_elmnt_count-1) {
 			pr_err("no space for sec level config %u, count is %u\n",
 			       vd->sec_elmnt_seq, vcl->conf.sec_elmnt_count);
 			return;
 		}
-		if (posix_memalign((void **)&vcl->other_bvds[i], 512, len)
-		    != 0) {
-			pr_err("%s could not allocate vd buf\n", __func__);
-			return;
-		}
 	}
 	memcpy(vcl->other_bvds[i], vd, len);
 }
@@ -1006,12 +1023,13 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 			}
 			vcl->next = super->conflist;
 			vcl->block_sizes = NULL; /* FIXME not for CONCAT */
-			if (vd->sec_elmnt_count > 1)
-				vcl->other_bvds =
-					xcalloc(vd->sec_elmnt_count - 1,
-						sizeof(struct vd_config *));
-			else
-				vcl->other_bvds = NULL;
+			vcl->conf.sec_elmnt_count = vd->sec_elmnt_count;
+			if (alloc_other_bvds(super, vcl) != 0) {
+				pr_err("%s could not allocate other bvds\n",
+				       __func__);
+				free(vcl);
+				return 1;
+			};
 			super->conflist = vcl;
 			dl->vlist[vnum++] = vcl;
 		}
@@ -1129,13 +1147,12 @@ static void free_super_ddf(struct supertype *st)
 		ddf->conflist = v->next;
 		if (v->block_sizes)
 			free(v->block_sizes);
-		if (v->other_bvds) {
-			int i;
-			for (i = 0; i < v->conf.sec_elmnt_count-1; i++)
-				if (v->other_bvds[i] != NULL)
-					free(v->other_bvds[i]);
-			free(v->other_bvds);
-		}
+		if (v->other_bvds)
+			/*
+			   v->other_bvds[0] points to beginning of buffer,
+			   see alloc_other_bvds()
+			*/
+			free(v->other_bvds[0]);
 		free(v);
 	}
 	while (ddf->dlist) {
@@ -1663,8 +1680,6 @@ static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int inst,
 		nsec = n / __be16_to_cpu(conf->prim_elmnt_count);
 		if (conf->sec_elmnt_seq != nsec) {
 			for (ibvd = 1; ibvd < conf->sec_elmnt_count; ibvd++) {
-				if (v->other_bvds[ibvd-1] == NULL)
-					continue;
 				if (v->other_bvds[ibvd-1]->sec_elmnt_seq
 				    == nsec)
 					break;
@@ -2359,8 +2374,6 @@ static int init_super_ddf_bvd(struct supertype *st,
 	vcl->lba_offset = (__u64*) &vcl->conf.phys_refnum[ddf->mppe];
 	vcl->vcnum = venum;
 	vcl->block_sizes = NULL; /* FIXME not for CONCAT */
-	vcl->other_bvds = NULL;
-
 	vc = &vcl->conf;
 
 	vc->magic = DDF_VD_CONF_MAGIC;
@@ -2377,6 +2390,12 @@ static int init_super_ddf_bvd(struct supertype *st,
 		return 0;
 	}
 	vc->sec_elmnt_seq = 0;
+	if (alloc_other_bvds(ddf, vcl) != 0) {
+		pr_err("%s could not allocate other bvds\n",
+		       __func__);
+		free(vcl);
+		return 0;
+	}
 	vc->blocks = __cpu_to_be64(info->size * 2);
 	vc->array_blocks = __cpu_to_be64(
 		calc_array_size(info->level, info->raid_disks, info->layout,
@@ -3391,7 +3410,7 @@ static int check_secondary(const struct vcl *vc)
 	__set_sec_seen(conf->sec_elmnt_seq);
 	for (i = 0; i < conf->sec_elmnt_count-1; i++) {
 		const struct vd_config *bvd = vc->other_bvds[i];
-		if (bvd == NULL)
+		if (bvd->sec_elmnt_seq == DDF_UNUSED_BVD)
 			continue;
 		if (bvd->srl != conf->srl) {
 			pr_err("Inconsistent secondary RAID level across BVDs\n");
@@ -3449,9 +3468,9 @@ static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 
 	for (n = 1; n < vc->conf.sec_elmnt_count; n++) {
 		struct vd_config *vd = vc->other_bvds[n-1];
-		if (vd == NULL)
-			continue;
 		sec = vd->sec_elmnt_seq;
+		if (sec == DDF_UNUSED_BVD)
+			continue;
 		for (i = 0, j = 0 ; i < nmax ; i++) {
 			if (vd->phys_refnum[i] != 0xffffffff)
 				j++;
@@ -3753,12 +3772,13 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 
 		vl1->next = first->conflist;
 		vl1->block_sizes = NULL;
-		if (vl2->conf.sec_elmnt_count > 1) {
-			vl1->other_bvds = xcalloc(vl2->conf.sec_elmnt_count - 1,
-						  sizeof(struct vd_config *));
-		} else
-			vl1->other_bvds = NULL;
 		memcpy(&vl1->conf, &vl2->conf, first->conf_rec_len*512);
+		if (alloc_other_bvds(first, vl1) != 0) {
+			pr_err("%s could not allocate other bvds\n",
+			       __func__);
+			free(vl1);
+			return 3;
+		}
 		vl1->lba_offset = (__u64 *)
 			&vl1->conf.phys_refnum[first->mppe];
 		for (vd = 0; vd < max_vds; vd++)
-- 
1.7.1
