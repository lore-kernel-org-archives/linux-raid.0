From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
Date: Thu, 10 May 2007 20:04:03 +1000
Message-ID: <17986.60947.483379.159313@notabene.brown>
References: <20070510161940.20204.patches@notabene>
	<1070510062231.20403@suse.de>
	<Pine.LNX.4.61.0705101143540.32349@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Engelhardt on Thursday May 10
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 10, jengelh@linux01.gwdg.de wrote:
> 
> On May 10 2007 16:22, NeilBrown wrote:
> >
> >diff .prev/drivers/md/md.c ./drivers/md/md.c
> >--- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
> >+++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
> >@@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
> > 		 *
> > 		 * Note: the following is an unsigned comparison.
> > 		 */
> >-		if ((curr_events - rdev->last_events + 4096) > 8192) {
> >+		if ((long)curr_events - (long)rdev->last_events > 4096) {
> > 			rdev->last_events = curr_events;
> > 			idle = 0;
> > 		}
> 
> What did really change? Unless I am seriously mistaken,
> 
>     curr_events - last_evens + 4096 > 8192
> 
> is mathematically equivalent to
> 
>     curr_events - last_evens        > 4096
> 
> The casting to (long) may however force a signed comparison which turns
> things quite upside down, and the comment does not apply anymore.

Yes, the use of a signed comparison is the significant difference.
And yes, the comment becomes wrong.  I'm in the process of redrafting
that.  It currently stands at:

		/* sync IO will cause sync_io to increase before the disk_stats
		 * as sync_io is counted when a request starts, and 
		 * disk_stats is counted when it completes.
		 * So resync activity will cause curr_events to be smaller than
		 * when there was no such activity.
		 * non-sync IO will cause disk_stat to increase without
		 * increasing sync_io so curr_events will (eventually)
		 * be larger than it was before.  Once it becomes
		 * substantially larger, the test below will cause
		 * the array to appear non-idle, and resync will slow
		 * down.
		 * If there is a lot of outstanding resync activity when
		 * we set last_event to curr_events, then all that activity
		 * completing might cause the array to appear non-idle
		 * and resync will be slowed down even though there might
		 * not have been non-resync activity.  This will only
		 * happen once though.  'last_events' will soon reflect
		 * the state where there is little or no outstanding
		 * resync requests, and further resync activity will
		 * always make curr_events less than last_events.
		 *
		 */


Does that read at all well?

NeilBrown
