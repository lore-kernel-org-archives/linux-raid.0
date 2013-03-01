From: mwilck@arcor.de
Subject: [PATCH 09/12] DDF: __write_init_super_ddf: use correct VD conf
Date: Fri,  1 Mar 2013 23:28:30 +0100
Message-ID: <1362176913-6804-10-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

When writing back the DDF structure, make sure that on each disk
we write the configs that include this disk even if a secondary
RAID level is present. Otherwise the secondary RAID will not be
read correctly any more when we open the device next time.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 01aa7d5..4c3e6f4 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2377,6 +2377,11 @@ static int remove_from_super_ddf(struct supertype *st, mdu_disk_info_t *dk)
  */
 #define NULL_CONF_SZ	4096
 
+static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
+					     __u32 refnum, unsigned int nmax,
+					     const struct vd_config **bvd,
+					     unsigned int *idx);
+
 static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 				 char *null_aligned)
 {
@@ -2422,14 +2427,26 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 	n_config = ddf->max_part;
 	conf_size = ddf->conf_rec_len * 512;
 	for (i = 0 ; i <= n_config ; i++) {
-		struct vcl *c = d->vlist[i];
-		if (i == n_config)
+		struct vcl *c;
+		struct vd_config *vdc = NULL;
+		if (i == n_config) {
 			c = (struct vcl *)d->spare;
-
+			if (c)
+				vdc = &c->conf;
+		} else {
+			unsigned int dummy;
+			c = d->vlist[i];
+			if (c)
+				get_pd_index_from_refnum(
+					c, d->disk.refnum,
+					ddf->mppe,
+					(const struct vd_config **)&vdc,
+					&dummy);
+		}
 		if (c) {
-			c->conf.seqnum = ddf->primary.seq;
-			c->conf.crc = calc_crc(&c->conf, conf_size);
-			if (write(fd, &c->conf, conf_size) < 0)
+			vdc->seqnum = ddf->primary.seq;
+			vdc->crc = calc_crc(vdc, conf_size);
+			if (write(fd, vdc, conf_size) < 0)
 				break;
 		} else {
 			unsigned int togo = conf_size;
@@ -3085,7 +3102,7 @@ static int check_secondary(const struct vcl *vc)
 	for (i = 0; i < conf->sec_elmnt_count-1; i++) {
 		const struct vd_config *bvd = vc->other_bvds[i];
 		if (bvd == NULL) {
-			pr_err("BVD %d is missing", i+1);
+			pr_err("BVD %d is missing\n", i+1);
 			return -1;
 		}
 		if (bvd->srl != conf->srl) {
-- 
1.7.3.4
