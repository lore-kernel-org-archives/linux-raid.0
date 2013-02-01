From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Fri, 1 Feb 2013 19:57:34 +0000
Message-ID: <20130201195734.GA16573@cthulhu.home.robinhill.me.uk>
References: <510A4AAE.6000009@evilazrael.de>
 <20130131113820.GA20536@cthulhu.home.robinhill.me.uk>
 <510A6E54.5050001@evilazrael.de>
 <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com>
 <20130131221007.GA1447@cthulhu.home.robinhill.me.uk>
 <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com>
 <20130201133455.GA24375@cthulhu.home.robinhill.me.uk>
 <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Christoph Nelles <evilazrael@evilazrael.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Feb 01, 2013 at 10:27:57 -0700, Chris Murphy wrote:

>=20
> On Feb 1, 2013, at 6:34 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > It'd also be useful to know whether sdg has been rewritten at
> > all since then (i.e. whether the testing was destructive or not), and
> > whether or not the array was written to at all since the failure of sdg.
>=20
> OP needs to reply back.
>=20
> Also I'd like to know what model disks these are, if they're AF or not.
>=20
> >> Yes, if sdg still contains valid array data (and the array wasn't
> > written since then) then it would definitely make more sense to recreate
> > the array using it, leaving sdj out for now. That'll require more work
> > checking mdadm versions and data offset values though. That'll avoid the
> > issues with the unreadable blocks on sdj.
>=20
> Here's an idea. One possibility is to use dd to read the sector on
> sdg1 that error1.txt reported with the write error, to a file, and see
> if there's a read error. If not, rewrite that data back to the same
> sector and see if there's a write error. If not, attempt to force
> assemble assume clean, get the array up in degraded mode, and do a
> non-destructive fsck. If that's OK, just take a backup immediately.
> Then sdj can be destructively written to, to force bad sectors there
> to be removed for reserves, but still needs a smart extended offline
> test to confirm; and then possibly reused and rebuilt.
>=20
That won't work. He's already lost the metadata on sdg1 by trying to
rebuild it in the first place, so a force assemble won't work. He'd need
to recreate the array instead. Otherwise yes, that would sound to be the
best option (assuming there's no other read errors on the other disks).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEMHi0ACgkQShxCyD40xBJedgCcDk0aXn0LikIXdmPS9ejKRMUT
f60AoIUC0nKjrAecbWCIp83r2e1cjHdT
=hh8D
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
