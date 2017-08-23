From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] block: reject attempts to allocate more than DISK_MAX_PARTS partitions
Date: Wed, 23 Aug 2017 19:10:29 +0200
Message-ID: <20170823171032.30529-4-hch@lst.de>
References: <20170823171032.30529-1-hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20170823171032.30529-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 2367087cdb7c..3380a1e73ea0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1357,6 +1357,13 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 	struct gendisk *disk;
 	struct disk_part_tbl *ptbl;
 
+	if (minors > DISK_MAX_PARTS) {
+		printk(KERN_ERR
+			"block: can't allocated more than %d partitions\n",
+			DISK_MAX_PARTS);
+		minors = DISK_MAX_PARTS;
+	}
+
 	disk = kzalloc_node(sizeof(struct gendisk), GFP_KERNEL, node_id);
 	if (disk) {
 		if (!init_part_stats(&disk->part0)) {
-- 
2.11.0

