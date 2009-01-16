From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 11/11][v2] ppc440spe-adma: ADMA driver for PPC440SP(e) systems
Date: Fri, 16 Jan 2009 15:13:19 +0300
Message-ID: <775016772.20090116151319@emcraft.com>
References: <200901130343.56020.yur@emcraft.com> <20090115022446.GA30657@oksana.dev.rtsoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090115022446.GA30657@oksana.dev.rtsoft.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, wd@denx.de, dzu@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids



 Hello Anton,

 Thanks for review. Please note the general note I made in "Re[2]: 
[PATCH 11/11][v2] ppc440spe-adma: ADMA driver for PPC440SP(e) 
systems".

 All your comments make sense, so we'll try to address these in the 
next version of the driver. Some comments below.

On Thursday, January 15, 2009 you wrote:

> Hello Yuri,

> On Tue, Jan 13, 2009 at 03:43:55AM +0300, Yuri Tikhonov wrote:
>> Adds the platform device definitions and the architecture specific support
>> routines for the ppc440spe adma driver.
>> 
>> Any board equipped with PPC440SP(e) controller may utilize this driver.
>> 
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
>> ---

> Quite complex and interesting driver, I must say.
> Have you thought about splitting ppc440spe-adma.c into multiple
> files, btw?

 Admittedly, no. But I guess this makes sense. The driver supports two 
different types of DMA devices of ppc440spe: DMA0,1 and DMA2[XOR 
engine]. So, we could split the driver at least in two, which would 
definitely simplified the code. 

> A few comments down below...

> [...]
>> +typedef struct ppc440spe_adma_device {

> Please avoid typedefs.

 OK.

> [...]
>> +/*
>> + * Descriptor of allocated CDB
>> + */
>> +typedef struct {
>> +     dma_cdb_t               *vaddr; /* virtual address of CDB */
>> +     dma_addr_t              paddr;  /* physical address of CDB */
>> +     /*
>> +      * Additional fields
>> +      */
>> +     struct list_head        link;   /* link in processing list */
>> +     u32                     status; /* status of the CDB */
>> +     /* status bits:  */
>> +     #define DMA_CDB_DONE    (1<<0)  /* CDB processing competed */
>> +     #define DMA_CDB_CANCEL  (1<<1)  /* waiting thread was interrupted */
>> +} dma_cdbd_t;

> It seems there are no users of this struct.

 Indeed. This is an useless inheritance of some old version of the 
driver. Will remove this in the next patch.

[..]

>> +/**
>> + * ppc440spe_desc_init_dma01pq - initialize the descriptors for PQ operation
>> + * qith DMA0/1
>> + */
>> +static inline void ppc440spe_desc_init_dma01pq(ppc440spe_desc_t *desc,
>> +             int dst_cnt, int src_cnt, unsigned long flags,
>> +             unsigned long op)
>> +{

> Way to big for inline. The same for all the inlines.

> Btw, ppc_async_tx_find_best_channel() looks too big for inline
> and also too big to be in a .h file.

 OK, will be moved to the appropriate .c.

[..]

> [...]
>> +static int ppc440spe_test_raid6 (ppc440spe_ch_t *chan)
>> +{
>> +     ppc440spe_desc_t *sw_desc, *iter;
>> +     struct page *pg;
>> +     char *a;
>> +     dma_addr_t dma_addr, addrs[2];
>> +     unsigned long op = 0;
>> +     int rval = 0;
>> +
>> +     /*FIXME*/

> ?

>> +
>> +     set_bit(PPC440SPE_DESC_WXOR, &op);
>> +
>> +     pg = alloc_page(GFP_KERNEL);
>> +     if (!pg)
>> +             return -ENOMEM;
>> +

>> +
>> +/**
>> + * ppc440spe_adma_probe - probe the asynch device
>> + */
>> +static int __devinit ppc440spe_adma_probe(struct platform_device *pdev)
>> +{
>> +     struct resource *res;

> Why is this a platform driver? What's the point of describing
> DMA nodes in the device tree w/o actually using them (don't count
> interrupts)? There are a lot of hard-coded addresses in the code...
> :-/

> And arch/powerpc/platforms/44x/ppc440spe_dma_engines.c file
> reminds me arch/ppc-style bindings. ;-)

 Right. This driver is a not-completed port from the arch/ppc branch.

>> +     int ret=0, irq1, irq2, initcode = PPC_ADMA_INIT_OK;
>> +     void *regs;
>> +     ppc440spe_dev_t *adev;
>> +     ppc440spe_ch_t *chan;
>> +     ppc440spe_aplat_t *plat_data;
>> +     struct ppc_dma_chan_ref *ref;
>> +     struct device_node *dp;
>> +     char s[10];
>> +

> [...]
>> +static int __init ppc440spe_adma_init (void)
>> +{
>> +     int rval, i;
>> +     struct proc_dir_entry *p;
>> +
>> +     for (i = 0; i < PPC440SPE_ADMA_ENGINES_NUM; i++)
>> +             ppc_adma_devices[i] = -1;
>> +
>> +     rval = platform_driver_register(&ppc440spe_adma_driver);
>> +
>> +     if (rval == 0) {
>> +             /* Create /proc entries */
>> +             ppc440spe_proot = proc_mkdir(PPC440SPE_R6_PROC_ROOT, NULL);
>> +             if (!ppc440spe_proot) {
>> +                     printk(KERN_ERR "%s: failed to create %s proc "
>> +                         "directory\n",__func__,PPC440SPE_R6_PROC_ROOT);
>> +                     /* User will not be able to enable h/w RAID-6 */
>> +                     return rval;
>> +             }

> /proc? Why /proc? The driver has nothing to do with Linux VM subsystem
> or processes. I think /sys/ interface would suit better for this, no?
> Either way, userspace interfaces should be documented somehow
> (probably Documentation/ABI/, or at least some comments in the
> code).

 Agree, we'll fix this.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

