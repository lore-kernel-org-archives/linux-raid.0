From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 7 - Collect device IO statistics for MD personalities.
Date: Fri, 23 Jan 2004 11:14:24 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ajoxs-0000jk-00@notabene>
References: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Update {read,write}{s,_sectors} on each request to an MD array.

 ----------- Diffstat output ------------
 ./drivers/md/linear.c    |    8 ++++++++
 ./drivers/md/multipath.c |    7 +++++++
 ./drivers/md/raid0.c     |    8 ++++++++
 ./drivers/md/raid1.c     |    8 ++++++++
 ./drivers/md/raid5.c     |    8 ++++++++
 ./drivers/md/raid6main.c |    8 ++++++++
 6 files changed, 47 insertions(+)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2004-01-23 10:30:07.000000000 +1100
+++ ./drivers/md/linear.c	2004-01-23 10:36:51.000000000 +1100
@@ -208,6 +208,14 @@ static int linear_make_request (request_
 	dev_info_t *tmp_dev;
 	sector_t block;
 
+	if (bio_data_dir(bio)==WRITE) {
+		disk_stat_inc(mddev->gendisk, writes);
+		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bio));
+	} else {
+		disk_stat_inc(mddev->gendisk, reads);
+		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bio));
+	}
+
 	tmp_dev = which_dev(mddev, bio->bi_sector);
 	block = bio->bi_sector >> 1;
   

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-01-23 10:30:08.000000000 +1100
+++ ./drivers/md/multipath.c	2004-01-23 10:36:51.000000000 +1100
@@ -167,6 +167,13 @@ static int multipath_make_request (reque
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
 
+	if (bio_data_dir(bio)==WRITE) {
+		disk_stat_inc(mddev->gendisk, writes);
+		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bio));
+	} else {
+		disk_stat_inc(mddev->gendisk, reads);
+		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bio));
+	}
 	/*
 	 * read balancing logic:
 	 */

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2004-01-23 10:30:08.000000000 +1100
+++ ./drivers/md/raid0.c	2004-01-23 10:36:51.000000000 +1100
@@ -365,6 +365,14 @@ static int raid0_make_request (request_q
 	unsigned long chunk;
 	sector_t block, rsect;
 
+	if (bio_data_dir(bio)==WRITE) {
+		disk_stat_inc(mddev->gendisk, writes);
+		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bio));
+	} else {
+		disk_stat_inc(mddev->gendisk, reads);
+		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bio));
+	}
+
 	chunk_size = mddev->chunk_size >> 10;
 	chunk_sects = mddev->chunk_size >> 9;
 	chunksize_bits = ffz(~chunk_size);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-01-23 10:30:08.000000000 +1100
+++ ./drivers/md/raid1.c	2004-01-23 10:36:51.000000000 +1100
@@ -474,6 +474,14 @@ static int make_request(request_queue_t 
 	conf->nr_pending++;
 	spin_unlock_irq(&conf->resync_lock);
 
+	if (bio_data_dir(bio)==WRITE) {
+		disk_stat_inc(mddev->gendisk, writes);
+		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bio));
+	} else {
+		disk_stat_inc(mddev->gendisk, reads);
+		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bio));
+	}
+
 	/*
 	 * make_request() can abort the operation when READA is being
 	 * used and no empty request is available.

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-01-23 10:30:08.000000000 +1100
+++ ./drivers/md/raid5.c	2004-01-23 10:36:51.000000000 +1100
@@ -1326,6 +1326,14 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
+	if (bio_data_dir(bi)==WRITE) {
+		disk_stat_inc(mddev->gendisk, writes);
+		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bi));
+	} else {
+		disk_stat_inc(mddev->gendisk, reads);
+		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bi));
+	}
+
 	logical_sector = bi->bi_sector & ~(STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-01-23 10:30:08.000000000 +1100
+++ ./drivers/md/raid6main.c	2004-01-23 10:36:51.000000000 +1100
@@ -1488,6 +1488,14 @@ static int make_request (request_queue_t
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 
+	if (bio_data_dir(bi)==WRITE) {
+		disk_stat_inc(mddev->gendisk, writes);
+		disk_stat_add(mddev->gendisk, write_sectors, bio_sectors(bi));
+	} else {
+		disk_stat_inc(mddev->gendisk, reads);
+		disk_stat_add(mddev->gendisk, read_sectors, bio_sectors(bi));
+	}
+
 	logical_sector = bi->bi_sector & ~(STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 
