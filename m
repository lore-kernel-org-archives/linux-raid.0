From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: BUG - raid 1 deadlock on handle_read_error / wait_barrier
Date: Sat, 8 Jun 2013 12:45:41 +0300
Message-ID: <CAGRgLy5yWdo4qu5kKsaYjzTwRJNQB_87vPKOFx71FCUxjd6K_w@mail.gmail.com>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
	<20130225110458.2b1b1e2d@notabene.brown>
	<1361808662.20264.4.camel@148>
	<alpine.DEB.2.02.1302260905390.1736@jlaw-desktop.mno.stratus.com>
	<CAGRgLy45byT7fxLBOqU6ZNjpOL0Xmq6nNsiwJSCTq+kd1Ya7Jg@mail.gmail.com>
	<20130520171753.002f07d9@notabene.brown>
	<CAGRgLy5m8KxKPxJE+AbtYbBDzo9uo81wez1ba=H4VY3Jiq32WQ@mail.gmail.com>
	<CAGRgLy4zTwopPS-cVwT1RKBr8pE7f3n-X3YLyFpktooQtTYGuQ@mail.gmail.com>
	<20130604114924.37e4573c@notabene.brown>
	<51B0A40A.2010208@bluehost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B0A40A.2010208@bluehost.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, yair@zadarastorage.com, Tregaron Bayly <tbayly@bluehost.com>
List-Id: linux-raid.ids

Hi Neil,
after reading the code of raid1.c, I see that there's also
conf->retry_list, which is also flushed by raid1d, but not by
flush_pending_writes(). So I think it can also cause similar deadlock,
but I don't know how to fix it:(

Alex.


On Thu, Jun 6, 2013 at 6:00 PM, Tregaron Bayly <tbayly@bluehost.com> wrote:
> On 06/03/2013 07:49 PM, NeilBrown wrote:
>>
>> On Sun, 2 Jun 2013 15:43:41 +0300 Alexander Lyakas
>> <alex.bolshoy@gmail.com>
>> wrote:
>>
>>> Hello Neil,
>>> I believe I have found what is causing the deadlock. It happens in two
>>> flavors:
>>>
>>> 1)
>>> # raid1d() is called, and conf->pending_bio_list is non-empty at this
>>> point
>>> # raid1d() calls md_check_recovery(), which eventually calls
>>> raid1_add_disk(), which calls raise_barrier()
>>> # Now raise_barrier will wait for conf->nr_pending to become 0, but it
>>> cannot become 0, because there are bios sitting in
>>> conf->pending_bio_list, which nobody will flush, because raid1d is the
>>> one supposed to call flush_pending_writes(), either directly or via
>>> handle_read_error. But it is stuck in raise_barrier.
>>>
>>> 2)
>>> # raid1_add_disk() calls raise_barrier(), and waits for
>>> conf->nr_pending to become 0, as before
>>> # new WRITE comes and calls wait_barrier(), but this thread has a
>>> non-empty current->bio_list
>>> # In this case, the code allows the WRITE to go through
>>> wait_barrier(), and trigger WRITEs to mirror legs, but these WRITEs
>>> again end up in conf->pending_bio_list (either via raid1_unplug or
>>> directly). But nobody will flush conf->pending_bio_list, because
>>> raid1d is stuck in raise_barrier.
>>>
>>> Previously, for example in kernel 3.2, raid1_add_disk did not call
>>> raise_barrier, so this problem did not happen.
>>>
>>> Attached is a reproduction with some prints that I added to
>>> raise_barrier and wait_barrier (their code also attached). It
>>> demonstrates case 2. It shows that once raise_barrier got called,
>>> conf->nr_pending drops down, until it equals the number of
>>> wait_barrier calls, that slipped through because of non-empty
>>> current->bio_list. And at this point, this array hangs.
>>>
>>> Can you please comment on how to fix this problem. It looks like a
>>> real deadlock.
>>> We can perhaps call md_check_recovery() after flush_pending_writes(),
>>> but this only makes the window smaller, not closes it entirely. But it
>>> looks like we really should not be calling raise_barrier from raid1d.
>>>
>>> Thanks,
>>> Alex.
>>
>>
>> Hi Alex,
>>   thanks for the analysis.
>>
>> Does the following patch fix it?  It makes raise_barrier  more  like
>> freeze_array().
>> If not, could you try making the same change to the first
>> wait_event_lock_irq in raise_barrier?
>>
>> Thanks.
>> NeilBrown
>>
>>
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 328fa2d..d34f892 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -828,9 +828,9 @@ static void raise_barrier(struct r1conf *conf)
>>         conf->barrier++;
>>
>>         /* Now wait for all pending IO to complete */
>> -       wait_event_lock_irq(conf->wait_barrier,
>> -                           !conf->nr_pending && conf->barrier <
>> RESYNC_DEPTH,
>> -                           conf->resync_lock);
>> +       wait_event_lock_irq_cmd(conf->wait_barrier,
>> +                               !conf->nr_pending && conf->barrier <
>> RESYNC_DEPTH,
>> +                               conf->resync_lock,
>> flush_pending_writes(conf));
>>
>>         spin_unlock_irq(&conf->resync_lock);
>>   }
>>
>
> Neil,
>
> This deadlock also cropped up in 3.4 between .37 and .38.  Passing
> flush_pending_writes(conf) as cmd to wait_event_lock_irq seems to fix it
> there as well.
>
> --- linux-3.4.38/drivers/md/raid1.c     2013-03-28 13:12:41.000000000 -0600
> +++ linux-3.4.38.patch/drivers/md/raid1.c       2013-06-04
> 12:17:35.314194903 -0600
> @@ -751,7 +751,7 @@
>
>         /* Now wait for all pending IO to complete */
>         wait_event_lock_irq(conf->wait_barrier,
>
>                             !conf->nr_pending && conf->barrier <
> RESYNC_DEPTH,
> -                           conf->resync_lock, );
>
> +                           conf->resync_lock, flush_pending_writes(conf));
>          spin_unlock_irq(&conf->resync_lock);
>  }
>
> Thanks,
>
> Tregaron
