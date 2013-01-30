From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH] Make --update=homehost work again.
Date: Wed, 30 Jan 2013 11:46:06 +0100
Message-ID: <1359542766.5755.46.camel@mattotaupa>
References: <1359512808-14297-1-git-send-email-jmaggard10@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7pY2rImS9Mzm5ew4hn9F"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1359512808-14297-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-7pY2rImS9Mzm5ew4hn9F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Justin,


thank you for your patch.


Am Dienstag, den 29.01.2013, 18:26 -0800 schrieb Justin Maggard:
> Commit 1e2b276535cea41c348292a019bdda8a58cb1679

Please not only add the hash, but also the summary, so people not having
the Linus=E2=80=99 master checked out know what the original commit was abo=
ut.
Also CC the original commit author so s/he can comment.

> broke homehost updating
> functionality because it depended on each string comparison being done
> even after we already found a match.  Fix this by using a goto instead.
>=20
> ---
>  super0.c |    3 ++-
>  super1.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/super0.c b/super0.c
> index ecb6b38..f15f1e0 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -554,10 +554,11 @@ static int update_super0(struct supertype *st, stru=
ct mdinfo *info,
>  	} else if (strcmp(update, "homehost") =3D=3D 0 &&
>  		   homehost) {
>  		uuid_set =3D 0;
> -		update =3D "uuid";
>  		info->uuid[0] =3D sb->set_uuid0;
>  		info->uuid[1] =3D sb->set_uuid1;
> +		goto update_uuid;
>  	} else if (strcmp(update, "uuid") =3D=3D 0) {

Would changing this from =C2=BBelse if =E2=80=A6=C2=AB to only =C2=BBif=C2=
=AB also solve this and
make it subjectively more clear?

> + update_uuid:
>  		if (!uuid_set && homehost) {
>  			char buf[20];
>  			char *hash =3D sha1_buffer(homehost,
> diff --git a/super1.c b/super1.c
> index 5bb1f01..fc31948 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -987,14 +987,15 @@ static int update_super1(struct supertype *st, stru=
ct mdinfo *info,
>  	} else if (strcmp(update, "homehost") =3D=3D 0 &&
>  		   homehost) {
>  		char *c;
> -		update =3D "name";
>  		c =3D strchr(sb->set_name, ':');
>  		if (c)
>  			strncpy(info->name, c+1, 31 - (c-sb->set_name));
>  		else
>  			strncpy(info->name, sb->set_name, 32);
>  		info->name[32] =3D 0;
> +		goto update_name;
>  	} else if (strcmp(update, "name") =3D=3D 0) {
> + update_name:
>  		if (info->name[0] =3D=3D 0)
>  			sprintf(info->name, "%d", info->array.md_minor);
>  		memset(sb->set_name, 0, sizeof(sb->set_name));


Thanks,

Paul

--=-7pY2rImS9Mzm5ew4hn9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlEI+e4ACgkQPX1aK2wOHVgnAgCfaAfeuaP5UDgX3I7IavhlMt4g
tU4AnjhBIRVWzDJadlOuIcMGoMt7jLm3
=5aYp
-----END PGP SIGNATURE-----

--=-7pY2rImS9Mzm5ew4hn9F--

