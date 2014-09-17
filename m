From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Wed, 17 Sep 2014 20:57:13 +0300
Message-ID: <CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
	<20140908171702.5b2853fc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908171702.5b2853fc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Mon, Sep 8, 2014 at 10:17 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 7 Sep 2014 17:18:16 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> we see the following issue:
>>
>> # RAID1 has 2 drives A and B, drive B is recovering
>> # READ request arrives
>> # read_balanace selects drive B to read from, because READ sector
>> comes before B->recovery_offset
>> # READ is issued to drive B, but fails (drive B fails again)
>>
>> Now raid1_end_read_request() has the following code:
>>
>>     if (uptodate)
>>         set_bit(R1BIO_Uptodate, &r1_bio->state);
>>     else {
>>         /* If all other devices have failed, we want to return
>>          * the error upwards rather than fail the last device.
>>          * Here we redefine "uptodate" to mean "Don't want to retry"
>>          */
>>         unsigned long flags;
>>         spin_lock_irqsave(&conf->device_lock, flags);
>>         if (r1_bio->mddev->degraded == conf->raid_disks ||
>>             (r1_bio->mddev->degraded == conf->raid_disks-1 &&
>>              !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
>>             uptodate = 1;
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>     }
>>
>> According to this code uptodate wrongly becomes 1, because:
>> r1_bio->mddev->degraded == conf->raid_disks-1 is TRUE
>> and
>> !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags) is also TRUE
>>
>> Indeed, drive B is not marked as Faulty, but also not marked as In_sync.
>> However, this function treats !Faulty being equal to In_Sync, so it
>> decides that the last good drive failed, so it does not retry the
>> READ.
>>
>> As a result, there is IO error, while we should have retried the READ
>> from the healthy drive.
>>
>> This is happening in 3.8.13, but your master branch seems to have the
>> same issue.
>>
>> What is a reasonable fix?
>> 1) Do not read from drives which are !In_sync (a bit scary to read
>> from such drive)
>
> It is perfectly safe to read from a !In_sync device providing you are before
> ->recovery_offset.
>
>
>> 2) replace !Faulty to In_sync check
>
> That probably makes sense... though that could race with raid1_spare_active().
> If a read-error returned just after raid1_spare_active() set In_sync, and
> before 'count' was subtracted from ->degraded, we would still set uptodate
> when we shouldn't.
> It probably make sense to put all of raid1_spare_active inside the spinlock -
> it doesn't get call often enough that performance is an issue (I hope).
>
> So:
>  1/ change !Faulty to In_sync
>  2/ extend the spinlock in raid1_spare_active to cover the whole function.


I made these fixes and reproduced the issue. However, the result is
not what we expect:

# raid1_end_read_request() now indeed adds the r1_bio into retry_list,
as we wanted
# raid1d calls fix_read_error()
# fix_read_error() searches for an In_sync drive to read the data
from. It finds such drive (this is our good drive A)
# now fix_read_error() wants to rewrite the bad area. But it rewrites
only on those drives that are In_sync (except the drive it got the
data from). In our case, it never tries to rewrite the data on drive B
(drive B is not marked Faulty and not marked In_sync). As a result,
md_error() is not called, so drive B is still not marked as Failed
when fix_read_error() completes
# so handle_read_error() retries the original READ by calling
read_balance(), which again in my case selects the recovering drive
B...

And then the whole flow repeats itself again and again...and READ
never completes.

Maybe we should not allow selecting recovering drives for READ? Or
some other approach?

Thanks,
Alex.




>
> Thanks,
> NeilBrown
