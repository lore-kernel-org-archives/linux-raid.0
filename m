From: mwilck@arcor.de
Subject: [PATCH 39/39] DDF: ddf_process_update: Fix updates for SVDs
Date: Mon,  8 Jul 2013 23:50:48 +0200
Message-ID: <1373320248-7520-13-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The "indirect" code path for adding VDs was not working correctly
for secondary RAID level. The "other BVDs" were not transmitted
to mdmon. Thus mdmon wouldn't build up correct information, and
RAID creation would fail when mdmon was already running on the container.

This patch fixes this.
---
 super-ddf.c |   86 +++++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index b80bb3b..b74cc51 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2940,7 +2940,8 @@ static int write_init_super_ddf(struct supertype *st)
 		/* queue the virtual_disk and vd_config as metadata updates */
 		struct virtual_disk *vd;
 		struct vd_config *vc;
-		int len;
+		int len, tlen;
+		unsigned int i;
 
 		if (!currentconf) {
 			int len = (sizeof(struct phys_disk) +
@@ -2967,9 +2968,13 @@ static int write_init_super_ddf(struct supertype *st)
 
 		/* Then the vd_config */
 		len = ddf->conf_rec_len * 512;
-		vc = xmalloc(len);
+		tlen = len * currentconf->conf.sec_elmnt_count;
+		vc = xmalloc(tlen);
 		memcpy(vc, &currentconf->conf, len);
-		append_metadata_update(st, vc, len);
+		for (i = 1; i < currentconf->conf.sec_elmnt_count; i++)
+			memcpy((char *)vc + i*len, currentconf->other_bvds[i-1],
+			       len);
+		append_metadata_update(st, vc, tlen);
 
 		/* FIXME I need to close the fds! */
 		return 0;
@@ -4254,6 +4259,27 @@ static int kill_subarray_ddf(struct supertype *st)
 	return 0;
 }
 
+static void copy_matching_bvd(struct ddf_super *ddf,
+			      struct vd_config *conf,
+			      const struct metadata_update *update)
+{
+	unsigned int mppe =
+		__be16_to_cpu(ddf->anchor.max_primary_element_entries);
+	unsigned int len = ddf->conf_rec_len * 512;
+	char *p;
+	struct vd_config *vc;
+	for (p = update->buf; p < update->buf + update->len; p += len) {
+		vc = (struct vd_config *) p;
+		if (vc->sec_elmnt_seq == conf->sec_elmnt_seq) {
+			memcpy(conf->phys_refnum, vc->phys_refnum,
+			       mppe * (sizeof(__u32) + sizeof(__u64)));
+			return;
+		}
+	}
+	pr_err("%s: no match for BVD %d of %s in update\n", __func__,
+	       conf->sec_elmnt_seq, guid_str(conf->guid));
+}
+
 static void ddf_process_update(struct supertype *st,
 			       struct metadata_update *update)
 {
@@ -4293,7 +4319,7 @@ static void ddf_process_update(struct supertype *st,
 	struct dl *dl;
 	unsigned int mppe;
 	unsigned int ent;
-	unsigned int pdnum, pd2;
+	unsigned int pdnum, pd2, len;
 
 	dprintf("Process update %x\n", *magic);
 
@@ -4386,9 +4412,14 @@ static void ddf_process_update(struct supertype *st,
 
 	case DDF_VD_CONF_MAGIC:
 		mppe = __be16_to_cpu(ddf->anchor.max_primary_element_entries);
-		if ((unsigned)update->len != ddf->conf_rec_len * 512)
-			return;
 		vc = (struct vd_config*)update->buf;
+		len = ddf->conf_rec_len * 512;
+		if ((unsigned int)update->len != len * vc->sec_elmnt_count) {
+			pr_err("%s: %s: insufficient data (%d) for %u BVDs\n",
+			       __func__, guid_str(vc->guid), update->len,
+			       vc->sec_elmnt_count);
+			return;
+		}
 		for (vcl = ddf->conflist; vcl ; vcl = vcl->next)
 			if (memcmp(vcl->conf.guid, vc->guid, DDF_GUID_LEN) == 0)
 				break;
@@ -4398,36 +4429,28 @@ static void ddf_process_update(struct supertype *st,
 			/* An update, just copy the phys_refnum and lba_offset
 			 * fields
 			 */
-			struct vd_config *conf = &vcl->conf;
-			if (vcl->other_bvds != NULL &&
-			    conf->sec_elmnt_seq != vc->sec_elmnt_seq) {
-				unsigned int i;
-				for (i = 1; i < conf->sec_elmnt_count; i++)
-					if (vcl->other_bvds[i-1]->sec_elmnt_seq
-					    == vc->sec_elmnt_seq)
-						break;
-				if (i == conf->sec_elmnt_count) {
-					pr_err("%s/DDF_VD_CONF_MAGIC: BVD %u not found\n",
-					       __func__, vc->sec_elmnt_seq);
-					return;
-				}
-				conf = vcl->other_bvds[i-1];
-			}
-			memcpy(conf->phys_refnum, vc->phys_refnum,
-			       mppe * (sizeof(__u32) + sizeof(__u64)));
+			unsigned int i;
+			copy_matching_bvd(ddf, &vcl->conf, update);
+			for (i = 1; i < vc->sec_elmnt_count; i++)
+				copy_matching_bvd(ddf, vcl->other_bvds[i-1],
+						  update);
 		} else {
 			/* A new VD_CONF */
+			unsigned int i;
 			if (!update->space)
 				return;
 			vcl = update->space;
 			update->space = NULL;
 			vcl->next = ddf->conflist;
-			memcpy(&vcl->conf, vc, update->len);
+			memcpy(&vcl->conf, vc, len);
 			ent = find_vde_by_guid(ddf, vc->guid);
 			if (ent == DDF_NOTFOUND)
 				return;
 			vcl->vcnum = ent;
 			ddf->conflist = vcl;
+			for (i = 1; i < vc->sec_elmnt_count; i++)
+				memcpy(vcl->other_bvds[i-1],
+				       update->buf + len * i, len);
 		}
 		/* Set DDF_Transition on all Failed devices - to help
 		 * us detect those that are no longer in use
@@ -4539,11 +4562,22 @@ static void ddf_prepare_update(struct supertype *st,
 	 */
 	struct ddf_super *ddf = st->sb;
 	__u32 *magic = (__u32*)update->buf;
-	if (*magic == DDF_VD_CONF_MAGIC)
+	if (*magic == DDF_VD_CONF_MAGIC) {
+		struct vcl *vcl;
+		struct vd_config *conf = (struct vd_config *) update->buf;
 		if (posix_memalign(&update->space, 512,
 				   offsetof(struct vcl, conf)
-				   + ddf->conf_rec_len * 512) != 0)
+				   + ddf->conf_rec_len * 512) != 0) {
+			update->space = NULL;
+			return;
+		}
+		vcl = update->space;
+		vcl->conf.sec_elmnt_count = conf->sec_elmnt_count;
+		if (alloc_other_bvds(ddf, vcl) != 0) {
+			free(update->space);
 			update->space = NULL;
+		}
+	}
 }
 
 /*
-- 
1.7.1
