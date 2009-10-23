From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: md software raid
Date: Fri, 23 Oct 2009 10:38:20 +0100
Message-ID: <20091023093820.GA7613@cthulhu.home.robinhill.me.uk>
References: <26023091.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <26023091.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Oct 23, 2009 at 02:11:09AM -0700, ian.d wrote:

>=20
> hello
>=20
> As a newbie to Linux kernel etc.
>=20
> How do you tell which version of md software raid is included in a specif=
ic
> kernel version?
> Is there a command to run which will return this info?
> Is it possible to install different versions of md in different kernels?
>=20
There's two separate components to Linux software RAID - the md code in
the kernel, and the mdadm application which interfaces with it.  I very
much doubt the kernel code is versioned at all, other than by the kernel
version (or GIT version).  The mdadm application is versioned, and you
can get the installed version by running 'mdadm -V'.

Some of the mdadm functionality will only work with newer kernel
versions, but you should be able to run any version with any kernel
(within reason anyway) and make use of the core functionality.  There
may be some exceptions here, but they should be detailed in the release
notes for specific versions.

As for changing the md version in the kernel - it may be possible, but
generally there's a lot of work involved in back/forward porting code
between kernel versions (because of changes to core structures, etc).

Is there any particular reason you're asking this (e.g. needing to use
some of the latest functionality with an older kernel)?  You may get
a more definitive answer if you have a specific case.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrheYwACgkQShxCyD40xBKXzQCguc4MePpikOFIu5SHcuGCAPea
EhcAnjIZqtV12Lb2sM/sJJiQ3vAD8ygr
=IwcQ
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
