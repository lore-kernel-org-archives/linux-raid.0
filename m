From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/3] md-cluster: introduce clear_clusterinfo_from_sb
Date: Fri, 27 Nov 2015 16:42:31 +1100
Message-ID: <87y4dk577c.fsf@notabene.neil.brown.name>
References: <1448008525-17095-1-git-send-email-gqjiang@suse.com> <1448008525-17095-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448008525-17095-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: rgoldwyn@suse.com, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20 2015, Guoqing Jiang <gqjiang@suse.com> wrote:

> To change the bitmap from clustered to none, we also
> need to clean related info about cluster from sb, such
> as version, nodes and cluster_name.

I've applied the other two (though I removed the __func__ and __LINE__
From=20error messages - they are just noise: the source of the message can
easily be found with out them - I should remove all the others).

However I haven't applied this because there doesn't seem to be any
point.
Once your told that main md superblock that there is no bitmap, it
doesn't really matter what data is in the superblock of that
non-existent bitmap - it will never be looked at.  Will it?

Thanks,
NeilBrown

>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/bitmap.c | 25 +++++++++++++++++++++++++
>  drivers/md/bitmap.h |  1 +
>  drivers/md/md.c     |  1 +
>  3 files changed, 27 insertions(+)
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 4f22e91..c11390f 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -417,6 +417,31 @@ out:
>  /*
>   * bitmap file superblock operations
>   */
> +void clear_clusterinfo_from_sb(struct bitmap *bitmap)
> +{
> +	bitmap_super_t *sb;
> +
> +	if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
> +		return;
> +	if (bitmap->mddev->bitmap_info.external)
> +		return;
> +	if (!bitmap->storage.sb_page) /* no superblock */
> +		return;
> +	sb =3D kmap_atomic(bitmap->storage.sb_page);
> +	sb->nodes =3D 0;
> +	sb->version =3D cpu_to_le32(BITMAP_MAJOR_HI);
> +	memset(sb->cluster_name, NULL, 64);
> +
> +	kunmap_atomic(sb);
> +	/* Don't write until any other writes have completed */
> +	if (bitmap->storage.file)
> +		wait_event(bitmap->write_wait,
> +			   atomic_read(&bitmap->pending_writes)=3D=3D0);
> +	else
> +		md_super_wait(bitmap->mddev);
> +
> +	write_page(bitmap, bitmap->storage.sb_page, 1);
> +}
>=20=20
>  /* update the event counter and sync the superblock to disk */
>  void bitmap_update_sb(struct bitmap *bitmap)
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index 7d5c3a6..1d0975b 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -241,6 +241,7 @@ void bitmap_flush(struct mddev *mddev);
>  void bitmap_destroy(struct mddev *mddev);
>=20=20
>  void bitmap_print_sb(struct bitmap *bitmap);
> +void clear_clusterinfo_from_sb(struct bitmap *bitmap);
>  void bitmap_update_sb(struct bitmap *bitmap);
>  void bitmap_status(struct seq_file *seq, struct bitmap *bitmap);
>=20=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 47ee8ae..f06dc43 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6598,6 +6598,7 @@ static int update_array_info(struct mddev *mddev, m=
du_array_info_t *info)
>  				}
>=20=20
>  				mddev->bitmap_info.nodes =3D 0;
> +				clear_clusterinfo_from_sb(mddev->bitmap);
>  				md_cluster_ops->leave(mddev);
>  			}
>  			mddev->pers->quiesce(mddev, 1);
> --=20
> 2.1.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWV+1HAAoJEDnsnt1WYoG5oAIP/jec7turu3Ls9a9oYboO6tyT
n0nC8PqrNw07gTlF7SRWjLVk1tQbtXIMCgUgzMGUYVPJHuKSOmsJWm1rXjk2AwNp
06FVgxCknMImUMdo2+z36Y6RZIbZ4tbrowTisC+Io8SJ+SYeDg+DtMhb8g4hiNqY
51iTBMThNDx2wmFwkh1dn9W4wf2HuCQBE9dsYZRZ8Lg9FCDg4qCHq3CzfCeHFtqE
XChDAAhItjZrP1BmRX1iVoIZP5hOSPy+mawmYAuMrjT+H7pVzbIqtaUWKAbPvsKo
9AGQUOm5DkUXxwxhSXIhnAfNjUDhSYk0djkJgvP5hfXJDAKUZRkvf1I0klxUfxPF
ASIi98+oylhq7l5Gnn6+fzCgoqWgc7KepvNr9t11hZqg4hZg0fZwyLMaPuVCNdMv
AqWGJuoV7RVjKV7zkWKS9QC1cx+gb873MYXpUhGLAGbXFZmNLFYdHj8avmtS6yrK
lq2TC1tpo1jJDTHqyrNcT9+yp0Ynsu0AUbC62uUTOFAGgLlctOsJQQngQSvBCKPU
XzzkvF9gTLDNDb9pKOshYXIPDDHJA5iu467LyeUhhzQHzq9jUtODP3bYdbNoloI3
XF9WgS6DGQPd/6c7f2AvkMyihcNYogs2s+BJFTPhk0dFwwf+S9f8BZVEF7ims3od
WHSc+95gjflb85OY1MPR
=u4++
-----END PGP SIGNATURE-----
--=-=-=--
