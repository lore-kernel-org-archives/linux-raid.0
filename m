From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: using ioctl to set disk faulty instead of sysfs
Date: Mon, 04 Dec 2017 11:34:42 +1100
Message-ID: <87shcrtjod.fsf@notabene.neil.brown.name>
References: <33BB30F4-F2A1-437B-ABFE-6A03E9563F01@mails.ucas.ac.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <33BB30F4-F2A1-437B-ABFE-6A03E9563F01@mails.ucas.ac.cn>
Sender: linux-raid-owner@vger.kernel.org
To: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21 2017, wuzhouhui wrote:

> Hi, I have a suggest about mdadm to set disk faulty. Since commit 1ca69c4=
bc4b1ef
> (md: avoid taking the mutex on some ioctls) removes lock when set disk fa=
ulty,
> so we'd better using ioctl(SET_DISK_FAULTY) to set disk faulty, instead o=
f=20
> echo faulty > /sys/block/<md>/md/dev-<disk>/state, because caller of stat=
e's
> handler would lock mddev. Like following:
>
> Index: mdadm-4.0/Manage.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- mdadm-4.0.orig/Manage.c
> +++ mdadm-4.0/Manage.c
> @@ -1662,9 +1662,7 @@ int Manage_subdevs(char *devname, int fd
>=20=20
>  		case 'f': /* set faulty */
>  			/* FIXME check current member */
> -			if ((sysfd >=3D 0 && write(sysfd, "faulty", 6) !=3D 6) ||
> -			    (sysfd < 0 && ioctl(fd, SET_DISK_FAULTY,
> -						rdev))) {
> +			if (ioctl(fd, SET_DISK_FAULTY, rdev)) {
>  				if (errno =3D=3D EBUSY)
>  					busy =3D 1;
>  				pr_err("set device faulty failed for %s:  %s\n",
>

This isn't just a debatable optimization.  It is wrong and would
introduce a regression.
Please make sure you understand code *before* trying to change it.

Please look at the git history for this code and find the patch where
writing "faulty" was added as an alternative.  That might help you to
understand what is happening here.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlokmCQACgkQOeye3VZi
gbkTJxAAuqK+JvbXTLjTQlzOAtS2mLFNlLMd95p+PDG4cdwx4IjIw2oSjHgumLZL
9f3cgG1tbwxEGWA4tjJmZlzcixx9YeInz5/SmPQn6heT6yM2xY681bYq/XwfSi9Y
tJbuCFx4voX19X9B8950eudOShDk7nFlRZjoIqbg9c02w2vHOOTjKUzqDZBvPANQ
NC9cCnuxcUC+KjhFHV9gh/g5YQIg/HghSeuOo2L0nIy+kV8ERSGxXEGfNHipp//Z
8ShR40GFgQtjSJrnhb3wNyqNJWuMiV6dgRpReMfjmA/keQrNiTOnrnP3qEKknndS
9Br08z9+3ayCKUReI/Ei/2n02BD2HUSbMASC8TGb8ybaM3Fc/IgvP2U/RVycPLrX
ypL3F8gj9VzCcZZSxr5wVz85bHvR7VOh0hpYrAJS/qfzmiX+K8fBUrSNsRpAmeI3
UcIwAg3gqAkKfWqQStJYsL4QIdWDm8nfiR3OclAkeHdEasqinjDYlzilGLVaqgAH
ZRavoijB1Ir4bOXAha9hONnlQAOuku1kA+IMtjBJthQdPgoNprvtVf313jvR0bUq
VNYv0g+FebG4lub+WypUR9rynZUKlXiOA8S+CvXXSG3Yju0TcbNZ7NE7XLEUgzUB
QfiVUEZsSdX7WuxeoI90PbZ5k3M70V8BOWko9HszxhAXSUTGRFg=
=cGpx
-----END PGP SIGNATURE-----
--=-=-=--
