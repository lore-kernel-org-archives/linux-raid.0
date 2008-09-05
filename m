From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Thu, 4 Sep 2008 17:03:25 -0700
Message-ID: <e9c3a7c20809041703h5bf6a007g6dcbe8fb2a5deffd@mail.gmail.com>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
	 <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
	 <e9c3a7c20809041624o24af57fsbe58507a44e6e2ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20809041624o24af57fsbe58507a44e6e2ef@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wd@denx.de, yur@emcraft.com
List-Id: linux-raid.ids

On Thu, Sep 4, 2008 at 4:24 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Sep 4, 2008 at 2:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu,  4 Sep 2008 01:43:51 +0400
>> Ilya Yanok <yanok@emcraft.com> wrote:
>>
>>> From: Yuri Tikhonov <yur@emcraft.com>
>>>
>>> Should clear the next pointer of the TX if we are sure that the
>>> next TX (say NXT) will be submitted to the channel too. Overwise,
>>> we break the chain of descriptors, because we lose the information
>>> about the next descriptor to run. So next time, when invoke
>>> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
>>> NXT will be never submitted.
>>>
>>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>>
>> This patch should include your signed-off-by: as well.  Because you
>> were on the delivery path, as described in
>> Documentation/SubmittingPatches, section 12.
>>
>
> Yes, Ilya once I have your signed-off-by I will push this to Linus and
> -stable.  As far as impact for in-tree drivers: iop13xx by is immune,
> iop3xx can hit this, and it looks like the orion5x implementation is
> immune since copy and xor are available on the same channel.
>

Please also take a look at this cleanup patch that I will queue for
.28.  I think it makes things easier to read let me know if you
disagree.

---gmail mangled patch follows--->
async_tx: make async_tx_run_dependencies() easier to read

From: Dan Williams <dan.j.williams@intel.com>

* Rename 'next' to 'dep'
* Move the channel switch check inside the loop to simplify
  termination

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_tx.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)


diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index e8362c1..b833cca 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -115,34 +115,32 @@ EXPORT_SYMBOL_GPL(dma_wait_for_async_tx);
  *	(start) dependent operations on their target channel
  * @tx: transaction with dependencies
  */
-void
-async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
+void async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
 {
-	struct dma_async_tx_descriptor *next = tx->next;
+	struct dma_async_tx_descriptor *dep = tx->next;
+	struct dma_async_tx_descriptor *dep_next;
 	struct dma_chan *chan;

-	if (!next)
+	if (dep)
+		chan = dep->chan;
+	else
 		return;

-	tx->next = NULL;
-	chan = next->chan;
-
 	/* keep submitting up until a channel switch is detected
 	 * in that case we will be called again as a result of
 	 * processing the interrupt from async_tx_channel_switch
 	 */
-	while (next && next->chan == chan) {
-		struct dma_async_tx_descriptor *_next;
-
-		spin_lock_bh(&next->lock);
-		next->parent = NULL;
-		_next = next->next;
-		if (_next && _next->chan == chan)
-			next->next = NULL;
-		spin_unlock_bh(&next->lock);
-
-		next->tx_submit(next);
-		next = _next;
+	for (; dep; dep = dep_next) {
+		spin_lock_bh(&dep->lock);
+		dep->parent = NULL;
+		dep_next = dep->next;
+		if (dep_next && dep_next->chan == chan)
+			dep->next = NULL; /* ->next will be submitted */
+		else
+			dep_next = NULL; /* submit current dep and terminate */
+		spin_unlock_bh(&dep->lock);
+
+		dep->tx_submit(dep);
 	}

 	chan->device->device_issue_pending(chan);
