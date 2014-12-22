From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: [RFC PATCH 12/17] md/raid10: make sync_request_write() call bio_copy_data()
Date: Mon, 22 Dec 2014 12:48:39 +0100
Message-ID: <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
 <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
 <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
 <abe647cf7cf272220227fad4dac9c43641192f01.1419241597.git.dongsu.park@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <abe647cf7cf272220227fad4dac9c43641192f01.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Kent Overstreet <kmo@daterainc.com>

Refactor sync_request_write() of md/raid10 to use bio_copy_data()
instead of open coding bio_vec iterations.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/raid10.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 32e282f..4a40354 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2107,18 +2107,11 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_iter.bi_size = r10_bio->sectors << 9;
 		tbio->bi_rw = WRITE;
-		tbio->bi_private = r10_bio;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
-
-		for (j=0; j < vcnt ; j++) {
-			tbio->bi_io_vec[j].bv_offset = 0;
-			tbio->bi_io_vec[j].bv_len = PAGE_SIZE;
-
-			memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-			       page_address(fbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
-		}
 		tbio->bi_end_io = end_sync_write;
+		tbio->bi_private = r10_bio;
+
+		bio_copy_data(tbio, fbio);
 
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
@@ -2134,17 +2127,14 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * that are active
 	 */
 	for (i = 0; i < conf->copies; i++) {
-		int j, d;
+		int d;
 
 		tbio = r10_bio->devs[i].repl_bio;
 		if (!tbio || !tbio->bi_end_io)
 			continue;
 		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
 		    && r10_bio->devs[i].bio != fbio)
-			for (j = 0; j < vcnt; j++)
-				memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-				       page_address(fbio->bi_io_vec[j].bv_page),
-				       PAGE_SIZE);
+			bio_copy_data(tbio, fbio);
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
-- 
2.1.0
