From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md ] Better handling of readerrors with raid5.
Date: Sat, 17 Sep 2005 07:39:53 +1000
Message-ID: <17195.15273.55414.57588@cse.unsw.edu.au>
References: <20050916125754.11044.patches@notabene>
	<1050916030157.11071@suse.de>
	<432AF89C.3040407@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Hardy on Friday September 16
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 16, mhardy@h3c.com wrote:
> 
> NeilBrown wrote:
> > TESTERS WANTED!!  SEE BELOW...
> > 
> > This patch changes the behaviour of raid5 when it gets a read error.
> > Instead of just failing the device, it tried to find out what should
> > have been there, and writes it over the bad block.  For some
> > media-errors, this has a reasonable chance of fixing the error.
> > If the write succeeds, and a subsequent read succeeds as well, raid5
> > decided the address is OK and continues.
> > 
> > I have tested this using the 'faulty' md personality, but it would be
> > really good to test it with real disks that have real errors.  If
> > anyone has such drives in a cupboard (or even in a computer) and would
> > be willing to give this a try, I would really appreciate it.
> 
> 
> Oh, this makes me so happy. Thank you thank you thank you.

Thanks....

> 
> I regret that I just yesterday sent a drive back with spontaneously
> growing read errors that were fixable yet would pop up in another
> spot.

Seems my timing is a little off :-)

> 
> Does this apply cleanly to 2.6.13 though? Does it require any special
> tool support or superblock (version of mdadm, etc)? I could put it on
> one of my non-mission-critical rigs and let it run for a while.

It should apply to 2.6.13  - it is purely a raid5 change, and most of
the md changes since 2.6.13 are md.c only.  So if 'patch' says it
applies, you can be sure it applies correctly.

It doesn't require any other changes - it's purely internal to raid5.

Thanks for trying to help..

NeilBrown
