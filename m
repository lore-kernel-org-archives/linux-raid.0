From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Bitmap version cleanup.
Date: Tue, 10 Apr 2012 16:14:55 +1000
Message-ID: <20120410161455.49acaeea@notabene.brown>
References: <1326614986-30166-1-git-send-email-andrey.warkentin@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QBUc4wtiAEPxsfv_P1P++yY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326614986-30166-1-git-send-email-andrey.warkentin@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Warkentin <andrey.warkentin@gmail.com>
Cc: linux-raid@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

--Sig_/QBUc4wtiAEPxsfv_P1P++yY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 15 Jan 2012 03:09:46 -0500 Andrei Warkentin
<andrey.warkentin@gmail.com> wrote:

> bitmap_new_disk_sb() would still create V3 bitmap superblock
> with host-endian layout.
>=20
> Perhaps I'm confused, but shouldn't bitmap_new_disk_sb() be
> creating a V4 bitmap superblock instead, that is portable,
> as per comment in bitmap.h? BITMAP_MINOR was also unused.
>=20
> Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
> ---
>  drivers/md/bitmap.c |    3 ---
>  drivers/md/bitmap.h |    2 --
>  2 files changed, 0 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 045e086..e786da6 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -568,9 +568,6 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
>  	bitmap->events_cleared =3D bitmap->mddev->events;
>  	sb->events_cleared =3D cpu_to_le64(bitmap->mddev->events);
> =20
> -	bitmap->flags |=3D BITMAP_HOSTENDIAN;
> -	sb->version =3D cpu_to_le32(BITMAP_MAJOR_HOSTENDIAN);
> -
>  	kunmap_atomic(sb);
> =20
>  	return 0;
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index a15436d..af588ac 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -13,8 +13,6 @@
>  #define BITMAP_MAJOR_HI 4
>  #define	BITMAP_MAJOR_HOSTENDIAN 3
> =20
> -#define BITMAP_MINOR 39
> -
>  /*
>   * in-memory bitmap:
>   *

Yes, you are exactly correct.  I've applied that patch (and less than three
months since you sent it - not bad [no, not bad: terrible!])

Thanks,
NeilBrown

--Sig_/QBUc4wtiAEPxsfv_P1P++yY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4PP3znsnt1WYoG5AQJmLw/+J/yz0XvcNep+llkD619dwjlmx5N7dxdg
MpLDwnsIegh64bPKVTYUaY7dhgt/ADFg8YeUWmwzBV8EjjN/9ej9wVY4hBDr7BVR
Dc8tj+HhKrdL/6qUWbfNBX1hzIwTtnaD1/wtDrafuqaS/VpGXCVR7c7kgx6Q+x5X
MwKNGCX6WEQQ3OtPq+GDKXVXrDqWLiwCwYsCMjvrl80GsYVv1u1g05NH1rKDn/DY
fYhCwxTc+jrNnZ/P/jxSEXz957eAbq0HCzyOv+glG4GCIVpThCJSL/I77c9i9gYN
tmQNXZa5YC1OcVHKrlwaZTtJbIBc8OegjM1z4ZZ3NuHmwy2Ifaxs+9JVjCgbZ/5l
mjYGMwmkgFprn9fs2gJt6EItItzDQve22wq5NB/W3Cec0sWANpYjIbq5jrlV6gPT
tqWO80wNThCGWMAIZyax29tqqbdXrIfbXWgqdW17QFViphns+15ETd6AsJwNvVKA
J0pIxKCQjRi8rZ5MW7vdVWlvV6a0tS4NCPLb2iUWKL1Nydqpx8KM4gwp6SshOgzH
bOgduA3oxQ0XwJqfixypnZUzXNCcJ/B+ABm/vtbvI1sgtFBz19juX0fxStSkabC3
FfG+yuKL2WGmCys5CgGSvOODKkpj7nQZGK2GOOAmVZbGzMS5cghYfq/lEeV62N57
UgEelN+0+p8=
=CA75
-----END PGP SIGNATURE-----

--Sig_/QBUc4wtiAEPxsfv_P1P++yY--
