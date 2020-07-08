From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] mmc: remove the call to check_disk_change
Date: Wed,  8 Jul 2020 14:25:46 +0200
Message-ID: <20200708122546.214579-7-hch@lst.de>
References: <20200708122546.214579-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200708122546.214579-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

The mmc driver doesn't support event notifications, which means
that check_disk_change is a no-op.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mmc/core/block.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 4791c82f8f7c78..fa313b63413547 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -312,10 +312,7 @@ static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 
 	mutex_lock(&block_mutex);
 	if (md) {
-		if (md->usage == 2)
-			check_disk_change(bdev);
 		ret = 0;
-
 		if ((mode & FMODE_WRITE) && md->read_only) {
 			mmc_blk_put(md);
 			ret = -EROFS;
-- 
2.26.2
