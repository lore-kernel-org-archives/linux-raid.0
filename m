From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Thu, 12 Oct 2017 10:30:19 -0700
Message-ID: <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
 <87bmldnjtq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bmldnjtq.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, kumba@gentoo.org, Shaohua Li <shli@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
> On Tue, Oct 10 2017, Shaohua Li wrote:
> 
> > From: Shaohua Li <shli@fb.com>
> >
> > If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary. Limit
> > the read size to the end of disk. Write path already has similar limitation.
> >
> > Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
> > Reported-by: Joshua Kinard <kumba@gentoo.org>
> > Tested-by: Joshua Kinard <kumba@gentoo.org>
> > Cc: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Shaohua Li <shli@fb.com>
> 
> Given that this bug was introduced by
> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
> 
> and that patch is markted:
> 
>     Cc: stable@vger.kernel.org (4.10+)
> 
> I think this patch should be tagged "CC: stable" too.

I thought the Fix tag is enough, but I'll add the stable 
> However ... that earlier patch looks strange to me.
> Why is it that "raid5 cache could write bitmap superblock before bitmap superblock is
> initialized."  Can we just get raid5 cache *not* to write the bitmap
> superblock too early?
> I think that would better than breaking code that previously worked.

That's the log reply code, which must update superblock and hence bitmap
superblock, because reply happens very earlier. I agree the reply might still
have problem with bitmap. We'd better defer reply after the raid is fully
initialized. Song, any idea?

Thanks,
Shaohua 
