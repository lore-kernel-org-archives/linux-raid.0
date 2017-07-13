From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/2] md: raid1/raid10: initialize bvec table via bio_add_page()
Date: Thu, 13 Jul 2017 13:09:28 +1000
Message-ID: <87inix2ftj.fsf@notabene.neil.brown.name>
References: <20170712082912.491-1-ming.lei@redhat.com> <87zic92oiq.fsf@notabene.neil.brown.name> <20170713013710.GC670@ming.t460p>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170713013710.GC670@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 13 2017, Ming Lei wrote:

> On Thu, Jul 13, 2017 at 10:01:33AM +1000, NeilBrown wrote:
>> On Wed, Jul 12 2017, Ming Lei wrote:
>>=20
>> > We will support multipage bvec soon, so initialize bvec
>> > table using the standardy way instead of writing the
>> > talbe directly. Otherwise it won't work any more once
>> > multipage bvec is enabled.
>> >
>> > Acked-by: Guoqing Jiang <gqjiang@suse.com>
>> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> > ---
>> >  drivers/md/md.c     | 21 +++++++++++++++++++++
>> >  drivers/md/md.h     |  3 +++
>> >  drivers/md/raid1.c  | 16 ++--------------
>> >  drivers/md/raid10.c |  4 ++--
>> >  4 files changed, 28 insertions(+), 16 deletions(-)
>> >
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > index 8cdca0296749..cc8dcd928dde 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -9130,6 +9130,27 @@ void md_reload_sb(struct mddev *mddev, int nr)
>> >  }
>> >  EXPORT_SYMBOL(md_reload_sb);
>> >=20=20
>> > +/* generally called after bio_reset() for reseting bvec */
>> > +void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *=
rp,
>> > +			       int size)
>> > +{
>> > +	int idx =3D 0;
>> > +
>> > +	/* initialize bvec table again */
>> > +	do {
>> > +		struct page *page =3D resync_fetch_page(rp, idx);
>> > +		int len =3D min_t(int, size, PAGE_SIZE);
>> > +
>> > +		/*
>> > +		 * won't fail because the vec table is big
>> > +		 * enough to hold all these pages
>> > +		 */
>> > +		bio_add_page(bio, page, len, 0);
>> > +		size -=3D len;
>> > +	} while (idx++ < RESYNC_PAGES && size > 0);
>> > +}
>> > +EXPORT_SYMBOL(md_bio_reset_resync_pages);
>>=20
>> I really don't think this is a good idea.
>> This code is specific to raid1/raid10.  It is not generic md code.  So
>> it doesn't belong here.
>
> We already added 'struct resync_pages' in drivers/md/md.h, so I think
> it is reasonable to add this function into drivers/md/md.c

Alternative perspective: it was unreasonable to add "resync_pages" to
md.h.

>
>>=20
>> If you want to remove code duplication, then work on moving all raid1
>> functionality into raid10.c, then discard raid1.c
>
> This patch is for avoiding new code duplication, not for removing current
> duplication.
>
>>=20
>> Or at the very least, have a separate "raid1-10.c" file for the common
>> code.
>
> You suggested it last time, but looks too overkill to be taken. But if
> someone wants to refactor raid1 and raid10, I think it can be a good star=
t,
> but still not belong to this patch.

You are trying to create common code for raid1 and raid10.  This does
not belong in md.c.
If you really want to have a single copy of common code, then it exactly
is the role of this patch to create a place to put it.
I'm not saying you should put all common code in raid1-10.c.   Just the
function that you have identified.

NeilBrown

>
> Thanks,
> Ming
>
>>=20
>> NeilBrown
>>=20
>> > +
>> >  #ifndef MODULE
>> >=20=20
>> >  /*
>> > diff --git a/drivers/md/md.h b/drivers/md/md.h
>> > index 2c780aa8d07f..efb32ce7a2f1 100644
>> > --- a/drivers/md/md.h
>> > +++ b/drivers/md/md.h
>> > @@ -782,4 +782,7 @@ static inline struct page *resync_fetch_page(struc=
t resync_pages *rp,
>> >  		return NULL;
>> >  	return rp->pages[idx];
>> >  }
>> > +
>> > +void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *=
rp,
>> > +			       int size);
>> >  #endif /* _MD_MD_H */
>> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> > index 7901ddc3362f..5dc3fda2fdf7 100644
>> > --- a/drivers/md/raid1.c
>> > +++ b/drivers/md/raid1.c
>> > @@ -2085,10 +2085,7 @@ static void process_checks(struct r1bio *r1_bio)
>> >  	/* Fix variable parts of all bios */
>> >  	vcnt =3D (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
>> >  	for (i =3D 0; i < conf->raid_disks * 2; i++) {
>> > -		int j;
>> > -		int size;
>> >  		blk_status_t status;
>> > -		struct bio_vec *bi;
>> >  		struct bio *b =3D r1_bio->bios[i];
>> >  		struct resync_pages *rp =3D get_resync_pages(b);
>> >  		if (b->bi_end_io !=3D end_sync_read)
>> > @@ -2097,8 +2094,6 @@ static void process_checks(struct r1bio *r1_bio)
>> >  		status =3D b->bi_status;
>> >  		bio_reset(b);
>> >  		b->bi_status =3D status;
>> > -		b->bi_vcnt =3D vcnt;
>> > -		b->bi_iter.bi_size =3D r1_bio->sectors << 9;
>> >  		b->bi_iter.bi_sector =3D r1_bio->sector +
>> >  			conf->mirrors[i].rdev->data_offset;
>> >  		b->bi_bdev =3D conf->mirrors[i].rdev->bdev;
>> > @@ -2106,15 +2101,8 @@ static void process_checks(struct r1bio *r1_bio)
>> >  		rp->raid_bio =3D r1_bio;
>> >  		b->bi_private =3D rp;
>> >=20=20
>> > -		size =3D b->bi_iter.bi_size;
>> > -		bio_for_each_segment_all(bi, b, j) {
>> > -			bi->bv_offset =3D 0;
>> > -			if (size > PAGE_SIZE)
>> > -				bi->bv_len =3D PAGE_SIZE;
>> > -			else
>> > -				bi->bv_len =3D size;
>> > -			size -=3D PAGE_SIZE;
>> > -		}
>> > +		/* initialize bvec table again */
>> > +		md_bio_reset_resync_pages(b, rp, r1_bio->sectors << 9);
>> >  	}
>> >  	for (primary =3D 0; primary < conf->raid_disks * 2; primary++)
>> >  		if (r1_bio->bios[primary]->bi_end_io =3D=3D end_sync_read &&
>> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> > index e594ca610f27..cb8e803cd1c2 100644
>> > --- a/drivers/md/raid10.c
>> > +++ b/drivers/md/raid10.c
>> > @@ -2086,8 +2086,8 @@ static void sync_request_write(struct mddev *mdd=
ev, struct r10bio *r10_bio)
>> >  		rp =3D get_resync_pages(tbio);
>> >  		bio_reset(tbio);
>> >=20=20
>> > -		tbio->bi_vcnt =3D vcnt;
>> > -		tbio->bi_iter.bi_size =3D fbio->bi_iter.bi_size;
>> > +		md_bio_reset_resync_pages(tbio, rp, fbio->bi_iter.bi_size);
>> > +
>> >  		rp->raid_bio =3D r10_bio;
>> >  		tbio->bi_private =3D rp;
>> >  		tbio->bi_iter.bi_sector =3D r10_bio->devs[i].addr;
>> > --=20
>> > 2.9.4
>
>
>
> --=20
> Ming

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllm5GoACgkQOeye3VZi
gbnrcw/7B5kcireVP1mcadZGszhq4JTpPn5q+TXeMCIg2icVofOA8ToGnJJbAxyS
SlkR4opRqf7BEggi/SVZDgqWUYNyLUOmhrqxlZLa1PnK7TnZ/Hjz6vllSMyEOGD9
0hi7dOzwK+sUu+N9kMmeIa5Qmw2gtG4cDJy0o9N1MdRtf5bEx5l8CRJbOvasGv2U
y+g05d2+tASob5mAEegUNRmbETB3LTTWcLQps0Pip8V1RI4eTMbe+JqSq2c7kbBZ
4pYaa9884dfBFogqDqUfvjNqLBjSb1TzsnLrDRMvw3zwtGWA7wui0Xkk1pRDDtxW
UYj2+pgGL6LVnqgG0fz3ZgQBhH/8nOXZgwRJmC6qqYtYi5NY3Q0PZ+D/8vw4Ar9U
slqQLvvQShKfgrpOhmjAGKUvhTjgNgAf0k1w38vRa+gWYd5qLXvJNWtEENuhdSXw
dV1v1VY31PrX5yYefFfA+pNt3AE4PGvn4QQajshr8wiU2tjevLsgGMS62562PejE
RNA0BQbjX3O6sqazotbnCQeg90hHQLEqF1OWDi+9ffqpvJ/PIgCVHhINXeiVlAoF
6SL/cbjOAbkI0iP3L0g+/T6t4giS3uhy1ChaLDAXYCbsmP6E12Bnbm0wQIn156hC
FV+ogSJm6KBRRtLc/yeje7+z4jPZBXRx8/lFvLoroWNz3wDAVq4=
=xRS4
-----END PGP SIGNATURE-----
--=-=-=--
