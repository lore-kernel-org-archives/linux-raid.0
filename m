From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: delete another BUG_ON
Date: Tue, 15 Apr 2014 08:47:03 +1000
Message-ID: <20140415084703.46b99886@notabene.brown>
References: <20140414061417.GA26258@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BR8YIFU2s/H_elsmOWP/QTO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140414061417.GA26258@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BR8YIFU2s/H_elsmOWP/QTO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Apr 2014 14:14:17 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> I hit another BUG_ON with e240c1839d11152b0355442. In __get_priority_stri=
pe(),
> stripe count equals to 0 initially. Between atomic_inc and BUG_ON,
> get_active_stripe() finds the stripe. So the stripe count isn't 1 any mor=
e.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-04-14 11:44:11.448492119 +0800
> +++ linux/drivers/md/raid5.c	2014-04-14 11:52:19.158359774 +0800
> @@ -4371,7 +4371,6 @@ static struct stripe_head *__get_priorit
>  	}
>  	list_del_init(&sh->lru);
>  	atomic_inc(&sh->count);
> -	BUG_ON(atomic_read(&sh->count) !=3D 1);
>  	return sh;
>  }
> =20

What if we made those two lines:
=20
  BUG_ON(atomic_inc_return(&sh->count) !=3D 1);

??

NeilBrown

--Sig_/BR8YIFU2s/H_elsmOWP/QTO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0xlZznsnt1WYoG5AQIw7BAAoICiwyK+d1k2KgWNAinBEE4I0LQ6wwQo
m46VGUNXma8vZc46e38KmHt0fqsiz0bcjiEJt2gZ8/1ysqjRV8aMwmVjsyIFWTlD
BUGupjdOG0RrkPGaJusBz4zcg3KN+kQUXn1NVt4tEqBz4SUs7/RnsF6JJIPT7cRj
uprnTLzJKpz7s2dRb6o6BDAZuz0DYhwFc3zJS0wP0cG1glColJoXu/8re3yQESqh
5yezsnP3F7soZTVfGAeRu+GQMzgRypHNCCz0oMcQLFipbWQW1HopKWsyxFbxkkKu
WPoH8f+6+MEJEHhReWm3Hc3d3idETtfpTFwQmoKc2zuC3Ir1MzbkHHAytSmlaz7+
EVDn1K/9QZBPl/FRS28u0ph++rUxqbXOFuZvMZBpZjv7/cKFSYWi6D2CM741O+ZR
6+URk6auMiOuKQ0MB6AAJZZIoyKY5+x40VO7Fpsqeiorciqe8jfvIcKvNmd1BiGr
ogapRnWcdfWmgp+bE5tu4y7RY8HZU9bWg5eYSyq/PtVGWyhnGONnpamLJIGwDQsh
uMrfSlY0U/S9MFxD9HC/FW9ZI5PdwgN3FyAUKkATAIXm+RjvFXo2fHuIirWvOh9d
Z916NgKCPAOjtEw7ITdwlMqmLnFhqAEjujN6lwnyKeFJ5oV/cg7oRUk96pkL7u94
H/Wa0tdjb7k=
=bfdS
-----END PGP SIGNATURE-----

--Sig_/BR8YIFU2s/H_elsmOWP/QTO--
