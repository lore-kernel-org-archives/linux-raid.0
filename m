From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH] ASYNC_TX: async_xor mapping fix
Date: Wed, 10 Dec 2008 22:07:18 +0300
Message-ID: <724394867.20081210220718@emcraft.com>
References: <200812082214.26811.yur@emcraft.com> <1228770496.26373.3.camel@dwillia2-linux.ch.intel.com> <1228934826.1224.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228934826.1224.5.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, "dzu@denx.de" <dzu@denx.de>, "wd@denx.de" <wd@denx.de>, Ilya Yanok <yanok@emcraft.com>, Saeed Bishara <saeed@marvell.com>
List-Id: linux-raid.ids



 Hello Dan,

On Wednesday, December 10, 2008 you wrote:

> On Mon, 2008-12-08 at 14:08 -0700, Dan Williams wrote:
>> On Mon, 2008-12-08 at 12:14 -0700, Yuri Tikhonov wrote:
>> > The destination address may be present in the source list, so we should
>> > map the addresses from the source list first.
>> >  Otherwise, if page corresponding to destination is not marked as write-
>> > through (with regards to CPU cache), then mapping it with DMA_FROM_DEVICE
>> > may lead to data loss, and finally to an incorrect result of calculations.
>> > 
>> 
>> Thanks Yuri.  I think we should avoid mapping the destination twice
>> altogether, and for simplicity just always map it bidirectionally.

> Yuri, Saeed, can I get your acked-by's for the following 2.6.28 patch:

 I would do the "src_list[i] == dest" check with unlikely(), since we 
a-priori aware that only one of all src_cnt addresses is the possible 
destination.

 As for the rest:

Acked-by: Yuri Tikhonov <yur@emcraft.com>

> Thanks,
> Dan


----snip---->>
> async_xor: dma_map destination DMA_BIDIRECTIONAL

> From: Dan Williams <dan.j.williams@intel.com>

> Mapping the destination multiple times is a misuse of the dma-api.
> Since the destination may be reused as a source, ensure that it is only
> mapped once and that it is mapped bidirectionally.  This appears to add
> ugliness on the unmap side in that it always reads back the destination
> address from the descriptor, but gcc can determine that dma_unmap is a
> nop and not emit the code that calculates its arguments.

> Cc: <stable@kernel.org>
> Cc: Saeed Bishara <saeed@marvell.com>
> Reported-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/async_xor.c |   11 +++++++++--
>  drivers/dma/iop-adma.c      |   16 +++++++++++++---
>  drivers/dma/mv_xor.c        |   15 ++++++++++++---
>  3 files changed, 34 insertions(+), 8 deletions(-)

> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index c029d3e..a6faa90 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -53,10 +53,17 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
>         int xor_src_cnt;
>         dma_addr_t dma_dest;
>  
> -       dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_FROM_DEVICE);
> -       for (i = 0; i < src_cnt; i++)
> +       /* map the dest bidrectional in case it is re-used as a source */
> +       dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
> +       for (i = 0; i < src_cnt; i++) {
> +               /* only map the dest once */
> +               if (src_list[i] == dest) {
> +                       dma_src[i] = dma_dest;
> +                       continue;
> +               }
>                 dma_src[i] = dma_map_page(dma->dev, src_list[i], offset,
>                                           len, DMA_TO_DEVICE);
> +       }
>  
>         while (src_cnt) {
>                 async_flags = flags;
> diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
> index c7a9306..6be3172 100644
> --- a/drivers/dma/iop-adma.c
> +++ b/drivers/dma/iop-adma.c
> @@ -85,18 +85,28 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
>                         enum dma_ctrl_flags flags = desc->async_tx.flags;
>                         u32 src_cnt;
>                         dma_addr_t addr;
> +                       dma_addr_t dest;
>  
> +                       src_cnt = unmap->unmap_src_cnt;
> +                       dest = iop_desc_get_dest_addr(unmap, iop_chan);
>                         if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> -                               addr =
> iop_desc_get_dest_addr(unmap, iop_chan);
> -                               dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
> +                               enum dma_data_direction dir;
> +
> +                               if (src_cnt > 1) /* is xor? */
> +                                       dir = DMA_BIDIRECTIONAL;
> +                               else
> +                                       dir = DMA_FROM_DEVICE;
> +
> +                               dma_unmap_page(dev, dest, len, dir);
>                         }
>  
>                         if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> -                               src_cnt = unmap->unmap_src_cnt;
>                                 while (src_cnt--) {
>                                         addr = iop_desc_get_src_addr(unmap,
>                                                                     iop_chan,
>                                                                     src_cnt);
> +                                       if (addr == dest)
> +                                               continue;
>                                         dma_unmap_page(dev, addr, len,
>                                                        DMA_TO_DEVICE);
>                                 }
> diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
> index 0328da0..bcda174 100644
> --- a/drivers/dma/mv_xor.c
> +++ b/drivers/dma/mv_xor.c
> @@ -311,17 +311,26 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
>                         enum dma_ctrl_flags flags = desc->async_tx.flags;
>                         u32 src_cnt;
>                         dma_addr_t addr;
> +                       dma_addr_t dest;
>  
> +                       src_cnt = unmap->unmap_src_cnt;
> +                       dest = mv_desc_get_dest_addr(unmap);
>                         if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> -                               addr = mv_desc_get_dest_addr(unmap);
> -                               dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
> +                               enum dma_data_direction dir;
> +
> +                               if (src_cnt > 1) /* is xor ? */
> +                                       dir = DMA_BIDIRECTIONAL;
> +                               else
> +                                       dir = DMA_FROM_DEVICE;
> +                               dma_unmap_page(dev, dest, len, dir);
>                         }
>  
>                         if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> -                               src_cnt = unmap->unmap_src_cnt;
>                                 while (src_cnt--) {
>                                         addr = mv_desc_get_src_addr(unmap,
>                                                                     src_cnt);
> +                                       if (addr == dest)
> +                                               continue;
>                                         dma_unmap_page(dev, addr, len,
>                                                        DMA_TO_DEVICE);
>                                 }





 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

