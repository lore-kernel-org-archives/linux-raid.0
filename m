From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Growing Linear RAID
Date: Wed, 9 Dec 2009 15:30:02 +0000
Message-ID: <20091209153002.GA5586@cthulhu.home.robinhill.me.uk>
References: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 09, 2009 at 08:31:54PM +0530, senthilkumar.muthukalai@wipro.com =
wrote:

> Hi,
>=20
> I am trying to add a disk to a Linear Raid which was created with 2
> disks.
> We use linux-2.6.18 and mdadm-2.6.4.
> I guess these support the above mentioned disk addition.
>=20
Why do you guess this?  The manual page should tell you exactly what's
supported, and even mdadm 3.1.1 makes no mention of support for growing
linear RAID:

        Currently supported growth options including changing the active
        size of component devices and  changing  the  number  of active
        devices  in RAID levels 1/4/5/6, changing the RAID level between
        1, 5, and 6, changing the chunk size and layout  for RAID5  and
        RAID5, as well as adding or removing a write-intent bitmap

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksfwnoACgkQShxCyD40xBJyowCfbiAeg1hhGATNm96WtN8fwZNO
ljEAnj4LljZ1EtaEz5f8+KembkWJfHy9
=NbHw
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
