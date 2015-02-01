From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: do_release_stripe(): No need to call
 md_wakeup_thread() twice
Date: Mon, 2 Feb 2015 10:25:23 +1100
Message-ID: <20150202102523.0556178f@notabene.brown>
References: <1422553109-29247-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/zNXmJz3ly8B.SW9=jwMHkAr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1422553109-29247-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zNXmJz3ly8B.SW9=jwMHkAr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Jan 2015 12:38:29 -0500 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> 67f455486d2ea20b2d94d6adf5b9b783d079e321 introduced a call to
> md_wakeup_thread() when adding to the delayed_list. However the md
> thread is woken up unconditionally just below.
>=20
> Remove the unnecessary wakeup call.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/md/raid5.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c1b0d52..41494d9 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -296,12 +296,9 @@ static void do_release_stripe(struct r5conf *conf, s=
truct stripe_head *sh,
>  	BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
>  	if (test_bit(STRIPE_HANDLE, &sh->state)) {
>  		if (test_bit(STRIPE_DELAYED, &sh->state) &&
> -		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
> +		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  			list_add_tail(&sh->lru, &conf->delayed_list);
> -			if (atomic_read(&conf->preread_active_stripes)
> -			    < IO_THRESHOLD)
> -				md_wakeup_thread(conf->mddev->thread);
> -		} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
> +		else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
>  			   sh->bm_seq - conf->seq_write > 0)
>  			list_add_tail(&sh->lru, &conf->bitmap_list);
>  		else {

Applied, thanks.

NeilBrown

--Sig_/zNXmJz3ly8B.SW9=jwMHkAr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM614znsnt1WYoG5AQIa2Q/7BZyRvMprFDMgk1DbiQQM108XaaOvoWfo
i2r3fuexSJLI+neEex84Bx1y04zMfaSCjc7fkuRvz8D1Iq2gqRWmX5Dcy1ZtmUns
5vYmQPkxoyG5TGHZEolO0l7y+KLrus13+gqjA0ioE7X8d9Pd1MVliegVoGrlPmK3
i1zGw/ULUElI8fHSJ+ylC3E1KcPFZf9Yi2CGmhR6ei0Q4TbMX+T37OoTsWuY7fw+
rYdT2QGfx0tNVxxyGEqZNtqAEKWDO0Dt4x5EiSH098wDIm8pbsFKwAd4YHrSRSD5
vJwqOxU7M5W3ToVCbDBeOFVoaxZGMU0lBzabYnP2N5EbG6mj3X0DMwI8/jpA8Am6
701VLPJ64fi0fVAcY/FTVKiY9S2BXOOlH0DYz7c1dlpnVV9JmhCaiTeBfebOzoWa
rwDidcp3wRbFljcquG3nYif2DrY2jxdwAGsm8UPpG81CZ/3K/ZPnguFZVNXoY/SC
0pmM7pNbVcGPfb7rRqEQpS6WPfKuCzDsCdYMWIMO0a4B+DEDPzg13F7Kuq8zuwRV
6ptwZnnVrX4aEnrjewDgRahVVjRl8xQa9mV8XI4Rl7lf9BzJ20Cb2RkWajyEGFN/
mFEYrBAH4iqaXST8HSX3vkjKUhOShBv/pTcflEnfV0KXy8p9Rf5iRLBzWoeg9Ecg
Md3YclKZbXw=
=u8eC
-----END PGP SIGNATURE-----

--Sig_/zNXmJz3ly8B.SW9=jwMHkAr--
