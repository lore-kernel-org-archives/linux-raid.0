From: Adam Luter <luterac@bellsouth.net>
Subject: Re: RAID5 problem with multiple Promise PDC20269 controllers
Date: Tue, 29 Oct 2002 14:02:30 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021029200230.GG21099@smeagol>
References: <3DBD54FA.20709@base2technology.com> <200210291908.35581.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210291908.35581.roy@karlsbakk.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've had problems with using two PDC20269's at the same time too.
(well actually one is a 69, the other is the 100, not 133 version).

They seem to work ok without DMA on, but otherwise I get lots of dma
errors when heavy load is placed (such as re-syncing).

I've got an Epox motherboard (Duron 1.0 ghz), and four IBM 7200RPM
120gig harddrives.

Right now things are running "ok" by having all four drives on one
card and the other card (doesn't matter which) in my desk drawer.  But
it would be nice if I could put it back in the system (the speed was
-great-!).

-Gryn

On Tue, Oct 29, 2002 at 07:08:35PM +0100, Roy Sigurd Karlsbakk wrote:
> On Monday 28 October 2002 16:17, Chris Hirsch wrote:
> > This is probably more of a hardware question than RAID but since there
> > has to be somebody in the same boat as myself....
> >
> > I'm trying to do a RAID5 setup with 3 IDE disks connected to IDE1/IDE2
> > on a Promise  ULTRA133 TX2. Fine..works great with only two disks. So I
> > bring in my 3rd disk on the second PDC20269 and I get kernel lockups and
> > fun stuff when the array tries to rebuild or activate. I've tried deja
> > and there seems to be some issues with multiple cards but I can't seem
> > to find any resolutions. This is a RH 8.0 box using 2.4.18.
> 
> strange ...
> 
> I'm running 20269's (or was that 68's?) with four drives each, and it works 
> fine
