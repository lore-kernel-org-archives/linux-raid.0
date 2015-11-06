From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH] raid5-cache: add crc32c Kconfig dependency
Date: Fri, 06 Nov 2015 14:19:11 +1100
Message-ID: <87si4jak7k.fsf@notabene.neil.brown.name>
References: <4308930.z8rrqMJU90@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4308930.z8rrqMJU90@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shaohua Li <shli@fb.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Nov 04 2015, Arnd Bergmann wrote:

> The recent change of the raid5-cache code to use crc32c instead
> of crc32 causes link errors when CONFIG_LIBCRC32C is disabled:
>
> drivers/built-in.o: In function crc32c'
> core.c:(.text+0x1c6060): undefined reference to `crc32c'
>
> This adds an explicit 'select' statement like all other users
> of this function do.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 5cb2fbd6ea0d ("raid5-cache: use crc32c checksum")
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 3e01e6fb3424..7913fdcfc849 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -123,6 +123,7 @@ config MD_RAID456
>  	tristate "RAID-4/RAID-5/RAID-6 mode"
>  	depends on BLK_DEV_MD
>  	select RAID6_PQ
> +	select LIBCRC32C
>  	select ASYNC_MEMCPY
>  	select ASYNC_XOR
>  	select ASYNC_PQ

Applied, thanks,

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWPBwvAAoJEDnsnt1WYoG563QP/ApICb4fLwIoz9j3sTkhw+uY
mJnjy9DLY2bmJl7C0JOB6+fY4WJqXMTSVHLs9XKa51SriVuxUxmsNB6ydGHSEOdk
Z4E0aNh/PO4QixNh3cMVsAgBMwUISHKWjiiGXLk9qQUoFUTPSJMDE/tUJ57ZEKuy
cIjLbQ6mFCE8JolTRQAWvNOzT5DxhhjfmQ3HJMTPGQtT906QhiWCPLt8pECo+kfP
wP0ONySt5In0m3lE8DNnyk8DwTkC1pvLRJ1UXGSo555na7nVickVp87TdDUfqTd+
OP6xUbmpFgOUUeeaseHOBGJDc/PaNeZR//s0ZjEsVJ/Gqpdx16NdeKwlumv91F7g
WDJ4qBYkOPA9vrzy2tBwBJayFQ/quh2OKjuF0JxUxgDjCEi0Ry1a2Sc3I/UNv2pL
YX97YXCzynUJGbH9gsi6PLM2Bc7dP+eaps2cpXm2Z58sYTWQxbFqQuQ8SOGUYEEN
dUZl3gMjshADXYiQOJPFaQMRcSU7aqxN3ApJfe4KWkyrnyDvHloKhSddutdgIsp6
/mgf5WucqNDNFVViB/WaoK1MQzHVIkIymeD7fR0XKGvIGSfTn3iWdlpx84xxFmt5
o1zWGqvwRaoyfwTiTik+YrHSB8HvGURCWFMt+KY/nWtTxOOXG6pI6HPNc0xCcNnW
QvZ2bj28DwrVSnA5S+3d
=Hwq2
-----END PGP SIGNATURE-----
--=-=-=--
