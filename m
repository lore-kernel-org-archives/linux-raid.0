From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/4] ioatdma: clean up sed pool kmem_cache
Date: Wed, 13 Nov 2013 12:12:31 -0800
Message-ID: <20131113201231.12667.17393.stgit@viggo.jf.intel.com>
References: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: dmaengine@vger.kernel.org
Cc: vinod.koul@intel.com, linux-raid@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

Use a single cache for all sed allocations.  No need to make it per
channel.  This also avoids the slub_debug warnings for multiple caches
with the same name.

Switching to dmam_pool_create() to fix leaking the dma pools on
initialization failure and lets us kill ioat3_dma_remove().

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.h    |    1 -
 drivers/dma/ioat/dma_v2.h |    1 -
 drivers/dma/ioat/dma_v3.c |   42 +++++++-----------------------------------
 drivers/dma/ioat/pci.c    |   20 +++++++++++++++-----
 4 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 4300d5af188f..df552d841481 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -83,7 +83,6 @@ struct ioatdma_device {
 	struct pci_pool *completion_pool;
 #define MAX_SED_POOLS	5
 	struct dma_pool *sed_hw_pool[MAX_SED_POOLS];
-	struct kmem_cache *sed_pool;
 	struct dma_device common;
 	u8 version;
 	struct msix_entry msix_entries[4];
diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index 212d584fe427..470292767e68 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -157,7 +157,6 @@ static inline void ioat2_set_chainaddr(struct ioat2_dma_chan *ioat, u64 addr)
 
 int ioat2_dma_probe(struct ioatdma_device *dev, int dca);
 int ioat3_dma_probe(struct ioatdma_device *dev, int dca);
-void ioat3_dma_remove(struct ioatdma_device *dev);
 struct dca_provider *ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase);
 struct dca_provider *ioat3_dca_init(struct pci_dev *pdev, void __iomem *iobase);
 int ioat2_check_space_lock(struct ioat2_dma_chan *ioat, int num_descs);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 0284908997f8..f8170de1d6a4 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -67,6 +67,8 @@
 #include "dma.h"
 #include "dma_v2.h"
 
+extern struct kmem_cache *ioat3_sed_cache;
+
 /* ioat hardware assumes at least two sources for raid operations */
 #define src_cnt_to_sw(x) ((x) + 2)
 #define src_cnt_to_hw(x) ((x) - 2)
@@ -252,7 +254,7 @@ ioat3_alloc_sed(struct ioatdma_device *device, unsigned int hw_pool)
 	struct ioat_sed_ent *sed;
 	gfp_t flags = __GFP_ZERO | GFP_ATOMIC;
 
-	sed = kmem_cache_alloc(device->sed_pool, flags);
+	sed = kmem_cache_alloc(ioat3_sed_cache, flags);
 	if (!sed)
 		return NULL;
 
@@ -260,7 +262,7 @@ ioat3_alloc_sed(struct ioatdma_device *device, unsigned int hw_pool)
 	sed->hw = dma_pool_alloc(device->sed_hw_pool[hw_pool],
 				 flags, &sed->dma);
 	if (!sed->hw) {
-		kmem_cache_free(device->sed_pool, sed);
+		kmem_cache_free(ioat3_sed_cache, sed);
 		return NULL;
 	}
 
@@ -273,7 +275,7 @@ static void ioat3_free_sed(struct ioatdma_device *device, struct ioat_sed_ent *s
 		return;
 
 	dma_pool_free(device->sed_hw_pool[sed->hw_pool], sed->hw, sed->dma);
-	kmem_cache_free(device->sed_pool, sed);
+	kmem_cache_free(ioat3_sed_cache, sed);
 }
 
 static bool desc_has_ext(struct ioat_ring_ent *desc)
@@ -1652,21 +1654,15 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		char pool_name[14];
 		int i;
 
-		/* allocate sw descriptor pool for SED */
-		device->sed_pool = kmem_cache_create("ioat_sed",
-				sizeof(struct ioat_sed_ent), 0, 0, NULL);
-		if (!device->sed_pool)
-			return -ENOMEM;
-
 		for (i = 0; i < MAX_SED_POOLS; i++) {
 			snprintf(pool_name, 14, "ioat_hw%d_sed", i);
 
 			/* allocate SED DMA pool */
-			device->sed_hw_pool[i] = dma_pool_create(pool_name,
+			device->sed_hw_pool[i] = dmam_pool_create(pool_name,
 					&pdev->dev,
 					SED_SIZE * (i + 1), 64, 0);
 			if (!device->sed_hw_pool[i])
-				goto sed_pool_cleanup;
+				return -ENOMEM;
 
 		}
 	}
@@ -1692,28 +1688,4 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		device->dca = ioat3_dca_init(pdev, device->reg_base);
 
 	return 0;
-
-sed_pool_cleanup:
-	if (device->sed_pool) {
-		int i;
-		kmem_cache_destroy(device->sed_pool);
-
-		for (i = 0; i < MAX_SED_POOLS; i++)
-			if (device->sed_hw_pool[i])
-				dma_pool_destroy(device->sed_hw_pool[i]);
-	}
-
-	return -ENOMEM;
-}
-
-void ioat3_dma_remove(struct ioatdma_device *device)
-{
-	if (device->sed_pool) {
-		int i;
-		kmem_cache_destroy(device->sed_pool);
-
-		for (i = 0; i < MAX_SED_POOLS; i++)
-			if (device->sed_hw_pool[i])
-				dma_pool_destroy(device->sed_hw_pool[i]);
-	}
 }
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 2c8d560e6334..1d051cd045db 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -123,6 +123,7 @@ module_param(ioat_dca_enabled, int, 0644);
 MODULE_PARM_DESC(ioat_dca_enabled, "control support of dca service (default: 1)");
 
 struct kmem_cache *ioat2_cache;
+struct kmem_cache *ioat3_sed_cache;
 
 #define DRV_NAME "ioatdma"
 
@@ -207,9 +208,6 @@ static void ioat_remove(struct pci_dev *pdev)
 	if (!device)
 		return;
 
-	if (device->version >= IOAT_VER_3_0)
-		ioat3_dma_remove(device);
-
 	dev_err(&pdev->dev, "Removing dma and dca services\n");
 	if (device->dca) {
 		unregister_dca_provider(device->dca, &pdev->dev);
@@ -221,7 +219,7 @@ static void ioat_remove(struct pci_dev *pdev)
 
 static int __init ioat_init_module(void)
 {
-	int err;
+	int err = -ENOMEM;
 
 	pr_info("%s: Intel(R) QuickData Technology Driver %s\n",
 		DRV_NAME, IOAT_DMA_VERSION);
@@ -231,9 +229,21 @@ static int __init ioat_init_module(void)
 	if (!ioat2_cache)
 		return -ENOMEM;
 
+	ioat3_sed_cache = KMEM_CACHE(ioat_sed_ent, 0);
+	if (!ioat3_sed_cache)
+		goto err_ioat2_cache;
+
 	err = pci_register_driver(&ioat_pci_driver);
 	if (err)
-		kmem_cache_destroy(ioat2_cache);
+		goto err_ioat3_cache;
+
+	return 0;
+
+ err_ioat3_cache:
+	kmem_cache_destroy(ioat3_sed_cache);
+
+ err_ioat2_cache:
+	kmem_cache_destroy(ioat2_cache);
 
 	return err;
 }

