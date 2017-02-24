From: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove
 resync window
Date: Fri, 24 Feb 2017 11:19:05 +0100
Message-ID: <CAD9gYJ+FqnFbJp3sY9k5j=ZtJiN6qPivJ665hJPX94eWaAMkJA@mail.gmail.com>
References: <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de> <87shn9spsy.fsf@notabene.neil.brown.name>
 <87k28lshg5.fsf@notabene.neil.brown.name> <20170220070430.4mca7clpaw7kpj4j@kernel.org>
 <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de> <878tp0s7w8.fsf@notabene.neil.brown.name>
 <f36e85b1-cca1-5be4-a171-d64057cc56a3@suse.de> <20170221174542.rer73ywil3oq26gj@kernel.org>
 <c04d68cd-96e8-dff9-c54e-54248394119f@suse.de> <488f88e0-8111-a320-3abb-c6e6611a957e@suse.de>
 <20170223173418.qrgjpj6utgceg5f4@kernel.org> <b6134a31-6cf6-3ea4-a3e5-0073c38c3a51@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b6134a31-6cf6-3ea4-a3e5-0073c38c3a51@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Hi Coly, Hi Shaohua,


>
> Hi Shaohua,
>
> I try to catch up with you, let me try to follow your mind by the
> split-in-while-loop condition (this is my new I/O barrier patch). I
> assume the original BIO is a write bio, and original bio is split and
> handled in a while loop in raid1_make_request().

It's still possible for read bio. We hit a deadlock in the past.
See https://patchwork.kernel.org/patch/9498949/

Also:
http://www.spinics.net/lists/raid/msg52792.html

Regards,
Jack

>
>> 1. in level1, set current->bio_list, split bio to bio1 and bio2
>
> This is done in level1 raid1_make_request().
>
>> 2. remap bio1 to level2 disk, and queue bio1-level2 in current->bio_list
>
> Remap is done by raid1_write_request(), and bio1_level may be added into
> one of the two list:
> - plug->pending:
>   bios in plug->pending may be handled in raid1_unplug(), or in
> flush_pending_writes() of raid1d().
>   If current task is about to be scheduled, raid1_unplug() will merge
> plug->pending's bios to conf->pending_bio_list. And
> conf->pending_bio_list will be handled in raid1d.
>   If raid1_unplug() is triggered by blk_finish_plug(), it is also
> handled in raid1d.
>
> - conf->pending_bio_list:
>   bios in this list is handled in raid1d by calling flush_pending_writes().
>
>
> So generic_make_request() to handle bio1_level2 can only be called in
> context of raid1d thread, bio1_level2 is added into raid1d's
> bio_list_on_stack, not caller of level1 generic_make_request().
>
>> 3. queue bio2 in current->bio_list
>
> Same, bio2_level2 is in level1 raid1d's bio_list_on_stack.
> Then back to level1 generic_make_request()
>
>> 4. generic_make_request then pops bio1-level2
>
> At this moment, bio1_level2 and bio2_level2 are in either plug->pending
> or conf->pending_bio_list, bio_list_pop() returns NULL, and level1
> generic_make_request() returns to its caller.
>
> If before bio_list_pop() called, kernel thread raid1d wakes up and
> iterates conf->pending_bio_list in flush_pending_writes() or iterate
> plug->pending in raid1_unplug() by blk_finish_plug(), that happens in
> level1 raid1d's stack, bios will not show up in level1
> generic_make_reques(), bio_list_pop() still returns NULL.
>
>> 5. remap bio1-level2 to level3 disk, and queue bio1-level2-level3 in current->bio_list
>
> bio2_level2 is at head of conf->pending_bio_list or plug->pending, so
> bio2_level2 is handled firstly.
>
> level1 raid1 calls level2 generic_make_request(), then level2
> raid1_make_request() is called, then level raid1_write_request().
> bio2_level2 is remapped to bio2_level3, added into plug->pending (level1
> raid1d's context) or conf->pending_bio_list (level2 raid1's conf), it
> will be handled by level2 raid1d, when level2 raid1d wakes up.
> Then returns back to level1 raid1, bio1_level2
> is handled by level2 generic_make_request() and added into level2
> plug->pending or conf->pending_bio_list. In this case neither
> bio2_level2 nor bio1_level is added into any bio_list_on_stack.
>
> Then level1 raid1d handles all bios in level1 conf->pending_bio_list,
> and sleeps.
>
> Then level2 raid1d wakes up, and handle bio2_level3 and bio1_level3, by
> iterate level2 plug->pending or conf->pending_bio_list, and calling
> level3 generic_make_request().
>
> In level3 generic_make_request(), because it is level2 raid1d context,
> not level1 raid1d context, bio2_level3 is send into
> q->make_request_fn(), and finally added into level3 plug->pending or
> conf->pending_bio_list, then back to level3 generic_make_reqeust().
>
> Now level2 raid1d's current->bio_list is empty, so level3
> generic_make_request() returns to level2 raid1d and continue to iterate
> and send bio1_level3 into level3 generic_make_request().
>
> After all bios are added into level3 plug->pending or
> conf->pending_bio_list, level2 raid1d sleeps.
>
> Now level3 raid1d wakes up, continue to iterate level3 plug->pending or
> conf->pending_bio_list by calling generic_make_request() to underlying
> devices (which might be a read device).
>
> On the above whole patch, each lower level generic_make_request() is
> called in context of the lower level raid1d. No recursive call happens
> in normal code path.
>
> In raid1 code, recursive call of generic_make_request() only happens for
> READ bio, but if array is not frozen, no barrier is required, it doesn't
> hurt.
>
>
>> 6. generic_make_request then pops bio2, but bio1 hasn't finished yet, deadlock
>
> As my understand to the code, it won't happen neither.
>
>>
>> The problem is because we add new bio to current->bio_list tail.
>
> New bios are added into other context's current->bio_list, which are
> different lists. If what I understand is correct, a dead lock won't
> happen in this way.
>
> If my understanding is correct, suddenly I come to realize why raid1
> bios are handled indirectly in another kernel thread.
>
> (Just for your information, when I write to this location, another run
> of testing finished, no deadlock. This time I reduce I/O barrier bucket
> unit size to 512KB, and set blocksize to 33MB in fio job file. It is
> really slow (130MB/s), but no deadlock observed)
>
>
> The stacked raid1 devices are really really confused, if I am wrong, any
> hint is warmly welcome.
>
>>
>>> =============== P.S ==============
>>> When I run the stacked raid1 testing, I feel I see something behavior
>>> suspiciously, it is resync.
>>>
>>> The second time when I rebuild all the raid1 devices by "mdadm -C
>>> /dev/mdXX -l 1 -n 2 /dev/xxx /dev/xxx", I see the top level raid1 device
>>> /dev/md40 already accomplished 50%+ resync. I don't think it could be
>>> that fast...
>>
>> no idea, is this reproducible?
>
> It can be stably reproduced. I need to check whether bitmap is cleaned
> when create a stacked raid1. This is a little off topic in this thread,
> once I have some idea, I will send out another topic. Hope it is just so
> fast.
>
> Coly
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
