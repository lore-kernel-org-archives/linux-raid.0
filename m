From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/3 v2]raid5: remove unnecessary bitmap write
 optimization
Date: Wed, 4 Jul 2012 16:17:43 +1000
Message-ID: <20120704161743.5f341277@notabene.brown>
References: <20120704052143.GB9145@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QPZuRXJTZ8d4i7GgTUX26kb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120704052143.GB9145@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QPZuRXJTZ8d4i7GgTUX26kb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Jul 2012 13:21:43 +0800 Shaohua Li <shli@kernel.org> wrote:

> Neil pointed out the bitmap write optimization in handle_stripe_clean_eve=
nt()
> is unnecessary, because the chance one stripe gets written twice in the m=
ean
> time is rare. We can always do a bitmap_startwrite when a write request is
> added to a stripe and bitmap_endwrite after write request is done.  Delet=
e the
> optimization. With it, we can delete some cases of device_lock.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

Thanks.  I've applied all three of these.
However...

> @@ -2455,6 +2455,7 @@ handle_failed_stripe(struct r5conf *conf
>  			s->to_write--;
>  			bitmap_end =3D 1;
>  		}
> +		spin_unlock_irq(&conf->device_lock);
> =20
>  		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>  			wake_up(&conf->wait_for_overlap);

I moved that spin_unlock_irq a little bit further up.

Thanks,
NeilBrown


--Sig_/QPZuRXJTZ8d4i7GgTUX26kb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/PgBznsnt1WYoG5AQINxQ/+JppuBbRMfIhkmqOfLrMhcH1xv6fh4W1N
6XIbzy7J3w1pDBvDluQKR3+3TOAwKHpRvqUWhwcxKCUN97vZQwCvFxzrGPwIR29X
9wA/+IUCV8gVBFiIf/y+esH9JqHZaplQfs4nzjCqci2ajzLLty3dIaozriLCyfYr
UD26R1MIg02QFlKaN59Uy8wmVICGPOFSEkAvu1NnD/WDYbnzbnbmcP3MxwRiBOaQ
M1JSnun7IHqpm2LMyhECm5gsyukcgYkzA30X5FcYw/b2HLzpxL1Cu0IP5g+uMscH
aH8BozlocODjwTCqMxJKssmr1+oS3RrgX14IZEDpyy51KkNWTYXsNk3jhtHCyWc1
iRgNPNcnjnG0ySRTgSszrdm7NNmqU9wI4HZMKmombdoXALy1sQZ9LstEX0S6Lw5L
CvIO7Haf0hJhlWu5wzzArd0zkBE6+O16n3uvbHw13oG0AkXkv5fJ6pDs27hk0wF/
wPu6GWCG1Ohh4jHa6vVlXkBfTAKx1jWxKkj8WxkcqUaDYl6qLWxcY0K26S/tWaLD
y/N4Sp2/GwK0yuDNeHb634Bssh9H30Zn7HiIyWsfSC3NlUTbZZa3vVje4XvsWelT
A3PB6MIxwURW5HFHb7y6wgoupfIKPG1e9xUfttSK47ryJ3tnh96QTwd9TVRhBCzZ
c4MG0BqkAMw=
=NvrN
-----END PGP SIGNATURE-----

--Sig_/QPZuRXJTZ8d4i7GgTUX26kb--
