From: mwilck@arcor.de
Subject: [PATCH 3/4] DDF: ddf_process_update: delete removed disks from dlist
Date: Fri,  2 Aug 2013 00:35:16 +0200
Message-ID: <1375396517-8479-3-git-send-email-mwilck@arcor.de>
References: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

We currently remove Failed disks that aren't used by any VD.
If we do that, we need to remove the disks from the dlist as well.
Otherwise, the same pdnum may occur multiple times in the dlist.

This fixes the problem reported by Albert Pauw.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 7a7f5fe..e1d0509 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4366,6 +4366,19 @@ static void copy_matching_bvd(struct ddf_super *ddf,
 	       conf->sec_elmnt_seq, guid_str(conf->guid));
 }
 
+static void _delete_dl_by_refnum(struct ddf_super *ddf, be32 refnum)
+{
+	struct dl **pdl = &ddf->dlist, *d;
+	while (*pdl) {
+		if (be32_eq((*pdl)->disk.refnum, refnum)) {
+			d = *pdl;
+			*pdl = d->next;
+			free(d);
+		} else
+			pdl = &(*pdl)->next;
+	}
+}
+
 static void ddf_process_update(struct supertype *st,
 			       struct metadata_update *update)
 {
@@ -4638,9 +4651,15 @@ static void ddf_process_update(struct supertype *st,
 			if (be16_and(ddf->phys->entries[pdnum].state,
 				     cpu_to_be16(DDF_Failed))
 			    && be16_and(ddf->phys->entries[pdnum].state,
-					cpu_to_be16(DDF_Transition)))
-				/* skip this one */;
-			else if (pdnum == pd2)
+					cpu_to_be16(DDF_Transition))) {
+				/* skip this one and remove from dlist */
+				dprintf("%s: %08x no longer used, removing it\n",
+					__func__,
+					be32_to_cpu(ddf->phys->
+						    entries[pdnum].refnum));
+				_delete_dl_by_refnum(
+					ddf, ddf->phys->entries[pdnum].refnum);
+			} else if (pdnum == pd2)
 				pd2++;
 			else {
 				ddf->phys->entries[pd2] =
-- 
1.7.1
