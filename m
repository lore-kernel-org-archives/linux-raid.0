From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 08/34] md/raid5: replace sh->lock with an 'active'
 flag.
Date: Fri, 22 Jul 2011 14:03:27 +0900
Message-ID: <1311311007.1325.2.camel@leonhard>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	 <20110721023225.6728.96772.stgit@notabene.brown> <87hb6fdjnr.fsf@gmail.com>
	 <20110722144920.2b933155@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110722144920.2b933155@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-07-22 (=EA=B8=88), 14:49 +1000, NeilBrown:
> On Fri, 22 Jul 2011 13:27:36 +0900 Namhyung Kim <namhyung@gmail.com> =
wrote:
>=20
> > NeilBrown <neilb@suse.de> writes:
> >=20
> > > sh->lock is now mainly used to ensure that two threads aren't run=
ning
> > > in the locked part of handle_stripe[56] at the same time.
> > >
> > > That can more neatly be achieved with an 'active' flag which we s=
et
> > > while running handle_stripe.  If we find the flag is set, we simp=
ly
> > > requeue the stripe for later by setting STRIPE_HANDLE.
> > >
> > > For safety we take ->device_lock while examining the state of the
> > > stripe and creating a summary in 'stripe_head_state / r6_state'.
> > > This possibly isn't needed but as shared fields like ->toread,
> > > ->towrite are checked it is safer for now at least.
> > >
> > > We leave the label after the old 'unlock' called "unlock" because=
 it
> > > will disappear in a few patches, so renaming seems pointless.
> > >
> > > This leaves the stripe 'locked' for longer as we clear STRIPE_ACT=
IVE
> > > later, but that is not a problem.
> > >
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > Reviewed-by: Namhyung Kim <namhyung@gmail.com>
>=20
> Thanks.
>=20
> >=20
> > But I have a question, please see below.
>=20
> I like questions...
>=20
> > > @@ -3037,6 +3028,7 @@ static void handle_stripe5(struct stripe_he=
ad *sh)
> > > =20
> > >  	/* Now to look around and see what can be done */
> > >  	rcu_read_lock();
> > > +	spin_lock_irq(&conf->device_lock);
> >=20
> > Do we still need rcu_read_lock()? AFAIK rcu_read_lock() only preven=
ts
> > task from preemption but spin_lock does same thing as well.
> >=20
> > I know it's been already there under sh->lock before this patch, an=
d
> > it doesn't hurt anything, but I'm not sure it is really needed.
>=20
> I see your point, but I think there are two reasons why it really is =
needed.
>=20
> 1/ I think rcu_read_lock does more than prevent preemption.  What it =
does
>    exactly I don't know and I think it depends on which RCU scheme wa=
s chosen
>    when configuring the kernel.  But what it conceptually does is sto=
p
>    a subsequent synchronize_rcu() from completing, and that it what I=
 need.
>    Disabling preemption might stop that as well, but I really don't k=
now and
>    so cannot trust it.
>=20
> 2/ It is useful documentation.  A reader seeing rcu_read_lock() knows=
 that
>    there must be some rcu-protected data here which needs to be handl=
ed with
>    a little care and so they can be on the lookout for it.
>=20
> So I think it is really needed.
>=20
> Thanks,
>=20
> NeilBrown
>=20

OK, looks reasonable. Thanks for the explanation. :)


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
