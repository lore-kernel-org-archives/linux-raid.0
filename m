From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 03/10] Create n bitmaps for clustered mode
Date: Wed, 29 Apr 2015 11:41:15 +1000
Message-ID: <20150429114115.2265643f@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-4-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/l415OMzyoECZ+AqKJjK9.SO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-4-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/l415OMzyoECZ+AqKJjK9.SO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 15:30:34 +0800 gqjiang@suse.com wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>=20
> For a clustered MD, create bitmaps equal to number of nodes so
> each node has an independent bitmap.
>=20
> Only the first bitmap is has the bits set so that the first node
> that assembles the device also performs the sync.
>=20
> The bitmaps are aligned to 4k boundaries.
>=20
> On-disk format:
>=20
> 0                    4k                     8k                    12k
> -------------------------------------------------------------------
> | idle                | md super            | bm super [0] + bits |
> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
> | bm bits [3, contd]  |                     |                     |
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Create.c   |  3 ++-
>  bitmap.h   |  7 +++++--
>  mdadm.8.in |  7 ++++++-
>  mdadm.c    | 17 ++++++++++++++++-
>  super1.c   | 59 +++++++++++++++++++++++++++++++++++++++++---------------=
---
>  5 files changed, 70 insertions(+), 23 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index cd5485b..9663dc4 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -752,7 +752,8 @@ int Create(struct supertype *st, char *mddev,
>  #endif
>  	}
> =20
> -	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")=3D=3D0) {
> +	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal")=3D=3D0
> +			|| strcmp(s->bitmap_file, "clustered")=3D=3D0)) {
>  		if ((vers%100) < 2) {
>  			pr_err("internal bitmaps not supported by this kernel.\n");
>  			goto abort_locked;
> diff --git a/bitmap.h b/bitmap.h
> index c8725a3..adbf0b4 100644
> --- a/bitmap.h
> +++ b/bitmap.h
> @@ -154,8 +154,11 @@ typedef struct bitmap_super_s {
>  	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
>  	__u32 daemon_sleep; /* 56  seconds between disk flushes */
>  	__u32 write_behind; /* 60  number of outstanding write-behind writes */
> -
> -	__u8  pad[256 - 64]; /* set to zero */
> +	__u32 sectors_reserved; /* 64 number of 512-byte sectors that are
> +				 * reserved for the bitmap. */
> +	__u32 nodes;        /* 68 the maximum number of nodes in cluster. */
> +	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
> +	__u8  pad[256 - 136]; /* set to zero */
>  } bitmap_super_t;

I missed this the first time, but these fields that you have added need to =
be
added to sb_le_to_cpu().

NeilBrown

--Sig_/l415OMzyoECZ+AqKJjK9.SO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUA2vDnsnt1WYoG5AQLlaRAApjxv5tt9HsNQMBRP3frHURHLMjJN7PaT
eChSGNxxlKJxI0MEHpgwy8hdgktB7pDKm4EvPc2HLc9oc0/fWyYp5l7XiJrVgGMm
FLBGkmCBRN/+BxJsxhPjQIY2xS8zkrHQIHABys2JSXBRVDAi1HmPUkZRL53pj4tC
As/ogBA8V5JFYdI82YSY6JmYmaOb2mTp9K8uTACGqVud9S2H9VNc8AmDK/GhYo4y
YL7mqrtkQBjlYwMxU1s+VUoJd8IZ+i3a2un1hTqJ27XAF1NMZp70j7MWDV6Ep5ws
eG8tuPvdgJt49ic90qEFas7WuHW20Vwf0zO1IlIG3IJIKZFaPU+jCYKQJYTJ7R6b
sO1kFiFIXB5YrNWqAo3z2vioLIMDfamRBm9oTVpXr6sbbWIUnOXcIMha8ahKmrpU
CBCmCqwJL4Zn5x+YZsH21XF6V2FuJAaDnkPb7tBJTb4hd4wX5ZcGTP4DncbOW7+f
wgRpvAXqTD1Bc67AZ1iM1pBWt4Sm4A6cNwnnF+4zhBE4hIEfFIRwVisFtrXTRaVE
UQeZd+oRsoWs/3wQlbQT2jWsLwP5xlZ520lB0Qbdm2uyRq3erjlroarEml4lXB8u
m7sdMq4A6ofNzO4e6c5DwpmBEMnJL5VVzwpfzJFep8vOOlS1sEbXwCwAS3/cMQ3y
YV3twcHqjjg=
=YOA5
-----END PGP SIGNATURE-----

--Sig_/l415OMzyoECZ+AqKJjK9.SO--
