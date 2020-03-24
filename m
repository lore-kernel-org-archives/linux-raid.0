From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/21] block: remove the blk_lookup_devt export
Date: Tue, 24 Mar 2020 08:25:10 +0100
Message-ID: <20200324072530.544483-2-hch@lst.de>
References: <20200324072530.544483-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200324072530.544483-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

This function is only used by init/do_mounts.c, which can't be modular.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6a60131baffa..c5d20a48b4de 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1487,7 +1487,6 @@ dev_t blk_lookup_devt(const char *name, int partno)
 	class_dev_iter_exit(&iter);
 	return devt;
 }
-EXPORT_SYMBOL(blk_lookup_devt);
 
 struct gendisk *__alloc_disk_node(int minors, int node_id)
 {
-- 
2.25.1
