From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v3 3/5] raid5: offload stripe handle to workqueue
Date: Wed, 28 Aug 2013 13:53:05 +1000
Message-ID: <20130828135305.3f328d92@notabene.brown>
References: <20130827095038.303090029@kernel.org>
	<20130827095452.202091257@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RelDit9Z5glkr.=mUrDDxo5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130827095452.202091257@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/RelDit9Z5glkr.=mUrDDxo5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Aug 2013 17:50:41 +0800 Shaohua Li <shli@kernel.org> wrote:

> -static struct stripe_head *__get_priority_stripe(struct r5conf *conf)
> +static struct stripe_head *__get_priority_stripe(struct r5conf *conf, in=
t group)
>  {
> -	struct stripe_head *sh;
> +	struct stripe_head *sh =3D NULL, *tmp;
> +	struct list_head *handle_list =3D NULL;
> +
> +	if (conf->worker_cnt_per_group =3D=3D 0) {
> +		handle_list =3D &conf->handle_list;
> +		if (list_empty(handle_list))
> +			handle_list =3D NULL;
> +	} else if (group !=3D ANY_GROUP) {
> +		handle_list =3D &conf->worker_groups[group].handle_list;
> +		if (list_empty(handle_list))
> +			handle_list =3D NULL;
> +	} else {
> +		int i;
> +		for (i =3D 0; i < conf->group_cnt; i++) {
> +			handle_list =3D &conf->worker_groups[i].handle_list;
> +			if (!list_empty(handle_list))
> +				break;
> +		}
> +		if (i =3D=3D conf->group_cnt)
> +			handle_list =3D NULL;
> +	}

Sorry, I meant to mention this last time...

The setting of handle_list to NULL seems unnecessary.  It is sufficient to
test if it is empty.
The only interesting case is the last 'else' above.  That is only reached if
worker_cnt_per_group !=3D 0 so handle_list will get set to some list_head.
If all list_heads are empty, handle_list will be set to the last list_head
so a list_empty(handle_list) test is perfectly safe.

Also with the current code:
> =20
>  	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\n",
>  		  __func__,
> -		  list_empty(&conf->handle_list) ? "empty" : "busy",
> +		  list_empty(handle_list) ? "empty" : "busy",
                  ^^^^^^^^^^^^^^^^^^^^^^^
This will crash.


Could you fix that up please?
Thanks.
NeilBrown

--Sig_/RelDit9Z5glkr.=mUrDDxo5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh10ITnsnt1WYoG5AQJDrxAAhVzKks1kuyKNvBVOoy2Sx1Dzm/u5vNPl
rHo13nAnkrYLHgBygaIdgdGGUtLvDc4UhJRUDJyJns6NBo1bex1fzOaCQzAhXifJ
uPI6Y1X8DiuP/+pD7orQYkckH1I1tLrhzfGQLAWEFGbTGIqQdvzzQ/MjGqDI63zs
S71fYltTVGONJfVgNb3X4WEPt0PwT331FmxjREvr9mj4uxG1uT9BbhtZdckkz29H
7L9cDi5U85vbYycj1T6hOETDDJo4b3gJxFwz/0Pdtxj490kvyXKZFYJIYDGnMFF8
7EdiVjk8RxZ6W7BZtrOzy5WnibfHiWTR2BfYdkqdWezfMvvvYbLU9U3tQGPNHLhV
vvXUeeznvf7s4a7orilkTEp/Gj5HIXAWAOtaeBVNVEgfRsUS6wmJttOuySoNGZuk
U/nzrtAhLH/YlMKQgbsjhtKdF589LWKww4q6pXAC/HvCK0ymS3Cd8IadhwPtXBU6
JhtWYyUFgnrWcakzjKCitIfjpznXgLsrRiOAuH/fRucWqzAxO36MxZkfxuAgqdbP
+0dslLWWOmIN28j8JHqtgCAUo6e7QoGBC5b4UiKJS0deZ41i+wMh9qfIBYpYGNQL
hogtpWBha6la34tNFSRy6TMCJzZM4XT6E8rNLLP6AmYLomwZFqh9vC5KZqJiZlFK
q2WQhseTnjw=
=rNMs
-----END PGP SIGNATURE-----

--Sig_/RelDit9Z5glkr.=mUrDDxo5--
