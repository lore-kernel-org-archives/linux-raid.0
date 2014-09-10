From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Question about RAID1 plug/unplug code
Date: Wed, 10 Sep 2014 11:01:30 +0300
Message-ID: <CAGRgLy6iLnxY-gHELBXhd4uymM3CoPVFM5yWdRpQC9Hk7vnf4g@mail.gmail.com>
References: <CAGRgLy4WTXdF4Tp1pf0BJ-VPR3Yhx_xyzbCAXBzNDpeYTPvkmw@mail.gmail.com>
	<20140909114538.552a4a7d@notabene.brown>
	<CAGRgLy4QAz6KVncLsVypsOD85jMUNaOgrFc13=knHMXb92SvXw@mail.gmail.com>
	<20140909194532.621f4500@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140909194532.621f4500@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Yair Hershko <yair@zadarastorage.com>
List-Id: linux-raid.ids

Hello Neil,

On Tue, Sep 9, 2014 at 12:45 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 9 Sep 2014 11:33:13 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>>
>>
>> On Tue, Sep 9, 2014 at 4:45 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Mon, 8 Sep 2014 16:55:52 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
>> > wrote:
>> >
>> >> Hi Neil,
>> >> We have been seeing high latency on the md/raid1 block device, due to
>> >> the fact that all WRITEs are handed off to raid1d thread. This thread
>> >> also calls bitmap_unplug(), which writes the bitmap synchronously.
>> >> While it waits for the bitmap, it cannot trigger other WRITEs waiting
>> >> in its pending_bio_list. This is especially seen with SSDs: MD's
>> >> latency is much higher that SSD latency (I have been stoned by Peter
>> >> Grandi when I brought up this issue previously for raid5).
>> >>
>> >> Then I have noticed the commit:
>> >>
>> >> commit f54a9d0e59c4bea3db733921ca9147612a6f292c
>> >> Author: NeilBrown <neilb@suse.de>
>> >> Date:   Thu Aug 2 08:33:20 2012 +1000
>> >>
>> >>     md/raid1: submit IO from originating thread instead of md thread.
>> >>
>> >> Looking at the code, I learned that to avoid switching into raid1d,
>> >> the caller has to use blk_start_plug/blk_finish_plug. So I added these
>> >> calls in our kernel module, which submits bios to MD. Results were
>> >> awesome, MD latency got down significantly.
>> >
>> > That's good to hear.
>> >
>> >>
>> >> So I have several questions about this plug/unplug thing.
>> >>
>> >> 1/ Originally this infrastructure was supposed to help IO schedulers
>> >> in merging requests. It is useful when one has a bunch of requests to
>> >> submit in one shot.
>> >
>> > That is exactly the whole point of plugging:  allow the device to handle a
>> > batch of requests together instead of one at a time.
>> >
>> >> But in MD case, thus infrastructure is used for a different purpose:
>> >> not to merge requests (which may help bandwidth, but probably not
>> >> latency), but to avoid making raid1d a bottleneck, to be able to
>> >> submit requests from multiple threads in parallel, which brings down
>> >> latency significantly in our case. Indeed "struct blk_plug" has a
>> >> special "cb_list", which is used only by MD.
>> >
>> > I don't think the way md uses plugging is conceptually different from any
>> > other use: it is always about gathering a batch together.
>> > "cb_list" is handled by blk_check_plugged() which is also used by
>> > block/umem.c and btrfs.
>> >
>> > The base plugging code assumes that it is only gathering a batch of requests
>> > for a single device - if the target device changes then the batch is flushed.
>> > It also assumed that it was "struct request" that was batched.
>> > Devices like md that want to queue 'struct bio', something else was needed.
>> > Also with layered devices it can be useful to gather multiple batches for
>> > multiple layers.
>> > So I created "cb_list" etc and a more generic interface.
>> >
>> >> In my case I have only individual bios (not a bunch of bios), and I
>> >> after wrap them with plug/unplug, MD latency gets better. So we are
>> >> using the plug infrastructure for a different purpose.
>> >> Is my understanding correct? Was this your intention?
>> >
>> > I don't really understand what you are doing.  There is no point in using
>> > plugging for individual bios.  The  main point for raid1 writes is to gather
>> > a lot of writes together so that all multiple bitmap bits can be set all at
>> > once.
>> > It should be possible to submit individual bios directly from make_request
>> > without passing them to raid1d and without using plugging.
>> Can you pls explain how it is possible?
>> You have this code for WRITEs:
>>         cb = blk_check_plugged(raid1_unplug, mddev, sizeof(*plug));
>>         if (cb)
>>             plug = container_of(cb, struct raid1_plug_cb, cb);
>>         else
>>             plug = NULL;
>>         spin_lock_irqsave(&conf->device_lock, flags);
>>         if (plug) {
>>             bio_list_add(&plug->pending, mbio);
>>             plug->pending_cnt++;
>>         } else {
>>             bio_list_add(&conf->pending_bio_list, mbio);
>>             conf->pending_count++;
>>         }
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>
>> If the thread blk_check_plugged returns NULL, then you always hand the
>> WRITE to raid1d. So the only option to avoid handoff to raid1d is for
>> the caller to plug. Otherwise, all WRITEs are handed off to raid1d and
>> latency becomes terrible.
>> So in my case, I use plug/unplug for individual bios only to avoid the
>> handoff to raid1d.
>> What am I missing in this analysis?
>
> if blk_check_plugged succeeds then it has arranged for raid1_unplug to be
> called a little later by that same process.
> So there is nothing to stop you calling raid1_unplug immediately.
>
> raid1_unplug essentially does:
>   bitmap_unplug()
>   generic_make_request()
>
> so you can very nearly just do that, without any plugging.
I am sorry, but I did not understand your reply. Maybe I did not
explain myself, I will try again.

I am not changing raid1.c code. I just want to avoid the handoff to
raid1d on WRITEs. According to your code, there are only two possible
flows:

Flow 1 - with plugging
# caller calls blk_start_plug
# caller calls submit_bio
# blk_check_plugged succeeds, and bio is put onto plug->pending list
# caller calls blk_finish_plug
# raid1_unplug is called in the same caller's thread, so it does
bitmap_unplug and generic_make_request

Flow 2 - without plugging
# caller calls submit_bio
# blk_check_plugged fails, and bio is put onto conf->pending_bio_list,
which means it will be submitted by raid1d

My conclusion from that: to avoid the handoff to raid1, caller always
need to plug, even if it has a single bio to submit. But you said "it
should be possible to submit individual bios directly from
make_request without passing them to raid1d and without using
plugging". So can you explain how it is possible? I prefer not to
change raid1.c code.

>
> There is a bit of extra subtlety but I can't really know how relevant that
> might be to you without actually seeing you code.
My code (in a different kernel module, not in raid1.c) is simply doing
submit_bio. I want to wrap this with plug/unplug to avoid the handoff
to raid1d and improve raid1 latency.

Thanks,
Alex.


>
> NeilBrown
