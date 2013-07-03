From: mwilck@arcor.de
Subject: [PATCH 07/27] DDF: find_vdcr: account for secondary RAID level
Date: Wed,  3 Jul 2013 22:27:47 +0200
Message-ID: <1372883287-8859-8-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

If secondary RAID level is taken into account, translation between
the md RAID member (raid_disk) and the index of a physical disk
in a BVD becomes more complex.

Also, take into account that the member list can have unused entries
(this is independent of secondary RAID level).

Adapt usage of find_vdcr() accordingly

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 87 insertions(+), 13 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index ae24bb9..c448bff 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1441,13 +1441,76 @@ static int match_home_ddf(struct supertype *st, char *homehost)
 }
 
 #ifndef MDASSEMBLE
-static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int inst)
+static int find_index_in_bvd(const struct ddf_super *ddf,
+			     const struct vd_config *conf, unsigned int n,
+			     unsigned int *n_bvd)
+{
+	/*
+	 * Find the index of the n-th valid physical disk in this BVD
+	 */
+	unsigned int i, j;
+	for (i = 0, j = 0; i < ddf->mppe &&
+		     j < __be16_to_cpu(conf->prim_elmnt_count); i++) {
+		if (conf->phys_refnum[i] != 0xffffffff) {
+			if (n == j) {
+				*n_bvd = i;
+				return 1;
+			}
+			j++;
+		}
+	}
+	dprintf("%s: couldn't find BVD member %u (total %u)\n",
+		__func__, n, __be16_to_cpu(conf->prim_elmnt_count));
+	return 0;
+}
+
+static struct vd_config *find_vdcr(struct ddf_super *ddf, unsigned int inst,
+				   unsigned int n,
+				   unsigned int *n_bvd, struct vcl **vcl)
 {
 	struct vcl *v;
 
-	for (v = ddf->conflist; v; v = v->next)
-		if (inst == v->vcnum)
-			return &v->conf;
+	for (v = ddf->conflist; v; v = v->next) {
+		unsigned int nsec, ibvd;
+		struct vd_config *conf;
+		if (inst != v->vcnum)
+			continue;
+		conf = &v->conf;
+		if (conf->sec_elmnt_count == 1) {
+			if (find_index_in_bvd(ddf, conf, n, n_bvd)) {
+				*vcl = v;
+				return conf;
+			} else
+				goto bad;
+		}
+		if (v->other_bvds == NULL) {
+			pr_err("%s: BUG: other_bvds is NULL, nsec=%u\n",
+			       __func__, conf->sec_elmnt_count);
+			goto bad;
+		}
+		nsec = n / __be16_to_cpu(conf->prim_elmnt_count);
+		if (conf->sec_elmnt_seq != nsec) {
+			for (ibvd = 1; ibvd < conf->sec_elmnt_count; ibvd++) {
+				if (v->other_bvds[ibvd-1] == NULL)
+					continue;
+				if (v->other_bvds[ibvd-1]->sec_elmnt_seq
+				    == nsec)
+					break;
+			}
+			if (ibvd == conf->sec_elmnt_count)
+				goto bad;
+			conf = v->other_bvds[ibvd-1];
+		}
+		if (!find_index_in_bvd(ddf, conf,
+				       n - nsec*conf->sec_elmnt_count, n_bvd))
+			goto bad;
+		dprintf("%s: found disk %u as member %u in bvd %d of array %u\n"
+			, __func__, n, *n_bvd, ibvd-1, inst);
+		*vcl = v;
+		return conf;
+	}
+bad:
+	pr_err("%s: Could't find disk %d in array %u\n", __func__, n, inst);
 	return NULL;
 }
 #endif
@@ -3769,9 +3832,11 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 static void ddf_set_disk(struct active_array *a, int n, int state)
 {
 	struct ddf_super *ddf = a->container->sb;
-	unsigned int inst = a->info.container_member;
-	struct vd_config *vc = find_vdcr(ddf, inst);
-	int pd = find_phys(ddf, vc->phys_refnum[n]);
+	unsigned int inst = a->info.container_member, n_bvd;
+	struct vcl *vcl;
+	struct vd_config *vc = find_vdcr(ddf, inst, (unsigned int)n,
+					 &n_bvd, &vcl);
+	int pd;
 	int i, st, working;
 	struct mdinfo *mdi;
 	struct dl *dl;
@@ -3796,15 +3861,21 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 	if (!dl)
 		return;
 
+	pd = find_phys(ddf, vc->phys_refnum[n_bvd]);
 	if (pd < 0 || pd != dl->pdnum) {
 		/* disk doesn't currently exist or has changed.
 		 * If it is now in_sync, insert it. */
+		dprintf("%s: phys disk not found for %d: %d/%d ref %08x\n",
+			__func__, dl->pdnum, dl->major, dl->minor,
+			dl->disk.refnum);
+		dprintf("%s: array %u disk %u ref %08x pd %d\n",
+			__func__, inst, n_bvd, vc->phys_refnum[n_bvd], pd);
 		if ((state & DS_INSYNC) && ! (state & DS_FAULTY)) {
-			struct vcl *vcl;
-			pd = dl->pdnum;
-			vc->phys_refnum[n] = dl->disk.refnum;
-			vcl = container_of(vc, struct vcl, conf);
-			vcl->lba_offset[n] = mdi->data_offset;
+			__u64 *lba_offset;
+			pd = dl->pdnum; /* FIXME: is this really correct ? */
+			vc->phys_refnum[n_bvd] = dl->disk.refnum;
+			lba_offset = (__u64 *)&vc->phys_refnum[ddf->mppe];
+			lba_offset[n_bvd] = mdi->data_offset;
 			ddf->phys->entries[pd].type &=
 				~__cpu_to_be16(DDF_Global_Spare);
 			ddf->phys->entries[pd].type |=
@@ -4187,8 +4258,10 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	struct metadata_update *mu;
 	struct dl *dl;
 	int i;
+	struct vcl *vcl;
 	struct vd_config *vc;
 	__u64 *lba;
+	unsigned int n_bvd;
 
 	for (d = a->info.devs ; d ; d = d->next) {
 		if ((d->curr_state & DS_FAULTY) &&
@@ -4353,7 +4426,8 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	mu->space = NULL;
 	mu->space_list = NULL;
 	mu->next = *updates;
-	vc = find_vdcr(ddf, a->info.container_member);
+	vc = find_vdcr(ddf, a->info.container_member, di->disk.raid_disk,
+		       &n_bvd, &vcl);
 	memcpy(mu->buf, vc, ddf->conf_rec_len * 512);
 
 	vc = (struct vd_config*)mu->buf;
-- 
1.7.1
