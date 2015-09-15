From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid1 resync stuck
Date: Tue, 15 Sep 2015 11:25:59 -0400
Message-ID: <wrfj1tdzvh4o.fsf@redhat.com>
References: <wrfjmvwvz9ke.fsf@redhat.com> <wrfjsi6k4zqy.fsf@redhat.com>
	<8737yg6rbl.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737yg6rbl.fsf@notabene.neil.brown.name> (Neil Brown's message
	of "Tue, 15 Sep 2015 10:05:02 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: majianpeng@gmail.com, linux-raid <linux-raid@vger.kernel.org>, nate.dailey@stratus.com
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>>> crash> r1conf 0xffff882028f3e600 | grep -e array_frozen -e barrier -e start_next_window -e next_resync
>>>   barrier = 0x1,                      (conf->barrier < RESYNC_DEPTH)
>>>   array_frozen = 0x0,                 (!conf->array_frozen)
>>>   next_resync = 0x3000,
>>>   start_next_window = 0x3000,
>>>
>>> ie. next_resync == start_next_window, which will never wake up since
>>> start_next_window is smaller than next_resync + RESYNC_SECTORS.
>>>
>>> Have you seen anything like this?
>>
>> Looking further at this together with Nate. It looks like you had a
>> patch resolving something similar:
>
> I hope you realize that this a confirming-instance of my hypothesis that
> if I just ignore questions, the asker will eventually solve it
> themselves?  Maybe I should just wait a bit longer...

Argh I screwed up again! :)

>> It looks to us like close_sync()'s conf->start_next_window = MaxSector
>> results in wait_barrier() triggering this when the outstanding IO
>> completes:
>>
>> 	if (bio && bio_data_dir(bio) == WRITE) {
>> 		if (bio->bi_sector >=
>> 		    conf->mddev->curr_resync_completed) {
>> 			if (conf->start_next_window == MaxSector)
>> 				conf->start_next_window =
>> 					conf->next_resync +
>> 					NEXT_NORMALIO_DISTANCE;
>>
>> putting us into the situation where raise_barrier()'s condition never
>> completes:
>>
>> 	wait_event_lock_irq(conf->wait_barrier,
>> 			    !conf->array_frozen &&
>> 			    conf->barrier < RESYNC_DEPTH &&
>> 			    conf->current_window_requests == 0 &&
>> 			    (conf->start_next_window >=
>> 			     conf->next_resync + RESYNC_SECTORS),
>> 			    conf->resync_lock);
>>
>> So the question is, is it wrong for close_sync() to be setting
>> conf->start_next_window = MaxSector in the first place, or should it
>> only be doing this once all outstanding I/O has completed?
>
> I think it is right to set start_next_window = MaxSector, but I think it
> is wrong to set ->next_resync = 0;
>
> I think:
>  close_sync() should set next_sync to some impossibly big number,
>    but not quite MaxSector as we sometimes add RESYNC_SECTORS or
>    NEXT_NORMALIO_DISTANCE.
>    May mddev->resync_max_sectors would be sensible.  Then raid1_resize
>    would need to update it though.
>    Or maybe we should make MaxSector a bit smaller so it is safe to
>    add to it. ((~(sector_t)0)>>1) ??
>
>  wait_barrier() should include ->next_resync in its decision about
>    setting start_next_window.  May just replace
>    "mddev->curr_resync_completed" with "next_resync".
>
> Can you try that?  Does it make sense to you too?

I think this makes sense - I'll spin a patch for it and see how it
works out.

Cheers,
Jes
