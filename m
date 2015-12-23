From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Grow: close file descriptor earlier to avoid "still in use" when stopping
Date: Thu, 24 Dec 2015 10:00:14 +1100
Message-ID: <877fk422kh.fsf@notabene.neil.brown.name>
References: <1450871831-25452-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450871831-25452-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Pawel Baldysiak <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 23 2015, Artur Paszkiewicz wrote:

> Close fd2 as soon as it is no longer needed, before calling
> Grow_continue(). Otherwise, we won't be able to stop an array with
> external metadata during reshape, because mdadm running in background
> will be keeping it open.
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Grow.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/Grow.c b/Grow.c
> index 80d7b22..f65b36a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -4873,6 +4873,9 @@ int Grow_continue_command(char *devname, int fd,
>=20=20
>  		sysfs_init(content, fd2, mdstat->devnm);
>=20=20
> +		close(fd2);
> +		fd2 =3D -1;
> +
>  		/* start mdmon in case it is not running
>  		 */
>  		if (!mdmon_running(container))

applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeyd+AAoJEDnsnt1WYoG5LSoP/3MwTwzViyuOIYcOwmUQ+lyl
PFp366CJZCfB9pIdw3iyQ5BTbyUr//M0FJVSXLlnIlFeiKOyt483k9XqYGyDhzYI
9cfKKIN9Oq1qapIE+mH1PhpL6LwWskWlEthBrCpJ+ud/qiUehLs6wMs0cYXlJ5Ym
QpVyN30CZmWgM3wMPN3YDNMCmmv6cUwt9hWJSD18xK07vvpMlgQEWoBviz+Kkulw
SZ0AXKAdfAqk7HcgV06855CVWRdEDsopPZcmXV65gwa7547GQbSCt2yH/ALwBi/2
7FhZyozWwbGNGGk2MJM4Si2VuviJQTB8wvQ8XztCnS7NaLOKnTqbUsjz6ym4Tb3H
kBcrPbJBJ+wUtfmx2IKgOS1LnVEfmNIJcsYICIOBt2aUJRyRzAsQlcFW7NziNWFl
d44JWFkgKdb1ztWi76ox95y10jm5TL56NeEvof3HZ3BtKgMNFgfNU/oj6bbEGknF
WWZKATF8pkiR4z958fyXA3cd9PVv3pjZEQVsYgUggbzT43nL+g/ryfhQjtnJTIbB
r9fhhmfK+Lx7ijR1nCViteU71DR4o/kXo0pPnJZdp4yBNzrxmq5x/L5WX0vi0Ncb
EMpsUbxdaFbPBUS28ib0YCi2xXzp3nnuXrkwWw+ju7WenbX39iW8Cx6IkOT7x4jA
GJ0Lx3qQrTRAoZbpi2A8
=drUx
-----END PGP SIGNATURE-----
--=-=-=--
