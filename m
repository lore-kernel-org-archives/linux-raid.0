From: mwilck@arcor.de
Subject: [PATCH 11/12] DDF: compare_super_ddf: merge local info of other superblock
Date: Fri,  1 Mar 2013 23:28:32 +0100
Message-ID: <1362176913-6804-12-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

If a match is found in compare_super_ddf, check the other SB
for local DDF information (VD config records, physical disk data)
which is not available in the current superblock, and add it
if needed.

This is important for the mdmon - when disks are added to a
auto read-only array, they must be present in the DDF structure
in order to guarantee consistent writeback of metadata to all
disks.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 56c9721..dbea77f 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3371,8 +3371,8 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 	 */
 	struct ddf_super *first = st->sb;
 	struct ddf_super *second = tst->sb;
-	struct dl *dl2;
-	struct vcl *vl2;
+	struct dl *dl1, *dl2;
+	struct vcl *vl1, *vl2;
 	unsigned int max_vds, max_pds, pd, vd;
 
 	if (!first) {
@@ -3424,6 +3424,104 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 	}
 	/* FIXME should I look at anything else? */
 
+	/*
+	   At this point we are fairly sure that the meta data matches.
+	   But the new disk may contain additional local data.
+	   Add it to the super block.
+	 */
+	for (vl2 = second->conflist; vl2; vl2 = vl2->next) {
+		for (vl1 = first->conflist; vl1; vl1 = vl1->next)
+			if (!memcmp(vl1->conf.guid, vl2->conf.guid,
+				    DDF_GUID_LEN))
+				break;
+		if (vl1) {
+			if (vl1->other_bvds != NULL &&
+			    vl1->conf.sec_elmnt_seq !=
+			    vl2->conf.sec_elmnt_seq) {
+				dprintf("%s: adding BVD %u\n", __func__,
+					vl2->conf.sec_elmnt_seq);
+				add_other_bvd(vl1, &vl2->conf,
+					      first->conf_rec_len*512);
+			}
+			continue;
+		}
+
+		if (posix_memalign((void **)&vl1, 512,
+				   (first->conf_rec_len*512 +
+				    offsetof(struct vcl, conf))) != 0) {
+			pr_err("%s could not allocate vcl buf\n",
+			       __func__);
+			return 3;
+		}
+
+		vl1->next = first->conflist;
+		vl1->block_sizes = NULL;
+		if (vl1->conf.sec_elmnt_count > 1) {
+			vl1->other_bvds = xcalloc(vl2->conf.sec_elmnt_count - 1,
+						  sizeof(struct vd_config *));
+		} else
+			vl1->other_bvds = NULL;
+		memcpy(&vl1->conf, &vl2->conf, first->conf_rec_len*512);
+		vl1->lba_offset = (__u64 *)
+			&vl1->conf.phys_refnum[first->mppe];
+		for (vd = 0; vd < max_vds; vd++)
+			if (!memcmp(first->virt->entries[vd].guid,
+				    vl1->conf.guid, DDF_GUID_LEN))
+				break;
+		vl1->vcnum = vd;
+		dprintf("%s: added config for VD %u\n", __func__, vl1->vcnum);
+		first->conflist = vl1;
+	}
+
+	for (dl2 = second->dlist; dl2; dl2 = dl2->next) {
+		for (dl1 = first->dlist; dl1; dl1 = dl1->next)
+			if (dl1->disk.refnum == dl2->disk.refnum)
+				break;
+		if (dl1)
+			continue;
+
+		if (posix_memalign((void **)&dl1, 512,
+		       sizeof(*dl1) + (first->max_part) * sizeof(dl1->vlist[0]))
+		    != 0) {
+			pr_err("%s could not allocate disk info buffer\n",
+			__func__);
+			return 3;
+		}
+		memcpy(dl1, dl2, sizeof(*dl1));
+		dl1->mdupdate = NULL;
+		dl1->next = first->dlist;
+		dl1->fd = -1;
+		for (pd = 0; pd < max_pds; pd++)
+			if (first->phys->entries[pd].refnum == dl1->disk.refnum)
+				break;
+		dl1->pdnum = pd;
+		if (dl2->spare) {
+			if (posix_memalign((void **)&dl1->spare, 512,
+				       first->conf_rec_len*512) != 0) {
+				pr_err("%s could not allocate spare info buf\n",
+				       __func__);
+				return 3;
+			}
+			memcpy(dl1->spare, dl2->spare, first->conf_rec_len*512);
+		}
+		for (vd = 0 ; vd < first->max_part ; vd++) {
+			if (!dl2->vlist[vd]) {
+				dl1->vlist[vd] = NULL;
+				continue;
+			}
+			for (vl1 = first->conflist; vl1; vl1 = vl1->next) {
+				if (!memcmp(vl1->conf.guid,
+					    dl2->vlist[vd]->conf.guid,
+					    DDF_GUID_LEN))
+					break;
+				dl1->vlist[vd] = vl1;
+			}
+		}
+		first->dlist = dl1;
+		dprintf("%s: added disk %d: %08x\n", __func__, dl1->pdnum,
+			dl1->disk.refnum);
+	}
+
 	return 0;
 }
 
-- 
1.7.3.4
