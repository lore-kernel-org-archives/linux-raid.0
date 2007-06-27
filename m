From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 17/19] iop13xx: surface the iop13xx adma units to the
	iop-adma driver
Date: Tue, 26 Jun 2007 18:52:00 -0700
Message-ID: <20070627015200.18962.66343.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

Adds the platform device definitions and the architecture specific
support routines (i.e. register initialization and descriptor formats) for the
iop-adma driver.

Changelog:
* added 'descriptor pool size' to the platform data
* add base support for buffer sizes larger than 16MB (hw max)
* build error fix from Kirill A. Shutemov
* rebase for async_tx changes
* add interrupt support
* do not call platform register macros in driver code
* remove unnecessary ARM assembly statement
* checkpatch.pl fixes
* gpl v2 only correction

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/mach-iop13xx/setup.c          |  217 +++++++++++++
 include/asm-arm/arch-iop13xx/adma.h    |  544 ++++++++++++++++++++++++++++++++
 include/asm-arm/arch-iop13xx/iop13xx.h |   38 +-
 3 files changed, 774 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index bc48715..bfe0c87 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -25,6 +25,7 @@
 #include <asm/hardware.h>
 #include <asm/irq.h>
 #include <asm/io.h>
+#include <asm/hardware/iop_adma.h>
 
 #define IOP13XX_UART_XTAL 33334000
 #define IOP13XX_SETUP_DEBUG 0
@@ -236,19 +237,143 @@ static unsigned long iq8134x_probe_flash_size(void)
 }
 #endif
 
+/* ADMA Channels */
+static struct resource iop13xx_adma_0_resources[] = {
+	[0] = {
+		.start = IOP13XX_ADMA_PHYS_BASE(0),
+		.end = IOP13XX_ADMA_UPPER_PA(0),
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_IOP13XX_ADMA0_EOT,
+		.end = IRQ_IOP13XX_ADMA0_EOT,
+		.flags = IORESOURCE_IRQ
+	},
+	[2] = {
+		.start = IRQ_IOP13XX_ADMA0_EOC,
+		.end = IRQ_IOP13XX_ADMA0_EOC,
+		.flags = IORESOURCE_IRQ
+	},
+	[3] = {
+		.start = IRQ_IOP13XX_ADMA0_ERR,
+		.end = IRQ_IOP13XX_ADMA0_ERR,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static struct resource iop13xx_adma_1_resources[] = {
+	[0] = {
+		.start = IOP13XX_ADMA_PHYS_BASE(1),
+		.end = IOP13XX_ADMA_UPPER_PA(1),
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_IOP13XX_ADMA1_EOT,
+		.end = IRQ_IOP13XX_ADMA1_EOT,
+		.flags = IORESOURCE_IRQ
+	},
+	[2] = {
+		.start = IRQ_IOP13XX_ADMA1_EOC,
+		.end = IRQ_IOP13XX_ADMA1_EOC,
+		.flags = IORESOURCE_IRQ
+	},
+	[3] = {
+		.start = IRQ_IOP13XX_ADMA1_ERR,
+		.end = IRQ_IOP13XX_ADMA1_ERR,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static struct resource iop13xx_adma_2_resources[] = {
+	[0] = {
+		.start = IOP13XX_ADMA_PHYS_BASE(2),
+		.end = IOP13XX_ADMA_UPPER_PA(2),
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_IOP13XX_ADMA2_EOT,
+		.end = IRQ_IOP13XX_ADMA2_EOT,
+		.flags = IORESOURCE_IRQ
+	},
+	[2] = {
+		.start = IRQ_IOP13XX_ADMA2_EOC,
+		.end = IRQ_IOP13XX_ADMA2_EOC,
+		.flags = IORESOURCE_IRQ
+	},
+	[3] = {
+		.start = IRQ_IOP13XX_ADMA2_ERR,
+		.end = IRQ_IOP13XX_ADMA2_ERR,
+		.flags = IORESOURCE_IRQ
+	}
+};
+
+static u64 iop13xx_adma_dmamask = DMA_64BIT_MASK;
+static struct iop_adma_platform_data iop13xx_adma_0_data = {
+	.hw_id = 0,
+	.pool_size = PAGE_SIZE,
+};
+
+static struct iop_adma_platform_data iop13xx_adma_1_data = {
+	.hw_id = 1,
+	.pool_size = PAGE_SIZE,
+};
+
+static struct iop_adma_platform_data iop13xx_adma_2_data = {
+	.hw_id = 2,
+	.pool_size = PAGE_SIZE,
+};
+
+/* The ids are fixed up later in iop13xx_platform_init */
+static struct platform_device iop13xx_adma_0_channel = {
+	.name = "iop-adma",
+	.id = 0,
+	.num_resources = 4,
+	.resource = iop13xx_adma_0_resources,
+	.dev = {
+		.dma_mask = &iop13xx_adma_dmamask,
+		.coherent_dma_mask = DMA_64BIT_MASK,
+		.platform_data = (void *) &iop13xx_adma_0_data,
+	},
+};
+
+static struct platform_device iop13xx_adma_1_channel = {
+	.name = "iop-adma",
+	.id = 0,
+	.num_resources = 4,
+	.resource = iop13xx_adma_1_resources,
+	.dev = {
+		.dma_mask = &iop13xx_adma_dmamask,
+		.coherent_dma_mask = DMA_64BIT_MASK,
+		.platform_data = (void *) &iop13xx_adma_1_data,
+	},
+};
+
+static struct platform_device iop13xx_adma_2_channel = {
+	.name = "iop-adma",
+	.id = 0,
+	.num_resources = 4,
+	.resource = iop13xx_adma_2_resources,
+	.dev = {
+		.dma_mask = &iop13xx_adma_dmamask,
+		.coherent_dma_mask = DMA_64BIT_MASK,
+		.platform_data = (void *) &iop13xx_adma_2_data,
+	},
+};
+
 void __init iop13xx_map_io(void)
 {
 	/* Initialize the Static Page Table maps */
 	iotable_init(iop13xx_std_desc, ARRAY_SIZE(iop13xx_std_desc));
 }
 
-static int init_uart = 0;
-static int init_i2c = 0;
+static int init_uart;
+static int init_i2c;
+static int init_adma;
 
 void __init iop13xx_platform_init(void)
 {
 	int i;
-	u32 uart_idx, i2c_idx, plat_idx;
+	u32 uart_idx, i2c_idx, adma_idx, plat_idx;
 	struct platform_device *iop13xx_devices[IQ81340_MAX_PLAT_DEVICES];
 
 	/* set the bases so we can read the device id */
@@ -294,6 +419,12 @@ void __init iop13xx_platform_init(void)
 		}
 	}
 
+	if (init_adma == IOP13XX_INIT_ADMA_DEFAULT) {
+		init_adma |= IOP13XX_INIT_ADMA_0;
+		init_adma |= IOP13XX_INIT_ADMA_1;
+		init_adma |= IOP13XX_INIT_ADMA_2;
+	}
+
 	plat_idx = 0;
 	uart_idx = 0;
 	i2c_idx = 0;
@@ -332,6 +463,56 @@ void __init iop13xx_platform_init(void)
 		}
 	}
 
+	/* initialize adma channel ids and capabilities */
+	adma_idx = 0;
+	for (i = 0; i < IQ81340_NUM_ADMA; i++) {
+		struct iop_adma_platform_data *plat_data;
+		if ((init_adma & (1 << i)) && IOP13XX_SETUP_DEBUG)
+			printk(KERN_INFO
+				"Adding adma%d to platform device list\n", i);
+		switch (init_adma & (1 << i)) {
+		case IOP13XX_INIT_ADMA_0:
+			iop13xx_adma_0_channel.id = adma_idx++;
+			iop13xx_devices[plat_idx++] = &iop13xx_adma_0_channel;
+			plat_data = &iop13xx_adma_0_data;
+			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
+			dma_cap_set(DMA_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_ZERO_SUM, plat_data->cap_mask);
+			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
+			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
+			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
+			break;
+		case IOP13XX_INIT_ADMA_1:
+			iop13xx_adma_1_channel.id = adma_idx++;
+			iop13xx_devices[plat_idx++] = &iop13xx_adma_1_channel;
+			plat_data = &iop13xx_adma_1_data;
+			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
+			dma_cap_set(DMA_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_ZERO_SUM, plat_data->cap_mask);
+			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
+			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
+			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
+			break;
+		case IOP13XX_INIT_ADMA_2:
+			iop13xx_adma_2_channel.id = adma_idx++;
+			iop13xx_devices[plat_idx++] = &iop13xx_adma_2_channel;
+			plat_data = &iop13xx_adma_2_data;
+			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
+			dma_cap_set(DMA_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_ZERO_SUM, plat_data->cap_mask);
+			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
+			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
+			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
+			dma_cap_set(DMA_PQ_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_PQ_UPDATE, plat_data->cap_mask);
+			dma_cap_set(DMA_PQ_ZERO_SUM, plat_data->cap_mask);
+			break;
+		}
+	}
+
 #ifdef CONFIG_MTD_PHYSMAP
 	iq8134x_flash_resource.end = iq8134x_flash_resource.start +
 				iq8134x_probe_flash_size() - 1;
@@ -399,5 +580,35 @@ static int __init iop13xx_init_i2c_setup(char *str)
 	return 1;
 }
 
+static int __init iop13xx_init_adma_setup(char *str)
+{
+	if (str)	{
+		while (*str != '\0') {
+			switch (*str) {
+			case '0':
+				init_adma |= IOP13XX_INIT_ADMA_0;
+				break;
+			case '1':
+				init_adma |= IOP13XX_INIT_ADMA_1;
+				break;
+			case '2':
+				init_adma |= IOP13XX_INIT_ADMA_2;
+				break;
+			case ',':
+			case '=':
+				break;
+			default:
+				PRINTK("\"iop13xx_init_adma\" malformed"
+					    " at character: \'%c\'", *str);
+				*(str + 1) = '\0';
+				init_adma = IOP13XX_INIT_ADMA_DEFAULT;
+			}
+			str++;
+		}
+	}
+	return 1;
+}
+
+__setup("iop13xx_init_adma", iop13xx_init_adma_setup);
 __setup("iop13xx_init_uart", iop13xx_init_uart_setup);
 __setup("iop13xx_init_i2c", iop13xx_init_i2c_setup);
diff --git a/include/asm-arm/arch-iop13xx/adma.h b/include/asm-arm/arch-iop13xx/adma.h
new file mode 100644
index 0000000..04006c1
--- /dev/null
+++ b/include/asm-arm/arch-iop13xx/adma.h
@@ -0,0 +1,544 @@
+/*
+ * Copyright(c) 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#ifndef _ADMA_H
+#define _ADMA_H
+#include <linux/types.h>
+#include <linux/io.h>
+#include <asm/hardware.h>
+#include <asm/hardware/iop_adma.h>
+
+#define ADMA_ACCR(chan)	(chan->mmr_base + 0x0)
+#define ADMA_ACSR(chan)	(chan->mmr_base + 0x4)
+#define ADMA_ADAR(chan)	(chan->mmr_base + 0x8)
+#define ADMA_IIPCR(chan)	(chan->mmr_base + 0x18)
+#define ADMA_IIPAR(chan)	(chan->mmr_base + 0x1c)
+#define ADMA_IIPUAR(chan)	(chan->mmr_base + 0x20)
+#define ADMA_ANDAR(chan)	(chan->mmr_base + 0x24)
+#define ADMA_ADCR(chan)	(chan->mmr_base + 0x28)
+#define ADMA_CARMD(chan)	(chan->mmr_base + 0x2c)
+#define ADMA_ABCR(chan)	(chan->mmr_base + 0x30)
+#define ADMA_DLADR(chan)	(chan->mmr_base + 0x34)
+#define ADMA_DUADR(chan)	(chan->mmr_base + 0x38)
+#define ADMA_SLAR(src, chan)	(chan->mmr_base + (0x3c + (src << 3)))
+#define ADMA_SUAR(src, chan)	(chan->mmr_base + (0x40 + (src << 3)))
+
+struct iop13xx_adma_src {
+	u32 src_addr;
+	union {
+		u32 upper_src_addr;
+		struct {
+			unsigned int pq_upper_src_addr:24;
+			unsigned int pq_dmlt:8;
+		};
+	};
+};
+
+struct iop13xx_adma_desc_ctrl {
+	unsigned int int_en:1;
+	unsigned int xfer_dir:2;
+	unsigned int src_select:4;
+	unsigned int zero_result:1;
+	unsigned int block_fill_en:1;
+	unsigned int crc_gen_en:1;
+	unsigned int crc_xfer_dis:1;
+	unsigned int crc_seed_fetch_dis:1;
+	unsigned int status_write_back_en:1;
+	unsigned int endian_swap_en:1;
+	unsigned int reserved0:2;
+	unsigned int pq_update_xfer_en:1;
+	unsigned int dual_xor_en:1;
+	unsigned int pq_xfer_en:1;
+	unsigned int p_xfer_dis:1;
+	unsigned int reserved1:10;
+	unsigned int relax_order_en:1;
+	unsigned int no_snoop_en:1;
+};
+
+struct iop13xx_adma_byte_count {
+	unsigned int byte_count:24;
+	unsigned int host_if:3;
+	unsigned int reserved:2;
+	unsigned int zero_result_err_q:1;
+	unsigned int zero_result_err:1;
+	unsigned int tx_complete:1;
+};
+
+struct iop13xx_adma_desc_hw {
+	u32 next_desc;
+	union {
+		u32 desc_ctrl;
+		struct iop13xx_adma_desc_ctrl desc_ctrl_field;
+	};
+	union {
+		u32 crc_addr;
+		u32 block_fill_data;
+		u32 q_dest_addr;
+	};
+	union {
+		u32 byte_count;
+		struct iop13xx_adma_byte_count byte_count_field;
+	};
+	union {
+		u32 dest_addr;
+		u32 p_dest_addr;
+	};
+	union {
+		u32 upper_dest_addr;
+		u32 pq_upper_dest_addr;
+	};
+	struct iop13xx_adma_src src[1];
+};
+
+struct iop13xx_adma_desc_dual_xor {
+	u32 next_desc;
+	u32 desc_ctrl;
+	u32 reserved;
+	u32 byte_count;
+	u32 h_dest_addr;
+	u32 h_upper_dest_addr;
+	u32 src0_addr;
+	u32 upper_src0_addr;
+	u32 src1_addr;
+	u32 upper_src1_addr;
+	u32 h_src_addr;
+	u32 h_upper_src_addr;
+	u32 d_src_addr;
+	u32 d_upper_src_addr;
+	u32 d_dest_addr;
+	u32 d_upper_dest_addr;
+};
+
+struct iop13xx_adma_desc_pq_update {
+	u32 next_desc;
+	u32 desc_ctrl;
+	u32 reserved;
+	u32 byte_count;
+	u32 p_dest_addr;
+	u32 p_upper_dest_addr;
+	u32 src0_addr;
+	u32 upper_src0_addr;
+	u32 src1_addr;
+	u32 upper_src1_addr;
+	u32 p_src_addr;
+	u32 p_upper_src_addr;
+	u32 q_src_addr;
+	struct {
+		unsigned int q_upper_src_addr:24;
+		unsigned int q_dmlt:8;
+	};
+	u32 q_dest_addr;
+	u32 q_upper_dest_addr;
+};
+
+static inline int iop_adma_get_max_xor(void)
+{
+	return 16;
+}
+
+static inline u32 iop_chan_get_current_descriptor(struct iop_adma_chan *chan)
+{
+	return __raw_readl(ADMA_ADAR(chan));
+}
+
+static inline void iop_chan_set_next_descriptor(struct iop_adma_chan *chan,
+						u32 next_desc_addr)
+{
+	__raw_writel(next_desc_addr, ADMA_ANDAR(chan));
+}
+
+#define ADMA_STATUS_BUSY (1 << 13)
+
+static inline char iop_chan_is_busy(struct iop_adma_chan *chan)
+{
+	if (__raw_readl(ADMA_ACSR(chan)) &
+		ADMA_STATUS_BUSY)
+		return 1;
+	else
+		return 0;
+}
+
+static inline int
+iop_chan_get_desc_align(struct iop_adma_chan *chan, int num_slots)
+{
+	return 1;
+}
+#define iop_desc_is_aligned(x, y) 1
+
+static inline int
+iop_chan_memcpy_slot_count(size_t len, int *slots_per_op)
+{
+	*slots_per_op = 1;
+	return 1;
+}
+
+#define iop_chan_interrupt_slot_count(s, c) iop_chan_memcpy_slot_count(0, s)
+
+static inline int
+iop_chan_memset_slot_count(size_t len, int *slots_per_op)
+{
+	*slots_per_op = 1;
+	return 1;
+}
+
+static inline int
+iop_chan_xor_slot_count(size_t len, int src_cnt, int *slots_per_op)
+{
+	int num_slots;
+	/* slots_to_find = 1 for basic descriptor + 1 per 4 sources above 1
+	 * (1 source => 8 bytes) (1 slot => 32 bytes)
+	 */
+	num_slots = 1 + (((src_cnt - 1) << 3) >> 5);
+	if (((src_cnt - 1) << 3) & 0x1f)
+		num_slots++;
+
+	*slots_per_op = num_slots;
+
+	return num_slots;
+}
+
+#define ADMA_MAX_BYTE_COUNT	(16 * 1024 * 1024)
+#define IOP_ADMA_MAX_BYTE_COUNT ADMA_MAX_BYTE_COUNT
+#define IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT ADMA_MAX_BYTE_COUNT
+#define IOP_ADMA_XOR_MAX_BYTE_COUNT ADMA_MAX_BYTE_COUNT
+#define iop_chan_zero_sum_slot_count(l, s, o) iop_chan_xor_slot_count(l, s, o)
+
+static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *desc,
+					struct iop_adma_chan *chan)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	return hw_desc->dest_addr;
+}
+
+static inline u32 iop_desc_get_byte_count(struct iop_adma_desc_slot *desc,
+					struct iop_adma_chan *chan)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	return hw_desc->byte_count_field.byte_count;
+}
+
+static inline u32 iop_desc_get_src_addr(struct iop_adma_desc_slot *desc,
+					struct iop_adma_chan *chan,
+					int src_idx)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	return hw_desc->src[src_idx].src_addr;
+}
+
+static inline u32 iop_desc_get_src_count(struct iop_adma_desc_slot *desc,
+					struct iop_adma_chan *chan)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	return hw_desc->desc_ctrl_field.src_select + 1;
+}
+
+static inline void
+iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, int int_en)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	union {
+		u32 value;
+		struct iop13xx_adma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value = 0;
+	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
+	u_desc_ctrl.field.int_en = int_en;
+	hw_desc->desc_ctrl = u_desc_ctrl.value;
+	hw_desc->crc_addr = 0;
+}
+
+static inline void
+iop_desc_init_memset(struct iop_adma_desc_slot *desc, int int_en)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	union {
+		u32 value;
+		struct iop13xx_adma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value = 0;
+	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
+	u_desc_ctrl.field.block_fill_en = 1;
+	u_desc_ctrl.field.int_en = int_en;
+	hw_desc->desc_ctrl = u_desc_ctrl.value;
+	hw_desc->crc_addr = 0;
+}
+
+/* to do: support buffers larger than ADMA_MAX_BYTE_COUNT */
+static inline void
+iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	union {
+		u32 value;
+		struct iop13xx_adma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value = 0;
+	u_desc_ctrl.field.src_select = src_cnt - 1;
+	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
+	u_desc_ctrl.field.int_en = int_en;
+	hw_desc->desc_ctrl = u_desc_ctrl.value;
+	hw_desc->crc_addr = 0;
+
+}
+#define iop_desc_init_null_xor(d, s, i) iop_desc_init_xor(d, s, i)
+
+/* to do: support buffers larger than ADMA_MAX_BYTE_COUNT */
+static inline int
+iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt, int int_en)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	union {
+		u32 value;
+		struct iop13xx_adma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value = 0;
+	u_desc_ctrl.field.src_select = src_cnt - 1;
+	u_desc_ctrl.field.xfer_dir = 3; /* local to internal bus */
+	u_desc_ctrl.field.zero_result = 1;
+	u_desc_ctrl.field.status_write_back_en = 1;
+	u_desc_ctrl.field.int_en = int_en;
+	hw_desc->desc_ctrl = u_desc_ctrl.value;
+	hw_desc->crc_addr = 0;
+
+	return 1;
+}
+
+static inline void iop_desc_set_byte_count(struct iop_adma_desc_slot *desc,
+					struct iop_adma_chan *chan,
+					u32 byte_count)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	hw_desc->byte_count = byte_count;
+}
+
+static inline void
+iop_desc_set_zero_sum_byte_count(struct iop_adma_desc_slot *desc, u32 len)
+{
+	int slots_per_op = desc->slots_per_op;
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc, *iter;
+	int i = 0;
+
+	if (len <= IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT) {
+		hw_desc->byte_count = len;
+	} else {
+		do {
+			iter = iop_hw_desc_slot_idx(hw_desc, i);
+			iter->byte_count = IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT;
+			len -= IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT;
+			i += slots_per_op;
+		} while (len > IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT);
+
+		if (len) {
+			iter = iop_hw_desc_slot_idx(hw_desc, i);
+			iter->byte_count = len;
+		}
+	}
+}
+
+
+static inline void iop_desc_set_dest_addr(struct iop_adma_desc_slot *desc,
+					struct iop_adma_chan *chan,
+					dma_addr_t addr)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	hw_desc->dest_addr = addr;
+	hw_desc->upper_dest_addr = 0;
+}
+
+static inline void iop_desc_set_memcpy_src_addr(struct iop_adma_desc_slot *desc,
+					dma_addr_t addr)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	hw_desc->src[0].src_addr = addr;
+	hw_desc->src[0].upper_src_addr = 0;
+}
+
+static inline void iop_desc_set_xor_src_addr(struct iop_adma_desc_slot *desc,
+					int src_idx, dma_addr_t addr)
+{
+	int slot_cnt = desc->slot_cnt, slots_per_op = desc->slots_per_op;
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc, *iter;
+	int i = 0;
+
+	do {
+		iter = iop_hw_desc_slot_idx(hw_desc, i);
+		iter->src[src_idx].src_addr = addr;
+		iter->src[src_idx].upper_src_addr = 0;
+		slot_cnt -= slots_per_op;
+		if (slot_cnt) {
+			i += slots_per_op;
+			addr += IOP_ADMA_XOR_MAX_BYTE_COUNT;
+		}
+	} while (slot_cnt);
+}
+
+static inline void
+iop_desc_init_interrupt(struct iop_adma_desc_slot *desc,
+	struct iop_adma_chan *chan)
+{
+	iop_desc_init_memcpy(desc, 1);
+	iop_desc_set_byte_count(desc, chan, 0);
+	iop_desc_set_dest_addr(desc, chan, 0);
+	iop_desc_set_memcpy_src_addr(desc, 0);
+}
+
+#define iop_desc_set_zero_sum_src_addr iop_desc_set_xor_src_addr
+
+static inline void iop_desc_set_next_desc(struct iop_adma_desc_slot *desc,
+					u32 next_desc_addr)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	BUG_ON(hw_desc->next_desc);
+	hw_desc->next_desc = next_desc_addr;
+}
+
+static inline u32 iop_desc_get_next_desc(struct iop_adma_desc_slot *desc)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	return hw_desc->next_desc;
+}
+
+static inline void iop_desc_clear_next_desc(struct iop_adma_desc_slot *desc)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	hw_desc->next_desc = 0;
+}
+
+static inline void iop_desc_set_block_fill_val(struct iop_adma_desc_slot *desc,
+						u32 val)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	hw_desc->block_fill_data = val;
+}
+
+static inline int iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
+{
+	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
+	struct iop13xx_adma_desc_ctrl desc_ctrl = hw_desc->desc_ctrl_field;
+	struct iop13xx_adma_byte_count byte_count = hw_desc->byte_count_field;
+
+	BUG_ON(!(byte_count.tx_complete && desc_ctrl.zero_result));
+
+	if (desc_ctrl.pq_xfer_en)
+		return byte_count.zero_result_err_q;
+	else
+		return byte_count.zero_result_err;
+}
+
+static inline void iop_chan_append(struct iop_adma_chan *chan)
+{
+	u32 adma_accr;
+
+	adma_accr = __raw_readl(ADMA_ACCR(chan));
+	adma_accr |= 0x2;
+	__raw_writel(adma_accr, ADMA_ACCR(chan));
+}
+
+static inline void iop_chan_idle(int busy, struct iop_adma_chan *chan)
+{
+	do { } while (0);
+}
+
+static inline u32 iop_chan_get_status(struct iop_adma_chan *chan)
+{
+	return __raw_readl(ADMA_ACSR(chan));
+}
+
+static inline void iop_chan_disable(struct iop_adma_chan *chan)
+{
+	u32 adma_chan_ctrl = __raw_readl(ADMA_ACCR(chan));
+	adma_chan_ctrl &= ~0x1;
+	__raw_writel(adma_chan_ctrl, ADMA_ACCR(chan));
+}
+
+static inline void iop_chan_enable(struct iop_adma_chan *chan)
+{
+	u32 adma_chan_ctrl;
+
+	adma_chan_ctrl = __raw_readl(ADMA_ACCR(chan));
+	adma_chan_ctrl |= 0x1;
+	__raw_writel(adma_chan_ctrl, ADMA_ACCR(chan));
+}
+
+static inline void iop_adma_device_clear_eot_status(struct iop_adma_chan *chan)
+{
+	u32 status = __raw_readl(ADMA_ACSR(chan));
+	status &= (1 << 12);
+	__raw_writel(status, ADMA_ACSR(chan));
+}
+
+static inline void iop_adma_device_clear_eoc_status(struct iop_adma_chan *chan)
+{
+	u32 status = __raw_readl(ADMA_ACSR(chan));
+	status &= (1 << 11);
+	__raw_writel(status, ADMA_ACSR(chan));
+}
+
+static inline void iop_adma_device_clear_err_status(struct iop_adma_chan *chan)
+{
+	u32 status = __raw_readl(ADMA_ACSR(chan));
+	status &= (1 << 9) | (1 << 5) | (1 << 4) | (1 << 3);
+	__raw_writel(status, ADMA_ACSR(chan));
+}
+
+static inline int
+iop_is_err_int_parity(unsigned long status, struct iop_adma_chan *chan)
+{
+	return test_bit(9, &status);
+}
+
+static inline int
+iop_is_err_mcu_abort(unsigned long status, struct iop_adma_chan *chan)
+{
+	return test_bit(5, &status);
+}
+
+static inline int
+iop_is_err_int_tabort(unsigned long status, struct iop_adma_chan *chan)
+{
+	return test_bit(4, &status);
+}
+
+static inline int
+iop_is_err_int_mabort(unsigned long status, struct iop_adma_chan *chan)
+{
+	return test_bit(3, &status);
+}
+
+static inline int
+iop_is_err_pci_tabort(unsigned long status, struct iop_adma_chan *chan)
+{
+	return 0;
+}
+
+static inline int
+iop_is_err_pci_mabort(unsigned long status, struct iop_adma_chan *chan)
+{
+	return 0;
+}
+
+static inline int
+iop_is_err_split_tx(unsigned long status, struct iop_adma_chan *chan)
+{
+	return 0;
+}
+
+#endif /* _ADMA_H */
diff --git a/include/asm-arm/arch-iop13xx/iop13xx.h b/include/asm-arm/arch-iop13xx/iop13xx.h
index e6736c3..d4e4f82 100644
--- a/include/asm-arm/arch-iop13xx/iop13xx.h
+++ b/include/asm-arm/arch-iop13xx/iop13xx.h
@@ -166,12 +166,22 @@ static inline int iop13xx_cpu_id(void)
 #define IOP13XX_INIT_I2C_1	      (1 << 1)
 #define IOP13XX_INIT_I2C_2	      (1 << 2)
 
-#define IQ81340_NUM_UART     2
-#define IQ81340_NUM_I2C      3
-#define IQ81340_NUM_PHYS_MAP_FLASH 1
-#define IQ81340_MAX_PLAT_DEVICES (IQ81340_NUM_UART +\
-				IQ81340_NUM_I2C +\
-				IQ81340_NUM_PHYS_MAP_FLASH)
+/* ADMA selection flags */
+/* INIT_ADMA_DEFAULT = Rely on CONFIG_IOP13XX_ADMA* */
+#define IOP13XX_INIT_ADMA_DEFAULT     (0)
+#define IOP13XX_INIT_ADMA_0           (1 << 0)
+#define IOP13XX_INIT_ADMA_1           (1 << 1)
+#define IOP13XX_INIT_ADMA_2           (1 << 2)
+
+/* Platform devices */
+#define IQ81340_NUM_UART     		2
+#define IQ81340_NUM_I2C      		3
+#define IQ81340_NUM_PHYS_MAP_FLASH	1
+#define IQ81340_NUM_ADMA     		3
+#define IQ81340_MAX_PLAT_DEVICES (IQ81340_NUM_UART + \
+				IQ81340_NUM_I2C + \
+				IQ81340_NUM_PHYS_MAP_FLASH + \
+				IQ81340_NUM_ADMA)
 
 /*========================== PMMR offsets for key registers ============*/
 #define IOP13XX_ATU0_PMMR_OFFSET   	0x00048000
@@ -444,22 +454,6 @@ static inline int iop13xx_cpu_id(void)
 /*==============================ADMA UNITS===============================*/
 #define IOP13XX_ADMA_PHYS_BASE(chan)	IOP13XX_REG_ADDR32_PHYS((chan << 9))
 #define IOP13XX_ADMA_UPPER_PA(chan)	(IOP13XX_ADMA_PHYS_BASE(chan) + 0xc0)
-#define IOP13XX_ADMA_OFFSET(chan, ofs)	IOP13XX_REG_ADDR32((chan << 9) + (ofs))
-
-#define IOP13XX_ADMA_ACCR(chan)      IOP13XX_ADMA_OFFSET(chan, 0x0)
-#define IOP13XX_ADMA_ACSR(chan)      IOP13XX_ADMA_OFFSET(chan, 0x4)
-#define IOP13XX_ADMA_ADAR(chan)      IOP13XX_ADMA_OFFSET(chan, 0x8)
-#define IOP13XX_ADMA_IIPCR(chan)     IOP13XX_ADMA_OFFSET(chan, 0x18)
-#define IOP13XX_ADMA_IIPAR(chan)     IOP13XX_ADMA_OFFSET(chan, 0x1c)
-#define IOP13XX_ADMA_IIPUAR(chan)    IOP13XX_ADMA_OFFSET(chan, 0x20)
-#define IOP13XX_ADMA_ANDAR(chan)     IOP13XX_ADMA_OFFSET(chan, 0x24)
-#define IOP13XX_ADMA_ADCR(chan)      IOP13XX_ADMA_OFFSET(chan, 0x28)
-#define IOP13XX_ADMA_CARMD(chan)     IOP13XX_ADMA_OFFSET(chan, 0x2c)
-#define IOP13XX_ADMA_ABCR(chan)      IOP13XX_ADMA_OFFSET(chan, 0x30)
-#define IOP13XX_ADMA_DLADR(chan)     IOP13XX_ADMA_OFFSET(chan, 0x34)
-#define IOP13XX_ADMA_DUADR(chan)     IOP13XX_ADMA_OFFSET(chan, 0x38)
-#define IOP13XX_ADMA_SLAR(src, chan) IOP13XX_ADMA_OFFSET(chan, 0x3c + (src <<3))
-#define IOP13XX_ADMA_SUAR(src, chan) IOP13XX_ADMA_OFFSET(chan, 0x40 + (src <<3))
 
 /*==============================XSI BRIDGE===============================*/
 #define IOP13XX_XBG_BECSR		IOP13XX_REG_ADDR32(0x178c)
