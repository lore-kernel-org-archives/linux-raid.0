From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: where to buy very very large cases
Date: Mon, 28 Jul 2003 11:38:25 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0307281120340.15708@router.windsormachine.com>
References: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net>
        <Pine.LNX.4.56.0307281024000.15708@router.windsormachine.com>
 <bWpzdHVtcGY=.4cd948dd5243da1b5289a26e6dc1ccfb@1059405399.cotse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bWpzdHVtcGY=.4cd948dd5243da1b5289a26e6dc1ccfb@1059405399.cotse.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Jul 2003, mjstumpf wrote:

> Thanks, all, for comments.  I see every detail I forgot to include:  I'm
> trying to do this on a budget (but not a college student budget) with ATA
> drives.  I'm using a stack of promise ATA controllers with rounded ATA
> cables (some of long lengths, 36") to get the job done.  It's been up and
> running for the better part of 4 years now.

How big are your drives now?  I've got a server at home with 5 drives in
it, could all be replaced with a raid1 of 80 gig drives, and retire the
ugly full tower case with a tiny case.

I ask, because there's 250-300 gig drives available now, you might be
able to use your existing case and just start replacing drives.  Newegg
sells the Maxtor 300gb drive for about 329.

It's 5400 rpm, and only 2 meg cache, but your needs might not require a
fast drive if you're just storing stuff.

For a fast drive, a 250 gig version goes for about 258, for a 8 meg
cache, 7200 rpm model.

So figure a dollar a gig.  How many gig do you want?  How many do you
actually need? ;)

> Has anyone seen the equivalent of more dense promise cards (more than 2
> channels per card, but no extra bells & whistles like raid.. meaning,
> cheap)?  I really prefer plain old software raid in linux, but I am
> actually physically out of PCI slots (and heat issues, space issues, etc).

Well, the 3ware cards are about 500 dollars for a 12 port.  This isn't all
that bad, since you'll only need two for 24 drives.  You can use these
with software raid just fine.  A 8 port version is around 340, or about
the same per port cost.

Btw, your 36" rounded cables likely grossly violate ATA spec, what kind of
wierd case are you currently using that you need that long of cabling?

3ware also makes SATA card versions, the 8500-12 comes to mind, this would
have much smaller cables, and SATA allows up to ~3 foot cables by design.
Controller is much more expensive though, at around 700 for a 12 port
model.

You can get 250 gb SATA drives for about 320ish, I don't see the 300 gb
models that Maxtor promised a year ago, which doesn't surprise me, as
Maxtor is king of waiting a year to actually release products.

> Can't easily stagger IDE powerup, can you?  Already ran into that issue...

Hence, start with fewer drives.

Mike
