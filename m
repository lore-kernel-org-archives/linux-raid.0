From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid1 rebuild slows to a crawl
Date: Fri, 13 Jan 2012 08:46:59 +0000
Message-ID: <20120113084659.GA24667@cthulhu.home.robinhill.me.uk>
References: <4F0FE4CD.3070703@cogweb.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F0FE4CD.3070703@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jan 13, 2012 at 01:31:17PM +0530, David Liontooth wrote:

>=20
> I'm trying to use a WD3200AAKX-001CA0 drive in a raid1 configuration=20
> (Debian squeeze mdadm 3.1.4-1+8efb9d1), but adding it is unusably slow:
>=20
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sdb3[2] sda3[1]
>        73015360 blocks [2/1] [_U]
>        [>....................]  recovery =3D  0.0% (28928/73015360)=20
> finish=3D2521.6min speed=3D482K/sec
>=20
> dmesg shows no errors:
>=20
> md: recovery of RAID array md0
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000=
=20
> KB/sec) for recovery.
>=20
> The drive itself doesn't seem to have a problem, though it's not=20
> particularly fast:
>=20
> # hdparm -tT /dev/sdb
>=20
> /dev/sdb:
>   Timing cached reads:   11220 MB in  2.00 seconds =3D 5614.03 MB/sec
>   Timing buffered disk reads: 174 MB in  6.44 seconds =3D  27.01 MB/sec
>=20
> # smartctl -a /dev/sdb
>=20
> 5 Reallocated_Sector_Ct   0x0033   133   133   140    Pre-fail  Always  =
=20
> FAILING_NOW 1265
>=20
It has 1265 reallocated sectors, reports FAILING_NOW, and you say it
doesn't seem to have a problem?  At a guess, it's repeatedly getting a
write failure, hitting the error retry timeout (which is quite long for
consumer drives),failing the sector, then reallocating it and moving on
to do the same with the next sector.

Get rid of this drive and get a replacement - there's no way you can
rely on it at all.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk8P74MACgkQShxCyD40xBKLRwCgtVl48cQRjmsPy8/CaW6GlVTq
ENEAoLvvPZpSI8kWM4wGpaICTWb3WspY
=Z3Cl
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
