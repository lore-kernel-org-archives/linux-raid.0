From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/4] raid1: directly dispatch write request if no bitmap
Date: Wed, 23 May 2012 15:26:20 +0800
Message-ID: <20120523072829.967587288@kernel.org>
References: <20120523072619.670179001@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid1-write-direct-dispatch.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

In raid1, all write requests are dispatched in raid1d thread. In fast storage,
the raid1d thread is a bottleneck, because it dispatches request too slow. Also
raid1d thread migrates freely, which makes request completion cpu not match
with submission cpu even driver/block layer has such capability. This will
cause bad cache issue.

If no bitmap, there is no point to queue bio to a thread and dispatch it in the
thread. Directly dispatching bio doesn't impact correctness and removes above
bottleneck.

Multiple threads dispatch requests could potentially reduce request merge and
increase lock contention. For slow stroage, we just worry about request merge.
Caller of .make_request should already have correct block plug set, which will
take care of request merge and locking just like accessing raw device, so we
don't need worry about this too much.

In a 4k randwrite test with a 2 disks setup, below patch can provide 20% ~ 50%
performance improvements depending on numa binding.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-05-22 13:50:26.989820654 +0800
+++ linux/drivers/md/raid1.c	2012-05-22 13:56:46.117054559 +0800
@@ -1187,10 +1187,13 @@ read_again:
 		mbio->bi_private = r1_bio;
 
 		atomic_inc(&r1_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		if (bitmap) {
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+		} else
+			generic_make_request(mbio);
 	}
 	/* Mustn't call r1_bio_write_done before this next test,
 	 * as it could result in the bio being freed.

