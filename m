From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid5 write latency is 10x the drive latency
Date: Tue, 4 Mar 2014 11:41:25 +0200
Message-ID: <CAGRgLy542j-G2WAbRdqGf26xfnQ5wkCqnEmgPecHtEp-WpXOSA@mail.gmail.com>
References: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
	<21268.65296.503057.601739@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21268.65296.503057.601739@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter,
Thank you for your response.

On Tue, Mar 4, 2014 at 12:15 AM, Peter Grandi <pg@lxra2.for.sabi.co.uk> wrote:
>> We are testing a fully random 8K write IOMETER workload on a
>> raid5 md, composed of 5 drives. [ ... ]
>
> "Doctor, if I stab my hand very hard with a fork it hurts a lot,
> what can you do about that?"
>
>> We see that the write latency that the MD device demonstrates
>
> Congratulations on reckoning that write latency matters. People
> who think they know better and use parity RAID usually manage to
> forget about write latency.
>
> Also congratulations on using a reasonable member count of 4+1.
Thank you, Peter.


>
>> is 10 times the latency of individual drives. [ ... ]
>
> The latency of what actually?
>
> That's what 'iostat' reports for "something". The definition of
> 'await' if that's what you are looking may be interesting.
>
Yes, r_await and w_await is what I am looking at.

> Also, what does your tool report?
>
>   BTW, why not use 'fio' which along with some versions of
>   Garloff's version of 'bonnie' is one of the few reliable
>   speed-testing tools (with the right options...).
>
> Also what type of device? Which size of the stripe cache (very
> important)?
>
> Which chunk size? Which drive write cache setting? Which use of
> barriers? Which filesystem? Which elevator? Which flusher
> parameters? Which tool settings? How many threads?
As you probably know, each entry in the MD stripe cache is a kind of a
mini-stripe of 4K blocks (this is what is called "struct stripe_head"
in the code). So for example, when using 64K MD chunk size and 8K
write-size, it may be required to load and update 2 stripe-heads to
satisfy the write. With 4K write-size and 4K MD chunk size, for
example, it is needed to load and update a single stripe-head to
satisfy the write.
In my test, MD chunk size is 64K, so yes, it is needed to load more
than one stripe-head each time. With 4K write-size, there is not much
difference, actually, there are still some milliseconds "unaccounted".

As for other parameters you mentioned, I can post all of them, but at
this point, I only care how much write latency MD adds above the write
latency that the drives demonstrate. I am not sure why you find this
funny, BTW.

>
> Because some of the numbers look a bit amazing or strange:
>
> * Only 20% of IOPS are reads, which is pretty miraculous.
>
> * 'dm-33' seems significantly faster (seek times) than the other
>   members.
>
> * Each drive delivers over 1,000 4kiB IOPS (mixed r/W), which is
>   also pretty miraculous if they are disk drives, and terrible if
>   they are flash drives.
>
> * That ~50ms full wait-time per IO seems a bit high to me at a
>   device utilization of around 70%, and a bit inconsistent with
>   the ability of each device to process 1,000 IOPS.
>
> * In your second set of numbers utilization remains the same,the
>   per-disk write await doubles to around 90-100ms, average queue
>   size nearly doubles too, but 4kiB write IOPS go up to by 50%,
>   and the percent of reads goes down to 16.6% almost exactly.
>   These numbers tell a story, a pretty strong story.
>

>> [ ... ] with RMW that raid5 is doing, we can expect 2x of the
>> drive latency
>
> HAHAHAHAHAHA! HAHAHAHAHAHAHAHAHA! You made my day.
>
>> (1x to load the stipe-head, 1x to update the required
>> stripe-head blocks on disk).
>
> Amazing! Send patches! :-)
I studied the raid5 code at some point, and here is the flow for
writing a 4Kb block onto a 2+1 raid5 with 4K chunk size:

add_stripe_bio: bio is attached to the stripe
analyse_stripe
handle_stripe_fill
handle_stripe_dirtying: here the second data drive is marked for "read"
ops_run_io: here it submits the READ bio
raid5_end_read_request: READ bio is completed, raid5d will complete
handling this stripe
analyse_stripe
handle_stripe_dirtying()->schedule_reconstruction()
__raid_run_ops
ops_run_biodrain: here user bio is copied into the stripe-head's block
of the data drive that we didn't read
ops_run_reconstruct5
ops_complete_reconstruct: parity calculation is done, processing will
resume in raid5d
analyse_stripe
handle_stripe: sets R5_Wantwrite on the parity and data r5devs
ops_run_io: schedules the writes
raid5_end_write_request: called two times: on parity and data drive
This completes the flow, and eventually user bio is completed.

So besides loaing and writing out the stripe-head, there is only the
parity calculation, which I don't know at this point how much time
does it take. (In my test, the CPU had a good amount of idle time,
BTW).
Do you agree that this is the flow? Or you see some other places,
where millis can be spent, which I missed?

>
>> raid5d thread is busy updating the bitmap
>
> Using a bitmap and worrying about write latency, I had not even
> thought about that as a possibility. Extremely funny!
Can you please clarify what to do you find so funny here? Should I not
use the bitmap?

>
>> commented out the bitmap_unplug call
>
> Ah plugging/unplugging one of the great examples of sheer
> "genius" in the Linux code. We can learn a lot from it :-).
Again, can you please clarify? I was only trying to see whether raid5d
does some other blocking operation, besides the bitmap update, and I
learned that it doesn't. I realize that the bitmap update is required,
just wanted to see if there is anything else that was blocking. Do you
see anything wrong with this approach?

>
>> Typically - without the bitmap update - raid5 call takes
>> 400-500us, so I don't understand how the additional ~100ms of
>> latency is gained
>
> That's really really funny! Thanks! :-)
Again, can you please clarify? I am happy to make your day, but if
since you have taken time to comment on my email, I would like to at
least understand what you meant.

Thanks,
Alex.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
