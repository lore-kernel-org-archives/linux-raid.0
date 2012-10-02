From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/6] Synchronize size calculation in human_size and
 human_size_brief
Date: Tue, 2 Oct 2012 16:40:28 +1000
Message-ID: <20121002164028.3d223f27@notabene.brown>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
	<20120926114408.328.96284.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//V.VZjYGTZON/znN6E30noc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114408.328.96284.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_//V.VZjYGTZON/znN6E30noc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 13:44:08 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> It would be better if two size-calculating methods had the same
> calculating algorithm. The human_size way of calculation seems
> more readable, so let's use it for both methods.
>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
> ---
>  util.c |   33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
>=20
> diff --git a/util.c b/util.c
> index c63a232..09971a2 100644
> --- a/util.c
> +++ b/util.c
> @@ -686,20 +686,27 @@ char *human_size_brief(long long bytes)
>  {
>  	static char buf[30];
> =20
> +	/* We convert bytes to either centi-M{ega,ibi}bytes or
> +	 * centi-G{igi,ibi}bytes, with appropriate rounding,
> +	 * and then print 1/100th of those as a decimal.
> +	 * We allow upto 2048Megabytes before converting to
> +	 * gigabytes, as that shows more precision and isn't
> +	 * too large a number.
> +	 * Terabytes are not yet handled.
> +	 */
> +
>  	if (bytes < 5000*1024)
> -		snprintf(buf, sizeof(buf), "%ld.%02ldKiB",
> -			(long)(bytes>>10), (long)(((bytes&1023)*100+512)/1024)
> -			);
> -	else if (bytes < 2*1024LL*1024LL*1024LL)
> -		snprintf(buf, sizeof(buf), "%ld.%02ldMiB",
> -			(long)(bytes>>20),
> -			(long)((bytes&0xfffff)+0x100000/200)/(0x100000/100)
> -			);
> -	else
> -		snprintf(buf, sizeof(buf), "%ld.%02ldGiB",
> -			(long)(bytes>>30),
> -			(long)(((bytes>>10)&0xfffff)+0x100000/200)/(0x100000/100)
> -			);
> +		buf[0] =3D 0;
> +	else if (bytes < 2*1024LL*1024LL*1024LL) {
> +		long cMiB =3D (bytes / ( (1LL<<20) / 200LL ) +1) /2;
> +		snprintf(buf, sizeof(buf), " (%ld.%02ldMiB)",
> +			cMiB/100 , cMiB % 100);
> +	} else {
> +		long cGiB =3D (bytes / ( (1LL<<30) / 200LL ) +1) /2;
> +		snprintf(buf, sizeof(buf), " (%ld.%02ldGiB)",
> +				cGiB/100 , cGiB % 100);
> +	}
> +
>  	return buf;
>  }
> =20

Applied,
thanks,
NeilBrown


--Sig_//V.VZjYGTZON/znN6E30noc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGqMXDnsnt1WYoG5AQLWjA//YiZq8SJJYRQBOIPaHGTqjcDjeafS8osx
poLUa9Uka2K6fyvp5a4/u4ylbJ2mH5EGEJtI9AUh7neRALuoUCTmcxiuZ8BXTeRO
NozsEYydUqqemirs0I5ReLi0neZZtahNqTwd7CuOoiXRg/N8Wl8m+X0rsfvUiLz9
r5HPeWOUmTNaYWzXB3bvduY06sg+/Vua/sEp82fYFX+HTvu5OSVHqc2hDN9Ce5Ax
+L9QDEdp5FsWdQq5flgvPTp8mW8o3SAq15pOUpqqDR/FfczE0bn2/hI1lNLdNepH
ZYN982B3ImCOA3cnU+Gy2o6D9MhoZnUOC0RDaqMx/zgqHX9N4H0F73Hl6bh9F/bA
RLp0tZ4I+EP0eBUKI3h5wx0t8jbqYxW2EDzfUm14QABMVUEHCpsIowjhn2sTggmi
xFZplfInqZontxIWyPTkJjA+0KjPRGYP0OFRYTUlA7KzEN35Sooke4pG79YWD7U5
26Und6R5RKV29rdH7YKcDc/rKcwzQCftxI0FILP3YJ7edgTPnekwcZ4O9THp+Z5Z
U9fHkC5m0HssBcCrev5JGzBa0yMmRJ7S1KXJTk0rQbnZ7HG2wNx2Kl0awIZtY2XH
eTCAiru8uqHsgPHBkRUE71jM5zhf0yo203WAHtF7rxrpYIwsZ2rWJ1y6gVFNSwCc
ozsiTvQkCbU=
=X/0n
-----END PGP SIGNATURE-----

--Sig_//V.VZjYGTZON/znN6E30noc--
