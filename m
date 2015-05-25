From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 09/11] mdadm: change the num of cluster node
Date: Mon, 25 May 2015 14:56:22 +1000
Message-ID: <20150525145622.5e05c1d4@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
	<1432092043-24220-10-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NIXtGsg.pnhlA6t7CH+L466"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-10-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/NIXtGsg.pnhlA6t7CH+L466
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:41 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> This extends nodes option for assemble mode, make the num of
> cluster node could be change by user.
>=20
> Before that, it is necessary to ensure there are enough space
> for those nodes, calc_bitmap_size is introduced to calculate
> the bitmap size of each node.
>=20
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Assemble.c |  4 ++++
>  ReadMe.c   |  2 +-
>  mdadm.c    |  3 +++
>  mdadm.h    |  1 +
>  super1.c   | 37 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 46 insertions(+), 1 deletion(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index e1b846c..9ff546b 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -626,6 +626,10 @@ static int load_devices(struct devs *devices, char *=
devmap,
> =20
>  			if (strcmp(c->update, "byteorder") =3D=3D 0)
>  				err =3D 0;
> +			else if (strcmp(c->update, "nodes") =3D=3D 0) {
> +				tst->nodes =3D c->nodes;
> +				err =3D tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
> +			}
>  			else
>  				err =3D tst->ss->update_super(tst, content, c->update,
>  							    devname, c->verbose,
> diff --git a/ReadMe.c b/ReadMe.c
> index c854cd5..d1830e1 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -140,7 +140,7 @@ struct option long_options[] =3D {
>      {"homehost",  1, 0,  HomeHost},
>      {"symlinks",  1, 0,  Symlinks},
>      {"data-offset",1, 0, DataOffset},
> -    {"nodes",1, 0, Nodes},
> +    {"nodes",1, 0, Nodes}, /* also for --assemble */
>      {"home-cluster",1, 0, ClusterName},
> =20
>      /* For assemble */
> diff --git a/mdadm.c b/mdadm.c
> index 22f4fc7..87c572d 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -589,6 +589,7 @@ int main(int argc, char *argv[])
>  			}
>  			ident.raid_disks =3D s.raiddisks;
>  			continue;
> +		case O(ASSEMBLE, Nodes):
>  		case O(CREATE, Nodes):
>  			c.nodes =3D parse_num(optarg);
>  			if (c.nodes <=3D 0) {
> @@ -744,6 +745,8 @@ int main(int argc, char *argv[])
>  				continue;
>  			if (strcmp(c.update, "home-cluster")=3D=3D0)
>  				continue;
> +			if (strcmp(c.update, "nodes")=3D=3D0)
> +				continue;
>  			if (strcmp(c.update, "devicesize")=3D=3D0)
>  				continue;
>  			if (strcmp(c.update, "no-bitmap")=3D=3D0)
> diff --git a/mdadm.h b/mdadm.h
> index d8b0749..97892e6 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -357,6 +357,7 @@ enum prefix_standard {
>  enum bitmap_update {
>      NoUpdate,
>      NameUpdate,
> +    NodeNumUpdate,
>  };
> =20
>  /* structures read from config file */
> diff --git a/super1.c b/super1.c
> index 07944d4..fe12e81 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -134,6 +134,20 @@ struct misc_dev_info {
>  					|MD_FEATURE_NEW_OFFSET		\
>  					)
> =20
> +/* return how many bytes are needed for bitmap, for cluster-md each node
> + * should have it's own bitmap */
> +static unsigned int calc_bitmap_size(bitmap_super_t *bms, unsigned int b=
oundary)
> +{
> +	unsigned long long bits, bytes;
> +
> +	bits =3D __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)=
>>9);
> +	bytes =3D (bits+7) >> 3;
> +	bytes +=3D sizeof(bitmap_super_t);
> +	bytes =3D ROUND_UP(bytes, boundary);
> +
> +	return bytes;
> +}
> +
>  static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
>  {
>  	unsigned int disk_csum, csum;
> @@ -2201,6 +2215,7 @@ static int write_bitmap1(struct supertype *st, int =
fd, enum bitmap_update update
>  	struct align_fd afd;
>  	unsigned int i =3D 0;
>  	char *new_name;
> +	unsigned long long total_bm_space, bm_space_per_node;
> =20
>  	switch (update) {
>  	case NameUpdate:
> @@ -2217,6 +2232,28 @@ static int write_bitmap1(struct supertype *st, int=
 fd, enum bitmap_update update
> =20
>  	    free(new_name);
>  	    break;
> +	case NodeNumUpdate:
> +	    /* cluster md only supports superblock 1.2 now */
> +	    if (st->minor_version !=3D 2) {
> +		pr_err("Warning: cluster md only works with superblock 1.2\n");
> +		return -EINVAL;
> +	    }
> +
> +	    /* Each node has an independent bitmap, it is necessary to calculat=
e the
> +	     * space is enough or not, first get how many bytes for the total b=
itmap */
> +	    bm_space_per_node =3D calc_bitmap_size(bms, 4096);
> +
> +	    total_bm_space =3D 512 * (__le64_to_cpu(sb->data_offset) - __le64_t=
o_cpu(sb->super_offset));
> +	    total_bm_space =3D total_bm_space - 4096; /* leave another 4k for s=
uperblock */
> +
> +	    if (bm_space_per_node * st->nodes > total_bm_space) {
> +		pr_err("Warning: The max num of nodes can't exceed %llu\n",
> +			total_bm_space / bm_space_per_node);
> +		return -ENOMEM;
> +	    }
> +
> +	    bms->nodes =3D __cpu_to_le32(st->nodes);
> +	    break;
>  	case NoUpdate:
>  	default:
>  	    break;


Again, missing documentation for the new --update option.
And indents should be tabs, not "4 spaces".  That "switch(update)"
has wrong indents - I didn't notice before.

Thanks,
NeilBrown.

--Sig_/NIXtGsg.pnhlA6t7CH+L466
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKrdznsnt1WYoG5AQJP0xAAvyxYwKdVSzozCH2KVPLaCdRYy6PYjSWo
gnAaRXaW+0fmtO8EZjnUmfGMrSem4O75piyyeL4dEzA18B74HuwceaWMKDTgxGfV
jUreH49zO6DYQsOYJaNsPa8hiKe/sJVP25aJu0pMALamvGhb7xOQtQrcADc8ICk/
Cm5jAQaBqo3oTdCnaKPPgm28veJMqGCXS8Ir/YpVPiz6YP8gG87Iuz4VfLx6MFuu
q2QZ6RiCQ/pPfOm7hs5mvdF7Ij/IAvtyQH/WK4M5FaNxuhDcZnTrfe72ANeVblLD
r4kBjAvIMRn38HIqV7DZV9hkZ1z9i+8HZiX5QjCEbToFUT9+lXIgiwUTpEHB3as5
ib0KsxUXu/ptVDb2eUuMmkUvzXPJKI1Uvt/2mxBxfJrkndPHN0XUxv3OppLRoT8w
qZ/g4QH5jEKQYZJNBxmGCCX5a5svlo0wQcF6mjNx+ZC3qCy1/7YlYmRVD5GyTTLy
fWR1KS8K74pKDRCMlAkTqxAcwPGxpZBVhbGs8Es5arWHqPJKdDaFzJBp3xwn+G92
lNYVUoX8detFBE/ti5AnkinaF0xVqr9kwcjaQH9nkwXAkBCjLIYwP5JkNSwdYxjM
qRFbR0R7QeL4wDRaw0a+dOT4q9BeAz1zZ6kPWPYH03om2dpVRUj1we9Cz/ZLsSPI
UW/d43kSBXE=
=tII3
-----END PGP SIGNATURE-----

--Sig_/NIXtGsg.pnhlA6t7CH+L466--
