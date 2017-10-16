From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Mon, 16 Oct 2017 16:56:09 -0700
Message-ID: <20171016235609.mmo3vbqiekr4li5c@kernel.org>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
 <87bmldnjtq.fsf@notabene.neil.brown.name>
 <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
 <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
 <87wp3zlj9q.fsf@notabene.neil.brown.name>
 <20171013195122.mi7gr4xxm77odx7t@kernel.org>
 <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com>
 <877evulrpm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877evulrpm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Tue, Oct 17, 2017 at 08:15:33AM +1100, Neil Brown wrote:
> On Mon, Oct 16 2017, Song Liu wrote:
> 
> >> On Oct 13, 2017, at 12:51 PM, Shaohua Li <shli@kernel.org> wrote:
> >> 
> >> On Fri, Oct 13, 2017 at 04:16:33PM +1100, Neil Brown wrote:
> >>> On Thu, Oct 12 2017, Song Liu wrote:
> >>> 
> >>>>> On Oct 12, 2017, at 10:30 AM, Shaohua Li <shli@kernel.org> wrote:
> >>>>> 
> >>>>> On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
> >>>>>> On Tue, Oct 10 2017, Shaohua Li wrote:
> >>>>>> 
> >>>>>>> From: Shaohua Li <shli@fb.com>
> >>>>>>> 
> >>>>>>> If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary. Limit
> >>>>>>> the read size to the end of disk. Write path already has similar limitation.
> >>>>>>> 
> >>>>>>> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
> >>>>>>> Reported-by: Joshua Kinard <kumba@gentoo.org>
> >>>>>>> Tested-by: Joshua Kinard <kumba@gentoo.org>
> >>>>>>> Cc: Song Liu <songliubraving@fb.com>
> >>>>>>> Signed-off-by: Shaohua Li <shli@fb.com>
> >>>>>> 
> >>>>>> Given that this bug was introduced by
> >>>>>> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
> >>>>>> 
> >>>>>> and that patch is markted:
> >>>>>> 
> >>>>>>   Cc: stable@vger.kernel.org (4.10+)
> >>>>>> 
> >>>>>> I think this patch should be tagged "CC: stable" too.
> >>>>> 
> >>>>> I thought the Fix tag is enough, but I'll add the stable 
> >>>>>> However ... that earlier patch looks strange to me.
> >>>>>> Why is it that "raid5 cache could write bitmap superblock before bitmap superblock is
> >>>>>> initialized."  Can we just get raid5 cache *not* to write the bitmap
> >>>>>> superblock too early?
> >>>>>> I think that would better than breaking code that previously worked.
> >>>>> 
> >>>>> That's the log reply code, which must update superblock and hence bitmap
> >>>>> superblock, because reply happens very earlier. I agree the reply might still
> >>>>> have problem with bitmap. We'd better defer reply after the raid is fully
> >>>>> initialized. Song, any idea?
> >>>>> 
> >>>> 
> >>>> With write back cache, there are two different types of stripes in recovery:
> >>>> data-parity, and data-only. For data-parity stripes, we can simply replay data
> >>>> from the journal. But for data-only stripes, we need to do rcw or rmw to update
> >>>> parities. Currently, the writes are handled with raid5 state machine. Therefore,
> >>>> we wake up mddev->thread in r5l_recovery_log(). It is necessary to finish these 
> >>>> stripes before we fully initialize the array, because these stripes need to be 
> >>>> handled with write back state machine; while we we always start the array with 
> >>>> write through journal_mode. 
> >>>> 
> >>>> Maybe we can fix this by change the order of initialization in md_run(), 
> >>>> specifically, moving bitmap_create() before pers->run(). 
> >>> 
> >>> I've looked at some of the details here now.
> >>> 
> >>> I think I would like raid5-cache to not perform any recovery until we
> >>> reach
> >>> 
> >>> 
> >>> 	md_wakeup_thread(mddev->thread);
> >>> 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
> >>> 
> >>> 
> >>> in do_md_run().  Before that point it is possible to fail and abort -
> >>> e.g. if bitmap_load() fails.
> >>> 
> >>> Possibly we could insert another personality call here "->start()" ??
> >>> That could then do whatever is needed before
> >>> 
> >>> 	set_capacity(mddev->gendisk, mddev->array_sectors);
> >>> 	revalidate_disk(mddev->gendisk);
> >>> 
> >>> makes the array accessible.
> >>> 
> >>> Might that be reasonable?
> >> 
> >> Looks good. I think we should call the ->start before
> >> md_wakeup_thread(mddev->thread); because we don't want to start recovery before
> >> log is recovered.
> >
> > I also like this idea. In the coming month, I won't have much bandwidth to 
> > implement this. Please let me know if you want to make the change. Otherwise, 
> > I will do it later (in December, I guess). 
> 
> It isn't something we should rush so take your time.
> However I think we need to clean up the patches that have gone to
> -stable.
> I think
>  Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
> should be reverted (in -stable too) and possibly be replaced by a patch
> which refuses any attempt to combine a bitmap with a journal.
> As Shaohua pointed that, that shouldn't really be needed anyway.
> That would address the issue that 8031c3ddc70a was meant to fix.
> I can write that patch if necessary.

Sounds good to me. Appreciate if you write the patch.

Thanks,
Shaohua
