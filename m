From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm][Experimental] suspend: Do not freeze md_threads
Date: Mon, 6 Nov 2006 11:28:18 +0100
Message-ID: <20061106102818.GA3138@elf.ucw.cz>
References: <200611022355.52856.rjw@sisk.pl> <20061105115804.GG4965@elf.ucw.cz> <17742.26007.249504.79631@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17742.26007.249504.79631@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

> > > If there's a swap file on a software RAID, it should be possible to use this
> > > file for saving the swsusp's suspend image.  Also, this file should be
> > > available to the memory management subsystem when memory is being freed before
> > > the suspend image is created.
> > > 
> > > For the above reasons it seems that md_threads should not be frozen during
> > > the suspend and the appended patch makes this happen, but then there is the
> > > question if they don't cause any data to be written to disks after the
> > > suspend image has been created, provided that all filesystems are frozen
> > > at that time.
> > 
> > Looks okay to me. It would be nice to have someone (Ingo? Neil?) try
> > to suspend to swap on md......
> 
> Yes... suspending to swap-on-md would probably be fairly easy.
> Resuming from that same swap might be a bit more of a challenge.
> If only I had more time...

With uswsusp (scheduled for 10.2), it should be fairly easy, too. I
guess we shall just get Andrea to try it :-).
							Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
