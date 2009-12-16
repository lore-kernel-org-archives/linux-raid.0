From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: [SOLVED] RAID-10 array won't auto-assemble @ boot of a Xen
 Guest; Works just fine 'manually' ... Any ideas?
Date: Wed, 16 Dec 2009 16:20:13 +0000
Message-ID: <20091216162013.GC15689@cthulhu.home.robinhill.me.uk>
References: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com>
 <babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
 <20091216091615.GB15689@cthulhu.home.robinhill.me.uk>
 <babafd2f0912160810p34e43a6ao93dae8a576bfcb75@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0912160810p34e43a6ao93dae8a576bfcb75@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 16, 2009 at 08:10:01AM -0800, Ben DJ wrote:

> >> =A0 chkconfig -- list | grep -i boot
> >> =A0 =A0 list: unknown service
> >>
> > What about if you leave out the space between the dashes and the list
> > option?
>=20
> Still not there.
>=20
> > chkconfig --list | grep -i boot
> >
>=20
A check of the manual page shows that on openSUSE, the command would be:
    chkconfig --list --allservices | grep -i boot

Boot services are hidden by default, so you need the --allservices (or
-A) switch to show them.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkspCL0ACgkQShxCyD40xBKrbwCg4axVVktmI0uCSPQtAZ+WHYtu
5jwAn0hbkJBh0wwD3XXOByTs9WeyMS6g
=nuvr
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
