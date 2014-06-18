From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: mismatches after growing raid1 and re-adding a failed drive
Date: Wed, 18 Jun 2014 20:42:14 +0300
Message-ID: <CAGRgLy6j0h5dd+AJP8XKq3Yx-jpqD7gWVSqs68e7fuv4Aaefsg@mail.gmail.com>
References: <CAGRgLy6YHMe-CRB1h4WHC-1xtdy5nURecf51LWu9WRaCy8Nw6w@mail.gmail.com>
	<20140610102105.6e544fd7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140610102105.6e544fd7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Tue, Jun 10, 2014 at 3:21 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 6 Jun 2014 14:59:32 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> testing the following scenario:
>>
>> 1) create a raid1 with drives A and B, wait for resync to complete
>> (verify mismatch_cnt is 0)
>> 2) drive B fails, array continues to operate as degraded, new data is
>> written to array
>> 3) add a fresh drive C to array (after zeroing any possible superblock on C)
>> 4) wait for C recovery to complete
>>
>> At this point, for some reason "bitmap->events_cleared" is not
>> updated, it remains 0, although the bitmap is clear.
>
> We should update events_cleared after the first write after the array became
> optimal.  I assume you didn't write to the array while the array was
> recovering or afterwards?
You are right, I did not. I tried writing to the array after it
becomes optimal, and indeed events_cleared gets updated, and from this
point I am unable to re-add the drive after growing the array.


>
>>
>> 5) grow the array by one slot:
>> mdadm --grow /dev/md1 --raid-devices=3 --forc
>> 6) re-add drive B back
>> mdadm --manage /dev/md1 --re-add /dev/sdb
>>
>> MD accepts this drive, because in super_1_validate:
>>         /* If adding to array with a bitmap, then we can accept an
>>          * older device, but not too old.
>>          */
>>         if (ev1 < mddev->bitmap->events_cleared)
>>             return 0;
>> Since events_cleared==0, this condition DOES NOT hold, and drive B is accepted
>
> Yes, that is bad.  I guess we need to update events_cleared when recovery
> completes because bits in the bitmap are cleared then too.
>
> Either bitmap_end_sync or the two places that call it need to update
> events_cleared just like bitmap_endwrite does.
>
>>
>> 7) recovery begins and completes immediately as the bitmap is clear
>> 8) issuing "echo check > ..." yields in a lot of mismatched
>> (naturally, as B's data was not synced)
>>
>> Is this a valid scenario? Any idea why events_cleared is not updated?
>
> Yes, scenario is valid.  It is a bug and should be fixed.
>
> Would you like to write and test a patch as discussed above?

I started looking at what's going on in the bitmap code, and I see
that I need to look more:) For example, in bitmap_endwrite() I see
that it sets events_cleared before even checking the value of the
counter. So I definitely don't understand how the bitmap works.

For my particular use-case, once a drive gets replaced like in the
above scenario, it is guaranteed that the old drive will not be
re-added unless its superblock is zeroed. But I wonder if there is
some other scenario, in which not updating bitmap->events_cleared when
recovery completes can bite us.

Thanks,
Alex.



>
> Thanks,
> NeilBrown
>
>
>
>> Kernel is 3.8.13
>>
>> Thanks,
>> Alex.
>
