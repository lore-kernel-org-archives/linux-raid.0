From: mwilck@arcor.de
Subject: [PATCH 05/12] DDF: load_ddf_local: store VD conf for other BVDs
Date: Fri,  1 Mar 2013 23:28:26 +0100
Message-ID: <1362176913-6804-6-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Store VD config for other BVDs in the other_bvds array.
This allows handling secondary RAID levels in container_content_ddf.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 8ec0afb..5426d29 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -636,6 +636,36 @@ static int load_ddf_global(int fd, struct ddf_super *super, char *devname)
 	return 0;
 }
 
+static void add_other_bvd(struct vcl *vcl, struct vd_config *vd,
+			  unsigned int len)
+{
+	int i;
+	for (i = 0; i < vcl->conf.sec_elmnt_count-1; i++)
+		if (vcl->other_bvds[i] != NULL &&
+		    vcl->other_bvds[i]->sec_elmnt_seq == vd->sec_elmnt_seq)
+			break;
+
+	if (i < vcl->conf.sec_elmnt_count-1) {
+		if (vd->seqnum <= vcl->other_bvds[i]->seqnum)
+			return;
+	} else {
+		for (i = 0; i < vcl->conf.sec_elmnt_count-1; i++)
+			if (vcl->other_bvds[i] == NULL)
+				break;
+		if (i == vcl->conf.sec_elmnt_count-1) {
+			pr_err("no space for sec level config %u, count is %u\n",
+			       vd->sec_elmnt_seq, vcl->conf.sec_elmnt_count);
+			return;
+		}
+		if (posix_memalign((void **)&vcl->other_bvds[i], 512, len)
+		    != 0) {
+			pr_err("%s could not allocate vd buf\n", __func__);
+			return;
+		}
+	}
+	memcpy(vcl->other_bvds[i], vd, len);
+}
+
 static int load_ddf_local(int fd, struct ddf_super *super,
 			  char *devname, int keep)
 {
@@ -731,6 +761,11 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 
 		if (vcl) {
 			dl->vlist[vnum++] = vcl;
+			if (vcl->other_bvds != NULL &&
+			    vcl->conf.sec_elmnt_seq != vd->sec_elmnt_seq) {
+				add_other_bvd(vcl, vd, super->conf_rec_len*512);
+				continue;
+			}
 			if (__be32_to_cpu(vd->seqnum) <=
 			    __be32_to_cpu(vcl->conf.seqnum))
 				continue;
@@ -867,8 +902,13 @@ static void free_super_ddf(struct supertype *st)
 		ddf->conflist = v->next;
 		if (v->block_sizes)
 			free(v->block_sizes);
-		if (v->other_bvds)
+		if (v->other_bvds) {
+			int i;
+			for (i = 0; i < v->conf.sec_elmnt_count-1; i++)
+				if (v->other_bvds[i] != NULL)
+					free(v->other_bvds[i]);
 			free(v->other_bvds);
+		}
 		free(v);
 	}
 	while (ddf->dlist) {
-- 
1.7.3.4
