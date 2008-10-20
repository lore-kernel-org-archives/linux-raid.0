From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/9] md: raid0_make_request(): Remove local variable chunk_size.
Date: Mon, 20 Oct 2008 10:56:40 +0200
Message-ID: <1224493007-1255-3-git-send-email-maan@systemlinux.org>
References: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

We might as well use chunk_sects instead.
---
 drivers/md/raid0.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 62a193c..d843849 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -387,7 +387,7 @@ static int raid0_stop (mddev_t *mddev)
 static int raid0_make_request (struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	unsigned int sect_in_chunk, chunksect_bits, chunk_size, chunk_sects;
+	unsigned int sect_in_chunk, chunksect_bits, chunk_sects;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
@@ -407,7 +407,6 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		      bio_sectors(bio));
 	part_stat_unlock();
 
-	chunk_size = mddev->chunk_size >> 10;
 	chunk_sects = mddev->chunk_size >> 9;
 	chunksect_bits = ffz(~chunk_sects);
 	block = bio->bi_sector >> 1;
@@ -442,7 +441,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	while (block >= (zone->zone_offset + zone->size)) 
 		zone++;
     
-	sect_in_chunk = bio->bi_sector & ((chunk_size<<1) -1);
+	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
 
 
 	{
@@ -467,7 +466,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 
 bad_map:
 	printk("raid0_make_request bug: can't convert block across chunks"
-		" or bigger than %dk %llu %d\n", chunk_size, 
+		" or bigger than %dk %llu %d\n", chunk_sects / 2,
 		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 
 	bio_io_error(bio);
-- 
1.5.3.8

