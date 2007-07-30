From: Neil Brown <neilb@suse.de>
Subject: Re: md: raid10: fix use-after-free of bio
Date: Mon, 30 Jul 2007 18:44:37 +1000
Message-ID: <18093.42229.134557.618117@notabene.brown>
References: <1185547583.2663.10.camel@c64>
	<20070728235519.1edc6ccb.akpm@linux-foundation.org>
	<1185783111.2684.15.camel@c64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maik Hampel on Monday July 30
Sender: linux-raid-owner@vger.kernel.org
To: Maik Hampel <m.hampel@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday July 30, m.hampel@gmx.de wrote:
> > 
> > Surely we just leaked that bio if (mirror == -1)?
> > 
> > better:
> > 
> > --- a/drivers/md/raid10.c~md-raid10-fix-use-after-free-of-bio
> > +++ a/drivers/md/raid10.c
> > @@ -1534,7 +1534,6 @@ static void raid10d(mddev_t *mddev)
> >  			bio = r10_bio->devs[r10_bio->read_slot].bio;
> >  			r10_bio->devs[r10_bio->read_slot].bio =
> >  				mddev->ro ? IO_BLOCKED : NULL;
> > -			bio_put(bio);
> >  			mirror = read_balance(conf, r10_bio);
> >  			if (mirror == -1) {
> >  				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
> > @@ -1542,8 +1541,10 @@ static void raid10d(mddev_t *mddev)
> >  				       bdevname(bio->bi_bdev,b),
> >  				       (unsigned long long)r10_bio->sector);
> >  				raid_end_bio_io(r10_bio);
> > +				bio_put(bio);
> raid_end_bio_io() calls put_all_bios(), which does a bio_put() to
> corresponding r10_bio->devs[i]. So this looks like redundant code for
> me.

Yes, but note above that this bio for this slot has been set to
'NULL', so put_all_bios won't find anything to call bio_put on.

Thanks,
NeilBrown


> >  			} else {
> >  				const int do_sync = bio_sync(r10_bio->master_bio);
> > +				bio_put(bio);
> >  				rdev = conf->mirrors[mirror].rdev;
> >  				if (printk_ratelimit())
> >  					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"
> 
> Regards, 
> Maik Hampel
> 
