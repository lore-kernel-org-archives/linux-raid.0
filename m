From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Bugreport ddf rebuild problems
Date: Thu, 01 Aug 2013 23:13:32 +0200
Message-ID: <51FACF7C.50400@arcor.de>
References: <51FAB74B.4030200@gmail.com>	<51FAB282.6040303@arcor.de> <CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010704030904050304070200"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCFT0+qm9YAnAJM7JGgVg0RTJi8=HAYDTMs-mfhXinqdcg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010704030904050304070200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Can you please try the attached patch?

Regards,
Martin



--------------010704030904050304070200
Content-Type: text/x-patch;
 name="0001-DDF-ddf_process_update-delete-removed-disks-from-dli.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-DDF-ddf_process_update-delete-removed-disks-from-dli.pa";
 filename*1="tch"

From e6b25d31ee79c1191f936e178324c97d2ce68a57 Mon Sep 17 00:00:00 2001
From: Martin Wilck <mwilck@arcor.de>
Date: Fri, 2 Aug 2013 00:11:20 +0200
Subject: [PATCH] DDF: ddf_process_update: delete removed disks from dlist

We currently remove Failed disks that are no longer used by any
VD. If we do that, we must remove them from dlist, too, because
otherwise the same pdnum may occur multiple times in the dlist.
---
 super-ddf.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 65472a2..f8d5fcd 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4366,6 +4366,18 @@ static void copy_matching_bvd(struct ddf_super *ddf,
 	       conf->sec_elmnt_seq, guid_str(conf->guid));
 }
 
+static void _delete_dl_by_refnum(struct ddf_super *ddf, be32 refnum)
+{
+	struct dl **pdl = &ddf->dlist;
+	while (*pdl) {
+		if (be32_eq((*pdl)->disk.refnum, refnum)) {
+			free(*pdl);
+			*pdl = (*pdl)->next;
+		} else
+			pdl = &(*pdl)->next;
+	}
+}
+
 static void ddf_process_update(struct supertype *st,
 			       struct metadata_update *update)
 {
@@ -4638,9 +4650,15 @@ static void ddf_process_update(struct supertype *st,
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


--------------010704030904050304070200--
