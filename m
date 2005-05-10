From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 4] Fix spliting of md/linear request that cross a device boundary
Date: Tue, 10 May 2005 15:04:02 +1000
Message-ID: <E1DVMuY-0000Ps-9V@notabene.cse.unsw.edu.au>
References: <20050510145931.1553.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When a request crosses a boundary between devices, it needs to
be split.  But where we should calculate the amount of the request
before the boundary to find the split-point, we care currently calculating
the amount that is *after* the boundary !!!


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/linear.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2005-05-10 14:25:28.000000000 +1000
+++ ./drivers/md/linear.c	2005-05-10 14:26:45.000000000 +1000
@@ -269,9 +269,8 @@ static int linear_make_request (request_
 		 * split it.
 		 */
 		struct bio_pair *bp;
-		bp = bio_split(bio, bio_split_pool, 
-			       (bio->bi_sector + (bio->bi_size >> 9) -
-				(tmp_dev->offset + tmp_dev->size))<<1);
+		bp = bio_split(bio, bio_split_pool,
+			       ((tmp_dev->offset + tmp_dev->size)<<1) - bio->bi_sector);
 		if (linear_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (linear_make_request(q, &bp->bio2))
