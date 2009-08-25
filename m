From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Tue, 25 Aug 2009 09:16:17 +0100
Message-ID: <20090825081617.GA8885@cthulhu.home.robinhill.me.uk>
References: <15771.7292.qm@web51312.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15771.7292.qm@web51312.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Aug 25, 2009 at 12:54:49AM -0700, Jon Hardcastle wrote:

> Guys,
>=20
> I have been having some problems with my arrays that I think i have
> nailed down to a pci controller (well I say that - it is always the
> drives connected to *a* controller but I have tried 2!) anyway the
> latest saga is i was trying some new kernel options last night - which
> didn't work.
>=20
Did they have the same chipset?  I had problems with PCI controllers on
one of my systems, which turned out to be some sort of conflict between
the onboard chipset and the chipset on the controllers.  I found a PCI
card with a different chipset and have had no issues since.

> But when i booted up again this morning it said one of the drives was
> in an inconsistent state (not sure of the *exact* error message). I
> then kicked off an add of the drive and it started syncing. It got
> about 5% in and then the second drive in on that controller complained
> and the array failed.
>=20
> Is there any hope for my data? If i get a good controller in there
> will the resync continue? can I try and tell it to assume the drives
> are good (which they ought to be)?
>=20
There's definitely hope.  You can assemble the array (using the good
drives and the last drive to fail) using the --force option, then re-add
(and sync) the other drive (I'd recommend doing a fsck on the filesystem
as well).  I've just had to do a similar thing myself after two drives
failed (overheated after a fan failure).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqTndEACgkQShxCyD40xBKFXwCgxKjyHU4uoWZ06GpWbc2dLy6p
3VYAnjkIazj4HUHu2Z4I22Bkbi0QrhcX
=nVgV
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
