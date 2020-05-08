From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/15] nfblock: use gendisk private_data
Date: Fri,  8 May 2020 18:15:03 +0200
Message-ID: <20200508161517.252308-2-hch@lst.de>
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
 arch/m68k/emu/nfblock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index c3a630440512e..5c6f04b00e866 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -61,7 +61,7 @@ struct nfhd_device {
 
 static blk_qc_t nfhd_make_request(struct request_queue *queue, struct bio *bio)
 {
-	struct nfhd_device *dev = queue->queuedata;
+	struct nfhd_device *dev = bio->bi_disk->private_data;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	int dir, len, shift;
@@ -122,7 +122,6 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	if (dev->queue == NULL)
 		goto free_dev;
 
-	dev->queue->queuedata = dev;
 	blk_queue_logical_block_size(dev->queue, bsize);
 
 	dev->disk = alloc_disk(16);
@@ -136,6 +135,7 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	sprintf(dev->disk->disk_name, "nfhd%u", dev_id);
 	set_capacity(dev->disk, (sector_t)blocks * (bsize / 512));
 	dev->disk->queue = dev->queue;
+	dev->disk->private_data = dev;
 
 	add_disk(dev->disk);
 
-- 
2.26.2
