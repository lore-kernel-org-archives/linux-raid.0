From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What parameters to mdadm, to re-create md device with payload
 starting at 0x22000 position on backing storage?
Date: Tue, 18 Sep 2012 08:52:13 +0100
Message-ID: <20120918075213.GA15342@cthulhu.home.robinhill.me.uk>
References: <5056CA7E.5040303@statystyka.net>
 <20120917174952.GA6559@cthulhu.home.robinhill.me.uk>
 <50581A65.5050201@statystyka.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50581A65.5050201@statystyka.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 18, 2012 at 08:53:25AM +0200, Adam Ryczkowski wrote:

> On 2012-09-17 19:49, Robin Hill wrote:
>=20
> > Your data offset is 272 sectors, which means you'll need to use an older
> > mdadm version to re-create the array. Newer versions use 2048 sectors,
> > but it looks like version 3.0 uses 272, so grab a copy of that if
> > possible.
> Does it mean, that with the current raid setup I need to stick to the=20
> mdadm 3.0, or is there way to convert the arrays to the new layout so I=
=20
> can use a recent mdadm? Re-creating the arrays from scratch would be a=20
> very long and complex enterprise.
>=20
You only need 3.0 to do the create. Once that's done, you can use any
newer version.

The only way I know of to update the offset location in an existing
array would be to fail the disks one at a time, zeroing the superblocks,
then adding them back into the array using a new mdadm. When it's added
back in, it'll use the new offset location. If you have a spare disk and
a new enough kernel version, you can use the pre-emptive replacement
option, which will prevent the need to run without full parity
available.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBYKC0ACgkQShxCyD40xBKhyQCgiGFIntGdt6b6H78MSQRMFvN9
gWEAnRxfYBwbyQptmiz00/mBlzyVNNYC
=7d9l
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
