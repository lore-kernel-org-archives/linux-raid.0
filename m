From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: integrity verification on raid-5?
Date: Sat, 18 Dec 2010 15:30:35 +0500
Message-ID: <20101218153035.5c134e06@natsu>
References: <4D0BD140.6040205@feystorm.net>
	<20101217212436.GA11425@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pMLEs1w7BTWjCNgF7lQbmVR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101217212436.GA11425@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/pMLEs1w7BTWjCNgF7lQbmVR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Dec 2010 21:24:37 +0000
Robin Hill <robin@robinhill.me.uk> wrote:
=20
> Currently, there's no easy way to find out what file(s) are affected by
> the mismatches though.

That's why it is also a good idea to keep around file-level checksums in ea=
ch
directory (especially if you store a lot of files which shouldn't ever chan=
ge,
like audio or video collections), using CFV - http://cfv.sourceforge.net/

--=20
With respect,
Roman

--Sig_/pMLEs1w7BTWjCNgF7lQbmVR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0MjUsACgkQTLKSvz+PZwiMXQCffzCgI+sLLYE9pNTFazM5j4nH
hSsAoIZ9ceDcY1gQRt4RKQcPMpuaJeq1
=KAAI
-----END PGP SIGNATURE-----

--Sig_/pMLEs1w7BTWjCNgF7lQbmVR--
