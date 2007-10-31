From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: async_tx: get best channel
Date: Wed, 31 Oct 2007 21:58:54 +0400
Message-ID: <200710312058.54892.yur@emcraft.com>
References: <200710191623.34381.yur@emcraft.com> <1193163398.14140.24.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193163398.14140.24.camel@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hi Dan,

On Tuesday 23 October 2007 22:16, Dan Williams wrote:
...
> The problem with moving this test to async_tx_find_channel() is that it
> imposes extra overhead in the fast path.  It would be best if we could
> keep all these decisions in the slow path, or at least hide it from
> architectures that do not need to implement it.  The thing that makes
> this tricky is the fact that the speed is based on the source address...

 I agree with you that extra checking will impose extra overhead, but in my 
case this overhead is expected to be less than the improvement achieved due 
to using the more effective channel.

 In the worst case, the architectures which do not need to implement the 
device_estimate() method will have the overhead because of the following:
- passing two additional parameters to function async_tx_find_channel() (these 
are the source list and the number of sources),
- and checking one condition for (depend_tx->chan->device->device_estimate != 
0).

 I guess this is not such a big overhead. Right ?

> One question what are the source address restrictions, is it around
> high-memory?  

 No, it isn't. The condition which has to be met to run the most effective DMA 
is that the source addresses might be arranged in the following way:

 src0 = addr0,
 src1 = addr0 + 1*BLOCK_SIZE,
 src2 = addr0 + 2*BLOCK_SIZE,
 src3 = addr0 + 3*BLOCK_SIZE,
 src4 = addr0 + 4*BLOCK_SIZE,
 ...
 srcN = addr0 + N*BLOCK_SIZE.

> My thought is MD usually only operates on GFP_KERNEL 
> memory but sometimes sees high-memory when copying data into and out of
> the cache.  You might be able to achieve your use case by disabling
> (hiding) the XOR capability on the channels used for copying.  This will
> cause async_tx to switch the operation from the high memory capable copy
> channel to the fast low memory XOR channel.
> 
> Another way to approach this would be to implement architecture specific
> definitions of dma_channel_add_remove() and async_tx_rebalance().  This
> will bypass the default allocation scheme and allow you to assign the
> fastest channel to an operation, but it still does not allow for dynamic
> selection based on source/destination address...

 Understood. Thanks. Unfortunately, this is not the case, because the channels 
which may do the fast XOR operations support asynchronous COPY in my ADMA 
driver, so I guess even very very fast XOR will not help too much if I'll 
have no asynchronous COPY : )

 Regards, Yuri

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
