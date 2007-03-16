From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Fri, 16 Mar 2007 11:23:30 +0100
Message-ID: <20070316102330.88535352604@atlas.denx.de>
References: <1174033758.6861.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Fri, 16 Mar 2007 09:29:18 +0100."
             <1174033758.6861.41.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Ben,

in message <1174033758.6861.41.camel@localhost.localdomain> you wrote:
> 
> This is all very ugly, hopefully, can be replaced by a proper
> device-tree representation in arch/powerpc. What are your plans for
> porting 440SP/SPe over ?

We will start working on it as soon as  we  can  lay  fingers  on  an
arch/powerpc port for the 440SP/SPe...

> > +/*
> > + *  Init DMA0/1 and XOR engines; allocate memory for DMAx FIFOs; set platform_device
> > + * memory resources addresses
> > + */
> > +static void ppc440spe_configure_raid_devices(void)
> > +{
> > +	void *fifo_buf;
> > +	i2o_regs_t *i2o_reg;
> > +	dma_regs_t *dma_reg0, *dma_reg1;
> > +	xor_regs_t *xor_reg;
> > +	u32 mask;
> > +
> > +	printk ("%s\n", __FUNCTION__);
> 
> The above should probably go...

Agreed, sorry.

> > +	i2o_reg  = (i2o_regs_t *)ioremap64(I2O_MMAP_BASE, I2O_MMAP_SIZE);
> > +	dma_reg0 = (dma_regs_t *)ioremap64(DMA0_MMAP_BASE, DMA_MMAP_SIZE);
> > +	dma_reg1 = (dma_regs_t *)ioremap64(DMA1_MMAP_BASE, DMA_MMAP_SIZE);
> > +	xor_reg  = (xor_regs_t *)ioremap64(XOR_MMAP_BASE,XOR_MMAP_SIZE);
> 
> You should test the result of these. Also, the move to arch/powerpc here
> as well will cleanup as ioremap will always take 64 bits resource_size_t
> (can't you make that working on arch/ppc too and use normal ioremap
> there as well ?).
> 
> In addition, the casting is ugly and your types lack __iomem
> annotations.

Will fix. Thanks for pointing out.

> > +	mtdcr(DCRN_SDR0_CFGADDR, 0x200);
> > +	mtdcr(DCRN_SDR0_CFGDATA, 0x10000);
> > +	mtdcr(DCRN_SDR0_CFGADDR, 0x200);
> > +	mtdcr(DCRN_SDR0_CFGDATA, 0x0);
> 
> The above could use some symbolic constants... Is this the only piece of
> code to access the SDR0 indirect config registers ? If not, then some
> global locking is needed as well.
> 
> (See my old thread about providing a global lock/mutex for that sort of
> system wide, low pressure, config registers accesses).

Will check.

> > +	/* Setup the base address of mmaped registers */
> > +	mtdcr(DCRN_I2O0_IBAH, 0x00000004);
> > +	mtdcr(DCRN_I2O0_IBAL, 0x00100001);
> 
> Some symbolic constants here too, also am I right to assume you are hard
> coding an address here ? That need at least some bold comments as there
> seem to be no resource management involved to make sure that address
> hasn't been used elsewhere.

Will check.

> That's also things that should be handled via the device-tree
> hopefully. 

Agreed.

...
> > +	PRINTK("\tfree slot %x: %d stride: %d\n", desc->phys, desc->idx, desc->stride);
> 
> Why don't you use the kernel existing debugging facilitie, like
> pr_debug, or dev_dbg if you have a proper struct device (which you
> should have with an arch/powerpc port hopefully using
> of_platform_device).

You are right once more..

> > +	for (; i < (plat_data->pool_size/db_sz); i++) {
> > +		slot = kzalloc(sizeof(struct spe_adma_desc_slot), GFP_KERNEL);
> 
> GFP_KERNEL within spin_lock_bh is no good...

Thanks for poointing out

> > diff --git a/include/asm-ppc/adma.h b/include/asm-ppc/adma.h
> > new file mode 100644
> > index 0000000..0be88f1
> > --- /dev/null
> > +++ b/include/asm-ppc/adma.h
> 
> There's way too many code in this .h file, too big inline functions. It
> should mostly be moved to a .c file
> 
> Also, it's a bit rude to have a file called asm-ppc/adma.h that contains
> ppc440SPe specific code without any guard. I don't care much about

Agreed. Will rename.

> > + * include/asm/ppc440spe_adma.h
> 
> Comment doesn't match file name. Just remove the comment anyway.

...and change the file name.

Thanks for your valuable input. Will try to clean up.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH, HRB 165235 Munich, CEO: Wolfgang Denk
Office:  Kirchenstr. 5,       D-82194 Groebenzell,            Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Microsoft Multimedia:
You have nice graphics, sound and animations when the system crashes.
