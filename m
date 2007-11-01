From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: Bug in processing dependencies by async_tx_submit() ?
Date: Thu, 1 Nov 2007 14:00:04 +0400
Message-ID: <200711011300.04546.yur@emcraft.com>
References: <200710311921.46609.yur@emcraft.com> <1193886112.24616.18.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193886112.24616.18.camel@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hi Dan,

  Honestly I tried to fix this quickly using the approach similar to proposed
 by you, with one addition though (in fact, deletion of BUG_ON(chan ==
 tx->chan) in async_tx_run_dependencies()). And this led to "Kernel stack
 overflow". This happened because of the recurseve calling async_tx_submit()
 from async_trigger_callback() and vice verse.

  So, then I made the interrupt scheduling in async_tx_submit() only for the
 cases when it is really needed: i.e. when dependent operations are to be run
 on different channels.

  The resulted kernel locked-up during processing of the mkfs command on the
 top of the RAID-array. The place where it is spinning is the dma_sync_wait()
 function. 

  This is happened because of the specific implementation of
 dma_wait_for_async_tx().
  The "iter", we finally waiting for there, corresponds to the last allocated
 but not-yet-submitted descriptor. But if the "iter" we are waiting for is
 dependent from another descriptor which has cookie > 0, but is not yet
 submitted to the h/w channel because of the fact that threshold is not
 achieved to this moment, then we may wait in dma_wait_for_async_tx()
 infinitely. I think that it makes more sense to get the first descriptor
 which was submitted to the channel but probably is not put into the h/w
 chain, i.e. with cookie > 0 and do dma_sync_wait() of this descriptor.

  When I modified the dma_wait_for_async_tx() in such way, then the kernel
 locking had disappeared. But nevertheless the mkfs processes hangs-up after
 some time. So, it looks like something is still missing in support of the
 chaining dependencies feature...

  Below is the final patch I used during my tests:

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index bc18cbb..b7d3b2b 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -92,7 +92,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
                /* find the root of the unsubmitted dependency chain */
                while (iter->cookie == -EBUSY) {
                        parent = iter->parent;
-                       if (parent && parent->cookie == -EBUSY)
+                       if (parent)
                                iter = iter->parent;
                        else
                                break;
@@ -120,11 +120,12 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
                depend_node) {
                chan = dep_tx->chan;
                dev = chan->device;
-               /* we can't depend on ourselves */
-               BUG_ON(chan == tx->chan);
                list_del(&dep_tx->depend_node);
                tx->tx_submit(dep_tx);

+               /* we no longer have a parent */
+               tx->parent = NULL;
+
                /* we need to poke the engine as client code does not
                 * know about dependency submission events
                 */
@@ -409,8 +410,9 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
        /* set this new tx to run after depend_tx if:
         * 1/ a dependency exists (depend_tx is !NULL)
         * 2/ the tx can not be submitted to the current channel
+        * 3/ the depend_tx has a parent
         */
-       if (depend_tx && depend_tx->chan != chan) {
+       if (depend_tx && (depend_tx->chan != chan || depend_tx->parent)) {
                /* if ack is already set then we cannot be sure
                 * we are referring to the correct operation
                 */
@@ -427,7 +429,8 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
                spin_unlock_bh(&depend_tx->lock);

                /* schedule an interrupt to trigger the channel switch */
-               async_trigger_callback(ASYNC_TX_ACK, depend_tx, NULL, NULL);
+               if (depend_tx->chan != chan)
+                       async_trigger_callback(ASYNC_TX_ACK, depend_tx, NULL, NULL);
        } else {
                tx->parent = NULL;
                tx->tx_submit(tx);



 Regards, Yuri

On Thursday 01 November 2007 06:01, Dan Williams wrote:
> On Wed, 2007-10-31 at 09:21 -0700, Yuri Tikhonov wrote:
> > 
> >  Hello Dan,
> > 
> >  I've run into a problem with the h/w accelerated RAID-5 driver (on the
> > ppc440spe-based board). After some investigations I've come to conclusion
> > that the issue is with the async_tx_submit() implementation in ASYNC_TX.
> > 
> Unfortunately this is correct, async_tx_submit() will let the third
> operation pass the second in the scenario you describe.  I propose the
> fix (untested) below.  I'll test this out tomorrow when I am back in the
> office.
> 
> ---
> async_tx: fix successive dependent operation submission
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> async_tx_submit() tried to use the hardware descriptor chain to maintain
> transaction ordering.  However before falling back to hardware-channel
> dependency ordering async_tx_submit() must first check if the entire chain
> is waiting on another channel.
> 
> OP1 (DMA0) <--- OP2 (DMA1) <--- OP3 (DMA1)
> 
> OP3 must be submitted as an OP2 dependency if it is submitted before OP1
> completes.  Otherwise if OP1 is complete, OP3 can use the natural sequence
> of DMA1's hardware chain to satisfy that it runs after OP2.
> 
> The fix is to check if the ->parent field of the dependency is non-NULL.
> This also requires that the parent field be cleared at dependency
> submission time.
> 
> Found-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  crypto/async_tx/async_tx.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
> index bc18cbb..eb1afb9 100644
> --- a/crypto/async_tx/async_tx.c
> +++ b/crypto/async_tx/async_tx.c
> @@ -125,6 +125,9 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
>  		list_del(&dep_tx->depend_node);
>  		tx->tx_submit(dep_tx);
>  
> +		/* we no longer have a parent */
> +		tx->parent = NULL;
> +
>  		/* we need to poke the engine as client code does not
>  		 * know about dependency submission events
>  		 */
> @@ -409,8 +412,9 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
>  	/* set this new tx to run after depend_tx if:
>  	 * 1/ a dependency exists (depend_tx is !NULL)
>  	 * 2/ the tx can not be submitted to the current channel
> +	 * 3/ the depend_tx has a parent
>  	 */
> -	if (depend_tx && depend_tx->chan != chan) {
> +	if (depend_tx && (depend_tx->chan != chan || depend_tx->parent)) {
>  		/* if ack is already set then we cannot be sure
>  		 * we are referring to the correct operation
>  		 */
> 
> 

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
