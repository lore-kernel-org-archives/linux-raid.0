From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md
 array.
Date: Mon, 8 Nov 2004 12:21:06 +1100
Message-ID: <16782.51714.392051.617743@cse.unsw.edu.au>
References: <20041102143440.12019.patches@notabene>
	<E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
	<20041103150315.47a7982e.akpm@osdl.org>
	<20041104092107.GE14993@suse.de>
	<20041105085250.GF16649@suse.de>
	<16782.45573.167835.261291@cse.unsw.edu.au>
	<20041107154223.0900c37f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Sunday November 7
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: axboe@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 7, akpm@osdl.org wrote:
> > I couldn't find blk_sync_queue in 2.6.10-rc1-mm2 ....
> 
> I added it in -mm3 to replace all the open-coded del_timer_sync()s.

Yeh... right... of course ... I saw that mail...

I think I missed the trust of Jens' mail.

I now see the point was that:

  .... you have to prevent new requests from setting it (the timer)
  off again.

That isn't a problem in my case. By the time I  to want to remove
the timer, I know that no-one has the device open, and so no requests
are going to arrive.
The blk_wait_queue_drained has no relevance for md as we don't use the
same sort of queue.
So I think blk_sync_queue is all that is needed.

> 
> We should be able to stick all the above inside block_sync_queue()


Maybe:

###Comments for ChangeSet
Document blk_sync_queue and complete it's functionality.

blk_sync_queue needs to call kblock_flush as the unplug function
is not actually called by the timer, but rather by a work_queue that
the timer triggers.

Also, use blk_sync_queue to abstract identical functionality from 
blk_cleanup_queue.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/block/ll_rw_blk.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff ./drivers/block/ll_rw_blk.c~current~ ./drivers/block/ll_rw_blk.c
--- ./drivers/block/ll_rw_blk.c~current~	2004-11-08 11:57:40.000000000 +1100
+++ ./drivers/block/ll_rw_blk.c	2004-11-08 12:17:53.000000000 +1100
@@ -1361,12 +1361,21 @@ void blk_stop_queue(request_queue_t *q)
 EXPORT_SYMBOL(blk_stop_queue);
 
 /**
- * blk_sync_queue - prepare to destroy a queue
+ * blk_sync_queue - cancel any pending callbacks a queue
  * @q: the queue
+ *
+ * Description:
+ *     The block layer may perform asynchronous callback activity
+ *     on a queue, such as calling the unplug function after a timeout.
+ *     A block device may call blk_sync_queue to ensure that any
+ *     such activity is cancelled, thus allowing it to release resources
+ *     the the callbacks might use.
+ *
  */
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
+	kblockd_flush();
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -1410,8 +1419,7 @@ void blk_cleanup_queue(request_queue_t *
 	if (q->elevator)
 		elevator_exit(q->elevator);
 
-	del_timer_sync(&q->unplug_timer);
-	kblockd_flush();
+	blk_sync_queue(q);
 
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
