From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 08/12] md: move compat_ioctl handling into md.c
Date: Mon, 16 Nov 2009 09:39:59 +0100
Message-ID: <20091116083959.GN5174@skl-net.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de> <1258331227-1694-9-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sKEQ01CzIzwqenDk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1258331227-1694-9-git-send-email-arnd@arndb.de>
Sender: linux-raid-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--sKEQ01CzIzwqenDk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 00:27, Arnd Bergmann wrote:
> The RAID ioctls are only implemented in md.c, so the
> handling for them should also be moved there from
> fs/compat_ioctl.c.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Andre Noll <maan@systemlinux.org>
> Cc: linux-raid@vger.kernel.org
> ---
>  drivers/md/md.c   |   23 +++++++++++++++++++++++
>  fs/compat_ioctl.c |   23 -----------------------
>  2 files changed, 23 insertions(+), 23 deletions(-)

Looks good to me.

Acked-by: Andre Noll <maan@systemlinux.org>

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--sKEQ01CzIzwqenDk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLAQ/fWto1QDEAkw8RAuL0AJ4ir4+rzAuas+GN7EfU6HkA+/zIbACcCEJD
IDwMva4sSBQMIGEo1VgFroQ=
=FNiY
-----END PGP SIGNATURE-----

--sKEQ01CzIzwqenDk--
