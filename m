From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Tue, 25 Aug 2009 10:34:37 +0100
Message-ID: <20090825093437.GB8885@cthulhu.home.robinhill.me.uk>
References: <20090825081617.GA8885@cthulhu.home.robinhill.me.uk> <264077.82481.qm@web51303.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <264077.82481.qm@web51303.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Aug 25, 2009 at 01:40:31AM -0700, Jon Hardcastle wrote:

> --- On Tue, 25/8/09, Robin Hill <robin@robinhill.me.uk> wrote:
>=20
> > From: Robin Hill <robin@robinhill.me.uk>
> > Subject: Re: Raid 5 - not clean and then a failure.
> > To: linux-raid@vger.kernel.org
> > Date: Tuesday, 25 August, 2009, 9:16 AM
> > On Tue Aug 25, 2009 at 12:54:49AM
> > -0700, Jon Hardcastle wrote:
> >=20
> > > Guys,
> > >=20
> > > I have been having some problems with my arrays that I think i have
> > > nailed down to a pci controller (well I say that - it is always the
> > > drives connected to *a* controller but I have tried 2!) anyway the
> > > latest saga is i was trying some new kernel options last night - which
> > > didn't work.
> > >=20
> > Did they have the same chipset?=A0 I had problems with PCI controllers =
on
> > one of my systems, which turned out to be some sort of conflict between
> > the onboard chipset and the chipset on the controllers.=A0 I found a PCI
> > card with a different chipset and have had no issues since.
>=20
> They are/were cheapy little via ones from 'aria' I got a new one and
> installed it along side a week ago 1 drive on it to 'test', when my
> array came to do a scrub a week later I got a whole host of issues. I
> am not sure what the cause was but now either of the controllers seem
> work reliably. I have a pci express controller but my kernel doesnt
> (yet!) support pci express. Do you know of you can get sata 3 on pci?
> or is it too slow?
>=20
By SATA 3, I assume you're actually referring to SATA 3GBit/s (as SATA 3
has only just been ratified, and I doubt you can get it at all yet)?
You'll probably be able to find PCI cards that support it, but the
standard PCI bus (32-bit, 33MHz) only has a bandwidth of 1 GBit/s, so
can't even keep up with 1.5GBit/s SATA, let alone 3GBit/s.  A 64-bit or
66MHz bus would do better though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqTsCwACgkQShxCyD40xBJ83ACcDacVfmUe1hpebeq4ymHO7oek
PQEAoKy9lqHPWXO0nO3HjsRfRUwPGB2Z
=AkmB
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
