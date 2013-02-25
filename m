From: NeilBrown <neilb@suse.de>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Tue, 26 Feb 2013 09:54:52 +1100
Message-ID: <20130226095452.32e2392b@notabene.brown>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
	<20130225110458.2b1b1e2d@notabene.brown>
	<1361808662.20264.4.camel@148>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yuzBHlhkj/qtM8xcUByJW=d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361808662.20264.4.camel@148>
Sender: linux-raid-owner@vger.kernel.org
To: tbayly@bluehost.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yuzBHlhkj/qtM8xcUByJW=d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Feb 2013 09:11:02 -0700 Tregaron Bayly <tbayly@bluehost.com> wro=
te:

> > Actually  don't bother.  I think I've found the problem.  It is related=
 to
> > pending_count and is easy to fix.
> > Could you try this patch please?
> >=20
> > Thanks.
> > NeilBrown
> >=20
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 6e5d5a5..fd86b37 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -967,6 +967,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bo=
ol from_schedule)
> >  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
> >  		conf->pending_count +=3D plug->pending_cnt;
> >  		spin_unlock_irq(&conf->device_lock);
> > +		wake_up(&conf->wait_barrier);
> >  		md_wakeup_thread(mddev->thread);
> >  		kfree(plug);
> >  		return;
>=20
> Running 15 hours now and no sign of the problem, which is 12 hours
> longer than it took to trigger the bug in the past.  I'll continue
> testing to be sure but I think this patch is a fix.

Thanks.  I've added a "Tested-by" you to the patch header.

Should go to Linus, and thence to -stable in a day or 2.

NeilBrown

>=20
> Thanks for the fast response!
>=20
> Tregaron Bayly


--Sig_/yuzBHlhkj/qtM8xcUByJW=d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUSvrvDnsnt1WYoG5AQI2qA//dj3d7y/ngPmgWlXWB0zheXb92oOsGvT2
SXQ8NlsFYjD/kFuTlMZy/b1itAFSEFasUGgIoad7lg4zIfrdnb+dknBHcQFs5+va
r7mOr86bTPF8KkzjE6MTMEFaRXiiLajAydvX0s7zmPHET9xzKO8xXpCVUuypCzm3
2UDAfvuMTuIDJQSCIf6JNOWkNk/xx2c9lmBQ33TYkZOC1AdfqX+udzSd4GQHE3eY
DwJ5UMGHrFFmIA8L0IrAI18YCG9m7u8zx5BYBDO7y0IfUzUGorn7J3BZ2A1vqD6B
2Z7o9K03B2lDMXOubfOzTjINuxfbQjhE5BCT0sHFuR4bMf07cUu3hoEZ8Zru+o9j
FTcTMevRrFzQKxbJP08ZRGKe0VeYKNffIH7ZZY3kylMEJw2lovMEMhBp2+GVvEjI
Fdsza5aOBnYfRq7ql1252pBvFt+bLusEWdKH33QMP+TuKrTM5Hffuh+27ZWa0ZCq
9H/Ktc8x2JwKSgm+3O4pbZ+j8T6YxgjHRkiwNy+tTcvX1a182p7Qswz7x96RL/z+
ka7qJ29IGw3OjOlzTF5AvoYSXwm/G7dzZCIRez3Hy6U3T4k1DAtNhuG4kcOAQfI/
vRFVDK31pZopI50Putcfsz/Cd3yOFMIYbWkDnQNdNgEy4t+Z7LPJssr+CxkqZZ0S
5LcThggihCI=
=vS/c
-----END PGP SIGNATURE-----

--Sig_/yuzBHlhkj/qtM8xcUByJW=d--
