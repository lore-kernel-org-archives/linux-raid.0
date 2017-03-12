From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] mdadm:checking level once mode has been set
Date: Mon, 13 Mar 2017 09:54:49 +1100
Message-ID: <878toaf6me.fsf@notabene.neil.brown.name>
References: <20170308074831.24683-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308074831.24683-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08 2017, Zhilong Liu wrote:

> mdadm: it would be better to check --level ealier,
> because it would fall to different prompt if user
> forgets to specify the --level. such as:
> ./mdadm -CR /dev/md0 -b internal -n2 -x1 /dev/loop[0-2]

When I run that command I get:

  mdadm: a RAID level is needed to create an array.


What do you get?

NeilBrown


>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>
> diff --git a/Create.c b/Create.c
> index 9a951b0..beec29f 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -125,10 +125,6 @@ int Create(struct supertype *st, char *mddev,
>  	memset(&info, 0, sizeof(info));
>  	if (s->level =3D=3D UnSet && st && st->ss->default_geometry)
>  		st->ss->default_geometry(st, &s->level, NULL, NULL);
> -	if (s->level =3D=3D UnSet) {
> -		pr_err("a RAID level is needed to create an array.\n");
> -		return 1;
> -	}
>  	if (s->raiddisks < 4 && s->level =3D=3D 6) {
>  		pr_err("at least 4 raid-devices needed for level 6\n");
>  		return 1;
> diff --git a/mdadm.c b/mdadm.c
> index 19a06db..ad24bdf 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -350,6 +350,12 @@ int main(int argc, char *argv[])
>  				pr_err("Must give -a/--add for devices to add: %s\n", optarg);
>  				exit(2);
>  			}
> +			if (devs_found > 0 && s.level =3D=3D UnSet && !devmode) {
> +				if (mode =3D=3D CREATE || mode =3D=3D BUILD) {
> +					pr_err("a RAID level is needed to create or build an array.\n");
> +					exit(2);
> +				}
> +			}
>  			dv =3D xmalloc(sizeof(*dv));
>  			dv->devname =3D optarg;
>  			dv->disposition =3D devmode;
> --=20
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljF0bkACgkQOeye3VZi
gbnpaA/+PRvM8fgcvERPiQ5hieShkuFlG/wmPg3LVfVTlaaMQG4PZLX6W7jAo/Mn
g0wf7WrEgnr/YTMW4uofNc9jRPZkmD5WcFJzgBcS7dOPofHeN2UR9dOD8RubD1IX
apTp8rGdLkGgvGmVMTMhb0USVrIrGRhGos2jpo6zLTsMZMCPi4qRu7lA4I6WJstn
9L52JRiJbNWHKTp9Dm4+OldOnF6NGDAVh8/E9ORHKHkIuCpnM6sIABJVsejpFIpc
3CzLe+pwd682Oy877/wwHMRA1NjJv+9C6BCjQFk5bdl7CqRMIWnVgiWQ4R4UjZsk
iwMszyg+6o6gF40+XVaMHsLVD9nWIY1TlxH99PEeaPUa6lwYxsUinkZ6NZQsdltJ
3hefdQmS2fR7xTA1wkY4sZOK8MuIORC65QBh8k3lN/CDqQr3R9zA+mPtb4Es9Axh
a5LCLJrgxWQkfOw6SZOzI7yoYIfGNdqpogrn28rBA57oj7nFvZein642IPu5D83I
CYS94Y/VZCYKP98MRzA9Du9Xa8VJnpI/7PSnwMKnyeIOpHxB1KyLiiCJImBLBLQ1
/b96EOzBZI+4x/uFe8NM30+BONr8vPet7U+RuXjiZR6tpAfpPuL/SC0MriYF/57D
nXXulqs7LoNjIvYwB2be0+VivQjCIC2PVVb6AoxNwXBzUEQ811o=
=zUj5
-----END PGP SIGNATURE-----
--=-=-=--
