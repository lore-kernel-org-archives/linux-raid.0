From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: NAS Remote Side of a Mirror
Date: Thu, 8 Oct 2009 08:51:07 +0100
Message-ID: <20091008075106.GA17343@cthulhu.home.robinhill.me.uk>
References: <905067.19304.qm@web38806.mail.mud.yahoo.com>
 <130273.20896.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <130273.20896.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Oct 07, 2009 at 04:49:09PM -0700, adfas asd wrote:

> OK, say I wanted to build this remote NAS box myself, rather than
> spending $750 for a Qnap.
> (http://qnap.com/pro_detail_feature.asp?p_id=3D110)  I find a good case,
> power supply, micro mobo, and cage, and install Linux and NX (remote
> desktop) on it.
> =20
> I need to share those drives over GbE with minimal software
> intervention. I'm not about to use bloatware like NFS or Samba. And
> sshfs or an SSH tunnel could not keep up the speeds I'd need. How do
> you suppose Qnap shares those drives? And provides all those other
> services?
> =20
> So looking at Qnap's update, it comes down as a disk img file, which I
> can not mount in loopback. Probably encrypted, and knowing them in
> AES256.
>=20
> Anyone built a remote NAS box?  How to share those drives with minimal
> software intervention?
>=20
The lowest level approach would probably be to export it as iSCSI - I
don't know what overhead the software initiator has for that (or what a
hardware initiator would cost) though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrNmeoACgkQShxCyD40xBJZ/wCdEOijX0gdZEO+y8z8BeDpOT+S
5z8AoKnoBKjR2iZQZT/7gegG5gU8XAt2
=eGtQ
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
