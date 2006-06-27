From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 12] md: Fix a plug/unplug race in raid5
Date: Tue, 27 Jun 2006 17:05:31 +1000
Message-ID: <1060627070531.26010@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030692AbWF0HFo@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When a device is unplugged, requests are moved from one or two
(depending on whether a bitmap is in use) queues to the main
request queue.

So whenever requests are put on either of those queues, we should make
sure the raid5 array is 'plugged'.
However we don't.  We currently plug the raid5 queue just before
putting requests on queues, so there is room for a race.  If something
unplugs the queue at just the wrong time, requests will be left on
the queue and nothing will want to unplug them.
Normally something else will plug and unplug the queue fairly
soon, but there is a risk that nothing will.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-06-27 12:17:32.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-27 12:17:33.000000000 +1000
@@ -89,12 +89,14 @@ static void __release_stripe(raid5_conf_
 		BUG_ON(!list_empty(&sh->lru));
 		BUG_ON(atomic_read(&conf->active_stripes)==0);
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state))
+			if (test_bit(STRIPE_DELAYED, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->delayed_list);
-			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
-				 conf->seq_write == sh->bm_seq)
+				blk_plug_device(conf->mddev->queue);
+			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+				   conf->seq_write == sh->bm_seq) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
-			else {
+				blk_plug_device(conf->mddev->queue);
+			} else {
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
 			}
@@ -2556,13 +2558,6 @@ static int raid5_issue_flush(request_que
 	return ret;
 }
 
-static inline void raid5_plug_device(raid5_conf_t *conf)
-{
-	spin_lock_irq(&conf->device_lock);
-	blk_plug_device(conf->mddev->queue);
-	spin_unlock_irq(&conf->device_lock);
-}
-
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
@@ -2672,7 +2667,6 @@ static int make_request(request_queue_t 
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			raid5_plug_device(conf);
 			handle_stripe(sh, NULL);
 			release_stripe(sh);
 		} else {
