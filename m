From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 08/12] FIX: use md position to reshape restart
Date: Thu, 9 Feb 2012 12:36:25 +1100
Message-ID: <20120209123625.13dd5ae4@notabene.brown>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
	<20120207140359.20627.10861.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vAebD=WrEF91bG.K08LWX9c"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207140359.20627.10861.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

--Sig_/vAebD=WrEF91bG.K08LWX9c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Feb 2012 15:03:59 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When reshape is broken, it can occur that metadata is not saved properly.
> This can cause that reshape process is farther in md than metadata states.
>=20
> On reshape restart use md position as start position, if it is farther th=
an
> position specified in metadata. Opposite situation treat as error.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   86 +++++++++++++++++++++++++++++++++++++++++++++-------------=
------
>  1 files changed, 60 insertions(+), 26 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 70bdee1..0668a16 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1862,6 +1862,55 @@ release:
>  	return rv;
>  }
> =20
> +/* verify_reshape_position()
> + *	Function checks if reshape position in metadata is not farther
> + *	than position in md.
> + * Return value:
> + *	 0 : not valid sysfs entry
> + *		it can be caused by not started reshape, it should be started
> + *		by reshape array or raid0 array is before takeover
> + *	-1 :	error, reshape position is obviously wrong
> + *	 1 :	success, reshape progress correct or updated
> +*/
> +static int verify_reshape_position(struct mdinfo *info, int level)
> +{
> +	int ret_val =3D 0;
> +	char buf[40];
> +
> +	/* read sync_max, failure can mean raid0 array */
> +	if (sysfs_get_str(info, NULL, "sync_max", buf, 40) > 0) {
> +		char *ep;
> +		unsigned long long position =3D strtoull(buf, &ep, 0);
> +
> +		dprintf(Name": Read sync_max sysfs entry is: %s\n", buf);
> +		if (!(ep =3D=3D buf || (*ep !=3D 0 && *ep !=3D '\n' && *ep !=3D ' ')))=
 {
> +			position *=3D get_data_disks(level,
> +						   info->new_layout,
> +						   info->array.raid_disks);
> +			if (info->reshape_progress < position) {
> +				dprintf("Corrected reshape progress (%llu) to "
> +					"md position (%llu)\n",
> +					info->reshape_progress, position);
> +				info->reshape_progress =3D position;
> +				ret_val =3D 1;
> +			} else if (info->reshape_progress > position) {
> +				fprintf(stderr, Name ": Fatal error: array "
> +					"reshape was not properly frozen "
> +					"(expected reshape position is %llu, "
> +					"but reshape progress is %llu.\n",
> +					position, info->reshape_progress);
> +				ret_val =3D -1;
> +			} else {
> +				dprintf("Reshape position in md and metadata "
> +					"are the same;");
> +				ret_val =3D 1;
> +			}
> +		}
> +	}
> +
> +	return ret_val;
> +}
> +
>  static int reshape_array(char *container, int fd, char *devname,
>  			 struct supertype *st, struct mdinfo *info,
>  			 int force, struct mddev_dev *devlist,
> @@ -2251,9 +2300,16 @@ started:
> =20
>  	sra->new_chunk =3D info->new_chunk;
> =20
> -	if (restart)
> +	if (restart) {
> +		/* for external metadata checkpoint saved by mdmon can be lost
> +		 * or missed /due to e.g. crash/. Check if md is not during
> +		 * restart farther than metadata points to.
> +		 * If so, this means metadata information is obsolete.
> +		 */
> +		if (st->ss->external)
> +			verify_reshape_position(info, reshape.level);
>  		sra->reshape_progress =3D info->reshape_progress;
> -	else {
> +	} else {
>  		sra->reshape_progress =3D 0;
>  		if (reshape.after.data_disks < reshape.before.data_disks)
>  			/* start from the end of the new array */
> @@ -3765,8 +3821,6 @@ int Grow_continue_command(char *devname, int fd,
>  	char buf[40];
>  	int cfd =3D -1;
>  	int fd2 =3D -1;
> -	char *ep;
> -	unsigned long long position;
> =20
>  	dprintf("Grow continue from command line called for %s\n",
>  		devname);
> @@ -3894,28 +3948,8 @@ int Grow_continue_command(char *devname, int fd,
>  	/* verify that array under reshape is started from
>  	 * correct position
>  	 */
> -	ret_val =3D sysfs_get_str(content, NULL, "sync_max", buf, 40);
> -	if (ret_val <=3D 0) {
                    ^^^

This test is '<=3D' however ...


> -		fprintf(stderr, Name
> -			": cannot open verify reshape progress for %s (%i)\n",
> -			content->sys_name, ret_val);
> -		ret_val =3D 1;
> -		goto Grow_continue_command_exit;
> -	}
> -	dprintf(Name ": Read sync_max sysfs entry is: %s\n", buf);
> -	position =3D strtoull(buf, &ep, 0);
> -	if (ep =3D=3D buf || (*ep !=3D 0 && *ep !=3D '\n' && *ep !=3D ' ')) {
> -		fprintf(stderr, Name ": Fatal error: array reshape was"
> -			" not properly frozen\n");
> -		ret_val =3D 1;
> -		goto Grow_continue_command_exit;
> -	}
> -	position *=3D get_data_disks(map_name(pers, mdstat->level),
> -				   content->new_layout,
> -				   content->array.raid_disks);
> -	if (position !=3D content->reshape_progress) {
> -		fprintf(stderr, Name ": Fatal error: array reshape was"
> -			" not properly frozen.\n");
> +	if (verify_reshape_position(content,
> +				    map_name(pers, mdstat->level)) < 0) {
                                                                   ^^

this one is just '<'.  However it looks like it should be the same.

Was there a reason for the change, or was it an oversight?

Thanks,
NeilBrown




>  		ret_val =3D 1;
>  		goto Grow_continue_command_exit;
>  	}


--Sig_/vAebD=WrEF91bG.K08LWX9c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzMjGTnsnt1WYoG5AQJDYw//S0uJ7taV9821O4nnT6jH9zxaYuP7BQrO
01JxB5McdtN5PBAKK37VTCxDf2kLumTDnRn0cqFEvW9x/qb5VO2jzn3+ig5K2Chm
b8Xmd1xd5okGU06ZL5I1545pm1jhzcdpuKKKgrkEnu2owkE18UILj59tYlJly271
6qFNatmIU4Q/5I0X+svSa1TslAuMZSKA+RgNRqErSNFvTQKmE2PGN7BOKRIyf31P
uV9pHNW8ZFa7XDC2EMiFam2fqpgRWFInvPmh4R80Thp2kDuKUoeDvpALLXi3MzqW
2Bx8X26oDVjdnLplgx98dH9uXrF53m+wEjQTJF26ht4IEToNhGZ9eDFOmudXmO91
nLESwwkdJ0EgTTiBJAeGYmXrY+uWrf6GtRADdXyHYaG2k7ZIkbMarxzTQlKtehCz
DVa2S0Ic/Axlu8lc3mp2jjWd3GTSkA27MxoJMcJtc2mvSOAuCsUEYB56T2GDQtWO
ekVev3XN+pKTMBvWMthNPLM8mhBNSDKcV1eWfwaoBwhKaRvo88fCe/xooQq9h3mj
LXED58DJWa4YwVGsHrXZTie9QW4zHel2N8DQDl+sx2mBepXMjzheQyxxhkum3so0
b1UOZdjpfUkBkpJOEMghRrTeOWgUmlBBpRHzySQx46/2XNo1vEgL23r4YpyW5vhE
2wmB07MsQi0=
=PUyY
-----END PGP SIGNATURE-----

--Sig_/vAebD=WrEF91bG.K08LWX9c--
