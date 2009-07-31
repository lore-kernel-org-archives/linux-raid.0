From: David Rees <drees76@gmail.com>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Fri, 31 Jul 2009 13:10:37 -0700
Message-ID: <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
	<20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk>
	<72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com>
	<20090731175455.GA11463@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090731175455.GA11463@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/7/31 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> On Thu, Jul 30, 2009 at 01:11:20PM -0700, David Rees wrote:
>> 2009/7/30 Keld J=F8rn Simonsen <keld@dkuug.dk>:
>> > I think raid10,f2 only degrades 10-20 % while raid1 can degrade as=
 much
>> > as 50 %. For writing it is about the same, given that you use a fi=
le
>> > system on top of the raid.
>>
>> Has anyone done any benchmarks of near vs far setups?
>
> Yes, there are a number of benchmarks on raid10 near/far scenarios
> at http://linux-raid.osdl.org/index.php/Performance

Hmm, don't know how I missed those!  Thanks!

>> >From what I understand, here's how performance should go for a 2-di=
sk
>> raid10 setup:
>>
>> Streaming/large reads far: Up to 100% faster since reads are striped
>> across both disks
>
> and possibly faster, due to far only using the faster half of the dis=
k
> for reading.

How is it possible to go faster than 2x faster?  If the system only
reads from the disk that has the data on the faster half of the disk,
you can't stripe the reads, so you won't see a significant increase in
speed.

Let's use some data from a real disk, the Velociraptor and a 2-disk
array and streaming reads/writes.  At the beginning of the disk you
can read about 120MB/s.  At the end of the disk, you can read about
80MB/s.

Data on the "beginning" of array, RAID0 =3D 240MB/s
Data on the "end" of array, RAID0 =3D 160MB/s.
Data on the "beginning" of array, RAID10,n2 =3D 120MB/s
Data on the "end" of array, RAID10,n2 =3D 80MB/s.
Data on the "beginning" of array, RAID10,f2 =3D 200MB/s
Data on the "end" of array, RAID10,f2 =3D 200MB/s.

With a f2 setup you'll read at something less than 120+80 =3D 200MB/s.
So I guess it's a bit more than 100% faster than 80MB/s, in that
situation, but you get less than the peak performance of 240MB/s, so
I'd still call it on average, 100% faster.  It may be 120% faster in
some situations, but only 80% faster in others.

>> Streaming/large writes far: Slower than single disk, since disks hav=
e
>> to seek to write. =A0How much of a hit in performance will depend on
>> chunk size.
>> Streaming/large writes near: Same as single disk.
>
> Due to the elevator of the file system, writes are about the same for
> both near and far.

Your benchmarks showed about a 13% performance hit for f2 compared to
n2 and RAID1, so I wouldn't quite call it the same.  Close, but still
noticeably slower.

>> Random/small reads far: Up to 100% faster
>
> Actually a bit more, due to that far only uses the fastest half of th=
e
> disks. One test shows 132 % faster, which is consistent with theory.

I doubt that is the case on average.  Best case, yes.  Worst case, no.
 I guess I should have said "appx 100% faster" instead of Up to 100%
faster.  So we're both right. :-)

>> 1. The array mostly sees write activity, streaming reads aren't that=
 common.
>> 2. I can only get about 120 MB/s out of the external enclosure becau=
se
>> of the PCIe card [1] , so being able to stripe reads wouldn't help g=
et
>> any extra performance out of those disks.
>> [1] http://ata.wiki.kernel.org/index.php/Hardware,_driver_status#Sil=
icon_Image_3124
>
> Hmm, a pci-e x1 should be able to get 2.5 Mbit/s =3D about 300 MB/s.
> Wikipedia says 250 MB/s. It is strange that you only can get 120 MB/s=
=2E
> That is the speed of a PCI 32 bit bus. I looked at your reference [1]
> for the 3132 model. Have you tried it out in practice?

Yes, in practice, IO reached exactly 120MB/s out of the controller.  I
ran dd read/write tests on individual disks and found that overall
throughput peaked exactly at 120MB/s.

> The max you should be able to get out of your raid10 with 8 disks wou=
ld
> then be around 400 - 480 MB/s, for sequential reads. 250 MB/s out of =
your PCIE
> enclosure, or 50 MB/s per disk, and then additional 50 MB/s each of t=
he last
> 3 disks. You can only multiply the speed of the slowest of the disks
> involved by the number of disks. But even then it is not so bad.
> For random read it is better yet, given that this is not limited by t=
he
> transfer speed of your PCIe controller.

=46or streaming reads/writes, I have found am limited by the average
speed of each disk the array.  Because I am limited to 120 MB/s on the
5-disk enclosure, for writes I'm limited to about 80 MB/s.  For reads
which only have to come from half the disks, I am able to get up to
180 MB/s out of the array. (I did have to use blockdev --setra
/dev/md0 to increase the readahead size to at least 16MB to get those
numbers).

But the primary reason I built it was to handle lots of small random
writes/reads, so being limited to 120MB/s out of the enclosure isn't
noticeable most of the time in practice as you say.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
