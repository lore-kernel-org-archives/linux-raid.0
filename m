From: mwilck@arcor.de
Subject: [PATCH 18/27] DDF: add_to_super_ddf: allow empty slots in phys disk table
Date: Wed,  3 Jul 2013 22:27:58 +0200
Message-ID: <1372883287-8859-19-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The used slots in the phys disk table aren't necessarily the
first ones. Rather, unused entries are represented by entries
where the GUID is all 0xff.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index e7aa0ad..093f2dc 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2242,6 +2242,8 @@ static int init_super_ddf(struct supertype *st,
 	pd->used_pdes = __cpu_to_be16(0);
 	pd->max_pdes = __cpu_to_be16(max_phys_disks);
 	memset(pd->pad, 0xff, 52);
+	for (i = 0; i < max_phys_disks; i++)
+		memset(pd->entries[i].guid, 0xff, DDF_GUID_LEN);
 
 	if (posix_memalign((void**)&vd, 512, vdsize) != 0) {
 		pr_err("%s could not allocate vd\n", __func__);
@@ -2538,6 +2540,16 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 	ddf_set_updates_pending(ddf);
 }
 
+static unsigned int find_unused_pde(const struct ddf_super *ddf)
+{
+	unsigned int i;
+	for (i = 0; i < __be16_to_cpu(ddf->phys->max_pdes); i++) {
+		if (all_ff(ddf->phys->entries[i].guid))
+			return i;
+	}
+	return DDF_NOTFOUND;
+}
+
 /* add a device to a container, either while creating it or while
  * expanding a pre-existing container
  */
@@ -2564,6 +2576,14 @@ static int add_to_super_ddf(struct supertype *st,
 	 * a phys_disk entry and a more detailed disk_data entry.
 	 */
 	fstat(fd, &stb);
+	n = find_unused_pde(ddf);
+	if (n == DDF_NOTFOUND) {
+		pr_err("%s: No free slot in array, cannot add disk\n",
+		       __func__);
+		return 1;
+	}
+	pde = &ddf->phys->entries[n];
+
 	if (posix_memalign((void**)&dd, 512,
 		           sizeof(*dd) + sizeof(dd->vlist[0]) * ddf->max_part) != 0) {
 		pr_err("%s could allocate buffer for new disk, aborting\n",
@@ -2602,8 +2622,6 @@ static int add_to_super_ddf(struct supertype *st,
 	for (i = 0; i < ddf->max_part ; i++)
 		dd->vlist[i] = NULL;
 
-	n = __be16_to_cpu(ddf->phys->used_pdes);
-	pde = &ddf->phys->entries[n];
 	dd->pdnum = n;
 
 	if (st->update_tail) {
@@ -2616,10 +2634,9 @@ static int add_to_super_ddf(struct supertype *st,
 		pd->used_pdes = __cpu_to_be16(n);
 		pde = &pd->entries[0];
 		dd->mdupdate = pd;
-	} else {
-		n++;
-		ddf->phys->used_pdes = __cpu_to_be16(n);
-	}
+	} else
+		ddf->phys->used_pdes = __cpu_to_be16(
+			1 + __be16_to_cpu(ddf->phys->used_pdes));
 
 	memcpy(pde->guid, dd->disk.guid, DDF_GUID_LEN);
 	pde->refnum = dd->disk.refnum;
-- 
1.7.1
