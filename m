From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 16:18:31 +0000
Message-ID: <20100128161831.GB23933@cthulhu.home.robinhill.me.uk>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
 <1264634977.1928.13.camel@test.apertos.eu>
 <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
 <1264691314.1928.27.camel@test.apertos.eu>
 <d80f793f1001280713j5b0ee689m1c4c455403c64928@mail.gmail.com>
 <1264692194.1928.29.camel@test.apertos.eu>
 <d80f793f1001280750n68257e18n3e79ec0d68b5ac18@mail.gmail.com>
 <1264694363.1928.30.camel@test.apertos.eu>
 <d80f793f1001280805w3f7dee29n8afdb287494d7673@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d80f793f1001280805w3f7dee29n8afdb287494d7673@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 28, 2010 at 11:05:33AM -0500, Carlos Williams wrote:

> Thanks all. Last question. If I have my system as 3 disks in RAID5
> array and the 4th disk as a hot spare. Do I still need to format the
> 4th disk with a filesystem (ext4)? Or will that occur when the
> software discovers a disaster in the RAID volume and then starts to
> sync the 'hot spare' into the degraded array to take the place of the
> failed drive?
>=20
> The 4th disk does have a 'fd' (RAID) partition table created but no
> file system. Just trying to understand how that would work...
>=20
No, you don't need a filesystem.  The recovery process will use the data
on the remaining disks to calculate what data was on the failed drive,
and write that to the spare.  This data will include the filesystem (or
parts thereof).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkthuNYACgkQShxCyD40xBKhMQCeM5vVFox9oSeaWlgDsnLoizYr
qyEAn37uwSi9yreMSiYkqhS2VSIZRdTm
=47Tl
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
