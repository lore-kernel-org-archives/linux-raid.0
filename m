From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
Date: Mon, 14 Jan 2008 12:45:25 +1100
Message-ID: <1080114014525.20337@suse.de>
References: <20080114123726.19968.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>
List-Id: linux-raid.ids


raid5's 'make_request' function calls generic_make_request on
underlying devices and if we run out of stripe heads, it could end up
waiting for one of those requests to complete.
This is bad as recursive calls to generic_make_request go on a queue
and are not even attempted until make_request completes.

So: don't make any generic_make_request calls in raid5 make_request
until all waiting has been done.  We do this by simply setting
STRIPE_HANDLE instead of calling handle_stripe().

If we need more stripe_heads, raid5d will get called to process the
pending stripe_heads which will call generic_make_request from a
different thread where no deadlock will happen.


This change by itself causes a performance hit.  So add a change so
that raid5_activate_delayed is only called at unplug time, never in
raid5.  This seems to bring back the performance numbers.  Calling it
in raid5d was sometimes too soon...

Cc: "Dan Williams" <dan.j.williams@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-11 15:01:14.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-14 12:24:07.000000000 +1100
@@ -3157,7 +3157,8 @@ static void raid5_activate_delayed(raid5
 				atomic_inc(&conf->preread_active_stripes);
 			list_add_tail(&sh->lru, &conf->handle_list);
 		}
-	}
+	} else
+		blk_plug_device(conf->mddev->queue);
 }
 
 static void activate_bit_delay(raid5_conf_t *conf)
@@ -3547,7 +3548,7 @@ static int make_request(struct request_q
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			handle_stripe(sh, NULL);
+			set_bit(STRIPE_HANDLE, &sh->state);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
@@ -3890,7 +3891,7 @@ static int  retry_aligned_read(raid5_con
  * During the scan, completed stripes are saved for us by the interrupt
  * handler, so that they will not have to wait for our next wakeup.
  */
-static void raid5d (mddev_t *mddev)
+static void raid5d(mddev_t *mddev)
 {
 	struct stripe_head *sh;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
@@ -3915,12 +3916,6 @@ static void raid5d (mddev_t *mddev)
 			activate_bit_delay(conf);
 		}
 
-		if (list_empty(&conf->handle_list) &&
-		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !blk_queue_plugged(mddev->queue) &&
-		    !list_empty(&conf->delayed_list))
-			raid5_activate_delayed(conf);
-
 		while ((bio = remove_bio_from_retry(conf))) {
 			int ok;
 			spin_unlock_irq(&conf->device_lock);
