From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: "bitmap file is out of date, doing full recovery"
Date: Thu, 23 Oct 2014 19:04:48 +0300
Message-ID: <CAGRgLy69gC2n0oAP8CRNBzTb+tBnwmwoJOCdKb+aRMO=Oeqf3Q@mail.gmail.com>
References: <CAGRgLy5zhV49xF=ZwULaF46Xx=8rnWcypTWxxgf0HmEPpCP+yQ@mail.gmail.com>
	<20141013092426.5ea1288d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141013092426.5ea1288d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
I found at least one way of this happening. The problem is that in
md_update_sb() we allow to decrease the event count:

    /* If this is just a dirty<->clean transition, and the array is clean
     * and 'events' is odd, we can roll back to the previous clean state */
    if (nospares
        && (mddev->in_sync && mddev->recovery_cp == MaxSector)
        && mddev->can_decrease_events
        && mddev->events != 1) {
        mddev->events--;
        mddev->can_decrease_events = 0;

Then we call bitmap_update_sb(). If we crash after we update (the
first or all of) bitmap superblocks, then after reboot, we will see
that bitmap event count is less than MD superblock event count. Then
we decide to do full resync.

This can be easily reproduced by hacking bitmap_update_sb() to call
BUG(), after it calls write_page() in case event count was decreased.

Why we are decreasing the event count??? Can we always increase it?
u64 is a lot to increase...

Some other doubt that I have is that bitmap_unplug() and
bitmap_daemon_work() call write_page() on page index=0. This page
contains both the superblock and also some dirty bits (could not we
waste 4KB on bitmap superblock???). I am not sure, but I wonder
whether this call can race with md_update_sb (which explicitly calls
bitmap_update_sb), and somehow write the outdated superblock, after
bitmap_update_sb has completed writing it.

Yet another suspect is when loading the bitmap we basically load it
from the first up-to-date drive. Maybe we should have scanned all the
bitmap superblocks, and selected one that has the higher event count
(although as we saw "higher" does not necessarily mean "more
up-to-date").

Anyways, back to decrementing the event count. Do you see any issue
with not doing this and always incrementing?

Thanks,
Alex.



On Mon, Oct 13, 2014 at 1:24 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 12 Oct 2014 21:03:57 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> after a 2-drive raid1 unclean shutdown (crash actually), after reboot, we had:
>>
>> md/raid1:md24: not clean -- starting background reconstruction
>> md/raid1:md24: active with 2 out of 2 mirrors
>> md24: bitmap file is out of date (41 < 42) -- forcing full recovery
>> created bitmap (22 pages) for device md24
>> md24: bitmap file is out of date, doing full recovery
>> md24: bitmap initialized from disk: read 2 pages, set 44667 of 44667 bits
>>
>> The superblock of both drives had event count = 42:
>> (this is a custom mdadm with some added prints):
>> mdadm: looking for devices for /dev/md24
>> mdadm: [/dev/md24] /dev/dm-205: slot=0, events=42,
>> recovery_offset=N/A, resync_offset=0, comp_size=5854539776
>> mdadm: [/dev/md24] /dev/dm-206: slot=1, events=42,
>> recovery_offset=N/A, resync_offset=0, comp_size=5854539776
>>
>> But the bitmap superblock had lower event count, which resulted in a
>> full resync. Is this an expected scenario in case of a crash?
>
> No.
>
>>
>> For example in md_update_sb, first we call
>> bitmap_update_sb(mddev->bitmap), which synchronously updates the
>> bitmap, and only afterwards we go ahead and update our superblocks. So
>> in this case, the bitmap should not have a lower event count. Is there
>> some other valid scenario, in which the bitmap can remain with a lower
>> event count?
>
> Not that I can think of.
>
>
> NeilBrown
>
>>
>> Thanks,
>> Alex.
>
