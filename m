From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: raid0 low performance
Date: Fri, 01 Jul 2005 08:32:44 -0400
Message-ID: <1120221164.5507.19.camel@localhost.localdomain>
References: <1120184148.5521.21.camel@localhost.localdomain>
	 <42C4AA31.8040307@dtbb.net>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BxxX8Ft7oKm9FtPPYr7G"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C4AA31.8040307@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-BxxX8Ft7oKm9FtPPYr7G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

i also suspect this marvel driver or chip and want to change to another
one. but before buying one, maybe i should gather some information on
which one is the best 8port or 12 port. :P

cpu utilization is not high. < 20%

i write a small program that allocate a piece of buffer and write the
buffer to device again and again synchronously, no mmap, glibc fwrite,
just basic write system call. i can attach the code here if this list
allows.

i tested to write to /dev/null or a ram disk, pretty fast.

ming


On Thu, 2005-06-30 at 19:28 -0700, Tyler wrote:
> My guess at a glance would be either the Marvel driver is at fault, or=20
> the simple fact of software raid performance... did you monitor the cpu=20
> useage during the tests?  even PCI 32bit, 33mhz should be able to hit=20
> 133 Mbytes per second I believe.  What are you writing *from* ? dev/zero=20
> or another drive that may not have a read speed high enough to keep up=20
> with what is available?
>=20
> Tyler.
>=20
> Ming Zhang wrote:
>=20
> >I meet some strange low performance when run RAID0 with vanilla kernel
> >2.4.27/2.6.11.12.
> >
> >My box is a 2.8G P4 and 1G RAM. 8 400GB SATA disk and A marvel 8port
> >controller. I run marvel 3.4.1 driver. I wrote a small program to write
> >device sequentially and SYNCHRONOUSLY.
> >
> >This is performance of 1 disk. looks fine.
> >
> > 1048576Bytes *     1024 :    55.466MB/s
> >  524288Bytes *     2048 :    55.830MB/s
> >  262144Bytes *     4096 :    55.782MB/s
> >  131072Bytes *     8192 :    55.567MB/s
> >   65536Bytes *    16384 :    55.926MB/s
> >   32768Bytes *    32768 :    54.344MB/s
> >   16384Bytes *    65536 :    41.415MB/s
> >    8192Bytes *    65536 :    26.499MB/s
> >    4096Bytes *    65536 :    15.110MB/s
> >    2048Bytes *    65536 :     8.422MB/s
> >    1024Bytes *    65536 :     4.318MB/s
> >
> >But when run 2 disk raid0, there is only 10% improvement.
> >
> >md3 : active raid0 sdb[1] sda[0]
> >      781422592 blocks 64k chunks
> > 1048576Bytes *     1024 :    67.300MB/s
> >  524288Bytes *     2048 :    66.796MB/s
> >  262144Bytes *     4096 :    65.728MB/s
> >  131072Bytes *     8192 :    65.017MB/s
> >   65536Bytes *    16384 :    59.223MB/s
> >   32768Bytes *    32768 :    49.766MB/s
> >   16384Bytes *    65536 :    39.162MB/s
> >    8192Bytes *    65536 :    26.386MB/s
> >    4096Bytes *    65536 :    15.084MB/s
> >    2048Bytes *    65536 :     8.383MB/s
> >    1024Bytes *    65536 :     4.303MB/s
> >
> >And when use 4 disks, the speed is slower!
> >md0 : active raid0 sdh[3] sdg[2] sdf[1] sde[0]
> >      1562845184 blocks 64k chunks
> > 1048576Bytes *     1024 :    58.032MB/s
> >  524288Bytes *     2048 :    56.994MB/s
> >  262144Bytes *     4096 :    58.289MB/s
> >  131072Bytes *     8192 :    65.999MB/s
> >   65536Bytes *    16384 :    59.723MB/s
> >   32768Bytes *    32768 :    50.061MB/s
> >   16384Bytes *    65536 :    38.689MB/s
> >    8192Bytes *    65536 :    26.169MB/s
> >    4096Bytes *    65536 :    15.169MB/s
> >    2048Bytes *    65536 :     8.378MB/s
> >    1024Bytes *    65536 :     4.287MB/s
> >
> >
> >Any hint on this?
> >
> >* I do not know how to check current PCI bus speed and I am not sure
> >whether is limited by that. It is a 64bit card but I am not sure if it
> >is run at 66MHZ. Should be, but want to check to make sure.
> >* I tested each disk and all disk performs OK.
> >
> >
> >Thanks
> >
> >
> >Ming
> >
> > =20
> >
>=20

--=-BxxX8Ft7oKm9FtPPYr7G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCxTfsSYbkL5BnVYoRAil2AJ0YFLB9Y47jqlXIWEOBMX6Pre1CuACdFugP
8cHv+kh2a3441EBqebIlqPc=
=ctqr
-----END PGP SIGNATURE-----

--=-BxxX8Ft7oKm9FtPPYr7G--

