From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Tiobench results LOWER with more threads
Date: Thu, 17 Oct 2002 23:50:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021017215014.GA7875@unthought.net>
References: <3DABCFE7.9070701@webmail.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DABCFE7.9070701@webmail.co.za>
To: Vladimir Milovanovic <vlad@webmail.co.za>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 15, 2002 at 10:20:55AM +0200, Vladimir Milovanovic wrote:
> OK, just joined the list and rad the faq, and something caught my eye.=20
> Tiobench results are apparently supposed to INCREASE when there are mor=
e=20
> threads.

No, what gave you that idea?

It is so much easier for the kernel to handle one sequential stream of
I/O, instead of many streams.

If you have more than one stream, you need to seek. Seeking is bad. One
sequential I/O is almost always (with the notable exception of RAID-1
reads) faster in total sustained throughput, and always (as in really
always) faster in per-thread sustained throughput.

>=20
> What I have is Tiobench results decreasing with more threads. This is m=
y=20
> setup:

Good, tiobench works  :)

>=20
> Celeron 633
> 196 MB PC 133
> Adaptec 29160 SCSI controller (PCI)
> 5 IBM Ultrastar 18XP (18gig, SCSI-3) disks hanging off the Adaptec=20
> controller
> Red Hat 7.3 Linux (2.4.18-3)
>=20
> Experimenting with different RAID configurations, I have found that I=20
> can not get more than 32 MB/s from this array with 4 disks, one spare. =
I=20
> have actually found out that the disks set the SCSI bus at 40 MB/s=20
> (since the disks are old) and that in RAID 0 it scales well, the speed=20
> doubles for two disks, and then the third disk brings in a little more=20
> performance, and then things topp off at 32 MB/s with four disks. Addin=
g=20
> the fifth disk gains no extra performance.
>=20
> Apparently VIA chipsets have problems with PCI bursting, so that is why=
=20
> I can't see the full 40 MB/s. That's fine.

There's some SCSI overhead as well.  And probably you have some RAM
bandwidth limitation also - although that is probably not very important
at the speed you're seeing.  But it all adds up.

> But, my tests with tiobench also show that performance decreases as=20
> extra threads are added. I am testing with a file of 800 MB (approx. 4x=
=20
> size of RAM, to get meaningful results) and the decrease with threads,=20
> while READING only, is consistent in all RAID levels. The write=20
> performance will sometimes increase, sometimes stay the same.
>=20
> WHY is this happening? Is it something I have not set up right , or=20
> what? I am not so much interested in getting more speed out of these ol=
d=20
> disks, they are gonna be replaced soon anyway, but I REALLY want to kno=
w=20
> WHY is this??

If you used SDRAM instead of disks with actual spindles, you should see
almost the same total sustained I/O going from 1 to some handfull or two
of threads.

But you use real disks. Those have heads that need to move when seeking.
The average seek time for your disks is probably around 7 ms. Let's say
you can do 10 MB/sec sequential reading from a disk (low number
probably), then *one* seek costs you the equivalent of 72 kB (low number
again) of transfer that you do not get while seeking.

The kernel will have to do a lot of seeks to satisfy your multiple
readers. That's many times 72kB.  And that's why you're losing
performance using more readers (or writers).

The more you add, the more you lose  :)

--=20
................................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
