From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH] ppc440spe-adma: adds updated ppc440spe adma driver
Date: Fri, 20 Nov 2009 08:00:26 -0500
Message-ID: <20091120130026.GS30489@zod.rchland.ibm.com>
References: <1258467425-13968-1-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1258467425-13968-1-git-send-email-agust@denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, wd@denx.de, dzu@denx.de
List-Id: linux-raid.ids

On Tue, Nov 17, 2009 at 03:17:05PM +0100, Anatolij Gustschin wrote:
>This patch adds new version of the PPC440SPe ADMA driver.
>
>Signed-off-by: Anatolij Gustschin <agust@denx.de>

The driver author is listed as Yuri Tikhonov <yur@emcraft.com>.  Shouldn't
this include a sign-off from Yuri, or perhaps even a From?

>Before applying this patch the following patch to katmai.dts
>should be applied first: http://patchwork.ozlabs.org/patch/36768/

For the linux-raid people's benefit, I have that patch queued up in my next
branch.

> arch/powerpc/include/asm/async_tx.h                |   47 +
> arch/powerpc/include/asm/ppc440spe_adma.h          |  195 +
> arch/powerpc/include/asm/ppc440spe_dma.h           |  224 +
> arch/powerpc/include/asm/ppc440spe_xor.h           |  110 +

Why are these header files in the asm directory?  They seem to be only used
by your new driver, so why not have them under the drivers/dma or if you want
to be neat, drivers/dma/ppc440spe/ dirs?  I really don't think they should
be in asm at all.

>diff --git a/arch/powerpc/include/asm/dcr-regs.h b/arch/powerpc/include/asm/dcr-regs.h
>index 828e3aa..67d4069 100644
>--- a/arch/powerpc/include/asm/dcr-regs.h
>+++ b/arch/powerpc/include/asm/dcr-regs.h
>@@ -157,4 +157,30 @@
> #define  L2C_SNP_SSR_32G	0x0000f000
> #define  L2C_SNP_ESR		0x00000800
>
>+#define DCRN_SDR_CONFIG_ADDR	0xe
>+#define DCRN_SDR_CONFIG_DATA	0xf

These #defines already exist as DCRN_SDR0_CONFIG_{ADDR,DATA}.  We don't need
them defined again.

>+ * DCR register offsets for 440SP/440SPe I2O/DMA controller.
>+ * The base address is configured in the device tree.
>+ */
>+#define DCRN_I2O0_IBAL		0x006
>+#define DCRN_I2O0_IBAH		0x007
>+#define I2O_REG_ENABLE		0x00000001	/* Enable I2O/DMA access */
>+
>+/* 440SP/440SPe Software Reset DCR */
>+#define DCRN_SDR0_SRST		0x0200
>+#define DCRN_SDR0_SRST_I2ODMA	(0x80000000 >> 15)	/* Reset I2O/DMA */
>+
>+/* 440SP/440SPe Memory Queue DCR offsets */
>+#define DCRN_MQ0_XORBA		0x04
>+#define DCRN_MQ0_CF2H		0x06
>+#define DCRN_MQ0_CFBHL		0x0f
>+#define DCRN_MQ0_BAUH		0x10
>+
>+/* HB/LL Paths Configuration Register */
>+#define MQ0_CFBHL_TPLM		28
>+#define MQ0_CFBHL_HBCL		23
>+#define MQ0_CFBHL_POLY		15
>+
> #endif /* __DCR_REGS_H__ */

<snip>

>+ * Common initialisation for RAID engines; allocate memory for
>+ * DMAx FIFOs, perform configuration common for all DMA engines.
>+ * Further DMA engine specific configuration is done at probe time.
>+ */
>+static int ppc440spe_configure_raid_devices(void)
>+{
>+	struct device_node *np;
>+	struct resource i2o_res;
>+	i2o_regs_t __iomem *i2o_reg;
>+	const u32 *dcrreg;
>+	u32 dcrbase_i2o;
>+	int i, len, ret;
>+
>+	np = of_find_compatible_node(NULL, NULL, "ibm,i2o-440spe");
>+	if (!np) {
>+		pr_err("%s: can't find I2O device tree node\n",
>+			__func__);
>+		return -ENODEV;
>+	}
>+
>+	if (of_address_to_resource(np, 0, &i2o_res)) {
>+		of_node_put(np);
>+		return -EINVAL;
>+	}
>+
>+	i2o_reg = of_iomap(np, 0);
>+	if (!i2o_reg) {
>+		pr_err("%s: failed to map I2O registers\n", __func__);
>+		of_node_put(np);
>+		return -EINVAL;
>+	}
>+
>+	/* Get I2O DCRs base */
>+	dcrreg = of_get_property(np, "dcr-reg", &len);
>+	if (!dcrreg || (len != 2 * sizeof(u32))) {
>+		pr_err("%s: can't get DCR register base!\n",
>+			np->full_name);
>+		of_node_put(np);
>+		iounmap(i2o_reg);
>+		return -ENODEV;
>+	}
>+	of_node_put(np);
>+	dcrbase_i2o = dcrreg[0];
>+
>+	/* Provide memory regions for DMA's FIFOs: I2O, DMA0 and DMA1 share
>+	 * the base address of FIFO memory space.
>+	 * Actually we need twice more physical memory than programmed in the
>+	 * <fsiz> register (because there are two FIFOs for each DMA: CP and CS)
>+	 */
>+	ppc440spe_dma_fifo_buf = kmalloc((DMA0_FIFO_SIZE + DMA1_FIFO_SIZE) << 1,
>+					 GFP_KERNEL);
>+	if (!ppc440spe_dma_fifo_buf) {
>+		pr_err("%s: DMA FIFO buffer allocation failed.\n", __func__);
>+		iounmap(i2o_reg);
>+		return -ENOMEM;
>+	}
>+v
>+	/*
>+	 * Configure h/w
>+	 */
>+	/* Reset I2O/DMA */
>+	mtdcri(SDR, DCRN_SDR0_SRST, DCRN_SDR0_SRST_I2ODMA);
>+	mtdcri(SDR, DCRN_SDR0_SRST, 0);
>+
>+	/* Setup the base address of mmaped registers */
>+	mtdcr(dcrbase_i2o + DCRN_I2O0_IBAH, (u32)(i2o_res.start >> 32));
>+	mtdcr(dcrbase_i2o + DCRN_I2O0_IBAL, (u32)(i2o_res.start) |
>+					    I2O_REG_ENABLE);

It would be cleaner if you used the dcr_read/dcr_write functions instead
of the open coded mtdcr/mfdcr.  I don't think it's required though.

>+
>+	/* Setup FIFO memory space base address */
>+	out_le32(&i2o_reg->ifbah, 0);
>+	out_le32(&i2o_reg->ifbal, ((u32)__pa(ppc440spe_dma_fifo_buf)));

Similarly ioread32/iowrite32 instead of {out,in}_.

josh
