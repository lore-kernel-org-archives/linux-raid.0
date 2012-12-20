From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: how to proceed with possible corruption
Date: Thu, 20 Dec 2012 08:38:51 +0000
Message-ID: <20121220083851.GA18661@cthulhu.home.robinhill.me.uk>
References: <1355951195.12402.33.camel@corn.betterworld.us>
 <20121219223009.GA12347@cthulhu.home.robinhill.me.uk>
 <50D24AC6.2080105@biostat.ucsf.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50D24AC6.2080105@biostat.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 19, 2012 at 03:16:22PM -0800, Ross Boylan wrote:

> On 12/19/2012 2:30 PM, Robin Hill wrote:

> > Otherwise, the issue could be filesystem corruption. A "fsck -f" on the
> > array should detect that.
> I think that's my next step.  My understanding is that this guarantees=20
> the integrity of the file system, but not necessarily the integrity of=20
> the contents of individual files.  I'm on ext3.
>=20
To check the files themselves, you'll have to have some info on their
correct state. A lot of distributions will include this as part of the
packaging, so that should be your first port of call (e.g. rpm
--verify). I'm not aware of any other way to verify the file contents
without previously having read their correct state (there's various file
integrity checking tools, intended for security checks to prevent
surreptitious replacement of system files).

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDSzpsACgkQShxCyD40xBLAVACfZW6QQ4tAEFYl21dX5Jfe3iMy
Ac4AoOAhZNU5RxSCsF8amk59qoWRruYq
=jb0l
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
