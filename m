From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: convert to kstrto*()
Date: Mon, 18 May 2015 12:12:37 +1000
Message-ID: <20150518121237.0cfa5a9d@notabene.brown>
References: <20150516110238.GA32480@p183.telecom.by>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4./573M8TBifswT.fhhISco"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150516110238.GA32480@p183.telecom.by>
Sender: linux-raid-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4./573M8TBifswT.fhhISco
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 16 May 2015 14:02:38 +0300 Alexey Dobriyan <adobriyan@gmail.com>
wrote:

> Convert away from deprecated simple_strto*() functions.
>=20
> Add "fit into sector_t" checks.
>=20
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>=20
>  drivers/md/md.c |  149 ++++++++++++++++++++++++++++++-------------------=
-------
>  1 file changed, 81 insertions(+), 68 deletions(-)
>=20
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2630,13 +2630,14 @@ errors_show(struct md_rdev *rdev, char *page)
>  static ssize_t
>  errors_store(struct md_rdev *rdev, const char *buf, size_t len)
>  {
> -	char *e;
> -	unsigned long n =3D simple_strtoul(buf, &e, 10);
> -	if (*buf && (*e =3D=3D 0 || *e =3D=3D '\n')) {
> -		atomic_set(&rdev->corrected_errors, n);
> -		return len;
> -	}
> -	return -EINVAL;
> +	unsigned int n;
> +	int rv;
> +
> +	rv =3D kstrtouint(buf, 10, &n);
> +	if (rv < 0)
> +		return rv;
> +	atomic_set(&rdev->corrected_errors, n);
> +	return len;
>  }
>  static struct rdev_sysfs_entry rdev_errors =3D
>  __ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
> @@ -2653,13 +2654,16 @@ slot_show(struct md_rdev *rdev, char *page)
>  static ssize_t
>  slot_store(struct md_rdev *rdev, const char *buf, size_t len)
>  {
> -	char *e;
> +	int slot;
>  	int err;
> -	int slot =3D simple_strtoul(buf, &e, 10);
> +
>  	if (strncmp(buf, "none", 4)=3D=3D0)
>  		slot =3D -1;
> -	else if (e=3D=3Dbuf || (*e && *e!=3D '\n'))
> -		return -EINVAL;
> +	else {
> +		err =3D kstrtouint(buf, 10, (unsigned int *)&slot);
> +		if (err < 0)
> +			return err;
> +	}
>  	if (rdev->mddev->pers && slot =3D=3D -1) {
>  		/* Setting 'slot' on an active array requires also
>  		 * updating the 'rd%d' link, and communicating
> @@ -3544,12 +3548,12 @@ layout_show(struct mddev *mddev, char *page)
>  static ssize_t
>  layout_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> -	char *e;
> -	unsigned long n =3D simple_strtoul(buf, &e, 10);
> +	unsigned int n;
>  	int err;
> =20
> -	if (!*buf || (*e && *e !=3D '\n'))
> -		return -EINVAL;
> +	err =3D kstrtouint(buf, 10, &n);
> +	if (err < 0)
> +		return err;
>  	err =3D mddev_lock(mddev);
>  	if (err)
>  		return err;
> @@ -3593,12 +3597,12 @@ static int update_raid_disks(struct mddev *mddev,=
 int raid_disks);
>  static ssize_t
>  raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> -	char *e;
> +	unsigned int n;
>  	int err;
> -	unsigned long n =3D simple_strtoul(buf, &e, 10);
> =20
> -	if (!*buf || (*e && *e !=3D '\n'))
> -		return -EINVAL;
> +	err =3D kstrtouint(buf, 10, &n);
> +	if (err < 0)
> +		return err;
> =20
>  	err =3D mddev_lock(mddev);
>  	if (err)
> @@ -3645,12 +3649,12 @@ chunk_size_show(struct mddev *mddev, char *page)
>  static ssize_t
>  chunk_size_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> +	unsigned long n;
>  	int err;
> -	char *e;
> -	unsigned long n =3D simple_strtoul(buf, &e, 10);
> =20
> -	if (!*buf || (*e && *e !=3D '\n'))
> -		return -EINVAL;
> +	err =3D kstrtoul(buf, 10, &n);
> +	if (err < 0)
> +		return err;
> =20
>  	err =3D mddev_lock(mddev);
>  	if (err)
> @@ -3688,19 +3692,24 @@ resync_start_show(struct mddev *mddev, char *page)
>  static ssize_t
>  resync_start_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> +	unsigned long long n;
>  	int err;
> -	char *e;
> -	unsigned long long n =3D simple_strtoull(buf, &e, 10);
> +
> +	if (cmd_match(buf, "none"))
> +		n =3D MaxSector;
> +	else {
> +		err =3D kstrtoull(buf, 10, &n);
> +		if (err < 0)
> +			return err;
> +		if (n !=3D (sector_t)n)
> +			return -EINVAL;
> +	}
> =20
>  	err =3D mddev_lock(mddev);
>  	if (err)
>  		return err;
>  	if (mddev->pers && !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>  		err =3D -EBUSY;
> -	else if (cmd_match(buf, "none"))
> -		n =3D MaxSector;
> -	else if (!*buf || (*e && *e !=3D '\n'))
> -		err =3D -EINVAL;
> =20
>  	if (!err) {
>  		mddev->recovery_cp =3D n;
> @@ -3936,14 +3945,14 @@ max_corrected_read_errors_show(struct mddev *mdde=
v, char *page) {
>  static ssize_t
>  max_corrected_read_errors_store(struct mddev *mddev, const char *buf, si=
ze_t len)
>  {
> -	char *e;
> -	unsigned long n =3D simple_strtoul(buf, &e, 10);
> +	unsigned int n;
> +	int rv;
> =20
> -	if (*buf && (*e =3D=3D 0 || *e =3D=3D '\n')) {
> -		atomic_set(&mddev->max_corr_read_errors, n);
> -		return len;
> -	}
> -	return -EINVAL;
> +	rv =3D kstrtouint(buf, 10, &n);
> +	if (rv < 0)
> +		return rv;
> +	atomic_set(&mddev->max_corr_read_errors, n);
> +	return len;
>  }
> =20
>  static struct md_sysfs_entry max_corr_read_errors =3D
> @@ -4297,15 +4306,18 @@ sync_min_show(struct mddev *mddev, char *page)
>  static ssize_t
>  sync_min_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> -	int min;
> -	char *e;
> +	unsigned int min;
> +	int rv;
> +
>  	if (strncmp(buf, "system", 6)=3D=3D0) {
> -		mddev->sync_speed_min =3D 0;
> -		return len;
> +		min =3D 0;
> +	} else {
> +		rv =3D kstrtouint(buf, 10, &min);
> +		if (rv < 0)
> +			return rv;
> +		if (min =3D=3D 0)
> +			return -EINVAL;
>  	}
> -	min =3D simple_strtoul(buf, &e, 10);
> -	if (buf =3D=3D e || (*e && *e !=3D '\n') || min <=3D 0)
> -		return -EINVAL;
>  	mddev->sync_speed_min =3D min;
>  	return len;
>  }
> @@ -4323,15 +4335,18 @@ sync_max_show(struct mddev *mddev, char *page)
>  static ssize_t
>  sync_max_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> -	int max;
> -	char *e;
> +	unsigned int max;
> +	int rv;
> +
>  	if (strncmp(buf, "system", 6)=3D=3D0) {
> -		mddev->sync_speed_max =3D 0;
> -		return len;
> +		max =3D 0;
> +	} else {
> +		rv =3D kstrtouint(buf, 10, &max);
> +		if (rv < 0)
> +			return rv;
> +		if (max =3D=3D 0)
> +			return -EINVAL;
>  	}
> -	max =3D simple_strtoul(buf, &e, 10);
> -	if (buf =3D=3D e || (*e && *e !=3D '\n') || max <=3D 0)
> -		return -EINVAL;
>  	mddev->sync_speed_max =3D max;
>  	return len;
>  }
> @@ -4514,12 +4529,13 @@ suspend_lo_show(struct mddev *mddev, char *page)
>  static ssize_t
>  suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> -	char *e;
> -	unsigned long long new =3D simple_strtoull(buf, &e, 10);
> -	unsigned long long old;
> +	unsigned long long old, new;
>  	int err;
> =20
> -	if (buf =3D=3D e || (*e && *e !=3D '\n'))
> +	err =3D kstrtoull(buf, 10, &new);
> +	if (err < 0)
> +		return err;
> +	if (new !=3D (sector_t)new)
>  		return -EINVAL;
> =20
>  	err =3D mddev_lock(mddev);
> @@ -4556,12 +4572,13 @@ suspend_hi_show(struct mddev *mddev, char *page)
>  static ssize_t
>  suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
>  {
> -	char *e;
> -	unsigned long long new =3D simple_strtoull(buf, &e, 10);
> -	unsigned long long old;
> +	unsigned long long old, new;
>  	int err;
> =20
> -	if (buf =3D=3D e || (*e && *e !=3D '\n'))
> +	err =3D kstrtoull(buf, 10, &new);
> +	if (err < 0)
> +		return err;
> +	if (new !=3D (sector_t)new)
>  		return -EINVAL;
> =20
>  	err =3D mddev_lock(mddev);
> @@ -4603,11 +4620,13 @@ static ssize_t
>  reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
>  {
>  	struct md_rdev *rdev;
> -	char *e;
> +	unsigned long long new;
>  	int err;
> -	unsigned long long new =3D simple_strtoull(buf, &e, 10);
> =20
> -	if (buf =3D=3D e || (*e && *e !=3D '\n'))
> +	err =3D kstrtoull(buf, 10, &new);
> +	if (err < 0)
> +		return err;
> +	if (new !=3D (sector_t)new)
>  		return -EINVAL;
>  	err =3D mddev_lock(mddev);
>  	if (err)
> @@ -9009,13 +9028,7 @@ static int get_ro(char *buffer, struct kernel_para=
m *kp)
>  }
>  static int set_ro(const char *val, struct kernel_param *kp)
>  {
> -	char *e;
> -	int num =3D simple_strtoul(val, &e, 10);
> -	if (*val && (*e =3D=3D '\0' || *e =3D=3D '\n')) {
> -		start_readonly =3D num;
> -		return 0;
> -	}
> -	return -EINVAL;
> +	return kstrtouint(val, 10, (unsigned int *)&start_readonly);
>  }
> =20
>  module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Looks good - thanks.
I'll queue for the next merge window.

Thanks,
NeilBrown

--Sig_/4./573M8TBifswT.fhhISco
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVlKlTnsnt1WYoG5AQLZsA//bBU9Pub5IvgAxMdCQ+JOWRU8sxLvhQX7
+hkiuk3CZHsBm4CPpfc5/y1uFgLlXmt8se3O5LlU+Ai8Ixh25J1gpm59u6lXmCH5
1NdG2xb03XvBJHycjYAX1yTZwlU268tgxpnhH+8ecuA6QG2vZI8zteisS08w7403
xP+chlpc612+8eRfLkSWwpHEmaL/wBivz0iswHojg1Et5T34negyCxIrQwRQVDLo
jgGL97LU0dHujgsQqRg8XTl0mvx+zBHafW2sZCNpYQR5HV/XFsWJWSROGlyjjDLJ
7MzngRq61CJJ4Z+T1Pby64sgQv5rhM9/nUB5TJ9pnNhh7PIDGeYLclS2A1p0Gfyx
wS/ml1ERkixcvmk2TaNpc8T4JPM00DuUMSzyvdzMkd8sQ5peuBiwc5jLvgPRpa4f
OEufD4mbd2Wqp8Vy6eqZ6lhIToGb4c9wbIzMnS/JPIcE7Ig27orocMuT5EgINXmp
ZcWMwPKW796lFr65wZYtiPrVFvM/ax47eldyqTPvQ6N6xaVL+XhNaSld1jAvsnQQ
/+0mX+9Dq0AkKxUs74Kppnw9W9WcQ81rirBnJpFDI2cq8BtrfxwnYlNGZxEKHRlC
mQcy2Euy+PYQ9XZu9qa8+Jh0TEKlvX1YVdT3O6pTxn8nZPUFJ19sAjZSbkdVlcLC
PIeDKSFHeic=
=EhuH
-----END PGP SIGNATURE-----

--Sig_/4./573M8TBifswT.fhhISco--
