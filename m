From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Thu, 30 Mar 2006 22:38:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.62.0603301057230.4271@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0603301057230.4271@chaos.egr.duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I have 4x500GB Maxtor SATA drives and I want to attach
> > these to a 4-port SATA PCI card and RAID5 them using "md"
> >
> > Could anybody recommend a card that will have out of
> > box support on a Fedora system ?

which FC release?  I believe FC4 would have decent support for 
promise tx4's (there are at least two - the most recent might
not work OOB).  sil 3114's ought to work as well.

> 3ware.  Period.  If you're going to use md, get the 8506-4 series rather 
> than either of the 9xxx series cards.

before the 9550, I never found attractive in price/performance: 
expensive as hell and a lot slower than MD.  but the 9550 is really
quite impressive...

regards, mark hahn

