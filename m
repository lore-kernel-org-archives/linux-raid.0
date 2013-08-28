From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v3 5/5] raid5: only wakeup necessary threads
Date: Wed, 28 Aug 2013 16:59:47 +1000
Message-ID: <20130828165947.7b1b9553@notabene.brown>
References: <20130827095038.303090029@kernel.org>
	<20130827095518.881234515@kernel.org>
	<20130828141304.5e6df26e@notabene.brown>
	<20130828063159.GC17163@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ve+dQLhhGfy7TDNIc0s0W2+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130828063159.GC17163@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/Ve+dQLhhGfy7TDNIc0s0W2+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Aug 2013 14:31:59 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, Aug 28, 2013 at 02:13:04PM +1000, NeilBrown wrote:
> > On Tue, 27 Aug 2013 17:50:43 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> >=20
> > > @@ -229,8 +233,26 @@ static void raid5_wakeup_stripe_thread(s
> > > =20
> > >  	group =3D conf->worker_groups + cpu_to_group(sh->cpu);
> > > =20
> > > -	for (i =3D 0; i < conf->worker_cnt_per_group; i++)
> > > -		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
> > > +	group->workers[0].working =3D true;
> > > +	/* at least one worker should run to avoid race */
> > > +	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
> > > +
> > > +	thread_cnt =3D group->stripes_cnt / MAX_STRIPE_BATCH - 1;
> > > +	/* wakeup more workers */
> > > +	for (i =3D 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++=
) {
> > > +		if (group->workers[i].working =3D=3D false) {
> > > +			group->workers[i].working =3D true;
> > > +			queue_work_on(sh->cpu, raid5_wq,
> > > +				      &group->workers[i].work);
> > > +			thread_cnt--;
> > > +		} else if (group->workers[i].working_cnt <=3D
> > > +			   MAX_STRIPE_BATCH / 2)
> > > +			/*
> > > +			 * If a worker has no enough stripes handling, assume
> > > +			 * it will fetch more stripes soon.
> > > +			 */
> > > +			thread_cnt--;
> > > +	}
> > >  }
> >=20
> > I don't really understand this  "working_cnt <=3D MAX_STRIPE_BATCH / 2"
> > heuristic.  It is at best a very coarse estimate of how long until the =
worker
> > will get some more stripes to work on.
> > I think I would simply not count any thread that is already working (ex=
cept
> > the first, which is always counted whether it is working or not)
> > Do you see some particular gain from the counting?
> >=20
> >=20
> >=20
> > > -#define MAX_STRIPE_BATCH 8
> > > -static int handle_active_stripes(struct r5conf *conf, int group)
> > > +static int handle_active_stripes(struct r5conf *conf, int group,
> > > +		struct r5worker *worker)
> > >  {
> > >  	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> > >  	int i, batch_size =3D 0;
> > > @@ -4921,6 +4955,9 @@ static int handle_active_stripes(struct
> > >  			(sh =3D __get_priority_stripe(conf, group)) !=3D NULL)
> > >  		batch[batch_size++] =3D sh;
> > > =20
> > > +	if (worker)
> > > +		worker->working_cnt =3D batch_size;
> > > +
> > >  	if (batch_size =3D=3D 0)
> > >  		return batch_size;
> >=20
> > I think this could possibly return with ->working still 'true'.
> > I think it is safest to clear it on every exit from the function
>=20
> I need do more tests on this one. Could you please apply other patches to=
 your
> tree, then I can rebase this patch against it when I'm done.

Other patches are now applied and pushed out.

NeilBrown

--Sig_/Ve+dQLhhGfy7TDNIc0s0W2+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh2f4znsnt1WYoG5AQL0rw/+LNnhl7VJNbuuwkntvZtz+OnBfc3dAQyZ
ZRXn/AQ7bAhA69w7+iTi0gVrX+YzsJozV629e1IFv6A8JxxUh5wmYaKF1nPRVPSc
hNfsMk5BB5yQFg7SITSSktc/DIrSPCjNug/VBwHBJlFdOe47O4djaujlntRkRPlB
H5VdGVKKUXwcelokfah7+feflXuwGjvqCU2V/rn+1F5VYr+6lq+SWrKrv8auV4A7
iKuDnZ+AgUHQ+n00JvMJ2YERlnaAJLsevdqVs1d7O1wTEswqDGS0pqom4kUpRqGh
O/hCUXjBx6o4qEUCdOrZ84HuEcsLOKJJ6PZLLdP1Hv1q9qJ0F4oDR+0mWJV/Ft67
dNyaDkHPBGAM3x4c9nrwJWf7KoEAWx1BdnYfMoGdHyy6vD9u5oYzASneAEh8Lusx
eALfTdBqrwg15r85favVU9A68/MZVDv7wHOIGvfaRX1GnK8T0Vb430LgOwORqOY4
EO3qxCo50x9RpvGVJTfUMRRexT9vFaywDBYW/FwB3liiWsK9OV1YwfciRjj5gZzz
DF4P2XPzyekzFNwRAdn0mBaUvn7HkZvC1xGaocl2TSY63iH/aUl11tb9I5/Bkwy+
Bvk8w0MgwuSvVldiOtvCn6Nvp2mTD1pAyjQ0HwSKOns5CQbK8P1dNLtFhUHyXYjr
pxMuNMh/1Fs=
=ii81
-----END PGP SIGNATURE-----

--Sig_/Ve+dQLhhGfy7TDNIc0s0W2+--
