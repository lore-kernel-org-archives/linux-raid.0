From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 14/22] md: support updating bitmap parameters via sysfs.
Date: Tue, 8 Dec 2009 11:29:43 +0100
Message-ID: <20091208102943.GZ21495@skl-net.de>
References: <20091204064559.10264.37619.stgit@notabene.brown> <20091204064802.10264.47719.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ohyzAr2DuZRs7WU"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091204064802.10264.47719.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--7ohyzAr2DuZRs7WU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:48, NeilBrown wrote:
> A new attribute directory 'bitmap' in 'md' is created which
> contains files for configuring the bitmap.

Nice.

> 'location' identifies where the bitmap is, either 'none',
> or 'file' or 'sector offset from metadata'.
> Writing 'location' can create or remove a bitmap.
> Adding a 'file' bitmap this way is not yet supported.
>=20
> 'chunksize' can be set before creating a bitmap, but is
> currently always over-ridden by the bitmap superblock.
>=20
> 'time_base' and 'backlog' can be updated at any time.

This text should probably go into the mdadm documentation as well.

> +static ssize_t
> +location_show(mddev_t *mddev, char *page)
> +{
> +	ssize_t len =3D 0;
> +	if (mddev->bitmap_info.file) {
> +		len =3D sprintf(page, "file");
> +	} else if (mddev->bitmap_info.offset) {
> +		len =3D sprintf(page, "%+lld", (long long)mddev->bitmap_info.offset);
> +	} else
> +		len =3D sprintf(page, "none");
> +	len +=3D sprintf(page+len, "\n");
> +	return len;
> +}

Pointless initialization to zero.

> +	} else {
> +		/* No bitmap, OK to set a location */
> +		long long offset;
> +		if (strncmp(buf, "none", 4) =3D=3D 0)
> +			/* nothing to be done */;
> +		else if (strncmp(buf, "file:", 5) =3D=3D 0) {
> +			/* Not supported yet */
> +			return -EINVAL;
> +		} else {
> +			int rv;
> +			if (buf[0] =3D=3D '+')
> +				rv =3D strict_strtoll(buf+1, 10, &offset);
> +			else
> +				rv =3D strict_strtoll(buf, 10, &offset);
> +			if (rv)
> +				return rv;
> +			mddev->bitmap_info.offset =3D offset;

Introducing a sanity check here would probably save some sysadmin's
feet.

> +static struct md_sysfs_entry bitmap_location =3D
> +__ATTR(location, S_IRUGO|S_IWUSR, location_show, location_store);
> +
> +static ssize_t
> +timeout_show(mddev_t *mddev, char *page)
> +{
> +	ssize_t len =3D 0;
> +	unsigned long secs =3D mddev->bitmap_info.daemon_sleep / HZ;
> +	unsigned long jifs =3D mddev->bitmap_info.daemon_sleep % HZ;
> +=09
> +	len =3D sprintf(page, "%lu", secs);
> +	if (jifs)
> +		len +=3D sprintf(page+len, ".%03u", jiffies_to_msecs(jifs));
> +	len +=3D sprintf(page+len, "\n");
> +	return len;
> +}

Again, no need to initialize len.

> +
> +int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
> +{
> +	unsigned long result =3D 0;
> +	long decimals =3D -1;
> +	while (isdigit(*cp) || (*cp =3D=3D '.' && decimals < 0)) {
> +		if (*cp =3D=3D '.')
> +			decimals =3D 0;
> +		else if (decimals < scale) {
> +			unsigned int value;
> +			value =3D *cp - '0';
> +			result =3D result * 10 + value;
> +			if (decimals >=3D 0)
> +				decimals++;
> +		}
> +		cp++;
> +	}
> +	if (*cp =3D=3D '\n')
> +		cp++;
> +	if (*cp)
> +		return -EINVAL;
> +	if (decimals < 0)
> +		decimals =3D 0;
> +	while (decimals < scale) {
> +		result *=3D 10;
> +		decimals ++;
> +	}
> +	*res =3D result;
> +	return 0;
> +}

A comment which describes what exactly this function is supposed to
to would be nice. It has only one caller and could be made static BTW.
OTOH, it probably belongs to lib/vsprintf.c.

> +static ssize_t
> +timeout_store(mddev_t *mddev, const char *buf, size_t len)
> +{
> +	/* timeout can be set at any time */
> +	unsigned long timeout;
> +	int rv =3D strict_strtoul_scaled(buf, &timeout, 4);
> +	if (rv)
> +		return rv;
> +
> +	timeout =3D timeout * HZ / 10000;

This might overflow. But maybe that's OK as only insane values (written
by root) will cause an overflow.

> +
> +	if (timeout > MAX_SCHEDULE_TIMEOUT)
> +		timeout =3D MAX_SCHEDULE_TIMEOUT;
> +	if (timeout < 1)
> +		timeout =3D 1;
> +	mddev->bitmap_info.daemon_sleep =3D timeout;
> +	if (mddev->thread) {
> +		if (mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT) {
> +			mddev->thread->timeout =3D timeout;
> +			md_wakeup_thread(mddev->thread);
> +		}

I don't get this. Why do we want to set mddev->thread->timeout only
if mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT)?

Also, if the timeout is being set while the array is stopped, the
command succeeds but has no effect (as mddev->thread is NULL). Maybe
it's better to return an error in this case.

> +static ssize_t
> +backlog_store(mddev_t *mddev, const char *buf, size_t len)
> +{
> +	unsigned long backlog;
> +	int rv =3D strict_strtoul(buf, 10, &backlog);
> +	if (rv)
> +		return rv;
> +	if (backlog > COUNTER_MAX)
> +		backlog =3D COUNTER_MAX;
> +	mddev->bitmap_info.max_write_behind =3D backlog;
> +	return len;
> +}

If the given value is too large this code silently ignores that value
and uses the maximal possible value instead. Even if we'd prefer "I
know better what you really want" over "you asked for it you got it",
we should at least be consistent. min_sync_store() for example returns
EINVAL if the given value is not suitable. So does chunksize_store()
below.

The same comment applies to timeout_store() of course.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--7ohyzAr2DuZRs7WU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLHiqXWto1QDEAkw8RAqB4AJ9stzBazg3i7t/wwfiCaDBYx3BhzwCgmfbT
Wd8/GyIuuQ03YmH+BeUKR1M=
=Anwn
-----END PGP SIGNATURE-----

--7ohyzAr2DuZRs7WU--
