From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: correct checking volume's degradation
Date: Tue, 29 May 2012 09:35:58 +1000
Message-ID: <20120529093558.571e8d95@notabene.brown>
References: <20120525130641.31750.43414.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NXgFyMKYKB_+gaeGPI0Na6L"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120525130641.31750.43414.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/NXgFyMKYKB_+gaeGPI0Na6L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 May 2012 15:06:41 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> We do not check the return value of sysfs_get_ll() now. It is wrong.
> If reading of the sysfs "degraded" key does not succeed,
> the "new_degraded" variable will not be initiated
> and accidentally it can have the value of "degraded" variable.
> In that case the change of degradation will not be checked.
>=20
> It happens if mdadm is compiled with gcc's "-fstack-protector" option
> when one tries to stop a volume under reshape (e.g. OLCE).
> Reshape seems to be finished then (metadata is in normal/clean state)
> but it is not finished, it is broken and data are corrupted.
>=20
> Now we always check the return value of sysfs_get_ll().
> Even if reading of the sysfs "degraded" key does not succeed
> (rv =3D=3D -1) the change of degradation will be checked.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 6c87e20..07ab9ae 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -10370,8 +10370,10 @@ int check_degradation_change(struct mdinfo *info,
>  			     int degraded)
>  {
>  	unsigned long long new_degraded;
> -	sysfs_get_ll(info, NULL, "degraded", &new_degraded);
> -	if (new_degraded !=3D (unsigned long long)degraded) {
> +	int rv;
> +
> +	rv =3D sysfs_get_ll(info, NULL, "degraded", &new_degraded);
> +	if ((rv =3D=3D -1) || (new_degraded !=3D (unsigned long long)degraded))=
 {
>  		/* check each device to ensure it is still working */
>  		struct mdinfo *sd;
>  		new_degraded =3D 0;


applied, thanks.

NeilBrown


--Sig_/NXgFyMKYKB_+gaeGPI0Na6L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8QL3jnsnt1WYoG5AQL7gQ//Y7Ic26KY+pQ70vKd53GaZdhzUI4FkMk6
MG38gbBWZSQDcmHBe5/BfEZX4piy3tzTCEoaZbN12O9RDSl3j8W5E2LjlScyd9Wx
N5mAzxsiXKonu/O39HNQd4TlWZxwnykSnj+RS15bMNz9WV1Uu7RdaLdZ9mtcL5An
mb1vrPavsTBhyhyk/b4lUF+syHf1a0iHuKE6im1kR00A3msI4Vq9jL6/fkEy+VTx
sfXyC2gOawMA7Ar9PzZOSdNwEEJI4G+QPW5E60E9gzVj9VDvpM+IsqVRxLTY/s8n
Pzgvw10F34/Ddc8fvjR13SsG2vz4d70jnCYtgL0nR8Za+5HednGmp/sNLDEXF/3h
E1ZxQXmYvqUGOFd7qmq3gHA4dM9i2lwSQ7hhr/tZaW/ajjyh1ntbiqI4hMIby5/h
XkkkedwetotzSjfBcjEL33KoyA5vOLbFClSHVun+vXK8y1SwAsdQUPW34/WE5f/F
YEjb2LU/jFSHPteO2odT6/kAS/1d9Of9VlYq6H3MlwQ9WHRxpYIwDOcVwjk+XYmI
zm8xK+wmu8zN7eVHVhKjIE4saPZznx827/LVKc6xUgLQqzhN2bDuP9rDrphWx2LE
BKC2Ld+caKYLIEMhgKOuPuDw5fLVIoa8q91NVy+XauPGWOdiJmqrdeXutxZM8LVN
nMJpf2OCQzo=
=WoPw
-----END PGP SIGNATURE-----

--Sig_/NXgFyMKYKB_+gaeGPI0Na6L--
