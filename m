From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 2] md: Make sure bi_max_vecs is set properly in bio_split
Date: Mon, 22 May 2006 16:18:55 +1000
Message-ID: <1060522061855.2861@suse.de>
References: <20060522161259.2792.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Don Dupuis <dondster@gmail.com>, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids


Else a subsequence bio_clone might make a mess.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: "Don Dupuis" <dondster@gmail.com>
Cc: Jens Axboe <axboe@suse.de>
### Diffstat output
 ./fs/bio.c |    3 +++
 1 file changed, 3 insertions(+)

diff ./fs/bio.c~current~ ./fs/bio.c
--- ./fs/bio.c~current~	2006-05-22 16:12:46.000000000 +1000
+++ ./fs/bio.c	2006-05-22 16:12:16.000000000 +1000
@@ -1103,6 +1103,9 @@ struct bio_pair *bio_split(struct bio *b
 	bp->bio1.bi_io_vec = &bp->bv1;
 	bp->bio2.bi_io_vec = &bp->bv2;
 
+	bp->bio1.bi_max_vecs = 1;
+	bp->bio2.bi_max_vecs = 1;
+
 	bp->bio1.bi_end_io = bio_pair_end_1;
 	bp->bio2.bi_end_io = bio_pair_end_2;
 
