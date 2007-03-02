From: NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Fix for raid6 reshape.
Date: Fri, 2 Mar 2007 15:56:55 +1100
Message-ID: <1070302045655.19069@suse.de>
References: <20070302155626.19014.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

### Comments for Changeset

Recent patch for raid6 reshape had a change missing that showed up in
subsequent review.

Many places in the raid5 code used "conf->raid_disks-1" to mean
"number of data disks".  With raid6 that had to be changed to
"conf->raid_disk - conf->max_degraded" or similar.  One place was missed.

This bug means that if a raid6 reshape were aborted in the middle the
recorded position would be wrong.  On restart it would either fail (as
the position wasn't on an appropriate boundary) or would leave a section
of the array unreshaped, causing data corruption.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-03-02 15:47:51.000000000 +1100
+++ ./drivers/md/raid5.c	2007-03-02 15:48:35.000000000 +1100
@@ -3071,7 +3071,7 @@ static sector_t reshape_request(mddev_t 
 		release_stripe(sh);
 	}
 	spin_lock_irq(&conf->device_lock);
-	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
+	conf->expand_progress = (sector_nr + i) * new_data_disks);
 	spin_unlock_irq(&conf->device_lock);
 	/* Ok, those stripe are ready. We can start scheduling
 	 * reads on the source stripes.
