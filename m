From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Wed, 15 Feb 2012 14:03:17 +0000
Message-ID: <20120215140317.GB18336@cthulhu.home.robinhill.me.uk>
References: <4F35E925.6000003@hardwarefreak.com>
 <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
 <4F38FD5D.1010201@hardwarefreak.com>
 <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
 <20120213230228.GA5822@www5.open-std.org>
 <4F39D9B2.3050305@hardwarefreak.com>
 <20120214113832.GA6157@www5.open-std.org>
 <4F3AEDEF.2000608@hardwarefreak.com>
 <20120215083058.GA8821@cthulhu.home.robinhill.me.uk>
 <4F3BB385.4000608@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3BB385.4000608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 15, 2012 at 07:30:45 -0600, Stan Hoeppner wrote:

> On 2/15/2012 2:30 AM, Robin Hill wrote:
> > On Tue Feb 14, 2012 at 05:27:43PM -0600, Stan Hoeppner wrote:
> >=20
> >> Maybe I simply don't understand this 'magic' of the f2 and far layouts.
> >>  If you only read the "faster half" of a spindle, does this mean writes
> >> go to the slower half?  If that's the case, how can you read data that=
's
> >> never been written?
> >>
> > Writes go to both halves, as normal for a mirrored setup, which is why
>=20
> Huh?  A 'normal' RAID setup mirrors one disk to another.  You're
> describing data being mirrored from the outer half of a single disk to
> the inner half.  Where's the Redundancy in this?  This doesn't make sense.
>=20
No, the outer half of one disk is mirrored to the inner half of the
next (for an f2 layout anyway - an f3 will split it into thirds). Its
outer half is in turn mirrored to the inner half of the next one, and so
on until the outer half of the last disk is mirrored to the inner half
of the last one. You can lose any non-adjacent disks without losing the
data.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk87uyQACgkQShxCyD40xBKkeQCfcJ0rKXSferPIYmE1htokxJra
U2cAoODsxdMpSVO3SsZH5pXw1Hl8/KMr
=9XIo
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
