From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm: hot remove failed for /dev/sdg: Device or resource busy
Date: Fri, 8 Feb 2013 19:59:35 +0000
Message-ID: <20130208195935.GA1575@cthulhu.home.robinhill.me.uk>
References: <eqndu9x4h8.ln2@goaway.wombat.san-francisco.ca.us>
 <csvfu9xsdm.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <csvfu9xsdm.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Feb 08, 2013 at 11:22:20 -0800, Keith Keller wrote:

> Hi again everyone,
>=20
> On 2013-02-07, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
> >
> > # mdadm /dev/md127  --remove /dev/sdg
> > mdadm: hot remove failed for /dev/sdg: Device or resource busy
>=20
> In poking around a little bit more, I have noticed something strange
> about sdg.  While the controller does not think that the device exists,
> it seems like udev still does (see below).  Could this be the root of
> the problem, and if so, what would be the canonical way of cleaning up
> after the device failure?  I realize that this may be a udev issue, not
> md, so feel free to point me elsewhere if that's the case.  (I stumbled
> across this when I tried to do mdadm --remove detached; when it failed,
> I wondered whether sdg had not been completely and cleanly detached.)
>=20
> I do feel like it would be handy to be able to tell mdadm that the
> device is really gone, and remove it even if it still seems available.
> From my reading of man mdadm --remove does not accept the --force
> switch; would it make sense to apply it to a scenario like this?
>=20
"mdadm --remove failed" would probably be best. There's also
"mdadm --remove missing" which is the other option in these
circumstances.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEVWSYACgkQShxCyD40xBL3CQCgoXICRGzQSY7vb3bqZyG+tsMy
MNIAoJvBcuCyICeKXR3yqO7sMjSJqm6l
=md4L
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
