From: mwilck@arcor.de
Subject: [PATCH 26/27] DDF: ddf_process_update: Fix vlist treatment for SVDs
Date: Wed,  3 Jul 2013 22:28:06 +0200
Message-ID: <1372883287-8859-27-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

With secondary RAID level, disks may belong to other BVDs in
a given conf record. This needs to be taken into account
when fixing the vlist.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   48 ++++++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 77c00b2..ebb5e0b 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4323,30 +4323,34 @@ static void ddf_process_update(struct supertype *st,
 					|= __be16_to_cpu(DDF_Transition);
 		/* Now make sure vlist is correct for each dl. */
 		for (dl = ddf->dlist; dl; dl = dl->next) {
-			unsigned int dn;
 			unsigned int vn = 0;
 			int in_degraded = 0;
-			for (vcl = ddf->conflist; vcl ; vcl = vcl->next)
-				for (dn=0; dn < ddf->mppe ; dn++)
-					if (vcl->conf.phys_refnum[dn] ==
-					    dl->disk.refnum) {
-						int vstate;
-						dprintf("dev %d has %p at %d\n",
-							dl->pdnum, vcl, vn);
-						/* Clear the Transition flag */
-						if (ddf->phys->entries[dl->pdnum].state
-						    & __be16_to_cpu(DDF_Failed))
-							ddf->phys->entries[dl->pdnum].state &=
-								~__be16_to_cpu(DDF_Transition);
-
-						dl->vlist[vn++] = vcl;
-						vstate = ddf->virt->entries[vcl->vcnum].state
-							& DDF_state_mask;
-						if (vstate == DDF_state_degraded ||
-						    vstate == DDF_state_part_optimal)
-							in_degraded = 1;
-						break;
-					}
+			for (vcl = ddf->conflist; vcl ; vcl = vcl->next) {
+				unsigned int dn, ibvd;
+				const struct vd_config *conf;
+				int vstate;
+				dn = get_pd_index_from_refnum(vcl,
+							      dl->disk.refnum,
+							      ddf->mppe,
+							      &conf, &ibvd);
+				if (dn == DDF_NOTFOUND)
+					continue;
+				dprintf("dev %d/%08x has %s (sec=%u) at %d\n",
+					dl->pdnum, dl->disk.refnum,
+					guid_str(conf->guid),
+					conf->sec_elmnt_seq, vn);
+				/* Clear the Transition flag */
+				if (ddf->phys->entries[dl->pdnum].state
+				    & __be16_to_cpu(DDF_Failed))
+					ddf->phys->entries[dl->pdnum].state &=
+						~__be16_to_cpu(DDF_Transition);
+				dl->vlist[vn++] = vcl;
+				vstate = ddf->virt->entries[vcl->vcnum].state
+					& DDF_state_mask;
+				if (vstate == DDF_state_degraded ||
+					vstate == DDF_state_part_optimal)
+					in_degraded = 1;
+			}
 			while (vn < ddf->max_part)
 				dl->vlist[vn++] = NULL;
 			if (dl->vlist[0]) {
-- 
1.7.1
