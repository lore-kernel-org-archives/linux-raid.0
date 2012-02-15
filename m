From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Wed, 15 Feb 2012 08:30:58 +0000
Message-ID: <20120215083058.GA8821@cthulhu.home.robinhill.me.uk>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
 <4F35E925.6000003@hardwarefreak.com>
 <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
 <4F38FD5D.1010201@hardwarefreak.com>
 <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
 <20120213230228.GA5822@www5.open-std.org>
 <4F39D9B2.3050305@hardwarefreak.com>
 <20120214113832.GA6157@www5.open-std.org>
 <4F3AEDEF.2000608@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3AEDEF.2000608@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Feb 14, 2012 at 05:27:43PM -0600, Stan Hoeppner wrote:

> Maybe I simply don't understand this 'magic' of the f2 and far layouts.
>  If you only read the "faster half" of a spindle, does this mean writes
> go to the slower half?  If that's the case, how can you read data that's
> never been written?
>=20
Writes go to both halves, as normal for a mirrored setup, which is why
its write performance is lower than that of a near layout array (more
head movement required). Reads will (normally) come from the faster
(outer) half of the disk though, so read performance is better. In most
cases workloads are read-heavy, so this comes out as a significant gain.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk87bUEACgkQShxCyD40xBJzNgCggl/nTPbV/U7WM0HqPA9VM1oT
UQkAnjLjC/PcoDw/AaO8fQvaoHXn65ra
=Bw05
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
