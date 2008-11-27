From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 02/11] async_tx: add support for asynchronous GF
	multiplication
Date: Thu, 27 Nov 2008 04:26:29 +0300
Message-ID: <1115054880.20081127042629@emcraft.com>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
	<1226589364-5619-3-git-send-email-yanok@emcraft.com>
	<e9c3a7c20811141728m3fee8a00jb1be0f36fb852fdd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <e9c3a7c20811141728m3fee8a00jb1be0f36fb852fdd@mail.gmail.com>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids


 Hello Dan,

On Saturday, November 15, 2008 you wrote:

> A few comments

 Thanks.

> 1/ I don't see code for handling cases where the src_cnt exceeds the
> hardware maximum.

 Right, actually the ADMA devices we used (ppc440spe DMA engines) has 
no limitations on the src_cnt (well, actually there is the limit - the 
size of descriptors FIFO, but it's more than the number of drives 
which may be handled with the current RAID-6 driver, i.e. > 256), but 
I agree - the ASYNC_TX functions should not assume that any ADMA 
device will have such a feature. So we'll implement this, and then 
re-post the patches.

> 2/ dmaengine.h defines DMA_PQ_XOR but these patches should really
> change that to DMA_PQ and do s/pqxor/pq/ across the rest of the code
> base.

 OK.

> 3/ In my implementation (unfinished) of async_pq I decided to make the
> prototype:

 May I ask do you have in plans to finish and release your 
implementation?


> +/**
> + * async_pq - attempt to generate p (xor) and q (Reed-Solomon code) with a
> + *     dma engine for a given set of blocks.  This routine assumes a field of
> + *     GF(2^8) with a primitive polynomial of 0x11d and a generator of {02}.
> + *     In the synchronous case the p and q blocks are used as temporary
> + *     storage whereas dma engines have their own internal buffers.  The
> + *     ASYNC_TX_PQ_ZERO_P and ASYNC_TX_PQ_ZERO_Q flags clear the
> + *     destination(s) before they are used.
> + * @blocks: source block array ordered from 0..src_cnt with the p destination
> + *     at blocks[src_cnt] and q at blocks[src_cnt + 1]
> + *     NOTE: client code must assume the contents of this array are destroyed
> + * @offset: offset in pages to start transaction
> + * @src_cnt: number of source pages: 2 < src_cnt <= 255
> + * @len: length in bytes
> + * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
> + * @depend_tx: p+q operation depends on the result of this transaction.
> + * @cb_fn: function to call when p+q generation completes
> + * @cb_param: parameter to pass to the callback routine
> + */
> +struct dma_async_tx_descriptor *
> +async_pq(struct page **blocks, unsigned int offset, int src_cnt, size_t len,
> +        enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
> +        dma_async_tx_callback cb_fn, void *cb_param)

> Where p and q are not specified separately.  This matches more closely
> how the current gen_syndrome is specified with the goal of not
> requiring any changes to existing software raid6 interface.
> Thoughts?

 Understood. Our goal was to be more close to the ASYNC_TX interfaces, 
so we specified the destinations separately. Though I'm fine with your 
prototype, since doubling the same address is no good, so, we'll 
change this. 

 Any comments regarding the drivers/md/raid5.c part ?

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com
