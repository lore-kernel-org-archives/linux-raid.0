From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: async_tx: get best channel
Date: Tue, 23 Oct 2007 11:16:38 -0700
Message-ID: <1193163398.14140.24.camel@dwillia2-linux.ch.intel.com>
References: <200710191623.34381.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200710191623.34381.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-10-19 at 05:23 -0700, Yuri Tikhonov wrote:
> 
>  Hello Dan,

Hi Yuri, sorry it has taken me so long to get back to you...
> 
>  I have a suggestion regarding the async_tx_find_channel() procedure.
> 
>  First, a little introduction. Some processors (e.g. ppc440spe) have several DMA
> engines (say DMA1 and DMA2) which are capable of performing the same type of
> operation, say XOR. The DMA2 engine may process the XOR operation faster than
> the DMA1 engine, but DMA2 (which is faster) has some restrictions for the source
> operand addresses, whereas there are no such restrictions for DMA1 (which is slower).
> So the question is, how may ASYNC_TX select the DMA engine which will be the
> most effective for the given tx operation ?

>  In the example just described this means: if the faster engine, DMA2, may process
> the tx operation with the given source operand addresses, then we select DMA2;
> if the given source operand addresses cannot be processed with DMA2, then we
> select the slower engine, DMA1.
> 
>  I see the following way for introducing such functionality.
> 
>  We may introduce an additional method in struct dma_device (let's call it device_estimate())
> which would take the following as the arguments:
> --- the list of sources to be processed during the given tx,
> --- the type of operation (XOR, COPY, ...),
> --- perhaps something else,
>  and then estimate the effectiveness of processing this tx on the given channel.
>  The async_tx_find_channel() function should call the device_estimate() method for each
> registered dma channel and then select the most effective one.
>  The architecture specific ADMA driver will be responsible for returning the greatest
> value from the device_estimate() method for the channel which will be the most effective
> for this given tx.
> 
>  What are your thoughts regarding this? Do you see any other effective ways for
> enhancing ASYNC_TX with such functionality?

The problem with moving this test to async_tx_find_channel() is that it
imposes extra overhead in the fast path.  It would be best if we could
keep all these decisions in the slow path, or at least hide it from
architectures that do not need to implement it.  The thing that makes
this tricky is the fact that the speed is based on the source address...

One question what are the source address restrictions, is it around
high-memory?  My thought is MD usually only operates on GFP_KERNEL
memory but sometimes sees high-memory when copying data into and out of
the cache.  You might be able to achieve your use case by disabling
(hiding) the XOR capability on the channels used for copying.  This will
cause async_tx to switch the operation from the high memory capable copy
channel to the fast low memory XOR channel.

Another way to approach this would be to implement architecture specific
definitions of dma_channel_add_remove() and async_tx_rebalance().  This
will bypass the default allocation scheme and allow you to assign the
fastest channel to an operation, but it still does not allow for dynamic
selection based on source/destination address...

> 
>  Regards, Yuri
> 
Regards,
Dan
