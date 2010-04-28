From: Neil Brown <neilb@suse.de>
Subject: Re: Suggestion needed for fixing RAID6
Date: Wed, 28 Apr 2010 12:12:46 +1000
Message-ID: <20100428121246.2ceabfd5@notabene.brown>
References: <626601cae203$dae35030$0400a8c0@dcccs>
	<20100423065143.GA17743@maude.comedia.it>
	<695a01cae2c1$a72907d0$0400a8c0@dcccs>
	<4BD193D0.5080003@shiftmail.org>
	<717901cae3e5$6a5fa730$0400a8c0@dcccs>
	<4BD3751A.5000403@shiftmail.org>
	<756601cae45e$213d6190$0400a8c0@dcccs>
	<4BD569E2.7010409@shiftmail.org>
	<7a3e01cae53f$684122c0$0400a8c0@dcccs>
	<4BD5C51E.9040207@shiftmail.org>
	<80a201cae621$684daa30$0400a8c0@dcccs>
	<4BD76CF6.5020804@shiftmail.org>
	<20100428113732.03486490@notabene.brown>
	<alpine.DEB.1.10.1004280400330.6768@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1004280400330.6768@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: MRK <mrk@shiftmail.org>, Janos Haar <janos.haar@netcenter.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Apr 2010 04:02:39 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 28 Apr 2010, Neil Brown wrote:
> 
> >> I think I can see a problem here:
> >> You had 11 active devices over 12 when you received the read error.
> >> At 11 devices over 12 your array is singly-degraded and this should be
> >> enough for raid6 to recompute the block from parity and perform the
> >> rewrite, correcting the read-error, but instead MD declared that it's
> >> impossible to correct the error, and dropped one more device (going to
> >> doubly-degraded).
> >>
> >> I think this is an MD bug, and I think I know where it is:
> >>
> >>
> >> --- linux-2.6.33-vanilla/drivers/md/raid5.c     2010-02-24
> >> 19:52:17.000000000 +0100
> >> +++ linux-2.6.33/drivers/md/raid5.c     2010-04-27 23:58:31.000000000 +0200
> >> @@ -1526,7 +1526,7 @@ static void raid5_end_read_request(struc
> >>
> >>                  clear_bit(R5_UPTODATE, &sh->dev[i].flags);
> >>                  atomic_inc(&rdev->read_errors);
> >> -               if (conf->mddev->degraded)
> >> +               if (conf->mddev->degraded == conf->max_degraded)
> >>                          printk_rl(KERN_WARNING
> >>                                    "raid5:%s: read error not correctable "
> >>                                    "(sector %llu on %s).\n",
> >>
> >> ------------------------------------------------------
> >> (This is just compile-tested so try at your risk)
> >>
> >> I'd like to hear what Neil thinks of this...
> >
> > I think you've found a real bug - thanks.
> >
> > It would make the test '>=' rather than '==' as that is safer, otherwise I
> > agree.
> >
> >> -               if (conf->mddev->degraded)
> >> +               if (conf->mddev->degraded >= conf->max_degraded)
> 
> If a raid6 device handling can reach this code path, could I also point 
> out that the message says "raid5" and that this is confusing if it's 
> referring to a degraded raid6?
> 

You could....

There are lots of places that say "raid5" where it could apply to raid4
or raid6 as well.  Maybe I should change them all to 'raid456'...

NeilBrown
