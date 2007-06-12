From: vignesh babu <vignesh.babu@wipro.com>
Subject: [PATCH]is_power_of_2-dm
Date: Tue, 12 Jun 2007 10:30:52 +0530
Message-ID: <1181624452.3109.20.camel@merlin.linuxcoe.com>
Reply-To: vignesh.babu@wipro.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel Janitors List <kernel-janitors@lists.osdl.org>
List-Id: linux-raid.ids


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ef124b7..3e1817a 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+#include <linux/log2.h>
 
 #define DM_MSG_PREFIX "raid1"
 #define DM_IO_PAGES 64
@@ -962,7 +963,7 @@ static void free_context(struct mirror_set *ms, struct dm_target *ti,
 
 static inline int _check_region_size(struct dm_target *ti, uint32_t size)
 {
-	return !(size % (PAGE_SIZE >> 9) || (size & (size - 1)) ||
+	return !(size % (PAGE_SIZE >> 9) || !is_power_of_2(size) ||
 		 size > ti->len);
 }
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 0821a2b..f2d4b23 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/log2.h>
 
 #include "dm-snap.h"
 #include "dm-bio-list.h"
@@ -414,7 +415,7 @@ static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
 	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
 
 	/* Check chunk_size is a power of 2 */
-	if (chunk_size & (chunk_size - 1)) {
+	if (!is_power_of_2(chunk_size)) {
 		*error = "Chunk size is not a power of 2";
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 51f5e07..969944a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -11,6 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 
 #define DM_MSG_PREFIX "striped"
 
@@ -99,7 +100,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/*
 	 * chunk_size is a power of two
 	 */
-	if (!chunk_size || (chunk_size & (chunk_size - 1)) ||
+	if (!is_power_of_2(chunk_size) ||
 	    (chunk_size < (PAGE_SIZE >> SECTOR_SHIFT))) {
 		ti->error = "Invalid chunk size";
 		return -EINVAL;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

