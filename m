From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Fri, 13 Feb 2015 19:49:53 +1100
Message-ID: <20150213194953.0368355d@notabene.brown>
References: <54D3D24E.5060303@cybernetics.com>
	<20150206085133.2c1ab892@notabene.brown>
	<20150206113930.GK23123@twins.programming.kicks-ass.net>
	<20150209121357.29f19d36@notabene.brown>
	<20150209091000.GN5029@twins.programming.kicks-ass.net>
	<20150210135017.7659e49c@notabene.brown>
	<20150210092936.GW21418@twins.programming.kicks-ass.net>
	<20150213162600.059fffb2@notabene.brown>
	<20150213083250.GN2896@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PEvtwWrUmM3Ck_fww+ADJdg"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150213083250.GN2896@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

--Sig_/PEvtwWrUmM3Ck_fww+ADJdg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2015 09:32:50 +0100 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Fri, Feb 13, 2015 at 04:26:00PM +1100, NeilBrown wrote:
> > I choose ... Buzz Lightyear !!!
>=20
> Great choice!
>=20
> > From: NeilBrown <neilb@suse.de>
> > Date: Fri, 13 Feb 2015 15:49:17 +1100
> > Subject: [PATCH] sched: prevent recursion in io_schedule()
> >=20
> > io_schedule() calls blk_flush_plug() which, depending on the
> > contents of current->plug, can initiate arbitrary blk-io requests.
> >=20
> > Note that this contrasts with blk_schedule_flush_plug() which requires
> > all non-trivial work to be handed off to a separate thread.
> >=20
> > This makes it possible for io_schedule() to recurse, and initiating
> > block requests could possibly call mempool_alloc() which, in times of
> > memory pressure, uses io_schedule().
> >=20
> > Apart from any stack usage issues, io_schedule() will not behave
> > correctly when called recursively as delayacct_blkio_start() does
> > not allow for repeated calls.
>=20
> Which seems to still be an issue with this patch.
>=20
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 1f37fe7f77a4..90f3de8bc7ca 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4420,30 +4420,27 @@ EXPORT_SYMBOL_GPL(yield_to);
> >   */
> >  void __sched io_schedule(void)
> >  {
> > +	io_schedule_timeout(MAX_SCHEDULE_TIMEOUT);
> >  }
> >  EXPORT_SYMBOL(io_schedule);
>=20
> Might as well move it to sched.h as an inline or so..
>=20
> >  long __sched io_schedule_timeout(long timeout)
> >  {
> > +	struct rq *rq;
> >  	long ret;
> > +	int old_iowait =3D current->in_iowait;
> > +
> > +	current->in_iowait =3D 1;
> > +	if (old_iowait)
> > +		blk_schedule_flush_plug(current);
> > +	else
> > +		blk_flush_plug(current);
> > =20
> >  	delayacct_blkio_start();
> > +	rq =3D raw_rq();
> >  	atomic_inc(&rq->nr_iowait);
> >  	ret =3D schedule_timeout(timeout);
> > +	current->in_iowait =3D old_iowait;
> >  	atomic_dec(&rq->nr_iowait);
> >  	delayacct_blkio_end();
> >  	return ret;
>=20
> Like said, that will still recursive call delayacct_blkio_*() and would
> increase nr_iowait for a second time; while arguably its still the same
> one io-wait instance.

No it doesn't.  There is no "blk_flush_plug" call between the
delayacct_blkio_*() calls.

I've moved blk_flush_plug to the beginning of the function.

>=20
> So would a little something like:
>=20
> long __sched io_schedule_timeout(long timeout)
> {
> 	struct rq *rq;
> 	long ret;
>=20
> 	/*
> 	 * Recursive io_schedule() call; make sure to not recurse
> 	 * on the blk_flush_plug() stuff again.
> 	 */
> 	if (unlikely(current->in_iowait)) {
> 		/*
> 		 * Our parent io_schedule() call will already have done
> 		 * all the required io-wait accounting.
> 		 */
> 		blk_schedule_flush_plug(current);
> 		return schedule_timeout(timeout);
> 	}
>=20
> 	current->in_iowait =3D 1;
> 	delayacct_blkio_start();
> 	rq =3D raw_rq();
> 	atomic_inc(&rq->nr_iowait);
> 	blk_flush_plug(current);
> 	ret =3D schedule_timeout(timeout);
> 	atomic_dec(&rq->nr_iowait);
> 	delayacct_blkio_end();
> 	current->in_iowait =3D 0;
>=20
> 	return ret;
> }
>=20
> not make more sense?=20

That does make a similar amount of sense at least....

I wondered if it really make sense to call blk_flush_plug with nr_iowait
elevated and delayacct_blkio active.  blk_flush_plug() could call schedule()
for non-"io" reasons and maybe that could upset stuff???

I don't really know.  I'm happy with your version.  I don't suppose anyone
else is paying attention and could give a third opinion....

Thanks,
NeilBrown



> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/PEvtwWrUmM3Ck_fww+ADJdg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVN26sTnsnt1WYoG5AQIjRg//XlfxZmCwGaWujQNfB+DtTR1mUIRtCHbo
5X2I692+9VN1fS8W6V72ePnxhKxO+g+mv2J5ScCEX0Hi1ekOmMRCLfgBAPrHGCya
AiRnUj8ATiMr3MNyoUA4BIXQqwverMuzERjyKVj2utSIQrgn8U4KxybxotSIGsMj
wbtTVodOIU9APe+rYw1Lj/48Mb2TFF16oRrfD3lIzZso0V4aP1cJNp9WXMmJlbVE
cjfVcED4NTKpEF+ZQgmNL+QEkse2F4O97LZouUf9OR4CqxUxYHobCG8JkBl2vf+D
gEAmSfAqB/lA6kwCi5WklxXqdTmvMbqhjGbYICMdFn5uk+I+Rhd5Un3ak9rhOhl5
Ll5QCZa8zGh5ShO4oUD5hoIYAaJPWGSE4D/fI3ZDAwNz+AE05VbWfj32YIIumaa2
nFEDgwTTm9/TK2AyXITvxzIhAcGcBEopksZkQd4TAxrz98KHNxiEqR6ROYT75f+E
ketPd1cNwoTrMV11lqNrYNmmCmIzeOX+UHI9lNUlr1B6SVzX25xbTGwvw6is354+
/MITvePKQ2uG9NXy/uq+HOKN+OaVDEZqzv2ix1T/NJ7lg/CIF0d49Wsm8ZbjBp7Z
GMIxkgcjwqMvTFW8ubHa7nznNod3Hodimh+L9kZzNXWsetmQtHIdMurTTJDTPrMh
dyOyZP92Q8Y=
=b+sI
-----END PGP SIGNATURE-----

--Sig_/PEvtwWrUmM3Ck_fww+ADJdg--
