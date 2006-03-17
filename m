From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 6] md: Remove some stray semi-colons after functions called in macro....
Date: Fri, 17 Mar 2006 18:21:46 +1100
Message-ID: <1060317072146.28668@suse.de>
References: <20060317181912.28543.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


wait_event_lock_irq puts a ';' after its usage of the 4th arg, so we
don't need to.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-03-17 18:18:44.000000000 +1100
+++ ./drivers/md/raid5.c	2006-03-17 18:18:48.000000000 +1100
@@ -262,7 +262,7 @@ static struct stripe_head *get_active_st
 						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
 						    conf->device_lock,
-						    unplug_slaves(conf->mddev);
+						    unplug_slaves(conf->mddev)
 					);
 				conf->inactive_blocked = 0;
 			} else
@@ -405,7 +405,7 @@ static int resize_stripes(raid5_conf_t *
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    !list_empty(&conf->inactive_list),
 				    conf->device_lock,
-				    unplug_slaves(conf->mddev);
+				    unplug_slaves(conf->mddev)
 			);
 		osh = get_free_stripe(conf);
 		spin_unlock_irq(&conf->device_lock);
