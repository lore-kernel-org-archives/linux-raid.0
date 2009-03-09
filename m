From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 3/3] md: 'array_size' sysfs attribute
Date: Mon, 9 Mar 2009 11:12:29 +0100
Message-ID: <20090309101229.GI17185@skl-net.de>
References: <20090306002341.9882.61625.stgit@dwillia2-linux.ch.intel.com> <20090306002458.9882.82188.stgit@dwillia2-linux.ch.intel.com> <20090306161559.GJ32416@skl-net.de> <1236407289.28806.9.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fVx4YFaxe8of50Zh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1236407289.28806.9.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>
List-Id: linux-raid.ids


--fVx4YFaxe8of50Zh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23:28, Dan Williams wrote:
> Subject: md: fixups to the userspace array size changes
>=20
> From: Dan Williams <dan.j.williams@intel.com>
>=20
> As identified by Andre Noll <maan@systemlinux.org>:
> 1/ No need to recalculate chunk shift in raid10_size
> 2/ Check for overflow in conversions from blocks to sectors
> 3/ Missing cast to sector_t in raid5_size
>=20
> Cc: Andre Noll <maan@systemlinux.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Yes, these fixes all look fine to me. Feel free to add

Reviewed-by: Andre Noll <maan@systemlinux.org>

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--fVx4YFaxe8of50Zh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD4DBQFJtOuNWto1QDEAkw8RAhErAJiYMeRk8CbWkn8k677qM7SCAGzvAJsGy6zA
BvAQIvPyc3hYPxacNwQw1w==
=/VdH
-----END PGP SIGNATURE-----

--fVx4YFaxe8of50Zh--
