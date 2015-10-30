From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH] [mdadm] add crc32c and use it for r5l checksum
Date: Fri, 30 Oct 2015 17:39:09 +1100
Message-ID: <87fv0sx3le.fsf@notabene.neil.brown.name>
References: <1446059166-1376285-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446059166-1376285-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29 2015, Song Liu wrote:

> In kernel space, r5l checksum will use crc32c:
> http://marc.info/?l=3Dlinux-raid&m=3D144598970529191
> mdadm need to change too.
>
> This patch ports a simplified crc32c algorithm from kernel code,
> and used in super1.c:write_empty_r5l_meta_block();
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>


applied, thanks.

NeilBrown

> ---
>  Makefile |   2 +-
>  crc32c.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  super1.c |  11 +++----
>  3 files changed, 109 insertions(+), 8 deletions(-)
>  create mode 100644 crc32c.c
>
> diff --git a/Makefile b/Makefile
> index 544e6cb..fde2e63 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -133,7 +133,7 @@ OBJS =3D  mdadm.o config.o policy.o mdstat.o  ReadMe.=
o util.o maps.o lib.o \
>  	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
>  	super-mbr.o super-gpt.o \
>  	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
> -	platform-intel.o probe_roms.o
> +	platform-intel.o probe_roms.o crc32c.o
>=20=20
>  CHECK_OBJS =3D restripe.o sysfs.o maps.o lib.o xmalloc.o dlink.o
>=20=20
> diff --git a/crc32c.c b/crc32c.c
> new file mode 100644
> index 0000000..156cba1
> --- /dev/null
> +++ b/crc32c.c
> @@ -0,0 +1,104 @@
> +/*
> + * Oct 28, 2015 Song Liu simplified the code and port it to mdadm
> + *
> + * Aug 8, 2011 Bob Pearson with help from Joakim Tjernlund and George Sp=
elvin
> + * cleaned up code to current version of sparse and added the slicing-by=
-8
> + * algorithm to the closely similar existing slicing-by-4 algorithm.
> + *
> + * Oct 15, 2000 Matt Domsch <Matt_Domsch@dell.com>
> + * Nicer crc32 functions/docs submitted by linux@horizon.com.  Thanks!
> + * Code was from the public domain, copyright abandoned.  Code was
> + * subsequently included in the kernel, thus was re-licensed under the
> + * GNU GPL v2.
> + *
> + * Oct 12, 2000 Matt Domsch <Matt_Domsch@dell.com>
> + * Same crc32 function was used in 5 other places in the kernel.
> + * I made one version, and deleted the others.
> + * There are various incantations of crc32().  Some use a seed of 0 or ~=
0.
> + * Some xor at the end with ~0.  The generic crc32() function takes
> + * seed as an argument, and doesn't xor at the end.  Then individual
> + * users can do whatever they need.
> + *   drivers/net/smc9194.c uses seed ~0, doesn't xor with ~0.
> + *   fs/jffs2 uses seed 0, doesn't xor with ~0.
> + *   fs/partitions/efi.c uses seed ~0, xor's with ~0.
> + *
> + * This source code is licensed under the GNU General Public License,
> + * Version 2.  See the file COPYING for more details.
> + */
> +
> +#include <sys/types.h>
> +#include <asm/types.h>
> +#include <stdlib.h>
> +
> +/*
> + * There are multiple 16-bit CRC polynomials in common use, but this is
> + * *the* standard CRC-32 polynomial, first popularized by Ethernet.
> + * x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x^1+x^0
> + */
> +#define CRCPOLY_LE 0xedb88320
> +#define CRCPOLY_BE 0x04c11db7
> +
> +/*
> + * This is the CRC32c polynomial, as outlined by Castagnoli.
> + * x^32+x^28+x^27+x^26+x^25+x^23+x^22+x^20+x^19+x^18+x^14+x^13+x^11+x^10=
+x^9+
> + * x^8+x^6+x^0
> + */
> +#define CRC32C_POLY_LE 0x82F63B78
> +
> +/**
> + * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN=
 II
> + *			CRC32/CRC32C
> + * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for o=
ther
> + *	 uses, or the previous crc32/crc32c value if computing incrementally.
> + * @p: pointer to buffer over which CRC32/CRC32C is run
> + * @len: length of buffer @p
> + * @polynomial: CRC32/CRC32c LE polynomial
> + */
> +static inline __u32 crc32_le_generic(__u32 crc, unsigned char const *p,
> +				     size_t len, __u32 polynomial)
> +{
> +	int i;
> +	while (len--) {
> +		crc ^=3D *p++;
> +		for (i =3D 0; i < 8; i++)
> +			crc =3D (crc >> 1) ^ ((crc & 1) ? polynomial : 0);
> +	}
> +	return crc;
> +}
> +
> +__u32 crc32_le(__u32 crc, unsigned char const *p, size_t len)
> +{
> +	return crc32_le_generic(crc, p, len, CRCPOLY_LE);
> +}
> +
> +__u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len)
> +{
> +	return crc32_le_generic(crc, p, len, CRC32C_POLY_LE);
> +}
> +
> +/**
> + * crc32_be_generic() - Calculate bitwise big-endian Ethernet AUTODIN II=
 CRC32
> + * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
> + *	other uses, or the previous crc32 value if computing incrementally.
> + * @p: pointer to buffer over which CRC32 is run
> + * @len: length of buffer @p
> + * @polynomial: CRC32 BE polynomial
> + */
> +static inline __u32 crc32_be_generic(__u32 crc, unsigned char const *p,
> +				     size_t len, __u32 polynomial)
> +{
> +	int i;
> +	while (len--) {
> +		crc ^=3D *p++ << 24;
> +		for (i =3D 0; i < 8; i++)
> +			crc =3D
> +			    (crc << 1) ^ ((crc & 0x80000000) ? polynomial :
> +					  0);
> +	}
> +	return crc;
> +}
> +
> +__u32 crc32_be(__u32 crc, unsigned char const *p, size_t len)
> +{
> +	return crc32_be_generic(crc, p, len, CRCPOLY_BE);
> +}
> diff --git a/super1.c b/super1.c
> index 58e6f9d..1735c2d 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1625,10 +1625,7 @@ static unsigned long choose_bm_space(unsigned long=
 devsize)
>  static void free_super1(struct supertype *st);
>=20=20
>  #define META_BLOCK_SIZE 4096
> -unsigned long crc32(
> -	unsigned long crc,
> -	const unsigned char *buf,
> -	unsigned len);
> +__u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
>=20=20
>  static int write_empty_r5l_meta_block(struct supertype *st, int fd)
>  {
> @@ -1652,9 +1649,9 @@ static int write_empty_r5l_meta_block(struct supert=
ype *st, int fd)
>  	mb->seq =3D __cpu_to_le64(random32());
>  	mb->position =3D __cpu_to_le64(0);
>=20=20
> -	crc =3D crc32(0xffffffff, sb->set_uuid, sizeof(sb->set_uuid));
> -	crc =3D crc32(crc, (void *)mb, META_BLOCK_SIZE);
> -	mb->checksum =3D __cpu_to_le32(crc);
> +	crc =3D crc32c_le(0xffffffff, sb->set_uuid, sizeof(sb->set_uuid));
> +	crc =3D crc32c_le(crc, (void *)mb, META_BLOCK_SIZE);
> +	mb->checksum =3D crc;
>=20=20
>  	if (lseek64(fd, (sb->data_offset) * 512, 0) < 0LL) {
>  		pr_err("cannot seek to offset of the meta block\n");
> --=20
> 2.4.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWMxCNAAoJEDnsnt1WYoG5iWsQAK7UW1XcFmRaEAVuUchSPzwx
A5lIeqqvkAQPkU4NqGII5e0RobkpO7hlTCffUjkaDdFD0Ii3odavOwO3r2ZrldjZ
xcn7mtQNFhCXP7mcZmnGsT9c43te+PJyNQDWEJCI8rNxxKU6KvzFP4GwbQTdpJ4C
ZIn+QeMxMxfmRczkSmryU7SLXvcFRGkQw5bRaKAekmWfUt7S3zUY+sdqo1gXDR0Q
58diYP7wq6JiB6fd03zoORZuZMZuRk+fR1pWmr1B7It+SuzxWTKJnKFO22btZA0h
17DCBlH6kEmSkRUiRDzRrW9uh/W+qLbkJpphWXcL1zlenyzOS3FQiRlPaCjI46jb
C25dXun++smdvcIJefL8FdaVWM45ODHix/REq88QXxnI5WjVA8luP9jw1JY1jzaa
+LsoyQWWASpdYUGHeQ4nxw3dIjENBKeD9bszQbs46D1eJgCIEiE2I8zF3IIDOHOR
mQ9Pfb/jfdh9QtbdRfikmnwloSivI9IfAmPB/wOXFPlb7efvg97uadMSoZZFLOUj
QTOUPeEfInNajNL9CXxl3iVlCTarFE6NanjvoV4mUH/URMom46ONVA+fiSJ4gZCN
9UCTgTwlGE/S4PFGU2sr+vbbuADg7lPp6AcsTD9yGnOhCI77dacjO1IaxKHZ4wo+
JpILjZRwQU/yAJgQPRPC
=XvRh
-----END PGP SIGNATURE-----
--=-=-=--
