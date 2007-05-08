From: Neil Brown <neilb@suse.de>
Subject: Re: Linux MD Raid Bug(?) w/Kernel sync_speed_min Option
Date: Tue, 8 May 2007 23:03:18 +1000
Message-ID: <17984.29974.116526.922404@notabene.brown>
References: <Pine.LNX.4.64.0705080821350.16228@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Tuesday May 8
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 8, jpiszcz@lucidpixels.com wrote:
> Kernel: 2.6.21.1
> 
> Here is the bug:
> 
> md2: RAID1 (works fine)
> md3: RAID5 (only syncs at the sync_speed_min set by the kernel)
> 
> If I do not run this command:
> echo 55000 > /sys/block/md3/md/sync_speed_min
> 
> I will get 2 megabytes per second check speed for RAID 5.

I can only reproduce this if I set the stripe_cache_size somewhat
larger than the default of 256 - did you do this?

This code (is_mddev_idle) has always been a bit fragile, particularly
so since the block layer started account IO when it finished rather
than when it started.

This patch might help though.  Let me know if it does what you expect.

Thanks,
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-07 17:47:15.000000000 +1000
+++ ./drivers/md/md.c	2007-05-08 22:57:51.000000000 +1000
@@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
 		 *
 		 * Note: the following is an unsigned comparison.
 		 */
-		if ((curr_events - rdev->last_events + 4096) > 8192) {
+		if ((long)curr_events - (long)rdev->last_events > 8192) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}
