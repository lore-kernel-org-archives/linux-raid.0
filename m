From: Saeed Bishara <saeed@marvell.com>
Subject: Re: [PATCH] mv_xor: add support for clkdev framework
Date: Tue, 23 Jun 2009 20:00:02 +0300 (IDT)
Message-ID: <alpine.DEB.2.00.0906231957570.31324@ubuntu-saeed.il.marvell.com>
References: <1245751004-3056-1-git-send-email-saeed@marvell.com> <4A4100B0.3070704@intel.com> <alpine.LFD.2.00.0906231241150.16467@xanadu.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0906231241150.16467@xanadu.home>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Pitre <nico@marvell.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Lennert Buijtenhek <buytenh@marvell.com>, "saeed.bishara@gmail.com" <saeed.bishara@gmail.com>
List-Id: linux-raid.ids


> >
> > Can you expand the changelog to explain why this patch is needed and
> > summarize what it does?  Also, releasing patches this late in the merge
Here is the patch with more explanation:
----------------------------------------<
From c999ed53a913979f1739854cb7c881a9dde980c6 Mon Sep 17 00:00:00 2001
From: Saeed Bishara <saeed@marvell.com>
Date: Tue, 12 May 2009 13:29:34 +0300
Subject: [PATCH 1/2 v2] mv_xor: add support for clkdev framework

When the clkdev framework is enabled, the device's clock is gated
by default, this patch uses the framework to enable the clock
when using the driver loaded and disables it when unloading the
driver.

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

