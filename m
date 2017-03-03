From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/3] md/raid5-cache: bump flush stripe batch size
Date: Fri, 3 Mar 2017 09:41:38 -0800
Message-ID: <20170303174138.iecwisogdkkdh6iy@kernel.org>
References: <cover.1487373517.git.shli@fb.com>
 <52a5e6f8924b9a19d4ec4ad73f6e7087f36f139d.1487373517.git.shli@fb.com>
 <87mvd3m58c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mvd3m58c.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

On Fri, Mar 03, 2017 at 02:03:31PM +1100, Neil Brown wrote:
> On Fri, Feb 17 2017, Shaohua Li wrote:
> 
> > Bump the flush stripe batch size to 2048. For my 12 disks raid
> > array, the stripes takes:
> > 12 * 4k * 2048 = 96MB
> >
> > This is still quite small. A hardware raid card generally has 1GB size,
> > which we suggest the raid5-cache has similar cache size.
> >
> > The advantage of a big batch size is we can dispatch a lot of IO in the
> > same time, then we can do some scheduling to make better IO pattern.
> >
> > Last patch prioritizes stripes, so we don't worry about a big flush
> > stripe batch will starve normal stripes.
> >
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/raid5-cache.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> > index 3f307be..b25512c 100644
> > --- a/drivers/md/raid5-cache.c
> > +++ b/drivers/md/raid5-cache.c
> > @@ -43,7 +43,7 @@
> >  /* wake up reclaim thread periodically */
> >  #define R5C_RECLAIM_WAKEUP_INTERVAL (30 * HZ)
> >  /* start flush with these full stripes */
> > -#define R5C_FULL_STRIPE_FLUSH_BATCH 256
> > +#define R5C_FULL_STRIPE_FLUSH_BATCH 2048
> 
> Fixed numbers are warning signs... I wonder if there is something better
> we could do?   "conf->max_nr_stripes / 4" maybe?  We use that sort of
> number elsewhere.
> Would that make sense?

The code where we check the batch size (in r5c_do_reclaim) already a check:
total_cached > conf->min_nr_stripes * 1 / 2
so I think that's ok, no?

Thanks,
Shaohua
