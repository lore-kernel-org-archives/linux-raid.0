From: mwilck@arcor.de
Subject: [PATCH 17/27] DDF: get_extents: support secondary RAID level
Date: Wed,  3 Jul 2013 22:27:57 +0200
Message-ID: <1372883287-8859-18-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Use get_pd_index_from_refnum() in get_extents to determine
matching VD. This will ensure RAID 10 (secondary RAID level)
support, too.

This also fixes a bug in the previous get_extents() code (missing
__be16_to_cpu for conf.prim_elmnt_count).

DDF test case (10ddf-create) verified.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index f22c0e3..e7aa0ad 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -467,6 +467,11 @@ static void pr_state(const struct ddf_super *ddf, const char *msg) {}
 #define ddf_set_updates_pending(x) \
 	do { (x)->updates_pending = 1; pr_state(x, __func__); } while (0)
 
+static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
+					     __u32 refnum, unsigned int nmax,
+					     const struct vd_config **bvd,
+					     unsigned int *idx);
+
 static unsigned int calc_crc(void *buf, int len)
 {
 	/* crcs are always at the same place as in the ddf_header */
@@ -2289,23 +2294,21 @@ static struct extent *get_extents(struct ddf_super *ddf, struct dl *dl)
 	 */
 	struct extent *rv;
 	int n = 0;
-	unsigned int i, j;
+	unsigned int i;
 
 	rv = xmalloc(sizeof(struct extent) * (ddf->max_part + 2));
 
 	for (i = 0; i < ddf->max_part; i++) {
+		const struct vd_config *bvd;
+		unsigned int ibvd;
 		struct vcl *v = dl->vlist[i];
-		if (v == NULL)
+		if (v == NULL ||
+		    get_pd_index_from_refnum(v, dl->disk.refnum, ddf->mppe,
+					     &bvd, &ibvd) == DDF_NOTFOUND)
 			continue;
-		for (j = 0; j < v->conf.prim_elmnt_count; j++)
-			if (v->conf.phys_refnum[j] == dl->disk.refnum) {
-				/* This device plays role 'j' in  'v'. */
-				rv[n].start = __be64_to_cpu(
-					LBA_OFFSET(ddf, &v->conf)[j]);
-				rv[n].size = __be64_to_cpu(v->conf.blocks);
-				n++;
-				break;
-			}
+		rv[n].start = __be64_to_cpu(LBA_OFFSET(ddf, bvd)[ibvd]);
+		rv[n].size = __be64_to_cpu(bvd->blocks);
+		n++;
 	}
 	qsort(rv, n, sizeof(*rv), cmp_extent);
 
@@ -2682,11 +2685,6 @@ static int remove_from_super_ddf(struct supertype *st, mdu_disk_info_t *dk)
  */
 #define NULL_CONF_SZ	4096
 
-static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
-					     __u32 refnum, unsigned int nmax,
-					     const struct vd_config **bvd,
-					     unsigned int *idx);
-
 static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 				 char *null_aligned)
 {
-- 
1.7.1
