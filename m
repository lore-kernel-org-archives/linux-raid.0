From: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 11/11][v2] ppc440spe-adma: ADMA driver for PPC440SP(e)
	systems
Date: Thu, 15 Jan 2009 05:24:46 +0300
Message-ID: <20090115022446.GA30657@oksana.dev.rtsoft.ru>
References: <200901130343.56020.yur@emcraft.com>
Reply-To: avorontsov@ru.mvista.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200901130343.56020.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, wd@denx.de, dzu@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

Hello Yuri,

On Tue, Jan 13, 2009 at 03:43:55AM +0300, Yuri Tikhonov wrote:
> Adds the platform device definitions and the architecture specific support
> routines for the ppc440spe adma driver.
> 
> Any board equipped with PPC440SP(e) controller may utilize this driver.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
> ---

Quite complex and interesting driver, I must say.
Have you thought about splitting ppc440spe-adma.c into multiple
files, btw?


A few comments down below...

[...]
> +typedef struct ppc440spe_adma_device {

Please avoid typedefs.

[...]
> +/*
> + * Descriptor of allocated CDB
> + */
> +typedef struct {
> +	dma_cdb_t		*vaddr;	/* virtual address of CDB */
> +	dma_addr_t		paddr;	/* physical address of CDB */
> +	/*
> +	 * Additional fields
> +	 */
> +	struct list_head 	link;	/* link in processing list */
> +	u32			status;	/* status of the CDB */
> +	/* status bits:  */
> +	#define	DMA_CDB_DONE	(1<<0)	/* CDB processing competed */
> +	#define DMA_CDB_CANCEL	(1<<1)	/* waiting thread was interrupted */
> +} dma_cdbd_t;

It seems there are no users of this struct.

[...]
> +typedef struct {
> +	xor_cb_t		*vaddr;
> +	dma_addr_t		paddr;
> +
> +	/*
> +	 * Additional fields
> +	 */
> +	struct list_head	link;	/* link to processing CBs */
> +	u32			status;	/* status of the CB */
> +	/* status bits: */
> +	#define XOR_CB_DONE	(1<<0)	/* CB processing competed */
> +	#define XOR_CB_CANCEL	(1<<1)	/* waiting thread was interrupted */
> +#if 0
> +	#define XOR_CB_STALLOC	(1<<2)	/* CB allocated statically */
> +#endif

Dead code.

[...]
> +static void ppc440spe_configure_raid_devices(void)
> +{
> +	void *fifo_buf;
> +	volatile i2o_regs_t *i2o_reg;
> +	volatile dma_regs_t *dma_reg0, *dma_reg1;
> +	volatile xor_regs_t *xor_reg;
> +	u32 mask;
> +
> +	/*
> +	 * Map registers and allocate fifo buffer
> +	 */
> +	if (!(i2o_reg  = ioremap(I2O_MMAP_BASE, I2O_MMAP_SIZE))) {
> +		printk(KERN_ERR "I2O registers mapping failed.\n");
> +		return;
> +	}

i2o_reg  = ioremap(I2O_MMAP_BASE, I2O_MMAP_SIZE);
if (!i20_reg)
	...;

would look better.

> +	if (!(dma_reg0 = ioremap(DMA0_MMAP_BASE, DMA_MMAP_SIZE))) {
> +		printk(KERN_ERR "DMA0 registers mapping failed.\n");
> +		goto err1;
> +	}
> +	if (!(dma_reg1 = ioremap(DMA1_MMAP_BASE, DMA_MMAP_SIZE))) {
> +		printk(KERN_ERR "DMA1 registers mapping failed.\n");
> +		goto err2;
> +	}
> +	if (!(xor_reg  = ioremap(XOR_MMAP_BASE,XOR_MMAP_SIZE))) {
> +		printk(KERN_ERR "XOR registers mapping failed.\n");
> +		goto err3;
> +	}
[...]

> +static struct platform_device *ppc440spe_devs[] __initdata = {
> +	&ppc440spe_dma_0_channel,
> +	&ppc440spe_dma_1_channel,
> +	&ppc440spe_xor_channel,
> +};
> +
> +static int __init ppc440spe_register_raid_devices(void)
> +{
> +	ppc440spe_configure_raid_devices();
> +	platform_add_devices(ppc440spe_devs, ARRAY_SIZE(ppc440spe_devs));
> +
> +	return 0;
> +}
> +
> +arch_initcall(ppc440spe_register_raid_devices);
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index e34b064..19df08c 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -62,6 +62,19 @@ config MV_XOR
>  	---help---
>  	  Enable support for the Marvell XOR engine.
>  
> +config AMCC_PPC440SPE_ADMA
> +	tristate "AMCC PPC440SPe ADMA support"

It's a tristate, but module_exit() disabled with #if 0...

[...]
> +/******************************************************************************
> + * Command (Descriptor) Blocks low-level routines
> + ******************************************************************************/
> +/**
> + * ppc440spe_desc_init_interrupt - initialize the descriptor for INTERRUPT
> + * pseudo operation
> + */
> +static inline void ppc440spe_desc_init_interrupt (ppc440spe_desc_t *desc,
> +							ppc440spe_ch_t *chan)
> +{

Isn't this function way too big for inline?

> +	xor_cb_t *p;
> +
> +	switch (chan->device->id) {
> +	case PPC440SPE_XOR_ID:
> +		p = desc->hw_desc;
> +		memset (desc->hw_desc, 0, sizeof(xor_cb_t));
> +		/* NOP with Command Block Complete Enable */
> +		p->cbc = XOR_CBCR_CBCE_BIT;
> +		break;
> +	case PPC440SPE_DMA0_ID:
> +	case PPC440SPE_DMA1_ID:
> +		memset (desc->hw_desc, 0, sizeof(dma_cdb_t));
> +		/* NOP with interrupt */
> +		set_bit(PPC440SPE_DESC_INT, &desc->flags);
> +		break;
> +	default:
> +		printk(KERN_ERR "Unsupported id %d in %s\n", chan->device->id,
> +				__func__);
> +		break;
> +	}
> +}
> +
> +/**
> + * ppc440spe_desc_init_null_xor - initialize the descriptor for NULL XOR
> + * pseudo operation
> + */
> +static inline void ppc440spe_desc_init_null_xor(ppc440spe_desc_t *desc)
> +{

I'd drop the inline.

> +	memset (desc->hw_desc, 0, sizeof(xor_cb_t));
> +	desc->hw_next = NULL;
> +	desc->src_cnt = 0;
> +	desc->dst_cnt = 1;
> +}
> +
> +/**
> + * ppc440spe_desc_init_xor - initialize the descriptor for XOR operation
> + */
> +static inline void ppc440spe_desc_init_xor(ppc440spe_desc_t *desc, int src_cnt,
> +		unsigned long flags)
> +{

Ditto.

> +	xor_cb_t *hw_desc = desc->hw_desc;
> +
> +	memset (desc->hw_desc, 0, sizeof(xor_cb_t));
> +	desc->hw_next = NULL;
> +	desc->src_cnt = src_cnt;
> +	desc->dst_cnt = 1;
> +
> +	hw_desc->cbc = XOR_CBCR_TGT_BIT | src_cnt;
> +	if (flags & DMA_PREP_INTERRUPT)
> +		/* Enable interrupt on complete */
> +		hw_desc->cbc |= XOR_CBCR_CBCE_BIT;
> +}
> +
> +/**
> + * ppc440spe_desc_init_dma2pq - initialize the descriptor for PQ
> + * operation in DMA2 controller
> + */
> +static inline void ppc440spe_desc_init_dma2pq(ppc440spe_desc_t *desc,
> +		int dst_cnt, int src_cnt, unsigned long flags)
> +{

Ditto.

> +	xor_cb_t *hw_desc = desc->hw_desc;
> +
> +	memset (desc->hw_desc, 0, sizeof(xor_cb_t));
> +	desc->hw_next = NULL;
> +	desc->src_cnt = src_cnt;
> +	desc->dst_cnt = dst_cnt;
> +	memset (desc->reverse_flags, 0, sizeof (desc->reverse_flags));
> +	desc->descs_per_op = 0;
> +
> +	hw_desc->cbc = XOR_CBCR_TGT_BIT;
> +	if (flags & DMA_PREP_INTERRUPT)
> +		/* Enable interrupt on complete */
> +		hw_desc->cbc |= XOR_CBCR_CBCE_BIT;
> +}
> +
> +/**
> + * ppc440spe_desc_init_dma01pq - initialize the descriptors for PQ operation
> + * qith DMA0/1
> + */
> +static inline void ppc440spe_desc_init_dma01pq(ppc440spe_desc_t *desc,
> +		int dst_cnt, int src_cnt, unsigned long flags,
> +		unsigned long op)
> +{

Way to big for inline. The same for all the inlines.

Btw, ppc_async_tx_find_best_channel() looks too big for inline
and also too big to be in a .h file.

> +	dma_cdb_t *hw_desc;
> +	ppc440spe_desc_t *iter;
> +	u8 dopc;
> +
> +	/* Common initialization of a PQ descriptors chain */
> +	set_bits(op, &desc->flags);
> +	desc->src_cnt = src_cnt;
> +	desc->dst_cnt = dst_cnt;
> +
> +	/* WXOR MULTICAST if both P and Q are being computed
> +	 * MV_SG1_SG2 if Q only
> +	 */
> +	dopc = (desc->dst_cnt == DMA_DEST_MAX_NUM) ?
> +		DMA_CDB_OPC_MULTICAST : DMA_CDB_OPC_MV_SG1_SG2;
> +
> +	list_for_each_entry(iter, &desc->group_list, chain_node) {
> +		hw_desc = iter->hw_desc;
> +		memset (iter->hw_desc, 0, sizeof(dma_cdb_t));
> +
> +		if (likely(!list_is_last(&iter->chain_node,
> +				&desc->group_list))) {
> +			/* set 'next' pointer */
> +			iter->hw_next = list_entry(iter->chain_node.next,
> +				ppc440spe_desc_t, chain_node);
> +			clear_bit(PPC440SPE_DESC_INT, &iter->flags);
> +		} else {
> +			/* this is the last descriptor.
> +			 * this slot will be pasted from ADMA level
> +			 * each time it wants to configure parameters
> +			 * of the transaction (src, dst, ...)
> +			 */
> +			iter->hw_next = NULL;
> +			if (flags & DMA_PREP_INTERRUPT)
> +				set_bit(PPC440SPE_DESC_INT, &iter->flags);
> +			else
> +				clear_bit(PPC440SPE_DESC_INT, &iter->flags);
> +		}
> +	}
> +
> +	/* Set OPS depending on WXOR/RXOR type of operation */
> +	if (!test_bit(PPC440SPE_DESC_RXOR, &desc->flags)) {
> +		/* This is a WXOR only chain:
> +		 * - first descriptors are for zeroing destinations
> +		 *   if PPC440SPE_ZERO_P/Q set;
> +		 * - descriptors remained are for GF-XOR operations.
> +		 */
> +		iter = list_first_entry(&desc->group_list,
> +					ppc440spe_desc_t, chain_node);
> +
> +		if (test_bit(PPC440SPE_ZERO_P, &desc->flags)) {
> +			hw_desc = iter->hw_desc;
> +			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
> +			iter = list_first_entry(&iter->chain_node,
> +					ppc440spe_desc_t, chain_node);
> +		}
> +
> +		if (test_bit(PPC440SPE_ZERO_Q, &desc->flags)) {
> +			hw_desc = iter->hw_desc;
> +			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
> +			iter = list_first_entry(&iter->chain_node,
> +					ppc440spe_desc_t, chain_node);
> +		}
> +
> +		list_for_each_entry_from(iter, &desc->group_list, chain_node) {
> +			hw_desc = iter->hw_desc;
> +			hw_desc->opc = dopc;
> +		}
> +	} else {
> +		/* This is either RXOR-only or mixed RXOR/WXOR */
> +
> +		/* The first 1 or 2 slots in chain are always RXOR,
> +		 * if need to calculate P & Q, then there are two
> +		 * RXOR slots; if only P or only Q, then there is one
> +		 */
> +		iter = list_first_entry(&desc->group_list,
> +					ppc440spe_desc_t, chain_node);
> +		hw_desc = iter->hw_desc;
> +		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
> +
> +		if (desc->dst_cnt == DMA_DEST_MAX_NUM) {
> +			iter = list_first_entry(&iter->chain_node,
> +						ppc440spe_desc_t, chain_node);
> +			hw_desc = iter->hw_desc;
> +			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
> +		}
> +
> +		/* The remain descs (if any) are WXORs */
> +		if (test_bit(PPC440SPE_DESC_WXOR, &desc->flags)) {
> +			iter = list_first_entry(&iter->chain_node,
> +						ppc440spe_desc_t, chain_node);
> +			list_for_each_entry_from(iter, &desc->group_list,
> +						chain_node) {
> +				hw_desc = iter->hw_desc;
> +				hw_desc->opc = dopc;
> +			}
> +		}
> +	}
> +}

[...]
> +/**
> + * ppc440spe_chan_xor_slot_count - get the number of slots necessary for
> + * XOR operation

IIRC kerneldoc does not permit multiline short descriptions. Kdoc tools
will warn about it, I presume.

[...]
> +static int ppc440spe_test_raid6 (ppc440spe_ch_t *chan)
> +{
> +	ppc440spe_desc_t *sw_desc, *iter;
> +	struct page *pg;
> +	char *a;
> +	dma_addr_t dma_addr, addrs[2];
> +	unsigned long op = 0;
> +	int rval = 0;
> +
> +	/*FIXME*/

?

> +
> +	set_bit(PPC440SPE_DESC_WXOR, &op);
> +
> +	pg = alloc_page(GFP_KERNEL);
> +	if (!pg)
> +		return -ENOMEM;
> +

> +
> +/**
> + * ppc440spe_adma_probe - probe the asynch device
> + */
> +static int __devinit ppc440spe_adma_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;

Why is this a platform driver? What's the point of describing
DMA nodes in the device tree w/o actually using them (don't count
interrupts)? There are a lot of hard-coded addresses in the code...
:-/

And arch/powerpc/platforms/44x/ppc440spe_dma_engines.c file
reminds me arch/ppc-style bindings. ;-)

> +	int ret=0, irq1, irq2, initcode = PPC_ADMA_INIT_OK;
> +	void *regs;
> +	ppc440spe_dev_t *adev;
> +	ppc440spe_ch_t *chan;
> +	ppc440spe_aplat_t *plat_data;
> +	struct ppc_dma_chan_ref *ref;
> +	struct device_node *dp;
> +	char s[10];
> +

[...]
> +static int __init ppc440spe_adma_init (void)
> +{
> +	int rval, i;
> +	struct proc_dir_entry *p;
> +
> +	for (i = 0; i < PPC440SPE_ADMA_ENGINES_NUM; i++)
> +		ppc_adma_devices[i] = -1;
> +
> +	rval = platform_driver_register(&ppc440spe_adma_driver);
> +
> +	if (rval == 0) {
> +		/* Create /proc entries */
> +		ppc440spe_proot = proc_mkdir(PPC440SPE_R6_PROC_ROOT, NULL);
> +		if (!ppc440spe_proot) {
> +			printk(KERN_ERR "%s: failed to create %s proc "
> +			    "directory\n",__func__,PPC440SPE_R6_PROC_ROOT);
> +			/* User will not be able to enable h/w RAID-6 */
> +			return rval;
> +		}

/proc? Why /proc? The driver has nothing to do with Linux VM subsystem
or processes. I think /sys/ interface would suit better for this, no?
Either way, userspace interfaces should be documented somehow
(probably Documentation/ABI/, or at least some comments in the
code).

> +		/* GF polynome to use */
> +		p = create_proc_entry("poly", 0, ppc440spe_proot);
> +		if (p) {
> +			p->read_proc = ppc440spe_poly_read;
> +			p->write_proc = ppc440spe_poly_write;
> +		}
> +
> +		/* RAID-6 h/w enable entry */
> +		p = create_proc_entry("enable", 0, ppc440spe_proot);
> +		if (p) {
> +			p->read_proc = ppc440spe_r6ena_read;
> +			p->write_proc = ppc440spe_r6ena_write;
> +		}
> +
> +		/* initialization status */
> +		p = create_proc_entry("devices", 0, ppc440spe_proot);
> +		if (p) {
> +			p->read_proc = ppc440spe_status_read;
> +		}
> +	}
> +	return rval;
> +}

[...]
> +#if 0
> +static void __exit ppc440spe_adma_exit (void)
> +{
> +	platform_driver_unregister(&ppc440spe_adma_driver);
> +	return;
> +}
> +module_exit(ppc440spe_adma_exit);
> +#endif

Dead code.


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
`irc://irc.freenode.net/bd2
