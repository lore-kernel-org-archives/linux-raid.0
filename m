From: mwilck@arcor.de
Subject: [PATCH 10/12] DDF: add sanity checks in compare_super_ddf
Date: Fri,  1 Mar 2013 23:28:31 +0100
Message-ID: <1362176913-6804-11-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Besides container GUID, also check seqnum, physical and virtual
disk numbers, and check match between local and global sections.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 4c3e6f4..56c9721 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3371,6 +3371,9 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 	 */
 	struct ddf_super *first = st->sb;
 	struct ddf_super *second = tst->sb;
+	struct dl *dl2;
+	struct vcl *vl2;
+	unsigned int max_vds, max_pds, pd, vd;
 
 	if (!first) {
 		st->sb = tst->sb;
@@ -3381,7 +3384,46 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
 	if (memcmp(first->anchor.guid, second->anchor.guid, DDF_GUID_LEN) != 0)
 		return 2;
 
+	if (first->anchor.seq != second->anchor.seq) {
+		dprintf("%s: sequence number mismatch %u/%u\n", __func__,
+			__be32_to_cpu(first->anchor.seq),
+			__be32_to_cpu(second->anchor.seq));
+		return 3;
+	}
+	if (first->max_part != second->max_part ||
+	    first->phys->used_pdes != second->phys->used_pdes ||
+	    first->virt->populated_vdes != second->virt->populated_vdes) {
+		dprintf("%s: PD/VD number mismatch\n", __func__);
+		return 3;
+	}
+
+	max_pds =  __be16_to_cpu(first->phys->used_pdes);
+	for (dl2 = second->dlist; dl2; dl2 = dl2->next) {
+		for (pd = 0; pd < max_pds; pd++)
+			if (first->phys->entries[pd].refnum == dl2->disk.refnum)
+				break;
+		if (pd == max_pds) {
+			dprintf("%s: no match for disk %08x\n", __func__,
+				__be32_to_cpu(dl2->disk.refnum));
+			return 3;
+		}
+	}
+
+	max_vds = __be16_to_cpu(first->active->max_vd_entries);
+	for (vl2 = second->conflist; vl2; vl2 = vl2->next) {
+		if (vl2->conf.magic != DDF_VD_CONF_MAGIC)
+			continue;
+		for (vd = 0; vd < max_vds; vd++)
+			if (!memcmp(first->virt->entries[vd].guid,
+				    vl2->conf.guid, DDF_GUID_LEN))
+				break;
+		if (vd == max_vds) {
+			dprintf("%s: no match for VD config\n", __func__);
+			return 3;
+		}
+	}
 	/* FIXME should I look at anything else? */
+
 	return 0;
 }
 
-- 
1.7.3.4
