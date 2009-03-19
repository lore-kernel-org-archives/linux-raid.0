From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 02/13] async_tx: don't use src_list argument of async_xor() for dma addresses
Date: Thu, 19 Mar 2009 21:10:08 +0100
Message-ID: <20090319201008.GC10491@skl-net.de>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> <20090318192026.20375.3053.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090318192026.20375.3053.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:20, Dan Williams wrote:

> Using src_list argument of async_xor() as a storage for dma addresses
> implies sizeof(dma_addr_t) <=3D sizeof(struct page *) restriction which is
> not always true (e.g. ppc440spe).

This message does not tell what the patch is going to do about that.
It would also be nice to mention (either in the log message or as a
comment) why allocating the dma_src arrays on the stack is not going
to be a problem.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJwqagWto1QDEAkw8RAol7AJ9jG26hiovmH4WW54bhvV1PctW/LQCeOxo7
a4ILQjqS5mMDQoLby5qlPvs=
=mIQl
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--
