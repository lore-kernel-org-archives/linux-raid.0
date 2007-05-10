From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
Date: Thu, 10 May 2007 14:52:45 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705101450210.32349@yvahk01.tjqt.qr>
References: <20070510161940.20204.patches@notabene> <1070510062231.20403@suse.de>
 <Pine.LNX.4.61.0705101143540.32349@yvahk01.tjqt.qr> <17986.60947.483379.159313@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17986.60947.483379.159313@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


On May 10 2007 20:04, Neil Brown wrote:
>> >-		if ((curr_events - rdev->last_events + 4096) > 8192) {
>> >+		if ((long)curr_events - (long)rdev->last_events > 4096) {
>> > 			rdev->last_events = curr_events;
>> > 			idle = 0;
>> > 		}
>> 
>/* sync IO will cause sync_io to increase before the disk_stats
> * as sync_io is counted when a request starts, and 
> * disk_stats is counted when it completes.
> * So resync activity will cause curr_events to be smaller than
> * when there was no such activity.
> * non-sync IO will cause disk_stat to increase without
> * increasing sync_io so curr_events will (eventually)
> * be larger than it was before.  Once it becomes
> * substantially larger, the test below will cause
> * the array to appear non-idle, and resync will slow
> * down.
> * If there is a lot of outstanding resync activity when
> * we set last_event to curr_events, then all that activity
> * completing might cause the array to appear non-idle
> * and resync will be slowed down even though there might
> * not have been non-resync activity.  This will only
> * happen once though.  'last_events' will soon reflect
> * the state where there is little or no outstanding
> * resync requests, and further resync activity will
> * always make curr_events less than last_events.
> *
> */
>
>Does that read at all well?

It is a more verbose explanation of your patch description, yes.


	Jan
-- 
