From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/15] dm: stop using ->queuedata
Date: Fri,  8 May 2020 18:15:13 +0200
Message-ID: <20200508161517.252308-12-hch@lst.de>
References: <20200508161517.252308-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0eb93da44ea2a..2aaae6c1ed312 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1783,7 +1783,7 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct mapped_device *md = q->queuedata;
+	struct mapped_device *md = bio->bi_disk->private_data;
 	blk_qc_t ret = BLK_QC_T_NONE;
 	int srcu_idx;
 	struct dm_table *map;
@@ -1980,7 +1980,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->queue = blk_alloc_queue(dm_make_request, numa_node_id);
 	if (!md->queue)
 		goto bad;
-	md->queue->queuedata = md;
 
 	md->disk = alloc_disk_node(1, md->numa_node_id);
 	if (!md->disk)
-- 
2.26.2
