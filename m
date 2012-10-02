From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/6] Display size with human_size_brief with a chosen
 prefix
Date: Tue, 2 Oct 2012 16:41:32 +1000
Message-ID: <20121002164132.3cdeade6@notabene.brown>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
	<20120926114415.328.68023.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rxhcv9_jWlcq5TqhwuDyZ=t"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114415.328.68023.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/rxhcv9_jWlcq5TqhwuDyZ=t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:44:15 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> When using human_size_brief, only IEC prefixes were supported. Now
> it's possible to specify which format we want to see - either IEC
> (kibi, mibi, gibi) or JEDEC (kilo, mega, giga).
>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  Query.c |    2 +-
>  mdadm.h |    7 ++++++-
>  util.c  |   36 +++++++++++++++++++++++++++---------
>  3 files changed, 34 insertions(+), 11 deletions(-)
>=20
> diff --git a/Query.c b/Query.c
> index b9c209f..329e583 100644
> --- a/Query.c
> +++ b/Query.c
> @@ -76,7 +76,7 @@ int Query(char *dev)
>  	else {
>  		printf("%s: %s %s %d devices, %d spare%s. Use mdadm --detail for more =
detail.\n",
>  		       dev,
> -		       human_size_brief(larray_size),
> +		       human_size_brief(larray_size,IEC),
>  		       map_num(pers, array.level),
>  		       array.raid_disks,
>  		       array.spare_disks, array.spare_disks=3D=3D1?"":"s");
> diff --git a/mdadm.h b/mdadm.h
> index e27275b..a24b803 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -329,6 +329,11 @@ enum special_options {
>  	ControllerPath,
>  };
> =20
> +enum prefix_standard {
> +	JEDEC,
> +	IEC
> +};
> +
>  /* structures read from config file */
>  /* List of mddevice names and identifiers
>   * Identifiers can be:
> @@ -1242,7 +1247,7 @@ extern int set_array_info(int mdfd, struct supertyp=
e *st, struct mdinfo *info);
>  unsigned long long min_recovery_start(struct mdinfo *array);
> =20
>  extern char *human_size(long long bytes);
> -extern char *human_size_brief(long long bytes);
> +extern char *human_size_brief(long long bytes, int prefix);
>  extern void print_r10_layout(int layout);
> =20
>  #define NoMdDev (1<<23)
> diff --git a/util.c b/util.c
> index 09971a2..cb97816 100644
> --- a/util.c
> +++ b/util.c
> @@ -682,7 +682,7 @@ char *human_size(long long bytes)
>  	return buf;
>  }
> =20
> -char *human_size_brief(long long bytes)
> +char *human_size_brief(long long bytes, int prefix)
>  {
>  	static char buf[30];
> =20
> @@ -693,19 +693,37 @@ char *human_size_brief(long long bytes)
>  	 * gigabytes, as that shows more precision and isn't
>  	 * too large a number.
>  	 * Terabytes are not yet handled.
> +	 *
> +	 * If prefix =3D=3D IEC, we mean prefixes like kibi,mebi,gibi etc.
> +	 * If prefix =3D=3D JEDEC, we mean prefixes like kilo,mega,giga etc.
>  	 */
> =20
>  	if (bytes < 5000*1024)
>  		buf[0] =3D 0;
> -	else if (bytes < 2*1024LL*1024LL*1024LL) {
> -		long cMiB =3D (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> -		snprintf(buf, sizeof(buf), " (%ld.%02ldMiB)",
> -			cMiB/100 , cMiB % 100);
> -	} else {
> -		long cGiB =3D (bytes / ( (1LL<<30) / 200LL ) +1) /2;
> -		snprintf(buf, sizeof(buf), " (%ld.%02ldGiB)",
> -				cGiB/100 , cGiB % 100);
> +	else if (prefix =3D=3D IEC) {
> +		if (bytes < 2*1024LL*1024LL*1024LL) {
> +			long cMiB =3D (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> +			snprintf(buf, sizeof(buf), "%ld.%02ldMiB",
> +				cMiB/100 , cMiB % 100);
> +		} else {
> +			long cGiB =3D (bytes / ( (1LL<<30) / 200LL ) +1) /2;
> +			snprintf(buf, sizeof(buf), "%ld.%02ldGiB",
> +					cGiB/100 , cGiB % 100);
> +		}
> +	}
> +	else if (prefix =3D=3D JEDEC) {
> +		if (bytes < 2*1024LL*1024LL*1024LL) {
> +			long cMB  =3D (bytes / ( 1000000LL / 200LL ) +1) /2;
> +			snprintf(buf, sizeof(buf), "%ld.%02ldMB",
> +					cMB/100, cMB % 100);
> +		} else {
> +			long cGB  =3D (bytes / (1000000000LL/200LL ) +1) /2;
> +			snprintf(buf, sizeof(buf), "%ld.%02ldGB",
> +					cGB/100 , cGB % 100);
> +		}
>  	}
> +	else
> +		buf[0] =3D 0;
> =20
>  	return buf;
>  }

Yes, I guess that make sense.

Applied,
thanks.
NeilBrown

--Sig_/rxhcv9_jWlcq5TqhwuDyZ=t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqMnDnsnt1WYoG5AQJNPhAAua4jaEqaRVFg2lbQkOVfr0a5D3XS8xKF
/wHKaA0oBTMU7aoFvWBwDqdMoWN3WE+pWGVG1/vPowgujhxTKmSaGnRfCrsdwG3i
VhnrULFgQygoYRvMo8UHf+my5LyJWR4bSWltUM7J7GPbRNP6hphn6EDEMksT3SAN
/ej66ySSq230FjESSw1d3I0GpWc16TLywAUK7f9w/JSq7Ccaf+f1ZpGJ6T3jaMx2
X5GkVPeD0xaZq7kLJfDC1kz3NWR+qEuU9+HhBQO6NOKMpfQCjn/U7PMsrLrg+vEv
sVctIm8/obxZYzjIstsu9TSVq+U14pKOfAlNTOsbMyGnp3bZvJ8Qg4zi4LxdQALZ
f1SPJQDKdEY2Qwbsqt3RZGZRZU/RP+xwGvBbacFSnp8trh8XNuFbsmMg1MIKNZV5
C7WJJ45ypkeuXR71vrw73uHZRn8RslxESOdybLN6JnTkbtKlBsLXnU5Ts9lGSdNk
0DtSCMBMFsKgpb9H4crXwNUPRJkrDe8Lz/GcOx0hpm9/pklkBSr4kmTHlfXR9jFt
lS5pIJVHMwwMNmuNDWm56VkT67HnBxNGvH8iorIKsV7GqZ1yorx2nh4FdAkD7Uwl
yoi2i7b+HggfTb70vk02Bl4+RChLGtik0NmjsogD8lMyrticWykJgrMPIoIJU1Jx
EJjx9YNWdIw=
=ep0L
-----END PGP SIGNATURE-----

--Sig_/rxhcv9_jWlcq5TqhwuDyZ=t--
