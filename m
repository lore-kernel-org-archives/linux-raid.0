From: mwilck@arcor.de
Subject: [PATCH 14/27] DDF: init_super_ddf_bvd: initialize other bvds
Date: Wed,  3 Jul 2013 22:27:54 +0200
Message-ID: <1372883287-8859-15-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Properly initialize the data structures of the other BVDs
in Create().

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 1ff8a28..f42bb16 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2328,7 +2328,7 @@ static int init_super_ddf_bvd(struct supertype *st,
 	 * We need to create a new vd_config and a new virtual_entry
 	 */
 	struct ddf_super *ddf = st->sb;
-	unsigned int venum;
+	unsigned int venum, i;
 	struct virtual_entry *ve;
 	struct vcl *vcl;
 	struct vd_config *vc;
@@ -2423,6 +2423,11 @@ static int init_super_ddf_bvd(struct supertype *st,
 	memset(vc->phys_refnum, 0xff, 4*ddf->mppe);
 	memset(vc->phys_refnum+ddf->mppe, 0x00, 8*ddf->mppe);
 
+	for (i = 1; i < vc->sec_elmnt_count; i++) {
+		memcpy(vcl->other_bvds[i-1], vc, ddf->conf_rec_len * 512);
+		vcl->other_bvds[i-1]->sec_elmnt_seq = i;
+	}
+
 	vcl->next = ddf->conflist;
 	ddf->conflist = vcl;
 	ddf->currentconf = vcl;
-- 
1.7.1
