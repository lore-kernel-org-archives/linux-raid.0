From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md-cluster: Fix potential error pointer dereference in resize_bitmaps()
Date: Wed, 5 Aug 2020 17:20:39 -0700
Message-ID: <CAPhsuW4EKCMhL0T=1iMbVYrh1azZOD-jQ-vXDMmZ5cy2m-oW4g@mail.gmail.com>
References: <20200804101645.GB392148@mwanda> <824849e0-c98d-1f22-817c-7a76d3ee22b1@cloud.ionos.com>
 <20200804111549.GN5493@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20200804111549.GN5493@kadam>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 4, 2020 at 4:16 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Tue, Aug 04, 2020 at 12:40:18PM +0200, Guoqing Jiang wrote:
> >
> >
> > On 8/4/20 12:16 PM, Dan Carpenter wrote:
> > > The error handling calls md_bitmap_free(bitmap) which checks for NULL
> > > but will Oops if we pass an error pointer.  Let's set "bitmap" to NULL
> > > on this error path.
> > >
> > > Fixes: afd756286083 ("md-cluster/raid10: resize all the bitmaps before start reshape")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > ---
> > >   drivers/md/md-cluster.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> > > index 73fd50e77975..d50737ec4039 100644
> > > --- a/drivers/md/md-cluster.c
> > > +++ b/drivers/md/md-cluster.c
> > > @@ -1139,6 +1139,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
> > >             bitmap = get_bitmap_from_slot(mddev, i);
> > >             if (IS_ERR(bitmap)) {
> > >                     pr_err("can't get bitmap from slot %d\n", i);
> > > +                   bitmap = NULL;
> > >                     goto out;
> > >             }
> > >             counts = &bitmap->counts;
> >
> > Thanks for the catch, Reviewed-by: Guoqing Jiang
> > <guoqing.jiang@cloud.ionos.com>
> >
> > BTW, seems there could be memory leak in the function since it keeps
> > allocate bitmap
> > in the loop ..., will send a format patch.
> >
> >
> > diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> > index 73fd50e77975..89d7b32489d8 100644
> > --- a/drivers/md/md-cluster.c
> > +++ b/drivers/md/md-cluster.c
> > @@ -1165,6 +1165,8 @@ static int resize_bitmaps(struct mddev *mddev,
> > sector_t newsize, sector_t oldsiz
> >                          * can't resize bitmap
> >                          */
> >                         goto out;
> > +
> > +               md_bitmap_free(bitmap);
>
> Hm...  I'm now not at all certain my patch is correct.  Although it's
> obviously harmless and fixes an Oops.  I had thought that that the call
> to update_bitmap_size(mddev, oldsize) would free the rest of the loop.
>
> I really suspect adding a free like you're suggesting will break the
> success path.
>
> I'm not familiar with this code at all.

Thanks Dan and Guoqing. I applied Dans' patch to md-next.

I think we are leaking bitmap in resize_bitmaps(). But we gonna need
more complex fix than the md_bitmap_free() above.

Thanks,
Song
