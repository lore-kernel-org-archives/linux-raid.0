From: Arne Wiebalck <wiebalck@kip.uni-heidelberg.de>
Subject: Re: Partitioning a RAID device
Date: Mon, 9 Sep 2002 09:38:21 +0200 (METDST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.HPX.4.43.0209090937250.27829-100000@electra.kip.uni-heidelberg.de>
References: <15736.14823.863026.285510@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15736.14823.863026.285510@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Derek Vadala <derek@cynicism.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


ok, works fine. thanks for your help.

arne


On Fri, 6 Sep 2002, Neil Brown wrote:

> On Thursday September 5, wiebalck@kip.uni-heidelberg.de wrote:
> >
> > fdisk(pid 1344) tried BLKRRPART ioctl on MD device. Should use MDP
> > device.
>
> Yes, you shold use the MDP devices... look in /proc/devices to find
> the major number.
> >
> > md: fdisk(pid 2486) used obsolete MD ioctl, upgrade your software to use
> > new ictls.
>
> Ignore this, it doesn't really mean anything.
>
> >
> > so, partitioning did not work.
> >
> > my fdisk version is 2.11.
> > should I use another tool for partitioning?
>
> fdisk, cfdisk, sfdisk all work fine.
>
> > who is responsible for making the device special files?
>
> You.  (or devfs).
> The first 16 minors for mdp correspond to md0
> The second 16 minors for mdp correspond to md1
> etc.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

**********************************************************************
 Arne Wiebalck                        Kirchhoff Institute for Physics
                                           Technical Computer Science
                                                     Schroederstr. 90
                                                   D-69120 Heidelberg

 e-mail: wiebalck@kip.uni-heidelberg.de      Tel.: (+49) 6221/54-4362
 web   : http://www.kip.uni-heidelberg.de    Fax.: (+49) 6221/54-4345
**********************************************************************


