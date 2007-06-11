From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: below 10MB/s write on raid5
Date: Mon, 11 Jun 2007 08:45:14 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706110844280.5806@gheavc.wnzcbav.cig>
References: <200706111446.55813.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0706110847380.31708@p34.internal.lan> <200706111528.11828.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0706110928420.31708@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706110928420.31708@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 11 Jun 2007, Justin Piszcz wrote:

> 
> 
> On Mon, 11 Jun 2007, Dexter Filmore wrote:
> 
> > On Monday 11 June 2007 14:47:50 Justin Piszcz wrote:
> > > On Mon, 11 Jun 2007, Dexter Filmore wrote:
> > > > I recently upgraded my file server, yet I'm still unsatisfied with the
> > > > write speed.
> > > > Machine now is a Athlon64 3400+ (Socket 754) equipped with 1GB of RAM.
> > > > The four RAID disks are attached to the board's onbaord sATA controller
> > > > (Sil3114 attached via PCI)
> > > > Kernel is 2.6.21.1, custom on Slackware 11.0.
> > > > RAID is on four Samsung SpinPoint disks, has LVM, 3 volumes atop of each
> > > > XFS.
> > > >
> > > > The machine does some other work, too, but still I would have suspected
> > > > to get into the 20-30MB/s area. Too much asked for?
> > > >
> > > > Dex
> > >
> > > What do you get without LVM?
> >
> > Hard to tell: the PV hogs all of the disk space, can't really do non-LVM
> > tests.
> 
> You can do a read test.
> 
> 10gb read test:
> 
> dd if=/dev/md0 bs=1M count=10240 of=/dev/null

eek! Make sure to use iflag=direct
with that otherwise you'll get cached reads and that will throw
the numbers off considerably.


--
Jon Nelson <jnelson-linux-raid@jamponi.net>
