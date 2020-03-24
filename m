From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/21] scsi: simplify scsi_bios_ptable
Date: Tue, 24 Mar 2020 08:25:15 +0100
Message-ID: <20200324072530.544483-7-hch@lst.de>
References: <20200324072530.544483-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20200324072530.544483-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

Use read_mapping_page and kmemdup instead of the odd read_dev_sector and
put_dev_sector helpers from the partitioning code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsicam.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
index e969138051c7..91a9530a4dcb 100644
--- a/drivers/scsi/scsicam.c
+++ b/drivers/scsi/scsicam.c
@@ -35,19 +35,17 @@ static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds
  */
 unsigned char *scsi_bios_ptable(struct block_device *dev)
 {
-	unsigned char *res = kmalloc(66, GFP_KERNEL);
-	if (res) {
-		struct block_device *bdev = dev->bd_contains;
-		Sector sect;
-		void *data = read_dev_sector(bdev, 0, &sect);
-		if (data) {
-			memcpy(res, data + 0x1be, 66);
-			put_dev_sector(sect);
-		} else {
-			kfree(res);
-			res = NULL;
-		}
-	}
+	struct address_space *mapping = dev->bd_contains->bd_inode->i_mapping;
+	unsigned char *res = NULL;
+	struct page *page;
+
+	page = read_mapping_page(mapping, 0, NULL);
+	if (IS_ERR(page))
+		return NULL;
+
+	if (!PageError(page))
+		res = kmemdup(page_address(page) + 0x1be, 66, GFP_KERNEL);
+	put_page(page);
 	return res;
 }
 EXPORT_SYMBOL(scsi_bios_ptable);
-- 
2.25.1
