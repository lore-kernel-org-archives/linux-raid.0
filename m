From: David Rees <drees76@gmail.com>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Sat, 1 Aug 2009 08:13:45 -0700
Message-ID: <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
	<20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk>
	<72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com>
	<20090731175455.GA11463@rap.rap.dk> <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com>
	<20090801130043.GA24915@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090801130043.GA24915@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/8/1 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> On Fri, Jul 31, 2009 at 01:10:37PM -0700, David Rees wrote:
>> Let's use some data from a real disk, the Velociraptor and a 2-disk
>> array and streaming reads/writes. =A0At the beginning of the disk yo=
u
>> can read about 120MB/s. =A0At the end of the disk, you can read abou=
t
>> 80MB/s.
>
> This is not actual figures from some benchmarking you did, true?

Those are actual numbers from a Velociraptor, but the numbers are just
estimates.

>> Data on the "beginning" of array, RAID0 =3D 240MB/s
>> Data on the "end" of array, RAID0 =3D 160MB/s.
>> Data on the "beginning" of array, RAID10,n2 =3D 120MB/s
>> Data on the "end" of array, RAID10,n2 =3D 80MB/s.
>> Data on the "beginning" of array, RAID10,f2 =3D 200MB/s
>
> Should be:
>
> Data on the "beginning" of array, RAID10,f2 =3D 230MB/s

No - you're getting 120 MB/s from one disk and 80MB/s from another.
How that would add up to 230MB/s defies logic...

>> With a f2 setup you'll read at something less than 120+80 =3D 200MB/=
s.
>
> When? at the beginning or the end?

The whole thing, on average.  But the whole point of f2 is to even out
performance from beginning of the array and let you stripe reads.

> Random read performance on a single disk, in one test, was 34 MB/s wh=
ile
> seq read on same disk was 82. In raid10,f2 with 2 disks random read w=
as
> 79 MB/s. This is 235 % of the random read on one disk (34 MB/s). This=
 is
> a likely result as you should expect a doubling in speed from the 2
> disks, and then som additional speed from the faster sectors of the
> outer disks, and then the shorter access times on the oyuter disk
> sectors. Geometry says that on average the transfer speeds are 17 %
> shorter on the outer half part of the disk, compared to the whole dis=
k.
> So that gives some 235 % speed improvement (2 * 1.17). The head
> improvement should also give a little, but maybe the elevator algorit=
hm
> of the file system eliminates most of that factor.

Sorry - I'm having a hard time wrapping my head around that you can
simply ignore access to the slow half the disk in a multi-threaded
random IO test.  The only way I might believe that you can get 235%
improvement is in a single threaded test with a queue depth of 1 which
lets the f2 setup only use the fast half the disks.  If that is your
assumption, then, OK.  But then getting 34MB/s isn't out of a rotating
disk isn't random IO, either.  Random IO on a rotating disk is
normally an order of magnitude slower.

>> Your benchmarks showed about a 13% performance hit for f2 compared t=
o
>> n2 and RAID1, so I wouldn't quite call it the same. =A0Close, but st=
ill
>> noticeably slower.
>
> Nah, for random write, MB/s:
>
> raid1 =A0 =A0 =A0 =A0 55
> raid10,n2 =A0 =A0 48
> raid10,f2 =A0 =A0 55

Sorry - must have read them wrong again.

>> >> 1. The array mostly sees write activity, streaming reads aren't t=
hat common.
>> >> 2. I can only get about 120 MB/s out of the external enclosure be=
cause
>> >> of the PCIe card [1] , so being able to stripe reads wouldn't hel=
p get
>> >> any extra performance out of those disks.
>> >> [1] http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#=
Silicon_Image_3124
>> >
>> > Hmm, a pci-e x1 should be able to get 2.5 Mbit/s =3D about 300 MB/=
s.
>> > Wikipedia says 250 MB/s. It is strange that you only can get 120 M=
B/s.
>> > That is the speed of a PCI 32 bit bus. I looked at your reference =
[1]
>> > for the 3132 model. Have you tried it out in practice?
>>
>> Yes, in practice, IO reached exactly 120MB/s out of the controller. =
=A0I
>> ran dd read/write tests on individual disks and found that overall
>> throughput peaked exactly at 120MB/s.
>
> Hmm, get another controller, then. A cheap PCIe contoller should be a=
ble
> to do about 300 MB/s on a x1 PCIe.

Please read my reference again.  It's a motherboard limitation.  I
already _have_ a good, cheap PCIe controller.

>> But the primary reason I built it was to handle lots of small random
>> writes/reads, so being limited to 120MB/s out of the enclosure isn't
>> noticeable most of the time in practice as you say.
>
> Yes, for random read/write you only get something like 45 % out of th=
e
> max transfer bandwidth. So 120 MB/s would be close to the max that yo=
ur
> 5 disks on the PCIe controller can deliver. With a faster PCIe
> controller you should be able to get better performance on random rea=
ds
> with raid10,f2. Anyway 180 MB/s may be fast enough for your applicati=
on.

Again - your idea of "random" IO is completely different than mine.
My random IO workloads can only get a couple MB/s out of a single
disk.

Here's a benchmark which tests SSDs and rotational disks.  All the
rotational disks are getting less than 1MB/s in the random IO test.
http://www.anandtech.com/storage/showdoc.aspx?i=3D3531&p=3D25  It's a
worst case scenario, but not far from my workloads which obviously
read a bit more data on each read.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
