From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Fwd: mismatches in raid1, clarification please
Date: Tue, 11 Jun 2013 16:17:24 +0100
Message-ID: <20130611151724.GA22861@cthulhu.home.robinhill.me.uk>
References: <CAHOfOo1Ex+JsJ3NDzyKxAkabBMY4up0apftMK=mVwS4rw_E+Bg@mail.gmail.com>
 <CAHOfOo0gjhXV701kwHcLS4-VYvxCnpLZp76P7hc_-e_g6vi-BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHOfOo0gjhXV701kwHcLS4-VYvxCnpLZp76P7hc_-e_g6vi-BA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Brooks <arb@sat.dundee.ac.uk>
Cc: Linux-RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Jun 11, 2013 at 02:49:03PM +0100, Andrew Brooks wrote:

> Hello
>=20
> The md manual says that
>  "If all blocks read successfully but are found to not be consistent, then
> this is regarded as a mismatch."
> whereas blocks that suffer from a read error are not counted as mismatche=
s.
>=20
> It then describes the action
>  "If repair was used, then a mismatch will be repaired in the same way th=
at
> resync repairs arrays. For RAID1, all but one block are overwritten with =
the
> content of that one block."
>=20
> If there has been no read error then how does it know which block is good?
>=20
It doesn't. I'm not sure what the algorithm is to pick which disk to use
as the reference value, but one disk is picked and that data is then
written to the other mirrors (no matter how many mirrors you have and
how many had each differing value). It's not ideal but it does keep the
code very simple and it returns the array to a consistent state. Without
filesystem level information, there's no way to comprehensively tell
what the correct data is (or whether it matters - in many cases the
"data" has already been deleted anyway).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEARECAAYFAlG3P4QACgkQShxCyD40xBKNeQCgr11kQxqkzV4XdQB+JTIUNbjg
gSUAoLrZk+xwkyT04mC562S5K+xDJkuA
=Lj/i
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
