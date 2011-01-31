From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 10:14:09 +0000
Message-ID: <20110131101409.GA7861@cthulhu.home.robinhill.me.uk>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jan 31, 2011 at 09:41:43AM +0000, Mathias Bur=E9n wrote:

> Hi,
>=20
> RAID10 is (could be) setup in this way, correct?
>=20
> 2 devices in a RAID1
> 2 devices in another RAID1
>=20
> Then you run RAID0 on top of them. If you're lucky you can lose 2
> devices at most (1 in each RAID1).
>=20
It could be, yes, or you could just use the RAID10 mode in md, which
simplifies the process and offers you a selection of different physical
layouts (some of which can offer significant performance benefits,
depending on usage).

> If you have, say 6 HDDs, would you create 3 RAID1 volumes? Then create
> a RAID0 on top of them?
>=20
Yes.

> How would one go about expanding a 4 HDD RAID10 into a 6 HDD RAID10?
> Is it "just" a matter of creating a new RAID1 array of the 2 new HDDs,
> then adding them to the RAID0, then expanding whatever is on that
> (lvm, xfs, ext4)?
>=20
Expansion of RAID0 (or RAID10) is not currently implemented, though
there is a workaround for RAID0.  The basic steps are to convert to
RAID4 with missing parity disk, expand, then convert back to RAID0.
It's a bit more complex though as you need to prevent md from recovering
the RAID4 array first - the full command process was posted a few days
ago though, so a dig through the archives should find them.  Proper
RAID0 expansion should be in a forthcoming (next?) mdadm release, not
sure about RAID10 expansion though.

Otherwise, yes, those are the correct steps needed for expanding the
array and filesystem.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1Gi3AACgkQShxCyD40xBJJiwCfTaikinBYDfd2E/sBQUGd072c
J1sAn0B+QiK/2ahrEJCf8C7+W4Y9VrLq
=+n/x
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
