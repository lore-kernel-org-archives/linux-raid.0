From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: fix portability issues encountered while
 building against musl libc
Date: Sun, 10 Feb 2013 15:45:48 +1100
Message-ID: <20130210154548.0ad0c36d@notabene.brown>
References: <5116D8A7.6070409@barfooze.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/geHz/q35Fye=no++3oidWRm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5116D8A7.6070409@barfooze.de>
Sender: linux-raid-owner@vger.kernel.org
To: John Spencer <maillist-mdadm@barfooze.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/geHz/q35Fye=no++3oidWRm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Feb 2013 00:15:51 +0100 John Spencer <maillist-mdadm@barfooze.de>
wrote:

> >From 23114b8c77982717cc3ce3d437321c7fb0b1c918 Mon Sep 17 00:00:00 2001
> From: John Spencer <maillist-mdadm@barfooze.de>
> Date: Sat, 2 Feb 2013 17:26:45 +0100
> Subject: [PATCH 1/3] platform-intel: canonicalize_file_name() is not port=
able
>=20
> this is a GLIBC specific feature and should not be used.
>=20
> according to its manpage:
> "The call canonicalize_file_name(path) is equivalent
> to the call realpath(path, NULL)."
>=20
> thus, we use realpath so it works everywhere.
>=20
> Signed-off-by: John Spencer <maillist-mdadm@barfooze.de>
> ---
>  platform-intel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/platform-intel.c b/platform-intel.c
> index 0dcf07c..d8d4942 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -116,7 +116,7 @@ struct sys_dev *find_driver_devices(const char *bus, =
const char *driver)
> =20
>  		list->dev_id =3D (__u16) dev_id;
>  		list->type =3D type;
> -		list->path =3D canonicalize_file_name(path);
> +		list->path =3D realpath(path, NULL);
>  		list->next =3D NULL;
>  		if ((list->pci_id =3D strrchr(list->path, '/')) !=3D NULL)
>  			list->pci_id++;
> @@ -459,7 +459,7 @@ char *devt_to_devpath(dev_t dev)
>  	char device[46];
> =20
>  	sprintf(device, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
> -	return canonicalize_file_name(device);
> +	return realpath(device, NULL);
>  }
> =20
>  char *diskfd_to_devpath(int fd)


Hi,
 I've applied this one and the GCC #ifdef - thanks.

 I haven't applied the last one, but not because I don't appreciate being
 called insane :-)

 I like having -Werror as it encourages people to report any warnings they
 get, and it keeps me "honest".
 If it is a problem for you, you can easily
   make CWFLAGS=3D

 or set the C Warning FLAGS to whatever you like - they are deliberately ke=
pt
 separate from other CFLAGS.

Thanks,
NeilBrown

--Sig_/geHz/q35Fye=no++3oidWRm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURcl/Dnsnt1WYoG5AQKKEg/+N46G9ygurJwgmTzItFVbOrp7F1NtH5Cx
c29VfAdHUhypbMRIGEYEJdbRSHuoGJEqkCwvBzC4J+vz7m7oZwfO/OZ3Ahkhgduo
u+wwK+edKFIpevDeZLNu8yOv5JJQGgni2CNye6apSESePzLmAsDhuzrw+OQ0g0+R
rfqzsgUxyQTDCmAzC/weXnDmfJcdYqQ7hCYScjijnOX07pg+TsuL761YfeKh7xeI
z/ryW2Smx1DjRMAgC8OetcgUa0w5Ig/GfeuEYgSCOVqwsQlbGHHzCLirDoPORTZ+
wwWEBDMNnFwL5UWyVgF4nLf24U8qk4jXXhZiBCGXxHFbiM+9yBOCv0FSVbxjgkI8
+BrtHwg/QKopGdTOd6zasMbeS08G3pqRipoWGc3CMM1Ezfx4YCKJg4eCFyGm7LPL
wL7oL2kBqHV7yDcy8ulsbzjq3Nlk7it46frmz6qAIxb8PxVfonAIy4nBLE8XKhX0
aIsNNn96g2J2Qm5qmSgwz1jw+UAqBCyeMHYaSX+PbGVM0P4YAUg5XCaF/pPdzREM
08oM/C3HlOwHoBEpob4ePXYpyy5YVyxZ8WYqT5NT64EYYHBfZcqSq54aZgtlh8Y+
g7Tt7XatRIxcFEXJztOlxGw17rLUBkKfF/aI9G7yDM4OU1NQHdXkk8hH7QIvv2KE
EutDk9x9NeA=
=Uvjv
-----END PGP SIGNATURE-----

--Sig_/geHz/q35Fye=no++3oidWRm--
