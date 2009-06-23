From: Saeed Bishara <saeed@marvell.com>
Subject: [PATCH] mv_xor: add support for clkdev framework
Date: Tue, 23 Jun 2009 12:56:43 +0300
Message-ID: <1245751004-3056-1-git-send-email-saeed@marvell.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dan.j.williams@intel.com
Cc: buytenh@marvell.com, nico@marvell.com, saeed.bishara@gmail.com, Saeed Bishara <saeed@marvell.com>
List-Id: linux-raid.ids


Signed-off-by: Saeed Bishara <saeed@marvell.com>
---
 drivers/dma/mv_xor.c |   16 ++++++++++++++++
 drivers/dma/mv_xor.h |    4 ++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index ddab94f..db77903 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1325,6 +1325,14 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, msp);
 
+#if defined(CONFIG_HAVE_CLK)
+	msp->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(msp->clk))
+		dev_notice(&pdev->dev, "cannot get clkdev\n");
+	else
+		clk_enable(msp->clk);
+#endif
+
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
 	 */
@@ -1336,6 +1344,14 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 
 static int mv_xor_shared_remove(struct platform_device *pdev)
 {
+#if defined(CONFIG_HAVE_CLK)
+	struct mv_xor_shared_private *msp = platform_get_drvdata(pdev);
+
+	if (!IS_ERR(msp->clk)) {
+		clk_disable(msp->clk);
+		clk_put(msp->clk);
+	}
+#endif
 	return 0;
 }
 
diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index 06cafe1..08c3815 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
+#include <linux/clk.h>
 
 #define USE_TIMER
 #define MV_XOR_SLOT_SIZE		64
@@ -55,6 +56,9 @@
 struct mv_xor_shared_private {
 	void __iomem	*xor_base;
 	void __iomem	*xor_high_base;
+#if defined(CONFIG_HAVE_CLK)
+	struct clk		*clk;
+#endif
 };
 
 
-- 
1.6.0.4

