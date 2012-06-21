From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 3/9 v2] raid5: lockless access raid5 overrided bi_phys_segments
Date: Wed, 20 Jun 2012 18:56:10 -0700
Message-ID: <CABE8wwuWQDXjKVnPd2_Wcd7=xRh_SvPnBmSub9YzS0iNW3t=3w@mail.gmail.com>
References: <20120619015941.891400722@kernel.org>
	<20120619020108.288903467@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120619020108.288903467@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Mon, Jun 18, 2012 at 6:59 PM, Shaohua Li <shli@kernel.org> wrote:
> Raid5 overrides bio->bi_phys_segments, accessing it is with device_lo=
ck hold,
> which is unnecessary, We can make it lockless actually.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
> =A0drivers/md/raid5.c | =A0 58 +++++++++++++++++++++++++++++---------=
---------------
> =A01 file changed, 32 insertions(+), 26 deletions(-)
>
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c =A0 =A0 =A0 2012-06-08 11:48:25.652=
618012 +0800
> +++ linux/drivers/md/raid5.c =A0 =A02012-06-08 13:15:31.458919391 +08=
00
> @@ -99,34 +99,40 @@ static inline struct bio *r5_next_bio(st
> =A0* We maintain a biased count of active stripes in the bottom 16 bi=
ts of
> =A0* bi_phys_segments, and a count of processed stripes in the upper =
16 bits
> =A0*/
> -static inline int raid5_bi_phys_segments(struct bio *bio)
> +static inline int raid5_bi_processed_stripes(struct bio *bio)
> =A0{
> - =A0 =A0 =A0 return bio->bi_phys_segments & 0xffff;
> + =A0 =A0 =A0 atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segmen=
ts;
> + =A0 =A0 =A0 return (atomic_read(segments) >> 16) & 0xffff;
> =A0}
>
> -static inline int raid5_bi_hw_segments(struct bio *bio)
> +static inline int raid5_dec_bi_active_stripes(struct bio *bio)
> =A0{
> - =A0 =A0 =A0 return (bio->bi_phys_segments >> 16) & 0xffff;
> + =A0 =A0 =A0 atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segmen=
ts;
> + =A0 =A0 =A0 return atomic_sub_return(1, segments) & 0xffff;
> =A0}
>
> -static inline int raid5_dec_bi_phys_segments(struct bio *bio)
> +static inline void raid5_inc_bi_active_stripes(struct bio *bio)
> =A0{
> - =A0 =A0 =A0 --bio->bi_phys_segments;
> - =A0 =A0 =A0 return raid5_bi_phys_segments(bio);
> + =A0 =A0 =A0 atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segmen=
ts;
> + =A0 =A0 =A0 atomic_inc(segments);
> =A0}
>
> -static inline int raid5_dec_bi_hw_segments(struct bio *bio)
> +static inline void raid5_set_bi_processed_stripes(struct bio *bio,
> + =A0 =A0 =A0 unsigned int cnt)
> =A0{
> - =A0 =A0 =A0 unsigned short val =3D raid5_bi_hw_segments(bio);
> + =A0 =A0 =A0 atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segmen=
ts;
> + =A0 =A0 =A0 int old, new;
>
> - =A0 =A0 =A0 --val;
> - =A0 =A0 =A0 bio->bi_phys_segments =3D (val << 16) | raid5_bi_phys_s=
egments(bio);
> - =A0 =A0 =A0 return val;
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 old =3D atomic_read(segments);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 new =3D (old & 0xffff) | (cnt << 16);
> + =A0 =A0 =A0 } while (atomic_cmpxchg(segments, old, new) !=3D old);
> =A0}
>
> -static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigne=
d int cnt)
> +static inline void raid5_set_bi_stripes(struct bio *bio, unsigned in=
t cnt)
> =A0{
> - =A0 =A0 =A0 bio->bi_phys_segments =3D raid5_bi_phys_segments(bio) |=
 (cnt << 16);
> + =A0 =A0 =A0 atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segmen=
ts;
> + =A0 =A0 =A0 atomic_set(segments, cnt);
> =A0}
>
> =A0/* Find first data disk in a raid6 stripe */
> @@ -767,7 +773,7 @@ static void ops_complete_biofill(void *s
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while (rbi && rbi->bi_=
sector <
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev->s=
ector + STRIPE_SECTORS) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rbi2 =3D=
 r5_next_bio(rbi, dev->sector);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ra=
id5_dec_bi_phys_segments(rbi)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ra=
id5_dec_bi_active_stripes(rbi)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0rbi->bi_next =3D return_bi;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0return_bi =3D rbi;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -2354,7 +2360,7 @@ static int add_stripe_bio(struct stripe_
> =A0 =A0 =A0 =A0if (*bip)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bi->bi_next =3D *bip;
> =A0 =A0 =A0 =A0*bip =3D bi;
> - =A0 =A0 =A0 bi->bi_phys_segments++;
> + =A0 =A0 =A0 raid5_inc_bi_active_stripes(bi);

Now that device_lock does not globally sync bio ingress/egress would
it be worth having a a comment here that says this ordering of adding
bi to the to{read|write} list is safe because make_request holds a
'segments' reference count until the bio has been added to all
affected stripes, and that within a given stripe bios are still synced
via stripe_lock?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
