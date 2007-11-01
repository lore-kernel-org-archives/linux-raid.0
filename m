From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Bug in processing dependencies by async_tx_submit() ?
Date: Wed, 31 Oct 2007 20:01:52 -0700
Message-ID: <1193886112.24616.18.camel@dwillia2-linux.ch.intel.com>
References: <200710311921.46609.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200710311921.46609.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2007-10-31 at 09:21 -0700, Yuri Tikhonov wrote:
> 
>  Hello Dan,
> 
>  I've run into a problem with the h/w accelerated RAID-5 driver (on the
> ppc440spe-based board). After some investigations I've come to conclusion
> that the issue is with the async_tx_submit() implementation in ASYNC_TX.
> 
Unfortunately this is correct, async_tx_submit() will let the third
operation pass the second in the scenario you describe.  I propose the
fix (untested) below.  I'll test this out tomorrow when I am back in the
office.

---
async_tx: fix successive dependent operation submission

From: Dan Williams <dan.j.williams@intel.com>

async_tx_submit() tried to use the hardware descriptor chain to maintain
transaction ordering.  However before falling back to hardware-channel
dependency ordering async_tx_submit() must first check if the entire chain
is waiting on another channel.

OP1 (DMA0) <--- OP2 (DMA1) <--- OP3 (DMA1)

OP3 must be submitted as an OP2 dependency if it is submitted before OP1
completes.  Otherwise if OP1 is complete, OP3 can use the natural sequence
of DMA1's hardware chain to satisfy that it runs after OP2.

The fix is to check if the ->parent field of the dependency is non-NULL.
This also requires that the parent field be cleared at dependency
submission time.

Found-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_tx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index bc18cbb..eb1afb9 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -125,6 +125,9 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
 		list_del(&dep_tx->depend_node);
 		tx->tx_submit(dep_tx);
 
+		/* we no longer have a parent */
+		tx->parent = NULL;
+
 		/* we need to poke the engine as client code does not
 		 * know about dependency submission events
 		 */
@@ -409,8 +412,9 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 	/* set this new tx to run after depend_tx if:
 	 * 1/ a dependency exists (depend_tx is !NULL)
 	 * 2/ the tx can not be submitted to the current channel
+	 * 3/ the depend_tx has a parent
 	 */
-	if (depend_tx && depend_tx->chan != chan) {
+	if (depend_tx && (depend_tx->chan != chan || depend_tx->parent)) {
 		/* if ack is already set then we cannot be sure
 		 * we are referring to the correct operation
 		 */

