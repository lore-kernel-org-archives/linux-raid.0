From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 01/13] md/raid6: move raid6 data processing to raid6_pq.ko
Date: Thu, 19 Mar 2009 21:09:31 +0100
Message-ID: <20090319200931.GA10491@skl-net.de>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> <20090318192021.20375.69678.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090318192021.20375.69678.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:20, Dan Williams wrote:
> Move the raid6 data processing routines into a standalone module
> (raid6_pq) to prepare them to be called from async_tx wrappers and other
> non-md drivers/modules.  This precludes a circular dependency of raid456
> needing the async modules for data processing while those modules in
> turn depend on raid456 for the base level synchronous raid6 routines.
>=20
> To support this move:
> 1/ The exportable definitions in raid6.h move to include/linux/raid/pq.h

As raid*.h and md.h have been moved to drivers/md recently, pq.h
should probably live there as well.

> +#define time_before(x, y) ((x) < (y))

This macro seems to have no users (and a strange name).

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJwqZ7Wto1QDEAkw8RAodBAKCGOKkDyTMqlUcEUhvfRHnLYCBXyQCdHLrZ
DUhZ+29OjnEmy/ggnTSfvwg=
=jSUM
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
