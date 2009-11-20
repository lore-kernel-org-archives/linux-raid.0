From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/8] ioat3: dca and raid operations are incompatible
Date: Fri, 20 Nov 2009 00:06:24 -0700
Message-ID: <20091120070624.13478.24768.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756886AbZKTHIG@vger.kernel.org>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

RAID operations cause a system hang on platforms with DCA
(Direct-Cache-Access) enabled.  So turn off RAID capabilities in this
case.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dca.c    |    2 +-
 drivers/dma/ioat/dma_v3.c |    6 ++++++
 drivers/dma/ioat/hw.h     |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index 14f0a78..abd9038 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -103,7 +103,7 @@ static int dca_enabled_in_bios(struct pci_dev *pdev)
 	return res;
 }
 
-static int system_has_dca_enabled(struct pci_dev *pdev)
+int system_has_dca_enabled(struct pci_dev *pdev)
 {
 	if (boot_cpu_has(X86_FEATURE_DCA))
 		return dca_enabled_in_bios(pdev);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 35d1e33..4f305f6 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1117,6 +1117,7 @@ static int __devinit ioat3_dma_self_test(struct ioatdma_device *device)
 int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
+	int dca_en = system_has_dca_enabled(pdev);
 	struct dma_device *dma;
 	struct dma_chan *c;
 	struct ioat_chan_common *chan;
@@ -1137,6 +1138,11 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 
 	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
+
+	/* dca is incompatible with raid operations */
+	if (dca_en && (cap & (IOAT_CAP_XOR|IOAT_CAP_PQ)))
+		cap &= ~(IOAT_CAP_XOR|IOAT_CAP_PQ);
+
 	if (cap & IOAT_CAP_XOR) {
 		is_raid_device = true;
 		dma->max_xor = 8;
diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 99afb12..60e6754 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -39,6 +39,8 @@
 #define IOAT_VER_3_0            0x30    /* Version 3.0 */
 #define IOAT_VER_3_2            0x32    /* Version 3.2 */
 
+int system_has_dca_enabled(struct pci_dev *pdev);
+
 struct ioat_dma_descriptor {
 	uint32_t	size;
 	union {
