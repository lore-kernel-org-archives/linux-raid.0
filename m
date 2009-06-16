From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 006:013]:raid0: remove redundant argument from
	is_in_chunk_boundary
Date: Wed, 17 Jun 2009 00:54:18 +0300
Message-ID: <1245189258.3478.104.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

remove redundant argument from is_in_chunk_boundary

 raid0.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0bb151b..c3fd471 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -476,8 +476,8 @@ static mdk_rdev_t *map_sector(mddev_t *mddev, struct strip_zone *zone,
 /*
  * Is io distribute over 1 or more chunks ?
 */
-static inline int is_io_in_chunk_boundary(mddev_t *mddev,
-			unsigned int chunk_sects, struct bio *bio)
+static inline int is_io_in_chunk_boundary(unsigned int chunk_sects,
+						struct bio *bio)
 {
 	if (likely(is_power_of_2(chunk_sects))) {
 		return chunk_sects >= ((bio->bi_sector & (chunk_sects-1))
@@ -511,7 +511,7 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 	part_stat_unlock();
 
 	chunk_sects = mddev->chunk_sectors;
-	if (unlikely(!is_io_in_chunk_boundary(mddev, chunk_sects, bio))) {
+	if (unlikely(!is_io_in_chunk_boundary(chunk_sects, bio))) {
 		sector_t sector = bio->bi_sector;
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */




