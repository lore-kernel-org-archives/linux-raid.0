From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md -  Use sector rather than block numbers when splitting raid0 requests.
Date: Mon, 20 Oct 2003 11:21:53 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1ABOk5-0002TI-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

When raid0 needs to split a request, it uses 'block' (1K)
addresses rather than sector (512b) addresses, which causes
problems if the sector address is odd.  This patch fixes the problem.

Thanks to Andy Polyakov <appro@fy.chalmers.se>


 ----------- Diffstat output ------------
 ./drivers/md/raid0.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-10-20 10:47:26.000000000 +1000
+++ ./drivers/md/raid0.c	2003-10-20 10:54:00.000000000 +1000
@@ -332,7 +332,7 @@ static int raid0_stop (mddev_t *mddev)
 static int raid0_make_request (request_queue_t *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	unsigned int sect_in_chunk, chunksize_bits,  chunk_size;
+	unsigned int sect_in_chunk, chunksize_bits,  chunk_size, chunk_sects;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
@@ -340,11 +340,12 @@ static int raid0_make_request (request_q
 	sector_t block, rsect;
 
 	chunk_size = mddev->chunk_size >> 10;
+	chunk_sects = mddev->chunk_size >> 9;
 	chunksize_bits = ffz(~chunk_size);
 	block = bio->bi_sector >> 1;
 	
 
-	if (unlikely(chunk_size < (block & (chunk_size - 1)) + (bio->bi_size >> 10))) {
+	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
 		if (bio->bi_vcnt != 1 ||
@@ -353,7 +354,7 @@ static int raid0_make_request (request_q
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, bio_split_pool, (chunk_size - (block & (chunk_size - 1)))<<1 );
+		bp = bio_split(bio, bio_split_pool, chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
 		if (raid0_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (raid0_make_request(q, &bp->bio2))
