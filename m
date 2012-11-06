From: Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] Fix deadlock with request based dm and some drivers
Date: Tue, 6 Nov 2012 12:29:03 +0100
Message-ID: <5098F47F.9030201@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Alasdair,

I recently fixed a deadlock for a customer we have with
the below patch. I have queued it up in my tree as not
to lose it. Can I have an ack from you, or do you want
to submit it yourself? I've marked it stable as well.


From 8ca211056519ac06bc96fb134dca1f8eb2141407 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 6 Nov 2012 12:24:26 +0100
Subject: [PATCH] dm: fix deadlock with request based dm and queue request_fn
 recursion

Request based dm attempts to re-run the request queue off the
request completion path. If used with a driver that potentially does
end_io from its request_fn, we could deadlock trying to recurse
back into request dispatch. Fix this by punting the request queue
run to kblockd.

Tested to fix a quickly reproducible deadlock in such a scenario.

Cc: stable@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/dm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 02db918..77e6eff 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -740,8 +740,14 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 	if (!md_in_flight(md))
 		wake_up(&md->wait);
 
+	/*
+	 * Run this off this callpath, as drivers could invoke end_io while
+	 * inside their request_fn (and holding the queue lock). Calling
+	 * back into ->request_fn() could deadlock attempting to grab the
+	 * queue lock again.
+	 */
 	if (run_queue)
-		blk_run_queue(md->queue);
+		blk_run_queue_async(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
-- 
1.7.12.rc3


-- 
Jens Axboe

