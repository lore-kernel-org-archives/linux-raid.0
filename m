From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 20/34] md/raid5: finalise new merged handle_stripe.
Date: Tue, 26 Jul 2011 13:50:53 +0900
Message-ID: <1311655853.1522.0.camel@leonhard>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	 <20110721023226.6728.78219.stgit@notabene.brown> <87hb6epshe.fsf@gmail.com>
	 <20110726120205.1962c301@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110726120205.1962c301@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-07-26 (=ED=99=94), 12:02 +1000, NeilBrown:
> On Fri, 22 Jul 2011 18:36:13 +0900 Namhyung Kim <namhyung@gmail.com> =
wrote:
>=20
> > NeilBrown <neilb@suse.de> writes:
> >=20
> > > handle_stripe5() and handle_stripe6() are now virtually identical=
=2E
> > > So discard one and rename the other to 'analyse_stripe()'.
> > >
> > > It always returns 0, so change it to 'void' and remove the 'done'
> > > variable in handle_stripe().
> > >
> > > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
>=20
> > >  static void handle_stripe(struct stripe_head *sh)
> > >  {
> > >  	struct stripe_head_state s;
> > > -	int done;
> > >  	raid5_conf_t *conf =3D sh->raid_conf;
> > >  	int i;
> > >  	int prexor;
> > > @@ -3099,13 +3015,7 @@ static void handle_stripe(struct stripe_he=
ad *sh)
> > >  	s.failed_num[0] =3D -1;
> > >  	s.failed_num[1] =3D -1;
> >=20
> > There are codes that set/initialize some fields of stripe_head_stat=
e
> > outside of analyse_stripe() and it'd better off moving them into th=
e
> > function, IMHO.
> >=20
> > Thanks.
>=20
> Thanks.  I have merged this change.
>=20
> NeilBrown
>=20
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ed6729d..b321d6c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2905,6 +2905,14 @@ static void analyse_stripe(struct stripe_head =
*sh, struct stripe_head_state *s)
>  	struct r5dev *dev;
>  	int i;
> =20
> +	memset(s, 0, sizeof(*s));
> +
> +	s->syncing =3D test_bit(STRIPE_SYNCING, &sh->state);
> +	s->expanding =3D test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
> +	s->expanded =3D test_bit(STRIPE_EXPAND_READY, &sh->state);
> +	s->failed_num[0] =3D -1;
> +	s->failed_num[1] =3D -1;
> +
>  	/* Now to look around and see what can be done */
>  	rcu_read_lock();
>  	spin_lock_irq(&conf->device_lock);
> @@ -3006,13 +3014,6 @@ static void handle_stripe(struct stripe_head *=
sh)
>  	       (unsigned long long)sh->sector, sh->state,
>  	       atomic_read(&sh->count), sh->pd_idx, sh->qd_idx,
>  	       sh->check_state, sh->reconstruct_state);
> -	memset(&s, 0, sizeof(s));
> -
> -	s.syncing =3D test_bit(STRIPE_SYNCING, &sh->state);
> -	s.expanding =3D test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
> -	s.expanded =3D test_bit(STRIPE_EXPAND_READY, &sh->state);
> -	s.failed_num[0] =3D -1;
> -	s.failed_num[1] =3D -1;
> =20
>  	analyse_stripe(sh, &s);
> =20

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

Looks great to me, thanks.


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
