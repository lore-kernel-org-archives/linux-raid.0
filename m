From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] ppc440spe-adma: adds updated ppc440spe adma driver
Date: Mon, 23 Nov 2009 11:10:25 -0700
Message-ID: <4B0AD011.1070405@intel.com>
References: <1258467425-13968-1-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1258467425-13968-1-git-send-email-agust@denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Anatolij Gustschin <agust@denx.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, "wd@denx.de" <wd@denx.de>, "dzu@denx.de" <dzu@denx.de>
List-Id: linux-raid.ids

Anatolij Gustschin wrote:
> This patch adds new version of the PPC440SPe ADMA driver.
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>

As Josh said please don't drop attribution tags.  If you borrowed from 
Yuri's implementation you can forward his signed-off-by.

> ---
> Before applying this patch the following patch to katmai.dts
> should be applied first: http://patchwork.ozlabs.org/patch/36768/
> 
> The driver was updated to work with extended async_tx API.
> Comments to previous PPC440SPe ADMA driver versions submitted to
> the linuxppc-dev list were addressed. Please review and consider
> for inclusion. Thanks.
> 
>  .../powerpc/dts-bindings/4xx/ppc440spe-adma.txt    |   93 +
>  arch/powerpc/boot/dts/katmai.dts                   |   52 +-
>  arch/powerpc/include/asm/async_tx.h                |   47 +
>  arch/powerpc/include/asm/dcr-regs.h                |   26 +
>  arch/powerpc/include/asm/ppc440spe_adma.h          |  195 +
>  arch/powerpc/include/asm/ppc440spe_dma.h           |  224 +
>  arch/powerpc/include/asm/ppc440spe_xor.h           |  110 +
>  drivers/dma/Kconfig                                |   13 +
>  drivers/dma/Makefile                               |    1 +
>  drivers/dma/ppc440spe-adma.c                       | 4944 ++++++++++++++++++++
>  10 files changed, 5704 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
>  create mode 100644 arch/powerpc/include/asm/async_tx.h
>  create mode 100644 arch/powerpc/include/asm/ppc440spe_adma.h
>  create mode 100644 arch/powerpc/include/asm/ppc440spe_dma.h
>  create mode 100644 arch/powerpc/include/asm/ppc440spe_xor.h
>  create mode 100644 drivers/dma/ppc440spe-adma.c
[..]
> diff --git a/arch/powerpc/include/asm/ppc440spe_dma.h b/arch/powerpc/include/asm/ppc440spe_dma.h
> new file mode 100644
> index 0000000..7cce63e
> --- /dev/null
> +++ b/arch/powerpc/include/asm/ppc440spe_dma.h
[..]
> +/*
> + * DMAx hardware registers (p.515 in 440SPe UM 1.22)
> + */
> +typedef struct {
> +       u32     cpfpl;
> +       u32     cpfph;
> +       u32     csfpl;
> +       u32     csfph;
> +       u32     dsts;
> +       u32     cfg;
> +       u8      pad0[0x8];
> +       u16     cpfhp;
> +       u16     cpftp;
> +       u16     csfhp;
> +       u16     csftp;
> +       u8      pad1[0x8];
> +       u32     acpl;
> +       u32     acph;
> +       u32     s1bpl;
> +       u32     s1bph;
> +       u32     s2bpl;
> +       u32     s2bph;
> +       u32     s3bpl;
> +       u32     s3bph;
> +       u8      pad2[0x10];
> +       u32     earl;
> +       u32     earh;
> +       u8      pad3[0x8];
> +       u32     seat;
> +       u32     sead;
> +       u32     op;
> +       u32     fsiz;
> +} dma_regs_t;
> +
> +/*
> + * I2O hardware registers (p.528 in 440SPe UM 1.22)
> + */
> +typedef struct {
> +       u32     ists;
> +       u32     iseat;
> +       u32     isead;
> +       u8      pad0[0x14];
> +       u32     idbel;
> +       u8      pad1[0xc];
> +       u32     ihis;
> +       u32     ihim;
> +       u8      pad2[0x8];
> +       u32     ihiq;
> +       u32     ihoq;
> +       u8      pad3[0x8];
> +       u32     iopis;
> +       u32     iopim;
> +       u32     iopiq;
> +       u8      iopoq;
> +       u8      pad4[3];
> +       u16     iiflh;
> +       u16     iiflt;
> +       u16     iiplh;
> +       u16     iiplt;
> +       u16     ioflh;
> +       u16     ioflt;
> +       u16     ioplh;
> +       u16     ioplt;
> +       u32     iidc;
> +       u32     ictl;
> +       u32     ifcpp;
> +       u8      pad5[0x4];
> +       u16     mfac0;
> +       u16     mfac1;
> +       u16     mfac2;
> +       u16     mfac3;
> +       u16     mfac4;
> +       u16     mfac5;
> +       u16     mfac6;
> +       u16     mfac7;
> +       u16     ifcfh;
> +       u16     ifcht;
> +       u8      pad6[0x4];
> +       u32     iifmc;
> +       u32     iodb;
> +       u32     iodbc;
> +       u32     ifbal;
> +       u32     ifbah;
> +       u32     ifsiz;
> +       u32     ispd0;
> +       u32     ispd1;
> +       u32     ispd2;
> +       u32     ispd3;
> +       u32     ihipl;
> +       u32     ihiph;
> +       u32     ihopl;
> +       u32     ihoph;
> +       u32     iiipl;
> +       u32     iiiph;
> +       u32     iiopl;
> +       u32     iioph;
> +       u32     ifcpl;
> +       u32     ifcph;
> +       u8      pad7[0x8];
> +       u32     iopt;
> +} i2o_regs_t;

I saw the use of "volatile" in the driver code which lead me back here. 
  I think it is a reasonable expectation that all drivers use the 
accessors in asm/io.h to read/write mmio registers rather than volatile 
structure pointers.  PPC folks feel free to correct me if this is common 
practice for PPC drivers.

A side note, checkpatch rightly says "do not add new typedefs".

[..]
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 5903a88..854d594 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -109,6 +109,19 @@ config SH_DMAE
>         help
>           Enable support for the Renesas SuperH DMA controllers.
> 
> +config AMCC_PPC440SPE_ADMA
> +       tristate "AMCC PPC440SPe ADMA support"
> +       depends on 440SPe || 440SP
> +       select DMA_ENGINE
> +       select ASYNC_TX_DMA

The user should have the option to turn off dma support on a per dma 
client basis, so please remove "select ASYNC_TX_DMA".

> +       select ARCH_HAS_ASYNC_TX_FIND_CHANNEL
> +       default y

New options should never default to y (except for backwards 
compatibility).  This is better left to a defconfig.

> +       help
> +         Enable support for the AMCC PPC440SPe RAID engines.
> +
> +config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
> +       bool
> +
>  config DMA_ENGINE
>         bool
> 
[..]
> diff --git a/drivers/dma/ppc440spe-adma.c b/drivers/dma/ppc440spe-adma.c
> new file mode 100644
> index 0000000..40e5479
> --- /dev/null
> +++ b/drivers/dma/ppc440spe-adma.c
[..]
> +#ifdef ADMA_LL_DEBUG
> +static void print_cb(struct ppc440spe_adma_chan *chan, void *block)
> +{
> +       struct dma_cdb *cdb;
> +       xor_cb_t *cb;
> +       int i;
> +
> +       switch (chan->device->id) {
> +       case 0:
> +       case 1:
> +               cdb = block;
> +
> +               printk("CDB at %p [%d]:\n"
> +                       "\t attr 0x%02x opc 0x%02x cnt 0x%08x\n"
> +                       "\t sg1u 0x%08x sg1l 0x%08x\n"
> +                       "\t sg2u 0x%08x sg2l 0x%08x\n"
> +                       "\t sg3u 0x%08x sg3l 0x%08x\n",
> +                       cdb, chan->device->id,
> +                       cdb->attr, cdb->opc, le32_to_cpu(cdb->cnt),
> +                       le32_to_cpu(cdb->sg1u), le32_to_cpu(cdb->sg1l),
> +                       le32_to_cpu(cdb->sg2u), le32_to_cpu(cdb->sg2l),
> +                       le32_to_cpu(cdb->sg3u), le32_to_cpu(cdb->sg3l)

Debug ifdefs lead to code that does not get compile coverage and bitrots 
until someone later tries to debug.  Converting these printk() calls to 
pr_debug() gets rid of most, but not all of print_cb().  Perhaps look 
into the coh-dma driver's approach of wrapping calls to debug functions 
with something like:

#ifdef VERBOSE_DEBUG
#define COH_DBG(x) ({ if (1) x; 0; })
#else
#define COH_DBG(x) ({ if (0) x; 0; })
#endif

Converting to pr_debug or dev_dbg will also make checkpatch happy: 
"printk() should include KERN_ facility level".

> +               );
> +               break;
> +       case 2:
> +               cb = block;
> +
> +               printk("CB at %p [%d]:\n"
> +                       "\t cbc 0x%08x cbbc 0x%08x cbs 0x%08x\n"
> +                       "\t cbtah 0x%08x cbtal 0x%08x\n"
> +                       "\t cblah 0x%08x cblal 0x%08x\n",
> +                       cb, chan->device->id,
> +                       cb->cbc, cb->cbbc, cb->cbs,
> +                       cb->cbtah, cb->cbtal,
> +                       cb->cblah, cb->cblal);
> +               for (i = 0; i < 16; i++) {
> +                       if (i && !cb->ops[i].h && !cb->ops[i].l)
> +                               continue;
> +                       printk("\t ops[%2d]: h 0x%08x l 0x%08x\n",
> +                               i, cb->ops[i].h, cb->ops[i].l);
> +               }
> +               break;
> +       }
> +}
> +#endif
> +
[..]
> +/******************************************************************************
> + * ADMA channel low-level routines
> + ******************************************************************************/
> +
> +static inline u32
> +ppc440spe_chan_get_current_descriptor(struct ppc440spe_adma_chan *chan);
> +static inline void ppc440spe_chan_append(struct ppc440spe_adma_chan *chan);

sparse says:
drivers/dma/ppc440spe-adma.c:1078:41: error: marked inline, but without 
a definition
drivers/dma/ppc440spe-adma.c:1077:38: error: marked inline, but without 
a definition

[..]
> +/**
> + * ppc440spe_adma_prep_dma_pqzero_sum - prepare CDB group for
> + * a PQ_ZERO_SUM operation
> + */
> +static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_pqzero_sum(
> +               struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
> +               unsigned int src_cnt, const unsigned char *scf, size_t len,
> +               enum sum_check_flags *pqres, unsigned long flags)
> +{
> +       struct ppc440spe_adma_chan *ppc440spe_chan;
> +       struct ppc440spe_adma_desc_slot *sw_desc, *iter;
> +       dma_addr_t pdest, qdest;
> +       int slot_cnt, slots_per_op, idst, dst_cnt;
> +
> +       ppc440spe_chan = to_ppc440spe_adma_chan(chan);
> +
> +       if (flags & DMA_PREP_PQ_DISABLE_P)
> +               pdest = 0;
> +       else
> +               pdest = pq[0];
> +
> +       if (flags & DMA_PREP_PQ_DISABLE_Q)
> +               qdest = 0;
> +       else
> +               qdest = pq[1];
> +
> +#ifdef ADMA_LL_DEBUG
> +       printk("\n%s(%d):\n\tsrc(coef): ", __func__,
> +               ppc440spe_chan->device->id);
> +       for (idst = 0; idst < src_cnt; idst++)
> +               printk("0x%08x(0x%02x) ", src[idst], scf[idst]);
> +
> +       printk("\n\tdst: ");
> +       for (idst = 0; idst < 2; idst++)
> +               printk("0x%08x ", src[src_cnt+idst]);
> +       printk("\n");
> +       printk("\n%s: src_cnt %d\n", __func__, src_cnt);
> +#endif
> +
> +       /* Always use WXOR for P/Q calculations (two destinations).
> +        * Need 1 or 2 extra slots to verify results are zero.
> +        */
> +       idst = dst_cnt = (pdest && qdest) ? 2 : 1;
> +
> +       /* One additional slot per destination to clone P/Q
> +        * before calculation (we have to preserve destinations).
> +        */
> +       slot_cnt = src_cnt + dst_cnt * 2;
> +       slots_per_op = 1;
> +
> +       spin_lock_bh(&ppc440spe_chan->lock);
> +       sw_desc = ppc440spe_adma_alloc_slots(ppc440spe_chan, slot_cnt,
> +                                            slots_per_op);
> +       if (sw_desc) {
> +               ppc440spe_desc_init_dma01pqzero_sum(sw_desc, dst_cnt, src_cnt);

It looks like you emulate pqzero_sum operations with PAGE_SIZE temporary 
buffer.  Be sure to check 'len' because users of the api are allowed to 
submit > PAGE_SIZE requests.

[..]
> +static void ppc440spe_adma_init_capabilities(struct ppc440spe_adma_device *adev)
[..]
> +       if (dma_has_cap(DMA_PQ, adev->common.cap_mask)) {
> +               switch (adev->id) {
> +               case PPC440SPE_DMA0_ID:
> +                       adev->common.max_pq = DMA0_FIFO_SIZE /
> +                                               sizeof(dma_cdb_t);
> +                       break;
> +               case PPC440SPE_DMA1_ID:
> +                       adev->common.max_pq = DMA1_FIFO_SIZE /
> +                                               sizeof(dma_cdb_t);
> +                       break;
> +               case PPC440SPE_XOR_ID:
> +                       adev->common.max_pq = XOR_MAX_OPS * 3;
> +                       break;
> +               }
> +               adev->common.device_prep_dma_pq =
> +                       ppc440spe_adma_prep_dma_pq;
> +       }
> +       if (dma_has_cap(DMA_PQ_VAL, adev->common.cap_mask)) {
> +               switch (adev->id) {
> +               case PPC440SPE_DMA0_ID:
> +                       adev->common.max_pq = DMA0_FIFO_SIZE /
> +                                               sizeof(dma_cdb_t);
> +                       break;
> +               case PPC440SPE_DMA1_ID:
> +                       adev->common.max_pq = DMA1_FIFO_SIZE /
> +                                               sizeof(dma_cdb_t);
> +                       break;
> +               }
> +               adev->common.device_prep_dma_pq_val =
> +                       ppc440spe_adma_prep_dma_pqzero_sum;
> +       }

Please use dma_set_maxpq() when setting 'max_pq' above to make it clear 
whether this driver supports hardware continuation of pq operations. 
Otherwise the async_tx api will chop the number of sources it passes for 
operations larger than the hardware maximum.

