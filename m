From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v3 5/5] raid5: only wakeup necessary threads
Date: Wed, 28 Aug 2013 14:13:04 +1000
Message-ID: <20130828141304.5e6df26e@notabene.brown>
References: <20130827095038.303090029@kernel.org>
	<20130827095518.881234515@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7dk83I6d8zlLHN5uRWmmqOd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130827095518.881234515@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/7dk83I6d8zlLHN5uRWmmqOd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Aug 2013 17:50:43 +0800 Shaohua Li <shli@kernel.org> wrote:


> @@ -229,8 +233,26 @@ static void raid5_wakeup_stripe_thread(s
> =20
>  	group =3D conf->worker_groups + cpu_to_group(sh->cpu);
> =20
> -	for (i =3D 0; i < conf->worker_cnt_per_group; i++)
> -		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
> +	group->workers[0].working =3D true;
> +	/* at least one worker should run to avoid race */
> +	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
> +
> +	thread_cnt =3D group->stripes_cnt / MAX_STRIPE_BATCH - 1;
> +	/* wakeup more workers */
> +	for (i =3D 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
> +		if (group->workers[i].working =3D=3D false) {
> +			group->workers[i].working =3D true;
> +			queue_work_on(sh->cpu, raid5_wq,
> +				      &group->workers[i].work);
> +			thread_cnt--;
> +		} else if (group->workers[i].working_cnt <=3D
> +			   MAX_STRIPE_BATCH / 2)
> +			/*
> +			 * If a worker has no enough stripes handling, assume
> +			 * it will fetch more stripes soon.
> +			 */
> +			thread_cnt--;
> +	}
>  }

I don't really understand this  "working_cnt <=3D MAX_STRIPE_BATCH / 2"
heuristic.  It is at best a very coarse estimate of how long until the work=
er
will get some more stripes to work on.
I think I would simply not count any thread that is already working (except
the first, which is always counted whether it is working or not)
Do you see some particular gain from the counting?



> -#define MAX_STRIPE_BATCH 8
> -static int handle_active_stripes(struct r5conf *conf, int group)
> +static int handle_active_stripes(struct r5conf *conf, int group,
> +		struct r5worker *worker)
>  {
>  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
>  	int i, batch_size =3D 0;
> @@ -4921,6 +4955,9 @@ static int handle_active_stripes(struct
>  			(sh =3D __get_priority_stripe(conf, group)) !=3D NULL)
>  		batch[batch_size++] =3D sh;
> =20
> +	if (worker)
> +		worker->working_cnt =3D batch_size;
> +
>  	if (batch_size =3D=3D 0)
>  		return batch_size;

I think this could possibly return with ->working still 'true'.
I think it is safest to clear it on every exit from the function


Thanks,
NeilBrown

--Sig_/7dk83I6d8zlLHN5uRWmmqOd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh140Dnsnt1WYoG5AQLPTQ/+J50xF6YYKLO0oEdHCwWbuvZv18TKBgXa
3VOfck+NzJyAlkAWWqxFeAMd7+l4EFR3UH27YCLHYHp1SSEV9fMLh4EdgIfTdNbx
Vz6Mj2J2aoWs65BEeet5T6jx4Dp24dDtVT8AIBcU/RmH78VwH44acodlVfg2VYua
hjjJyQtJTMyX5P38u5FEv7MMqnvoQF4h/y2dstcFZNi1MJT1KE/VHyqqPNO2N85F
bWYtJQ9evi4ZKhRCY9L3GWAwwlOJ8C4gmh+cj4cJ8sCS2Bx43rjJgGQpKjElB5DD
4WjWp/sUZHW+JKEZY7uw8Tei/0UZIuBbT/HJgGEZ5TmrYlhguY/dX3n4a3oncIPH
sil8TSN/LtrSozhQbk6IqyCGMmD9kOT0AsRTnH/ITj2T7LBm1y1oXuBlNSlv7xLo
H8LlOP/N+AUA3oOU3iLt2BdaL3CvhnpMC21Xjb38bcfXhFHbiqIVrzLn9F6PwYAC
PLMuX3TbZjKRdDnINjxQtMObMw521hkWBtSklrJD7ZQk1Hzh7mkHQNjLlvXjzeLE
ip423FF/hXjD00C1GuKoK33VeWd7hZ18sEjJWeHCcB6AwioOW0GZr+LUNzLVNyhh
dZxPeoIKsxjMRmQoVv6G5s6Uqk5j08pJczYOFWHAQNXs/uynmNHFNoNDh2b3YzOc
hUNPvLZU9yA=
=cghc
-----END PGP SIGNATURE-----

--Sig_/7dk83I6d8zlLHN5uRWmmqOd--
