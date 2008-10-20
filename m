From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/9] md: raid0_make_request(): Replace local variable block by sector.
Date: Mon, 20 Oct 2008 10:56:41 +0200
Message-ID: <1224493007-1255-4-git-send-email-maan@systemlinux.org>
References: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This change already simplifies the code a bit.
---
 drivers/md/raid0.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d843849..fd65d88 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -392,7 +392,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
 	sector_t chunk;
-	sector_t block, rsect;
+	sector_t sector, rsect;
 	const int rw = bio_data_dir(bio);
 	int cpu;
 
@@ -409,8 +409,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 
 	chunk_sects = mddev->chunk_size >> 9;
 	chunksect_bits = ffz(~chunk_sects);
-	block = bio->bi_sector >> 1;
-	
+	sector = bio->bi_sector;
 
 	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
 		struct bio_pair *bp;
@@ -433,24 +432,24 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
  
 
 	{
-		sector_t x = block >> conf->preshift;
+		sector_t x = sector >> (conf->preshift + 1);
 		sector_div(x, (u32)conf->hash_spacing);
 		zone = conf->hash_table[x];
 	}
  
-	while (block >= (zone->zone_offset + zone->size)) 
+	while (sector / 2 >= (zone->zone_offset + zone->size))
 		zone++;
     
 	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
 
 
 	{
-		sector_t x =  (block - zone->zone_offset) >> (chunksect_bits - 1);
+		sector_t x = (sector - zone->zone_offset * 2) >> chunksect_bits;
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
 
-		x = block >> (chunksect_bits - 1);
+		x = sector >> chunksect_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
 	}
 	rsect = (((chunk << (chunksect_bits - 1)) + zone->dev_offset)<<1)
-- 
1.5.3.8

