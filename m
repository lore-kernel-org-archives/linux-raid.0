From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: Bug in processing dependencies by async_tx_submit() ?
Date: Mon, 12 Nov 2007 11:46:05 +0300
Message-ID: <927792640.20071112114605@emcraft.com>
References: <200710311921.46609.yur@emcraft.com>
 <1193886112.24616.18.camel@dwillia2-linux.ch.intel.com>
 <200711011300.04546.yur@emcraft.com>
 <e9c3a7c20711011736idef37b4qf5e86b40930a2eb1@mail.gmail.com>
Reply-To: Yuri Tikhonov <yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20711011736idef37b4qf5e86b40930a2eb1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hi Dan,

On 02.11.2007, 3:36:50 you wrote:

> I am preparing a new patch that replaces ASYNC_TX_DEP_ACK with
> ASYNC_TX_CHAIN_ACK.  The plan is to make the entire chain of
> dependencies available up until the last transaction is submitted.
> This allows the entire dependency chain to be walked at
> async_tx_submit time so that we can properly handle these multiple
> dependency cases.  I'll send it out when it passes my internal
> tests...

 Meanwhile I've implemented my fix to this issue. With this the tests, which
previously failed (mkfs got stuck), now pass successfully for me. Would you 
please take a look? Thanks in advance.

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index bc18cbb..6d77ae6 100644
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
@@ -120,10 +120,11 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
                depend_node) {
                chan = dep_tx->chan;
                dev = chan->device;
-               /* we can't depend on ourselves */
-               BUG_ON(chan == tx->chan);
                list_del(&dep_tx->depend_node);
-               tx->tx_submit(dep_tx);
+               dep_tx->tx_submit(dep_tx);
+
+               /* we no longer have a parent */
+               dep_tx->parent = NULL;

                /* we need to poke the engine as client code does not
                 * know about dependency submission events
@@ -409,25 +410,41 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
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
                BUG_ON(depend_tx->ack);

-               tx->parent = depend_tx;
                spin_lock_bh(&depend_tx->lock);
+               tx->parent = depend_tx;
                list_add_tail(&tx->depend_node, &depend_tx->depend_list);
                if (depend_tx->cookie == 0) {
-                       struct dma_chan *dep_chan = depend_tx->chan;
-                       struct dma_device *dep_dev = dep_chan->device;
-                       dep_dev->device_dependency_added(dep_chan);
-               }
-               spin_unlock_bh(&depend_tx->lock);
+                       /* depend_tx has been completed, run our dep
+                        * manually
+                        */
+                       async_tx_run_dependencies(depend_tx);
+                       spin_unlock_bh(&depend_tx->lock);
+               } else {
+                       /* depend_tx still in fly */
+                       spin_unlock_bh(&depend_tx->lock);


-               /* schedule an interrupt to trigger the channel switch */
-               async_trigger_callback(ASYNC_TX_ACK, depend_tx, NULL, NULL);
+                       /* schedule an interrupt to trigger the channel
+                        * switch or dependencies submittion
+                        */
+                       if (!(flags & ASYNC_TX_INT) && (depend_tx->chan != chan ||
+                           !depend_tx->callback))
+                               async_trigger_callback(ASYNC_TX_ACK | ASYNC_TX_INT,
+                                               depend_tx, NULL, NULL);
+
+                       /* flush the parent if it's not submitted yet */
+                       spin_lock_bh(&depend_tx->lock);
+                       depend_tx->chan->device->device_issue_pending(
+                               depend_tx->chan);
+                       spin_unlock_bh(&depend_tx->lock);
+               }
        } else {
                tx->parent = NULL;
                tx->tx_submit(tx);
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index aea0402..ee09315 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -67,6 +67,7 @@ enum async_tx_flags {
        ASYNC_TX_KMAP_SRC        = (1 << 5),
        ASYNC_TX_KMAP_DST        = (1 << 6),
        ASYNC_TX_ASYNC_ONLY      = (1 << 7),
+       ASYNC_TX_INT             = (1 << 8),
 };

 #ifdef CONFIG_DMA_ENGINE

