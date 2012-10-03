From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Add zlib license to crc32.c
Date: Wed, 3 Oct 2012 18:17:48 +1000
Message-ID: <20121003181748.5ddfc981@notabene.brown>
References: <1349251234-1703-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4KUmatIvAFZ13v3yFmyOo=k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1349251234-1703-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4KUmatIvAFZ13v3yFmyOo=k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Oct 2012 10:00:34 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  crc32.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>=20
> diff --git a/crc32.c b/crc32.c
> index 12d08e5..94fda06 100644
> --- a/crc32.c
> +++ b/crc32.c
> @@ -2,6 +2,26 @@
>   * Copyright (C) 1995-2003 Mark Adler
>   * For conditions of distribution and use, see copyright notice in zlib.h
>   *
> + * Note: zlib license from from zlib.h added explicitly as mdadm does
> + *       not include zlib.h. License from v1.2.2 of zlib:
> + *
> + *  This software is provided 'as-is', without any express or implied
> + *  warranty.  In no event will the authors be held liable for any damag=
es
> + *  arising from the use of this software.
> + *
> + *  Permission is granted to anyone to use this software for any purpose,
> + *  including commercial applications, and to alter it and redistribute =
it
> + *  freely, subject to the following restrictions:
> + *
> + *  1. The origin of this software must not be misrepresented; you must =
not
> + *     claim that you wrote the original software. If you use this softw=
are
> + *     in a product, an acknowledgment in the product documentation woul=
d be
> + *     appreciated but is not required.
> + *  2. Altered source versions must be plainly marked as such, and must =
not be
> + *     misrepresented as being the original software.
> + *  3. This notice may not be removed or altered from any source distrib=
ution.
> + *
> + *
>   * Thanks to Rodney Brown <rbrown64@csc.com.au> for his contribution of =
faster
>   * CRC methods: exclusive-oring 32 bits of data at a time, and pre-compu=
ting
>   * tables for updating the shift register in one step with three exclusi=
ve-ors

Applied, thanks.

NeilBrown


--Sig_/4KUmatIvAFZ13v3yFmyOo=k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGv0rDnsnt1WYoG5AQI1zBAAtXSjt5kzsHwuZIP3PtTz/RF+xQFs1sCb
1LVNMof+PEcaFf9qd7ASKDK5mjWQwPsGhXWNo5k9jGD58uTRFMhdMlKd/468qmMY
6nwymViMtwRMJoa4wco9kUi7ZCAycfn8Ym8eszJ/b7mgGoV784Jo8peQ0H8NQF01
7UKAhQI6xJ6Gw179ljlWkzdltJ52J13rWSXfN91/1sqCHFzytstZaPbV3ioxzN4y
40eDZAC8pcTluE55ImdHISS7FFprjupZNRWqWYEDuM2mpXr8i6rSPhjxmtbKims7
DCG4iIrgB9mj1WOg0cE4loMYrjofkTiM8ynjfv9LD5+PvtdE8KVlxw06MW86ApOL
tzyejmfAqTOLB2Vg3cg5Q8MAqlKDUcUH+dEiX7h10+5LS8tKKJfTYzHRPWd5On2k
WM1F0tiwTGwTPvNKOmw3j1jM8MpVWq0sFz3kzdpBwykA2ZUyZatMwO4dDYh1oJbz
hhmSjff45pM5B52An9DbxzY7+j9kTl7dhsLY1VU4U9UetMn3yVXKrEG8aGM0ajy7
zPeCIQu1w29qL5/nZU/nTLd6sVZkE7RNwGpuIvUrDGgN+H0Kj/lxOjoxDuTxlgTf
vyMaJ4mzxS1Cgja0q6edC8sjSoY2q3JQFqcQMM+G9HwplN7zvwtwwtAw4asKfrPB
fZUGc2F7HI8=
=tU9a
-----END PGP SIGNATURE-----

--Sig_/4KUmatIvAFZ13v3yFmyOo=k--
