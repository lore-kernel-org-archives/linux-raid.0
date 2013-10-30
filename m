From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] UAPI: include <asm/byteorder.h> in linux/raid/md_p.h
Date: Wed, 30 Oct 2013 17:20:13 +1100
Message-ID: <20131030172013.5dae6baa@notabene.brown>
References: <1383049738-26107-1-git-send-email-aurelien@aurel32.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BoZeLe+eLDx7Lq5nEa1mtAt"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383049738-26107-1-git-send-email-aurelien@aurel32.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BoZeLe+eLDx7Lq5nEa1mtAt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Oct 2013 13:28:58 +0100 Aurelien Jarno <aurelien@aurel32.net>
wrote:

> linux/raid/md_p.h is using conditionals depending on endianess and fails
> with an error if neither of __BIG_ENDIAN, __LITTLE_ENDIAN or
> __BYTE_ORDER are defined, but it doesn't include any header which can
> define these constants. This make this header unusable alone.
>=20
> This patch adds a #include <asm/byteorder.h> at the beginning of this
> header to make it usable alone. This is needed to compile klibc on MIPS.
>=20
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  include/uapi/linux/raid/md_p.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_=
p.h
> index fe1a540..f7cf7f3 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -16,6 +16,7 @@
>  #define _MD_P_H
> =20
>  #include <linux/types.h>
> +#include <asm/byteorder.h>
> =20
>  /*
>   * RAID superblock.

Makes sense.  Applied.  Thanks.

NeilBrown

--Sig_/BoZeLe+eLDx7Lq5nEa1mtAt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnClHTnsnt1WYoG5AQIZjQ/6ApB1MiVjgr2VudIXjtKuWI5DYuvcNtsc
C4P7eb18GEAk1ePnDtkUZJRq8UH9QjLKo9L9pYyaydKOCQ1M/WFpbK7G+ZUeRkd+
fLE6kudhhcQUOMfAtHZ8RtNE6mZEop7tOPOzws+PHVZup6jXGEcOqtAVMyHioyyJ
2U7HBwwsZfF8CB8pkTt7awJzDB45bFLDlIIq4YpiM9CiGybLU34Y6UpRrZ/reWAC
bcb6LPnhLHl5rYyO4AEXWixe0l1Uxqm0k4UPb4JJg1eDgiY69Pk/VnQqi2H8StJN
m36BQfqqnNevd45/hR1OuUxfI+PFIGeDeWOmQVo1vrIbRJtm3NyKdMgW6RsBlEa9
9FQ2erL81E21jZHMOIhI+kORLNwP4gPR34Vf0/dC39Rj2pcvJaH443uh7Xi5YLlq
k32yvWybqeCGoa8QCzVlbN9YLLj4DOslXF4i9v0jvkHgvPNqeuGpcbWuOGSeFDWW
glvh58/ribbXKP+raUIfQ2g+V4340XaF8Samdl9dtI4TsHeAe+kFR85YoSUK0/u6
NgCFnY3Zai2XBtTywDCUTuMXPH1pejrFf7qrmfhlUTYLBRyHPOJXhHvAlmp19ju2
h9iZdGANfs4tcQvZZReK/0FMwI3AsdHxwr4vgNFJVcGi1HHc5XJqu1K6EeQjIakm
TwSMdsojpS0=
=l1Mz
-----END PGP SIGNATURE-----

--Sig_/BoZeLe+eLDx7Lq5nEa1mtAt--
