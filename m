From: =?ISO-8859-1?Q?Jo=EBl?= Bourquard <numlock@freesurf.ch>
Subject: Re: What SATA controller for software raid and/or lvm?
Date: Mon, 19 Jan 2004 20:50:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074541807.11253.33.camel@localhost.localdomain>
References: <Pine.LNX.4.44.0401191411050.12676-100000@coffee.psychology.mcmaster.ca>
Reply-To: numlock@freesurf.ch
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0401191411050.12676-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: mingz@ele.uri.edu, admin@ecommerce.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark,

Thanks a lot for your answer...

On Mon, 2004-01-19 at 20:19, Mark Hahn wrote:
> > However, before I rush and order these two Highpoint 1820's ($300),=
 it
>=20
> afaikt, HPT's driver is one that plugs into SCSI.  this by itself doe=
sn't
> mean it's bad (since libata and 3ware also do so, and are good).  the=
 problem
> is that it's not clear how well HPT will maintain the driver, updatin=
g it=20
> when the SCSI layers above it change (or the kernel in general).
>=20

I understand your concerns about the future !
=46ortunately (at least for me) it won't matter much, because I don't n=
eed
top-notch software in the fileserver.

Since we talk SCSI, is it still possible to monitor the S.M.A.R.T healt=
h
attributes of the SATA disks when plugged into one of these controllers=
?
I'd be lost with 16 disks and no smartctl..

By the way, there's something I didn't grasp yet..  is libata a library
which is needed for SATA drivers to run ? Or does libata rather mean
"open-source SATA-to-SCSI driver" ?

In the second case, with a HPT controller there would be no need for
libata, correct ?

> I'm going with promise 4-port cards: most server boards have two PCIX
> buses, it gets painful to put more than 8 disks in a chassis anyway.
> these days, a disk will do 70 MB/s, so expecting 560 MB/s out of a si=
ngle=20
> card is probably over-optimistic anyway.
>=20

Good point. With 8 disks, I'd have taken two 4-port controllers too.

> > it might help a lot of people on Linux-RAID... I mean, a 64-bit 133=
MHz
> > SATA controller with 8 ports, for about $150 is really nice :-)
>=20
> I don't mind two cheaper cards for the same thing.  it's easy to argu=
e
> that you shouldn't have the controller as a single point of failure, =
too.
>=20

Indeed. Also if there are two arrays (I think it's needed because of th=
e
2TB limit), one could split the work on the 2 controllers... and on the
two PCI-X bridges :-)

> regards, mark hahn.

Regards
Jo=C3=ABl

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
