From: mwilck@arcor.de
Subject: [PATCH 25/27] DDF: ddf_process_update: handle update of conf records for SVD
Date: Wed,  3 Jul 2013 22:28:05 +0200
Message-ID: <1372883287-8859-26-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

For secondary RAID, we need to check which BVD needs to be updated.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 8e1d502..77c00b2 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4282,7 +4282,22 @@ static void ddf_process_update(struct supertype *st,
 			/* An update, just copy the phys_refnum and lba_offset
 			 * fields
 			 */
-			memcpy(vcl->conf.phys_refnum, vc->phys_refnum,
+			struct vd_config *conf = &vcl->conf;
+			if (vcl->other_bvds != NULL &&
+			    conf->sec_elmnt_seq != vc->sec_elmnt_seq) {
+				unsigned int i;
+				for (i = 1; i < conf->sec_elmnt_count; i++)
+					if (vcl->other_bvds[i-1]->sec_elmnt_seq
+					    == vc->sec_elmnt_seq)
+						break;
+				if (i == conf->sec_elmnt_count) {
+					pr_err("%s/DDF_VD_CONF_MAGIC: BVD %u not found\n",
+					       __func__, vc->sec_elmnt_seq);
+					return;
+				}
+				conf = vcl->other_bvds[i-1];
+			}
+			memcpy(conf->phys_refnum, vc->phys_refnum,
 			       mppe * (sizeof(__u32) + sizeof(__u64)));
 		} else {
 			/* A new VD_CONF */
-- 
1.7.1
