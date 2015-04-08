From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] IMSM: Count arrays per orom
Date: Thu, 9 Apr 2015 09:06:41 +1000
Message-ID: <20150409090641.17ee3c3b@notabene.brown>
References: <20150408094217.10715.28672.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/f6.wZ5LQhxodoCMSGu9pZCj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150408094217.10715.28672.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/f6.wZ5LQhxodoCMSGu9pZCj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Apr 2015 11:42:18 +0200 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Active arrays with IMSM metadata are counted per hba so far.
> This is bad due to new functionality of orom shared between multiple
> controllers i.e. more arrays can be created than is supported by orom.
> This patch changes the way of counting arrays, so the result will be
> sum of arrays under every hba supported by specific orom.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  platform-intel.c |   14 ++++++++-
>  platform-intel.h |    1 +
>  super-intel.c    |   85 +++++++++++++++++++++++++++++++++++++-----------=
------
>  3 files changed, 71 insertions(+), 29 deletions(-)
>=20
> diff --git a/platform-intel.c b/platform-intel.c
> index 1e9ddcd..edb8679 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -233,7 +233,7 @@ struct pciExpDataStructFormat {
> =20
>  struct orom_entry *orom_entries;
> =20
> -const struct imsm_orom *get_orom_by_device_id(__u16 dev_id)
> +const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id)
>  {
>  	struct orom_entry *entry;
>  	struct devid_list *devid;
> @@ -241,13 +241,23 @@ const struct imsm_orom *get_orom_by_device_id(__u16=
 dev_id)
>  	for (entry =3D orom_entries; entry; entry =3D entry->next) {
>  		for (devid =3D entry->devid_list; devid; devid =3D devid->next) {
>  			if (devid->devid =3D=3D dev_id)
> -				return &entry->orom;
> +				return entry;
>  		}
>  	}
> =20
>  	return NULL;
>  }
> =20
> +const struct imsm_orom *get_orom_by_device_id(__u16 dev_id)
> +{
> +	const struct orom_entry *entry =3D get_orom_entry_by_device_id(dev_id);
> +
> +	if (entry)
> +		return &entry->orom;
> +
> +	return NULL;
> +}
> +
>  static struct orom_entry *add_orom(const struct imsm_orom *orom)
>  {
>  	struct orom_entry *list;
> diff --git a/platform-intel.h b/platform-intel.h
> index 631fa76..695d6c6 100644
> --- a/platform-intel.h
> +++ b/platform-intel.h
> @@ -238,5 +238,6 @@ int devt_attached_to_hba(dev_t dev, const char *hba_p=
ath);
>  char *devt_to_devpath(dev_t dev);
>  int path_attached_to_hba(const char *disk_path, const char *hba_path);
>  const char *get_sys_dev_type(enum sys_dev_type);
> +const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id);
>  const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
>  struct sys_dev *device_by_id(__u16 device_id);
> diff --git a/super-intel.c b/super-intel.c
> index 77df8db..66cc8e5 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5853,37 +5853,68 @@ count_volumes_list(struct md_list *devlist, char =
*homehost,
>  }
> =20
>  static int
> -count_volumes(char *hba, int dpa, int verbose)
> +count_volumes(struct intel_hba *hba, int dpa, int verbose)
>  {
> -	struct md_list *devlist =3D NULL;
> +	struct sys_dev *idev, *intel_devices =3D find_intel_devices();
>  	int count =3D 0;
> -	int found =3D 0;;
> +	const struct orom_entry *entry;
> +	struct devid_list *dv, *devid_list;
> =20
> -	devlist =3D get_devices(hba);
> -	/* if no intel devices return zero volumes */
> -	if (devlist =3D=3D NULL)
> +	if (!hba || !hba->path)
>  		return 0;
> =20
> -	count =3D active_arrays_by_format("imsm", hba, &devlist, dpa, verbose);
> -	dprintf("path: %s active arrays: %d\n", hba, count);
> -	if (devlist =3D=3D NULL)
> +	for (idev =3D intel_devices; idev; idev =3D idev->next) {
> +		if (strstr(idev->path, hba->path))
> +				break;
> +	}
> +
> +	if (!idev || !idev->dev_id)
>  		return 0;
> -	do  {
> -		found =3D 0;
> -		count +=3D count_volumes_list(devlist,
> -					    NULL,
> -					    verbose,
> -					    &found);
> -		dprintf("found %d count: %d\n", found, count);
> -	} while (found);
> -
> -	dprintf("path: %s total number of volumes: %d\n", hba, count);
> -
> -	while(devlist) {
> -		struct md_list *dv =3D devlist;
> -		devlist =3D devlist->next;
> -		free(dv->devname);
> -		free(dv);
> +
> +	entry =3D get_orom_entry_by_device_id(idev->dev_id);
> +
> +	if (!entry || !entry->devid_list)
> +		return 0;
> +
> +	devid_list =3D entry->devid_list;
> +	for (dv =3D devid_list; dv; dv =3D dv->next) {
> +
> +		struct md_list *devlist =3D NULL;
> +		struct sys_dev *device =3D device_by_id(dv->devid);
> +		char *hba_path;
> +		int found =3D 0;
> +
> +		if (device)
> +			hba_path =3D device->path;
> +		else
> +			return 0;
> +
> +		devlist =3D get_devices(hba_path);
> +		/* if no intel devices return zero volumes */
> +		if (devlist =3D=3D NULL)
> +			return 0;
> +
> +		count +=3D active_arrays_by_format("imsm", hba_path, &devlist, dpa, ve=
rbose);
> +		dprintf("path: %s active arrays: %d\n", hba_path, count);
> +		if (devlist =3D=3D NULL)
> +			return 0;
> +		do  {
> +			found =3D 0;
> +			count +=3D count_volumes_list(devlist,
> +							NULL,
> +							verbose,
> +							&found);
> +			dprintf("found %d count: %d\n", found, count);
> +		} while (found);
> +
> +		dprintf("path: %s total number of volumes: %d\n", hba_path, count);
> +
> +		while (devlist) {
> +			struct md_list *dv =3D devlist;
> +			devlist =3D devlist->next;
> +			free(dv->devname);
> +			free(dv);
> +		}
>  	}
>  	return count;
>  }
> @@ -6105,7 +6136,7 @@ static int validate_geometry_imsm_volume(struct sup=
ertype *st, int level,
>  	*freesize =3D maxsize;
> =20
>  	if (super->orom) {
> -		int count =3D count_volumes(super->hba->path,
> +		int count =3D count_volumes(super->hba,
>  				      super->orom->dpa, verbose);
>  		if (super->orom->vphba <=3D count) {
>  			pr_vrb(": platform does not support more than %d raid volumes.\n",
> @@ -6261,7 +6292,7 @@ static int validate_geometry_imsm(struct supertype =
*st, int level, int layout,
>  			   created */
>  			if (super->orom && freesize) {
>  				int count;
> -				count =3D count_volumes(super->hba->path,
> +				count =3D count_volumes(super->hba,
>  						      super->orom->dpa, verbose);
>  				if (super->orom->vphba <=3D count) {
>  					pr_vrb(": platform does not support more than %d raid volumes.\n",
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

applied, thanks.

NeilBrown

--Sig_/f6.wZ5LQhxodoCMSGu9pZCj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSW0gTnsnt1WYoG5AQJDNBAAkvYB5oev/1OMxtPO6rlnKGm1Lu3ctwIK
emBiUuVu3DYtYgSWTIYB2LQ06X2FCMZfQ+PJQX+F+dbwFoW+IbckavRkkGtQj1Tn
D4xDElj9BMqhe2S+f8TgMbwIGC9XYxlkOdCle2F6XrfgYGBKIvAXBX+9/dqoDP6o
03L68Sts1MVq3Qr2D1kEBxjp7hbbCiv1ONDFQFJ2XRgdgLWqd8GYK6V5V/MJkeuU
Ejd1EoEzMWbqx+TVcJzgxMiL2UOLT1FTKQPC3wwRjUN/TtPcwv7ctXOKU5HAlgLc
wxhclEwVVYajN3Il4pUbxpn5JPrpBlwGctPceHhU2JUGlI2YyfoJlXtnN1rgnJjx
npQSgypg+V8jJefHD6XMZ0AYMGkXoSW5LkGu6hc1V1xkJjDGrEkA4Zpg8EMoSzQp
/XuyGcG0o86TJNrVqXa3mgRJlO99E9jI2hyTBb3SyV25bAFfzN8xBF7lo6tfWU2O
qpnFdP9vUNVYvFesogb2pgmGwt82SiANNjri6lzGpj9kcSvlwkSPhE8Z9XboiOSd
26BM5bDi0MCZ9c2/adk9sm3Q3mYhwpytMZge4YhJdJwIxMEh6i9suFcTWicM5rXp
180qhdSerHLrm67Dokzs3dZhAm4qlioZ+pzAYDQenOs3JRP4oWiKpga8xZ466141
vsRMtMfhQU8=
=qr4D
-----END PGP SIGNATURE-----

--Sig_/f6.wZ5LQhxodoCMSGu9pZCj--
