From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/15] nvdimm/pmem: stop using ->queuedata
Date: Fri,  8 May 2020 18:15:17 +0200
Message-ID: <20200508161517.252308-16-hch@lst.de>
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
 drivers/nvdimm/pmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 2df6994acf836..f8dc5941215bf 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -196,7 +196,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long start;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
-	struct pmem_device *pmem = q->queuedata;
+	struct pmem_device *pmem = bio->bi_disk->private_data;
 	struct nd_region *nd_region = to_region(pmem);
 
 	if (bio->bi_opf & REQ_PREFLUSH)
@@ -231,7 +231,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 		       struct page *page, unsigned int op)
 {
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	blk_status_t rc;
 
 	if (op_is_write(op))
@@ -464,7 +464,6 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 	if (pmem->pfn_flags & PFN_MAP)
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
-	q->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
 	if (!disk)
@@ -474,6 +473,7 @@ static int pmem_attach_disk(struct device *dev,
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
+	disk->private_data	= pmem;
 	disk->queue->backing_dev_info->capabilities |= BDI_CAP_SYNCHRONOUS_IO;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
-- 
2.26.2
