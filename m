From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/8] raid5: lockless access raid5 overrided
 bi_phys_segments
Date: Thu, 7 Jun 2012 11:06:03 +1000
Message-ID: <20120607110603.0d88c757@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080307.401236650@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X4HVCcRckl8=rV3AyhZ0JWM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604080307.401236650@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/X4HVCcRckl8=rV3AyhZ0JWM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 16:01:54 +0800 Shaohua Li <shli@kernel.org> wrote:

> Raid5 overrides bio->bi_phys_segments, accessing it is with device_lock h=
old,
> which is unnecessary, We can make it lockless actually.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

I cannot say that I like this (casting fields in the bio structure), but I
can see the value and it should work.  'atomic_t' is currently always the s=
ame
size as an 'int', and I doubt that will change.

So maybe I'll get used to the idea.

I think we should take the opportunity to change the names to refer to
"active" and "processed" rather than "phys" and "hw".

Thanks,

NeilBrown


> ---
>  drivers/md/raid5.c |   37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-01 13:43:05.594056130 +0800
> +++ linux/drivers/md/raid5.c	2012-06-01 13:50:39.852349690 +0800
> @@ -101,32 +101,43 @@ static inline struct bio *r5_next_bio(st
>   */
>  static inline int raid5_bi_phys_segments(struct bio *bio)
>  {
> -	return bio->bi_phys_segments & 0xffff;
> +	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
> +	return atomic_read(segments) & 0xffff;
>  }
> =20
>  static inline int raid5_bi_hw_segments(struct bio *bio)
>  {
> -	return (bio->bi_phys_segments >> 16) & 0xffff;
> +	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
> +	return (atomic_read(segments) >> 16) & 0xffff;
>  }
> =20
>  static inline int raid5_dec_bi_phys_segments(struct bio *bio)
>  {
> -	--bio->bi_phys_segments;
> -	return raid5_bi_phys_segments(bio);
> +	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
> +	return atomic_sub_return(1, segments) & 0xffff;
>  }
> =20
> -static inline int raid5_dec_bi_hw_segments(struct bio *bio)
> +static inline void raid5_inc_bi_phys_segments(struct bio *bio)
>  {
> -	unsigned short val =3D raid5_bi_hw_segments(bio);
> -
> -	--val;
> -	bio->bi_phys_segments =3D (val << 16) | raid5_bi_phys_segments(bio);
> -	return val;
> +	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
> +	atomic_inc(segments);
>  }
> =20
>  static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned in=
t cnt)
>  {
> -	bio->bi_phys_segments =3D raid5_bi_phys_segments(bio) | (cnt << 16);
> +	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
> +	int old, new;
> +
> +	do {
> +		old =3D atomic_read(segments);
> +		new =3D (old & 0xffff) | (cnt << 16);
> +	} while (atomic_cmpxchg(segments, old, new) !=3D old);
> +}
> +
> +static inline void raid5_set_bi_segments(struct bio *bio, unsigned int c=
nt)
> +{
> +	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
> +	atomic_set(segments, cnt);
>  }
> =20
>  /* Find first data disk in a raid6 stripe */
> @@ -2354,7 +2365,7 @@ static int add_stripe_bio(struct stripe_
>  	if (*bip)
>  		bi->bi_next =3D *bip;
>  	*bip =3D bi;
> -	bi->bi_phys_segments++;
> +	raid5_inc_bi_phys_segments(bi);
> =20
>  	if (forwrite) {
>  		/* check if page is covered */
> @@ -3783,7 +3794,7 @@ static struct bio *remove_bio_from_retry
>  		 * this sets the active strip count to 1 and the processed
>  		 * strip count to zero (upper 8 bits)
>  		 */
> -		bi->bi_phys_segments =3D 1; /* biased count of active stripes */
> +		raid5_set_bi_segments(bi, 1); /* biased count of active stripes */
>  	}
> =20
>  	return bi;


--Sig_/X4HVCcRckl8=rV3AyhZ0JWM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8/+eznsnt1WYoG5AQJe8A/+MqMjrycENi1Z/37EJugC8snzclXljxqD
oRQb0eZ3TOTLBjV9R3hujEWPt/cQTcptMZnVnCiSAhUGo3T7GMPqbsOckndMGwRE
+bzp/zgtBKmSX0/Lz558+HVCAN+j/SUBMGsD2nw9f3HZcAMO+3DTnSHnnESdzQzR
pPM6O9Y53y1hidMT8VUMv4M3ReiarRVtox07bQCNHY6xOI+583rfF5kdUb8V4KY/
Qn3zDdhT8p0PCxm2nA8X0OFjZ+1kkfHeAp7bCc0V+sKWGd4e+AdFcT41ETJTbEFm
q/HnIEsc/WAjPIkYW9UUh+umsYc2ep0fiekR+r+ZSGrLD3cjDV9xGzp1b3RdYbhk
M2onVUnqeHqZLtEIHvCwl0xuc+Iq3x0rgOp+HFfAHccu6xhJuaPp0ALIiFg1sHkq
8POsO0a7ftrOnnP2AkmC4/M6y0jaC+rFBcZmB9zOfdjuvEJiYWT4FlHA1nc5uGcm
2caTXr830OIDeQxLwD7FJTfUIcxBdt6M2PHmUNsUoe+EoJW7R/uVMeJmciUJnptU
2uVMjHrjZO4SKrdKT7gadKEwGDhh8aE6aMRfMvErz0kafNfRD91gj213wZFRx2Ya
9pmsQc6mYG3Ah4vWgf6VTiOe5Twug+VSxorMNh8xr6pBkNvEVgOMtPtd8r0lTDW0
Cy+mo0vlzP4=
=dcyw
-----END PGP SIGNATURE-----

--Sig_/X4HVCcRckl8=rV3AyhZ0JWM--
