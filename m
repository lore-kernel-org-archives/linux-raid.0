From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: below 10MB/s write on raid5
Date: Mon, 11 Jun 2007 15:28:11 +0200
Message-ID: <200706111528.11828.Dexter.Filmore@gmx.de>
References: <200706111446.55813.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0706110847380.31708@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706110847380.31708@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 11 June 2007 14:47:50 Justin Piszcz wrote:
> On Mon, 11 Jun 2007, Dexter Filmore wrote:
> > I recently upgraded my file server, yet I'm still unsatisfied with the
> > write speed.
> > Machine now is a Athlon64 3400+ (Socket 754) equipped with 1GB of RAM.
> > The four RAID disks are attached to the board's onbaord sATA controller
> > (Sil3114 attached via PCI)
> > Kernel is 2.6.21.1, custom on Slackware 11.0.
> > RAID is on four Samsung SpinPoint disks, has LVM, 3 volumes atop of each
> > XFS.
> >
> > The machine does some other work, too, but still I would have suspected
> > to get into the 20-30MB/s area. Too much asked for?
> >
> > Dex
>
> What do you get without LVM?

Hard to tell: the PV hogs all of the disk space, can't really do non-LVM 
tests.



-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
