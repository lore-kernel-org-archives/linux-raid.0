From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 12] md: Possible fix for unplug problem
Date: Tue, 27 Jun 2006 17:05:10 +1000
Message-ID: <1060627070510.25960@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030690AbWF0HFU@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


I have reports of a problem with raid5 which turns out to be because
the raid5 device gets stuck in a 'plugged' state.  This shouldn't be
able to happen as 3msec after it gets plugged it should get unplugged.
However it happens none-the-less.  This patch fixes the problem and is
a reasonable thing to do, though it might hurt performance slightly in
some cases.

Until I can find the real problem, we should probably have this
workaround in place.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-06-27 12:15:17.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-27 12:16:41.000000000 +1000
@@ -271,7 +271,7 @@ static struct stripe_head *get_active_st
 						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
 						    conf->device_lock,
-						    unplug_slaves(conf->mddev)
+						    raid5_unplug_device(conf->mddev->queue)
 					);
 				conf->inactive_blocked = 0;
 			} else
