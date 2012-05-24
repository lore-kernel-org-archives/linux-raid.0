From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/4] raid1: directly dispatch write request if no bitmap
Date: Thu, 24 May 2012 13:09:12 +1000
Message-ID: <20120524130912.4076ea1a@notabene.brown>
References: <20120523072619.670179001@kernel.org>
	<20120523072829.967587288@kernel.org>
	<20120524122112.05b4d6e3@notabene.brown>
	<20120524025425.GA1190@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MWWXz+OJwqO3aYyKawBoKVl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120524025425.GA1190@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/MWWXz+OJwqO3aYyKawBoKVl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 May 2012 10:54:25 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, May 24, 2012 at 12:21:12PM +1000, NeilBrown wrote:
> > On Wed, 23 May 2012 15:26:20 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > In raid1, all write requests are dispatched in raid1d thread. In fast=
 storage,
> > > the raid1d thread is a bottleneck, because it dispatches request too =
slow. Also
> > > raid1d thread migrates freely, which makes request completion cpu not=
 match
> > > with submission cpu even driver/block layer has such capability. This=
 will
> > > cause bad cache issue.
> > >=20
> > > If no bitmap, there is no point to queue bio to a thread and dispatch=
 it in the
> > > thread. Directly dispatching bio doesn't impact correctness and remov=
es above
> > > bottleneck.
> > >=20
> > > Multiple threads dispatch requests could potentially reduce request m=
erge and
> > > increase lock contention. For slow stroage, we just worry about reque=
st merge.
> > > Caller of .make_request should already have correct block plug set, w=
hich will
> > > take care of request merge and locking just like accessing raw device=
, so we
> > > don't need worry about this too much.
> > >=20
> > > In a 4k randwrite test with a 2 disks setup, below patch can provide =
20% ~ 50%
> > > performance improvements depending on numa binding.
> > >=20
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > ---
> > >  drivers/md/raid1.c |   11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > >=20
> > > Index: linux/drivers/md/raid1.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux.orig/drivers/md/raid1.c	2012-05-22 13:50:26.989820654 +0800
> > > +++ linux/drivers/md/raid1.c	2012-05-22 13:56:46.117054559 +0800
> > > @@ -1187,10 +1187,13 @@ read_again:
> > >  		mbio->bi_private =3D r1_bio;
> > > =20
> > >  		atomic_inc(&r1_bio->remaining);
> > > -		spin_lock_irqsave(&conf->device_lock, flags);
> > > -		bio_list_add(&conf->pending_bio_list, mbio);
> > > -		conf->pending_count++;
> > > -		spin_unlock_irqrestore(&conf->device_lock, flags);
> > > +		if (bitmap) {
> > > +			spin_lock_irqsave(&conf->device_lock, flags);
> > > +			bio_list_add(&conf->pending_bio_list, mbio);
> > > +			conf->pending_count++;
> > > +			spin_unlock_irqrestore(&conf->device_lock, flags);
> > > +		} else
> > > +			generic_make_request(mbio);
> > >  	}
> > >  	/* Mustn't call r1_bio_write_done before this next test,
> > >  	 * as it could result in the bio being freed.
> >=20
> > This looks like it should be 'obviously correct' but unfortunately it i=
sn't.
> >=20
> > If this raid1 is beneath a dm device (e.g. LVM), then generic_make_requ=
est
> > will queue the request internally and not actually start it.
> > In particular this means that the cloned bio has no chance of being rel=
eased
> > before the next clone_bio call which is made on the next time around th=
e loop.
> >=20
> > This can lead to a deadlock as the clone_bio() might be waiting for that
> > first cloned bio to be released (if memory is really tight).
> >=20
> > i.e. when allocating multiple bios from a mempool, we need to arrange f=
or
> > them to be submitted by a separate thread.
>=20
> If there isn't block plug, generic_make_request will dispatch the request
> directly.

Not necessarily.  It might queue it:
	if (current->bio_list) {
		bio_list_add(current->bio_list, bio);
		return;
	}

NeilBrown



 If there is, when clone_bio() waits for memory, it will
> sleep/schedule, which will trigger block unplug and dispatch the first bi=
o, so
> no deadlock to me. Am I misunderstanding you?
>=20
> Thanks,
> Shaohua


--Sig_/MWWXz+OJwqO3aYyKawBoKVl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT72mWDnsnt1WYoG5AQJmOg//WPCgVKNU/pkQ4ROOo5hydP5y2TyjhAc+
h9VHFG/9FXGm9MAbwX+uWlbDc5yaNds6dx56e/mNDJgJXJ0HqjtWHJRjs4xywcje
wm/BqXTbyEwL1M4I7WpHSv7MQ1AUUtqS+3fQGAw/5ABxo3wlMQurf1xet4i6dVI2
b7pkCihJMgCkZo6S97evgV+ccJs74XYLB7ODVSzOF4hTbBsnImvDgA996id0p0md
LPPuS7Ip5507VLn6sMqbImi0SG56heoybUO4FkdhVdvN/m3eo/omqUllAol3Vphr
1bwC3uEfPNi7C5rcVnI4AwinNZudt4xzH7WNYYisvwwLJclLT36UfJ4RGTacfJ8g
udRAXS7DfjhYxoCQwtEhH0ynTjiezby9j2zxCYeXirJL7HhFMzcSwhGJHbTbl5Sc
s9iR13KmNEdE6b7JMx40LVFmi6GLZs78r49I09DHRh86AFAewbP3US12wFiGEBNj
CWExMYWnvszXlW60nRayjcofgTbgZMFz/b5Pir/9Er1SBRVEtweqC92PROeYSrpA
jIkItXhaYBmJXjBDDKllCx0y7FcUMKh6oLKbMLjXz2ly3MyYqT6zd6fJnMtg2PWQ
70V0K87d50FWGGTY8VlaCYbfQGVqyxtTyU4zeyxnx5dXsYCt+QvtZwlY58gk19wn
Um7fS4zIKYU=
=4vYj
-----END PGP SIGNATURE-----

--Sig_/MWWXz+OJwqO3aYyKawBoKVl--
