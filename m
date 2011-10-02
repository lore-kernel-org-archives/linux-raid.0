From: NeilBrown <neilb@suse.de>
Subject: Re: [mdadm PATCH] Fix small memory leak
Date: Mon, 3 Oct 2011 08:31:27 +1100
Message-ID: <20111003083127.039bc0fe@notabene.brown>
References: <4E88BF65.2010500@intra2net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/J8fyedvHsN7D2dhjWDGRl.s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E88BF65.2010500@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/J8fyedvHsN7D2dhjWDGRl.s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 02 Oct 2011 21:45:41 +0200 Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:

> Credit goes to cppcheck.
>=20
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  policy.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/policy.c b/policy.c
> index 2bbbac8..4a6ef82 100644
> --- a/policy.c
> +++ b/policy.c
> @@ -757,8 +757,10 @@ int policy_check_path(struct mdinfo *disk, struct ma=
p_ent *array)
> =20
>  	snprintf(path, PATH_MAX, FAILED_SLOTS_DIR "/%s", id_path);
>  	f =3D fopen(path, "r");
> -	if (!f)
> +	if (!f) {
> +		free(id_path);
>  		return 0;
> +	}
> =20
>  	rv =3D fscanf(f, " %s %x:%x:%x:%x\n",
>  		    array->metadata,
> @@ -767,6 +769,7 @@ int policy_check_path(struct mdinfo *disk, struct map=
_ent *array)
>  		    array->uuid+2,
>  		    array->uuid+3);
>  	fclose(f);
> +	free(id_path);
>  	return rv =3D=3D 5;
>  }
> =20


applied.  Thanks.

NeilBrown

--Sig_/J8fyedvHsN7D2dhjWDGRl.s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiNgvG5fc6gV+Wb0RAjKlAKCrUdwnh+B5gNKomblesz9c5XNt3gCfaD4t
5dweZ+sWis0HPWrPjMkFuzo=
=dNVl
-----END PGP SIGNATURE-----

--Sig_/J8fyedvHsN7D2dhjWDGRl.s--
