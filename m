From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 20:50:06 +0100
Message-ID: <20090410195006.GA21242@cthulhu.home.robinhill.me.uk>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <20090410132233.GA15442@cthulhu.home.robinhill.me.uk> <008001c9ba12$3ac92c10$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <008001c9ba12$3ac92c10$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 10, 2009 at 12:22:44PM -0700, Timothy D. Lenz wrote:

> How can cp not work? every guide I found used ether cp or rsync. Even
> guides on seting up an auto backup system use cp or rsync.
> Seems the only files/folders that shouldn't get copied are the block
> device ones that are created at boot and are not really on the drive.
>=20
They'll all get copied, but you won't necessarily get the correct
contents.  Because the system is in use:
 - files will be being written, so you'll either get a partial copy, or
   an old version.
 - files may be locked, so you won't be able to copy them.

Doing a backup of a running system using cp/rsync will work fine for a
lot of things (especially for config files, documents, etc) but will
almost certainly fail miserably for some (databases for example).

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknfouwACgkQShxCyD40xBKnVwCfdbAZgQaDXJydTsSHoorJNY2J
KVUAn3woxt4BVRBgSkB4wj9axRc/GIBq
=YbwW
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
