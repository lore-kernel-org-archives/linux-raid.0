From: mwilck@arcor.de
Subject: [PATCH 19/27] DDF: add_to_super_ddf: Use same amount of workspace as other disks
Date: Wed,  3 Jul 2013 22:27:59 +0200
Message-ID: <1372883287-8859-20-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

If there are already disks in the container, reserve the same amount
of workspace as the first disk. Fill in the primary/secondary/
workspace LBA values.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 093f2dc..040a965 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2583,6 +2583,13 @@ static int add_to_super_ddf(struct supertype *st,
 		return 1;
 	}
 	pde = &ddf->phys->entries[n];
+	get_dev_size(fd, NULL, &size);
+	if (size <= 32*1024*1024) {
+		pr_err("%s: device size must be at least 32MB\n",
+		       __func__);
+		return 1;
+	}
+	size >>= 9;
 
 	if (posix_memalign((void**)&dd, 512,
 		           sizeof(*dd) + sizeof(dd->vlist[0]) * ddf->max_part) != 0) {
@@ -2642,13 +2649,31 @@ static int add_to_super_ddf(struct supertype *st,
 	pde->refnum = dd->disk.refnum;
 	pde->type = __cpu_to_be16(DDF_Forced_PD_GUID | DDF_Global_Spare);
 	pde->state = __cpu_to_be16(DDF_Online);
-	get_dev_size(fd, NULL, &size);
-	/* We are required to reserve 32Meg, and record the size in sectors */
-	pde->config_size = __cpu_to_be64( (size - 32*1024*1024) / 512);
+	dd->size = size;
+	/*
+	 * If there is already a device in dlist, try to reserve the same
+	 * amount of workspace. Otherwise, use 32MB.
+	 * We checked disk size above already.
+	 */
+#define __calc_lba(new, old, lba, mb) do { \
+		unsigned long long dif; \
+		if ((old) != NULL) \
+			dif = (old)->size - __be64_to_cpu((old)->lba); \
+		else \
+			dif = (new)->size; \
+		if ((new)->size > dif) \
+			(new)->lba = __cpu_to_be64((new)->size - dif); \
+		else \
+			(new)->lba = __cpu_to_be64((new)->size - (mb*1024*2)); \
+	} while (0)
+	__calc_lba(dd, ddf->dlist, workspace_lba, 32);
+	__calc_lba(dd, ddf->dlist, primary_lba, 16);
+	__calc_lba(dd, ddf->dlist, secondary_lba, 32);
+	pde->config_size = dd->workspace_lba;
+
 	sprintf(pde->path, "%17.17s","Information: nil") ;
 	memset(pde->pad, 0xff, 6);
 
-	dd->size = size >> 9;
 	if (st->update_tail) {
 		dd->next = ddf->add_list;
 		ddf->add_list = dd;
-- 
1.7.1
