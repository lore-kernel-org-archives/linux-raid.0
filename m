From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/15] md: stop using ->queuedata
Date: Fri,  8 May 2020 18:15:14 +0200
Message-ID: <20200508161517.252308-13-hch@lst.de>
References: <20200508161517.252308-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
Sender: linux-m68k-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 271e8a5873549..c079ecf77c564 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -466,7 +466,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
 	const int sgrp = op_stat_group(bio_op(bio));
-	struct mddev *mddev = q->queuedata;
+	struct mddev *mddev = bio->bi_disk->private_data;
 	unsigned int sectors;
 
 	if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw == WRITE)) {
@@ -5626,7 +5626,6 @@ static int md_alloc(dev_t dev, char *name)
 	mddev->queue = blk_alloc_queue(md_make_request, NUMA_NO_NODE);
 	if (!mddev->queue)
 		goto abort;
-	mddev->queue->queuedata = mddev;
 
 	blk_set_stacking_limits(&mddev->queue->limits);
 
-- 
2.26.2
