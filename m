From: David Rees <drees76@gmail.com>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Tue, 4 Aug 2009 15:21:28 -0700
Message-ID: <72dbd3150908041521q1d71994cl25159d5ec3e7f326@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
	<20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk>
	<72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com>
	<20090731175455.GA11463@rap.rap.dk> <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com>
	<20090801130043.GA24915@rap.rap.dk> <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com>
	<20090801175734.GB27831@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090801175734.GB27831@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/8/1 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> On Sat, Aug 01, 2009 at 08:13:45AM -0700, David Rees wrote:
>> No - you're getting 120 MB/s from one disk and 80MB/s from another.
>> How that would add up to 230MB/s defies logic...
>
> Why only 80 MB/ when reading? reading from both disks with raid10,f2 =
are done at the
> beginning of both disks, thus getting about 115 MB/s from both of the=
m.
>
> reading in raid10,f2 is restricted to the faster half of the disk, by
> design.
>
> It is different when writing. there both halves, fast and slow, are
> used.

As I mentioned earlier, I was having a hard time visualizing the data
layout.  So here's a simple diagram that shows near/far layout and why
Keld was right - with a far layout, reads can be isolated to the fast
half of the disk.

It also shows how sequential writes (or any other write that spans
multiple chunks) force the drives to seek half way across the disk for
each write.

Near layout, 4 disks, 2 copies:
a b c d
0 0 1 1
2 2 3 3
4 4 5 5
6 6 7 7

=46ar layout, 4 disks, 2 copies
a b c d
0 1 2 3
4 5 6 7
7 0 1 2
3 4 5 6

>> >> > Hmm, a pci-e x1 should be able to get 2.5 Mbit/s =3D about 300 =
MB/s.
>> >> > Wikipedia says 250 MB/s. It is strange that you only can get 12=
0 MB/s.
>> >> > That is the speed of a PCI 32 bit bus. I looked at your referen=
ce [1]
>> >> > for the 3132 model. Have you tried it out in practice?
>> >>
>> >> Yes, in practice, IO reached exactly 120MB/s out of the controlle=
r. =A0I
>> >> ran dd read/write tests on individual disks and found that overal=
l
>> >> throughput peaked exactly at 120MB/s.
>> >
>> > Hmm, get another controller, then. A cheap PCIe contoller should b=
e able
>> > to do about 300 MB/s on a x1 PCIe.
>>
>> Please read my reference again. =A0It's a motherboard limitation. =A0=
I
>> already _have_ a good, cheap PCIe controller.
>
> OK, I read:
> [1] http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Sili=
con_Image_3124
> as being the description of the PCIe controller, especially SIL 3132 =
-
> the PCIe controller. And that this was restricted to 120 MB/s - not t=
he
> mobo. Anuway, yuo could get a new mobo, they are =A0cheap these days =
and
> many of them come with either 4 or 8 SATA interfaces. If you have bou=
ght
> Velociraptors then it must be for the speed, and quite cheap mobos co=
uld
> enhance your performance considerably.

Hah, I wish I had Velociraptors - I was only using those as an example
since I happened to have the IO rate charts handy. :-)  And also as I
mentioned, streaming IO is rare on this server - current throughput of
the setup is more than enough for the workload, especially considering
how little we spent on building the array.

I built my particular system on a severe budget using 8 spare 80GB
drives and a $165 5-bay external enclosure since the chassis doesn't
have room for more than 4 drives.  Spending a minimum of $600-750 on a
bare-bones motherboard/CPU/memory upgrade is not in the budget at this
time. The existing server is an old dual Xeon 3.2 GHz system with 8GB
RAM, and I would want to upgrade if I'm going to spend any more and
get something at least twice as fast meaning quad-core 3GHz+, 12-16GB
RAM, etc...

> yes, it seems we have different usage scenarios. I am serving reasona=
bly
> big files, say 700 MB ISO images, or .rpm packages of several MBs, yo=
u are
> probably doing some database access.

Yes, completely different.  You are working with mostly sequential
reads/writes on large files.

>> Here's a benchmark which tests SSDs and rotational disks. =A0All the
>> rotational disks are getting less than 1MB/s in the random IO test.
>> http://www.anandtech.com/storage/showdoc.aspx?i=3D3531&p=3D25 =A0It'=
s a
>> worst case scenario, but not far from my workloads which obviously
>> read a bit more data on each read.
>
> What are your average read or write block sizes? Is it some database
> usage?

Typical writes are very small - a few kB - database and application log=
s.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
