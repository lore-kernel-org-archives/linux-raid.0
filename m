From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 2] Fix problem with unsigned variable going "negative" in linear.c
Date: Tue, 16 Nov 2004 15:45:49 +1100
Message-ID: <E1CTvDx-0004mp-IA@notabene.cse.unsw.edu.au>
References: <20041116153856.18330.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We replace 'size' by 'start'.
'start' means exactly the same as 'curr_offset - size', and
the equivalence of the new code can be tested based on this.
The difference is that 'start' will never be negative and so can
fit in a 'sector_t' while 'size' could be negative.

Also make curr_offset sector_t, as it should have been.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2004-11-16 15:24:31.000000000 +1100
+++ ./drivers/md/linear.c	2004-11-16 15:24:31.000000000 +1100
@@ -117,8 +117,8 @@ static int linear_run (mddev_t *mddev)
 	struct linear_hash *table;
 	mdk_rdev_t *rdev;
 	int i, nb_zone, cnt;
-	sector_t size;
-	unsigned int curr_offset;
+	sector_t start;
+	sector_t curr_offset;
 	struct list_head *tmp;
 
 	conf = kmalloc (sizeof (*conf) + mddev->raid_disks*sizeof(dev_info_t),
@@ -193,23 +193,24 @@ static int linear_run (mddev_t *mddev)
 	 * Here we generate the linear hash table
 	 */
 	table = conf->hash_table;
-	size = 0;
+	start = 0;
 	curr_offset = 0;
 	for (i = 0; i < cnt; i++) {
 		dev_info_t *disk = conf->disks + i;
 
+		if (start > curr_offset)
+			table[-1].dev1 = disk;
+
 		disk->offset = curr_offset;
 		curr_offset += disk->size;
 
-		if (size < 0) {
-			table[-1].dev1 = disk;
-		}
-		size += disk->size;
-
-		while (size>0) {
+		/* 'curr_offset' is the end of this disk
+		 * 'start' is the start of table
+		 */
+		while (start < curr_offset) {
 			table->dev0 = disk;
 			table->dev1 = NULL;
-			size -= conf->smallest->size;
+			start += conf->smallest->size;
 			table++;
 		}
 	}
