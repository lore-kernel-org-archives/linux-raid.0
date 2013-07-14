From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] block: add bio_rewind() to reset bio_vec
Date: Mon, 15 Jul 2013 09:40:43 +1000
Message-ID: <20130715094043.7eea1ca1@notabene.brown>
References: <20130708160656.6cb8e74b@jlaw-desktop.mno.stratus.com>
	<1373315114-16625-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KNnwShP5D3vcqeGnx/xO.Le"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373315114-16625-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-raid@vger.kernel.org, kmo@daterainc.com
List-Id: linux-raid.ids

--Sig_/KNnwShP5D3vcqeGnx/xO.Le
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Jens,
 (I tried sending this a week ago but managed to not include your email - no
  wonder I didn't get a reply!)

 Are you OK with adding this to fs/bio.c?
 The follow-on patch which uses it to fix a crash in md in 3.10 is at=20
    http://marc.info/?l=3Dlinux-raid&m=3D137331514131503&w=3D2

 If so: will you submit or should I?  Both patches are in my "for-next" and
 so should be in linux-next.

 If not, I'll just do something local in raid1 to reset the bio before
 calling bio_copy_data().

Thanks,
NeilBrown


On Mon,  8 Jul 2013 16:25:13 -0400 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> Provide a mechanism for drivers to "rewind" a bio, essentially undoing
> all bio_advance() calls on the bio. After the rewind, the bio idx will
> be 0, size and sector reset, and each bio_vec len and offset restored to
> their initial values.
>=20
> Suggested-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>  fs/bio.c            | 27 +++++++++++++++++++++++++++
>  include/linux/bio.h |  1 +
>  2 files changed, 28 insertions(+)
>=20
> diff --git a/fs/bio.c b/fs/bio.c
> index 94bbc04..04309df 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -833,6 +833,33 @@ void bio_advance(struct bio *bio, unsigned bytes)
>  EXPORT_SYMBOL(bio_advance);
> =20
>  /**
> + * bio_rewind - reset a bio to its start
> + * @bio:        bio to rewind
> + *
> + * This resets bi_sector, bi_size and bi_idx; completely undoing all
> + * bio_advances on the @bio.
> + */
> +void bio_rewind(struct bio *bio)
> +{
> +	int bytes =3D 0;
> +
> +	if (bio->bi_idx < bio->bi_vcnt && bio_iovec(bio)->bv_offset > 0) {
> +		bytes =3D bio_iovec(bio)->bv_offset;
> +		bio_iovec(bio)->bv_offset -=3D bytes;
> +		bio_iovec(bio)->bv_len +=3D bytes;
> +	}
> +	while (bio->bi_idx) {
> +		bio->bi_idx -=3D 1;
> +		bio_iovec(bio)->bv_len +=3D bio_iovec(bio)->bv_offset;
> +		bio_iovec(bio)->bv_offset =3D 0;
> +		bytes +=3D bio_iovec(bio)->bv_len;
> +	}
> +	bio->bi_size +=3D bytes;
> +	bio->bi_sector -=3D bytes >> 9;
> +}
> +EXPORT_SYMBOL(bio_rewind);
> +
> +/**
>   * bio_alloc_pages - allocates a single page for each bvec in a bio
>   * @bio: bio to allocate pages for
>   * @gfp_mask: flags for allocation
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index ef24466..e2082fb 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -258,6 +258,7 @@ extern int bio_phys_segments(struct request_queue *, =
struct bio *);
> =20
>  extern int submit_bio_wait(int rw, struct bio *bio);
>  extern void bio_advance(struct bio *, unsigned);
> +extern void bio_rewind(struct bio *);
> =20
>  extern void bio_init(struct bio *);
>  extern void bio_reset(struct bio *);


--Sig_/KNnwShP5D3vcqeGnx/xO.Le
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeM2+znsnt1WYoG5AQKXMQ//U4X3kZ0so23MYqzF3IjvMXW3NcnJMPn2
K1tUabhyZnW6o4jpnPnDjc/cWsQmkcUJEP2lZ1j77nRZh5/zPRK0nbhWPSMAMJTm
wm0NUMXOlWJoRTCco4D5FR8joT9zvkKVPrbv2r8UMUZTECeC01RLZgF2VtmGSR/n
CMZKRi3/l5acRPICkOmGfQQ/qONAmOSNwiw0EgRt5nlThSauhNkQvQARXKt863+g
w2gafyde3rRyGxENQ2X/ijjdwIi+eONBBTpJtzf4+LEelHxCA/1Rcn+L+NjClmYa
XGQvWaqxqOYMBkTINwJKzUdx2VTfuypkAcx7iw8bpSv7oySAlMiKTuCMVKcb4Cw3
QkLy4Rs9GPYhhNDHWRfafhdjJ6BfxcW7Pl2Qbcon+bosriY640mOW4Yl+/ALpUAS
DVSIc6m6LNhtuOjbtMCbh26M5ElEwuZ59DMYT73igTvDaJHjy09dkKlpR2b7VcSq
+YFpDU81+3satk6mhrxGjJp49+hJvwsilW0ZrS+wnesY9mXMGoUjLSi3tS0e3LPN
55PpgAD9ebn5UnaJa7Xe2ZGQWTqZjr9+L/YpckFQiWlkokGmBtSF0Kf2KFD4wwiz
9NSEPqzQWEBjxQkdtUM4zwcM7h318OujZoD1Bq1KDPz7lfO1B99SfbsoV4fWfUKk
UlAL4m+MbZ8=
=lopv
-----END PGP SIGNATURE-----

--Sig_/KNnwShP5D3vcqeGnx/xO.Le--
