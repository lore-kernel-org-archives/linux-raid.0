From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] lib/raid6: fix sparse warnings in recovery functions
Date: Thu, 24 May 2012 15:15:26 +1000
Message-ID: <20120524151526.1f9b5f85@notabene.brown>
References: <1337835258-26903-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YP0sC4ensVKxUShOhiubISZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1337835258-26903-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org, fengguang.wu@intel.com
List-Id: linux-raid.ids

--Sig_/YP0sC4ensVKxUShOhiubISZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 May 2012 21:54:18 -0700 Jim Kukunas
<james.t.kukunas@linux.intel.com> wrote:

> Make the recovery functions static to fix the following sparse warnings:
>=20
> lib/raid6/recov.c:25:6: warning: symbol 'raid6_2data_recov_intx1' was
> not declared. Should it be static?
> lib/raid6/recov.c:69:6: warning: symbol 'raid6_datap_recov_intx1' was
> not declared. Should it be static?
> lib/raid6/recov_ssse3.c:22:6: warning: symbol 'raid6_2data_recov_ssse3'
> was not declared. Should it be static?
> lib/raid6/recov_ssse3.c:197:6: warning: symbol 'raid6_datap_recov_ssse3'
> was not declared. Should it be static?
>=20
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> ---
>  lib/raid6/recov.c       |    7 ++++---
>  lib/raid6/recov_ssse3.c |    7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/lib/raid6/recov.c b/lib/raid6/recov.c
> index 1805a5c..a95bccb 100644
> --- a/lib/raid6/recov.c
> +++ b/lib/raid6/recov.c
> @@ -22,8 +22,8 @@
>  #include <linux/raid/pq.h>
> =20
>  /* Recover two failed data blocks. */
> -void raid6_2data_recov_intx1(int disks, size_t bytes, int faila, int fai=
lb,
> -		       void **ptrs)
> +static void raid6_2data_recov_intx1(int disks, size_t bytes, int faila,
> +		int failb, void **ptrs)
>  {
>  	u8 *p, *q, *dp, *dq;
>  	u8 px, qx, db;
> @@ -66,7 +66,8 @@ void raid6_2data_recov_intx1(int disks, size_t bytes, i=
nt faila, int failb,
>  }
> =20
>  /* Recover failure of one data block plus the P block */
> -void raid6_datap_recov_intx1(int disks, size_t bytes, int faila, void **=
ptrs)
> +static void raid6_datap_recov_intx1(int disks, size_t bytes, int faila,
> +		void **ptrs)
>  {
>  	u8 *p, *q, *dq;
>  	const u8 *qmul;		/* Q multiplier table */
> diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
> index b77266f..ecb0289 100644
> --- a/lib/raid6/recov_ssse3.c
> +++ b/lib/raid6/recov_ssse3.c
> @@ -19,8 +19,8 @@ static int raid6_has_ssse3(void)
>  		boot_cpu_has(X86_FEATURE_SSSE3);
>  }
> =20
> -void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila, int fai=
lb,
> -		       void **ptrs)
> +static void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila,
> +		int failb, void **ptrs)
>  {
>  	u8 *p, *q, *dp, *dq;
>  	const u8 *pbmul;	/* P multiplier table for B data */
> @@ -194,7 +194,8 @@ void raid6_2data_recov_ssse3(int disks, size_t bytes,=
 int faila, int failb,
>  }
> =20
> =20
> -void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila, void **=
ptrs)
> +static void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila,
> +		void **ptrs)
>  {
>  	u8 *p, *q, *dq;
>  	const u8 *qmul;		/* Q multiplier table */


Applied, thanks.

NeilBrown


--Sig_/YP0sC4ensVKxUShOhiubISZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT73D7jnsnt1WYoG5AQJkNA/9HPoLi6se6L4sAAjcS00RXAQ5jPa7dG8N
a/bm94wVMeaH037U5ExbzXFsN1WbVu/i5i31vE4J4bB8cCCCMXStNAdWiXDHHZi8
prZvEhIUyijFCfP+B8u+D8XDBRep4JKjfOlWvz+VwjwTWadlXJT7Bev1YmRCrH+i
34ELA4zMSLXvPoJdr/AsPlxtMt0+Zqb1ln049QtV+/KzBunmhQ/Zmdd6Mum3HFEq
8LrE+GsOSpq/OveEiuUZ8fq/twIT6lyO0zkwlXJiwfUTeipRkCeIncGcW9pUExm/
i3P/TOyQu2IsB47Mf2GGjsmlflvvL8uOIOhk2q6Z7DL2gB+pAputbFeqS5EaBfGM
1PtojXJVtrPuPzO3wN7jioPo0eexqkWFSTSwBSlTNjm+HbbHbT5AMOg2KePEUcQd
EJqjOLx7hlmXEicjnteWqnEDxNWPS0uV+SsiNX9FNpzg9Ewqh157+o6+HuqCn/My
C4NdyzM1EZoBe0IMvcwHUv+wNXPcATW8re3FN/u7r4oSuVNevlkzyLPdVOwXHh36
ppPR0Id3nnsCyhMAciF+pbGBkv3i+IxIZn6lEtNnMijWULSJ1+AbTGF/XrVkV502
XYLK40RrVDjqdx35p3zSmj0jGjsCGJzNvBozmUjOouaOxSNhIykTfVR4Obq8+WKz
KsNyBfYDjTU=
=95Zp
-----END PGP SIGNATURE-----

--Sig_/YP0sC4ensVKxUShOhiubISZ--
