From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH] md: fix 32-bit build warning
Date: Mon, 12 Oct 2015 15:59:27 +1100
Message-ID: <87fv1g1y34.fsf@notabene.neil.brown.name>
References: <5304496.D8N6u074t0@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5304496.D8N6u074t0@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann <arnd@arndb.de> writes:

> On 32-bit architectures, the md code produces this warning when CONFIG_LD=
AF
> is set:
>
> drivers/md/md.c: In function 'check_sb_changes':
> drivers/md/md.c:8990:10: warning: format '%lu' expects argument of type '=
long unsigned int', but argument 4 has type 'sector_t {aka long long unsign=
ed int}' [-Wformat=3D]
>    pr_info("%s:%d recovery_cp changed from %lu to %lu\n", __func__,
>
> The code was only recently introduced, and uses the wrong format string
> for sector_t. As a workaround, this patch adds an explicit cast to 'u64'
> so we can use the %llu format string on all architectures.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: e0212320066e ("md-cluster: Improve md_reload_sb to be less error p=
rone")
> Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>
> I also noticed that some commmits in md/for-next including the one causing
> the problem lack a Signed-off-by line. It might make sense to just fold t=
his
> patch and add the lines at the same time.
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7fff1e6884d6..e13f72a3b561 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8987,9 +8987,9 @@ static void check_sb_changes(struct mddev *mddev, s=
truct md_rdev *rdev)
>=20=20
>  	/* recovery_cp changed */
>  	if (le64_to_cpu(sb->resync_offset) !=3D mddev->recovery_cp) {
> -		pr_info("%s:%d recovery_cp changed from %lu to %lu\n", __func__,
> -				__LINE__, mddev->recovery_cp,
> -				(unsigned long) le64_to_cpu(sb->resync_offset));
> +		pr_info("%s:%d recovery_cp changed from %llu to %llu\n", __func__,
> +				__LINE__, (u64)mddev->recovery_cp,
> +				(u64) le64_to_cpu(sb->resync_offset));
>  		mddev->recovery_cp =3D le64_to_cpu(sb->resync_offset);
>  	}
>=20=20

Thanks, but is this really right?
I think u64 is "unsigned long" on 64bit.
I have always used (unsigned long long) when I want to use %llu on
sector_t.

How confident are you of using "u64" ?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWGz4vAAoJEDnsnt1WYoG5af8P/1h/uRYWnNQGJV+2iuWATREN
1lAm0b9wetEQ/bj4n0Tjl+Qe7TQ02D5Aqhy90hj6XyD8ovTDlRFwHSmqGKu6P7Bx
zsxMHfmebqU6+TFR4r7V+99zcCo+hfcP+bhbMgBPkPwYSjWI0Fuott4puW96pjo5
iLJ+4vIMijJE14DPHQf0GhkPHvVDHlY3+14PwH9FcRik/h55+e4kxw6By5evJ+bo
GRAxHsFmvcdOtOCfaj/+G/VYXrzffZVBop99yr9bZ0wGw00Z0TW0fJpOyMrIoqmE
Agwmx3OzJwpZCWJBB6zo8Civ7iI23ZqpHgwuXvGjr5DuWFitJqe+liHBzcXmwRLC
WD1bzOW2Yx6VXXmJZpikGI+cnFpTFgAkdHpiYh0o8rUq4Zzldcp1lfDvwMx8eGro
Brd4e9fZ6NUNbjPZ6YWNxrXEcEF7TfYFMCBFhaMqBA+4KB9/0U0KdIwhaE4/sTa0
NpZ7NF17S/Mpzru7QKk0bc3KnQpQHAC6jFU8aHZL/dkPBgtnbADUPch2aaQbQk6t
1lSDMc6xLQ7S1Soqe1nvVXgCqqD+L9Ru+jeSsw89p/5UCLSo3I+2Su0ZUbJph17C
8BbLHsTDOPj723VNJKF8mrDj0IMZ2Y+jNq0c32Z98B16Y8JX9T12FIyOnf8LdyJx
Kk//IxPxT19Tb9m0vPdB
=fIpw
-----END PGP SIGNATURE-----
--=-=-=--
