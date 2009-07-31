From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Fri, 31 Jul 2009 19:54:55 +0200
Message-ID: <20090731175455.GA11463@rap.rap.dk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com> <20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk> <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 30, 2009 at 01:11:20PM -0700, David Rees wrote:
> 2009/7/30 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> > I think raid10,f2 only degrades 10-20 % while raid1 can degrade as =
much
> > as 50 %. For writing it is about the same, given that you use a fil=
e
> > system on top of the raid.
>=20
> Has anyone done any benchmarks of near vs far setups?

Yes, there are a number of benchmarks on raid10 near/far scenarios
at http://linux-raid.osdl.org/index.php/Performance

> >From what I understand, here's how performance should go for a 2-dis=
k
> raid10 setup:
>=20
> Streaming/large reads far: Up to 100% faster since reads are striped
> across both disks

and possibly faster, due to far only using the faster half of the disk
for reading.

> Streaming/large reads near: Same as single disk as reads can't be
> striped across both disks

yes.

> Streaming/large writes far: Slower than single disk, since disks have
> to seek to write.  How much of a hit in performance will depend on
> chunk size.
> Streaming/large writes near: Same as single disk.

Due to the elevator of the file system, writes are about the same for
both near and far.

> Random/small reads far: Up to 100% faster

Actually a bit more, due to that far only uses the fastest half of the
disks. One test shows 132 % faster, which is consistent with theory.

> Random/small reads near: Up to 100% faster

One test shows 156 % faster.

> Random/small writes far: Same as single disk.
> Random/small writes near: Same as single disk.

yes.

> So basically, if you have a setup which mostly reads from disk, using
> a far layout is beneficial, but if you have a setup which does a
> higher percentage of writes, sticking to a near layout will be faster=
=2E

=46or reading, this is true, but for writing, it is not true, given tha=
t
you use a filesystem, with an elevator algorithm in use. The elevator
evens out the lesser performance of layout=3Dfar for a raw raid10,f2, s=
o
that the performance is about the same for the near and far layouts.

> I recently set up an 8-disk RAID10 across 8 7200 disks across 3 contr=
ollers.
>=20
> 5 disks are in an external enclosure via eSATA and a PCIe card.
> 2 disks are using onboard SATA controller
> 1 disk is using onboard IDE controller
>=20
> I debated whether or not to use near or far, but ultimately stuck wit=
h
> near for two reasons:
>=20
> 1. The array mostly sees write activity, streaming reads aren't that =
common.
> 2. I can only get about 120 MB/s out of the external enclosure becaus=
e
> of the PCIe card [1] , so being able to stripe reads wouldn't help ge=
t
> any extra performance out of those disks.

Hmm, a pci-e x1 should be able to get 2.5 Mbit/s =3D about 300 MB/s.=20
Wikipedia says 250 MB/s. It is strange that you only can get 120 MB/s.
That is the speed of a PCI 32 bit bus. I looked at your reference [1]
for the 3132 model. Have you tried it out in practice?

The max you should be able to get out of your raid10 with 8 disks would
then be around 400 - 480 MB/s, for sequential reads. 250 MB/s out of yo=
ur PCIE
enclosure, or 50 MB/s per disk, and then additional 50 MB/s each of the=
 last
3 disks. You can only multiply the speed of the slowest of the disks
involved by the number of disks. But even then it is not so bad.
=46or random read it is better yet, given that this is not limited by t=
he
transfer speed of your PCIe controller.

> -Dave
>=20
> [1] http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Sili=
con_Image_3124
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
