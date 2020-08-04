From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] md-cluster: Fix potential error pointer dereference in
 resize_bitmaps()
Date: Tue, 4 Aug 2020 14:15:49 +0300
Message-ID: <20200804111549.GN5493@kadam>
References: <20200804101645.GB392148@mwanda>
 <824849e0-c98d-1f22-817c-7a76d3ee22b1@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <824849e0-c98d-1f22-817c-7a76d3ee22b1@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Song Liu <song@kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 04, 2020 at 12:40:18PM +0200, Guoqing Jiang wrote:
> 
> 
> On 8/4/20 12:16 PM, Dan Carpenter wrote:
> > The error handling calls md_bitmap_free(bitmap) which checks for NULL
> > but will Oops if we pass an error pointer.  Let's set "bitmap" to NULL
> > on this error path.
> > 
> > Fixes: afd756286083 ("md-cluster/raid10: resize all the bitmaps before start reshape")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >   drivers/md/md-cluster.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> > index 73fd50e77975..d50737ec4039 100644
> > --- a/drivers/md/md-cluster.c
> > +++ b/drivers/md/md-cluster.c
> > @@ -1139,6 +1139,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
> >   		bitmap = get_bitmap_from_slot(mddev, i);
> >   		if (IS_ERR(bitmap)) {
> >   			pr_err("can't get bitmap from slot %d\n", i);
> > +			bitmap = NULL;
> >   			goto out;
> >   		}
> >   		counts = &bitmap->counts;
> 
> Thanks for the catch, Reviewed-by: Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com>
> 
> BTW, seems there could be memory leak in the function since it keeps
> allocate bitmap
> in the loop ..., will send a format patch.
> 
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 73fd50e77975..89d7b32489d8 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1165,6 +1165,8 @@ static int resize_bitmaps(struct mddev *mddev,
> sector_t newsize, sector_t oldsiz
>                          * can't resize bitmap
>                          */
>                         goto out;
> +
> +               md_bitmap_free(bitmap);

Hm...  I'm now not at all certain my patch is correct.  Although it's
obviously harmless and fixes an Oops.  I had thought that that the call
to update_bitmap_size(mddev, oldsize) would free the rest of the loop.

I really suspect adding a free like you're suggesting will break the
success path.

I'm not familiar with this code at all.

regards,
dan carpenter
