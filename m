From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 02/10 v3] raid5: delayed stripe fix
Date: Mon, 2 Jul 2012 10:46:48 +1000
Message-ID: <20120702104648.758e56d9@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072606.544356632@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9mqzH6/mb+ON3ZKy_L+uAr_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072606.544356632@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/9mqzH6/mb+ON3ZKy_L+uAr_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:49 +0800 Shaohua Li <shli@kernel.org> wrote:

> There isn't locking setting STRIPE_DELAYED and STRIPE_PREREAD_ACTIVE bits=
, but
> the two bits have relationship. A delayed stripe can be moved to hold lis=
t only
> when preread active stripe count is below IO_THRESHOLD. If a stripe has b=
oth
> the bits set, such stripe will be in delayed list and preread count not 0,
> which will make such stripe never leave delayed list.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-25 14:36:15.964613183 +0800
> +++ linux/drivers/md/raid5.c	2012-06-25 14:36:57.280096788 +0800
> @@ -196,12 +196,14 @@ static void __release_stripe(struct r5co
>  		BUG_ON(!list_empty(&sh->lru));
>  		BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
>  		if (test_bit(STRIPE_HANDLE, &sh->state)) {
> -			if (test_bit(STRIPE_DELAYED, &sh->state))
> +			if (test_bit(STRIPE_DELAYED, &sh->state) &&
> +			    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  				list_add_tail(&sh->lru, &conf->delayed_list);
>  			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
>  				   sh->bm_seq - conf->seq_write > 0)
>  				list_add_tail(&sh->lru, &conf->bitmap_list);
>  			else {
> +				clear_bit(STRIPE_DELAYED, &sh->state);
>  				clear_bit(STRIPE_BIT_DELAY, &sh->state);
>  				list_add_tail(&sh->lru, &conf->handle_list);
>  			}

Thanks.  I've applied this patch and will submit it upstream shortly.

Have you actually seen a stripe get trapped with both bits set, or is this
just a theoretical problem discovered by code inspection?

Thanks,
NeilBrown

--Sig_/9mqzH6/mb+ON3ZKy_L+uAr_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/DveDnsnt1WYoG5AQIVKhAAkL/3oAi5WjRZ0Ck7IzOr47uXMRJv1ZLr
j6viZqUiqt1Uo/TexVXWYrVhy8Z1c2RjaZpm7LaE97N6F3xPjouK/ZAlkjiZWVpD
H+cpdL9Iq95shQfjC8Adx9y5ghdqqHUPDUQe1pnoYC9mCxI0zpXuXGnnzp8yBsZL
RcjZ284ayBJRaJDY3pPOpnr6Vgm9qjOHDwK4HEZm92+E1+AAhMk+TTerc3IJBbqM
w1KAmGqLdZpudRgmzDKBvqAB/gVv/cVDXDK6YNOJrJ10BJTHCRNqDk5x9bVYgSeu
28fAHCmZl4JH4WrK4zqn7sD5yveEPSw7MEEeX3AkUtakrbG+ZJM0cpg9q9ppsbxE
Jb4Ok9uAkuxyKxVXe/S3xcjzvM1qErzITcrw20EfTPh9vlN36vNomxzWKx8ZgeGX
XbkYPi7wGL0UaNleGvG4TTS/quNZFIKHfT63kU1JLINOaZ3sFbxhXzz1ODv+sDRa
upbn3v3KOb4MR8kPv4loxHYZNyE7dFAKvsti2YuLrNfiJMBI4ut0nC3kkDqNFWMF
bTaRwMjpnmm3MdLKNqXPf3dPN/fbffzHRnCA9BymvaB7v1DZt3OK/hIkYx6kQHgz
nQlgqLEMMfSZOOQlrM7x2fB7cvXFx266FPwxztsnb1Q0gb8AyaUxIAnZvvJmRHRH
gsocVxA6Ei4=
=bAl5
-----END PGP SIGNATURE-----

--Sig_/9mqzH6/mb+ON3ZKy_L+uAr_--
