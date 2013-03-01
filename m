From: mwilck@arcor.de
Subject: [PATCH 04/12] DDF: added other_bvd to struct vcl
Date: Fri,  1 Mar 2013 23:28:25 +0100
Message-ID: <1362176913-6804-5-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The VD config structures of different BVDs in the same SVD may be
different. This pointer stores the other BVDs.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index e165927..8ec0afb 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -407,6 +407,7 @@ struct ddf_super {
 				__u64		*lba_offset; /* location in 'conf' of
 							      * the lba table */
 				unsigned int	vcnum; /* index into ->virt */
+				struct vd_config **other_bvds;
 				__u64		*block_sizes; /* NULL if all the same */
 			};
 		};
@@ -743,6 +744,12 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 			}
 			vcl->next = super->conflist;
 			vcl->block_sizes = NULL; /* FIXME not for CONCAT */
+			if (vd->sec_elmnt_count > 1)
+				vcl->other_bvds =
+					xcalloc(vd->sec_elmnt_count - 1,
+						sizeof(struct vd_config *));
+			else
+				vcl->other_bvds = NULL;
 			super->conflist = vcl;
 			dl->vlist[vnum++] = vcl;
 		}
@@ -860,6 +867,8 @@ static void free_super_ddf(struct supertype *st)
 		ddf->conflist = v->next;
 		if (v->block_sizes)
 			free(v->block_sizes);
+		if (v->other_bvds)
+			free(v->other_bvds);
 		free(v);
 	}
 	while (ddf->dlist) {
@@ -2028,6 +2037,7 @@ static int init_super_ddf_bvd(struct supertype *st,
 	vcl->lba_offset = (__u64*) &vcl->conf.phys_refnum[ddf->mppe];
 	vcl->vcnum = venum;
 	vcl->block_sizes = NULL; /* FIXME not for CONCAT */
+	vcl->other_bvds = NULL;
 
 	vc = &vcl->conf;
 
-- 
1.7.3.4
