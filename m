From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 8 of 14 - Improve raid0 mapping code to simplify and reduce mem usage.
Date: Tue, 27 May 2003 13:01:13 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUi9-0003HB-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

To cope with a raid0 array with differing sized devices,
raid0 divides an array into "strip zones".
The first zone covers the start of all devices, upto an offset
equal to the size of the smallest device.

The second strip zone covers the remaining devices upto the size of the
next smallest size, etc.

In order to determing which strip zone a given address is in,
the array is logically divided into slices the size of the smallest
zone, and a 'hash' table is created listing the first and, if relevant,
second zone in each slice.

As the smallest slice can be very small (imagine an array with a 
76G drive and a 75.5G drive) this hash table can be rather large.

With this patch, we limit the size of the hash table to one page,
at the possible cost of making several probes into the zone list
before we find the correct zone.

We also cope with the possibility that a zone could be larger than
a 32bit sector address would allow.

 ----------- Diffstat output ------------
 ./drivers/md/raid0.c         |  170 ++++++++++++++++++-------------------------
 ./include/linux/raid/raid0.h |   14 +--
 2 files changed, 78 insertions(+), 106 deletions(-)

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-05-27 11:58:23.000000000 +1000
+++ ./drivers/md/raid0.c	2003-05-27 11:58:25.000000000 +1000
@@ -30,6 +30,7 @@ static int create_strip_zones (mddev_t *
 {
 	int i, c, j;
 	sector_t current_offset, curr_zone_offset;
+	sector_t min_spacing;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
 	struct list_head *tmp1, *tmp2;
@@ -83,7 +84,7 @@ static int create_strip_zones (mddev_t *
 	memset(conf->strip_zone, 0,sizeof(struct strip_zone)*
 				   conf->nr_strip_zones);
 	/* The first zone must contain all devices, so here we check that
-	 * there is a properly alignment of slots to devices and find them all
+	 * there is a proper alignment of slots to devices and find them all
 	 */
 	zone = &conf->strip_zone[0];
 	cnt = 0;
@@ -114,7 +115,6 @@ static int create_strip_zones (mddev_t *
 	zone->size = smallest->size * cnt;
 	zone->zone_offset = 0;
 
-	conf->smallest = zone;
 	current_offset = smallest->size;
 	curr_zone_offset = zone->size;
 
@@ -150,9 +150,6 @@ static int create_strip_zones (mddev_t *
 		printk("raid0: zone->nb_dev: %d, size: %llu\n",
 			zone->nb_dev, (unsigned long long)zone->size);
 
-		if (!conf->smallest || (zone->size < conf->smallest->size))
-			conf->smallest = zone;
-
 		zone->zone_offset = curr_zone_offset;
 		curr_zone_offset += zone->size;
 
@@ -160,6 +157,27 @@ static int create_strip_zones (mddev_t *
 		printk("raid0: current zone offset: %llu\n",
 			(unsigned long long)current_offset);
 	}
+
+	/* Now find appropriate hash spacing.
+	 * We want a number which causes most hash entries to cover
+	 * at most two strips, but the hash table must be at most
+	 * 1 PAGE.  We choose the smallest strip, or contiguous collection
+	 * of strips, that has big enough size.  We never consider the last
+	 * strip though as it's size has no bearing on the efficacy of the hash
+	 * table.
+	 */
+	conf->hash_spacing = curr_zone_offset;
+	min_spacing = curr_zone_offset;
+	sector_div(min_spacing, PAGE_SIZE/sizeof(struct strip_zone*));
+	for (i=0; i < conf->nr_strip_zones-1; i++) {
+		sector_t sz = 0;
+		for (j=i; j<conf->nr_strip_zones-1 &&
+			     sz < min_spacing ; j++)
+			sz += conf->strip_zone[j].size;
+		if (sz >= min_spacing && sz < conf->hash_spacing)
+			conf->hash_spacing = sz;
+	}
+
 	printk("raid0: done.\n");
 	return 0;
  abort:
@@ -194,7 +212,6 @@ static int raid0_mergeable_bvec(request_
 static int raid0_run (mddev_t *mddev)
 {
 	unsigned  cur=0, i=0, nb_zone;
-	sector_t zone0_size;
 	s64 size;
 	raid0_conf_t *conf;
 	mdk_rdev_t *rdev;
@@ -215,60 +232,53 @@ static int raid0_run (mddev_t *mddev)
 
 	printk("raid0 : md_size is %llu blocks.\n", 
 		(unsigned long long)mddev->array_size);
-	printk("raid0 : conf->smallest->size is %llu blocks.\n",
-		(unsigned long long)conf->smallest->size);
+	printk("raid0 : conf->hash_spacing is %llu blocks.\n",
+		(unsigned long long)conf->hash_spacing);
 	{
 #if __GNUC__ < 3
 		volatile
 #endif
 		sector_t s = mddev->array_size;
-		int round = sector_div(s, (unsigned long)conf->smallest->size) ? 1 : 0;
+		sector_t space = conf->hash_spacing;
+		int round;
+		conf->preshift = 0;
+		if (sizeof(sector_t) > sizeof(unsigned long)) {
+			/*shift down space and s so that sector_div will work */
+			while (space > (sector_t) (~(unsigned long)0)) {
+				s >>= 1;
+				space >>= 1;
+				s += 1; /* force round-up */
+				conf->preshift++;
+			}
+		}
+		round = sector_div(s, (unsigned long)space) ? 1 : 0;
 		nb_zone = s + round;
 	}
 	printk("raid0 : nb_zone is %d.\n", nb_zone);
-	conf->nr_zones = nb_zone;
 
 	printk("raid0 : Allocating %Zd bytes for hash.\n",
-				nb_zone*sizeof(struct raid0_hash));
-	conf->hash_table = kmalloc (sizeof (struct raid0_hash)*nb_zone, GFP_KERNEL);
+				nb_zone*sizeof(struct strip_zone*));
+	conf->hash_table = kmalloc (sizeof (struct strip_zone *)*nb_zone, GFP_KERNEL);
 	if (!conf->hash_table)
 		goto out_free_zone_conf;
 	size = conf->strip_zone[cur].size;
 
-	i = 0;
-	while (cur < conf->nr_strip_zones) {
-		conf->hash_table[i].zone0 = conf->strip_zone + cur;
-
-		/*
-		 * If we completely fill the slot
-		 */
-		if (size >= conf->smallest->size) {
-			conf->hash_table[i++].zone1 = NULL;
-			size -= conf->smallest->size;
-
-			if (!size) {
-				if (++cur == conf->nr_strip_zones)
-					continue;
-				size = conf->strip_zone[cur].size;
-			}
-			continue;
+	for (i=0; i< nb_zone; i++) {
+		conf->hash_table[i] = conf->strip_zone + cur;
+		while (size <= conf->hash_spacing) {
+			cur++;
+			size += conf->strip_zone[cur].size;
 		}
-		if (++cur == conf->nr_strip_zones) {
-			/*
-			 * Last dev, set unit1 as NULL
-			 */
-			conf->hash_table[i].zone1=NULL;
-			continue;
-		}
-
-		/*
-		 * Here we use a 2nd dev to fill the slot
+		size -= conf->hash_spacing;
+	}
+	if (conf->preshift) {
+		conf->hash_spacing >>= conf->preshift;
+		/* round hash_spacing up so when we divide by it, we
+		 * err on the side of too-low, which is safest
 		 */
-		zone0_size = size;
-		size = conf->strip_zone[cur].size;
-		conf->hash_table[i++].zone1 = conf->strip_zone + cur;
-		size -= (conf->smallest->size - zone0_size);
+		conf->hash_spacing++;
 	}
+
 	blk_queue_max_sectors(&mddev->queue, mddev->chunk_size >> 9);
 	blk_queue_merge_bvec(&mddev->queue, raid0_mergeable_bvec);
 	return 0;
@@ -303,7 +313,6 @@ static int raid0_make_request (request_q
 	mddev_t *mddev = q->queuedata;
 	unsigned int sect_in_chunk, chunksize_bits,  chunk_size;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
-	struct raid0_hash *hash;
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
 	unsigned long chunk;
@@ -314,15 +323,6 @@ static int raid0_make_request (request_q
 	block = bio->bi_sector >> 1;
 	
 
-	{
-#if __GNUC__ < 3
-		volatile
-#endif
-		sector_t x = block;
-		sector_div(x, (unsigned long)conf->smallest->size);
-		hash = conf->hash_table + x;
-	}
-
 	if (unlikely(chunk_size < (block & (chunk_size - 1)) + (bio->bi_size >> 10))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
@@ -337,30 +337,31 @@ static int raid0_make_request (request_q
 			generic_make_request(&bp->bio1);
 		if (raid0_make_request(q, &bp->bio2))
 			generic_make_request(&bp->bio2);
+
 		bio_pair_release(bp);
 		return 0;
 	}
  
-	if (!hash)
-		goto bad_hash;
 
-	if (!hash->zone0)
-		goto bad_zone0;
+	{
+#if __GNUC__ < 3
+		volatile
+#endif
+		sector_t x = block >> conf->preshift;
+		sector_div(x, (unsigned long)conf->hash_spacing);
+		zone = conf->hash_table[x];
+	}
  
-	if (block >= (hash->zone0->size + hash->zone0->zone_offset)) {
-		if (!hash->zone1)
-			goto bad_zone1;
-		zone = hash->zone1;
-	} else
-		zone = hash->zone0;
+	while (block >= (zone->zone_offset + zone->size)) 
+		zone++;
     
 	sect_in_chunk = bio->bi_sector & ((chunk_size<<1) -1);
 
 
 	{
-		sector_t x =  block - zone->zone_offset;
+		sector_t x =  (block - zone->zone_offset) >> chunksize_bits;
 
-		sector_div(x, (zone->nb_dev << chunksize_bits));
+		sector_div(x, zone->nb_dev);
 		chunk = x;
 		BUG_ON(x != (sector_t)chunk);
 
@@ -370,10 +371,6 @@ static int raid0_make_request (request_q
 	rsect = (((chunk << chunksize_bits) + zone->dev_offset)<<1)
 		+ sect_in_chunk;
  
-	/*
-	 * The new BH_Lock semantics in ll_rw_blk.c guarantee that this
-	 * is the only IO operation happening on this bh.
-	 */
 	bio->bi_bdev = tmp_dev->bdev;
 	bio->bi_sector = rsect + tmp_dev->data_offset;
 
@@ -386,19 +383,7 @@ bad_map:
 	printk("raid0_make_request bug: can't convert block across chunks"
 		" or bigger than %dk %llu %d\n", chunk_size, 
 		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
-	goto outerr;
-bad_hash:
-	printk("raid0_make_request bug: hash==NULL for block %llu\n",
-		(unsigned long long)block);
-	goto outerr;
-bad_zone0:
-	printk("raid0_make_request bug: hash->zone0==NULL for block %llu\n",
-		(unsigned long long)block);
-	goto outerr;
-bad_zone1:
-	printk("raid0_make_request bug: hash->zone1==NULL for block %llu\n",
-			(unsigned long long)block);
- outerr:
+
 	bio_io_error(bio, bio->bi_size);
 	return 0;
 }
@@ -407,24 +392,15 @@ static void raid0_status (struct seq_fil
 {
 #undef MD_DEBUG
 #ifdef MD_DEBUG
-	int j, k;
+	int j, k, h;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
   
-	seq_printf(seq, "      ");
-	for (j = 0; j < conf->nr_zones; j++) {
-		seq_printf(seq, "[z%d",
-				conf->hash_table[j].zone0 - conf->strip_zone);
-		if (conf->hash_table[j].zone1)
-			seq_printf(seq, "/z%d] ",
-				conf->hash_table[j].zone1 - conf->strip_zone);
-		else
-			seq_printf(seq, "] ");
-	}
-  
-	seq_printf(seq, "\n");
-  
+	h = 0;
 	for (j = 0; j < conf->nr_strip_zones; j++) {
-		seq_printf(seq, "      z%d=[", j);
+		seq_printf(seq, "      z%d", j);
+		if (conf->hash_table[h] == conf->strip_zone+j)
+			seq_printf("(h%d)", h++);
+		seq_printf(seq, "=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
 			seq_printf (seq, "%s/", bdev_partition_name(
 				conf->strip_zone[j].dev[k]->bdev));

diff ./include/linux/raid/raid0.h~current~ ./include/linux/raid/raid0.h
--- ./include/linux/raid/raid0.h~current~	2003-05-27 11:58:24.000000000 +1000
+++ ./include/linux/raid/raid0.h	2003-05-27 11:58:25.000000000 +1000
@@ -12,18 +12,14 @@ struct strip_zone
 	mdk_rdev_t *dev[MD_SB_DISKS]; /* Devices attached to the zone */
 };
 
-struct raid0_hash
-{
-	struct strip_zone *zone0, *zone1;
-};
-
 struct raid0_private_data
 {
-	struct raid0_hash *hash_table; /* Dynamically allocated */
-	struct strip_zone *strip_zone; /* This one too */
+	struct strip_zone **hash_table; /* Table of indexes into strip_zone */
+	struct strip_zone *strip_zone;
 	int nr_strip_zones;
-	struct strip_zone *smallest;
-	int nr_zones;
+
+	sector_t hash_spacing;
+	int preshift;			/* shift this before divide by hash_spacing */
 };
 
 typedef struct raid0_private_data raid0_conf_t;
