From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What does --replace actually do?
Date: Fri, 15 Apr 2016 13:18:12 +0100
Message-ID: <20160415121812.GA22573@cthulhu.home.robinhill.me.uk>
References: <5710CFF8.70508@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5710CFF8.70508@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 15, 2016 at 09:26:48PM +1000, Eyal Lebedinsky wrote:

> When I request to replace sda with sdj (RAID6 in my case), does it
> create sdj from the other members (NOT using sda) or does it make a
> copy of (by reading) sda?
>=20
> I hope it is the former, assuming sda is having issues and the action
> is precautionary.
>=20
It's the latter. The data is copied from the existing disk, unless a
read-error occurs, in which case it'll be reconstructed from the other
members. This will be faster and have a far lower impact on performance
than using the other members for everything. If you cannot trust the
disk you're replacing then it should be failed and a normal rebuild
carried out instead.

> And while I am here, can I replace two members at the same time? This
> should save time as it takes about 10 hours to reconstruct a 4TB member.
>=20
I've no idea on this one I'm afraid. I can't think of any immediate
reason why this wouldn't be possible, but whether the current
implementation supports it or not is another matter. You could test with
loopback devices.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlcQ3AMACgkQShxCyD40xBLGFACfbYdQ2b4UtwkWYxKo4PPRWLIe
EhsAoLbEKhvxphM9G+dccqpEln8rVbiU
=8mvm
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
