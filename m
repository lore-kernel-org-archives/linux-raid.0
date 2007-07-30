From: Maik Hampel <m.hampel@gmx.de>
Subject: Re: md: raid10: fix use-after-free of bio
Date: Mon, 30 Jul 2007 10:11:51 +0200
Message-ID: <1185783111.2684.15.camel@c64>
References: <1185547583.2663.10.camel@c64>
	 <20070728235519.1edc6ccb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070728235519.1edc6ccb.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Samstag, den 28.07.2007, 23:55 -0700 schrieb Andrew Morton:
> On Fri, 27 Jul 2007 16:46:23 +0200 Maik Hampel <m.hampel@gmx.de> wrote:
> 
> > In case of read errors raid10d tries to print a nice error message,
> > unfortunately using data from an already put bio.
> > 
> > Signed-off-by: Maik Hampel <m.hampel@gmx.de>
> > 
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index f730a14..ea1b3e3 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1557,7 +1557,6 @@ static void raid10d(mddev_t *mddev)
> >  			bio = r10_bio->devs[r10_bio->read_slot].bio;
> >  			r10_bio->devs[r10_bio->read_slot].bio =
> >  				mddev->ro ? IO_BLOCKED : NULL;
> > -			bio_put(bio);
> >  			mirror = read_balance(conf, r10_bio);
> >  			if (mirror == -1) {
> >  				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
> > @@ -1567,6 +1566,7 @@ static void raid10d(mddev_t *mddev)
> >  				raid_end_bio_io(r10_bio);
> >  			} else {
> >  				const int do_sync = bio_sync(r10_bio->master_bio);
> > +				bio_put(bio);
> >  				rdev = conf->mirrors[mirror].rdev;
> >  				if (printk_ratelimit())
> >  					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
> > 
> > 
> 
> Surely we just leaked that bio if (mirror == -1)?
> 
> better:
> 
> --- a/drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio
> +++ a/drivers/md/raid10.c
> @@ -1534,7 +1534,6 @@ static void raid10d(mddev_t *mddev)
>  			bio = r10_bio->devs[r10_bio->read_slot].bio;
>  			r10_bio->devs[r10_bio->read_slot].bio =
>  				mddev->ro ? IO_BLOCKED : NULL;
> -			bio_put(bio);
>  			mirror = read_balance(conf, r10_bio);
>  			if (mirror == -1) {
>  				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
> @@ -1542,8 +1541,10 @@ static void raid10d(mddev_t *mddev)
>  				       bdevname(bio->bi_bdev,b),
>  				       (unsigned long long)r10_bio->sector);
>  				raid_end_bio_io(r10_bio);
> +				bio_put(bio);
raid_end_bio_io() calls put_all_bios(), which does a bio_put() to
corresponding r10_bio->devs[i]. So this looks like redundant code for
me.
>  			} else {
>  				const int do_sync = bio_sync(r10_bio->master_bio);
> +				bio_put(bio);
>  				rdev = conf->mirrors[mirror].rdev;
>  				if (printk_ratelimit())
>  					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"

Regards, 
Maik Hampel


