From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: Allowed to assemble 2 volumes with the same names
 from config file.
Date: Mon, 7 Nov 2011 12:22:46 +1100
Message-ID: <20111107122246.6f50387b@notabene.brown>
References: <20111104085148.12168.60370.stgit@gklab-128-192.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eCIzStGUP1iLlS.2J9X7GXv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111104085148.12168.60370.stgit@gklab-128-192.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Orlowski <lukasz.orlowski@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/eCIzStGUP1iLlS.2J9X7GXv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 04 Nov 2011 09:51:48 +0100 Lukasz Orlowski
<lukasz.orlowski@intel.com> wrote:

> mdadm allowes to assemble 2 volumes with the same names based on the
> config file. The issue is fixed by iterating over the list of md device
> identifiers and comparing the names of md devices against each other,
> detecting identical names and blocking the assembly should the same names
> be found.
> Now having detected duplicate names, mdadm terminates without assembling
> the container, displaying appropriate prompt.
>=20
> Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>
> ---
>  config.c |   25 +++++++++++++++++++++++++
>  mdadm.c  |    7 +++++++
>  mdadm.h  |    1 +
>  3 files changed, 33 insertions(+), 0 deletions(-)
>=20
> diff --git a/config.c b/config.c
> index c0a6baa..9b337eb 100644
> --- a/config.c
> +++ b/config.c
> @@ -1088,3 +1088,28 @@ struct mddev_ident *conf_match(struct mdinfo *info=
, struct supertype *st)
>  	}
>  	return match;
>  }
> +
> +int conf_verify_devnames(struct mddev_ident *array_list)
> +{
> +	struct mddev_ident *a1, *a2;
> +
> +	for (a1 =3D array_list; a1; a1 =3D a1->next) {
> +		if (!a1->devname)
> +			continue;
> +		for (a2 =3D a1->next; a2; a2 =3D a2->next) {
> +			if (!a2->devname)
> +				continue;
> +			if (!strcmp(a1->devname, a2->devname)) {
> +				fprintf(stderr,
> +					Name ": Devices %x:%x:%x:%x and "
> +					"%x:%x:%x:%x have the same name: %s\n",
> +					a1->uuid[0], a1->uuid[1], a1->uuid[2],
> +					a1->uuid[3], a2->uuid[0], a2->uuid[1],
> +					a2->uuid[2], a2->uuid[3], a1->devname);
> +				return 1;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> diff --git a/mdadm.c b/mdadm.c
> index 56de7b7..ebf4c4d 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1282,6 +1282,13 @@ int main(int argc, char *argv[])
>  			struct map_ent *map =3D NULL;
>  			int cnt =3D 0;
>  			int failures, successes;
> +
> +			if (conf_verify_devnames(array_list)) {
> +				fprintf(stderr, Name
> +					": Duplicate MD device names in "
> +					"conf file were found.\n");
> +				exit(1);
> +			}
>  			if (devlist =3D=3D NULL) {
>  				fprintf(stderr, Name ": No devices listed in conf file were found.\n=
");
>  				exit(1);
> diff --git a/mdadm.h b/mdadm.h
> index 6dbc5ea..bff454f 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1145,6 +1145,7 @@ extern char *conf_get_homehost(int *require_homehos=
tp);
>  extern char *conf_line(FILE *file);
>  extern char *conf_word(FILE *file, int allow_key);
>  extern int conf_name_is_free(char *name);
> +extern int conf_verify_devnames(struct mddev_ident *array_list);
>  extern int devname_matches(char *name, char *match);
>  extern struct mddev_ident *conf_match(struct mdinfo *info, struct supert=
ype *st);
>  extern int experimental(void);
>=20

Thanks.
I've applied this patch, though with a few changes.

1/ I personally despise the "!strcmp()" usage.  It seems to be saying "not"
   but it is actually saying "is equal".  I always write
       strcmp(a,c) =3D=3D 0
   or !=3D or < or whatever comparison is wanted.
2/ You assume that both names have a uuid but that may not be correct.  You
   need to check 'uuid_set'.

Thanks,
NeilBrown


--Sig_/eCIzStGUP1iLlS.2J9X7GXv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrcy5jnsnt1WYoG5AQKlhA/8C7NXijpupTyFL0DLtx8tSUPiYGDWyc2j
kN8GYNTZQBadp3lT9IYqGwFyCWgn96mz3uHjDFU8xFzAjnIm2OUJ71+WPokH026f
BeoIpdj999TvOZVyxEnUcA4RwUcmziialKNnfQ8Qf0nW5EjFwWQWaiPhCBStlwmP
oItRMbhU8yor1B21MYKtMBoIH0b95xly5vJKV6rTSWAPxk+3k+NWY2FY/o1FKMZX
PqM/1DFhW1/gdQJxRRYLuKOQOuWlD1Day4uhzA1oGOjZ04Dixh39qe94Utl2jsL9
73rlLgM++3/gBVcWAxLShYCcju9qBtP3gx1HroqEYkkUGD6i8phz5qeq1aiXZIwz
g/C8XiV1tVIP2+TCGajcgcqYYO5eyWkTLvyJnsvQt4jBCDS+Qc9pTS4RMISqoV5y
oyhqHL48x3BgqKhGPnzj3IwZBPoopFyBeaTbmjyForTWv7LSH9bozW3tshCIyX1u
Dx9khsYHz1aqgu6SiPSANnldjiVvdHsgDDUR0UsmS3qg20GTfyAcDERMVZ7sqons
CD8g+8JGHPIf3kO++n24dif6450qavIXrSt2D9Zr7DU+fhGHmdX8JD8BSHTxXNvG
qp+M67Q5r2qkVcx0/RsEbf0a0xPRc721tmbjPTi/BqOHRcz0mq6FNxE0QAk44ZU0
k13dDcluzaI=
=yjIq
-----END PGP SIGNATURE-----

--Sig_/eCIzStGUP1iLlS.2J9X7GXv--
