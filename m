From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 07/18] ioat3: split ioat3 support to its own file, add memset
Date: Thu, 03 Sep 2009 23:45:10 -0700
Message-ID: <20090904064510.7141.80671.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932821AbZIDGpz@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Up until this point the driver for Intel(R) QuickData Technology
engines, specification versions 2 and 3, were mostly identical save for
a few quirks.  Version 3.2 hardware adds many new capabilities (like
raid offload support) requiring some infrastructure that is not relevant
for v2.  For better code organization of the new funcionality move v3
and v3.2 support to its own file dma_v3.c, and export some routines from
the base files (dma.c and dma_v2.c) that can be reused directly.

The first new capability included in this code reorganization is support
for v3.2 memset operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/Makefile |    2 
 drivers/dma/ioat/dma.c    |   11 -
 drivers/dma/ioat/dma.h    |   16 ++
 drivers/dma/ioat/dma_v2.c |   94 +++---------
 drivers/dma/ioat/dma_v2.h |   14 ++
 drivers/dma/ioat/dma_v3.c |  367 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/ioat/pci.c    |    2 
 7 files changed, 422 insertions(+), 84 deletions(-)
 create mode 100644 drivers/dma/ioat/dma_v3.c

diff --git a/drivers/dma/ioat/Makefile b/drivers/dma/ioat/Makefile
index 205a639..8997d3f 100644
--- a/drivers/dma/ioat/Makefile
+++ b/drivers/dma/ioat/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
-ioatdma-objs := pci.o dma.o dma_v2.o dca.o
+ioatdma-objs := pci.o dma.o dma_v2.o dma_v3.o dca.o
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 21527b8..92c2778 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -539,17 +539,6 @@ static void ioat1_cleanup_tasklet(unsigned long data)
 	writew(IOAT_CHANCTRL_RUN, chan->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
-static void ioat_unmap(struct pci_dev *pdev, dma_addr_t addr, size_t len,
-		       int direction, enum dma_ctrl_flags flags, bool dst)
-{
-	if ((dst && (flags & DMA_COMPL_DEST_UNMAP_SINGLE)) ||
-	    (!dst && (flags & DMA_COMPL_SRC_UNMAP_SINGLE)))
-		pci_unmap_single(pdev, addr, len, direction);
-	else
-		pci_unmap_page(pdev, addr, len, direction);
-}
-
-
 void ioat_dma_unmap(struct ioat_chan_common *chan, enum dma_ctrl_flags flags,
 		    size_t len, struct ioat_dma_descriptor *hw)
 {
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 08e391a..5999c12 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -60,6 +60,10 @@
  * @dca: direct cache access context
  * @intr_quirk: interrupt setup quirk (for ioat_v1 devices)
  * @enumerate_channels: hw version specific channel enumeration
+ * @cleanup_tasklet: select between the v2 and v3 cleanup routines
+ * @timer_fn: select between the v2 and v3 timer watchdog routines
+ *
+ * Note: the v3 cleanup routine supports raid operations
  */
 
 struct ioatdma_device {
@@ -74,6 +78,8 @@ struct ioatdma_device {
 	struct dca_provider *dca;
 	void (*intr_quirk)(struct ioatdma_device *device);
 	int (*enumerate_channels)(struct ioatdma_device *device);
+	void (*cleanup_tasklet)(unsigned long data);
+	void (*timer_fn)(unsigned long data);
 };
 
 struct ioat_chan_common {
@@ -288,6 +294,16 @@ static inline bool is_ioat_bug(unsigned long err)
 			 IOAT_CHANERR_LENGTH_ERR));
 }
 
+static inline void ioat_unmap(struct pci_dev *pdev, dma_addr_t addr, size_t len,
+			      int direction, enum dma_ctrl_flags flags, bool dst)
+{
+	if ((dst && (flags & DMA_COMPL_DEST_UNMAP_SINGLE)) ||
+	    (!dst && (flags & DMA_COMPL_SRC_UNMAP_SINGLE)))
+		pci_unmap_single(pdev, addr, len, direction);
+	else
+		pci_unmap_page(pdev, addr, len, direction);
+}
+
 int __devinit ioat_probe(struct ioatdma_device *device);
 int __devinit ioat_register(struct ioatdma_device *device);
 int __devinit ioat1_dma_probe(struct ioatdma_device *dev, int dca);
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index b3a1f81..5a736a3 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -39,7 +39,7 @@
 #include "registers.h"
 #include "hw.h"
 
-static int ioat_ring_alloc_order = 8;
+int ioat_ring_alloc_order = 8;
 module_param(ioat_ring_alloc_order, int, 0644);
 MODULE_PARM_DESC(ioat_ring_alloc_order,
 		 "ioat2+: allocate 2^n descriptors per channel (default: n=8)");
@@ -63,7 +63,7 @@ static void __ioat2_issue_pending(struct ioat2_dma_chan *ioat)
 		__func__, ioat->head, ioat->tail, ioat->issued, ioat->dmacount);
 }
 
-static void ioat2_issue_pending(struct dma_chan *chan)
+void ioat2_issue_pending(struct dma_chan *chan)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(chan);
 
@@ -214,7 +214,7 @@ static void ioat2_cleanup_tasklet(unsigned long data)
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
-static void __restart_chan(struct ioat2_dma_chan *ioat)
+void __ioat2_restart_chan(struct ioat2_dma_chan *ioat)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 
@@ -255,11 +255,9 @@ static void ioat2_restart_channel(struct ioat2_dma_chan *ioat)
 	if (ioat_cleanup_preamble(chan, &phys_complete))
 		__cleanup(ioat, phys_complete);
 
-	__restart_chan(ioat);
+	__ioat2_restart_chan(ioat);
 }
 
-static bool reshape_ring(struct ioat2_dma_chan *ioat, int order);
-
 static void ioat2_timer_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = (void *) data;
@@ -321,7 +319,7 @@ static void ioat2_timer_event(unsigned long data)
  * ioat2_enumerate_channels - find and initialize the device's channels
  * @device: the device to be enumerated
  */
-static int ioat2_enumerate_channels(struct ioatdma_device *device)
+int ioat2_enumerate_channels(struct ioatdma_device *device)
 {
 	struct ioat2_dma_chan *ioat;
 	struct device *dev = &device->pdev->dev;
@@ -354,8 +352,8 @@ static int ioat2_enumerate_channels(struct ioatdma_device *device)
 			break;
 
 		ioat_init_channel(device, &ioat->base, i,
-				  ioat2_timer_event,
-				  ioat2_cleanup_tasklet,
+				  device->timer_fn,
+				  device->cleanup_tasklet,
 				  (unsigned long) ioat);
 		ioat->xfercap_log = xfercap_log;
 		spin_lock_init(&ioat->ring_lock);
@@ -461,7 +459,7 @@ static struct ioat_ring_ent **ioat2_alloc_ring(struct dma_chan *c, int order, gf
 /* ioat2_alloc_chan_resources - allocate/initialize ioat2 descriptor ring
  * @chan: channel to be initialized
  */
-static int ioat2_alloc_chan_resources(struct dma_chan *c)
+int ioat2_alloc_chan_resources(struct dma_chan *c)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
 	struct ioat_chan_common *chan = &ioat->base;
@@ -515,7 +513,7 @@ static int ioat2_alloc_chan_resources(struct dma_chan *c)
 	return 1 << ioat->alloc_order;
 }
 
-static bool reshape_ring(struct ioat2_dma_chan *ioat, int order)
+bool reshape_ring(struct ioat2_dma_chan *ioat, int order)
 {
 	/* reshape differs from normal ring allocation in that we want
 	 * to allocate a new software ring while only
@@ -628,7 +626,7 @@ static bool reshape_ring(struct ioat2_dma_chan *ioat, int order)
  * @ioat: ioat2,3 channel (ring) to operate on
  * @num_descs: allocation length
  */
-static int ioat2_alloc_and_lock(u16 *idx, struct ioat2_dma_chan *ioat, int num_descs)
+int ioat2_alloc_and_lock(u16 *idx, struct ioat2_dma_chan *ioat, int num_descs)
 {
 	struct ioat_chan_common *chan = &ioat->base;
 
@@ -656,9 +654,11 @@ static int ioat2_alloc_and_lock(u16 *idx, struct ioat2_dma_chan *ioat, int num_d
 		spin_lock_bh(&chan->cleanup_lock);
 		if (jiffies > chan->timer.expires &&
 		    timer_pending(&chan->timer)) {
+			struct ioatdma_device *device = chan->device;
+
 			mod_timer(&chan->timer, jiffies + COMPLETION_TIMEOUT);
 			spin_unlock_bh(&chan->cleanup_lock);
-			ioat2_timer_event((unsigned long) ioat);
+			device->timer_fn((unsigned long) ioat);
 		} else
 			spin_unlock_bh(&chan->cleanup_lock);
 		return -ENOMEM;
@@ -671,7 +671,7 @@ static int ioat2_alloc_and_lock(u16 *idx, struct ioat2_dma_chan *ioat, int num_d
 	return 0;  /* with ioat->ring_lock held */
 }
 
-static struct dma_async_tx_descriptor *
+struct dma_async_tx_descriptor *
 ioat2_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
 			   dma_addr_t dma_src, size_t len, unsigned long flags)
 {
@@ -723,11 +723,11 @@ ioat2_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
  * ioat2_free_chan_resources - release all the descriptors
  * @chan: the channel to be cleaned
  */
-static void ioat2_free_chan_resources(struct dma_chan *c)
+void ioat2_free_chan_resources(struct dma_chan *c)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
 	struct ioat_chan_common *chan = &ioat->base;
-	struct ioatdma_device *ioatdma_device = chan->device;
+	struct ioatdma_device *device = chan->device;
 	struct ioat_ring_ent *desc;
 	const u16 total_descs = 1 << ioat->alloc_order;
 	int descs;
@@ -741,7 +741,7 @@ static void ioat2_free_chan_resources(struct dma_chan *c)
 
 	tasklet_disable(&chan->cleanup_task);
 	del_timer_sync(&chan->timer);
-	ioat2_cleanup(ioat);
+	device->cleanup_tasklet((unsigned long) ioat);
 
 	/* Delay 100ms after reset to allow internal DMA logic to quiesce
 	 * before removing DMA descriptor resources.
@@ -771,8 +771,7 @@ static void ioat2_free_chan_resources(struct dma_chan *c)
 	kfree(ioat->ring);
 	ioat->ring = NULL;
 	ioat->alloc_order = 0;
-	pci_pool_free(ioatdma_device->completion_pool,
-		      chan->completion,
+	pci_pool_free(device->completion_pool, chan->completion,
 		      chan->completion_dma);
 	spin_unlock_bh(&ioat->ring_lock);
 
@@ -782,16 +781,17 @@ static void ioat2_free_chan_resources(struct dma_chan *c)
 	ioat->dmacount = 0;
 }
 
-static enum dma_status
+enum dma_status
 ioat2_is_complete(struct dma_chan *c, dma_cookie_t cookie,
 		     dma_cookie_t *done, dma_cookie_t *used)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+	struct ioatdma_device *device = ioat->base.device;
 
 	if (ioat_is_complete(c, cookie, done, used) == DMA_SUCCESS)
 		return DMA_SUCCESS;
 
-	ioat2_cleanup(ioat);
+	device->cleanup_tasklet((unsigned long) ioat);
 
 	return ioat_is_complete(c, cookie, done, used);
 }
@@ -805,6 +805,8 @@ int __devinit ioat2_dma_probe(struct ioatdma_device *device, int dca)
 	int err;
 
 	device->enumerate_channels = ioat2_enumerate_channels;
+	device->cleanup_tasklet = ioat2_cleanup_tasklet;
+	device->timer_fn = ioat2_timer_event;
 	dma = &device->common;
 	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
 	dma->device_issue_pending = ioat2_issue_pending;
@@ -831,53 +833,3 @@ int __devinit ioat2_dma_probe(struct ioatdma_device *device, int dca)
 
 	return err;
 }
-
-int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
-{
-	struct pci_dev *pdev = device->pdev;
-	struct dma_device *dma;
-	struct dma_chan *c;
-	struct ioat_chan_common *chan;
-	int err;
-	u16 dev_id;
-
-	device->enumerate_channels = ioat2_enumerate_channels;
-	dma = &device->common;
-	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
-	dma->device_issue_pending = ioat2_issue_pending;
-	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
-	dma->device_free_chan_resources = ioat2_free_chan_resources;
-	dma->device_is_tx_complete = ioat2_is_complete;
-
-	/* -= IOAT ver.3 workarounds =- */
-	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
-	 * that can cause stability issues for IOAT ver.3
-	 */
-	pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0x3e07);
-
-	/* Clear DMAUNCERRSTS Cfg-Reg Parity Error status bit
-	 * (workaround for spurious config parity error after restart)
-	 */
-	pci_read_config_word(pdev, IOAT_PCI_DEVICE_ID_OFFSET, &dev_id);
-	if (dev_id == PCI_DEVICE_ID_INTEL_IOAT_TBG0)
-		pci_write_config_dword(pdev, IOAT_PCI_DMAUNCERRSTS_OFFSET, 0x10);
-
-	err = ioat_probe(device);
-	if (err)
-		return err;
-	ioat_set_tcp_copy_break(262144);
-
-	list_for_each_entry(c, &dma->channels, device_node) {
-		chan = to_chan_common(c);
-		writel(IOAT_DMA_DCA_ANY_CPU,
-		       chan->reg_base + IOAT_DCACTRL_OFFSET);
-	}
-
-	err = ioat_register(device);
-	if (err)
-		return err;
-	if (dca)
-		device->dca = ioat3_dca_init(pdev, device->reg_base);
-
-	return err;
-}
diff --git a/drivers/dma/ioat/dma_v2.h b/drivers/dma/ioat/dma_v2.h
index 9011306..af69dd1 100644
--- a/drivers/dma/ioat/dma_v2.h
+++ b/drivers/dma/ioat/dma_v2.h
@@ -27,6 +27,7 @@
 
 
 extern int ioat_pending_level;
+extern int ioat_ring_alloc_order;
 
 /*
  * workaround for IOAT ver.3.0 null descriptor issue
@@ -168,4 +169,17 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *dev, int dca);
 struct dca_provider * __devinit ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase);
 struct dca_provider * __devinit ioat3_dca_init(struct pci_dev *pdev, void __iomem *iobase);
 extern struct kmem_cache *ioat2_cache;
+int ioat2_alloc_and_lock(u16 *idx, struct ioat2_dma_chan *ioat, int num_descs);
+int ioat2_enumerate_channels(struct ioatdma_device *device);
+struct dma_async_tx_descriptor *
+ioat2_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
+			   dma_addr_t dma_src, size_t len, unsigned long flags);
+void ioat2_issue_pending(struct dma_chan *chan);
+int ioat2_alloc_chan_resources(struct dma_chan *c);
+void ioat2_free_chan_resources(struct dma_chan *c);
+enum dma_status ioat2_is_complete(struct dma_chan *c, dma_cookie_t cookie,
+				  dma_cookie_t *done, dma_cookie_t *used);
+void __ioat2_restart_chan(struct ioat2_dma_chan *ioat);
+dma_cookie_t ioat2_inject_fence(struct ioat2_dma_chan *ioat);
+bool reshape_ring(struct ioat2_dma_chan *ioat, int order);
 #endif /* IOATDMA_V2_H */
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
new file mode 100644
index 0000000..b223d66
--- /dev/null
+++ b/drivers/dma/ioat/dma_v3.c
@@ -0,0 +1,367 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2004 - 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2004-2009 Intel Corporation. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/*
+ * Support routines for v3+ hardware
+ */
+
+#include <linux/pci.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include "registers.h"
+#include "hw.h"
+#include "dma.h"
+#include "dma_v2.h"
+
+static void ioat3_dma_unmap(struct ioat2_dma_chan *ioat,
+			    struct ioat_ring_ent *desc)
+{
+	struct ioat_chan_common *chan = &ioat->base;
+	struct pci_dev *pdev = chan->device->pdev;
+	size_t len = desc->len;
+	size_t offset = len - desc->hw->size;
+	struct dma_async_tx_descriptor *tx = &desc->txd;
+	enum dma_ctrl_flags flags = tx->flags;
+
+	switch (desc->hw->ctl_f.op) {
+	case IOAT_OP_COPY:
+		ioat_dma_unmap(chan, flags, len, desc->hw);
+		break;
+	case IOAT_OP_FILL: {
+		struct ioat_fill_descriptor *hw = desc->fill;
+
+		if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP))
+			ioat_unmap(pdev, hw->dst_addr - offset, len,
+				   PCI_DMA_FROMDEVICE, flags, 1);
+		break;
+	}
+	default:
+		dev_err(&pdev->dev, "%s: unknown op type: %#x\n",
+			__func__, desc->hw->ctl_f.op);
+	}
+}
+
+
+static void __cleanup(struct ioat2_dma_chan *ioat, unsigned long phys_complete)
+{
+	struct ioat_chan_common *chan = &ioat->base;
+	struct ioat_ring_ent *desc;
+	bool seen_current = false;
+	u16 active;
+	int i;
+
+	dev_dbg(to_dev(chan), "%s: head: %#x tail: %#x issued: %#x\n",
+		__func__, ioat->head, ioat->tail, ioat->issued);
+
+	active = ioat2_ring_active(ioat);
+	for (i = 0; i < active && !seen_current; i++) {
+		struct dma_async_tx_descriptor *tx;
+
+		prefetch(ioat2_get_ring_ent(ioat, ioat->tail + i + 1));
+		desc = ioat2_get_ring_ent(ioat, ioat->tail + i);
+		dump_desc_dbg(ioat, desc);
+		tx = &desc->txd;
+		if (tx->cookie) {
+			chan->completed_cookie = tx->cookie;
+			ioat3_dma_unmap(ioat, desc);
+			tx->cookie = 0;
+			if (tx->callback) {
+				tx->callback(tx->callback_param);
+				tx->callback = NULL;
+			}
+		}
+
+		if (tx->phys == phys_complete)
+			seen_current = true;
+	}
+	ioat->tail += i;
+	BUG_ON(!seen_current); /* no active descs have written a completion? */
+	chan->last_completion = phys_complete;
+	if (ioat->head == ioat->tail) {
+		dev_dbg(to_dev(chan), "%s: cancel completion timeout\n",
+			__func__);
+		clear_bit(IOAT_COMPLETION_PENDING, &chan->state);
+		mod_timer(&chan->timer, jiffies + IDLE_TIMEOUT);
+	}
+}
+
+static void ioat3_cleanup(struct ioat2_dma_chan *ioat)
+{
+	struct ioat_chan_common *chan = &ioat->base;
+	unsigned long phys_complete;
+
+	prefetch(chan->completion);
+
+	if (!spin_trylock_bh(&chan->cleanup_lock))
+		return;
+
+	if (!ioat_cleanup_preamble(chan, &phys_complete)) {
+		spin_unlock_bh(&chan->cleanup_lock);
+		return;
+	}
+
+	if (!spin_trylock_bh(&ioat->ring_lock)) {
+		spin_unlock_bh(&chan->cleanup_lock);
+		return;
+	}
+
+	__cleanup(ioat, phys_complete);
+
+	spin_unlock_bh(&ioat->ring_lock);
+	spin_unlock_bh(&chan->cleanup_lock);
+}
+
+static void ioat3_cleanup_tasklet(unsigned long data)
+{
+	struct ioat2_dma_chan *ioat = (void *) data;
+
+	ioat3_cleanup(ioat);
+	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
+}
+
+static void ioat3_restart_channel(struct ioat2_dma_chan *ioat)
+{
+	struct ioat_chan_common *chan = &ioat->base;
+	unsigned long phys_complete;
+	u32 status;
+
+	status = ioat_chansts(chan);
+	if (is_ioat_active(status) || is_ioat_idle(status))
+		ioat_suspend(chan);
+	while (is_ioat_active(status) || is_ioat_idle(status)) {
+		status = ioat_chansts(chan);
+		cpu_relax();
+	}
+
+	if (ioat_cleanup_preamble(chan, &phys_complete))
+		__cleanup(ioat, phys_complete);
+
+	__ioat2_restart_chan(ioat);
+}
+
+static void ioat3_timer_event(unsigned long data)
+{
+	struct ioat2_dma_chan *ioat = (void *) data;
+	struct ioat_chan_common *chan = &ioat->base;
+
+	spin_lock_bh(&chan->cleanup_lock);
+	if (test_bit(IOAT_COMPLETION_PENDING, &chan->state)) {
+		unsigned long phys_complete;
+		u64 status;
+
+		spin_lock_bh(&ioat->ring_lock);
+		status = ioat_chansts(chan);
+
+		/* when halted due to errors check for channel
+		 * programming errors before advancing the completion state
+		 */
+		if (is_ioat_halted(status)) {
+			u32 chanerr;
+
+			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+			BUG_ON(is_ioat_bug(chanerr));
+		}
+
+		/* if we haven't made progress and we have already
+		 * acknowledged a pending completion once, then be more
+		 * forceful with a restart
+		 */
+		if (ioat_cleanup_preamble(chan, &phys_complete))
+			__cleanup(ioat, phys_complete);
+		else if (test_bit(IOAT_COMPLETION_ACK, &chan->state))
+			ioat3_restart_channel(ioat);
+		else {
+			set_bit(IOAT_COMPLETION_ACK, &chan->state);
+			mod_timer(&chan->timer, jiffies + COMPLETION_TIMEOUT);
+		}
+		spin_unlock_bh(&ioat->ring_lock);
+	} else {
+		u16 active;
+
+		/* if the ring is idle, empty, and oversized try to step
+		 * down the size
+		 */
+		spin_lock_bh(&ioat->ring_lock);
+		active = ioat2_ring_active(ioat);
+		if (active == 0 && ioat->alloc_order > ioat_get_alloc_order())
+			reshape_ring(ioat, ioat->alloc_order-1);
+		spin_unlock_bh(&ioat->ring_lock);
+
+		/* keep shrinking until we get back to our minimum
+		 * default size
+		 */
+		if (ioat->alloc_order > ioat_get_alloc_order())
+			mod_timer(&chan->timer, jiffies + IDLE_TIMEOUT);
+	}
+	spin_unlock_bh(&chan->cleanup_lock);
+}
+
+static enum dma_status
+ioat3_is_complete(struct dma_chan *c, dma_cookie_t cookie,
+		  dma_cookie_t *done, dma_cookie_t *used)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+
+	if (ioat_is_complete(c, cookie, done, used) == DMA_SUCCESS)
+		return DMA_SUCCESS;
+
+	ioat3_cleanup(ioat);
+
+	return ioat_is_complete(c, cookie, done, used);
+}
+
+static struct dma_async_tx_descriptor *
+ioat3_prep_memset_lock(struct dma_chan *c, dma_addr_t dest, int value,
+		       size_t len, unsigned long flags)
+{
+	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
+	struct ioat_ring_ent *desc;
+	size_t total_len = len;
+	struct ioat_fill_descriptor *fill;
+	int num_descs;
+	u64 src_data = (0x0101010101010101ULL) * (value & 0xff);
+	u16 idx;
+	int i;
+
+	num_descs = ioat2_xferlen_to_descs(ioat, len);
+	if (likely(num_descs) &&
+	    ioat2_alloc_and_lock(&idx, ioat, num_descs) == 0)
+		/* pass */;
+	else
+		return NULL;
+	for (i = 0; i < num_descs; i++) {
+		size_t xfer_size = min_t(size_t, len, 1 << ioat->xfercap_log);
+
+		desc = ioat2_get_ring_ent(ioat, idx + i);
+		fill = desc->fill;
+
+		fill->size = xfer_size;
+		fill->src_data = src_data;
+		fill->dst_addr = dest;
+		fill->ctl = 0;
+		fill->ctl_f.op = IOAT_OP_FILL;
+
+		len -= xfer_size;
+		dest += xfer_size;
+		dump_desc_dbg(ioat, desc);
+	}
+
+	desc->txd.flags = flags;
+	desc->len = total_len;
+	fill->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
+	fill->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
+	fill->ctl_f.compl_write = 1;
+	dump_desc_dbg(ioat, desc);
+
+	/* we leave the channel locked to ensure in order submission */
+	return &desc->txd;
+}
+
+int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
+{
+	struct pci_dev *pdev = device->pdev;
+	struct dma_device *dma;
+	struct dma_chan *c;
+	struct ioat_chan_common *chan;
+	int err;
+	u16 dev_id;
+	u32 cap;
+
+	device->enumerate_channels = ioat2_enumerate_channels;
+	device->cleanup_tasklet = ioat3_cleanup_tasklet;
+	device->timer_fn = ioat3_timer_event;
+	dma = &device->common;
+	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
+	dma->device_issue_pending = ioat2_issue_pending;
+	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
+	dma->device_free_chan_resources = ioat2_free_chan_resources;
+	dma->device_is_tx_complete = ioat3_is_complete;
+	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
+	if (cap & IOAT_CAP_FILL_BLOCK) {
+		dma_cap_set(DMA_MEMSET, dma->cap_mask);
+		dma->device_prep_dma_memset = ioat3_prep_memset_lock;
+	}
+
+	/* -= IOAT ver.3 workarounds =- */
+	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
+	 * that can cause stability issues for IOAT ver.3
+	 */
+	pci_write_config_dword(pdev, IOAT_PCI_CHANERRMASK_INT_OFFSET, 0x3e07);
+
+	/* Clear DMAUNCERRSTS Cfg-Reg Parity Error status bit
+	 * (workaround for spurious config parity error after restart)
+	 */
+	pci_read_config_word(pdev, IOAT_PCI_DEVICE_ID_OFFSET, &dev_id);
+	if (dev_id == PCI_DEVICE_ID_INTEL_IOAT_TBG0)
+		pci_write_config_dword(pdev, IOAT_PCI_DMAUNCERRSTS_OFFSET, 0x10);
+
+	err = ioat_probe(device);
+	if (err)
+		return err;
+	ioat_set_tcp_copy_break(262144);
+
+	list_for_each_entry(c, &dma->channels, device_node) {
+		chan = to_chan_common(c);
+		writel(IOAT_DMA_DCA_ANY_CPU,
+		       chan->reg_base + IOAT_DCACTRL_OFFSET);
+	}
+
+	err = ioat_register(device);
+	if (err)
+		return err;
+	if (dca)
+		device->dca = ioat3_dca_init(pdev, device->reg_base);
+
+	return 0;
+}
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 61086c6..064bc95 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -36,7 +36,7 @@
 #include "hw.h"
 
 MODULE_VERSION(IOAT_DMA_VERSION);
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel Corporation");
 
 static struct pci_device_id ioat_pci_tbl[] = {
