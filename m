From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: "bitmap file is out of date, doing full recovery"
Date: Tue, 4 Nov 2014 11:17:20 +0200
Message-ID: <CAGRgLy4YjfUtziFfFyZmC5SHGm+PLUzmLACJfanBBN8SS7JjCg@mail.gmail.com>
References: <CAGRgLy5zhV49xF=ZwULaF46Xx=8rnWcypTWxxgf0HmEPpCP+yQ@mail.gmail.com>
	<20141013092426.5ea1288d@notabene.brown>
	<CAGRgLy69gC2n0oAP8CRNBzTb+tBnwmwoJOCdKb+aRMO=Oeqf3Q@mail.gmail.com>
	<20141029101950.5528b347@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141029101950.5528b347@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
thank you for your comments.

On Wed, Oct 29, 2014 at 1:19 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 23 Oct 2014 19:04:48 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> I found at least one way of this happening. The problem is that in
>> md_update_sb() we allow to decrease the event count:
>>
>>     /* If this is just a dirty<->clean transition, and the array is clean
>>      * and 'events' is odd, we can roll back to the previous clean state */
>>     if (nospares
>>         && (mddev->in_sync && mddev->recovery_cp == MaxSector)
>>         && mddev->can_decrease_events
>>         && mddev->events != 1) {
>>         mddev->events--;
>>         mddev->can_decrease_events = 0;
>>
>> Then we call bitmap_update_sb(). If we crash after we update (the
>> first or all of) bitmap superblocks, then after reboot, we will see
>> that bitmap event count is less than MD superblock event count. Then
>> we decide to do full resync.
>>
>> This can be easily reproduced by hacking bitmap_update_sb() to call
>> BUG(), after it calls write_page() in case event count was decreased.
>>
>> Why we are decreasing the event count??? Can we always increase it?
>> u64 is a lot to increase...
>
> The reason for decreasing the event count is so that we don't need to update
> the event count on spares - they can be left spun down.
> We for simple clean/dirty transitions with increment for clean->dirty and
> decrement for dirty->clean.  But we should only use this optimisation when
> everything is simple.
> We really shouldn't do this when the array is degraded.
> Do this fix your problem?
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2c73fcb82593..98fd97b10e13 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2244,6 +2244,7 @@ repeat:
>          * and 'events' is odd, we can roll back to the previous clean state */
>         if (nospares
>             && (mddev->in_sync && mddev->recovery_cp == MaxSector)
> +           && mddev->degraded == 0
>             && mddev->can_decrease_events
>             && mddev->events != 1) {
>                 mddev->events--;
>
>
No, unfortunately, this doesn't fix the problem. In my case, the array
is never degraded. Both drives are present and operational, then the
box crashes, and after reboot the bitmap event counter is lower than
we expect. Again, this is easily reproduced by hacking
bitmap_update_sb() as I mentioned earlier.

In my case array does not have spares. (There is some other system on
top, which monitors the array, and, if needed, adds a spare from a
"global" spare pool). Is this ok in this case to always increment the
event count?

Thanks,
Alex.


>>
>> Some other doubt that I have is that bitmap_unplug() and
>> bitmap_daemon_work() call write_page() on page index=0. This page
>> contains both the superblock and also some dirty bits (could not we
>> waste 4KB on bitmap superblock???). I am not sure, but I wonder
>> whether this call can race with md_update_sb (which explicitly calls
>> bitmap_update_sb), and somehow write the outdated superblock, after
>> bitmap_update_sb has completed writing it.
>>
>
> storage.sb_page is exactly the same as storage.filemap[0]
> So once an update has happened, the "outdated superblock" doesn't exist
> anywhere to be written out from.
>
>> Yet another suspect is when loading the bitmap we basically load it
>> from the first up-to-date drive. Maybe we should have scanned all the
>> bitmap superblocks, and selected one that has the higher event count
>> (although as we saw "higher" does not necessarily mean "more
>> up-to-date").
>>
>> Anyways, back to decrementing the event count. Do you see any issue
>> with not doing this and always incrementing?
>>
>> Thanks,
>> Alex.
>>
>
> Thanks,
> NeilBrown
