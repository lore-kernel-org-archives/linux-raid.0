From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/9] md: raid0_make_request(): Replace chunksize_bits by chunksect_bits.
Date: Mon, 20 Oct 2008 10:56:39 +0200
Message-ID: <1224493007-1255-2-git-send-email-maan@systemlinux.org>
References: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

As ffz(~(2 * x)) = ffz(~x) + 1, we have

	chunksect_bits = chunksize_bits + 1.

Fixup all users accordingly.
---
 drivers/md/raid0.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8ac6488..62a193c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -387,7 +387,7 @@ static int raid0_stop (mddev_t *mddev)
 static int raid0_make_request (struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	unsigned int sect_in_chunk, chunksize_bits,  chunk_size, chunk_sects;
+	unsigned int sect_in_chunk, chunksect_bits, chunk_size, chunk_sects;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
@@ -409,7 +409,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 
 	chunk_size = mddev->chunk_size >> 10;
 	chunk_sects = mddev->chunk_size >> 9;
-	chunksize_bits = ffz(~chunk_size);
+	chunksect_bits = ffz(~chunk_sects);
 	block = bio->bi_sector >> 1;
 	
 
@@ -446,15 +446,15 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 
 
 	{
-		sector_t x =  (block - zone->zone_offset) >> chunksize_bits;
+		sector_t x =  (block - zone->zone_offset) >> (chunksect_bits - 1);
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
 
-		x = block >> chunksize_bits;
+		x = block >> (chunksect_bits - 1);
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
 	}
-	rsect = (((chunk << chunksize_bits) + zone->dev_offset)<<1)
+	rsect = (((chunk << (chunksect_bits - 1)) + zone->dev_offset)<<1)
 		+ sect_in_chunk;
  
 	bio->bi_bdev = tmp_dev->bdev;
-- 
1.5.3.8

