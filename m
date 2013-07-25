From: mwilck@arcor.de
Subject: [PATCH 4/4] DDF: ddf_activate_spare: fix metadata update for SVDs
Date: Thu, 25 Jul 2013 20:59:13 +0200
Message-ID: <1374778753-6252-5-git-send-email-mwilck@arcor.de>
References: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Metadata updates for secondary RAID (RAID10) need to cover
all BVDs. Compare with code in write_init_super_ddf().
---
 super-ddf.c |   41 ++++++++++++++++++++++++++++++++---------
 1 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index ae1222c..47074fe 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4730,6 +4730,7 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	struct metadata_update *mu;
 	struct dl *dl;
 	int i;
+	unsigned int j;
 	struct vcl *vcl;
 	struct vd_config *vc;
 	unsigned int n_bvd;
@@ -4902,26 +4903,48 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
 	 * Create a metadata_update record to update the
 	 * phys_refnum and lba_offset values
 	 */
+	vc = find_vdcr(ddf, a->info.container_member, di->disk.raid_disk,
+		       &n_bvd, &vcl);
+	if (vc == NULL)
+		return NULL;
+
 	mu = xmalloc(sizeof(*mu));
 	if (posix_memalign(&mu->space, 512, sizeof(struct vcl)) != 0) {
 		free(mu);
 		mu = NULL;
 	}
-	mu->buf = xmalloc(ddf->conf_rec_len * 512);
-	mu->len = ddf->conf_rec_len * 512;
+
+	mu->len = ddf->conf_rec_len * 512 * vcl->conf.sec_elmnt_count;
+	mu->buf = xmalloc(mu->len);
 	mu->space = NULL;
 	mu->space_list = NULL;
 	mu->next = *updates;
-	vc = find_vdcr(ddf, a->info.container_member, di->disk.raid_disk,
-		       &n_bvd, &vcl);
-	memcpy(mu->buf, vc, ddf->conf_rec_len * 512);
+	memcpy(mu->buf, &vcl->conf, ddf->conf_rec_len * 512);
+	for (j = 1; j < vcl->conf.sec_elmnt_count; j++)
+		memcpy(mu->buf + j * ddf->conf_rec_len * 512,
+		       vcl->other_bvds[j-1], ddf->conf_rec_len * 512);
 
 	vc = (struct vd_config*)mu->buf;
 	for (di = rv ; di ; di = di->next) {
-		vc->phys_refnum[di->disk.raid_disk] =
-			ddf->phys->entries[dl->pdnum].refnum;
-		LBA_OFFSET(ddf, vc)[di->disk.raid_disk]
-			= cpu_to_be64(di->data_offset);
+		unsigned int i_sec, i_prim;
+		i_sec = di->disk.raid_disk
+			/ be16_to_cpu(vcl->conf.prim_elmnt_count);
+		i_prim = di->disk.raid_disk
+			% be16_to_cpu(vcl->conf.prim_elmnt_count);
+		vc = (struct vd_config *)(mu->buf
+					  + i_sec * ddf->conf_rec_len * 512);
+		for (dl = ddf->dlist; dl; dl = dl->next)
+			if (dl->major == di->disk.major
+			    && dl->minor == di->disk.minor)
+				break;
+		if (!dl) {
+			pr_err("%s: BUG: can't find disk %d (%d/%d)\n",
+			       __func__, di->disk.raid_disk,
+			       di->disk.major, di->disk.minor);
+			return NULL;
+		}
+		vc->phys_refnum[i_prim] = ddf->phys->entries[dl->pdnum].refnum;
+		LBA_OFFSET(ddf, vc)[i_prim] = cpu_to_be64(di->data_offset);
 	}
 	*updates = mu;
 	return rv;
-- 
1.7.1
