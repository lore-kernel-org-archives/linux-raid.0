From: "Orlowski, Lukasz" <lukasz.orlowski@intel.com>
Subject: RE: [PATCH] fix: Allowed to assemble 2 volumes with the same names
 from config file.
Date: Mon, 7 Nov 2011 08:34:16 +0000
Message-ID: <2AC2FDB9F3686F48962B2B65E2040CCC3D2C6FFE@irsmsx503.ger.corp.intel.com>
References: <20111104085148.12168.60370.stgit@gklab-128-192.igk.intel.com>
 <20111107122246.6f50387b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111107122246.6f50387b@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Thanks for the feedback. I'll keep this in mind, while producing my nex=
t patches.

Pozdrawiam / Regards,
=A3ukasz Or=B3owski

-----Original Message-----
=46rom: NeilBrown [mailto:neilb@suse.de]=20
Sent: Monday, November 07, 2011 2:23 AM
To: Orlowski, Lukasz
Cc: linux-raid@vger.kernel.org; Williams, Dan J
Subject: Re: [PATCH] fix: Allowed to assemble 2 volumes with the same n=
ames from config file.

On Fri, 04 Nov 2011 09:51:48 +0100 Lukasz Orlowski <lukasz.orlowski@int=
el.com> wrote:

> mdadm allowes to assemble 2 volumes with the same names based on the=20
> config file. The issue is fixed by iterating over the list of md=20
> device identifiers and comparing the names of md devices against each=
=20
> other, detecting identical names and blocking the assembly should the=
=20
> same names be found.
> Now having detected duplicate names, mdadm terminates without=20
> assembling the container, displaying appropriate prompt.
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
> @@ -1088,3 +1088,28 @@ struct mddev_ident *conf_match(struct mdinfo *=
info, struct supertype *st)
>  	}
>  	return match;
>  }
> +
> +int conf_verify_devnames(struct mddev_ident *array_list) {
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
>  				fprintf(stderr, Name ": No devices listed in conf file were foun=
d.\n");
>  				exit(1);
> diff --git a/mdadm.h b/mdadm.h
> index 6dbc5ea..bff454f 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1145,6 +1145,7 @@ extern char *conf_get_homehost(int=20
> *require_homehostp);  extern char *conf_line(FILE *file);  extern cha=
r=20
> *conf_word(FILE *file, int allow_key);  extern int=20
> conf_name_is_free(char *name);
> +extern int conf_verify_devnames(struct mddev_ident *array_list);
>  extern int devname_matches(char *name, char *match);  extern struct=20
> mddev_ident *conf_match(struct mdinfo *info, struct supertype *st); =20
> extern int experimental(void);
>=20

Thanks.
I've applied this patch, though with a few changes.

1/ I personally despise the "!strcmp()" usage.  It seems to be saying "=
not"
   but it is actually saying "is equal".  I always write
       strcmp(a,c) =3D=3D 0
   or !=3D or < or whatever comparison is wanted.
2/ You assume that both names have a uuid but that may not be correct. =
 You
   need to check 'uuid_set'.

Thanks,
NeilBrown

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku,=20
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
