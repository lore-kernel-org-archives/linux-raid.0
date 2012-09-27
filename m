From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: autodetect being run in an initramfs
Date: Fri, 28 Sep 2012 08:35:18 +1000
Message-ID: <20120928083518.12d53ea8@notabene.brown>
References: <1348756863-21081-1-git-send-email-dreisner@archlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9oZV7sv2qEu08FxuiK5ZfGp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1348756863-21081-1-git-send-email-dreisner@archlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Reisner <dreisner@archlinux.org>
Cc: linux-raid@vger.kernel.org, teg@jklm.no
List-Id: linux-raid.ids

--Sig_/9oZV7sv2qEu08FxuiK5ZfGp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Sep 2012 10:41:03 -0400 Dave Reisner <dreisner@archlinux.org>
wrote:

> Key off of the existance of /etc/initrd-release as an indicator that
> mdadm is running in early userspace and set the __offroot flag. This
> allows the same udev-based assembly rules to be valid both off and on
> root and, moreover, will propagate to mdmon, should it need to be
> started.
>=20
> Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> ---
>  mdadm.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/mdadm.c b/mdadm.c
> index 4c7c5ea..557e00b 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1106,6 +1106,11 @@ int main(int argc, char *argv[])
>  		exit(0);
>  	}
> =20
> +	/* auto-detect being on an initramfs
> +	 * http://www.freedesktop.org/wiki/Software/systemd/InitrdInterface */
> +	if (access("/etc/initrd-release", F_OK) =3D=3D 0)
> +		__offroot =3D 1;
> +
>  	if (!mode && devs_found) {
>  		mode =3D MISC;
>  		devmode =3D 'Q';

What is the problem with adding the --offroot flag to every place in the
initrd that starts mdadm?

(Actually I'm contemplating making --offroot the default so this might beco=
me
a non-issue)

NeilBrown

--Sig_/9oZV7sv2qEu08FxuiK5ZfGp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGTUpjnsnt1WYoG5AQK3Wg//V3mrlUcNCPiARm4TePVW/+lsv/qoUgAU
t8R5TW8kyzNcd0O3h0C3OPwBpDyl9ad/eLtRo+d+hyrhOKth+d0gPE8LufcO4L+D
LMUKGwnlV9MGmY/X8C528i9F07i77dLhhuZCQD9x0GOXVkkCesHX827XQeeMZMUC
PMm+eO+acM6mRu+5DznajfzkwfmXJz5kTyqRCbxPYLCu+ErYg4syGYEMdkg03EbX
1WbshdZXm5i+Kkwcm7aD/fHslMJAR9l02L2a0m2fPHmzDotYZFDf0rHpOSl2Kwps
HGyr6ffXW3uwy97T2n6A/U4s+ml7XTX5Zkjetk2EVwUyF9okCEP5/EyASfn1gX3k
hcsyq3UUr8W2/s92i2YoA4xSE30NiBG49e3rm4YWs/KH4kl/N49/nuR8dM3KoFdW
nSrG7ihw4uNGQquJelrfPzpYfauFBeBktbleiKQy4oIOT9IoOI6PsLFdeXaey/g2
8NY7X7To5ahA9XwOKDMr6I4HRbsIjGhxJSlMGihZZPMa6V8anXMXEygG79gKvQcj
32Qv5nQwTk8o4vPiJ3k6Ic3NWdTGgUAmbml4nKNBMwXFvJBa+h/uZYlZ5uZ0UoHQ
xE+j7vE/Cmbr/dZ13a7CEmdzgYUdYFvcwiqWQElakiEiLVLdIhnvqf1iTpK4YMJK
oWliwT5NJ/A=
=Z3Dp
-----END PGP SIGNATURE-----

--Sig_/9oZV7sv2qEu08FxuiK5ZfGp--
