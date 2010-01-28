From: Andre Noll <maan@systemlinux.org>
Subject: Re: [mdadm PATCH] Move symbol definitions from source files to Makefile.
Date: Thu, 28 Jan 2010 18:02:59 +0100
Message-ID: <20100128170259.GU7517@skl-net.de>
References: <20100128154745.31726.15500.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eEYjL7b2m+/uQ8dh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100128154745.31726.15500.stgit@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids


--eEYjL7b2m+/uQ8dh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16:47, Artur Wojcik wrote:
> This patch will move _GNU_SOURCE and _FILE_OFFSET_BITS=3D64 from
> various source files to Makefile.

That's fine by me, but let's see what Neil has to say about this.

While cleaning up the #defines, we might want to get rid of a couple
of unused ones at the same time. BLKPG_ADD_PARTITION, START_MD,
REGISTER_DEV, MD_FEATURE_ALL, STDC, OF seem to be good candidates
for removal.

There are also quite some unused defines in super-ddf.c and
super-intel.c, presumably because these files contain code that was
copied from somewhere else. I'm not sure if it is worth to kill these
as well though.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--eEYjL7b2m+/uQ8dh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLYcNDWto1QDEAkw8RAjNyAJ9oIHxyBHceDsMCiH+8HAb8a/oj0QCfUZJM
4ENqRB4dDzLdNJRa9m68gEc=
=rc6e
-----END PGP SIGNATURE-----

--eEYjL7b2m+/uQ8dh--
