From: Arne Wiebalck <wiebalck@kip.uni-heidelberg.de>
Subject: Re: Partitioning a RAID device
Date: Thu, 5 Sep 2002 17:42:35 +0200 (METDST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.HPX.4.43.0209051727350.11531-100000@electra.kip.uni-heidelberg.de>
References: <Pine.LNX.4.30.0209040912270.11782-100000@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.30.0209040912270.11782-100000@jaded.cynicism.com>
To: Derek Vadala <derek@cynicism.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


thanks for the hint!
I applied all the md patches for my kernel (2.4.18).

the compilation complained about __minor not to be member of the
mddev structure, so replaced it by a __unit. apart from that patching and
compiling was without problems.

I tried to partition the device using fdisk, but in /var/log/messages
I found

fdisk(pid 1344) tried BLKRRPART ioctl on MD device. Should use MDP device.

and

md: fdisk(pid 2486) used obsolete MD ioctl, upgrade your software to use
new ictls.

so, partitioning did not work.

my fdisk version is 2.11.
should I use another tool for partitioning?
who is responsible for making the device special files?

TIA,
 arne



On Wed, 4 Sep 2002, Derek Vadala wrote:

> On Wed, 4 Sep 2002, Arne Wiebalck wrote:
>
> > is it possible to have partitions on a RAID device?
> >
> > [...]
> >
> > Anything I am missing here?
>
> You first need to patch your kernel so that the md driver and md devices
> support partitioning. Check out
> http://cgi.cse.unsw.edu.au/~neilb/patches/linux-stable/ for the patches.
>
>
> ---
> Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek
>

**********************************************************************
 Arne Wiebalck                        Kirchhoff Institute for Physics
                                           Technical Computer Science
                                                     Schroederstr. 90
                                                   D-69120 Heidelberg

 e-mail: wiebalck@kip.uni-heidelberg.de      Tel.: (+49) 6221/54-4362
 web   : http://www.kip.uni-heidelberg.de    Fax.: (+49) 6221/54-4345
**********************************************************************


