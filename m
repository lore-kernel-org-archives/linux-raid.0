From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: hardware raid
Date: Wed, 16 Jul 2003 12:30:19 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0307161158520.6612-100000@multivac.sdsc.edu>
References: <003c01c34bca$1d037a30$01e703ca@magnus>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003c01c34bca$1d037a30$01e703ca@magnus>
To: Mikael Chambon <raid-ml@cronos.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael,

> As I wrote in my previous emails, I am working
> on a root raid1 array with two IDE HD.
> I would like to mirror the entire system to make it able
> to boot even if one of the disk crash.
>
> It's not working yet but I am still trying.
>
> Anyway I am also considering bying an hardware
> raid controller like the 3ware 7000-2 or 7506-4LP
> (seem to be what I need).
>
> http://www.3ware.com/products/parallel_ata.asp
>
> Does someone has any experiences with these cards
> and Linux, it is well supported, stable ?

I've sold many systems with this option for the boot disk.  The 7000-2 is
the less expensive solution, and perfect for a boot disk.  You should be
aware that multiple RAID arrays on a single 3Ware card is usually bad, due
to buffer allocation on the card.  Also, there are historical
compatability problems with using disks on the motherboard IDE channels
(CDROMs work fine).

If you need 2 JBOD disks, in addition to the system disk, the 7500-4
controller might be a good choice.

> Is it hard to implement or configure (kernel patch, etc ..) ?

The only difficulties that I've encountered with these controllers
recently are:

1.  Smaller WD disks are NOT reliable.  This is due to firmware problems
    in the disk, which WD seems to have no intention of fixing.  These
    problems have been 'fixed' in the larger disks.
2.  When it's time to upgrade the firmware, the drivers and 3DM daemon (or
    CLI) all need to be updated at the same time.  This is not a technicaly
    difficult thing to do, it just requires some coordination between the
    HW maintainers and the SysAdmin.
3.  Most of the time, it will be necessary to compile the drivers.  This
    is primarilly due to the frequency of driver releases, combined with
    the MANY versions of Linux.

I think you'll be happy with these controllers.

				Peter Ashford

