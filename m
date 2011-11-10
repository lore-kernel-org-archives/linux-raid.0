From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Thu, 10 Nov 2011 16:50:21 +0000
Message-ID: <20111110165020.GB3639@cthulhu.home.robinhill.me.uk>
References: <4EBBF60F.4030606@northfolk.ca>
 <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Purves <chris@northfolk.ca>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Nov 10, 2011 at 05:20:03PM +0100, Alexander K=FChn wrote:

> ddrescue to the rescue!
> Get a another new disk, then ddrescue the one with the read error to =20
> the new disk.
> Assemble the array using the new disk instead of the one with the read er=
ror.
> You will loose the blocks that can't be read of course.
> And in the future do run raid check/scrubbing at regular intervals. ;)
> Alex.
>=20
You may be better cloning the original failed disk - that way it will
have a chance of actually recovering the read error (rather than having
to lose the blocks). It depends on why/how/when the original disk failed
though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk68AMwACgkQShxCyD40xBKBlACg3T4kH9iCBWWO/S086p7NLCQr
33AAoMPJw1rMW2VNbNhpW079939MmLF5
=RCiF
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
