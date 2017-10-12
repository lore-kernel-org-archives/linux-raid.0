From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Thu, 12 Oct 2017 15:51:06 -0700
Message-ID: <20171012225106.wodh2g255bt6aqar@kernel.org>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
 <87bmldnjtq.fsf@notabene.neil.brown.name>
 <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
 <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
 <87r2u8m43o.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r2u8m43o.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Fri, Oct 13, 2017 at 08:46:35AM +1100, Neil Brown wrote:
> On Thu, Oct 12 2017, Song Liu wrote:
> 
> >> On Oct 12, 2017, at 10:30 AM, Shaohua Li <shli@kernel.org> wrote:
> >> 
> >> On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
> >>> On Tue, Oct 10 2017, Shaohua Li wrote:
> >>> 
> >>>> From: Shaohua Li <shli@fb.com>
> >>>> 
> >>>> If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary. Limit
> >>>> the read size to the end of disk. Write path already has similar limitation.
> >>>> 
> >>>> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
> >>>> Reported-by: Joshua Kinard <kumba@gentoo.org>
> >>>> Tested-by: Joshua Kinard <kumba@gentoo.org>
> >>>> Cc: Song Liu <songliubraving@fb.com>
> >>>> Signed-off-by: Shaohua Li <shli@fb.com>
> >>> 
> >>> Given that this bug was introduced by
> >>> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
> >>> 
> >>> and that patch is markted:
> >>> 
> >>>    Cc: stable@vger.kernel.org (4.10+)
> >>> 
> >>> I think this patch should be tagged "CC: stable" too.
> >> 
> >> I thought the Fix tag is enough, but I'll add the stable 
> >>> However ... that earlier patch looks strange to me.
> >>> Why is it that "raid5 cache could write bitmap superblock before bitmap superblock is
> >>> initialized."  Can we just get raid5 cache *not* to write the bitmap
> >>> superblock too early?
> >>> I think that would better than breaking code that previously worked.
> >> 
> >> That's the log reply code, which must update superblock and hence bitmap
> >> superblock, because reply happens very earlier. I agree the reply might still
> >> have problem with bitmap. We'd better defer reply after the raid is fully
> >> initialized. Song, any idea?
> >> 
> >
> > With write back cache, there are two different types of stripes in recovery:
> > data-parity, and data-only. For data-parity stripes, we can simply replay data
> > from the journal. But for data-only stripes, we need to do rcw or rmw to update
> > parities. Currently, the writes are handled with raid5 state machine. Therefore,
> > we wake up mddev->thread in r5l_recovery_log(). It is necessary to finish these 
> > stripes before we fully initialize the array, because these stripes need to be 
> > handled with write back state machine; while we we always start the array with 
> > write through journal_mode. 
> >
> > Maybe we can fix this by change the order of initialization in md_run(), 
> > specifically, moving bitmap_create() before pers->run(). 
> 
> I was thinking exactly this as I was looking at the code.  ->run can
> start recovery happening, and having that happen before the bitmap is
> ready is wrong.
> Maybe there is enough locking that things won't happen in the wrong
> order, but it does look a bit odd.
> Thanks for the explanation about the interaction between the journal and
> the bitmaps.  I'll dig into the code and see what I find.  Then maybe we
> can compare notes.

On the other hand, is there any value to let bitmap and journal co-exist?
Sounds not to me, if journal is enabled, bitmap is useless. Should we just not
allow array with both bitmap and journal enabled?

Thanks,
Shaohua
