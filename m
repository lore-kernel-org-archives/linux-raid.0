From: Shaohua Li <shli@kernel.org>
Subject: [patch]raid5: make_request does less prepare wait
Date: Tue, 8 Apr 2014 12:05:07 +0800
Message-ID: <20140408040507.GA20886@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


In NUMA machine, prepare_to_wait/finish_wait in make_request exposes a lot of
contention for sequential workload (or big request size workload). For such
workload, each bio includes several stripes. So we can just do
prepare_to_wait/finish_wait once for the whold bio instead of every stripe.
This reduces the lock contention completely for such workload. Random workload
might have the similar lock contention too, but I didn't see it yet, maybe
because my stroage is still not fast enough.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-04-08 09:04:20.000000000 +0800
+++ linux/drivers/md/raid5.c	2014-04-08 09:11:08.201533487 +0800
@@ -4552,6 +4552,8 @@ static void make_request(struct mddev *m
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
 	int remaining;
+	DEFINE_WAIT(w);
+	bool do_prepare;
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
@@ -4575,15 +4577,19 @@ static void make_request(struct mddev *m
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
+	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int previous;
 		int seq;
 
+		do_prepare = false;
 	retry:
 		seq = read_seqcount_begin(&conf->gen_lock);
 		previous = 0;
-		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
+		if (do_prepare)
+			prepare_to_wait(&conf->wait_for_overlap, &w,
+				TASK_UNINTERRUPTIBLE);
 		if (unlikely(conf->reshape_progress != MaxSector)) {
 			/* spinlock is needed as reshape_progress may be
 			 * 64bit on a 32bit platform, and so it might be
@@ -4604,6 +4610,7 @@ static void make_request(struct mddev *m
 				    : logical_sector >= conf->reshape_safe) {
 					spin_unlock_irq(&conf->device_lock);
 					schedule();
+					do_prepare = true;
 					goto retry;
 				}
 			}
@@ -4640,6 +4647,7 @@ static void make_request(struct mddev *m
 				if (must_retry) {
 					release_stripe(sh);
 					schedule();
+					do_prepare = true;
 					goto retry;
 				}
 			}
@@ -4663,8 +4671,10 @@ static void make_request(struct mddev *m
 				prepare_to_wait(&conf->wait_for_overlap,
 						&w, TASK_INTERRUPTIBLE);
 				if (logical_sector >= mddev->suspend_lo &&
-				    logical_sector < mddev->suspend_hi)
+				    logical_sector < mddev->suspend_hi) {
 					schedule();
+					do_prepare = true;
+				}
 				goto retry;
 			}
 
@@ -4677,9 +4687,9 @@ static void make_request(struct mddev *m
 				md_wakeup_thread(mddev->thread);
 				release_stripe(sh);
 				schedule();
+				do_prepare = true;
 				goto retry;
 			}
-			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if ((bi->bi_rw & REQ_SYNC) &&
@@ -4689,10 +4699,10 @@ static void make_request(struct mddev *m
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
-			finish_wait(&conf->wait_for_overlap, &w);
 			break;
 		}
 	}
+	finish_wait(&conf->wait_for_overlap, &w);
 
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
