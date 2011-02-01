From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 09:20:07 +0000
Message-ID: <20110201092007.GA7860@cthulhu.home.robinhill.me.uk>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
 <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
 <20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
 <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
 <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
 <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
 <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
 <4D470F96.40409@cfl.rr.com>
 <4D471A41.1090706@hardwarefreak.com>
 <4D4730C0.8080900@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4730C0.8080900@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jan 31, 2011 at 04:59:28PM -0500, Phillip Susi wrote:

> On 1/31/2011 3:23 PM, Stan Hoeppner wrote:
> > This is absolutely not correct.  In a 10 disk RAID 10 array, exactly 5 =
disks can
> > fail, as long as no two are in the same mirror pair, and the array will=
 continue
> > to function, with little or no performance degradation.
>=20
> That is a raid 0+1, not raid10.
>=20
No, it's RAID 10 or RAID 1+0. RAID 0+1 would be 2 mirrored pairs of
5-disk RAID 0 arrays, in which case you could only lose 5 disks if
they're all from the same RAID 0 array.  With RAID 10 or RAID 1+0 (in
the case of a 10-disk n2 setup, the physical layout should be exactly
the same) then the restriction is, as stated, that no two are "mirrored"
(whether that's a separate RAID 1 mirror or just that the two are
defined by the RAID 10 layout to contain the same data is irrelevant).

> > Where are you getting your information?  Pretty much everything you sta=
ted is
> > wrong...
>=20
> The mdadm man page.
>=20
The md man page would be better for information on the physical layouts,
but I don't see anything on there to support what you're saying here.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1H0EcACgkQShxCyD40xBKefQCcDzqpsQvw134+tjGydo2dZdxL
C5IAoJZwNqYP5SFq9bA+sjdHZyoumOSm
=Eafb
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
