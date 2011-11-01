From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] conf_match(): Remove dead code
Date: Tue, 1 Nov 2011 13:33:31 +1100
Message-ID: <20111101133331.21d4ebae@notabene.brown>
References: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
	<1320069234-13112-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G7J4Ictu9TJ8CnUqyXP/0e8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069234-13112-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

--Sig_/G7J4Ictu9TJ8CnUqyXP/0e8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 14:53:52 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> devname is always NULL, hence if () statement will always fail.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  config.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
>=20
> diff --git a/config.c b/config.c
> index c0a6baa..b57ba50 100644
> --- a/config.c
> +++ b/config.c
> @@ -1023,7 +1023,6 @@ struct mddev_ident *conf_match(struct mdinfo *info,=
 struct supertype *st)
>  {
>  	struct mddev_ident *array_list, *match;
>  	int verbose =3D 0;
> -	char *devname =3D NULL;
>  	array_list =3D conf_get_ident(NULL);
>  	match =3D NULL;
>  	for (; array_list; array_list =3D array_list->next) {
> @@ -1044,14 +1043,6 @@ struct mddev_ident *conf_match(struct mdinfo *info=
, struct supertype *st)
>  					array_list->devname);
>  			continue;
>  		}
> -		if (array_list->devices && devname &&
> -		    !match_oneof(array_list->devices, devname)) {
> -			if (verbose >=3D 2 && array_list->devname)
> -				fprintf(stderr, Name
> -					": Not a listed device for %s.\n",
> -					array_list->devname);
> -			continue;
> -		}
>  		if (array_list->super_minor !=3D UnSet &&
>  		    array_list->super_minor !=3D info->array.md_minor) {
>  			if (verbose >=3D 2 && array_list->devname)


Hi Jes,
 thanks for these 3 patches.
 In each case I chose to remove different code :-)

 In this case search_mdstat was nearly identical to conf_match, but uses the
 bits you removed.  So I unified the two.

 For the 'Kill' fix, I removed a different test on 'force' so that the prin=
tf
 that you removed could not actually be reached.

Thanks,
NeilBrown


--Sig_/G7J4Ictu9TJ8CnUqyXP/0e8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq9aeznsnt1WYoG5AQJ7LQ/+MFnt+pYgvkgAxO7eQ1758IKxyWdlvMAP
HDzrnrMMT0dRODBSlvEpccc9Hn7Xx5OthU7Ei5l3Ql0hGHSW5rxi9hMx3naAr5JP
e/naPOlqM6HrgJGG275m18HjGtDB5W+7z/+klIN5GNzRJB/TGtslvOEHk1/4Vb00
DACptKf++VE+OgycMoKGnRNqS9EtNdt7yFzYoVt3bHs4nxETyIN3pmtLlVOEtY7v
VgUUPA8rCjP35Vfw6C4tGc22UOc6NK7hNGZ12kfCmx6y2hodhsWhYxZpf5MwVWiI
TK8V1D5uUWqN72wQRzws8prq3ZmRB0ZMGa/2htVdhJi+29JD8f+gmOzXAlJtwTbR
+DmtCnHFlEgr9XC8S++LBhipeqPai6OkDhmZB5ul786WUIvIu4fBnLeB8LfnPn69
hKRHPIyslr3PSGYO7xKBRPUcwFIPvbwNrSUzTJaQ2/VrkF0k1vIZxnMjDXb1nVC/
Oj1l/zw5yOT+TAeb03V3cK78/8KzSvKX5fm5uUmVHlzUzE2JXHg6B7ai6FMtgpJB
WekHVGZYHY5kChUf6BC7iiXirGwgTgEMQLcqYQMtYD0DfAlSGl5rjSg0JKJUFLvj
xn8PIS3jXFRoBY0SCp2BmINA7QQ1KR4SnM6ZPJ3h+68zUPh024XZcGvz/NV6QGn0
ZbAY7SdbgTk=
=hDnQ
-----END PGP SIGNATURE-----

--Sig_/G7J4Ictu9TJ8CnUqyXP/0e8--
