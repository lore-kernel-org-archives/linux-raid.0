From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 12:43:40 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807021241350.5166@p34.internal.lan>
References: <20080702155603.GA11156@rap.rap.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1562106971-1215017021=:5166"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080702155603.GA11156@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1562106971-1215017021=:5166
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 2 Jul 2008, Keld J=F8rn Simonsen wrote:

> The 66 MHz 64-bit PCI bus is capable of handling about 4 Gbit/s, or
> about 500 MB/s. This can also be a bottleneck with bigger arrays, eg a 6
> drive array will be able to deliver about 500 MB/s, and maybe you want
> also to feed a gigabyte ethernet card - 125 MB/s, totalling potentially
> 625 MB/s on the PCI bus.
>
> The PCI-Express bus v1.1 has a limit of 250 MB/s per lane per dirction,
> and that limit can easily be hit eg by a 4-drive array.
Correction, can easily be hit with two veliciraptors.
One veliciraptor for much of the read/write throughout the entire disk
is 120MiB/s and it slows down toward the middle obviously but FYI.
So two disks saturate it, I get 120MiB/s on a PCI-e x1 card but when I run =
two
disks on it at the same time (saturing them I only get 80-90MiB/s) on each =
of
them for an aggregate bandwidth of ~160MiB/s, it could be the card too.

03:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid I=
I Controller (rev 01)
04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid I=
I Controller (rev 01)
05:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid I=
I Controller (rev 01)

(Not using RAID, they also act as a normal SATA controller)

Otherwise, very good write-up!

Justin.

---1463747160-1562106971-1215017021=:5166--
