From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 2] Improve 'hash' code in linear.c
Date: Tue, 16 Nov 2004 15:45:49 +1100
Message-ID: <E1CTvDx-0004mt-Q5@notabene.cse.unsw.edu.au>
References: <20041116153856.18330.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The hashtable that linear uses to find the right device stores
two pointers for every entry.
The second is always one of:
   The first plus 1
   NULL
When NULL, it is never access, so any value can be stored.
Thus it could always be "first plus 1", and so we don't need to store
it as it is trivial to calculate.

This patch halves the size of this table, which results in some simpler
code as well.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c         |   38 ++++++++++++++------------------------
 ./include/linux/raid/linear.h |    7 +------
 2 files changed, 15 insertions(+), 30 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2004-11-16 15:24:31.000000000 +1100
+++ ./drivers/md/linear.c	2004-11-16 15:24:37.000000000 +1100
@@ -31,7 +31,7 @@
  */
 static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
 {
-	struct linear_hash *hash;
+	dev_info_t *hash;
 	linear_conf_t *conf = mddev_to_conf(mddev);
 	sector_t block = sector >> 1;
 
@@ -39,12 +39,11 @@ static inline dev_info_t *which_dev(mdde
 	 * sector_div(a,b) returns the remainer and sets a to a/b
 	 */
 	(void)sector_div(block, conf->smallest->size);
-	hash = conf->hash_table + block;
+	hash = conf->hash_table[block];
 
-	if ((sector>>1) >= (hash->dev0->size + hash->dev0->offset))
-		return hash->dev1;
-	else
-		return hash->dev0;
+	while ((sector>>1) >= (hash->size + hash->offset))
+		hash++;
+	return hash;
 }
 
 /**
@@ -114,7 +113,7 @@ static int linear_issue_flush(request_qu
 static int linear_run (mddev_t *mddev)
 {
 	linear_conf_t *conf;
-	struct linear_hash *table;
+	dev_info_t **table;
 	mdk_rdev_t *rdev;
 	int i, nb_zone, cnt;
 	sector_t start;
@@ -184,7 +183,7 @@ static int linear_run (mddev_t *mddev)
 		nb_zone = conf->nr_zones = sz + (round ? 1 : 0);
 	}
 			
-	conf->hash_table = kmalloc (sizeof (struct linear_hash) * nb_zone,
+	conf->hash_table = kmalloc (sizeof (dev_info_t*) * nb_zone,
 					GFP_KERNEL);
 	if (!conf->hash_table)
 		goto out;
@@ -198,9 +197,6 @@ static int linear_run (mddev_t *mddev)
 	for (i = 0; i < cnt; i++) {
 		dev_info_t *disk = conf->disks + i;
 
-		if (start > curr_offset)
-			table[-1].dev1 = disk;
-
 		disk->offset = curr_offset;
 		curr_offset += disk->size;
 
@@ -208,10 +204,8 @@ static int linear_run (mddev_t *mddev)
 		 * 'start' is the start of table
 		 */
 		while (start < curr_offset) {
-			table->dev0 = disk;
-			table->dev1 = NULL;
+			*table++ = disk;
 			start += conf->smallest->size;
-			table++;
 		}
 	}
 	if (table-conf->hash_table != nb_zone)
@@ -255,13 +249,6 @@ static int linear_make_request (request_
 
 	tmp_dev = which_dev(mddev, bio->bi_sector);
 	block = bio->bi_sector >> 1;
-  
-	if (unlikely(!tmp_dev)) {
-		printk("linear_make_request: hash->dev1==NULL for block %llu\n",
-			(unsigned long long)block);
-		bio_io_error(bio, bio->bi_size);
-		return 0;
-	}
     
 	if (unlikely(block >= (tmp_dev->size + tmp_dev->offset)
 		     || block < tmp_dev->offset)) {
@@ -306,17 +293,20 @@ static void linear_status (struct seq_fi
 #ifdef MD_DEBUG
 	int j;
 	linear_conf_t *conf = mddev_to_conf(mddev);
+	sector_t s = 0;
   
 	seq_printf(seq, "      ");
 	for (j = 0; j < conf->nr_zones; j++)
 	{
 		char b[BDEVNAME_SIZE];
+		s += conf->smallest_size;
 		seq_printf(seq, "[%s",
-			   bdevname(conf->hash_table[j].dev0->rdev->bdev,b));
+			   bdevname(conf->hash_table[j][0].rdev->bdev,b));
 
-		if (conf->hash_table[j].dev1)
+		while (s > conf->hash_table[j][0].offset + 
+		           conf->hash_table[j][0].size)
 			seq_printf(seq, "/%s] ",
-				   bdevname(conf->hash_table[j].dev1->rdev->bdev,b));
+				   bdevname(conf->hash_table[j][1].rdev->bdev,b));
 		else
 			seq_printf(seq, "] ");
 	}

diff ./include/linux/raid/linear.h~current~ ./include/linux/raid/linear.h
--- ./include/linux/raid/linear.h~current~	2004-11-16 15:24:37.000000000 +1100
+++ ./include/linux/raid/linear.h	2004-11-16 15:24:37.000000000 +1100
@@ -11,14 +11,9 @@ struct dev_info {
 
 typedef struct dev_info dev_info_t;
 
-struct linear_hash
-{
-	dev_info_t *dev0, *dev1;
-};
-
 struct linear_private_data
 {
-	struct linear_hash	*hash_table;
+	dev_info_t		**hash_table;
 	dev_info_t		*smallest;
 	int			nr_zones;
 	dev_info_t		disks[0];
