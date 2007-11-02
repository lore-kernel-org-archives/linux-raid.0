From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Bug in processing dependencies by async_tx_submit() ?
Date: Thu, 1 Nov 2007 17:36:50 -0700
Message-ID: <e9c3a7c20711011736idef37b4qf5e86b40930a2eb1@mail.gmail.com>
References: <200710311921.46609.yur@emcraft.com>
	 <1193886112.24616.18.camel@dwillia2-linux.ch.intel.com>
	 <200711011300.04546.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200711011300.04546.yur@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/1/07, Yuri Tikhonov <yur@emcraft.com> wrote:
>
>  Hi Dan,
>
>   Honestly I tried to fix this quickly using the approach similar to proposed
>  by you, with one addition though (in fact, deletion of BUG_ON(chan ==
>  tx->chan) in async_tx_run_dependencies()). And this led to "Kernel stack
>  overflow". This happened because of the recurseve calling async_tx_submit()
>  from async_trigger_callback() and vice verse.
>

I had a feeling the fix could not be that easy...

>   So, then I made the interrupt scheduling in async_tx_submit() only for the
>  cases when it is really needed: i.e. when dependent operations are to be run
>  on different channels.
>
>   The resulted kernel locked-up during processing of the mkfs command on the
>  top of the RAID-array. The place where it is spinning is the dma_sync_wait()
>  function.
>
>   This is happened because of the specific implementation of
>  dma_wait_for_async_tx().

So I take it you are not implementing interrupt based callbacks in your driver?

>   The "iter", we finally waiting for there, corresponds to the last allocated
>  but not-yet-submitted descriptor. But if the "iter" we are waiting for is
>  dependent from another descriptor which has cookie > 0, but is not yet
>  submitted to the h/w channel because of the fact that threshold is not
>  achieved to this moment, then we may wait in dma_wait_for_async_tx()
>  infinitely. I think that it makes more sense to get the first descriptor
>  which was submitted to the channel but probably is not put into the h/w
>  chain, i.e. with cookie > 0 and do dma_sync_wait() of this descriptor.
>
>   When I modified the dma_wait_for_async_tx() in such way, then the kernel
>  locking had disappeared. But nevertheless the mkfs processes hangs-up after
>  some time. So, it looks like something is still missing in support of the
>  chaining dependencies feature...
>

I am preparing a new patch that replaces ASYNC_TX_DEP_ACK with
ASYNC_TX_CHAIN_ACK.  The plan is to make the entire chain of
dependencies available up until the last transaction is submitted.
This allows the entire dependency chain to be walked at
async_tx_submit time so that we can properly handle these multiple
dependency cases.  I'll send it out when it passes my internal
tests...

--
Dan
