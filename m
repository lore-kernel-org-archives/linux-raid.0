From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] xtensa/simdisk: remove the call to check_disk_change
Date: Wed,  8 Jul 2020 14:25:45 +0200
Message-ID: <20200708122546.214579-6-hch@lst.de>
References: <20200708122546.214579-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200708122546.214579-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

The simdisk driver doesn't support event notifications, which means
that check_disk_change is a no-op.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/xtensa/platforms/iss/simdisk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 5107140dbb7edc..3447556d276d32 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -127,8 +127,6 @@ static int simdisk_open(struct block_device *bdev, fmode_t mode)
 	struct simdisk *dev = bdev->bd_disk->private_data;
 
 	spin_lock(&dev->lock);
-	if (!dev->users)
-		check_disk_change(bdev);
 	++dev->users;
 	spin_unlock(&dev->lock);
 	return 0;
-- 
2.26.2
