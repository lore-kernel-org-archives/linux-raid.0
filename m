From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: Bug in processing dependencies by async_tx_submit() ?
Date: Fri, 2 Nov 2007 11:13:57 +0300
Message-ID: <200711021113.57471.yur@emcraft.com>
References: <200710311921.46609.yur@emcraft.com> <200711011300.04546.yur@emcraft.com> <e9c3a7c20711011736idef37b4qf5e86b40930a2eb1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20711011736idef37b4qf5e86b40930a2eb1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hi Dan,

On Friday 02 November 2007 03:36, Dan Williams wrote:
> >   This is happened because of the specific implementation of
> >  dma_wait_for_async_tx().
> 
> So I take it you are not implementing interrupt based callbacks in your 
driver?

 Why not ? I have interrupt based callbacks in my driver. An INTERRUPT 
descriptor, implemented for both (COPY and XOR) channels, does the callback 
upon its completion.

 Here is an example where your implementation of dma_wait_for_async_tx() will 
not work as expected. Let's we have OP1 <--depends on-- OP2 <--depends on-- 
OP3, where

 OP1: cookie = -EBUSY, channel = DMA0; <- not submitted
 OP2: cookie = -EBUSY, channel = DMA0; <- not submitted
 OP3: cookie = 101, channel = DMA1; <- submitted, but not linked to h/w

 where cookie == 101 is some valid, positive cookie; and this fact means that 
OP3 *was submitted* to the DMA1 channel but *perhaps was not linked* to the 
h/w chain, for example, because the threshold for DMA1 was not achieved yet.
 
 With your implementation of dma_wait_for_async_tx() we do dma_sync_wait(OP2). 
And I propose to do dma_sync_wait(OP3), because in your case we may never 
wait for OP2 completion since dma_sync_wait() flushes to h/w the chains of 
DMA0, but OP3 in DMA1 remains unlinked to h/w and it blocks all the chain of 
dependencies.

> >   The "iter", we finally waiting for there, corresponds to the last 
allocated
> >  but not-yet-submitted descriptor. But if the "iter" we are waiting for is
> >  dependent from another descriptor which has cookie > 0, but is not yet
> >  submitted to the h/w channel because of the fact that threshold is not
> >  achieved to this moment, then we may wait in dma_wait_for_async_tx()
> >  infinitely. I think that it makes more sense to get the first descriptor
> >  which was submitted to the channel but probably is not put into the h/w
> >  chain, i.e. with cookie > 0 and do dma_sync_wait() of this descriptor.
> >
> >   When I modified the dma_wait_for_async_tx() in such way, then the kernel
> >  locking had disappeared. But nevertheless the mkfs processes hangs-up 
after
> >  some time. So, it looks like something is still missing in support of the
> >  chaining dependencies feature...
> >
> 
> I am preparing a new patch that replaces ASYNC_TX_DEP_ACK with
> ASYNC_TX_CHAIN_ACK.  The plan is to make the entire chain of
> dependencies available up until the last transaction is submitted.
> This allows the entire dependency chain to be walked at
> async_tx_submit time so that we can properly handle these multiple
> dependency cases.  I'll send it out when it passes my internal
> tests...

 Fine. I guess this replacement assumes some modifications to the RAID-5 
driver as well. Right?

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
