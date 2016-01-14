From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH V2 2/2] Add casts for the addr arg of connect and bind
Date: Fri, 15 Jan 2016 08:37:30 +1100
Message-ID: <87twmf6dwl.fsf@notabene.neil.brown.name>
References: <1452753159-1527-1-git-send-email-raj.khem@gmail.com> <1452753159-1527-2-git-send-email-raj.khem@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1452753159-1527-2-git-send-email-raj.khem@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khem Raj <raj.khem@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Jan 14 2016, Khem Raj wrote:

> glibc allows the addr arg to connect and socket to be any of a number
> of 'sockaddr_*' types, but musl requires 'const struct sockaddr *'
> which is in line with open group specs.  So add casts to allow
> compilation with musl.
>
> Signed-off-by: Khem Raj <raj.khem@gmail.com>

Thanks a lot!  Both patches applied.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWmBUaAAoJEDnsnt1WYoG5kx8P/1FhgymTVkFt4Lziq+P88qWI
OgNW+8wcpt8dbEn86NyC6TEPO+f9al3qbDW3CoKTCYDub+w3lST+GDYWcDfGKGhU
Fl6tSCW4q+Ailk/0d4WZU2nNAaSSUDniHjjIR/6As9bIKzCrbXnRav3UruBWBCIr
wB6ADSbRLcAB1l3TAR72GgsovGscTvj76xSYVt93Ml0+0VYWjx+fVcWlTxpnis96
nZPiKzObPWhLdNZODrGGXIt6fDqqRYqvadGS54brPT7UqSfCq8d/lHn2f4fT0MYa
tE2uc4wtme8SttSHSTBjIQVucwn3g/YU9Qcjl7Nr3zBItQC2shtf/ESglkTiP/WN
kD9m0As4ZUl0yxDU01nZSYjS2NstNcqA0l2r0UmYpZAe+4znpO1mF8efKVCL1T4+
skKk2vxRztlmWQ/i3wcUiKwJS9HfgmzqXIMuk9rOc30Wjj4+ViQvdY3pxfqi0OQx
aQ77eb7jFDohNiSuYBIY4IUwcleF+O7N0wV0YdoFJJBZZAQ4+pXd+S4bwmU88PIm
AE4AAwWCjISGbOO+xTb9EYloHUt0JazFGvCJJZCAMEs61xxpr/E3E0AZe641mt1s
LOdu+cjHAum9QjYN39TUDJamOXkZ8U+JQXmcg1fCcNKiM5fze7F3H5p9gHHqmrSW
sMCb7vWphpiKlEKGoN7b
=qOa8
-----END PGP SIGNATURE-----
--=-=-=--
