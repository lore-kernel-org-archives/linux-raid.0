From: Wei Yongquan <weiyqlq@gmail.com>
Subject: [PATCH] Update CONFIG_MD_RAID6_PQ to CONFIG_RAID6_PQ in drivers/dma/iop-adma.c
Date: Wed, 29 Dec 2010 20:30:55 +0800
Message-ID: <AANLkTimdi-V1kNGwWdUQVmUEXXCrVZGwGS7nFJ=piwDc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Commit f5e70d0fe3ea990cfb3fc8d7f76a719adcb1e0b5 renamed MD_RAID6_PQ to RAID6_PQ,
but iop-adma.c didn't update synchronously.

Signed-off-by: Wei Yongquan <weiyqlq@gmail.com>
---
 drivers/dma/iop-adma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 161c452..c6b01f5 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1261,7 +1261,7 @@ out:
 	return err;
 }

-#ifdef CONFIG_MD_RAID6_PQ
+#ifdef CONFIG_RAID6_PQ
 static int __devinit
 iop_adma_pq_zero_sum_self_test(struct iop_adma_device *device)
 {
@@ -1584,7 +1584,7 @@ static int __devinit iop_adma_probe(struct
platform_device *pdev)

 	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask) &&
 	    dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask)) {
-		#ifdef CONFIG_MD_RAID6_PQ
+		#ifdef CONFIG_RAID6_PQ
 		ret = iop_adma_pq_zero_sum_self_test(adev);
 		dev_dbg(&pdev->dev, "pq self test returned %d\n", ret);
 		#else
-- 
1.7.0
