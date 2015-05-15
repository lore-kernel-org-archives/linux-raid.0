From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V2 01/11] Create n bitmaps for clustered mode
Date: Fri, 15 May 2015 15:45:27 +1000
Message-ID: <20150515154527.7751f765@notabene.brown>
References: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
	<1431075029-5484-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ERn2mP0me5/zVBCrqlwascp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431075029-5484-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/ERn2mP0me5/zVBCrqlwascp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  8 May 2015 16:50:19 +0800 gqjiang@suse.com wrote:

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
>  bitmap.c   |  2 ++
>  bitmap.h   |  7 +++++--
>  mdadm.8.in |  7 ++++++-
>  mdadm.c    |  9 +++++++++
>  super1.c   | 59 +++++++++++++++++++++++++++++++++++++++++---------------=
---
>  6 files changed, 65 insertions(+), 22 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index ef28da0..69f5432 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -750,7 +750,8 @@ int Create(struct supertype *st, char *mddev,
>  #endif
>  	}
> =20
> -	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")=3D=3D0) {
> +	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal")=3D=3D0
> +			|| strcmp(s->bitmap_file, "clustered")=3D=3D0)) {
>  		if ((vers%100) < 2) {
>  			pr_err("internal bitmaps not supported by this kernel.\n");
>  			goto abort_locked;
> diff --git a/bitmap.c b/bitmap.c
> index b1d54a6..920033a 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -32,6 +32,8 @@ inline void sb_le_to_cpu(bitmap_super_t *sb)
>  	sb->daemon_sleep =3D __le32_to_cpu(sb->daemon_sleep);
>  	sb->sync_size =3D __le64_to_cpu(sb->sync_size);
>  	sb->write_behind =3D __le32_to_cpu(sb->write_behind);
> +	sb->nodes =3D __le32_to_cpu(sb->nodes);
> +	sb->sectors_reserved =3D __le32_to_cpu(sb->sectors_reserved);
>  }
> =20
>  inline void sb_cpu_to_le(bitmap_super_t *sb)
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
> =20
>  /* notes:
> diff --git a/mdadm.8.in b/mdadm.8.in
> index a630310..4aec0db 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -694,7 +694,12 @@ and so is replicated on all devices.  If the word
>  .B "none"
>  is given with
>  .B \-\-grow
> -mode, then any bitmap that is present is removed.
> +mode, then any bitmap that is present is removed. If the word
> +.B "clustered"
> +is given, the array is created for a clustered environment. One bitmap
> +is created for each node as defined by the
> +.B \-\-nodes
> +parameter and are stored internally.
> =20
>  To help catch typing errors, the filename must contain at least one
>  slash ('/') if it is a real file (not 'internal' or 'none').
> diff --git a/mdadm.c b/mdadm.c
> index 3e8c49b..bd9382e 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1097,6 +1097,15 @@ int main(int argc, char *argv[])
>  				s.bitmap_file =3D optarg;
>  				continue;
>  			}
> +			if (strcmp(optarg, "clustered")=3D=3D 0) {
> +				s.bitmap_file =3D optarg;
> +				/* Set the default number of cluster nodes
> +				 * to 4 if not already set by user
> +				 */
> +				if (c.nodes < 1)
> +					c.nodes =3D 4;
> +				continue;
> +			}


Please make sure than mdadm compiles after each patch is applied.
You don't defined that 'nodes' field until a later patch.

NeilBrown


>  			/* probable typo */
>  			pr_err("bitmap file must contain a '/', or be 'internal', or 'none'\n"
>  				"       not '%s'\n", optarg);
> diff --git a/super1.c b/super1.c
> index f0508fe..57b1526 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2144,6 +2144,10 @@ add_internal_bitmap1(struct supertype *st,
>  	bms->daemon_sleep =3D __cpu_to_le32(delay);
>  	bms->sync_size =3D __cpu_to_le64(size);
>  	bms->write_behind =3D __cpu_to_le32(write_behind);
> +	bms->nodes =3D __cpu_to_le32(st->nodes);
> +	if (st->cluster_name)
> +		strncpy((char *)bms->cluster_name,
> +				st->cluster_name, strlen(st->cluster_name));
> =20
>  	*chunkp =3D chunk;
>  	return 1;
> @@ -2177,6 +2181,7 @@ static int write_bitmap1(struct supertype *st, int =
fd)
>  	void *buf;
>  	int towrite, n;
>  	struct align_fd afd;
> +	unsigned int i;
> =20
>  	init_afd(&afd, fd);
> =20
> @@ -2185,27 +2190,45 @@ static int write_bitmap1(struct supertype *st, in=
t fd)
>  	if (posix_memalign(&buf, 4096, 4096))
>  		return -ENOMEM;
> =20
> -	memset(buf, 0xff, 4096);
> -	memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
> -
> -	towrite =3D __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksi=
ze)>>9);
> -	towrite =3D (towrite+7) >> 3; /* bits to bytes */
> -	towrite +=3D sizeof(bitmap_super_t);
> -	towrite =3D ROUND_UP(towrite, 512);
> -	while (towrite > 0) {
> -		n =3D towrite;
> -		if (n > 4096)
> -			n =3D 4096;
> -		n =3D awrite(&afd, buf, n);
> -		if (n > 0)
> -			towrite -=3D n;
> +	/* We use bms->nodes as opposed to st->nodes to
> +	 * be compatible with write-after-reads such as
> +	 * the GROW operation.
> +	 */
> +	for (i =3D 0; i < __le32_to_cpu(bms->nodes); i++) {
> +		/* Only the bitmap[0] should resync
> +		 * whole device on initial assembly
> +		 */
> +		if (i)
> +			memset(buf, 0x00, 4096);
>  		else
> +			memset(buf, 0xff, 4096);
> +		memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
> +
> +		towrite =3D __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunks=
ize)>>9);
> +		towrite =3D (towrite+7) >> 3; /* bits to bytes */
> +		towrite +=3D sizeof(bitmap_super_t);
> +		/* we need the bitmaps to be at 4k boundary */
> +		towrite =3D ROUND_UP(towrite, 4096);
> +		while (towrite > 0) {
> +			n =3D towrite;
> +			if (n > 4096)
> +				n =3D 4096;
> +			n =3D awrite(&afd, buf, n);
> +			if (n > 0)
> +				towrite -=3D n;
> +			else
> +				break;
> +			if (i)
> +				memset(buf, 0x00, 4096);
> +			else
> +				memset(buf, 0xff, 4096);
> +		}
> +		fsync(fd);
> +		if (towrite) {
> +			rv =3D -2;
>  			break;
> -		memset(buf, 0xff, 4096);
> +		}
>  	}
> -	fsync(fd);
> -	if (towrite)
> -		rv =3D -2;
> =20
>  	free(buf);
>  	return rv;


--Sig_/ERn2mP0me5/zVBCrqlwascp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVWH9znsnt1WYoG5AQI39A/+JdP4oQEBswQ3iuK2rIvHMiKvTJ1VilgX
AVs2luJ0vABHGMB950VRLFuyNpwRm/nfXYZH7TsEOiYwu4W9Q7ZpXk42baQNLpFC
uZuknoYZ5WCfcNej0kKUcxK6k7LIEG6n7um4Qm/kdvV2zlL1fk/Fnuwv7/KBCCNT
aJd+5pH25UgrST7bgIYjHaBakvHgtgSr7AEhkBS+h2OEfmXqH14bUFwXdGxJWglC
oqNjN6QCZ4x2fykhCX0iVnZJH2lhQVjqz9fGAP17ntcpiRWor9WDC4+kdfPpU/er
PXW95rMQ+cw2fzZfejTHSEaTv9OQlpSOwMkLX2rMn1iWuJTyjo/wiEqpfaRhaf1G
ijEX0prz5nro6eirRh707gcO402LbIzATPOvzys8ykPOC80GqA3xBu6Qkqe50BXu
IFOj84erT6CSA8y43UTDIGitY7pKSWVrpoF6DBqQPgYNQw0WeF6lHMXA4cIpXGJP
eTMYYXg0mQuY+d3rjldIpjK/l2/VklMz/lw/zjG/osxWMdan4EPjZsQGZoKtpmDA
5okTLQ4KP1KdncCImS4qPs6hfcqHcwmra6E3erxK24byiilJXz4U5fOeVpWzLao0
8mgBFmN5SNkREQx8LP+bBkQMMp6ihfZ30W+VwBXCuVBUYT/4wBQMqA4STyAJe/6a
8N90IQS1geU=
=r/qg
-----END PGP SIGNATURE-----

--Sig_/ERn2mP0me5/zVBCrqlwascp--
