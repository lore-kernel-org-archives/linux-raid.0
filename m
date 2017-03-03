From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 06/13] md: raid1: don't use bio's vec table to manage
 resync pages
Date: Fri, 3 Mar 2017 09:38:00 -0800
Message-ID: <20170303173800.tj43oir24fuw5yb2@kernel.org>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-7-git-send-email-tom.leiming@gmail.com>
 <20170228233716.v3izfseg3dpdyexc@kernel.org>
 <CACVXFVPqFyvsdwjdcHbKm8J8Ni=d5isSxguRVJZoF3m2kaO98Q@mail.gmail.com>
 <20170302174803.ds45hdbzkofl5hkh@kernel.org>
 <CACVXFVPQx0rQqQS0PG2MoYh+pGvVQb_H_+fMCGbWeVDM3JNcnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVPQx0rQqQS0PG2MoYh+pGvVQb_H_+fMCGbWeVDM3JNcnQ@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Mar 03, 2017 at 10:11:31AM +0800, Ming Lei wrote:
> On Fri, Mar 3, 2017 at 1:48 AM, Shaohua Li <shli@kernel.org> wrote:
> > On Thu, Mar 02, 2017 at 10:25:10AM +0800, Ming Lei wrote:
> >> Hi Shaohua,
> >>
> >> On Wed, Mar 1, 2017 at 7:37 AM, Shaohua Li <shli@kernel.org> wrote:
> >> > On Tue, Feb 28, 2017 at 11:41:36PM +0800, Ming Lei wrote:
> >> >> Now we allocate one page array for managing resync pages, instead
> >> >> of using bio's vec table to do that, and the old way is very hacky
> >> >> and won't work any more if multipage bvec is enabled.
> >> >>
> >> >> The introduced cost is that we need to allocate (128 + 16) * raid_disks
> >> >> bytes per r1_bio, and it is fine because the inflight r1_bio for
> >> >> resync shouldn't be much, as pointed by Shaohua.
> >> >>
> >> >> Also the bio_reset() in raid1_sync_request() is removed because
> >> >> all bios are freshly new now and not necessary to reset any more.
> >> >>
> >> >> This patch can be thought as a cleanup too
> >> >>
> >> >> Suggested-by: Shaohua Li <shli@kernel.org>
> >> >> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >> >> ---
> >> >>  drivers/md/raid1.c | 83 ++++++++++++++++++++++++++++++++++--------------------
> >> >>  1 file changed, 53 insertions(+), 30 deletions(-)
> >> >>
> >> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> >> index c442b4657e2f..900144f39630 100644
> >> >> --- a/drivers/md/raid1.c
> >> >> +++ b/drivers/md/raid1.c
> >> >> @@ -77,6 +77,16 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
> >> >>  #define raid1_log(md, fmt, args...)                          \
> >> >>       do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##args); } while (0)
> >> >>
> >> >> +static inline struct resync_pages *get_resync_pages(struct bio *bio)
> >> >> +{
> >> >> +     return bio->bi_private;
> >> >> +}
> >> >> +
> >> >> +static inline struct r1bio *get_resync_r1bio(struct bio *bio)
> >> >> +{
> >> >> +     return get_resync_pages(bio)->raid_bio;
> >> >> +}
> >> >
> >> > This is a weird between bio, r1bio and the resync_pages. I'd like the pages are
> >>
> >> It is only a bit weird inside allocating and freeing r1bio, once all
> >> are allocated, you
> >> can see everthing is clean and simple:
> >>
> >>     - r1bio includes lots of bioes,
> >>     - and one bio is attached by one resync_pages via .bi_private
> >
> > I don't how complex to let r1bio pointer to the pages, but that's the nartual
> > way. r1bio owns the pages, not the pages own r1bio, so we should let r1bio
> > points to the pages. The bio.bi_private still points to r1bio.
> 
> Actually it is bio which owns the pages for doing its own I/O, and the only
> thing related with r10bio is that bios may share these pages, but using
> page refcount trick will make the relation quite implicit.
>
> The only reason to allocate all resync_pages together is for sake of efficiency,
> and just for avoiding to allocate one resync_pages one time for each bio.
> 
> We have to make .bi_private point to resync_pages(per bio), otherwise we
> can't fetch pages into one bio at all, thinking about where to store the index
> for each bio's pre-allocated pages, and it has to be per bio.

So the reason is we can't find the corresponding pages of the bio if bi_private
points to r1bio, right? Got it. We don't have many choices in this way. Ok, I
don't insist. Please add some comments in the get_resync_r1bio to describe how
the data structure is organized.

Thanks,
Shaohua
