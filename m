From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH] raid5: only dispatch IO from raid5d for harddisk raid
Date: Wed, 4 Jan 2017 10:14:29 -0800
Message-ID: <20170104181428.GB73049@shli-mbp.local>
References: <9e987c0d95c49224da7fb82477dd10fcacf4d794.1483552525.git.shli@fb.com>
 <E6506DA7-E269-4092-8761-12FFC1770F82@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E6506DA7-E269-4092-8761-12FFC1770F82@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Wed, Jan 04, 2017 at 06:10:59PM +0000, Song Liu wrote:
> 
> > On Jan 4, 2017, at 9:57 AM, Shaohua Li <shli@fb.com> wrote:
> > 
> > +	spin_lock_init(&conf->pending_bios_lock);
> > +	conf->batch_bio_dispatch = true;
> > +	rdev_for_each(rdev, mddev) {
> > +		if (blk_queue_nonrot(bdev_get_queue(rdev->bdev))) {
> > +			conf->batch_bio_dispatch = false;
> 
> Shall we skip this check for the journal device?

yep, will add it in next post

Thanks,
Shaohua
