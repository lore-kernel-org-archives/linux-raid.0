From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Several steps to death
Date: Tue, 26 Jan 2010 19:12:26 +0100
Message-ID: <1264529546.30742.95.camel@test.apertos.eu>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
	 <4B5EB5BD.7070406@shiftmail.org>
	 <5931ac0a02f59a2a2e1db82c630ff474.squirrel@www.dcsnow.com>
	 <4B5EEFD7.2080407@shiftmail.org>
	 <37bfaf9c6cbe90557cdef839be3ff20f.squirrel@www.dcsnow.com>
	 <1264517763.30742.88.camel@test.apertos.eu>
	 <4eae8d29d5e663323c7be0a31c8b6262.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HlRBkX/YD3G1JFEO7L9+"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4eae8d29d5e663323c7be0a31c8b6262.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-HlRBkX/YD3G1JFEO7L9+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-26, wto o godzinie 12:48 -0500, aragonx@dcsnow.com pisze:
> My thinking this morning is to setup a 2nd server with the 5 750GB
> disks
> and leave that as a software RAID.  Then I would purchase 2 2TB disks
> for
> my current server and just use them as-is.

Remember that if you lose any of the 2TB disks, you lose all data on
that disk. With those 5 disks in a RAID5 array, you can safely replace
any of them, without losing any data.

> Throughput is a concern though.  I currently was getting 50MB/sec over
> the
> network.  This was okay but I really wanted to get that up to 75MB/sec
> or
> more.

=46rom a RAID5 array (when reading) you should get more than from one,
even faster, disk. Remember that with a RAID5 data is read sequentially
from N-1 disks (where N is the number of disks in your array). Writing
can be a bit slower due to parity calculation that needs to occur.

I would stay with the software RAID setup, but it seems you should try
and read some more about it. Remember to use some monitoring tools like
smartd and mdadm --monitor that will shout at you when there are
problems.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-HlRBkX/YD3G1JFEO7L9+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktfMIoACgkQzQlUjpZYlbdaWQCeM+FqrXFvXZmKqYa2EtzaadrS
OsUAoKoUIrxtSaxaJrK31SjURWFsA6AA
=uQLH
-----END PGP SIGNATURE-----

--=-HlRBkX/YD3G1JFEO7L9+--

