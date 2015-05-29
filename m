From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] raid5: grown at least NR_STRIPE_HASH_LOCKS stripes
Date: Fri, 29 May 2015 15:07:46 +1000
Message-ID: <20150529150746.27dc5af3@notabene.brown>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
	<08b93a26b679edad7d3065b6c6d5819d3b1f41b9.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/WM=CmZa+3VE89FNl8p_B7zH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <08b93a26b679edad7d3065b6c6d5819d3b1f41b9.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WM=CmZa+3VE89FNl8p_B7zH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 May 2015 17:33:46 -0700 Shaohua Li <shli@fb.com> wrote:

> stripes are in hash list. If we are waiting for a free stripe, we must
> make sure there is free stripe in corresponding hash list. To do this,
> we simpliy allocate at lease NR_STRIPE_HASH_LOCKS stripes at runtime
> stripe allocation.
>=20
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index bfa2042..0cceb71 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5867,7 +5867,9 @@ static void raid5d(struct md_thread *thread)
> =20
>  	spin_unlock_irq(&conf->device_lock);
>  	if (test_and_clear_bit(R5_ALLOC_MORE, &conf->cache_state)) {
> -		grow_one_stripe(conf, __GFP_NOWARN);
> +		int i;
> +		for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++)
> +			grow_one_stripe(conf, __GFP_NOWARN);
>  		/* Set flag even if allocation failed.  This helps
>  		 * slow down allocation requests when mem is short
>  		 */

Again, if R5_ALLOC_MORE is just a hint, it certainly isn't true that we
"must" make sure there are free stripes.
It's fairly important that the pool of stripes grows slowly.  I don't think
it matters a lot how slowly, but on a busy array it should grow steadily
until it hits an equilibrium, and making that happen a bit faster doesn't
seem necessary.

Think of R5_ALLOC_MORE like a gentle push towards allocating more strips.  =
It
doesn't matter if it fails, and if it is really important there will be
plenty more gentle pushes coming.

Thanks,
NeilBrown


--Sig_/WM=CmZa+3VE89FNl8p_B7zH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWf0Ijnsnt1WYoG5AQJQixAAidB/Efmra8ZarazqmnwyCYDXu0s/n/61
ffyFD7KR/nvzueJ1XHBriZtr8iwlV2d/PzKdUVw38F5TzmC5qOvgITOmeSNguPxf
XpdAeY5bG09UOPcL3UlKtvGqipS5EbkDDfgqPLt4qQmjD6ygiPHMyPU7QuNBOKG4
+DQOgkpScQbfZgcbRJFhsCaByFYM2V2DUDTzeY2AGHZ50U2LmXLbwgcjGiFhKGYU
FmyNhdgyXTUf3wm06SqL1JYF4LrDywSXAgF4l019Ax8Sf37Zw6FXMfw4SrZkPIVi
ThkwABsWM27t0GzcsdYfJV9bKL/mE8yUUtWaUOWAbbNXE57FOsc8Iji4Z1jlSPf3
GnxRgsHCa+t+iTRo7GrHuizBGOjbbKy0ebokwu04muxdqMGliNYa4jlN8yFNPf7U
22KgCPHmKBpJARNnM5CeX0aDDSDrDC2UIu89p+okY7/dujmJz+AJkkM22g1sV3S/
NW/lTowd+RqAg4huygqQuNyjhT2dAlh7yCbSL5mJ2dpCmDUEa/evH6CMvRLP7J2Y
jm7MMMbXbidJagjdN6kpyMMRLmzTMy0xO27r6+FW0icSdNW+KOqPQxwEXP2IjFvP
So0uQa3QLBWeCjRP7xP/J5P3umwCUGcu1AD0arhxUkQGOkieyV+cNR6dlzOTXXlV
y1WAQB+KXJQ=
=e4Rg
-----END PGP SIGNATURE-----

--Sig_/WM=CmZa+3VE89FNl8p_B7zH--
