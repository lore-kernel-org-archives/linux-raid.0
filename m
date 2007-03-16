From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] [PPC32]  ADMA support for PPC 440SPe processors.
Date: Fri, 16 Mar 2007 09:29:18 +0100
Message-ID: <1174033758.6861.41.camel@localhost.localdomain>
References: <20070315232956.37DAB353A6C@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070315232956.37DAB353A6C@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi !

I'm short on time, so no really in-depth review right now, but a few
nits I've spotted while browsing the patch..

> static u64 ppc440spe_adma_dmamask = DMA_32BIT_MASK;
> +
> +/* DMA and XOR platform devices' resources */
> +static struct resource ppc440spe_dma_0_resources[] = {
> +	{
> +		.flags = IORESOURCE_MEM,
> +	},
> +	{
> +		.start = DMA0_CS_FIFO_NEED_SERVICE,
> +		.end = DMA0_CS_FIFO_NEED_SERVICE,
> +		.flags = IORESOURCE_IRQ
> +	}
> +};

   .../...

This is all very ugly, hopefully, can be replaced by a proper
device-tree representation in arch/powerpc. What are your plans for
porting 440SP/SPe over ?

> +/*
> + *  Init DMA0/1 and XOR engines; allocate memory for DMAx FIFOs; set platform_device
> + * memory resources addresses
> + */
> +static void ppc440spe_configure_raid_devices(void)
> +{
> +	void *fifo_buf;
> +	i2o_regs_t *i2o_reg;
> +	dma_regs_t *dma_reg0, *dma_reg1;
> +	xor_regs_t *xor_reg;
> +	u32 mask;
> +
> +	printk ("%s\n", __FUNCTION__);

The above should probably go...

> +	/*
> +	 * Map registers
> +	 */
> +	i2o_reg  = (i2o_regs_t *)ioremap64(I2O_MMAP_BASE, I2O_MMAP_SIZE);
> +	dma_reg0 = (dma_regs_t *)ioremap64(DMA0_MMAP_BASE, DMA_MMAP_SIZE);
> +	dma_reg1 = (dma_regs_t *)ioremap64(DMA1_MMAP_BASE, DMA_MMAP_SIZE);
> +	xor_reg  = (xor_regs_t *)ioremap64(XOR_MMAP_BASE,XOR_MMAP_SIZE);

You should test the result of these. Also, the move to arch/powerpc here
as well will cleanup as ioremap will always take 64 bits resource_size_t
(can't you make that working on arch/ppc too and use normal ioremap
there as well ?).

In addition, the casting is ugly and your types lack __iomem
annotations.

> +	/*
> +	 * Configure h/w
> +	 */
> +
> +	/* Reset I2O/DMA */
> +	mtdcr(DCRN_SDR0_CFGADDR, 0x200);
> +	mtdcr(DCRN_SDR0_CFGDATA, 0x10000);
> +	mtdcr(DCRN_SDR0_CFGADDR, 0x200);
> +	mtdcr(DCRN_SDR0_CFGDATA, 0x0);

The above could use some symbolic constants... Is this the only piece of
code to access the SDR0 indirect config registers ? If not, then some
global locking is needed as well.

(See my old thread about providing a global lock/mutex for that sort of
system wide, low pressure, config registers accesses).

> +	/* Reset XOR */
> +	out_be32(&xor_reg->crsr, XOR_CRSR_XASR_BIT);
> +	out_be32(&xor_reg->crrr, XOR_CRSR_64BA_BIT);
> +
> +	/* Setup the base address of mmaped registers */
> +	mtdcr(DCRN_I2O0_IBAH, 0x00000004);
> +	mtdcr(DCRN_I2O0_IBAL, 0x00100001);

Some symbolic constants here too, also am I right to assume you are hard
coding an address here ? That need at least some bold comments as there
seem to be no resource management involved to make sure that address
hasn't been used elsewhere.

That's also things that should be handled via the device-tree
hopefully. 

> +	/*  Provide memory regions for DMA's FIFOs: I2O, DMA0 and DMA1 share
> +	 * the base address of FIFO memory space
> +	 */
> +	fifo_buf = kmalloc((DMA0_FIFO_SIZE + DMA1_FIFO_SIZE)<<1, GFP_KERNEL | __GFP_DMA);

Error checking ? Also, what is the rationale for GFP_KERNEL | __GFP_DMA
here ? I don't think you need the later and probably not with
underscores if you do anyway.

> +	/* SetUp FIFO memory space base address */
> +	out_le32(&i2o_reg->ifbah, 0);
> +	out_le32(&i2o_reg->ifbal, ((u32)__pa(fifo_buf)));
>
> +	/* zero FIFO size for I2O, DMAs; 0x1000 to enable DMA */
> +	out_le32(&i2o_reg->ifsiz, 0);
> +	out_le32(&dma_reg0->fsiz, 0x1000 | ((DMA0_FIFO_SIZE>>3) - 1));
> +	out_le32(&dma_reg1->fsiz, 0x1000 | ((DMA1_FIFO_SIZE>>3) - 1));

Symbolicm constants ?

> +	/* Configure DMA engine */
> +	out_le32(&dma_reg0->cfg, 0x0D880000);
> +	out_le32(&dma_reg1->cfg, 0x0D880000);

Same ?

> +	/* Clear Status */
> +	out_le32(&dma_reg0->dsts, ~0);
> +	out_le32(&dma_reg1->dsts, ~0);
> +
> +	/* Unmask 'CS FIFO Attention' interrupts */
> +	mask = in_le32(&i2o_reg->iopim) & ~0x48;
> +	out_le32(&i2o_reg->iopim, mask);

Same ?

> +	/* enable XOR engine interrupt */
> +	out_be32(&xor_reg->ier, XOR_IE_CBLCI_BIT | XOR_IE_CBCIE_BIT | 0x34000);

Same ?

> +	PRINTK("\tfree slot %x: %d stride: %d\n", desc->phys, desc->idx, desc->stride);

Why don't you use the kernel existing debugging facilitie, like
pr_debug, or dev_dbg if you have a proper struct device (which you
should have with an arch/powerpc port hopefully using
of_platform_device).

> +	spin_lock_bh(&spe_chan->lock);
> +	/* Allocate descriptor slots */
> +	i = spe_chan->slots_allocated;
> +	if (spe_chan->device->id != PPC440SPE_XOR_ID)
> +		db_sz = sizeof (dma_cdb_t);
> +	else
> +		db_sz = sizeof (xor_cb_t);
> +
> +	for (; i < (plat_data->pool_size/db_sz); i++) {
> +		slot = kzalloc(sizeof(struct spe_adma_desc_slot), GFP_KERNEL);

GFP_KERNEL within spin_lock_bh is no good...
 
> diff --git a/include/asm-ppc/adma.h b/include/asm-ppc/adma.h
> new file mode 100644
> index 0000000..0be88f1
> --- /dev/null
> +++ b/include/asm-ppc/adma.h

There's way too many code in this .h file, too big inline functions. It
should mostly be moved to a .c file

Also, it's a bit rude to have a file called asm-ppc/adma.h that contains
ppc440SPe specific code without any guard. I don't care much about
asm-ppc for now but once that's moving to asm-powerpc, you might end up
with more than one platform doing ADMA differently and several of them
buildable in a single kernel, so keep that in mind.

> @@ -0,0 +1,715 @@
> +/*
> + * include/asm/ppc440spe_adma.h
> + 

Comment doesn't match file name. Just remove the comment anyway.

Cheers,
Ben.


