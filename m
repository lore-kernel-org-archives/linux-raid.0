From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Tue, 17 Oct 2006 10:13:05 +1000
Message-ID: <17716.8209.575554.65572@cse.unsw.edu.au>
References: <20061005171233.6542.patches@notabene>
	<1061005071326.6578@suse.de>
	<45255C54.6060608@ilm.com>
	<4526DBCE.6070906@ilm.com>
	<17706.65210.999441.373846@cse.unsw.edu.au>
	<452E12B1.1070506@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Thursday October 12
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Eli Stair <estair@ilm.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 12, mjt@tls.msk.ru wrote:
> Neil Brown wrote:
> []
> > Fix count of degraded drives in raid10.
> > 
> > Signed-off-by: Neil Brown <neilb@suse.de>
> > 
> > --- .prev/drivers/md/raid10.c	2006-10-09 14:18:00.000000000 +1000
> > +++ ./drivers/md/raid10.c	2006-10-05 20:10:07.000000000 +1000
> > @@ -2079,7 +2079,7 @@ static int run(mddev_t *mddev)
> >  		disk = conf->mirrors + i;
> >  
> >  		if (!disk->rdev ||
> > -		    !test_bit(In_sync, &rdev->flags)) {
> > +		    !test_bit(In_sync, &disk->rdev->flags)) {
> >  			disk->head_position = 0;
> >  			mddev->degraded++;
> >  		}
> 
> Neil, this makes me nervous.  Seriously.

Yes.  Bugs are a problem.

> 
> How many bugs like this has been fixed so far? 10? 50?  I stopped counting
> long time ago.  And it's the same thing in every case - misuse of rdev vs
> disk->rdev.  The same pattern.

I really don't think there have been that many that follow that
pattern that closely. Maybe 2 or 3.

> 
> I wonder if it can be avoided in the first place somehow - maybe don't
> declare and use local variable `rdev' (not by name, but by the semantics
> of it), and always use disk->rdev or mddev->whatever in every place,
> explicitly, and let the compiler optimize the deref if possible?
> 

There certainly are styles of programming and rules for choosing names
that can help reduce bugs.  And the kernel style does encourage some
good practices.
But that won't be enough by itself.  We need good style, and a review
process, and testing.  And still bugs will get through, but there
should be fewer.  You are welcome to help with any of these.

I hope to set up a more structured testing system soon with should be
able to catch this sort of bug at least.

> And btw, this is another 2.6.18.1 candidate (if it's not too late already).

Yes, it was too late for 2.6.18.1.  I'll submit it for 2.6.18.2.

Thanks,
NeilBrown
