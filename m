From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Sat, 1 Aug 2009 19:57:34 +0200
Message-ID: <20090801175734.GB27831@rap.rap.dk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com> <20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk> <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com> <20090731175455.GA11463@rap.rap.dk> <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com> <20090801130043.GA24915@rap.rap.dk> <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Aug 01, 2009 at 08:13:45AM -0700, David Rees wrote:
> 2009/8/1 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> > On Fri, Jul 31, 2009 at 01:10:37PM -0700, David Rees wrote:
> >> Let's use some data from a real disk, the Velociraptor and a 2-dis=
k
> >> array and streaming reads/writes. =A0At the beginning of the disk =
you
> >> can read about 120MB/s. =A0At the end of the disk, you can read ab=
out
> >> 80MB/s.
> >
> > This is not actual figures from some benchmarking you did, true?
>=20
> Those are actual numbers from a Velociraptor, but the numbers are jus=
t
> estimates.
>=20
> >> Data on the "beginning" of array, RAID0 =3D 240MB/s
> >> Data on the "end" of array, RAID0 =3D 160MB/s.
> >> Data on the "beginning" of array, RAID10,n2 =3D 120MB/s
> >> Data on the "end" of array, RAID10,n2 =3D 80MB/s.
> >> Data on the "beginning" of array, RAID10,f2 =3D 200MB/s
> >
> > Should be:
> >
> > Data on the "beginning" of array, RAID10,f2 =3D 230MB/s
>=20
> No - you're getting 120 MB/s from one disk and 80MB/s from another.
> How that would add up to 230MB/s defies logic...

Why only 80 MB/ when reading? reading from both disks with raid10,f2 ar=
e done at the
beginning of both disks, thus getting about 115 MB/s from both of them.

> >> With a f2 setup you'll read at something less than 120+80 =3D 200M=
B/s.
> >
> > When? at the beginning or the end?
>=20
> The whole thing, on average.  But the whole point of f2 is to even ou=
t
> performance from beginning of the array and let you stripe reads.
>=20
> > Random read performance on a single disk, in one test, was 34 MB/s =
while
> > seq read on same disk was 82. In raid10,f2 with 2 disks random read=
 was
> > 79 MB/s. This is 235 % of the random read on one disk (34 MB/s). Th=
is is
> > a likely result as you should expect a doubling in speed from the 2
> > disks, and then som additional speed from the faster sectors of the
> > outer disks, and then the shorter access times on the oyuter disk
> > sectors. Geometry says that on average the transfer speeds are 17 %
> > shorter on the outer half part of the disk, compared to the whole d=
isk.
> > So that gives some 235 % speed improvement (2 * 1.17). The head
> > improvement should also give a little, but maybe the elevator algor=
ithm
> > of the file system eliminates most of that factor.
>=20
> Sorry - I'm having a hard time wrapping my head around that you can
> simply ignore access to the slow half the disk in a multi-threaded
> random IO test.=20

reading in raid10,f2 is restricted to the faster half of the disk, by
design.

It is different when writing. there both halves, fast and slow, are
used.

> The only way I might believe that you can get 235%
> improvement is in a single threaded test with a queue depth of 1 whic=
h
> lets the f2 setup only use the fast half the disks.=20

The test was for a multi-threaded test, with many processes running, sa=
y
about 200 processes. The test was set up to mimick a ftp mirror.

> If that is your
> assumption, then, OK.  But then getting 34MB/s isn't out of a rotatin=
g
> disk isn't random IO, either.  Random IO on a rotating disk is
> normally an order of magnitude slower.

Agreed. The 34 MB/s is random io in a multi-thread environment. and an =
elevator
algorithm is in operation.=20

If you only do the individual random reading in a single thread, it
would be much slower. However, the same speedups will occur for
raid10,f2. There will be a double up from reading from 2 disks at the
same time, and only using the faster half of the disks will both make a
better overall transfer rate, and quicker access times.

> >> >> 1. The array mostly sees write activity, streaming reads aren't=
 that common.
> >> >> 2. I can only get about 120 MB/s out of the external enclosure =
because
> >> >> of the PCIe card [1] , so being able to stripe reads wouldn't h=
elp get
> >> >> any extra performance out of those disks.
> >> >> [1] http://ata.wiki.kernel.org/index.php/Hardware,_driver_statu=
s#Silicon_Image_3124
> >> >
> >> > Hmm, a pci-e x1 should be able to get 2.5 Mbit/s =3D about 300 M=
B/s.
> >> > Wikipedia says 250 MB/s. It is strange that you only can get 120=
 MB/s.
> >> > That is the speed of a PCI 32 bit bus. I looked at your referenc=
e [1]
> >> > for the 3132 model. Have you tried it out in practice?
> >>
> >> Yes, in practice, IO reached exactly 120MB/s out of the controller=
=2E =A0I
> >> ran dd read/write tests on individual disks and found that overall
> >> throughput peaked exactly at 120MB/s.
> >
> > Hmm, get another controller, then. A cheap PCIe contoller should be=
 able
> > to do about 300 MB/s on a x1 PCIe.
>=20
> Please read my reference again.  It's a motherboard limitation.  I
> already _have_ a good, cheap PCIe controller.

OK, I read:
[1] http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Silico=
n_Image_3124
as being the description of the PCIe controller, especially SIL 3132 -
the PCIe controller. And that this was restricted to 120 MB/s - not the
mobo. Anuway, yuo could get a new mobo, they are  cheap these days and
many of them come with either 4 or 8 SATA interfaces. If you have bough=
t
Velociraptors then it must be for the speed, and quite cheap mobos coul=
d
enhance your performance considerably.

> >> But the primary reason I built it was to handle lots of small rand=
om
> >> writes/reads, so being limited to 120MB/s out of the enclosure isn=
't
> >> noticeable most of the time in practice as you say.
> >
> > Yes, for random read/write you only get something like 45 % out of =
the
> > max transfer bandwidth. So 120 MB/s would be close to the max that =
your
> > 5 disks on the PCIe controller can deliver. With a faster PCIe
> > controller you should be able to get better performance on random r=
eads
> > with raid10,f2. Anyway 180 MB/s may be fast enough for your applica=
tion.
>=20
> Again - your idea of "random" IO is completely different than mine.
> My random IO workloads can only get a couple MB/s out of a single
> disk.

yes, it seems we have different usage scenarios. I am serving reasonabl=
y
big files, say 700 MB ISO images, or .rpm packages of several MBs, you =
are
probably doing some database access.

> Here's a benchmark which tests SSDs and rotational disks.  All the
> rotational disks are getting less than 1MB/s in the random IO test.
> http://www.anandtech.com/storage/showdoc.aspx?i=3D3531&p=3D25  It's a
> worst case scenario, but not far from my workloads which obviously
> read a bit more data on each read.

What are your average read or write block sizes? Is it some database
usage?

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
