From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Found a new bug!
Date: Mon, 15 Aug 2005 11:21:07 +1000
Message-ID: <17151.60931.26972.713074@cse.unsw.edu.au>
References: <20050717182650.24540.patches@notabene>
	<E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
	<009001c58ac8$9ab25d40$0400a8c0@LocalHost>
	<17114.55335.687696.686786@cse.unsw.edu.au>
	<03e501c5a120$f3a79a00$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from djani22@dynamicweb.hu on Monday August 15
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 15, djani22@dynamicweb.hu wrote:
> Hello list, Neil!
> 
> Is there something news with the 2TB raid-input problem?
> Sooner or later, I will need to join two 8TB array to one big 16TB. :-)

Thanks for the reminder.

The following patch should work, but my test machine won't boot the
current -mm kernels :-( so it is hard to test properly.

Let me know the results if you are able to test it.

Thanks,
NeilBrown

---------------------------------
Support md/linear array with components greater than 2 terabytes.

linear currently uses division by the size of the smallest componenet
device to find which device a request goes to.
If that smallest device is larger than 2 terabytes, then the division
will not work on some systems.

So we introduce a pre-shift, and take care not to make the hash table
too large, much like the code in raid0.

Also get rid of conf->nr_zones, which is not needed.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c         |   99 ++++++++++++++++++++++++++++--------------
 ./include/linux/raid/linear.h |    4 -
 2 files changed, 70 insertions(+), 33 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2005-08-15 11:18:21.000000000 +1000
+++ ./drivers/md/linear.c	2005-08-15 11:18:27.000000000 +1000
@@ -38,7 +38,8 @@ static inline dev_info_t *which_dev(mdde
 	/*
 	 * sector_div(a,b) returns the remainer and sets a to a/b
 	 */
-	(void)sector_div(block, conf->smallest->size);
+	block >>= conf->preshift;
+	(void)sector_div(block, conf->hash_spacing);
 	hash = conf->hash_table[block];
 
 	while ((sector>>1) >= (hash->size + hash->offset))
@@ -47,7 +48,7 @@ static inline dev_info_t *which_dev(mdde
 }
 
 /**
- *	linear_mergeable_bvec -- tell bio layer if a two requests can be merged
+ *	linear_mergeable_bvec -- tell bio layer if two requests can be merged
  *	@q: request queue
  *	@bio: the buffer head that's been built up so far
  *	@biovec: the request that could be merged to it.
@@ -116,7 +117,7 @@ static int linear_run (mddev_t *mddev)
 	dev_info_t **table;
 	mdk_rdev_t *rdev;
 	int i, nb_zone, cnt;
-	sector_t start;
+	sector_t min_spacing;
 	sector_t curr_offset;
 	struct list_head *tmp;
 
@@ -127,11 +128,6 @@ static int linear_run (mddev_t *mddev)
 	memset(conf, 0, sizeof(*conf) + mddev->raid_disks*sizeof(dev_info_t));
 	mddev->private = conf;
 
-	/*
-	 * Find the smallest device.
-	 */
-
-	conf->smallest = NULL;
 	cnt = 0;
 	mddev->array_size = 0;
 
@@ -159,8 +155,6 @@ static int linear_run (mddev_t *mddev)
 		disk->size = rdev->size;
 		mddev->array_size += rdev->size;
 
-		if (!conf->smallest || (disk->size < conf->smallest->size))
-			conf->smallest = disk;
 		cnt++;
 	}
 	if (cnt != mddev->raid_disks) {
@@ -168,6 +162,36 @@ static int linear_run (mddev_t *mddev)
 		goto out;
 	}
 
+	min_spacing = mddev->array_size;
+	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
+
+	/* min_spacing is the minimum spacing that will fit the hash
+	 * table in one PAGE.  This may be much smaller than needed.
+	 * We find the smallest non-terminal set of consecutive devices
+	 * that is larger than min_spacing as use the size of that as
+	 * the actual spacing 
+	 */
+	conf->hash_spacing = mddev->array_size;
+	for (i=0; i < cnt-1 ; i++) {
+		sector_t sz = 0;
+		int j;
+		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
+			sz += conf->disks[j].size;
+		if (sz >= min_spacing && sz < conf->hash_spacing)
+			conf->hash_spacing = sz;
+	}
+
+	/* hash_spacing may be too large for sector_div to work with,
+	 * so we might need to pre-shift 
+	 */
+	conf->preshift = 0;
+	if (sizeof(sector_t) > sizeof(u32)) {
+		sector_t space = conf->hash_spacing;
+		while (space > (sector_t)(~(u32)0)) {
+			space >>= 1;
+			conf->preshift++;
+		}
+	}
 	/*
 	 * This code was restructured to work around a gcc-2.95.3 internal
 	 * compiler error.  Alter it with care.
@@ -177,39 +201,52 @@ static int linear_run (mddev_t *mddev)
 		unsigned round;
 		unsigned long base;
 
-		sz = mddev->array_size;
-		base = conf->smallest->size;
+		sz = mddev->array_size >> conf->preshift;
+		sz += 1; /* force round-up */
+		base = conf->hash_spacing >> conf->preshift;
 		round = sector_div(sz, base);
-		nb_zone = conf->nr_zones = sz + (round ? 1 : 0);
+		nb_zone = sz + (round ? 1 : 0);
 	}
-			
-	conf->hash_table = kmalloc (sizeof (dev_info_t*) * nb_zone,
+	BUG_ON(nb_zone > PAGE_SIZE / sizeof(struct dev_info *));
+
+	conf->hash_table = kmalloc (sizeof (struct dev_info *) * nb_zone,
 					GFP_KERNEL);
 	if (!conf->hash_table)
 		goto out;
 
 	/*
 	 * Here we generate the linear hash table
+	 * First calculate the device offsets.
 	 */
+	conf->disks[0].offset = 0;
+	for (i=1; i<mddev->raid_disks; i++)
+		conf->disks[i].offset =
+			conf->disks[i-1].offset +
+			conf->disks[i-1].size;
+
 	table = conf->hash_table;
-	start = 0;
 	curr_offset = 0;
-	for (i = 0; i < cnt; i++) {
-		dev_info_t *disk = conf->disks + i;
-
-		disk->offset = curr_offset;
-		curr_offset += disk->size;
-
-		/* 'curr_offset' is the end of this disk
-		 * 'start' is the start of table
+	i = 0;
+	for (curr_offset = 0;
+	     curr_offset < mddev->array_size;
+	     curr_offset += conf->hash_spacing) {
+
+		while (i < mddev->raid_disks-1 &&
+		       curr_offset >= conf->disks[i+1].offset)
+			i++;
+
+		*table ++ = conf->disks + i;
+	}
+
+	if (conf->preshift) {
+		conf->hash_spacing >>= conf->preshift;
+		/* round hash_spacing up so that when we divide by it,
+		 * we err on the side of "too-low", which is safest.
 		 */
-		while (start < curr_offset) {
-			*table++ = disk;
-			start += conf->smallest->size;
-		}
+		conf->hash_spacing++;
 	}
-	if (table-conf->hash_table != nb_zone)
-		BUG();
+
+	BUG_ON(table - conf->hash_table > nb_zone);
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
@@ -299,7 +336,7 @@ static void linear_status (struct seq_fi
 	sector_t s = 0;
   
 	seq_printf(seq, "      ");
-	for (j = 0; j < conf->nr_zones; j++)
+	for (j = 0; j < mddev->raid_disks; j++)
 	{
 		char b[BDEVNAME_SIZE];
 		s += conf->smallest_size;

diff ./include/linux/raid/linear.h~current~ ./include/linux/raid/linear.h
--- ./include/linux/raid/linear.h~current~	2005-08-15 11:18:21.000000000 +1000
+++ ./include/linux/raid/linear.h	2005-08-15 09:13:55.000000000 +1000
@@ -14,8 +14,8 @@ typedef struct dev_info dev_info_t;
 struct linear_private_data
 {
 	dev_info_t		**hash_table;
-	dev_info_t		*smallest;
-	int			nr_zones;
+	sector_t		hash_spacing;
+	int			preshift; /* shift before dividing by hash_spacing */
 	dev_info_t		disks[0];
 };
 
