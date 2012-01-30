From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: do not overwrite existing devices' symlinks
Date: Mon, 30 Jan 2012 12:27:28 +1100
Message-ID: <20120130122728.3aa8da9a@notabene.brown>
References: <20120123120652.20165.47998.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iDr2cbzHMEU3k01sz4RLgDf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120123120652.20165.47998.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/iDr2cbzHMEU3k01sz4RLgDf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jan 2012 13:06:52 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> If the device's name is given in /etc/mdadm.conf, create_mddev()
> does not check if the map contains a device of this name (mdopen.c:140).
> If it does, the symlink of that name will be overwritten.
>=20
> create_mddev() has been changed. Now it checks if the map contains
> a device of the name given in /etc/mdadm.conf.
> If it does, the appropriate suffix is added to the given name.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>

Can you please remind me what the big picture problem is here??

It seem like you are suggesting that if
   /dev/md/thing

is given in mdadm.conf, but some other array is already assembled with the
name /dev/md/thing, then the array from mdadm.conf should be assembled as
   /dev/md/thing0
or something like that - is that correct?

I don't think we want that.  If there is a name conflict like  this with a
name given in mdadm.conf, then one of the arrays should fail to assemble as
this is really a fairly serious configuration error.

Or did I misunderstand?

Thanks,
NeilBrown



> ---
>  mdopen.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
>=20
> diff --git a/mdopen.c b/mdopen.c
> index eac1c1f..3078de6 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -147,10 +147,12 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
>  	char *cname;
>  	char devname[20];
>  	char cbuf[400];
> +	struct map_ent *map =3D NULL;
> +	int dev_conflict =3D 0;
> +
>  	if (chosen =3D=3D NULL)
>  		chosen =3D cbuf;
> =20
> -
>  	if (autof =3D=3D 0)
>  		autof =3D ci->autof;
> =20
> @@ -277,17 +279,21 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
>  	else
>  		sprintf(devname, "/dev/md%d", num);
> =20
> -	if (cname[0] =3D=3D 0 && name) {
> +	if ((cname[0] !=3D 0) && map_by_name(&map, cname))
> +		dev_conflict =3D 1;
> +
> +	if ((cname[0] =3D=3D 0 && name) || dev_conflict) {
>  		/* Need to find a name if we can
>  		 * We don't completely trust 'name'.  Truncate to
>  		 * reasonable length and remove '/'
>  		 */
>  		char *cp;
> -		struct map_ent *map =3D NULL;
>  		int conflict =3D 1;
>  		int unum =3D 0;
>  		int cnlen;
> -		strncpy(cname, name, 200);
> +
> +		if (!dev_conflict)
> +			strncpy(cname, name, 200);
>  		cname[200] =3D 0;
>  		while ((cp =3D strchr(cname, '/')) !=3D NULL)
>  			*cp =3D '-';
> @@ -312,7 +318,7 @@ int create_mddev(char *dev, char *name, int autof, in=
t trustworthy,
>  		}
>  	}
> =20
> -	if (dev && dev[0] =3D=3D '/')
> +	if ((dev && dev[0] =3D=3D '/') && (!dev_conflict))
>  		strcpy(chosen, dev);
>  	else if (cname[0] =3D=3D 0)
>  		strcpy(chosen, devname);


--Sig_/iDr2cbzHMEU3k01sz4RLgDf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyXyADnsnt1WYoG5AQLPgA//TAKRrAwEMaIz5eeN46eHG7T2+sotppQX
P05Tz3pIuqnhvJU6u5EiIW/OIF8IjYoJiC186toUBoKSkEmFfoDXJk3tvhiX6vBu
+KTUjQ1nlhAgb9U10fq98RoBuwQpN+om631QQUzH6jIGridliR+dnpalCIABVYoY
JEScV1CdWyWGEZ2vBpCDz65LBb77kO5KG6Ydshvx/n3WPDOJ21MJ9bBUG6L6Chjy
1O6OBjv88fi3hHi8Jc369yEA0thmbmhDm0sJ5x0JwPZ7xHNJWXdG09x7e/Epr/Sc
ftfAq4WfFNlAWFNk4j3DbAqU9K/tx6pcMvxC+HAA8fLelr3FDAlCXJMabGH74Xlt
Rrk7uah8FBSVFwK8hKeZu0jlWLJCuOaCUW4TAfGE4akCfcAApvdJ2+sk0/JjYMhU
b1d5hY4Bf7XPaGfmXKTYR3gIuisEx1lGAQAtUAcMhPpBJVS9f8Q8kaHMZR+Yd627
NWxiOxXsDcVGyt//21WHZil9KK7+jrWBjVwTB04IdhfF5rVrXQhruREh+ZDY72Xc
hiQgigEcwT4+XeFhqjjwPkEDuAyT2nhHriugD3hAXIi3zPYvHTeWGWMs26KyAeoz
/pDF8MPt9ykQbpciBir0JsE0W/J3N2ab6/uryKTNdGJ11Xu+uTtAyHO9vpNXJhLb
aLfPN8G+HL4=
=62G3
-----END PGP SIGNATURE-----

--Sig_/iDr2cbzHMEU3k01sz4RLgDf--
