From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] raid5-cache: use a bio_set
Date: Mon, 14 Dec 2015 22:12:00 +0100
Message-ID: <20151214211200.GA17714@lst.de>
References: <1449072638-15409-1-git-send-email-hch@lst.de> <1449072638-15409-2-git-send-email-hch@lst.de> <87bna0r0ez.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bna0r0ez.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 09, 2015 at 10:22:12AM +1100, NeilBrown wrote:
> > +/*
> > + * We only need 2 bios per I/O unit to make progress, but ensure we
> > + * have a few more available to not get too tight.
> > + */
> > +#define R5L_POOL_SIZE	1024
> > +
> 
> I'm really suspicious of big pool sizes.
> The memory allocated to the pool is almost never used - only where no
> other memory is available - so large pools are largely wasted.

I originally had 16 here, andd incremented it for some debugging that
stuck.  I retested with 4 and that works as well.  That will be included
in the next resend.
