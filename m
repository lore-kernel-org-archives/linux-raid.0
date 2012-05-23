From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/4] raid10: directly dispatch write request if no bitmap
Date: Wed, 23 May 2012 15:26:22 +0800
Message-ID: <20120523072849.059863847@kernel.org>
References: <20120523072619.670179001@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid10-write-direct-dispatch.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

In raid10, all write requests are dispatched in raid10d thread. In fast
storage, the raid10d thread is a bottleneck, because it dispatches request too
slow. Also raid10d thread migrates freely, which makes request completion cpu
not match with submission cpu even driver/block layer has such capability. This
will cause bad cache issue.

If no bitmap, there is no point to queue bio to a thread and dispatch it in the
thread. Directly dispatching bio doesn't impact correctness and removes above
bottleneck.

Multiple threads dispatch requests could potentially reduce request merge and
increase lock contention. For slow stroage, we just worry about request merge.
Caller of .make_request should already have correct block plug set, which will
take care of request merge and locking just like accessing raw device, so we
don't need worry about this too much.

In a 4k randwrite test with a 4 disks setup, below patch can provide 95% ~ 135%
performance improvements depending on numa binding.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid10.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

Index: linux/drivers/md/raid10.c
===================================================================
--- linux.orig/drivers/md/raid10.c	2012-05-22 19:05:52.495894815 +0800
+++ linux/drivers/md/raid10.c	2012-05-22 19:06:30.955411279 +0800
@@ -1304,10 +1304,13 @@ retry_write:
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		if (mddev->bitmap) {
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+		} else
+			generic_make_request(mbio);
 
 		if (!r10_bio->devs[i].repl_bio)
 			continue;
@@ -1329,10 +1332,13 @@ retry_write:
 		mbio->bi_private = r10_bio;
 
 		atomic_inc(&r10_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		if (mddev->bitmap) {
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+		} else
+			generic_make_request(mbio);
 	}
 
 	/* Don't remove the bias on 'remaining' (one_write_done) until

