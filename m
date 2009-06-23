From: Saeed Bishara <saeed@marvell.com>
Subject: [PATCH] mv_xor: add support for power management
Date: Tue, 23 Jun 2009 12:56:44 +0300
Message-ID: <1245751004-3056-2-git-send-email-saeed@marvell.com>
References: <1245751004-3056-1-git-send-email-saeed@marvell.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1245751004-3056-1-git-send-email-saeed@marvell.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dan.j.williams@intel.com
Cc: buytenh@marvell.com, nico@marvell.com, saeed.bishara@gmail.com, Saeed Bishara <saeed@marvell.com>
List-Id: linux-raid.ids


Signed-off-by: Saeed Bishara <saeed@marvell.com>
---
 drivers/dma/mv_xor.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index db77903..ecacd32 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1284,9 +1284,38 @@ mv_xor_conf_mbus_windows(struct mv_xor_shared_private *msp,
 	writel(win_enable, base + WINDOW_BAR_ENABLE(1));
 }
 
+#ifdef CONFIG_PM
+static int mv_xor_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	return 0;
+}
+
+static int mv_xor_resume(struct platform_device *pdev)
+{
+	struct mv_xor_device *device = platform_get_drvdata(pdev);
+	struct dma_chan *chan, *_chan;
+	struct mv_xor_chan *mv_chan;
+
+	list_for_each_entry_safe(chan, _chan, &device->common.channels,
+				device_node) {
+		mv_chan = to_mv_xor_chan(chan);
+		mv_chan_unmask_interrupts(mv_chan);
+
+		mv_set_mode(mv_chan, mv_chan->current_type);
+	}
+	return 0;
+}
+
+#else
+#define mv_xor_suspend NULL
+#define mv_xor_resume NULL
+#endif
+
 static struct platform_driver mv_xor_driver = {
 	.probe		= mv_xor_probe,
 	.remove		= __devexit_p(mv_xor_remove),
+	.suspend	= mv_xor_suspend,
+	.resume		= mv_xor_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= MV_XOR_NAME,
@@ -1355,9 +1384,36 @@ static int mv_xor_shared_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int mv_xor_shared_suspend(struct platform_device *pdev,
+				 pm_message_t state)
+{
+	return 0;
+}
+
+static int mv_xor_shared_resume(struct platform_device *pdev)
+{
+	struct mv_xor_platform_shared_data *msd = pdev->dev.platform_data;
+	struct mv_xor_shared_private *msp = platform_get_drvdata(pdev);
+	/*
+	 * (Re-)program MBUS remapping windows if we are asked to.
+	 */
+	if (msd != NULL && msd->dram != NULL)
+		mv_xor_conf_mbus_windows(msp, msd->dram);
+
+	return 0;
+}
+
+#else
+#define mv_xor_shared_suspend NULL
+#define mv_xor_shared_resume NULL
+#endif
+
 static struct platform_driver mv_xor_shared_driver = {
 	.probe		= mv_xor_shared_probe,
 	.remove		= mv_xor_shared_remove,
+	.suspend	= mv_xor_shared_suspend,
+	.resume		= mv_xor_shared_resume,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= MV_XOR_SHARED_NAME,
-- 
1.6.0.4

