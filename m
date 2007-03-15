From: Wolfgang Denk <wd@denx.de>
Subject: [PATCH] [PPC32]  ADMA support for PPC 440SPe processors.
Date: Fri, 16 Mar 2007 00:29:56 +0100
Message-ID: <20070315232956.37DAB353A6C@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a driver for the XOR and DMA1,2 engines on the PPC 440SPe
processors. It includes support for using the engines asynchronously
to perform such operations as copy, xor calculations, xor_zero_check
operations and some other. The driver is adapted for use inside the
ADMA sub-system.

This patch is based on and requires a set of patches posted to the
linux-raid mailing list by Dan Williams on 2007-01-23:

[PATCH 2.6.20-rc5 01/12] dmaengine: add base support for the async_tx api
	http://marc.theaimsgroup.com/?l=linux-kernel&m=116957843221563&q=raw
[PATCH 02/12] dmaengine: add the async_tx api
	http://marc.theaimsgroup.com/?l=linux-raid&m=116952392528235&q=raw
[PATCH 03/12] md: add raid5_run_ops and support routines
	http://marc.theaimsgroup.com/?l=linux-kernel&m=116952392407474&q=raw
[PATCH 04/12] md: use raid5_run_ops for stripe cache operations
	http://marc.theaimsgroup.com/?l=linux-kernel&m=116952392416825&q=raw
[PATCH 05/12] md: move write operations to raid5_run_ops
	http://marc.theaimsgroup.com/?l=linux-raid&m=116952392615357&q=raw
[PATCH 06/12] md: move raid5 compute block operations to raid5_run_ops
	http://marc.theaimsgroup.com/?l=linux-raid&m=116952392509989&q=raw
[PATCH 07/12] md: move raid5 parity checks to raid5_run_ops
	http://marc.theaimsgroup.com/?l=linux-raid&m=116952306910263&q=raw
[PATCH 08/12] md: satisfy raid5 read requests via raid5_run_ops
	http://marc.theaimsgroup.com/?l=linux-kernel&m=116952392304938&q=raw
[PATCH 09/12] md: use async_tx and raid5_run_ops for raid5 expansion operations
	http://marc.theaimsgroup.com/?l=linux-raid&m=116952392405885&q=raw
[PATCH 10/12] md: move raid5 io requests to raid5_run_ops
	http://marc.theaimsgroup.com/?l=linux-raid&m=116952392409725&q=raw
[PATCH 11/12] md: remove raid5 compute_block and compute_parity5
	http://marc.theaimsgroup.com/?l=linux-kernel&m=116952392323697&q=raw
[PATCH 12/12] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
	http://marc.theaimsgroup.com/?l=linux-kernel&m=116952307012911&q=raw

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Wolfgang Denk <wd@denx.de>
---
 arch/ppc/platforms/4xx/ppc440spe.c |  209 +++++++
 arch/ppc/syslib/ppc440spe_pcie.h   |    2 +
 drivers/dma/Kconfig                |    7 +
 drivers/dma/Makefile               |    1 +
 drivers/dma/spe-adma.c             | 1071 ++++++++++++++++++++++++++++++++++++
 include/asm-ppc/adma.h             |  715 ++++++++++++++++++++++++
 include/asm-ppc/ppc440spe_dma.h    |  214 +++++++
 include/asm-ppc/ppc440spe_xor.h    |  131 +++++
 8 files changed, 2350 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/spe-adma.c
 create mode 100644 include/asm-ppc/adma.h
 create mode 100644 include/asm-ppc/ppc440spe_dma.h
 create mode 100644 include/asm-ppc/ppc440spe_xor.h

diff --git a/arch/ppc/platforms/4xx/ppc440spe.c b/arch/ppc/platforms/4xx/ppc440spe.c
index 1be5d1c..6bdfb47 100644
--- a/arch/ppc/platforms/4xx/ppc440spe.c
+++ b/arch/ppc/platforms/4xx/ppc440spe.c
@@ -22,6 +22,13 @@
 #include <asm/ocp.h>
 #include <asm/ppc4xx_pic.h>
 
+#if defined(CONFIG_AMCC_SPE_ADMA)
+#include <syslib/ppc440spe_pcie.h>
+#include <linux/async_tx.h>
+#include <linux/platform_device.h>
+#include <asm/adma.h>
+#endif
+
 static struct ocp_func_emac_data ppc440spe_emac0_def = {
 	.rgmii_idx	= -1,		/* No RGMII */
 	.rgmii_mux	= -1,		/* No RGMII */
@@ -144,3 +151,205 @@ struct ppc4xx_uic_settings ppc4xx_core_uic_cfg[] __initdata = {
 	  .ext_irq_mask = 0x00000000,
 	},
 };
+
+#if defined(CONFIG_AMCC_SPE_ADMA)
+
+static u64 ppc440spe_adma_dmamask = DMA_32BIT_MASK;
+
+/* DMA and XOR platform devices' resources */
+static struct resource ppc440spe_dma_0_resources[] = {
+	{
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = DMA0_CS_FIFO_NEED_SERVICE,
+		.end = DMA0_CS_FIFO_NEED_SERVICE,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static struct resource ppc440spe_dma_1_resources[] = {
+	{
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = DMA1_CS_FIFO_NEED_SERVICE,
+		.end = DMA1_CS_FIFO_NEED_SERVICE,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static struct resource ppc440spe_xor_resources[] = {
+	{
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = XOR_INTERRUPT,
+		.end = XOR_INTERRUPT,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+/* DMA and XOR platform devices' data */
+static struct spe_adma_platform_data ppc440spe_dma_0_data = {
+	.hw_id  = PPC440SPE_DMA0_ID,
+	.capabilities = DMA_CAP_MEMCPY | DMA_CAP_INTERRUPT,
+	.pool_size = PAGE_SIZE,
+};
+
+static struct spe_adma_platform_data ppc440spe_dma_1_data = {
+	.hw_id  = PPC440SPE_DMA1_ID,
+	.capabilities =  DMA_CAP_MEMCPY | DMA_CAP_INTERRUPT,
+	.pool_size = PAGE_SIZE,
+};
+
+static struct spe_adma_platform_data ppc440spe_xor_data = {
+	.hw_id  = PPC440SPE_XOR_ID,
+	.capabilities = DMA_CAP_XOR | DMA_CAP_INTERRUPT,
+	.pool_size = PAGE_SIZE,
+};
+
+/* DMA and XOR platform devices definitions */
+static struct platform_device ppc440spe_dma_0_channel = {
+	.name = "SPE-ADMA",
+	.id = PPC440SPE_DMA0_ID,
+	.num_resources = ARRAY_SIZE(ppc440spe_dma_0_resources),
+	.resource = ppc440spe_dma_0_resources,
+	.dev = {
+		.dma_mask = &ppc440spe_adma_dmamask,
+		.coherent_dma_mask = DMA_64BIT_MASK,
+		.platform_data = (void *) &ppc440spe_dma_0_data,
+	},
+};
+
+static struct platform_device ppc440spe_dma_1_channel = {
+	.name = "SPE-ADMA",
+	.id = PPC440SPE_DMA1_ID,
+	.num_resources = ARRAY_SIZE(ppc440spe_dma_1_resources),
+	.resource = ppc440spe_dma_1_resources,
+	.dev = {
+		.dma_mask = &ppc440spe_adma_dmamask,
+		.coherent_dma_mask = DMA_64BIT_MASK,
+		.platform_data = (void *) &ppc440spe_dma_1_data,
+	},
+};
+
+static struct platform_device ppc440spe_xor_channel = {
+	.name = "SPE-ADMA",
+	.id = PPC440SPE_XOR_ID,
+	.num_resources = ARRAY_SIZE(ppc440spe_xor_resources),
+	.resource = ppc440spe_xor_resources,
+	.dev = {
+		.dma_mask = &ppc440spe_adma_dmamask,
+		.coherent_dma_mask = DMA_64BIT_MASK,
+		.platform_data = (void *) &ppc440spe_xor_data,
+	},
+};
+
+/*
+ *  Init DMA0/1 and XOR engines; allocate memory for DMAx FIFOs; set platform_device
+ * memory resources addresses
+ */
+static void ppc440spe_configure_raid_devices(void)
+{
+	void *fifo_buf;
+	i2o_regs_t *i2o_reg;
+	dma_regs_t *dma_reg0, *dma_reg1;
+	xor_regs_t *xor_reg;
+	u32 mask;
+
+	printk ("%s\n", __FUNCTION__);
+
+	/*
+	 * Map registers
+	 */
+	i2o_reg  = (i2o_regs_t *)ioremap64(I2O_MMAP_BASE, I2O_MMAP_SIZE);
+	dma_reg0 = (dma_regs_t *)ioremap64(DMA0_MMAP_BASE, DMA_MMAP_SIZE);
+	dma_reg1 = (dma_regs_t *)ioremap64(DMA1_MMAP_BASE, DMA_MMAP_SIZE);
+	xor_reg  = (xor_regs_t *)ioremap64(XOR_MMAP_BASE,XOR_MMAP_SIZE);
+
+	/*
+	 * Configure h/w
+	 */
+
+	/* Reset I2O/DMA */
+	mtdcr(DCRN_SDR0_CFGADDR, 0x200);
+	mtdcr(DCRN_SDR0_CFGDATA, 0x10000);
+	mtdcr(DCRN_SDR0_CFGADDR, 0x200);
+	mtdcr(DCRN_SDR0_CFGDATA, 0x0);
+
+	/* Reset XOR */
+	out_be32(&xor_reg->crsr, XOR_CRSR_XASR_BIT);
+	out_be32(&xor_reg->crrr, XOR_CRSR_64BA_BIT);
+
+	/* Setup the base address of mmaped registers */
+	mtdcr(DCRN_I2O0_IBAH, 0x00000004);
+	mtdcr(DCRN_I2O0_IBAL, 0x00100001);
+
+	/*  Provide memory regions for DMA's FIFOs: I2O, DMA0 and DMA1 share
+	 * the base address of FIFO memory space
+	 */
+	fifo_buf = kmalloc((DMA0_FIFO_SIZE + DMA1_FIFO_SIZE)<<1, GFP_KERNEL | __GFP_DMA);
+
+	/* SetUp FIFO memory space base address */
+	out_le32(&i2o_reg->ifbah, 0);
+	out_le32(&i2o_reg->ifbal, ((u32)__pa(fifo_buf)));
+
+	/* zero FIFO size for I2O, DMAs; 0x1000 to enable DMA */
+	out_le32(&i2o_reg->ifsiz, 0);
+	out_le32(&dma_reg0->fsiz, 0x1000 | ((DMA0_FIFO_SIZE>>3) - 1));
+	out_le32(&dma_reg1->fsiz, 0x1000 | ((DMA1_FIFO_SIZE>>3) - 1));
+
+	/* Configure DMA engine */
+	out_le32(&dma_reg0->cfg, 0x0D880000);
+	out_le32(&dma_reg1->cfg, 0x0D880000);
+
+	/* Clear Status */
+	out_le32(&dma_reg0->dsts, ~0);
+	out_le32(&dma_reg1->dsts, ~0);
+
+	/* Unmask 'CS FIFO Attention' interrupts */
+	mask = in_le32(&i2o_reg->iopim) & ~0x48;
+	out_le32(&i2o_reg->iopim, mask);
+
+	/* enable XOR engine interrupt */
+	out_be32(&xor_reg->ier, XOR_IE_CBLCI_BIT | XOR_IE_CBCIE_BIT | 0x34000);
+
+	/*
+	 * Unmap I2O registers
+	 */
+	iounmap(i2o_reg);
+
+	/*
+	 * Set resource addresses
+	 */
+	ppc440spe_dma_0_channel.resource[0].start = (resource_size_t)(dma_reg0);
+	ppc440spe_dma_0_channel.resource[0].end =
+		ppc440spe_dma_0_channel.resource[0].start+DMA_MMAP_SIZE;
+
+	ppc440spe_dma_1_channel.resource[0].start = (resource_size_t)(dma_reg1);
+	ppc440spe_dma_1_channel.resource[0].end =
+		ppc440spe_dma_1_channel.resource[0].start+DMA_MMAP_SIZE;
+
+	ppc440spe_xor_channel.resource[0].start = (resource_size_t)(xor_reg);
+	ppc440spe_xor_channel.resource[0].end =
+		ppc440spe_xor_channel.resource[0].start+XOR_MMAP_SIZE;
+}
+
+static struct platform_device *ppc440spe_devs[] __initdata = {
+	&ppc440spe_dma_0_channel,
+	&ppc440spe_dma_1_channel,
+	&ppc440spe_xor_channel,
+};
+
+static int __init ppc440spe_register_raid_devices(void)
+{
+	ppc440spe_configure_raid_devices();
+	platform_add_devices(ppc440spe_devs, ARRAY_SIZE(ppc440spe_devs));
+
+	return 0;
+}
+
+arch_initcall(ppc440spe_register_raid_devices);
+#endif	/* CONFIG_AMCC_SPE_ADMA */
+
diff --git a/arch/ppc/syslib/ppc440spe_pcie.h b/arch/ppc/syslib/ppc440spe_pcie.h
index 902ef23..e7099a3 100644
--- a/arch/ppc/syslib/ppc440spe_pcie.h
+++ b/arch/ppc/syslib/ppc440spe_pcie.h
@@ -13,6 +13,8 @@
 
 #define DCRN_SDR0_CFGADDR	0x00e
 #define DCRN_SDR0_CFGDATA	0x00f
+#define DCRN_I2O0_IBAL		0x066
+#define DCRN_I2O0_IBAH		0x067
 
 #define DCRN_PCIE0_BASE		0x100
 #define DCRN_PCIE1_BASE		0x120
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index d61e3e5..46a6e69 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -49,4 +49,11 @@ config INTEL_IOP_ADMA
         ---help---
           Enable support for the Intel(R) IOP Series RAID engines.
 
+config AMCC_SPE_ADMA
+	tristate "AMCC SPE ADMA support"
+	depends on DMA_ENGINE && 440SPE
+	default y
+	---help---
+	  Enable support for the AMCC 440SPe RAID engines.
+
 endmenu
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 8ebf10d..8568e31 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
 obj-$(CONFIG_ASYNC_TX_DMA) += async_tx.o xor.o
+obj-$(CONFIG_AMCC_SPE_ADMA) += spe-adma.o
diff --git a/drivers/dma/spe-adma.c b/drivers/dma/spe-adma.c
new file mode 100644
index 0000000..5b1ada0
--- /dev/null
+++ b/drivers/dma/spe-adma.c
@@ -0,0 +1,1071 @@
+/*
+ * Copyright(c) 2006 DENX Engineering. All rights reserved.
+ *
+ * Author: Yuri Tikhonov <yur@emcraft.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called COPYING.
+ */
+
+/*
+ *  This driver supports the asynchrounous DMA copy and RAID engines available
+ * on the AMCC PPC440SPe Processors.
+ *  Based on the Intel Xscale(R) family of I/O Processors (SPE 32x, 33x, 134x)
+ * ADMA driver.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/async_tx.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <asm/adma.h>
+
+#define to_spe_adma_chan(chan) container_of(chan, struct spe_adma_chan, common)
+#define to_spe_adma_device(dev) container_of(dev, struct spe_adma_device, common)
+#define to_spe_adma_slot(lh) container_of(lh, struct spe_adma_desc_slot, slot_node)
+#define tx_to_spe_adma_slot(tx) container_of(tx, struct spe_adma_desc_slot, async_tx)
+
+#define SPE_ADMA_MAX_BYTE_COUNT		0xFFFFFF
+
+#define SPE_ADMA_DEBUG 0
+#define PRINTK(x...) ((void)(SPE_ADMA_DEBUG && printk(x)))
+
+/**
+ * spe_adma_free_slots - flags descriptor slots for reuse
+ * @slot: Slot to free
+ * Caller must hold &spe_chan->lock while calling this function
+ */
+static inline void spe_adma_free_slots(struct spe_adma_desc_slot *slot)
+{
+	int stride = slot->stride;
+
+	while (stride--) {
+		slot->stride = 0;
+		slot = list_entry(slot->slot_node.next,
+				struct spe_adma_desc_slot,
+				slot_node);
+	}
+}
+
+static inline dma_cookie_t
+spe_adma_run_tx_complete_actions(struct spe_adma_desc_slot *desc,
+	struct spe_adma_chan *spe_chan, dma_cookie_t cookie)
+{
+
+	BUG_ON(desc->async_tx.cookie < 0);
+
+	if (desc->async_tx.cookie > 0) {
+		cookie = desc->async_tx.cookie;
+		desc->async_tx.cookie = 0; 
+
+		/* call the callback (must not sleep or submit new
+		 * operations to this channel)
+		 */
+		if (desc->async_tx.callback)
+			desc->async_tx.callback(
+				desc->async_tx.callback_param);
+
+		/* unmap dma addresses
+		 * (unmap_single vs unmap_page?)
+		 */
+		if (desc->group_head && desc->async_tx.type != DMA_INTERRUPT) {
+			struct spe_adma_desc_slot *unmap = desc->group_head;
+			u32 src_cnt = unmap->unmap_src_cnt;
+			dma_addr_t addr = spe_desc_get_dest_addr(unmap,
+				spe_chan);
+
+			dma_unmap_page(&spe_chan->device->pdev->dev, addr, 
+					unmap->unmap_len, DMA_FROM_DEVICE);
+			while(src_cnt--) {
+				addr = spe_desc_get_src_addr(unmap,
+							spe_chan,
+							src_cnt);
+				dma_unmap_page(&spe_chan->device->pdev->dev, addr, 
+					unmap->unmap_len, DMA_TO_DEVICE);
+			}
+			desc->group_head = NULL;
+		}
+	}
+
+	/* run dependent operations */
+	async_tx_run_dependencies(&desc->async_tx, &spe_chan->common);
+
+	return cookie;
+}
+
+static inline int
+spe_adma_clean_slot(struct spe_adma_desc_slot *desc,
+	struct spe_adma_chan *spe_chan)
+{
+	/* the client is allowed to attach dependent operations
+	 * until 'ack' is set
+	 */
+	if (!desc->async_tx.ack)
+		return 0;
+
+	/* leave the last descriptor in the chain
+	 * so we can append to it
+	 */
+	if (desc->chain_node.next == &spe_chan->chain || 
+			desc->phys == spe_chan_get_current_descriptor(spe_chan))
+		return 1;
+
+	PRINTK("\tfree slot %x: %d stride: %d\n", desc->phys, desc->idx, desc->stride);
+
+	list_del(&desc->chain_node);
+
+	spe_adma_free_slots(desc);
+
+	return 0;
+}
+
+int spe_check_stride (struct dma_async_tx_descriptor *tx)
+{
+	struct spe_adma_desc_slot *p = tx_to_spe_adma_slot(tx);
+
+	return p->stride;
+}
+
+static void __spe_adma_slot_cleanup(struct spe_adma_chan *spe_chan)
+{
+	struct spe_adma_desc_slot *iter, *_iter, *group_start = NULL;
+	dma_cookie_t cookie = 0;
+	u32 current_desc = spe_chan_get_current_descriptor(spe_chan);
+	int busy = spe_chan_is_busy(spe_chan);
+	int seen_current = 0, slot_cnt = 0, slots_per_op = 0;
+
+	PRINTK ("spe adma%d: %s\n", spe_chan->device->id, __FUNCTION__);
+
+	/* free completed slots from the chain starting with
+	 * the oldest descriptor
+	 */
+	list_for_each_entry_safe(iter, _iter, &spe_chan->chain,
+					chain_node) {
+		PRINTK ("\tcookie: %d slot: %d busy: %d "
+			"this_desc: %#x next_desc: %#x cur: %#x ack: %d\n",
+			iter->async_tx.cookie, iter->idx, busy, iter->phys,
+			spe_desc_get_next_desc(iter, spe_chan),
+			current_desc,
+			iter->async_tx.ack);
+
+		/* do not advance past the current descriptor loaded into the
+		 * hardware channel, subsequent descriptors are either in process
+		 * or have not been submitted
+		 */
+		if (seen_current)
+			break;
+
+		/* stop the search if we reach the current descriptor and the
+		 * channel is busy, or if it appears that the current descriptor
+		 * needs to be re-read (i.e. has been appended to)
+		 */
+		if (iter->phys == current_desc) {
+			BUG_ON(seen_current++);
+			if (busy || spe_desc_get_next_desc(iter, spe_chan)) {
+				spe_adma_run_tx_complete_actions(iter, spe_chan, cookie);
+				break;
+			}
+		}
+
+		/* detect the start of a group transaction */
+		if (!slot_cnt && !slots_per_op) {
+			slot_cnt = iter->slot_cnt;
+			slots_per_op = iter->slots_per_op;
+			if (slot_cnt <= slots_per_op) {
+				slot_cnt = 0;
+				slots_per_op = 0;
+			}
+		}
+
+		if (slot_cnt) {
+			PRINTK("\tgroup++\n");
+			if (!group_start)
+				group_start = iter;
+			slot_cnt -= slots_per_op;
+		}
+
+		/* all the members of a group are complete */
+		if (slots_per_op != 0 && slot_cnt == 0) {
+			struct spe_adma_desc_slot *grp_iter, *_grp_iter;
+			int end_of_chain = 0;
+			PRINTK("\tgroup end\n");
+
+			/* collect the total results */
+			if (group_start->xor_check_result) {
+				u32 zero_sum_result = 0;
+				slot_cnt = group_start->slot_cnt;
+				grp_iter = group_start;
+
+				list_for_each_entry_from(grp_iter,
+					&spe_chan->chain, chain_node) {
+					PRINTK("\titer%d result: %d\n", grp_iter->idx,
+						zero_sum_result);
+					slot_cnt -= slots_per_op;
+					if (slot_cnt == 0)
+						break;
+				}
+				PRINTK("\tgroup_start->xor_check_result: %p\n",
+					group_start->xor_check_result);
+				*group_start->xor_check_result = zero_sum_result;
+			}
+
+			/* clean up the group */
+			slot_cnt = group_start->slot_cnt;
+			grp_iter = group_start;
+			list_for_each_entry_safe_from(grp_iter, _grp_iter,
+				&spe_chan->chain, chain_node) {
+
+				cookie = spe_adma_run_tx_complete_actions(
+					grp_iter, spe_chan, cookie);
+
+				slot_cnt -= slots_per_op;
+				end_of_chain = spe_adma_clean_slot(grp_iter,
+					spe_chan);
+
+				if (slot_cnt == 0 || end_of_chain)
+					break;
+			}
+
+			/* the group should be complete at this point */
+			BUG_ON(slot_cnt);
+
+			slots_per_op = 0;
+			group_start = NULL;
+			if (end_of_chain)
+				break;
+			else
+				continue;
+		} else if (slots_per_op) /* wait for group completion */
+			continue;
+
+		cookie = spe_adma_run_tx_complete_actions(iter, spe_chan, cookie);
+
+		if (spe_adma_clean_slot(iter, spe_chan))
+			break;
+	}
+
+	if (!seen_current) {
+		BUG();
+	}
+
+	if (cookie > 0) {
+		spe_chan->completed_cookie = cookie;
+		PRINTK("\tcompleted cookie %d\n", cookie);
+	}
+}
+
+static inline void
+spe_adma_slot_cleanup(struct spe_adma_chan *spe_chan)
+{
+	spin_lock_bh(&spe_chan->lock);
+	__spe_adma_slot_cleanup(spe_chan);
+	spin_unlock_bh(&spe_chan->lock);
+}
+
+static struct spe_adma_chan *spe_adma_chan_array[3];
+static void spe_adma0_task(unsigned long data)
+{
+	__spe_adma_slot_cleanup(spe_adma_chan_array[0]);
+}
+
+static void spe_adma1_task(unsigned long data)
+{
+	__spe_adma_slot_cleanup(spe_adma_chan_array[1]);
+}
+
+static void spe_adma2_task(unsigned long data)
+{
+	__spe_adma_slot_cleanup(spe_adma_chan_array[2]);
+}
+
+DECLARE_TASKLET(spe_adma0_tasklet, spe_adma0_task, 0);
+DECLARE_TASKLET(spe_adma1_tasklet, spe_adma1_task, 0);
+DECLARE_TASKLET(spe_adma2_tasklet, spe_adma2_task, 0);
+struct tasklet_struct *spe_adma_tasklet[] = {
+	&spe_adma0_tasklet,
+	&spe_adma1_tasklet,
+	&spe_adma2_tasklet,
+};
+
+static struct spe_adma_desc_slot *
+__spe_adma_alloc_slots(struct spe_adma_chan *spe_chan, int num_slots,
+			int slots_per_op, int recurse)
+{
+	struct spe_adma_desc_slot *iter = NULL, *alloc_start = NULL;
+	struct spe_adma_desc_slot *last_used = NULL, *last_op_head = NULL;
+	struct list_head chain = LIST_HEAD_INIT(chain);
+	int i;
+
+	/* start search from the last allocated descrtiptor
+	 * if a contiguous allocation can not be found start searching
+	 * from the beginning of the list
+	 */
+
+	for (i = 0; i < 2; i++) {
+		int slots_found = 0;
+		if (i == 0)
+			iter = spe_chan->last_used;
+		else {
+			iter = list_entry(&spe_chan->all_slots,
+				struct spe_adma_desc_slot,
+				slot_node);
+		}
+
+		list_for_each_entry_continue(iter, &spe_chan->all_slots, slot_node) {
+			if (iter->stride) {
+				/* give up after finding the first busy slot
+				 * on the second pass through the list
+				 */
+				if (i == 1)
+					break;
+
+				slots_found = 0;
+				continue;
+			}
+
+			/* start the allocation if the slot is correctly aligned */
+			if (!slots_found++) {
+				if (spe_desc_is_aligned(iter, slots_per_op))
+					alloc_start = iter;
+				else {
+					slots_found = 0;
+					continue;
+				}
+			}
+
+			if (slots_found == num_slots) {
+				iter = alloc_start;
+				i = 0;
+				while (num_slots) {
+
+					/* pre-ack all but the last descriptor */
+					if (num_slots != slots_per_op)
+						iter->async_tx.ack = 1;
+					else
+						iter->async_tx.ack = 0;
+
+                                        PRINTK ("spe adma%d: allocated slot: %d "
+                                                "(desc %p phys: %#x) stride %d"
+						",ack = %d\n",
+                                                spe_chan->device->id,
+                                                iter->idx, iter->hw_desc, iter->phys,
+                                                slots_per_op, iter->async_tx.ack);
+
+					list_add_tail(&iter->chain_node, &chain);
+					last_op_head = iter;
+					iter->async_tx.cookie = 0;
+					iter->hw_next = NULL;
+					iter->flags = 0;
+					iter->slot_cnt = num_slots;
+					iter->slots_per_op = slots_per_op;
+					iter->xor_check_result = NULL;
+					for (i = 0; i < slots_per_op; i++) {
+						iter->stride = slots_per_op - i;
+						last_used = iter;
+						iter = list_entry(iter->slot_node.next,
+								struct spe_adma_desc_slot,
+								slot_node);
+					}
+					num_slots -= slots_per_op;
+				}
+				last_op_head->group_head = alloc_start;
+				last_op_head->async_tx.cookie = -EBUSY;
+				list_splice(&chain, &last_op_head->group_list);
+				spe_chan->last_used = last_used;
+				return last_op_head;
+			}
+		}
+	}
+
+	/* try to free some slots if the allocation fails */
+	tasklet_schedule(spe_adma_tasklet[spe_chan->device->id]);
+	return NULL;
+}
+
+static struct spe_adma_desc_slot *
+spe_adma_alloc_slots(struct spe_adma_chan *spe_chan,
+			int num_slots,
+			int slots_per_op)
+{
+	return __spe_adma_alloc_slots(spe_chan, num_slots, slots_per_op, 1);
+}
+
+static void spe_chan_start_null_xor(struct spe_adma_chan *spe_chan);
+
+/* returns the actual number of allocated descriptors */
+static int spe_adma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	struct spe_adma_desc_slot *slot = NULL;
+	char *hw_desc;
+	int i, db_sz;
+	int init = spe_chan->slots_allocated ? 0 : 1;
+	struct spe_adma_platform_data *plat_data;
+
+	chan->chan_id = spe_chan->device->id;
+	plat_data = spe_chan->device->pdev->dev.platform_data;
+
+	spin_lock_bh(&spe_chan->lock);
+	/* Allocate descriptor slots */
+	i = spe_chan->slots_allocated;
+	if (spe_chan->device->id != PPC440SPE_XOR_ID)
+		db_sz = sizeof (dma_cdb_t);
+	else
+		db_sz = sizeof (xor_cb_t);
+
+	for (; i < (plat_data->pool_size/db_sz); i++) {
+		slot = kzalloc(sizeof(struct spe_adma_desc_slot), GFP_KERNEL);
+		if (!slot) {
+			printk(KERN_INFO "SPE ADMA Channel only initialized"
+				" %d descriptor slots", i--);
+			break;
+		}
+
+		hw_desc = (char *) spe_chan->device->dma_desc_pool_virt;
+		slot->hw_desc = (void *) &hw_desc[i * db_sz];
+		dma_async_tx_descriptor_init(&slot->async_tx, chan);
+		INIT_LIST_HEAD(&slot->chain_node);
+		INIT_LIST_HEAD(&slot->slot_node);
+		INIT_LIST_HEAD(&slot->group_list);
+		hw_desc = (char *) spe_chan->device->dma_desc_pool;
+		slot->phys = (dma_addr_t) &hw_desc[i * db_sz];
+		slot->idx = i;
+		list_add_tail(&slot->slot_node, &spe_chan->all_slots);
+	}
+
+	if (i && !spe_chan->last_used)
+		spe_chan->last_used = list_entry(spe_chan->all_slots.next,
+					struct spe_adma_desc_slot,
+					slot_node);
+
+	spe_chan->slots_allocated = i;
+	PRINTK("spe adma%d: allocated %d descriptor slots last_used: %p\n",
+		spe_chan->device->id, i, spe_chan->last_used);
+	spin_unlock_bh(&spe_chan->lock);
+
+	/* initialize the channel and the chain with a null operation */
+	if (init) {
+		if (test_bit(DMA_XOR,
+			&spe_chan->device->common.capabilities))
+			spe_chan_start_null_xor(spe_chan);
+	}
+
+	return (i > 0) ? i : -ENOMEM;
+}
+
+static inline dma_cookie_t
+spe_desc_assign_cookie(struct spe_adma_chan *spe_chan,
+	struct spe_adma_desc_slot *desc)
+{
+	dma_cookie_t cookie = spe_chan->common.cookie;
+	cookie++;
+	if (cookie < 0)
+		cookie = 1;
+	spe_chan->common.cookie = desc->async_tx.cookie = cookie;
+	return cookie;
+}
+
+static inline void spe_adma_check_threshold(struct spe_adma_chan *spe_chan)
+{
+	PRINTK("spe adma%d: pending: %d\n", spe_chan->device->id,
+		spe_chan->pending);
+
+	if (spe_chan->pending >= SPE_ADMA_THRESHOLD) {
+		spe_chan->pending = 0;
+		spe_chan_append(spe_chan);
+	}
+}
+
+
+static dma_cookie_t
+spe_adma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct spe_adma_desc_slot *sw_desc = tx_to_spe_adma_slot(tx);
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(tx->chan);
+	struct spe_adma_desc_slot *group_start, *old_chain_tail;
+	int slot_cnt;
+	int slots_per_op;
+	dma_cookie_t cookie;
+
+	group_start = sw_desc->group_head;
+	slot_cnt = group_start->slot_cnt;
+	slots_per_op = group_start->slots_per_op;
+
+	spin_lock_bh(&spe_chan->lock);
+
+	cookie = spe_desc_assign_cookie(spe_chan, sw_desc);
+
+	old_chain_tail = list_entry(spe_chan->chain.prev,
+		struct spe_adma_desc_slot, chain_node);
+	list_splice_init(&sw_desc->group_list, &old_chain_tail->chain_node);
+
+	/* fix up the hardware chain */
+	spe_desc_set_next_desc(old_chain_tail, spe_chan, group_start);
+
+	/* increment the pending count by the number of operations */
+	spe_chan->pending += slot_cnt / slots_per_op;
+	spe_adma_check_threshold(spe_chan);
+	spin_unlock_bh(&spe_chan->lock);
+
+	PRINTK("spe adma%d: %s cookie: %d slot: %d tx %p\n", spe_chan->device->id,
+		__FUNCTION__, sw_desc->async_tx.cookie, sw_desc->idx, sw_desc);
+
+	return cookie;
+}
+
+struct dma_async_tx_descriptor *
+spe_adma_prep_dma_interrupt(struct dma_chan *chan)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	struct spe_adma_desc_slot *sw_desc, *group_start;
+	int slot_cnt, slots_per_op = 0;
+
+	PRINTK("*** spe adma%d: %s\n", spe_chan->device->id, __FUNCTION__);
+	spin_lock_bh(&spe_chan->lock);
+	slot_cnt = spe_chan_interrupt_slot_count(&slots_per_op, spe_chan);
+	sw_desc = spe_adma_alloc_slots(spe_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		group_start = sw_desc->group_head;
+		spe_desc_init_interrupt(group_start, spe_chan);
+		sw_desc->async_tx.type = DMA_INTERRUPT;
+	}
+	spin_unlock_bh(&spe_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+struct dma_async_tx_descriptor *
+spe_adma_prep_dma_memcpy(struct dma_chan *chan, size_t len, int int_en)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	struct spe_adma_desc_slot *sw_desc, *group_start;
+	int slot_cnt, slots_per_op;
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(unlikely(len > SPE_ADMA_MAX_BYTE_COUNT));
+
+	spin_lock_bh(&spe_chan->lock);
+
+        PRINTK("spe adma%d: %s len: %u int_en %d\n",
+        spe_chan->device->id, __FUNCTION__, len, int_en);
+
+	slot_cnt = spe_chan_memcpy_slot_count(len, &slots_per_op);
+	sw_desc = spe_adma_alloc_slots(spe_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		group_start = sw_desc->group_head;
+		spe_desc_init_memcpy(group_start, int_en);
+		spe_desc_set_byte_count(group_start, spe_chan, len);
+		sw_desc->unmap_src_cnt = 1;
+		sw_desc->unmap_len = len;
+		sw_desc->async_tx.type = DMA_MEMCPY;
+	} 
+	spin_unlock_bh(&spe_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+struct dma_async_tx_descriptor *
+spe_adma_prep_dma_xor(struct dma_chan *chan, unsigned int src_cnt, size_t len,
+	int int_en)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	struct spe_adma_desc_slot *sw_desc, *group_start;
+	int slot_cnt, slots_per_op;
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(unlikely(len > SPE_ADMA_XOR_MAX_BYTE_COUNT));
+
+	PRINTK("spe adma%d: %s src_cnt: %d len: %u int_en: %d\n",
+	spe_chan->device->id, __FUNCTION__, src_cnt, len, int_en);
+
+	spin_lock_bh(&spe_chan->lock);
+	slot_cnt = spe_chan_xor_slot_count(len, src_cnt, &slots_per_op);
+	sw_desc = spe_adma_alloc_slots(spe_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		group_start = sw_desc->group_head;
+		spe_desc_init_xor(group_start, src_cnt, int_en);
+		spe_desc_set_byte_count(group_start, spe_chan, len);
+		sw_desc->unmap_src_cnt = src_cnt;
+		sw_desc->unmap_len = len;
+		sw_desc->async_tx.type = DMA_XOR;
+	}
+	spin_unlock_bh(&spe_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+static void
+spe_adma_set_dest(dma_addr_t addr, struct dma_async_tx_descriptor *tx,
+	int index)
+{
+	struct spe_adma_desc_slot *sw_desc = tx_to_spe_adma_slot(tx);
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(tx->chan);
+
+	/* to do: support transfers lengths > SPE_ADMA_MAX_BYTE_COUNT */
+	spe_desc_set_dest_addr(sw_desc->group_head, spe_chan, addr);
+}
+
+static void
+spe_adma_set_src(dma_addr_t addr, struct dma_async_tx_descriptor *tx,
+	int index)
+{
+	struct spe_adma_desc_slot *sw_desc = tx_to_spe_adma_slot(tx);
+	struct spe_adma_desc_slot *group_start = sw_desc->group_head;
+
+	switch (tx->type) {
+	case DMA_MEMCPY:
+		spe_desc_set_memcpy_src_addr(
+			group_start,
+			addr,
+			group_start->slot_cnt,
+			group_start->slots_per_op);
+		break;
+	case DMA_XOR:
+		spe_desc_set_xor_src_addr(
+			group_start,
+			index,
+			addr,
+			group_start->slot_cnt,
+			group_start->slots_per_op);
+		break;
+	/* todo: case DMA_ZERO_SUM: */
+	/* todo: case DMA_PQ_XOR: */
+	/* todo: case DMA_DUAL_XOR: */
+	/* todo: case DMA_PQ_UPDATE: */
+	/* todo: case DMA_PQ_ZERO_SUM: */
+	/* todo: case DMA_MEMCPY_CRC32C: */
+	case DMA_MEMSET:
+	default:
+		do {
+			struct spe_adma_chan *spe_chan =
+				to_spe_adma_chan(tx->chan);
+			printk(KERN_ERR "spe adma%d: unsupport tx_type: %d\n",
+				spe_chan->device->id, tx->type);
+			BUG();
+		} while (0);
+	}
+}
+
+static inline void spe_adma_schedule_cleanup(unsigned long id)
+{
+	tasklet_schedule(spe_adma_tasklet[id]);
+}
+
+static void spe_adma_dependency_added(struct dma_chan *chan)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+
+	spe_adma_schedule_cleanup(spe_chan->device->id);
+}
+
+static void spe_adma_free_chan_resources(struct dma_chan *chan)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	struct spe_adma_desc_slot *iter, *_iter;
+	int in_use_descs = 0;
+
+	spe_adma_slot_cleanup(spe_chan);
+
+	spin_lock_bh(&spe_chan->lock);
+	list_for_each_entry_safe(iter, _iter, &spe_chan->chain,
+					chain_node) {
+		in_use_descs++;
+		list_del(&iter->chain_node);
+	}
+	list_for_each_entry_safe_reverse(iter, _iter, &spe_chan->all_slots, slot_node) {
+		list_del(&iter->slot_node);
+		kfree(iter);
+		spe_chan->slots_allocated--;
+	}
+	spe_chan->last_used = NULL;
+
+	PRINTK("spe adma%d %s slots_allocated %d\n", spe_chan->device->id,
+		__FUNCTION__, spe_chan->slots_allocated);
+	spin_unlock_bh(&spe_chan->lock);
+
+	/* one is ok since we left it on there on purpose */
+	if (in_use_descs > 1)
+		printk(KERN_ERR "SPE: Freeing %d in use descriptors!\n",
+			in_use_descs - 1);
+}
+
+/**
+ * spe_adma_is_complete - poll the status of an ADMA transaction
+ * @chan: ADMA channel handle
+ * @cookie: ADMA transaction identifier
+ */
+static enum dma_status spe_adma_is_complete(struct dma_chan *chan,
+                                            dma_cookie_t cookie,
+                                            dma_cookie_t *done,
+                                            dma_cookie_t *used)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+	enum dma_status ret;
+
+	last_used = chan->cookie;
+	last_complete = spe_chan->completed_cookie;
+
+	if (done)
+		*done= last_complete;
+	if (used)
+		*used = last_used;
+
+	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	if (ret == DMA_SUCCESS)
+		return ret;
+
+	spe_adma_slot_cleanup(spe_chan);
+
+	last_used = chan->cookie;
+	last_complete = spe_chan->completed_cookie;
+
+	if (done)
+		*done= last_complete;
+	if (used)
+		*used = last_used;
+
+	return dma_async_is_complete(cookie, last_complete, last_used);
+}
+
+/*
+ * End of transfer interrupt
+ */
+static irqreturn_t spe_adma_eot_handler(int irq, void *data)
+{
+	int id = *(int *) data;
+
+	PRINTK("spe adma%d: %s\n", id, __FUNCTION__);
+
+	tasklet_schedule(spe_adma_tasklet[id]);
+	spe_adma_device_clear_eot_status(spe_adma_chan_array[id]);
+
+	return IRQ_HANDLED;
+}
+
+static void spe_adma_issue_pending(struct dma_chan *chan)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+
+	PRINTK("spe adma%d: %s %d \n", spe_chan->device->id, __FUNCTION__,
+			spe_chan->pending);
+
+	if (spe_chan->pending) {
+        	spe_chan->pending = 0;
+                spe_chan_append(spe_chan);
+	}
+}
+
+void spe_block_ch (struct dma_chan *chan)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+
+	spin_lock_bh(&spe_chan->lock);
+}
+
+void spe_unblock_ch (struct dma_chan *chan)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+
+	spin_unlock_bh(&spe_chan->lock);
+}
+
+static dma_addr_t spe_adma_map_page(struct dma_chan *chan, struct page *page,
+					unsigned long offset, size_t size,
+					int direction)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	return dma_map_page(&spe_chan->device->pdev->dev, page, offset, size,
+			direction);
+}
+
+static dma_addr_t spe_adma_map_single(struct dma_chan *chan, void *cpu_addr,
+					size_t size, int direction)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	return dma_map_single(&spe_chan->device->pdev->dev, cpu_addr, size,
+			direction);
+}
+
+static void spe_adma_unmap_page(struct dma_chan *chan, dma_addr_t handle,
+				size_t size, int direction)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	dma_unmap_page(&spe_chan->device->pdev->dev, handle, size, direction);
+}
+
+static void spe_adma_unmap_single(struct dma_chan *chan, dma_addr_t handle,
+				size_t size, int direction)
+{
+	struct spe_adma_chan *spe_chan = to_spe_adma_chan(chan);
+	dma_unmap_single(&spe_chan->device->pdev->dev, handle, size, direction);
+}
+
+static int __devexit spe_adma_remove(struct platform_device *dev)
+{
+	struct spe_adma_device *device = platform_get_drvdata(dev);
+	struct dma_chan *chan, *_chan;
+	struct spe_adma_chan *spe_chan;
+	int i;
+	struct spe_adma_platform_data *plat_data = dev->dev.platform_data;
+
+	PRINTK("%s\n", __FUNCTION__);
+
+	dma_async_device_unregister(&device->common);
+
+	for (i = 0; i < 3; i++) {
+		unsigned int irq;
+		irq = platform_get_irq(dev, i);
+		free_irq(irq, device);
+	}
+
+	dma_free_coherent(&dev->dev, plat_data->pool_size,
+			device->dma_desc_pool_virt, device->dma_desc_pool);
+
+	do {
+		struct resource *res;
+		res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+		release_mem_region(res->start, res->end - res->start);
+	} while (0);
+
+	list_for_each_entry_safe(chan, _chan, &device->common.channels,
+				device_node) {
+		spe_chan = to_spe_adma_chan(chan);
+		list_del(&chan->device_node);
+		kfree(spe_chan);
+	}
+	kfree(device);
+
+	return 0;
+}
+
+static int __devinit spe_adma_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret=0, irq_eot=0, irq;
+	struct spe_adma_device *adev;
+	struct spe_adma_chan *spe_chan;
+	struct spe_adma_platform_data *plat_data = pdev->dev.platform_data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (!request_mem_region(res->start, res->end - res->start, pdev->name))
+		return -EBUSY;
+
+	if ((adev = kzalloc(sizeof(*adev), GFP_KERNEL)) == NULL) {
+		ret = -ENOMEM;
+		goto err_adev_alloc;
+	}
+
+	/* allocate coherent memory for hardware descriptors
+	 * note: writecombine gives slightly better performance, but
+	 * requires that we explicitly drain the write buffer
+	 */
+	if ((adev->dma_desc_pool_virt = dma_alloc_coherent(&pdev->dev,
+					plat_data->pool_size,
+					&adev->dma_desc_pool,
+					GFP_KERNEL)) == NULL) {
+		ret = -ENOMEM;
+		goto err_dma_alloc;
+	}
+
+	PRINTK("%s: allocted descriptor pool virt %p phys %p\n",
+	__FUNCTION__, adev->dma_desc_pool_virt, (void *) adev->dma_desc_pool);
+
+	adev->id = plat_data->hw_id;
+	adev->common.capabilities = plat_data->capabilities;
+
+	/* clear errors before enabling interrupts */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = -ENXIO;
+	} else {
+		irq_eot = irq;
+		ret = request_irq(irq, spe_adma_eot_handler,
+			0, pdev->name, &adev->id);
+		if (ret) {
+			ret = -EIO;
+			goto err_irq0;
+		}
+	}
+
+	adev->pdev = pdev;
+	platform_set_drvdata(pdev, adev);
+
+	INIT_LIST_HEAD(&adev->common.channels);
+
+	/* set base routines */
+	adev->common.device_tx_submit = spe_adma_tx_submit;
+	adev->common.device_set_dest = spe_adma_set_dest;
+	adev->common.device_set_src = spe_adma_set_src;
+	adev->common.device_alloc_chan_resources = spe_adma_alloc_chan_resources;
+	adev->common.device_free_chan_resources = spe_adma_free_chan_resources;
+	adev->common.device_is_tx_complete = spe_adma_is_complete;
+	adev->common.device_issue_pending = spe_adma_issue_pending;
+	adev->common.device_dependency_added = spe_adma_dependency_added;
+
+	adev->common.map_page = spe_adma_map_page;
+	adev->common.map_single = spe_adma_map_single;
+	adev->common.unmap_page = spe_adma_unmap_page;
+	adev->common.unmap_single = spe_adma_unmap_single;
+
+	/* set prep routines based on capability */
+	if (test_bit(DMA_MEMCPY, &adev->common.capabilities))
+		adev->common.device_prep_dma_memcpy = spe_adma_prep_dma_memcpy;
+	if (test_bit(DMA_XOR, &adev->common.capabilities)) {
+		adev->common.max_xor = spe_adma_get_max_xor();
+		adev->common.device_prep_dma_xor = spe_adma_prep_dma_xor;
+	}
+	if (test_bit(DMA_INTERRUPT, &adev->common.capabilities))
+		adev->common.device_prep_dma_interrupt =
+			spe_adma_prep_dma_interrupt;
+
+	if ((spe_chan = kzalloc(sizeof(struct spe_adma_chan), GFP_KERNEL)) == NULL) {
+		ret = -ENOMEM;
+		goto err_chan_alloc;
+	}
+
+	spe_adma_chan_array[adev->id] = spe_chan;
+
+	spe_chan->device = adev;
+	spin_lock_init(&spe_chan->lock);
+	init_timer(&spe_chan->cleanup_watchdog);
+	spe_chan->cleanup_watchdog.data = adev->id;
+	spe_chan->cleanup_watchdog.function = spe_adma_schedule_cleanup;
+	INIT_LIST_HEAD(&spe_chan->chain);
+	INIT_LIST_HEAD(&spe_chan->all_slots);
+	INIT_RCU_HEAD(&spe_chan->common.rcu);
+	spe_chan->common.device = &adev->common;
+	list_add_tail(&spe_chan->common.device_node, &adev->common.channels);
+
+	printk(KERN_INFO "Intel(R) SPE ADMA Engine found [%d]: "
+	  "( %s%s%s%s%s%s%s%s%s%s)\n",
+	  adev->id,
+	  test_bit(DMA_PQ_XOR, &adev->common.capabilities) ? "pq_xor " : "",
+	  test_bit(DMA_PQ_UPDATE, &adev->common.capabilities) ? "pq_update " : "",
+	  test_bit(DMA_PQ_ZERO_SUM, &adev->common.capabilities) ? "pq_zero_sum " : "",
+	  test_bit(DMA_XOR, &adev->common.capabilities) ? "xor " : "",
+	  test_bit(DMA_DUAL_XOR, &adev->common.capabilities) ? "dual_xor " : "",
+	  test_bit(DMA_ZERO_SUM, &adev->common.capabilities) ? "xor_zero_sum " : "",
+	  test_bit(DMA_MEMSET, &adev->common.capabilities)  ? "memset " : "",
+	  test_bit(DMA_MEMCPY_CRC32C, &adev->common.capabilities) ? "memcpy+crc " : "",
+	  test_bit(DMA_MEMCPY, &adev->common.capabilities) ? "memcpy " : "",
+	  test_bit(DMA_INTERRUPT, &adev->common.capabilities) ? "int " : "");
+
+	dma_async_device_register(&adev->common);
+	goto out;
+
+err_chan_alloc:
+err_irq0:
+	dma_free_coherent(&adev->pdev->dev, plat_data->pool_size,
+			adev->dma_desc_pool_virt, adev->dma_desc_pool);
+err_dma_alloc:
+	kfree(adev);
+err_adev_alloc:
+	release_mem_region(res->start, res->end - res->start);
+out:
+	return ret;
+}
+
+static char src1[16], src2[16], dst[16];
+
+static void spe_chan_start_null_xor(struct spe_adma_chan *spe_chan)
+{
+	struct spe_adma_desc_slot *sw_desc, *group_start;
+	dma_cookie_t cookie;
+	int slot_cnt, slots_per_op;
+
+	PRINTK("spe adma%d: %s\n", spe_chan->device->id, __FUNCTION__);
+
+	spin_lock_bh(&spe_chan->lock);
+	slot_cnt = spe_chan_xor_slot_count(0, 2, &slots_per_op);
+	sw_desc = spe_adma_alloc_slots(spe_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		group_start = sw_desc->group_head;
+		list_splice_init(&sw_desc->group_list, &spe_chan->chain);
+		sw_desc->async_tx.ack = 1;
+		spe_desc_init_null_xor(group_start, 2, 0);
+		spe_desc_set_byte_count(group_start, spe_chan, 16);
+		spe_desc_set_dest_addr(group_start, spe_chan, __pa(dst));
+		spe_desc_set_xor_src_addr(group_start, 0, __pa(src1), 1, 1);
+		spe_desc_set_xor_src_addr(group_start, 1, __pa(src2), 1, 1);
+
+		cookie = spe_chan->common.cookie;
+		cookie++;
+		if (cookie <= 1)
+			cookie = 2;
+
+		/* initialize the completed cookie to be less than
+		 * the most recently used cookie
+		 */
+		spe_chan->completed_cookie = cookie - 1;
+		spe_chan->common.cookie = sw_desc->async_tx.cookie = cookie;
+
+		/* channel should not be busy */
+		BUG_ON(spe_chan_is_busy(spe_chan));
+
+		/* disable operation */
+		spe_chan_disable(spe_chan);
+
+		/* set the descriptor address */
+		spe_chan_set_next_descriptor(spe_chan, sw_desc);
+
+		/* run the descriptor */
+		spe_chan_enable(spe_chan);
+	} else
+		printk(KERN_ERR "spe adma%d failed to allocate null descriptor\n",
+			spe_chan->device->id);
+	spin_unlock_bh(&spe_chan->lock);
+}
+
+static struct platform_driver spe_adma_driver = {
+	.probe		= spe_adma_probe,
+	.remove		= spe_adma_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "SPE-ADMA",
+	},
+};
+
+static int __init spe_adma_init (void)
+{
+	/* it's currently unsafe to unload this module */
+	/* if forced, worst case is that rmmod hangs */
+	__unsafe(THIS_MODULE);
+
+	return platform_driver_register(&spe_adma_driver);
+}
+
+static void __exit spe_adma_exit (void)
+{
+	platform_driver_unregister(&spe_adma_driver);
+	return;
+}
+
+module_init(spe_adma_init);
+module_exit(spe_adma_exit);
+
+MODULE_AUTHOR("Yuri Tikhonov <yur@emcraft.com>");
+MODULE_DESCRIPTION("SPE ADMA Engine Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/asm-ppc/adma.h b/include/asm-ppc/adma.h
new file mode 100644
index 0000000..0be88f1
--- /dev/null
+++ b/include/asm-ppc/adma.h
@@ -0,0 +1,715 @@
+/*
+ * include/asm/ppc440spe_adma.h
+ *
+ * 2006 (C) DENX Software Engineering.
+ *
+ * Author: Yuri Tikhonov <yur@emcraft.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of
+ * any kind, whether express or implied.
+ */
+
+#ifndef PPC440SPE_ADMA_H
+#define PPC440SPE_ADMA_H
+
+#include <linux/types.h>
+#include <asm/ppc440spe_dma.h>
+#include <asm/ppc440spe_xor.h>
+
+#define SPE_ADMA_SLOT_SIZE      sizeof(struct spe_adma_desc_slot)
+#define SPE_ADMA_THRESHOLD      5
+
+#define PPC440SPE_DMA0_ID       0
+#define PPC440SPE_DMA1_ID       1
+#define PPC440SPE_XOR_ID        2
+
+#define SPE_DESC_INT		(1<<1)
+#define SPE_DESC_PROCESSED	(1<<2)
+
+#define SPE_ADMA_XOR_MAX_BYTE_COUNT (1 << 31) /* this is the XOR_CBBCR width */
+#define SPE_ADMA_ZERO_SUM_MAX_BYTE_COUNT SPE_ADMA_XOR_MAX_BYTE_COUNT
+
+#undef ADMA_LL_DEBUG
+
+/**
+ * struct spe_adma_device - internal representation of an ADMA device
+ * @pdev: Platform device
+ * @id: HW ADMA Device selector
+ * @dma_desc_pool: base of DMA descriptor region (DMA address)
+ * @dma_desc_pool_virt: base of DMA descriptor region (CPU address)
+ * @common: embedded struct dma_device
+ */
+struct spe_adma_device {
+	struct platform_device *pdev;
+	void *dma_desc_pool_virt;
+
+	int id;
+	dma_addr_t dma_desc_pool;
+	struct dma_device common;
+};
+
+/**
+ * struct spe_adma_device - internal representation of an ADMA device
+ * @lock: serializes enqueue/dequeue operations to the slot pool
+ * @device: parent device
+ * @chain: device chain view of the descriptors
+ * @common: common dmaengine channel object members
+ * @all_slots: complete domain of slots usable by the channel
+ * @pending: allows batching of hardware operations
+ * @result_accumulator: allows zero result sums of buffers > the hw maximum
+ * @zero_sum_group: flag to the clean up routine to collect zero sum results
+ * @completed_cookie: identifier for the most recently completed operation
+ * @slots_allocated: records the actual size of the descriptor slot pool
+ */
+struct spe_adma_chan {
+	spinlock_t lock;
+	struct spe_adma_device *device;
+	struct timer_list cleanup_watchdog;
+	struct list_head chain;
+	struct dma_chan common;
+	struct list_head all_slots;
+	struct spe_adma_desc_slot *last_used;
+	int pending;
+	u8 result_accumulator;
+	u8 zero_sum_group;
+	dma_cookie_t completed_cookie;
+	int slots_allocated;
+};
+
+struct spe_adma_desc_slot {
+	dma_addr_t phys;
+	struct spe_adma_desc_slot *group_head, *hw_next;
+	struct dma_async_tx_descriptor async_tx;
+	struct list_head slot_node;
+	struct list_head chain_node; /* node in channel ops list */
+	struct list_head group_list; /* list */
+	unsigned int unmap_len;
+	unsigned int unmap_src_cnt;
+	dma_cookie_t cookie;
+	void *hw_desc;
+	u16 stride;
+	u16 idx;
+	u16 slot_cnt;
+	u8 src_cnt;
+	u8 slots_per_op;
+	unsigned long flags;
+	union {
+		u32 *xor_check_result;
+		u32 *crc32_result;
+	};
+};
+
+struct spe_adma_platform_data {
+	int hw_id;
+	unsigned long capabilities;
+	size_t pool_size;
+};
+
+static u32 xor_refetch = 0;
+static struct spe_adma_desc_slot *last_sub[2] = { NULL, NULL };
+
+#ifdef ADMA_LL_DEBUG
+static void print_dma_desc (struct spe_adma_desc_slot *desc)
+{
+	dma_cdb_t *p = desc->hw_desc;
+
+	printk(	"**************************\n"
+		"%s: CDB at %p (phys %x)\n"
+		"DMA OpCode=0x%x\n"
+		"Upper Half of SG1 Address=0x%x\n"
+		"Lower Half of SG1 Address=0x%x\n"
+		"SG (Scatter/Gather) Count=%x\n"
+		"Upper Half of SG2 Address=0x%x\n"
+		"Lower Half of SG2 Address=0x%x\n"
+		"Upper Half of SG3 Address=0x%x\n"
+		"Lower Half of SG3 Address=0x%x\n",
+		__FUNCTION__, p, desc->phys,
+		cpu_to_le32(p->opc),
+		cpu_to_le32(p->sg1u), cpu_to_le32(p->sg1l),
+		cpu_to_le32(p->cnt),
+		cpu_to_le32(p->sg2u), cpu_to_le32(p->sg2l),
+		cpu_to_le32(p->sg3u), cpu_to_le32(p->sg3l)
+	);
+}
+
+
+static void print_xor_desc (struct spe_adma_desc_slot *desc)
+{
+	xor_cb_t *p = desc->hw_desc;
+	int i;
+
+	printk( "**************************\n"
+		"%s(%p) [phys %x]\n"
+		"XOR0_CBCR=%x; XOR0_CBBCR=%x; XOR0_CBSR=%x;\n"
+		"XOR0_CBTAH=%x; XOR0_CBTAL=%x; XOR0_CBLAL=%x;\n",
+		__FUNCTION__, p, (u32)(desc->phys),
+		p->cbc,  p->cbbc, p->cbs,
+		p->cbtah, p->cbtal, p->cblal
+	);
+	for (i=0; i < 16; i++) {
+		printk("Operand[%d]=%x; ", i, p->ops[i]);
+		if (i && !(i%3))
+			printk("\n");
+	}
+}
+
+static void print_xor_chain (xor_cb_t *p)
+{
+	int i;
+
+	do {
+	        printk( "####### \n"
+	                "%s(%p) [phys %x]\n"
+        	        "XOR0_CBCR=%x; XOR0_CBBCR=%x; XOR0_CBSR=%x;\n"
+                	"XOR0_CBTAH=%x; XOR0_CBTAL=%x; XOR0_CBLAL=%x;\n",
+	                __FUNCTION__, p, (u32)__pa(p),
+        	        p->cbc,  p->cbbc, p->cbs,
+                	p->cbtah, p->cbtal, p->cblal
+        	);
+        	for (i=0; i < 16; i++) {
+	                printk("Operand[%d]=%x; ", i, p->ops[i]);
+                	if (i && !(i%3))
+        	                printk("\n");
+	        }
+
+		if (!p->cblal)
+			break;
+		p = __va(p->cblal);
+	} while (p);
+}
+
+static void print_xor_regs (struct spe_adma_chan *spe_chan)
+{
+       volatile xor_regs_t *p = (xor_regs_t *)spe_chan->device->pdev->resource[0].start;
+
+	printk("------ regs -------- \n");
+        printk( "\tcbcr=%x; cbbcr=%x; cbsr=%x;\n"
+        	"\tcblalr=%x;crsr=%x;crrr=%x;\n"
+                "\tccbalr=%x;ier=%x;sr=%x\n"
+                "\tplbr=%x;cbtalr=%x\n"
+		"\top1=%x;op2=%x;op3=%x\n",
+                in_be32(&p->cbcr), in_be32(&p->cbbcr),in_be32(&p->cbsr),
+                in_be32(&p->cblalr),in_be32(&p->crsr),in_be32(&p->crrr),
+                in_be32(&p->ccbalr),in_be32(&p->ier),in_be32(&p->sr),
+                in_be32(&p->plbr),in_be32(&p->cbtalr),
+		p->op_ar[0][1], p->op_ar[1][1], p->op_ar[2][1]);
+}
+#endif
+
+static inline int spe_chan_interrupt_slot_count (int *slots_per_op, struct spe_adma_chan *chan)
+{
+	*slots_per_op = 1;
+	return *slots_per_op;
+}
+
+static inline void spe_desc_init_interrupt (struct spe_adma_desc_slot *desc, struct spe_adma_chan *chan)
+{
+	xor_cb_t *p;
+
+	switch (chan->device->id) {
+	        case PPC440SPE_DMA0_ID:
+        	case PPC440SPE_DMA1_ID:
+			printk("%s is not supported for chan %d\n", __FUNCTION__, 
+				chan->device->id);
+	                break;
+        	case PPC440SPE_XOR_ID:
+			p = desc->hw_desc;
+			memset (desc->hw_desc, 0, sizeof(xor_cb_t));
+        		p->cbc = XOR_CBCR_CBCE_BIT; /* NOP */
+			break;
+	}
+}
+
+static inline void spe_adma_device_clear_eot_status (struct spe_adma_chan *chan)
+{
+	volatile dma_regs_t *dma_reg;
+	volatile xor_regs_t *xor_reg;
+	u32 rv;
+
+	switch (chan->device->id) {
+        case PPC440SPE_DMA0_ID:
+        case PPC440SPE_DMA1_ID:
+		/* read FIFO to ack */
+		dma_reg = (dma_regs_t *)chan->device->pdev->resource[0].start;
+		rv = le32_to_cpu(dma_reg->csfpl);
+		if (!rv) {
+			printk ("%s: CSFPL is NULL\n", __FUNCTION__);
+		}
+		break;
+        case PPC440SPE_XOR_ID:
+		/* reset status bit to ack*/
+		xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+		rv = in_be32(&xor_reg->sr);
+		/* clear status */
+		out_be32(&xor_reg->sr, rv);
+
+                if (!(xor_reg->sr & XOR_SR_XCP_BIT) && xor_refetch) {
+			xor_reg->crsr = XOR_CRSR_RCBE_BIT;
+                        xor_refetch = 0;
+                }
+
+		break;
+	}
+}
+
+static inline u32 spe_adma_get_max_xor (void)
+{
+	return 16;
+}
+
+static inline u32 spe_chan_get_current_descriptor(struct spe_adma_chan *chan)
+{
+	int id = chan->device->id;
+	volatile dma_regs_t *dma_reg;
+	volatile xor_regs_t *xor_reg;
+
+	switch (id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_reg = (dma_regs_t *)chan->device->pdev->resource[0].start;
+			return (le32_to_cpu(dma_reg->acpl)) & (~0xF);
+		case PPC440SPE_XOR_ID:
+			xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+			return xor_reg->ccbalr;
+		default:
+			BUG();
+	}
+	return 0;
+}
+
+static inline void spe_desc_init_null_xor(struct spe_adma_desc_slot *desc,
+                               int src_cnt, int unknown_param)
+{
+	xor_cb_t *hw_desc = desc->hw_desc;
+
+	desc->src_cnt = 0;
+	hw_desc->cbc = src_cnt; /* NOP ? */
+	hw_desc->cblal = 0;
+}
+
+static inline void spe_chan_set_next_descriptor(struct spe_adma_chan *chan,
+						struct spe_adma_desc_slot *next_desc)
+{
+	int id = chan->device->id;
+	volatile xor_regs_t *xor_reg;
+	unsigned long flags;
+
+	switch (id) {
+		case PPC440SPE_XOR_ID:
+			xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+
+			/* Set Link Address and mark that it's valid */
+			local_irq_save(flags);
+			while (xor_reg->sr & XOR_SR_XCP_BIT);
+			xor_reg->cblalr = next_desc->phys;
+			local_irq_restore(flags);
+			break;
+	}
+}
+
+static inline int spe_chan_is_busy(struct spe_adma_chan *chan)
+{
+	int id = chan->device->id, busy;
+	volatile xor_regs_t *xor_reg;
+	volatile dma_regs_t *dma_reg;
+
+	switch (id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_reg = (dma_regs_t *)chan->device->pdev->resource[0].start;
+			/*  if command FIFO's head and tail pointers are equal - 
+			 * channel is free
+			 */
+			busy = (dma_reg->cpfhp != dma_reg->cpftp) ? 1 : 0;
+			break;
+		case PPC440SPE_XOR_ID:
+			xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+			busy = (xor_reg->sr & XOR_SR_XCP_BIT) ? 1 : 0;
+			break;
+		default:
+			busy = 0;
+			BUG();
+	}
+
+	return busy;
+}
+
+static inline int spe_desc_is_aligned(struct spe_adma_desc_slot *desc,
+					int num_slots)
+{
+	return (desc->idx & (num_slots - 1)) ? 0 : 1;
+}
+
+/* to do: support large (i.e. > hw max) buffer sizes */
+static inline int spe_chan_memcpy_slot_count(size_t len, int *slots_per_op)
+{
+	*slots_per_op = 1;
+	return 1;
+}
+
+static inline int ppc440spe_xor_slot_count(size_t len, int src_cnt,
+					int *slots_per_op)
+{
+	/* Each XOR descriptor provides up to 16 source operands */
+	*slots_per_op = (src_cnt + 15)/16;
+	return *slots_per_op;
+}
+
+static inline int spe_chan_xor_slot_count(size_t len, int src_cnt,
+						int *slots_per_op)
+{
+	/* Number of slots depends on
+	 *	- the number of operators
+	 *	- the operator width (len)
+	 *  the maximum <len> may be 4K since the StripeHead size is PAGE_SIZE, so
+	 * if we'll use this driver for RAID purposes only we'll assume this maximum
+	 */
+	int slot_cnt = ppc440spe_xor_slot_count(len, src_cnt, slots_per_op);
+
+	if (likely(len <= SPE_ADMA_XOR_MAX_BYTE_COUNT))
+		return slot_cnt;
+
+	printk("%s: len %d > max %d !!\n", __FUNCTION__, len, SPE_ADMA_XOR_MAX_BYTE_COUNT);
+	BUG();
+	return slot_cnt;
+}
+
+static inline u32 spe_desc_get_dest_addr(struct spe_adma_desc_slot *desc,
+					struct spe_adma_chan *chan)
+{
+	dma_cdb_t *dma_hw_desc;
+	xor_cb_t *xor_hw_desc;
+
+	switch (chan->device->id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_hw_desc = desc->hw_desc;
+			return le32_to_cpu(dma_hw_desc->sg2l);
+		case PPC440SPE_XOR_ID:
+			xor_hw_desc = desc->hw_desc;
+			return xor_hw_desc->cbtal;
+		default:
+			BUG();
+	}
+	return 0;
+}
+
+static inline u32 spe_desc_get_byte_count(struct spe_adma_desc_slot *desc,
+					struct spe_adma_chan *chan)
+{
+        dma_cdb_t *dma_hw_desc;
+        xor_cb_t *xor_hw_desc;
+
+	switch (chan->device->id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_hw_desc = desc->hw_desc;
+			return le32_to_cpu(dma_hw_desc->cnt);
+		case PPC440SPE_XOR_ID:
+			xor_hw_desc = desc->hw_desc;
+			return xor_hw_desc->cbbc;
+		default:
+			BUG();
+	}
+	return 0;
+}
+
+static inline u32 spe_desc_get_src_addr(struct spe_adma_desc_slot *desc,
+					struct spe_adma_chan *chan,
+					int src_idx)
+{
+        dma_cdb_t *dma_hw_desc;
+        xor_cb_t *xor_hw_desc;
+
+	switch (chan->device->id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_hw_desc = desc->hw_desc;
+			return le32_to_cpu(dma_hw_desc->sg1l);
+		case PPC440SPE_XOR_ID:
+			xor_hw_desc = desc->hw_desc;
+			return xor_hw_desc->ops[src_idx];
+		default:
+			BUG();
+	}
+	return 0;
+}
+
+static inline void spe_xor_desc_set_src_addr(xor_cb_t *hw_desc,
+					int src_idx, dma_addr_t addr)
+{
+	out_be32(&hw_desc->ops[src_idx], addr);
+}
+
+static inline void spe_desc_init_memcpy(struct spe_adma_desc_slot *desc,
+				int int_en)
+{
+	dma_cdb_t *hw_desc = desc->hw_desc;
+
+	memset (desc->hw_desc, 0, sizeof(dma_cdb_t));
+
+	if (int_en)
+		desc->flags |= SPE_DESC_INT;
+	else
+		desc->flags &= ~SPE_DESC_INT;
+
+	desc->src_cnt = 1;
+	hw_desc->opc = cpu_to_le32(1<<24);
+}
+
+static inline void spe_desc_init_xor(struct spe_adma_desc_slot *desc,
+				int src_cnt,
+				int int_en)
+{
+	xor_cb_t *hw_desc;
+
+	memset (desc->hw_desc, 0, sizeof(xor_cb_t));
+
+	desc->src_cnt = src_cnt;
+	hw_desc = desc->hw_desc;
+	hw_desc->cbc = XOR_CBCR_TGT_BIT | src_cnt;
+	if (int_en)
+		hw_desc->cbc |= XOR_CBCR_CBCE_BIT;
+}
+
+static inline void spe_desc_set_byte_count(struct spe_adma_desc_slot *desc,
+					struct spe_adma_chan *chan,
+					u32 byte_count)
+{
+	dma_cdb_t *dma_hw_desc;
+	xor_cb_t *xor_hw_desc;
+
+	switch (chan->device->id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_hw_desc = desc->hw_desc;
+			dma_hw_desc->cnt = cpu_to_le32(byte_count);
+			break;
+		case PPC440SPE_XOR_ID:
+			xor_hw_desc = desc->hw_desc;
+			xor_hw_desc->cbbc = byte_count;
+			break;
+		default:
+			BUG();
+	}
+}
+
+static inline void spe_desc_set_dest_addr(struct spe_adma_desc_slot *desc,
+					struct spe_adma_chan *chan,
+					dma_addr_t addr)
+{
+	dma_cdb_t *dma_hw_descr;
+	xor_cb_t *xor_hw_descr;
+
+	switch (chan->device->id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_hw_descr = desc->hw_desc;
+			dma_hw_descr->sg2l = cpu_to_le32(addr);
+			break;
+		case PPC440SPE_XOR_ID:
+			xor_hw_descr = desc->hw_desc;
+			xor_hw_descr->cbtal = addr;
+			break;
+		default:
+			BUG();
+	}
+}
+
+static inline void spe_desc_set_memcpy_src_addr(struct spe_adma_desc_slot *desc,
+					dma_addr_t addr, int slot_cnt,
+					int slots_per_op)
+{
+	dma_cdb_t *hw_desc = desc->hw_desc;
+	hw_desc->sg1l = cpu_to_le32(addr);
+}
+
+static inline void spe_desc_set_xor_src_addr(struct spe_adma_desc_slot *desc,
+					int src_idx, dma_addr_t addr, int slot_cnt,
+					int slots_per_op)
+{
+	xor_cb_t *hw_desc = desc->hw_desc;
+
+	if (unlikely(slot_cnt != 1)) {
+		printk("%s: slot cnt = %d !!! \n", __FUNCTION__, slot_cnt);
+		BUG();
+	}
+
+	hw_desc->ops[src_idx] = addr;
+}
+
+static inline void spe_desc_set_next_desc(struct spe_adma_desc_slot *prev_desc,
+					struct spe_adma_chan *chan,
+					struct spe_adma_desc_slot *next_desc)
+{
+	volatile xor_cb_t *xor_hw_desc;
+	volatile xor_regs_t *xor_reg;
+	unsigned long flags;
+
+	if (!prev_desc)
+		return;
+
+	prev_desc->hw_next = next_desc;
+
+	switch (chan->device->id) {
+	case PPC440SPE_DMA0_ID:
+	case PPC440SPE_DMA1_ID:
+		break;
+	case PPC440SPE_XOR_ID:
+
+                next_desc->flags |= (1<<16);
+                next_desc->flags &= ~(1<<17);
+
+		/* bind descriptor to the chain */
+		xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+
+		/* modify link fields */
+		local_irq_save(flags);
+
+		xor_hw_desc = next_desc->hw_desc;
+		xor_hw_desc->cblal = 0;
+		xor_hw_desc->cbc &= ~XOR_CBCR_LNK_BIT;
+
+		xor_hw_desc = prev_desc->hw_desc;
+		xor_hw_desc->cbs = 0;
+		xor_hw_desc->cblal = next_desc->phys;
+		xor_hw_desc->cbc |= XOR_CBCR_LNK_BIT;
+
+		local_irq_restore(flags);
+
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline u32 spe_desc_get_next_desc(struct spe_adma_desc_slot *desc,
+					struct spe_adma_chan *chan)
+{
+	volatile xor_cb_t *xor_hw_desc;
+
+	switch (chan->device->id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			if (desc->hw_next)
+				return desc->hw_next->phys; 
+			return 0;
+		case PPC440SPE_XOR_ID:
+			xor_hw_desc = desc->hw_desc;
+			return xor_hw_desc->cblal;
+		default:
+			BUG();
+	}
+
+	return 0;
+}
+
+static inline void spe_chan_append(struct spe_adma_chan *chan)
+{
+        volatile dma_regs_t *dma_reg;
+        volatile xor_regs_t *xor_reg;
+	struct spe_adma_desc_slot *iter;
+	int id = chan->device->id;
+	u32 cur_desc;
+	unsigned long flags;
+
+	switch (id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			dma_reg = (dma_regs_t *)chan->device->pdev->resource[0].start;
+			cur_desc = spe_chan_get_current_descriptor(chan);
+			if (likely(cur_desc)) {
+				/* flush descriptors from queue to fifo */
+				iter = last_sub[chan->device->id];
+				if (!iter->hw_next)
+					return;
+
+				local_irq_save(flags);
+				list_for_each_entry_continue(iter, &chan->chain, chain_node) {
+					cur_desc = iter->phys;
+					if (!list_empty(&iter->async_tx.depend_list)) {
+						iter->flags |= SPE_DESC_INT;
+					}						
+
+					out_le32 (&dma_reg->cpfpl, cur_desc);  
+					if (!iter->hw_next)
+						break;
+				}
+				last_sub[chan->device->id] = iter;
+				local_irq_restore(flags);
+			} else {
+				/* first peer */
+				cur_desc = chan->last_used->phys;
+				last_sub[chan->device->id] = chan->last_used;
+				if (!(chan->last_used->flags & SPE_DESC_INT))
+					cur_desc |= 1 << 3;
+				out_le32 (&dma_reg->cpfpl, cur_desc);
+			}
+			break;
+		case PPC440SPE_XOR_ID:
+			xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+			local_irq_save(flags);
+
+			/* update current descriptor and refetch link */
+			if (!(xor_reg->sr & XOR_SR_XCP_BIT)) {
+				xor_reg->crsr = XOR_CRSR_RCBE_BIT;
+			} else {
+				xor_refetch = 1;
+			}
+
+			local_irq_restore(flags);
+			break;
+		default:
+			BUG();
+	}
+}
+
+static inline void spe_chan_disable(struct spe_adma_chan *chan)
+{
+	int id = chan->device->id;
+	volatile xor_regs_t *xor_reg;
+
+	switch (id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			break;
+		case PPC440SPE_XOR_ID:
+			xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+			xor_reg->crsr = XOR_CRSR_PAUS_BIT;
+
+			break;
+		default:
+			BUG();
+	}
+}
+
+static inline void spe_chan_enable(struct spe_adma_chan *chan)
+{
+	int id = chan->device->id;
+	volatile xor_regs_t *xor_reg;
+	unsigned long flags;
+
+	switch (id) {
+		case PPC440SPE_DMA0_ID:
+		case PPC440SPE_DMA1_ID:
+			/* always enable, do nothing */
+			break;
+		case PPC440SPE_XOR_ID:
+			/* drain write buffer */
+			xor_reg = (xor_regs_t *)chan->device->pdev->resource[0].start;
+
+			local_irq_save(flags);
+			xor_reg->crrr = XOR_CRSR_PAUS_BIT;
+			/* fetch descriptor pointed in <link> */
+			xor_reg->crrr = XOR_CRSR_64BA_BIT;
+			xor_reg->crsr = XOR_CRSR_XAE_BIT;
+			local_irq_restore(flags);
+
+			break;
+		default:
+			BUG();
+	}
+}
+
+#endif /* PPC440SPE_ADMA_H */
diff --git a/include/asm-ppc/ppc440spe_dma.h b/include/asm-ppc/ppc440spe_dma.h
new file mode 100644
index 0000000..e04c512
--- /dev/null
+++ b/include/asm-ppc/ppc440spe_dma.h
@@ -0,0 +1,214 @@
+/*
+ * include/asm/ppc440spe_dma.h
+ *
+ * 440SPe's DMA engines support header file
+ *
+ * 2006 (c) DENX Software Engineering
+ *
+ * Author: Yuri Tikhonov <yur@emcraft.com>
+ *
+ * This file is licensed under the term of  the GNU General Public License
+ * version 2. The program licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef	PPC440SPE_DMA_H
+#define PPC440SPE_DMA_H
+
+#include <asm/types.h>
+
+/* Number of elements in the array with statical CDBs */
+#define	MAX_STAT_DMA_CDBS	16
+/* Number of DMA engines available on the contoller */
+#define DMA_ENGINES_NUM		2
+
+/* FIFO's params */
+#define DMA0_FIFO_SIZE		0x1000
+#define DMA1_FIFO_SIZE		0x1000
+
+/* DMA Opcodes */
+#define	DMA_NOP_OPC		(u8)(0x00)
+#define DMA_MOVE_SG1_SF2_OPC	(u8)(0x01)
+#define DMA_MULTICAST_OPC	(u8)(0x05)
+
+/* I2O Memory Mapped Registers base address */
+#define I2O_MMAP_BASE		0x400100000ULL
+#define I2O_MMAP_SIZE		0xF4ULL
+
+/* DMA Memory Mapped Registers base address */
+#define DMA0_MMAP_BASE		0x400100100ULL
+#define DMA1_MMAP_BASE		0x400100200ULL
+#define DMA_MMAP_SIZE		0x80
+
+/* DMA Interrupt Sources, UIC0[20],[22] */
+#define DMA0_CP_FIFO_NEED_SERVICE	19
+#define DMA0_CS_FIFO_NEED_SERVICE	20
+#define DMA1_CP_FIFO_NEED_SERVICE	21
+#define DMA1_CS_FIFO_NEED_SERVICE	22
+
+/*UIC0:*/
+#define D0CPF_INT		(1<<12)
+#define D0CSF_INT		(1<<11)
+#define D1CPF_INT		(1<<10)
+#define D1CSF_INT		(1<<9)
+/*UIC1:*/
+#define DMAE_INT		(1<<9)
+
+
+/*
+ * DMAx engines Command Descriptor Block Type
+ */
+typedef struct dma_cdb {
+	/*
+	 * Basic CDB structure (Table 20-17, p.499, 440spe_um_1_22.pdf) 
+	 */
+	u32	opc;		/* opcode */
+#if 0
+	u8	pad0[2];        /* reserved */
+	u8	attr;		/* attributes */
+	u8	opc;		/* opcode */
+#endif
+	u32	sg1u;		/* upper SG1 address */
+	u32	sg1l;		/* lower SG1 address */
+	u32	cnt;		/* SG count, 3B used */
+	u32	sg2u;		/* upper SG2 address */
+	u32	sg2l;		/* lower SG2 address */
+	u32	sg3u;		/* upper SG3 address */
+	u32	sg3l;		/* lower SG3 address */
+} dma_cdb_t;
+
+/*
+ * Descriptor of allocated CDB
+ */
+typedef struct {
+	dma_cdb_t		*vaddr;	/* virtual address of CDB */
+	dma_addr_t		paddr;	/* physical address of CDB */
+	/*
+	 * Additional fields
+	 */
+	struct list_head 	link;	/* link in processing list */
+	u32			status;	/* status of the CDB */
+	/* status bits:  */
+	#define	DMA_CDB_DONE	(1<<0)	/* CDB processing competed */
+	#define DMA_CDB_CANCEL	(1<<1)	/* waiting thread was interrupted */
+#if 0
+	#define DMA_CDB_STALLOC (1<<2)  /* CDB allocated dynamically */
+
+	/*
+	 *  Each CDB must be 16B-alligned, if we use static array we should
+	 * take care of aligment for each array's element.
+	 */
+	u8	pad1[1];
+#endif
+} dma_cdbd_t;
+
+/*
+ * DMAx hardware registers (p.515 in 440SPe UM 1.22)
+ */
+typedef struct {
+	u32	cpfpl;
+	u32	cpfph;
+	u32	csfpl;
+	u32	csfph;
+	u32	dsts;
+	u32	cfg;
+	u8	pad0[0x8];
+	u16	cpfhp;
+	u16	cpftp;
+	u16	csfhp;
+	u16	csftp;
+	u8	pad1[0x8];
+	u32	acpl;
+	u32	acph;
+	u32	s1bpl;
+	u32	s1bph;
+	u32	s2bpl;
+	u32	s2bph;
+	u32	s3bpl;
+	u32	s3bph;
+	u8	pad2[0x10];
+	u32	earl;
+	u32	earh;
+	u8	pad3[0x8];
+	u32	seat;
+	u32	sead;
+	u32	op;
+	u32	fsiz;
+} dma_regs_t;
+
+/*
+ * I2O hardware registers (p.528 in 440SPe UM 1.22)
+ */
+typedef struct {
+	u32	ists;
+	u32	iseat;
+	u32	isead;
+	u8	pad0[0x14];
+	u32	idbel;
+	u8	pad1[0xc];
+	u32	ihis;
+	u32	ihim;
+	u8	pad2[0x8];
+	u32	ihiq;
+	u32	ihoq;
+	u8	pad3[0x8];
+	u32	iopis;
+	u32	iopim;
+	u32	iopiq;
+	u8	iopoq;
+	u8	pad4[3];
+	u16	iiflh;
+	u16	iiflt;
+	u16	iiplh;
+	u16	iiplt;
+	u16	ioflh;
+	u16	ioflt;
+	u16	ioplh;
+	u16	ioplt;
+	u32	iidc;
+	u32	ictl;
+	u32	ifcpp;
+	u8	pad5[0x4];
+	u16	mfac0;
+	u16	mfac1;
+	u16	mfac2;
+	u16	mfac3;
+	u16	mfac4;
+	u16	mfac5;
+	u16	mfac6;
+	u16	mfac7;
+	u16	ifcfh;
+	u16	ifcht;
+	u8	pad6[0x4];
+	u32	iifmc;
+	u32	iodb;
+	u32	iodbc;
+	u32	ifbal;
+	u32	ifbah;
+	u32	ifsiz;
+	u32	ispd0;
+	u32	ispd1;
+	u32	ispd2;
+	u32	ispd3;
+	u32	ihipl;
+	u32	ihiph;
+	u32	ihopl;
+	u32	ihoph;
+	u32	iiipl;
+	u32	iiiph;
+	u32	iiopl;
+	u32	iioph;
+	u32	ifcpl;
+	u32	ifcph;
+	u8	pad7[0x8];
+	u32	iopt;
+} i2o_regs_t;
+
+/*
+ *  Prototypes
+ */
+int dma_copy (char *dst,char *src, unsigned int data_sz);
+
+
+#endif /* PPC440SPE_DMA_H */
+
diff --git a/include/asm-ppc/ppc440spe_xor.h b/include/asm-ppc/ppc440spe_xor.h
new file mode 100644
index 0000000..fa135d7
--- /dev/null
+++ b/include/asm-ppc/ppc440spe_xor.h
@@ -0,0 +1,131 @@
+/*
+ * include/asm/ppc440spe_xor.h
+ *
+ * 440SPe's XOR engines support header file
+ *
+ * 2006 (c) DENX Software Engineering
+ *
+ * Author: Yuri Tikhonov <yur@emcraft.com>
+ *
+ * This file is licensed under the term of  the GNU General Public License
+ * version 2. The program licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef PPC440SPE_XOR_H
+#define PPC440SPE_XOR_H
+
+#include <asm/types.h>
+
+/* XOR Memory Mapped Registers base address */
+#define XOR_MMAP_BASE		0x400200000ULL
+#define XOR_MMAP_SIZE		0x224ULL
+
+/* XOR Interrupt Source, UIC1[31] */
+#define XOR_INTERRUPT		63
+
+/*
+ * XOR Command Block Control Register bits
+ */
+#define XOR_CBCR_LNK_BIT        (1<<31) /* link present */
+#define XOR_CBCR_TGT_BIT        (1<<30) /* target present */
+#define XOR_CBCR_CBCE_BIT       (1<<29) /* command block compete enable */
+#define XOR_CBCR_RNZE_BIT       (1<<28) /* result not zero enable */
+#define XOR_CBCR_XNOR_BIT       (1<<15) /* XOR/XNOR */
+
+/*
+ * XORCore Status Register bits
+ */
+#define XOR_SR_XCP_BIT		(1<<31)	/* core processing */
+#define XOR_SR_ICB_BIT		(1<<17)	/* invalid CB */
+#define XOR_SR_IC_BIT		(1<<16)	/* invalid command */
+#define XOR_SR_IPE_BIT		(1<<15)	/* internal parity error */
+#define XOR_SR_RNZ_BIT		(1<<2)	/* result not Zero */
+#define XOR_SR_CBC_BIT		(1<<1)	/* CB complete */
+#define XOR_SR_CBLC_BIT		(1<<0)	/* CB list complete */
+
+/*
+ * XORCore Control Set and Reset Register bits
+ */
+#define XOR_CRSR_XASR_BIT	(1<<31)	/* soft reset */
+#define XOR_CRSR_XAE_BIT	(1<<30)	/* enable */
+#define XOR_CRSR_RCBE_BIT	(1<<29)	/* refetch CB enable */
+#define XOR_CRSR_PAUS_BIT	(1<<28)	/* pause */
+#define XOR_CRSR_64BA_BIT	(1<<27) /* 64/32 CB format */
+#define XOR_CRSR_CLP_BIT	(1<<25)	/* continue list processing */
+
+/*
+ * XORCore Interrupt Enable Register
+ */
+#define XOR_IE_CBCIE_BIT	(1<<1)	/* CB complete interrupt enable */
+#define XOR_IE_CBLCI_BIT	(1<<0)	/* CB list complete interrupt enable */
+
+/*
+ * XOR Accelerator engine Command Block Type
+ */
+typedef struct {
+	/*
+	 * Basic 32-bit format XOR CB (Table 19-1, p.463, 440spe_um_1_22.pdf)
+	 */
+	u32	cbc;		/* control */
+	u32	cbbc;		/* byte count */
+	u32	cbs;		/* status */
+	u8	pad0[4];	/* reserved */
+	u32	cbtah;		/* target address high */
+	u32	cbtal;		/* target address low */
+	u8	pad1[4];	/* reserved */
+	u32	cblal;		/* link address low */
+	u32	ops[16];	/* operands addresses */
+} __attribute__ ((packed)) xor_cb_t;
+
+typedef struct {
+	xor_cb_t		*vaddr;
+	dma_addr_t		paddr;
+
+	/*
+	 * Additional fields
+	 */
+	struct list_head	link;	/* link to processing CBs */
+	u32			status;	/* status of the CB */
+	/* status bits: */
+	#define XOR_CB_DONE	(1<<0)	/* CB processing competed */
+	#define XOR_CB_CANCEL	(1<<1)	/* waiting thread was interrupted */
+#if 0
+	#define XOR_CB_STALLOC	(1<<2)	/* CB allocated statically */
+#endif
+} xor_cbd_t;
+
+
+/*
+ * XOR hardware registers Table 19-3, UM 1.22
+ */
+typedef struct {
+	u32	op_ar[16][2];	/* operand address[0]-high,[1]-low registers */
+	u8	pad0[352];	/* reserved */
+	u32	cbcr;		/* CB control register */
+	u32	cbbcr;		/* CB byte count register */
+	u32	cbsr;		/* CB status register */
+	u8	pad1[4];	/* reserved */
+	u32	cbtahr;		/* operand target address high register */
+	u32	cbtalr;		/* operand target address low register */
+	u32	cblahr;		/* CB link address high register */
+	u32	cblalr;		/* CB link address low register */
+	u32	crsr;		/* control set register */
+	u32	crrr;		/* control reset register */
+	u32	ccbahr;		/* current CB address high register */
+	u32	ccbalr;		/* current CB address low register */
+	u32	plbr;		/* PLB configuration register */
+	u32	ier;		/* interrupt enable register */
+	u32	pecr;		/* parity error count register */
+	u32	sr;		/* status register */
+	u32	revidr;		/* revision ID register */
+} __attribute__ ((packed)) xor_regs_t;
+
+/*
+ * Prototypes
+ */
+int init_xor_eng(void);
+int spe440_xor_block (unsigned int ops_count, unsigned int op_len, void **ops);
+
+#endif /* PPC440SPE_XOR_H */
+
-- 
1.5.0.2

