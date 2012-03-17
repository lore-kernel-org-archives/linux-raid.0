From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH 2/3] lib/raid6: update test program recovery functions
Date: Sat, 17 Mar 2012 09:52:24 +0100
Message-ID: <1331974344.3602.4.camel@mattotaupa>
References: <1331939167-10787-1-git-send-email-james.t.kukunas@linux.intel.com>
	 <1331939167-10787-3-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zfBypZVrPlLAKHLcXGXK"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1331939167-10787-3-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org, hpa@zytor.com
List-Id: linux-raid.ids


--=-zfBypZVrPlLAKHLcXGXK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Jim,


Am Freitag, den 16.03.2012, 16:06 -0700 schrieb Jim Kukunas:
> Test each combination of recovery and syndrome generation
> functions.
>=20
> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> ---
>  lib/raid6/algos.c     |    2 +-
>  lib/raid6/test/test.c |   32 +++++++++++++++++++++-----------
>  lib/raid6/x86.h       |   13 ++++++++-----
>  3 files changed, 30 insertions(+), 17 deletions(-)
>=20
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index a3ac58a..82cdd01 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -17,12 +17,12 @@
>   */
> =20
>  #include <linux/raid/pq.h>
> -#include <linux/module.h>
>  #include "x86.h"
>  #ifndef __KERNEL__
>  #include <sys/mman.h>
>  #include <stdio.h>
>  #else
> +#include <linux/module.h>

that change is not mentioned in the commit message as far as I can see.

>  #include <linux/gfp.h>
>  #if !RAID6_USE_EMPTY_ZERO_PAGE
>  /* In .bss so it's zeroed */

[=E2=80=A6]


Thanks,

Paul

--=-zfBypZVrPlLAKHLcXGXK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk9kUMgACgkQPX1aK2wOHVgTaQCePzdsk2aZGCK68lzHunzutu/p
WtUAn0Aor5nZkoEmz22Iv5Ad93m48hnK
=IQ9G
-----END PGP SIGNATURE-----

--=-zfBypZVrPlLAKHLcXGXK--

