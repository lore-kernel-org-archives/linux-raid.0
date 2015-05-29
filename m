From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] raid5: wakeup raid5d when R5_ALLOC_MORE is set
Date: Fri, 29 May 2015 15:02:56 +1000
Message-ID: <20150529150256.6ca4211f@notabene.brown>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/b/sdxPI/s6tQ.j+GJhlFTIX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/b/sdxPI/s6tQ.j+GJhlFTIX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 May 2015 17:33:45 -0700 Shaohua Li <shli@fb.com> wrote:

> The run time stripe allocation is done at raid5d. When we set the
> R5_ALLOC_MORE flag, we should notify raid5d to handle it
>=20
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 61e8e04..bfa2042 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -674,9 +674,11 @@ get_active_stripe(struct r5conf *conf, sector_t sect=
or,
>  			if (!test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state)) {
>  				sh =3D get_free_stripe(conf, hash);
>  				if (!sh && llist_empty(&conf->released_stripes) &&
> -				    !test_bit(R5_DID_ALLOC, &conf->cache_state))
> +				    !test_bit(R5_DID_ALLOC, &conf->cache_state)) {
>  					set_bit(R5_ALLOC_MORE,
>  						&conf->cache_state);
> +					md_wakeup_thread(conf->mddev->thread);
> +				}
>  			}
>  			if (noblock && sh =3D=3D NULL)
>  				break;

Thanks for reviewing my code !!!

I'm not exactly against this patch, but I wonder if it is really needed.
R5_ALLOC_MORE is really just a hint - "You can allocate another stripe if y=
ou
like".  If the array is at all busy, raid5d will be called fairly often and
the allocation will happen.  If the array is idle, it doesn't matter if
memory is allocated for a while.  Does it?

Thanks,
NeilBrown

--Sig_/b/sdxPI/s6tQ.j+GJhlFTIX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWfzADnsnt1WYoG5AQI7Xw/8DbCXMJtdIOgj/VGpajIzr8WXE8llbZ0J
Wnb8iHexXZpLE/skiQdEBfsG3cwg2F9AmvqQtesdeRlNZ3HCHFbxizEn3Mqj1TmG
OaDjW/rJNWcyI1OVT8nNsw/GBmkw9V0kEgyBM4GNGin/uu4t+X2i1OgUnA/epre+
6DmLs4VKzxK9miy52LC3aRbgpn+yboON0zPh59Uew05jD1+lvbHIndVklLwCsxNF
JZ23xXH0JyOHQThlgE+xr4XKkrrRK3gU/wdhm/g/PUdzu5VkRMaLJMOnAAH37wuK
J4D6AUmFXTHj3Z6iC6E2C8ScEAnJjsJ4SzVYqLCzGSqG2xJ09unxyRyvl/Wku5qJ
6BqgeK8wcE4b62WP4TlGJ8dnXqek8fPEmf3470Ty8+I2XAvggvjjWOiXUDPsbvZL
AuqiyuzFVXueDPYjo7ADXJ/A9U1snf4KCbovrkM+2sc+/+m2wkw9mHX5FCAE7TcD
6YhIJ04essB+EjAazZG/2KhKkkTJx3VtQQc14n55R6jWm98xZAiVs8aefOuLs47b
hiz+InUssRvLP6Am8IlnVEzZccc+vigzmuxFF0RpbZ1a4LfUlHdzV9I5f4bIaMVp
BvKMfM9BoUXNclqncbSjIm0Lc9m19ZzNDDPCkLQMj1+CPTf9mKUSd4Y9R8dN0DiI
BvPX470O9S8=
=Ht2L
-----END PGP SIGNATURE-----

--Sig_/b/sdxPI/s6tQ.j+GJhlFTIX--
