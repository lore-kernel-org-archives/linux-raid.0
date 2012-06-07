From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 6/8] raid5: make_request use batch stripe release
Date: Thu, 7 Jun 2012 11:23:45 +1000
Message-ID: <20120607112345.1429436b@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080335.029329200@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6=2=g/rseywnnrwuHkVI9/3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604080335.029329200@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/6=2=g/rseywnnrwuHkVI9/3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 16:01:58 +0800 Shaohua Li <shli@kernel.org> wrote:

> make_request() does stripe release for every stripe and the stripe usuall=
y has
> count 1, which makes previous release_stripe() optimization not work. In =
my
> test, this release_stripe() becomes the heaviest pleace to take
> conf->device_lock after previous patches applied.
>=20
> Below patch makes stripe release batch. When maxium strips of a batch rea=
ch,
> the batch will be flushed out. Another way to do the flush is when unplug=
 is
> called.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

I like the idea of a batched release.
I don't like the per-cpu variables... and I don't think it is safe to only
allocate them for_each_present_cpu without support cpu-hot-plug.

I would much rather keep a list of stripes (linked on ->lru) in struct
md_plug_cb (or maybe in some structure which contains that) and release them
all on unplug - and only on unplug.

Maybe pass a size to mddev_check_unplugged, and it allocates that much more
space.  Get mddev_check_unplugged to return the md_plug_cb structure.
If the new space is NULL, then list_head_init it, and change the cb.callback
to a raid5 specific function.
Then add any stripe to the md_plug_cb, and in the unplug function, release
them all.

Does that make sense?

Also I would rather the batched stripe release code were defined in the same
patch that used it.  It isn't big enough to justify a separate patch.

Thanks,
NeilBrown



> ---
>  drivers/md/raid5.c |   42 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-01 14:13:46.846909398 +0800
> +++ linux/drivers/md/raid5.c	2012-06-01 14:22:07.944611949 +0800
> @@ -4023,6 +4023,38 @@ static struct stripe_head *__get_priorit
>  	return sh;
>  }
> =20
> +struct raid5_plug {
> +	struct blk_plug_cb cb;
> +	struct stripe_head_batch batch;
> +};
> +static DEFINE_PER_CPU(struct raid5_plug, raid5_plugs);
> +
> +static void raid5_do_plug(struct blk_plug_cb *cb)
> +{
> +	struct raid5_plug *plug =3D container_of(cb, struct raid5_plug, cb);
> +
> +	release_stripe_flush_batch(&plug->batch);
> +	INIT_LIST_HEAD(&plug->cb.list);
> +}
> +
> +static void release_stripe_plug(struct stripe_head *sh)
> +{
> +	struct blk_plug *plug =3D current->plug;
> +	struct raid5_plug *raid5_plug;
> +
> +	if (!plug) {
> +		release_stripe(sh);
> +		return;
> +	}
> +	preempt_disable();
> +	raid5_plug =3D &__raw_get_cpu_var(raid5_plugs);
> +	release_stripe_add_batch(&raid5_plug->batch, sh);
> +
> +	if (list_empty(&raid5_plug->cb.list))
> +		list_add(&raid5_plug->cb.list, &plug->cb_list);
> +	preempt_enable();
> +}
> +
>  static void make_request(struct mddev *mddev, struct bio * bi)
>  {
>  	struct r5conf *conf =3D mddev->private;
> @@ -4153,7 +4185,7 @@ static void make_request(struct mddev *m
>  			if ((bi->bi_rw & REQ_SYNC) &&
>  			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				atomic_inc(&conf->preread_active_stripes);
> -			release_stripe(sh);
> +			release_stripe_plug(sh);
>  		} else {
>  			/* cannot get stripe for read-ahead, just give-up */
>  			clear_bit(BIO_UPTODATE, &bi->bi_flags);
> @@ -6170,6 +6202,14 @@ static struct md_personality raid4_perso
> =20
>  static int __init raid5_init(void)
>  {
> +	int i;
> +
> +	for_each_present_cpu(i) {
> +		struct raid5_plug *plug =3D &per_cpu(raid5_plugs, i);
> +		plug->batch.count =3D 0;
> +		INIT_LIST_HEAD(&plug->cb.list);
> +		plug->cb.callback =3D raid5_do_plug;
> +	}
>  	register_md_personality(&raid6_personality);
>  	register_md_personality(&raid5_personality);
>  	register_md_personality(&raid4_personality);


--Sig_/6=2=g/rseywnnrwuHkVI9/3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9ACoTnsnt1WYoG5AQJ4+xAAgXcBB5VzG8bnQr/eyG3iq29Gc58iEBvZ
D89fUhKeGkcxBNQpxhyzebq9ah5WOn3Ry9hIJaWuwKwIU5xrNL9Hd1P5OIj0kSF0
Kx7Wd+jvTu5wux1RBMPb4tjegHnbzotoqlJFSdn6G83idXPKgRcDyBGTObYsLjhA
67wroTs87zECvlWzGGo1Mklg7wr5uC6/+au0jnrxS2NwRiwAYmHxmhhtUrjZdt+o
q92zc10sL6Nw/nSUcu3I1np0oklyTRZCVUjxSk6CONTCM6GYhzbpmfCb6gWWzzG2
k4k7obxxJf2xQOc9EreSqnouMbT+rLzsaJ5mltdXLvfaAEpU6XU8vuG1uR0no1an
nkTS+0mnI/EjE7hhLat4BBa2Rhja9CPb1d52uwkt3kl4JXD70dA7pA60EvgKvxNG
QS24Gv3ZgYMsZhOIkLavNhHfOw0iPGAMydpAGjefQocEcGsFj86P8xbWhvN697nU
ckvnYJvik1nkOXoFbeelyCFKOJwfMehzjjuLF3nCt43YTcTfm02EtTYXzniRbg6X
R70Ag0mF3KqbGxrU6NIUcAFdERVgE+DeUnIxBltUIBzh17aDv6uhu4vCNJBgDSvp
gZA/7xBbYG5RaEIh7duYXxitNtlsBxKfu4VPocJ4MmVLc3NhedstOjmwrjDO/QSi
JjpPQQfAB8Y=
=LSkE
-----END PGP SIGNATURE-----

--Sig_/6=2=g/rseywnnrwuHkVI9/3--
