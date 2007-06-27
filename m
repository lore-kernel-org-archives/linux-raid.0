From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 18/19] iop3xx: surface the iop3xx DMA and AAU units
	to the iop-adma driver
Date: Tue, 26 Jun 2007 18:52:05 -0700
Message-ID: <20070627015205.18962.1637.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

Adds the platform device definitions and the architecture specific supp=
ort
routines (i.e. register initialization and descriptor formats) for the
iop-adma driver.

Changelog:
* add support for > 1k zero sum buffer sizes
* added dma/aau platform devices to iq80321 and iq80332 setup
* fixed the calculation in iop_desc_is_aligned
* support xor buffer sizes larger than 16MB
* fix places where software descriptors are assumed to be contiguous, o=
nly
  hardware descriptors are contiguous for up to a PAGE_SIZE buffer size
* convert to async_tx
* add interrupt support
* add platform devices for 80219 boards
* do not call platform register macros in driver code
* remove switch() statements for compatible register offsets/layouts
* change over to bitmap based capabilities
* remove unnecessary ARM assembly statement
* checkpatch.pl fixes
* gpl v2 only correction

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/mach-iop32x/glantank.c        |    2=20
 arch/arm/mach-iop32x/iq31244.c         |    5=20
 arch/arm/mach-iop32x/iq80321.c         |    3=20
 arch/arm/mach-iop32x/n2100.c           |    2=20
 arch/arm/mach-iop33x/iq80331.c         |    3=20
 arch/arm/mach-iop33x/iq80332.c         |    3=20
 arch/arm/plat-iop/Makefile             |    2=20
 arch/arm/plat-iop/adma.c               |  209 ++++++++
 include/asm-arm/arch-iop32x/adma.h     |    5=20
 include/asm-arm/arch-iop33x/adma.h     |    5=20
 include/asm-arm/hardware/iop3xx-adma.h |  891 ++++++++++++++++++++++++=
++++++++
 include/asm-arm/hardware/iop3xx.h      |   68 --
 12 files changed, 1138 insertions(+), 60 deletions(-)

diff --git a/arch/arm/mach-iop32x/glantank.c b/arch/arm/mach-iop32x/gla=
ntank.c
index 5776fd8..2b086ab 100644
--- a/arch/arm/mach-iop32x/glantank.c
+++ b/arch/arm/mach-iop32x/glantank.c
@@ -180,6 +180,8 @@ static void __init glantank_init_machine(void)
 	platform_device_register(&iop3xx_i2c1_device);
 	platform_device_register(&glantank_flash_device);
 	platform_device_register(&glantank_serial_device);
+	platform_device_register(&iop3xx_dma_0_channel);
+	platform_device_register(&iop3xx_dma_1_channel);
=20
 	pm_power_off =3D glantank_power_off;
 }
diff --git a/arch/arm/mach-iop32x/iq31244.c b/arch/arm/mach-iop32x/iq31=
244.c
index d4eefbe..98cfa1c 100644
--- a/arch/arm/mach-iop32x/iq31244.c
+++ b/arch/arm/mach-iop32x/iq31244.c
@@ -298,9 +298,14 @@ static void __init iq31244_init_machine(void)
 	platform_device_register(&iop3xx_i2c1_device);
 	platform_device_register(&iq31244_flash_device);
 	platform_device_register(&iq31244_serial_device);
+	platform_device_register(&iop3xx_dma_0_channel);
+	platform_device_register(&iop3xx_dma_1_channel);
=20
 	if (is_ep80219())
 		pm_power_off =3D ep80219_power_off;
+
+	if (!is_80219())
+		platform_device_register(&iop3xx_aau_channel);
 }
=20
 static int __init force_ep80219_setup(char *str)
diff --git a/arch/arm/mach-iop32x/iq80321.c b/arch/arm/mach-iop32x/iq80=
321.c
index 8d9f491..18ad29f 100644
--- a/arch/arm/mach-iop32x/iq80321.c
+++ b/arch/arm/mach-iop32x/iq80321.c
@@ -181,6 +181,9 @@ static void __init iq80321_init_machine(void)
 	platform_device_register(&iop3xx_i2c1_device);
 	platform_device_register(&iq80321_flash_device);
 	platform_device_register(&iq80321_serial_device);
+	platform_device_register(&iop3xx_dma_0_channel);
+	platform_device_register(&iop3xx_dma_1_channel);
+	platform_device_register(&iop3xx_aau_channel);
 }
=20
 MACHINE_START(IQ80321, "Intel IQ80321")
diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.=
c
index d55005d..390a97d 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -245,6 +245,8 @@ static void __init n2100_init_machine(void)
 	platform_device_register(&iop3xx_i2c0_device);
 	platform_device_register(&n2100_flash_device);
 	platform_device_register(&n2100_serial_device);
+	platform_device_register(&iop3xx_dma_0_channel);
+	platform_device_register(&iop3xx_dma_1_channel);
=20
 	pm_power_off =3D n2100_power_off;
=20
diff --git a/arch/arm/mach-iop33x/iq80331.c b/arch/arm/mach-iop33x/iq80=
331.c
index 2b06318..433188e 100644
--- a/arch/arm/mach-iop33x/iq80331.c
+++ b/arch/arm/mach-iop33x/iq80331.c
@@ -136,6 +136,9 @@ static void __init iq80331_init_machine(void)
 	platform_device_register(&iop33x_uart0_device);
 	platform_device_register(&iop33x_uart1_device);
 	platform_device_register(&iq80331_flash_device);
+	platform_device_register(&iop3xx_dma_0_channel);
+	platform_device_register(&iop3xx_dma_1_channel);
+	platform_device_register(&iop3xx_aau_channel);
 }
=20
 MACHINE_START(IQ80331, "Intel IQ80331")
diff --git a/arch/arm/mach-iop33x/iq80332.c b/arch/arm/mach-iop33x/iq80=
332.c
index 7889ce3..416c095 100644
--- a/arch/arm/mach-iop33x/iq80332.c
+++ b/arch/arm/mach-iop33x/iq80332.c
@@ -136,6 +136,9 @@ static void __init iq80332_init_machine(void)
 	platform_device_register(&iop33x_uart0_device);
 	platform_device_register(&iop33x_uart1_device);
 	platform_device_register(&iq80332_flash_device);
+	platform_device_register(&iop3xx_dma_0_channel);
+	platform_device_register(&iop3xx_dma_1_channel);
+	platform_device_register(&iop3xx_aau_channel);
 }
=20
 MACHINE_START(IQ80332, "Intel IQ80332")
diff --git a/arch/arm/plat-iop/Makefile b/arch/arm/plat-iop/Makefile
index 4d2b1da..36bff03 100644
--- a/arch/arm/plat-iop/Makefile
+++ b/arch/arm/plat-iop/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_ARCH_IOP32X) +=3D setup.o
 obj-$(CONFIG_ARCH_IOP32X) +=3D time.o
 obj-$(CONFIG_ARCH_IOP32X) +=3D io.o
 obj-$(CONFIG_ARCH_IOP32X) +=3D cp6.o
+obj-$(CONFIG_ARCH_IOP32X) +=3D adma.o
=20
 # IOP33X
 obj-$(CONFIG_ARCH_IOP33X) +=3D gpio.o
@@ -21,6 +22,7 @@ obj-$(CONFIG_ARCH_IOP33X) +=3D setup.o
 obj-$(CONFIG_ARCH_IOP33X) +=3D time.o
 obj-$(CONFIG_ARCH_IOP33X) +=3D io.o
 obj-$(CONFIG_ARCH_IOP33X) +=3D cp6.o
+obj-$(CONFIG_ARCH_IOP33X) +=3D adma.o
=20
 # IOP13XX
 obj-$(CONFIG_ARCH_IOP13XX) +=3D cp6.o
diff --git a/arch/arm/plat-iop/adma.c b/arch/arm/plat-iop/adma.c
new file mode 100644
index 0000000..53c5e9a
--- /dev/null
+++ b/arch/arm/plat-iop/adma.c
@@ -0,0 +1,209 @@
+/*
+ * platform device definitions for the iop3xx dma/xor engines
+ * Copyright =C2=A9 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITH=
OUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/platform_device.h>
+#include <asm/hardware/iop3xx.h>
+#include <linux/dma-mapping.h>
+#include <asm/arch/adma.h>
+#include <asm/hardware/iop_adma.h>
+
+#ifdef CONFIG_ARCH_IOP32X
+#define IRQ_DMA0_EOT IRQ_IOP32X_DMA0_EOT
+#define IRQ_DMA0_EOC IRQ_IOP32X_DMA0_EOC
+#define IRQ_DMA0_ERR IRQ_IOP32X_DMA0_ERR
+
+#define IRQ_DMA1_EOT IRQ_IOP32X_DMA1_EOT
+#define IRQ_DMA1_EOC IRQ_IOP32X_DMA1_EOC
+#define IRQ_DMA1_ERR IRQ_IOP32X_DMA1_ERR
+
+#define IRQ_AA_EOT IRQ_IOP32X_AA_EOT
+#define IRQ_AA_EOC IRQ_IOP32X_AA_EOC
+#define IRQ_AA_ERR IRQ_IOP32X_AA_ERR
+#endif
+#ifdef CONFIG_ARCH_IOP33X
+#define IRQ_DMA0_EOT IRQ_IOP33X_DMA0_EOT
+#define IRQ_DMA0_EOC IRQ_IOP33X_DMA0_EOC
+#define IRQ_DMA0_ERR IRQ_IOP33X_DMA0_ERR
+
+#define IRQ_DMA1_EOT IRQ_IOP33X_DMA1_EOT
+#define IRQ_DMA1_EOC IRQ_IOP33X_DMA1_EOC
+#define IRQ_DMA1_ERR IRQ_IOP33X_DMA1_ERR
+
+#define IRQ_AA_EOT IRQ_IOP33X_AA_EOT
+#define IRQ_AA_EOC IRQ_IOP33X_AA_EOC
+#define IRQ_AA_ERR IRQ_IOP33X_AA_ERR
+#endif
+/* AAU and DMA Channels */
+static struct resource iop3xx_dma_0_resources[] =3D {
+	[0] =3D {
+		.start =3D IOP3XX_DMA_PHYS_BASE(0),
+		.end =3D IOP3XX_DMA_UPPER_PA(0),
+		.flags =3D IORESOURCE_MEM,
+	},
+	[1] =3D {
+		.start =3D IRQ_DMA0_EOT,
+		.end =3D IRQ_DMA0_EOT,
+		.flags =3D IORESOURCE_IRQ
+	},
+	[2] =3D {
+		.start =3D IRQ_DMA0_EOC,
+		.end =3D IRQ_DMA0_EOC,
+		.flags =3D IORESOURCE_IRQ
+	},
+	[3] =3D {
+		.start =3D IRQ_DMA0_ERR,
+		.end =3D IRQ_DMA0_ERR,
+		.flags =3D IORESOURCE_IRQ
+	}
+};
+
+static struct resource iop3xx_dma_1_resources[] =3D {
+	[0] =3D {
+		.start =3D IOP3XX_DMA_PHYS_BASE(1),
+		.end =3D IOP3XX_DMA_UPPER_PA(1),
+		.flags =3D IORESOURCE_MEM,
+	},
+	[1] =3D {
+		.start =3D IRQ_DMA1_EOT,
+		.end =3D IRQ_DMA1_EOT,
+		.flags =3D IORESOURCE_IRQ
+	},
+	[2] =3D {
+		.start =3D IRQ_DMA1_EOC,
+		.end =3D IRQ_DMA1_EOC,
+		.flags =3D IORESOURCE_IRQ
+	},
+	[3] =3D {
+		.start =3D IRQ_DMA1_ERR,
+		.end =3D IRQ_DMA1_ERR,
+		.flags =3D IORESOURCE_IRQ
+	}
+};
+
+
+static struct resource iop3xx_aau_resources[] =3D {
+	[0] =3D {
+		.start =3D IOP3XX_AAU_PHYS_BASE,
+		.end =3D IOP3XX_AAU_UPPER_PA,
+		.flags =3D IORESOURCE_MEM,
+	},
+	[1] =3D {
+		.start =3D IRQ_AA_EOT,
+		.end =3D IRQ_AA_EOT,
+		.flags =3D IORESOURCE_IRQ
+	},
+	[2] =3D {
+		.start =3D IRQ_AA_EOC,
+		.end =3D IRQ_AA_EOC,
+		.flags =3D IORESOURCE_IRQ
+	},
+	[3] =3D {
+		.start =3D IRQ_AA_ERR,
+		.end =3D IRQ_AA_ERR,
+		.flags =3D IORESOURCE_IRQ
+	}
+};
+
+static u64 iop3xx_adma_dmamask =3D DMA_32BIT_MASK;
+
+static struct iop_adma_platform_data iop3xx_dma_0_data =3D {
+	.hw_id =3D DMA0_ID,
+	.pool_size =3D PAGE_SIZE,
+};
+
+static struct iop_adma_platform_data iop3xx_dma_1_data =3D {
+	.hw_id =3D DMA1_ID,
+	.pool_size =3D PAGE_SIZE,
+};
+
+static struct iop_adma_platform_data iop3xx_aau_data =3D {
+	.hw_id =3D AAU_ID,
+	.pool_size =3D 3 * PAGE_SIZE,
+};
+
+struct platform_device iop3xx_dma_0_channel =3D {
+	.name =3D "iop-adma",
+	.id =3D 0,
+	.num_resources =3D 4,
+	.resource =3D iop3xx_dma_0_resources,
+	.dev =3D {
+		.dma_mask =3D &iop3xx_adma_dmamask,
+		.coherent_dma_mask =3D DMA_64BIT_MASK,
+		.platform_data =3D (void *) &iop3xx_dma_0_data,
+	},
+};
+
+struct platform_device iop3xx_dma_1_channel =3D {
+	.name =3D "iop-adma",
+	.id =3D 1,
+	.num_resources =3D 4,
+	.resource =3D iop3xx_dma_1_resources,
+	.dev =3D {
+		.dma_mask =3D &iop3xx_adma_dmamask,
+		.coherent_dma_mask =3D DMA_64BIT_MASK,
+		.platform_data =3D (void *) &iop3xx_dma_1_data,
+	},
+};
+
+struct platform_device iop3xx_aau_channel =3D {
+	.name =3D "iop-adma",
+	.id =3D 2,
+	.num_resources =3D 4,
+	.resource =3D iop3xx_aau_resources,
+	.dev =3D {
+		.dma_mask =3D &iop3xx_adma_dmamask,
+		.coherent_dma_mask =3D DMA_64BIT_MASK,
+		.platform_data =3D (void *) &iop3xx_aau_data,
+	},
+};
+
+static int __init iop3xx_adma_cap_init(void)
+{
+	#ifdef CONFIG_ARCH_IOP32X /* the 32x DMA does not perform CRC32C */
+	dma_cap_set(DMA_MEMCPY, iop3xx_dma_0_data.cap_mask);
+	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_0_data.cap_mask);
+	#else
+	dma_cap_set(DMA_MEMCPY, iop3xx_dma_0_data.cap_mask);
+	dma_cap_set(DMA_MEMCPY_CRC32C, iop3xx_dma_0_data.cap_mask);
+	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_0_data.cap_mask);
+	#endif
+
+	#ifdef CONFIG_ARCH_IOP32X /* the 32x DMA does not perform CRC32C */
+	dma_cap_set(DMA_MEMCPY, iop3xx_dma_1_data.cap_mask);
+	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_1_data.cap_mask);
+	#else
+	dma_cap_set(DMA_MEMCPY, iop3xx_dma_1_data.cap_mask);
+	dma_cap_set(DMA_MEMCPY_CRC32C, iop3xx_dma_1_data.cap_mask);
+	dma_cap_set(DMA_INTERRUPT, iop3xx_dma_1_data.cap_mask);
+	#endif
+
+	#ifdef CONFIG_ARCH_IOP32X /* the 32x AAU does not perform zero sum */
+	dma_cap_set(DMA_XOR, iop3xx_aau_data.cap_mask);
+	dma_cap_set(DMA_MEMSET, iop3xx_aau_data.cap_mask);
+	dma_cap_set(DMA_INTERRUPT, iop3xx_aau_data.cap_mask);
+	#else
+	dma_cap_set(DMA_XOR, iop3xx_aau_data.cap_mask);
+	dma_cap_set(DMA_ZERO_SUM, iop3xx_aau_data.cap_mask);
+	dma_cap_set(DMA_MEMSET, iop3xx_aau_data.cap_mask);
+	dma_cap_set(DMA_INTERRUPT, iop3xx_aau_data.cap_mask);
+	#endif
+
+	return 0;
+}
+
+arch_initcall(iop3xx_adma_cap_init);
diff --git a/include/asm-arm/arch-iop32x/adma.h b/include/asm-arm/arch-=
iop32x/adma.h
new file mode 100644
index 0000000..5ed9203
--- /dev/null
+++ b/include/asm-arm/arch-iop32x/adma.h
@@ -0,0 +1,5 @@
+#ifndef IOP32X_ADMA_H
+#define IOP32X_ADMA_H
+#include <asm/hardware/iop3xx-adma.h>
+#endif
+
diff --git a/include/asm-arm/arch-iop33x/adma.h b/include/asm-arm/arch-=
iop33x/adma.h
new file mode 100644
index 0000000..4b92f79
--- /dev/null
+++ b/include/asm-arm/arch-iop33x/adma.h
@@ -0,0 +1,5 @@
+#ifndef IOP33X_ADMA_H
+#define IOP33X_ADMA_H
+#include <asm/hardware/iop3xx-adma.h>
+#endif
+
diff --git a/include/asm-arm/hardware/iop3xx-adma.h b/include/asm-arm/h=
ardware/iop3xx-adma.h
new file mode 100644
index 0000000..cb321b2
--- /dev/null
+++ b/include/asm-arm/hardware/iop3xx-adma.h
@@ -0,0 +1,891 @@
+/*
+ * Copyright =C2=A9 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITH=
OUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License a=
long with
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
+/* Memory copy units */
+#define DMA_CCR(chan)		(chan->mmr_base + 0x0)
+#define DMA_CSR(chan)		(chan->mmr_base + 0x4)
+#define DMA_DAR(chan)		(chan->mmr_base + 0xc)
+#define DMA_NDAR(chan)		(chan->mmr_base + 0x10)
+#define DMA_PADR(chan)		(chan->mmr_base + 0x14)
+#define DMA_PUADR(chan)	(chan->mmr_base + 0x18)
+#define DMA_LADR(chan)		(chan->mmr_base + 0x1c)
+#define DMA_BCR(chan)		(chan->mmr_base + 0x20)
+#define DMA_DCR(chan)		(chan->mmr_base + 0x24)
+
+/* Application accelerator unit  */
+#define AAU_ACR(chan)		(chan->mmr_base + 0x0)
+#define AAU_ASR(chan)		(chan->mmr_base + 0x4)
+#define AAU_ADAR(chan)		(chan->mmr_base + 0x8)
+#define AAU_ANDAR(chan)	(chan->mmr_base + 0xc)
+#define AAU_SAR(src, chan)	(chan->mmr_base + (0x10 + ((src) << 2)))
+#define AAU_DAR(chan)		(chan->mmr_base + 0x20)
+#define AAU_ABCR(chan)		(chan->mmr_base + 0x24)
+#define AAU_ADCR(chan)		(chan->mmr_base + 0x28)
+#define AAU_SAR_EDCR(src_edc)	(chan->mmr_base + (0x02c + ((src_edc-4) =
<< 2)))
+#define AAU_EDCR0_IDX	8
+#define AAU_EDCR1_IDX	17
+#define AAU_EDCR2_IDX	26
+
+#define DMA0_ID 0
+#define DMA1_ID 1
+#define AAU_ID 2
+
+struct iop3xx_aau_desc_ctrl {
+	unsigned int int_en:1;
+	unsigned int blk1_cmd_ctrl:3;
+	unsigned int blk2_cmd_ctrl:3;
+	unsigned int blk3_cmd_ctrl:3;
+	unsigned int blk4_cmd_ctrl:3;
+	unsigned int blk5_cmd_ctrl:3;
+	unsigned int blk6_cmd_ctrl:3;
+	unsigned int blk7_cmd_ctrl:3;
+	unsigned int blk8_cmd_ctrl:3;
+	unsigned int blk_ctrl:2;
+	unsigned int dual_xor_en:1;
+	unsigned int tx_complete:1;
+	unsigned int zero_result_err:1;
+	unsigned int zero_result_en:1;
+	unsigned int dest_write_en:1;
+};
+
+struct iop3xx_aau_e_desc_ctrl {
+	unsigned int reserved:1;
+	unsigned int blk1_cmd_ctrl:3;
+	unsigned int blk2_cmd_ctrl:3;
+	unsigned int blk3_cmd_ctrl:3;
+	unsigned int blk4_cmd_ctrl:3;
+	unsigned int blk5_cmd_ctrl:3;
+	unsigned int blk6_cmd_ctrl:3;
+	unsigned int blk7_cmd_ctrl:3;
+	unsigned int blk8_cmd_ctrl:3;
+	unsigned int reserved2:7;
+};
+
+struct iop3xx_dma_desc_ctrl {
+	unsigned int pci_transaction:4;
+	unsigned int int_en:1;
+	unsigned int dac_cycle_en:1;
+	unsigned int mem_to_mem_en:1;
+	unsigned int crc_data_tx_en:1;
+	unsigned int crc_gen_en:1;
+	unsigned int crc_seed_dis:1;
+	unsigned int reserved:21;
+	unsigned int crc_tx_complete:1;
+};
+
+struct iop3xx_desc_dma {
+	u32 next_desc;
+	union {
+		u32 pci_src_addr;
+		u32 pci_dest_addr;
+		u32 src_addr;
+	};
+	union {
+		u32 upper_pci_src_addr;
+		u32 upper_pci_dest_addr;
+	};
+	union {
+		u32 local_pci_src_addr;
+		u32 local_pci_dest_addr;
+		u32 dest_addr;
+	};
+	u32 byte_count;
+	union {
+		u32 desc_ctrl;
+		struct iop3xx_dma_desc_ctrl desc_ctrl_field;
+	};
+	u32 crc_addr;
+};
+
+struct iop3xx_desc_aau {
+	u32 next_desc;
+	u32 src[4];
+	u32 dest_addr;
+	u32 byte_count;
+	union {
+		u32 desc_ctrl;
+		struct iop3xx_aau_desc_ctrl desc_ctrl_field;
+	};
+	union {
+		u32 src_addr;
+		u32 e_desc_ctrl;
+		struct iop3xx_aau_e_desc_ctrl e_desc_ctrl_field;
+	} src_edc[31];
+};
+
+struct iop3xx_aau_gfmr {
+	unsigned int gfmr1:8;
+	unsigned int gfmr2:8;
+	unsigned int gfmr3:8;
+	unsigned int gfmr4:8;
+};
+
+struct iop3xx_desc_pq_xor {
+	u32 next_desc;
+	u32 src[3];
+	union {
+		u32 data_mult1;
+		struct iop3xx_aau_gfmr data_mult1_field;
+	};
+	u32 dest_addr;
+	u32 byte_count;
+	union {
+		u32 desc_ctrl;
+		struct iop3xx_aau_desc_ctrl desc_ctrl_field;
+	};
+	union {
+		u32 src_addr;
+		u32 e_desc_ctrl;
+		struct iop3xx_aau_e_desc_ctrl e_desc_ctrl_field;
+		u32 data_multiplier;
+		struct iop3xx_aau_gfmr data_mult_field;
+		u32 reserved;
+	} src_edc_gfmr[19];
+};
+
+struct iop3xx_desc_dual_xor {
+	u32 next_desc;
+	u32 src0_addr;
+	u32 src1_addr;
+	u32 h_src_addr;
+	u32 d_src_addr;
+	u32 h_dest_addr;
+	u32 byte_count;
+	union {
+		u32 desc_ctrl;
+		struct iop3xx_aau_desc_ctrl desc_ctrl_field;
+	};
+	u32 d_dest_addr;
+};
+
+union iop3xx_desc {
+	struct iop3xx_desc_aau *aau;
+	struct iop3xx_desc_dma *dma;
+	struct iop3xx_desc_pq_xor *pq_xor;
+	struct iop3xx_desc_dual_xor *dual_xor;
+	void *ptr;
+};
+
+static inline int iop_adma_get_max_xor(void)
+{
+	return 32;
+}
+
+static inline u32 iop_chan_get_current_descriptor(struct iop_adma_chan=
 *chan)
+{
+	int id =3D chan->device->id;
+
+	switch (id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return __raw_readl(DMA_DAR(chan));
+	case AAU_ID:
+		return __raw_readl(AAU_ADAR(chan));
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+static inline void iop_chan_set_next_descriptor(struct iop_adma_chan *=
chan,
+						u32 next_desc_addr)
+{
+	int id =3D chan->device->id;
+
+	switch (id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		__raw_writel(next_desc_addr, DMA_NDAR(chan));
+		break;
+	case AAU_ID:
+		__raw_writel(next_desc_addr, AAU_ANDAR(chan));
+		break;
+	}
+
+}
+
+#define IOP_ADMA_STATUS_BUSY (1 << 10)
+#define IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT (1024)
+#define IOP_ADMA_XOR_MAX_BYTE_COUNT (16 * 1024 * 1024)
+#define IOP_ADMA_MAX_BYTE_COUNT (16 * 1024 * 1024)
+
+static inline int iop_chan_is_busy(struct iop_adma_chan *chan)
+{
+	u32 status =3D __raw_readl(DMA_CSR(chan));
+	return (status & IOP_ADMA_STATUS_BUSY) ? 1 : 0;
+}
+
+static inline int iop_desc_is_aligned(struct iop_adma_desc_slot *desc,
+					int num_slots)
+{
+	/* num_slots will only ever be 1, 2, 4, or 8 */
+	return (desc->idx & (num_slots - 1)) ? 0 : 1;
+}
+
+/* to do: support large (i.e. > hw max) buffer sizes */
+static inline int iop_chan_memcpy_slot_count(size_t len, int *slots_pe=
r_op)
+{
+	*slots_per_op =3D 1;
+	return 1;
+}
+
+/* to do: support large (i.e. > hw max) buffer sizes */
+static inline int iop_chan_memset_slot_count(size_t len, int *slots_pe=
r_op)
+{
+	*slots_per_op =3D 1;
+	return 1;
+}
+
+static inline int iop3xx_aau_xor_slot_count(size_t len, int src_cnt,
+					int *slots_per_op)
+{
+	const static int slot_count_table[] =3D { 0,
+						1, 1, 1, 1, /* 01 - 04 */
+						2, 2, 2, 2, /* 05 - 08 */
+						4, 4, 4, 4, /* 09 - 12 */
+						4, 4, 4, 4, /* 13 - 16 */
+						8, 8, 8, 8, /* 17 - 20 */
+						8, 8, 8, 8, /* 21 - 24 */
+						8, 8, 8, 8, /* 25 - 28 */
+						8, 8, 8, 8, /* 29 - 32 */
+					      };
+	*slots_per_op =3D slot_count_table[src_cnt];
+	return *slots_per_op;
+}
+
+static inline int
+iop_chan_interrupt_slot_count(int *slots_per_op, struct iop_adma_chan =
*chan)
+{
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return iop_chan_memcpy_slot_count(0, slots_per_op);
+	case AAU_ID:
+		return iop3xx_aau_xor_slot_count(0, 2, slots_per_op);
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+static inline int iop_chan_xor_slot_count(size_t len, int src_cnt,
+						int *slots_per_op)
+{
+	int slot_cnt =3D iop3xx_aau_xor_slot_count(len, src_cnt, slots_per_op=
);
+
+	if (len <=3D IOP_ADMA_XOR_MAX_BYTE_COUNT)
+		return slot_cnt;
+
+	len -=3D IOP_ADMA_XOR_MAX_BYTE_COUNT;
+	while (len > IOP_ADMA_XOR_MAX_BYTE_COUNT) {
+		len -=3D IOP_ADMA_XOR_MAX_BYTE_COUNT;
+		slot_cnt +=3D *slots_per_op;
+	}
+
+	if (len)
+		slot_cnt +=3D *slots_per_op;
+
+	return slot_cnt;
+}
+
+/* zero sum on iop3xx is limited to 1k at a time so it requires multip=
le
+ * descriptors
+ */
+static inline int iop_chan_zero_sum_slot_count(size_t len, int src_cnt=
,
+						int *slots_per_op)
+{
+	int slot_cnt =3D iop3xx_aau_xor_slot_count(len, src_cnt, slots_per_op=
);
+
+	if (len <=3D IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT)
+		return slot_cnt;
+
+	len -=3D IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT;
+	while (len > IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT) {
+		len -=3D IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT;
+		slot_cnt +=3D *slots_per_op;
+	}
+
+	if (len)
+		slot_cnt +=3D *slots_per_op;
+
+	return slot_cnt;
+}
+
+static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *de=
sc,
+					struct iop_adma_chan *chan)
+{
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return hw_desc.dma->dest_addr;
+	case AAU_ID:
+		return hw_desc.aau->dest_addr;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+static inline u32 iop_desc_get_byte_count(struct iop_adma_desc_slot *d=
esc,
+					struct iop_adma_chan *chan)
+{
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return hw_desc.dma->byte_count;
+	case AAU_ID:
+		return hw_desc.aau->byte_count;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+/* translate the src_idx to a descriptor word index */
+static inline int __desc_idx(int src_idx)
+{
+	const static int desc_idx_table[] =3D { 0, 0, 0, 0,
+					      0, 1, 2, 3,
+					      5, 6, 7, 8,
+					      9, 10, 11, 12,
+					      14, 15, 16, 17,
+					      18, 19, 20, 21,
+					      23, 24, 25, 26,
+					      27, 28, 29, 30,
+					    };
+
+	return desc_idx_table[src_idx];
+}
+
+static inline u32 iop_desc_get_src_addr(struct iop_adma_desc_slot *des=
c,
+					struct iop_adma_chan *chan,
+					int src_idx)
+{
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return hw_desc.dma->src_addr;
+	case AAU_ID:
+		break;
+	default:
+		BUG();
+	}
+
+	if (src_idx < 4)
+		return hw_desc.aau->src[src_idx];
+	else
+		return hw_desc.aau->src_edc[__desc_idx(src_idx)].src_addr;
+}
+
+static inline void iop3xx_aau_desc_set_src_addr(struct iop3xx_desc_aau=
 *hw_desc,
+					int src_idx, dma_addr_t addr)
+{
+	if (src_idx < 4)
+		hw_desc->src[src_idx] =3D addr;
+	else
+		hw_desc->src_edc[__desc_idx(src_idx)].src_addr =3D addr;
+}
+
+static inline void
+iop_desc_init_memcpy(struct iop_adma_desc_slot *desc, int int_en)
+{
+	struct iop3xx_desc_dma *hw_desc =3D desc->hw_desc;
+	union {
+		u32 value;
+		struct iop3xx_dma_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value =3D 0;
+	u_desc_ctrl.field.mem_to_mem_en =3D 1;
+	u_desc_ctrl.field.pci_transaction =3D 0xe; /* memory read block */
+	u_desc_ctrl.field.int_en =3D int_en;
+	hw_desc->desc_ctrl =3D u_desc_ctrl.value;
+	hw_desc->upper_pci_src_addr =3D 0;
+	hw_desc->crc_addr =3D 0;
+}
+
+static inline void
+iop_desc_init_memset(struct iop_adma_desc_slot *desc, int int_en)
+{
+	struct iop3xx_desc_aau *hw_desc =3D desc->hw_desc;
+	union {
+		u32 value;
+		struct iop3xx_aau_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value =3D 0;
+	u_desc_ctrl.field.blk1_cmd_ctrl =3D 0x2; /* memory block fill */
+	u_desc_ctrl.field.dest_write_en =3D 1;
+	u_desc_ctrl.field.int_en =3D int_en;
+	hw_desc->desc_ctrl =3D u_desc_ctrl.value;
+}
+
+static inline u32
+iop3xx_desc_init_xor(struct iop3xx_desc_aau *hw_desc, int src_cnt, int=
 int_en)
+{
+	int i, shift;
+	u32 edcr;
+	union {
+		u32 value;
+		struct iop3xx_aau_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value =3D 0;
+	switch (src_cnt) {
+	case 25 ... 32:
+		u_desc_ctrl.field.blk_ctrl =3D 0x3; /* use EDCR[2:0] */
+		edcr =3D 0;
+		shift =3D 1;
+		for (i =3D 24; i < src_cnt; i++) {
+			edcr |=3D (1 << shift);
+			shift +=3D 3;
+		}
+		hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl =3D edcr;
+		src_cnt =3D 24;
+		/* fall through */
+	case 17 ... 24:
+		if (!u_desc_ctrl.field.blk_ctrl) {
+			hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl =3D 0;
+			u_desc_ctrl.field.blk_ctrl =3D 0x3; /* use EDCR[2:0] */
+		}
+		edcr =3D 0;
+		shift =3D 1;
+		for (i =3D 16; i < src_cnt; i++) {
+			edcr |=3D (1 << shift);
+			shift +=3D 3;
+		}
+		hw_desc->src_edc[AAU_EDCR1_IDX].e_desc_ctrl =3D edcr;
+		src_cnt =3D 16;
+		/* fall through */
+	case 9 ... 16:
+		if (!u_desc_ctrl.field.blk_ctrl)
+			u_desc_ctrl.field.blk_ctrl =3D 0x2; /* use EDCR0 */
+		edcr =3D 0;
+		shift =3D 1;
+		for (i =3D 8; i < src_cnt; i++) {
+			edcr |=3D (1 << shift);
+			shift +=3D 3;
+		}
+		hw_desc->src_edc[AAU_EDCR0_IDX].e_desc_ctrl =3D edcr;
+		src_cnt =3D 8;
+		/* fall through */
+	case 2 ... 8:
+		shift =3D 1;
+		for (i =3D 0; i < src_cnt; i++) {
+			u_desc_ctrl.value |=3D (1 << shift);
+			shift +=3D 3;
+		}
+
+		if (!u_desc_ctrl.field.blk_ctrl && src_cnt > 4)
+			u_desc_ctrl.field.blk_ctrl =3D 0x1; /* use mini-desc */
+	}
+
+	u_desc_ctrl.field.dest_write_en =3D 1;
+	u_desc_ctrl.field.blk1_cmd_ctrl =3D 0x7; /* direct fill */
+	u_desc_ctrl.field.int_en =3D int_en;
+	hw_desc->desc_ctrl =3D u_desc_ctrl.value;
+
+	return u_desc_ctrl.value;
+}
+
+static inline void
+iop_desc_init_xor(struct iop_adma_desc_slot *desc, int src_cnt, int in=
t_en)
+{
+	iop3xx_desc_init_xor(desc->hw_desc, src_cnt, int_en);
+}
+
+/* return the number of operations */
+static inline int
+iop_desc_init_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt, i=
nt int_en)
+{
+	int slot_cnt =3D desc->slot_cnt, slots_per_op =3D desc->slots_per_op;
+	struct iop3xx_desc_aau *hw_desc, *prev_hw_desc, *iter;
+	union {
+		u32 value;
+		struct iop3xx_aau_desc_ctrl field;
+	} u_desc_ctrl;
+	int i, j;
+
+	hw_desc =3D desc->hw_desc;
+
+	for (i =3D 0, j =3D 0; (slot_cnt -=3D slots_per_op) >=3D 0;
+		i +=3D slots_per_op, j++) {
+		iter =3D iop_hw_desc_slot_idx(hw_desc, i);
+		u_desc_ctrl.value =3D iop3xx_desc_init_xor(iter, src_cnt, int_en);
+		u_desc_ctrl.field.dest_write_en =3D 0;
+		u_desc_ctrl.field.zero_result_en =3D 1;
+		u_desc_ctrl.field.int_en =3D int_en;
+		iter->desc_ctrl =3D u_desc_ctrl.value;
+
+		/* for the subsequent descriptors preserve the store queue
+		 * and chain them together
+		 */
+		if (i) {
+			prev_hw_desc =3D
+				iop_hw_desc_slot_idx(hw_desc, i - slots_per_op);
+			prev_hw_desc->next_desc =3D (u32) (desc->phys + (i << 5));
+		}
+	}
+
+	return j;
+}
+
+static inline void
+iop_desc_init_null_xor(struct iop_adma_desc_slot *desc, int src_cnt, i=
nt int_en)
+{
+	struct iop3xx_desc_aau *hw_desc =3D desc->hw_desc;
+	union {
+		u32 value;
+		struct iop3xx_aau_desc_ctrl field;
+	} u_desc_ctrl;
+
+	u_desc_ctrl.value =3D 0;
+	switch (src_cnt) {
+	case 25 ... 32:
+		u_desc_ctrl.field.blk_ctrl =3D 0x3; /* use EDCR[2:0] */
+		hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl =3D 0;
+		/* fall through */
+	case 17 ... 24:
+		if (!u_desc_ctrl.field.blk_ctrl) {
+			hw_desc->src_edc[AAU_EDCR2_IDX].e_desc_ctrl =3D 0;
+			u_desc_ctrl.field.blk_ctrl =3D 0x3; /* use EDCR[2:0] */
+		}
+		hw_desc->src_edc[AAU_EDCR1_IDX].e_desc_ctrl =3D 0;
+		/* fall through */
+	case 9 ... 16:
+		if (!u_desc_ctrl.field.blk_ctrl)
+			u_desc_ctrl.field.blk_ctrl =3D 0x2; /* use EDCR0 */
+		hw_desc->src_edc[AAU_EDCR0_IDX].e_desc_ctrl =3D 0;
+		/* fall through */
+	case 1 ... 8:
+		if (!u_desc_ctrl.field.blk_ctrl && src_cnt > 4)
+			u_desc_ctrl.field.blk_ctrl =3D 0x1; /* use mini-desc */
+	}
+
+	u_desc_ctrl.field.dest_write_en =3D 0;
+	u_desc_ctrl.field.int_en =3D int_en;
+	hw_desc->desc_ctrl =3D u_desc_ctrl.value;
+}
+
+static inline void iop_desc_set_byte_count(struct iop_adma_desc_slot *=
desc,
+					struct iop_adma_chan *chan,
+					u32 byte_count)
+{
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		hw_desc.dma->byte_count =3D byte_count;
+		break;
+	case AAU_ID:
+		hw_desc.aau->byte_count =3D byte_count;
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline void
+iop_desc_init_interrupt(struct iop_adma_desc_slot *desc,
+			struct iop_adma_chan *chan)
+{
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		iop_desc_init_memcpy(desc, 1);
+		hw_desc.dma->byte_count =3D 0;
+		hw_desc.dma->dest_addr =3D 0;
+		hw_desc.dma->src_addr =3D 0;
+		break;
+	case AAU_ID:
+		iop_desc_init_null_xor(desc, 2, 1);
+		hw_desc.aau->byte_count =3D 0;
+		hw_desc.aau->dest_addr =3D 0;
+		hw_desc.aau->src[0] =3D 0;
+		hw_desc.aau->src[1] =3D 0;
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline void
+iop_desc_set_zero_sum_byte_count(struct iop_adma_desc_slot *desc, u32 =
len)
+{
+	int slots_per_op =3D desc->slots_per_op;
+	struct iop3xx_desc_aau *hw_desc =3D desc->hw_desc, *iter;
+	int i =3D 0;
+
+	if (len <=3D IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT) {
+		hw_desc->byte_count =3D len;
+	} else {
+		do {
+			iter =3D iop_hw_desc_slot_idx(hw_desc, i);
+			iter->byte_count =3D IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT;
+			len -=3D IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT;
+			i +=3D slots_per_op;
+		} while (len > IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT);
+
+		if (len) {
+			iter =3D iop_hw_desc_slot_idx(hw_desc, i);
+			iter->byte_count =3D len;
+		}
+	}
+}
+
+static inline void iop_desc_set_dest_addr(struct iop_adma_desc_slot *d=
esc,
+					struct iop_adma_chan *chan,
+					dma_addr_t addr)
+{
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		hw_desc.dma->dest_addr =3D addr;
+		break;
+	case AAU_ID:
+		hw_desc.aau->dest_addr =3D addr;
+		break;
+	default:
+		BUG();
+	}
+}
+
+static inline void iop_desc_set_memcpy_src_addr(struct iop_adma_desc_s=
lot *desc,
+					dma_addr_t addr)
+{
+	struct iop3xx_desc_dma *hw_desc =3D desc->hw_desc;
+	hw_desc->src_addr =3D addr;
+}
+
+static inline void
+iop_desc_set_zero_sum_src_addr(struct iop_adma_desc_slot *desc, int sr=
c_idx,
+				dma_addr_t addr)
+{
+
+	struct iop3xx_desc_aau *hw_desc =3D desc->hw_desc, *iter;
+	int slot_cnt =3D desc->slot_cnt, slots_per_op =3D desc->slots_per_op;
+	int i;
+
+	for (i =3D 0; (slot_cnt -=3D slots_per_op) >=3D 0;
+		i +=3D slots_per_op, addr +=3D IOP_ADMA_ZERO_SUM_MAX_BYTE_COUNT) {
+		iter =3D iop_hw_desc_slot_idx(hw_desc, i);
+		iop3xx_aau_desc_set_src_addr(iter, src_idx, addr);
+	}
+}
+
+static inline void iop_desc_set_xor_src_addr(struct iop_adma_desc_slot=
 *desc,
+					int src_idx, dma_addr_t addr)
+{
+
+	struct iop3xx_desc_aau *hw_desc =3D desc->hw_desc, *iter;
+	int slot_cnt =3D desc->slot_cnt, slots_per_op =3D desc->slots_per_op;
+	int i;
+
+	for (i =3D 0; (slot_cnt -=3D slots_per_op) >=3D 0;
+		i +=3D slots_per_op, addr +=3D IOP_ADMA_XOR_MAX_BYTE_COUNT) {
+		iter =3D iop_hw_desc_slot_idx(hw_desc, i);
+		iop3xx_aau_desc_set_src_addr(iter, src_idx, addr);
+	}
+}
+
+static inline void iop_desc_set_next_desc(struct iop_adma_desc_slot *d=
esc,
+					u32 next_desc_addr)
+{
+	/* hw_desc->next_desc is the same location for all channels */
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+	BUG_ON(hw_desc.dma->next_desc);
+	hw_desc.dma->next_desc =3D next_desc_addr;
+}
+
+static inline u32 iop_desc_get_next_desc(struct iop_adma_desc_slot *de=
sc)
+{
+	/* hw_desc->next_desc is the same location for all channels */
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+	return hw_desc.dma->next_desc;
+}
+
+static inline void iop_desc_clear_next_desc(struct iop_adma_desc_slot =
*desc)
+{
+	/* hw_desc->next_desc is the same location for all channels */
+	union iop3xx_desc hw_desc =3D { .ptr =3D desc->hw_desc, };
+	hw_desc.dma->next_desc =3D 0;
+}
+
+static inline void iop_desc_set_block_fill_val(struct iop_adma_desc_sl=
ot *desc,
+						u32 val)
+{
+	struct iop3xx_desc_aau *hw_desc =3D desc->hw_desc;
+	hw_desc->src[0] =3D val;
+}
+
+static inline int iop_desc_get_zero_result(struct iop_adma_desc_slot *=
desc)
+{
+	struct iop3xx_desc_aau *hw_desc =3D desc->hw_desc;
+	struct iop3xx_aau_desc_ctrl desc_ctrl =3D hw_desc->desc_ctrl_field;
+
+	BUG_ON(!(desc_ctrl.tx_complete && desc_ctrl.zero_result_en));
+	return desc_ctrl.zero_result_err;
+}
+
+static inline void iop_chan_append(struct iop_adma_chan *chan)
+{
+	u32 dma_chan_ctrl;
+	/* workaround dropped interrupts on 3xx */
+	mod_timer(&chan->cleanup_watchdog, jiffies + msecs_to_jiffies(3));
+
+	dma_chan_ctrl =3D __raw_readl(DMA_CCR(chan));
+	dma_chan_ctrl |=3D 0x2;
+	__raw_writel(dma_chan_ctrl, DMA_CCR(chan));
+}
+
+static inline void iop_chan_idle(int busy, struct iop_adma_chan *chan)
+{
+	if (!busy)
+		del_timer(&chan->cleanup_watchdog);
+}
+
+static inline u32 iop_chan_get_status(struct iop_adma_chan *chan)
+{
+	return __raw_readl(DMA_CSR(chan));
+}
+
+static inline void iop_chan_disable(struct iop_adma_chan *chan)
+{
+	u32 dma_chan_ctrl =3D __raw_readl(DMA_CCR(chan));
+	dma_chan_ctrl &=3D ~1;
+	__raw_writel(dma_chan_ctrl, DMA_CCR(chan));
+}
+
+static inline void iop_chan_enable(struct iop_adma_chan *chan)
+{
+	u32 dma_chan_ctrl =3D __raw_readl(DMA_CCR(chan));
+
+	dma_chan_ctrl |=3D 1;
+	__raw_writel(dma_chan_ctrl, DMA_CCR(chan));
+}
+
+static inline void iop_adma_device_clear_eot_status(struct iop_adma_ch=
an *chan)
+{
+	u32 status =3D __raw_readl(DMA_CSR(chan));
+	status &=3D (1 << 9);
+	__raw_writel(status, DMA_CSR(chan));
+}
+
+static inline void iop_adma_device_clear_eoc_status(struct iop_adma_ch=
an *chan)
+{
+	u32 status =3D __raw_readl(DMA_CSR(chan));
+	status &=3D (1 << 8);
+	__raw_writel(status, DMA_CSR(chan));
+}
+
+static inline void iop_adma_device_clear_err_status(struct iop_adma_ch=
an *chan)
+{
+	u32 status =3D __raw_readl(DMA_CSR(chan));
+
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		status &=3D (1 << 5) | (1 << 3) | (1 << 2) | (1 << 1);
+		break;
+	case AAU_ID:
+		status &=3D (1 << 5);
+		break;
+	default:
+		BUG();
+	}
+
+	__raw_writel(status, DMA_CSR(chan));
+}
+
+static inline int
+iop_is_err_int_parity(unsigned long status, struct iop_adma_chan *chan=
)
+{
+	return 0;
+}
+
+static inline int
+iop_is_err_mcu_abort(unsigned long status, struct iop_adma_chan *chan)
+{
+	return 0;
+}
+
+static inline int
+iop_is_err_int_tabort(unsigned long status, struct iop_adma_chan *chan=
)
+{
+	return 0;
+}
+
+static inline int
+iop_is_err_int_mabort(unsigned long status, struct iop_adma_chan *chan=
)
+{
+	return test_bit(5, &status);
+}
+
+static inline int
+iop_is_err_pci_tabort(unsigned long status, struct iop_adma_chan *chan=
)
+{
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return test_bit(2, &status);
+	default:
+		return 0;
+	}
+}
+
+static inline int
+iop_is_err_pci_mabort(unsigned long status, struct iop_adma_chan *chan=
)
+{
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return test_bit(3, &status);
+	default:
+		return 0;
+	}
+}
+
+static inline int
+iop_is_err_split_tx(unsigned long status, struct iop_adma_chan *chan)
+{
+	switch (chan->device->id) {
+	case DMA0_ID:
+	case DMA1_ID:
+		return test_bit(1, &status);
+	default:
+		return 0;
+	}
+}
+#endif /* _ADMA_H */
diff --git a/include/asm-arm/hardware/iop3xx.h b/include/asm-arm/hardwa=
re/iop3xx.h
index 63feceb..81ca5d3 100644
--- a/include/asm-arm/hardware/iop3xx.h
+++ b/include/asm-arm/hardware/iop3xx.h
@@ -144,24 +144,9 @@ extern int init_atu;
 #define IOP3XX_IAR		(volatile u32 *)IOP3XX_REG_ADDR(0x0380)
=20
 /* DMA Controller  */
-#define IOP3XX_DMA0_CCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0400)
-#define IOP3XX_DMA0_CSR		(volatile u32 *)IOP3XX_REG_ADDR(0x0404)
-#define IOP3XX_DMA0_DAR		(volatile u32 *)IOP3XX_REG_ADDR(0x040c)
-#define IOP3XX_DMA0_NDAR	(volatile u32 *)IOP3XX_REG_ADDR(0x0410)
-#define IOP3XX_DMA0_PADR	(volatile u32 *)IOP3XX_REG_ADDR(0x0414)
-#define IOP3XX_DMA0_PUADR	(volatile u32 *)IOP3XX_REG_ADDR(0x0418)
-#define IOP3XX_DMA0_LADR	(volatile u32 *)IOP3XX_REG_ADDR(0x041c)
-#define IOP3XX_DMA0_BCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0420)
-#define IOP3XX_DMA0_DCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0424)
-#define IOP3XX_DMA1_CCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0440)
-#define IOP3XX_DMA1_CSR		(volatile u32 *)IOP3XX_REG_ADDR(0x0444)
-#define IOP3XX_DMA1_DAR		(volatile u32 *)IOP3XX_REG_ADDR(0x044c)
-#define IOP3XX_DMA1_NDAR	(volatile u32 *)IOP3XX_REG_ADDR(0x0450)
-#define IOP3XX_DMA1_PADR	(volatile u32 *)IOP3XX_REG_ADDR(0x0454)
-#define IOP3XX_DMA1_PUADR	(volatile u32 *)IOP3XX_REG_ADDR(0x0458)
-#define IOP3XX_DMA1_LADR	(volatile u32 *)IOP3XX_REG_ADDR(0x045c)
-#define IOP3XX_DMA1_BCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0460)
-#define IOP3XX_DMA1_DCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0464)
+#define IOP3XX_DMA_PHYS_BASE(chan) (IOP3XX_PERIPHERAL_PHYS_BASE + \
+					(0x400 + (chan << 6)))
+#define IOP3XX_DMA_UPPER_PA(chan)  (IOP3XX_DMA_PHYS_BASE(chan) + 0x27)
=20
 /* Peripheral bus interface  */
 #define IOP3XX_PBCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0680)
@@ -210,48 +195,8 @@ extern int init_atu;
 #define IOP_TMR_RATIO_1_1  0x00
=20
 /* Application accelerator unit  */
-#define IOP3XX_AAU_ACR		(volatile u32 *)IOP3XX_REG_ADDR(0x0800)
-#define IOP3XX_AAU_ASR		(volatile u32 *)IOP3XX_REG_ADDR(0x0804)
-#define IOP3XX_AAU_ADAR		(volatile u32 *)IOP3XX_REG_ADDR(0x0808)
-#define IOP3XX_AAU_ANDAR	(volatile u32 *)IOP3XX_REG_ADDR(0x080c)
-#define IOP3XX_AAU_SAR1		(volatile u32 *)IOP3XX_REG_ADDR(0x0810)
-#define IOP3XX_AAU_SAR2		(volatile u32 *)IOP3XX_REG_ADDR(0x0814)
-#define IOP3XX_AAU_SAR3		(volatile u32 *)IOP3XX_REG_ADDR(0x0818)
-#define IOP3XX_AAU_SAR4		(volatile u32 *)IOP3XX_REG_ADDR(0x081c)
-#define IOP3XX_AAU_DAR		(volatile u32 *)IOP3XX_REG_ADDR(0x0820)
-#define IOP3XX_AAU_ABCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0824)
-#define IOP3XX_AAU_ADCR		(volatile u32 *)IOP3XX_REG_ADDR(0x0828)
-#define IOP3XX_AAU_SAR5		(volatile u32 *)IOP3XX_REG_ADDR(0x082c)
-#define IOP3XX_AAU_SAR6		(volatile u32 *)IOP3XX_REG_ADDR(0x0830)
-#define IOP3XX_AAU_SAR7		(volatile u32 *)IOP3XX_REG_ADDR(0x0834)
-#define IOP3XX_AAU_SAR8		(volatile u32 *)IOP3XX_REG_ADDR(0x0838)
-#define IOP3XX_AAU_EDCR0	(volatile u32 *)IOP3XX_REG_ADDR(0x083c)
-#define IOP3XX_AAU_SAR9		(volatile u32 *)IOP3XX_REG_ADDR(0x0840)
-#define IOP3XX_AAU_SAR10	(volatile u32 *)IOP3XX_REG_ADDR(0x0844)
-#define IOP3XX_AAU_SAR11	(volatile u32 *)IOP3XX_REG_ADDR(0x0848)
-#define IOP3XX_AAU_SAR12	(volatile u32 *)IOP3XX_REG_ADDR(0x084c)
-#define IOP3XX_AAU_SAR13	(volatile u32 *)IOP3XX_REG_ADDR(0x0850)
-#define IOP3XX_AAU_SAR14	(volatile u32 *)IOP3XX_REG_ADDR(0x0854)
-#define IOP3XX_AAU_SAR15	(volatile u32 *)IOP3XX_REG_ADDR(0x0858)
-#define IOP3XX_AAU_SAR16	(volatile u32 *)IOP3XX_REG_ADDR(0x085c)
-#define IOP3XX_AAU_EDCR1	(volatile u32 *)IOP3XX_REG_ADDR(0x0860)
-#define IOP3XX_AAU_SAR17	(volatile u32 *)IOP3XX_REG_ADDR(0x0864)
-#define IOP3XX_AAU_SAR18	(volatile u32 *)IOP3XX_REG_ADDR(0x0868)
-#define IOP3XX_AAU_SAR19	(volatile u32 *)IOP3XX_REG_ADDR(0x086c)
-#define IOP3XX_AAU_SAR20	(volatile u32 *)IOP3XX_REG_ADDR(0x0870)
-#define IOP3XX_AAU_SAR21	(volatile u32 *)IOP3XX_REG_ADDR(0x0874)
-#define IOP3XX_AAU_SAR22	(volatile u32 *)IOP3XX_REG_ADDR(0x0878)
-#define IOP3XX_AAU_SAR23	(volatile u32 *)IOP3XX_REG_ADDR(0x087c)
-#define IOP3XX_AAU_SAR24	(volatile u32 *)IOP3XX_REG_ADDR(0x0880)
-#define IOP3XX_AAU_EDCR2	(volatile u32 *)IOP3XX_REG_ADDR(0x0884)
-#define IOP3XX_AAU_SAR25	(volatile u32 *)IOP3XX_REG_ADDR(0x0888)
-#define IOP3XX_AAU_SAR26	(volatile u32 *)IOP3XX_REG_ADDR(0x088c)
-#define IOP3XX_AAU_SAR27	(volatile u32 *)IOP3XX_REG_ADDR(0x0890)
-#define IOP3XX_AAU_SAR28	(volatile u32 *)IOP3XX_REG_ADDR(0x0894)
-#define IOP3XX_AAU_SAR29	(volatile u32 *)IOP3XX_REG_ADDR(0x0898)
-#define IOP3XX_AAU_SAR30	(volatile u32 *)IOP3XX_REG_ADDR(0x089c)
-#define IOP3XX_AAU_SAR31	(volatile u32 *)IOP3XX_REG_ADDR(0x08a0)
-#define IOP3XX_AAU_SAR32	(volatile u32 *)IOP3XX_REG_ADDR(0x08a4)
+#define IOP3XX_AAU_PHYS_BASE (IOP3XX_PERIPHERAL_PHYS_BASE + 0x800)
+#define IOP3XX_AAU_UPPER_PA (IOP3XX_AAU_PHYS_BASE + 0xa7)
=20
 /* I2C bus interface unit  */
 #define IOP3XX_ICR0		(volatile u32 *)IOP3XX_REG_ADDR(0x1680)
@@ -329,6 +274,9 @@ static inline void write_tisr(u32 val)
 	asm volatile("mcr p6, 0, %0, c6, c1, 0" : : "r" (val));
 }
=20
+extern struct platform_device iop3xx_dma_0_channel;
+extern struct platform_device iop3xx_dma_1_channel;
+extern struct platform_device iop3xx_aau_channel;
 extern struct platform_device iop3xx_i2c0_device;
 extern struct platform_device iop3xx_i2c1_device;
=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
