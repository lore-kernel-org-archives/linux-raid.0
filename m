From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Fri, 13 Feb 2015 16:26:00 +1100
Message-ID: <20150213162600.059fffb2@notabene.brown>
References: <54D3D24E.5060303@cybernetics.com>
	<20150206085133.2c1ab892@notabene.brown>
	<20150206113930.GK23123@twins.programming.kicks-ass.net>
	<20150209121357.29f19d36@notabene.brown>
	<20150209091000.GN5029@twins.programming.kicks-ass.net>
	<20150210135017.7659e49c@notabene.brown>
	<20150210092936.GW21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/9FmO31../+OH1BUi+4oTm/4"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150210092936.GW21418@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

--Sig_/9FmO31../+OH1BUi+4oTm/4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Feb 2015 10:29:36 +0100 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Tue, Feb 10, 2015 at 01:50:17PM +1100, NeilBrown wrote:
> > On Mon, 9 Feb 2015 10:10:00 +0100 Peter Zijlstra <peterz@infradead.org>=
 wrote:
> > > > However, when io_schedule() explicitly calls blk_flush_plug(), then
> > > > @from_schedule=3Dfalse variant is used, and the unplug functions ar=
e allowed to
> > > > allocate memory and block and maybe even call mempool_alloc() which=
 might
> > > > call io_schedule().
> > > >=20
> > > > This shouldn't be a problem as blk_flush_plug() spliced out the plu=
g list, so
> > > > any recursive call will find an empty list and do nothing.
> > >=20
> > > Unless, something along the way stuck something back on, right? So
> > > should we stick an:
> > >=20
> > > 	WARN_ON(current->in_iowait);
> > >=20
> > > somewhere near where things are added to this plug list? (and move the
> > > blk_flush_plug() call inside of where that's actually true of course).
> >=20
> > No, I don't think so.
> >=20
> > It is certainly possible that some request on plug->cb_list could add
> > something to plug->list - which is processed after ->cb_list.
> >=20
> > I think the best way to think about this is that the *problem* was that=
 a
> > wait_event loop could spin without making any progress.   So any time t=
hat
> > clear forward progress is made it is safe sleep without necessitating t=
he
> > warning.  Hence sched_annotate_sleep() is reasonable.
> > blk_flush_plug() with definitely have dispatched some requests if it
> > might_sleep(), so the sleep is OK.
>=20
> Well, yes, but you forget that this gets us back into recursion land.
> io_schedule() calling io_schedule() calling io_schedule() and *boom*
> stack overflow -> dead machine.
>=20
> We must either guarantee io_schedule() will never call io_schedule() or
> that io_schedule() itself will not add new work to the current plug such
> that calling io_schedule() itself will not recurse on the blk stuff.
>=20
> Pick either option, but pick one.

I choose ... Buzz Lightyear !!!

Sorry, go carried away there.  Uhhmm.  I think I pick a/  (But I expect I'll
find a goat... ho hum).

Does this look credible?

Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Fri, 13 Feb 2015 15:49:17 +1100
Subject: [PATCH] sched: prevent recursion in io_schedule()

io_schedule() calls blk_flush_plug() which, depending on the
contents of current->plug, can initiate arbitrary blk-io requests.

Note that this contrasts with blk_schedule_flush_plug() which requires
all non-trivial work to be handed off to a separate thread.

This makes it possible for io_schedule() to recurse, and initiating
block requests could possibly call mempool_alloc() which, in times of
memory pressure, uses io_schedule().

Apart from any stack usage issues, io_schedule() will not behave
correctly when called recursively as delayacct_blkio_start() does
not allow for repeated calls.

So:
 - use in_iowait to detect recursion.  Set it earlier, and restore
   it to the old value.
 - move the call to "raw_rq" after the call to blk_flush_plug().
   As this is some sort of per-cpu thing, we want some chance that
   we are on the right CPU
 - When io_schedule() is called recurively, use blk_schedule_flush_plug()
   which cannot further recurse.
 - as this makes io_schedule() a lot more complex and as io_schedule()
   must match io_schedule_timeout(), but all the changes in io_schedule_tim=
eout()
   and make io_schedule a simple wrapper for that.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1f37fe7f77a4..90f3de8bc7ca 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4420,30 +4420,27 @@ EXPORT_SYMBOL_GPL(yield_to);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq =3D raw_rq();
-
-	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
-	blk_flush_plug(current);
-	current->in_iowait =3D 1;
-	schedule();
-	current->in_iowait =3D 0;
-	atomic_dec(&rq->nr_iowait);
-	delayacct_blkio_end();
+	io_schedule_timeout(MAX_SCHEDULE_TIMEOUT);
 }
 EXPORT_SYMBOL(io_schedule);
=20
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq =3D raw_rq();
+	struct rq *rq;
 	long ret;
+	int old_iowait =3D current->in_iowait;
+
+	current->in_iowait =3D 1;
+	if (old_iowait)
+		blk_schedule_flush_plug(current);
+	else
+		blk_flush_plug(current);
=20
 	delayacct_blkio_start();
+	rq =3D raw_rq();
 	atomic_inc(&rq->nr_iowait);
-	blk_flush_plug(current);
-	current->in_iowait =3D 1;
 	ret =3D schedule_timeout(timeout);
-	current->in_iowait =3D 0;
+	current->in_iowait =3D old_iowait;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;

--Sig_/9FmO31../+OH1BUi+4oTm/4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVN2K6Dnsnt1WYoG5AQILyA//VBT6XrziB4i1pjAqpW87FiFwsAXo/Y1q
U+zzcaJTQbC+fudxCTwp7WVAdRBXr7nIDmrzRKAW6Ls3hGImaEEJEvEVyBHeobcd
l+X034YGpr4RDajU878GBYCFP6VsFn8Ts2gt35gyXF94vhkr0+4NhQapYO6Hf4l/
3srLIriZaI0klXKEMMNJ995cdA3kvwedgvduNbXT4mwlk8NtBAw8IfxJE6E7d+nj
WICLP+2JC8ZEwZwdnS1DGj2fPGRXen3WXz7dQTQOCoQv/FvIBW3nV1PvwVnWv0oe
XH4rLbxv5W8YGtKUz+iH8cki4VjO9toKQijnjBNjqj5PUebvR+rQWuxlwLxuLd+h
hDIusJSSGFIbYAr1luofkBC29WFcB2ffNrzbg1s199PA30JeZLmBOxFAHWpRNRJf
icg3psurg8kkPfEapFiI/5s1VjJp5MSYZ1uPtU4WccbDwtvJ4VhXwKwr37yj06xJ
Fg8IPtT05yxeJSkMAM9jjMiYr2Q9g0HlwwbYe57SGVtPb4gH17g3xWL1YuGmdVjT
vV8aec/dt7+SyesOpYyxCMXU1jyUx17up++9bnUKu9VR/LeD80n9aVoZ7q07OJXV
asA9dtD5DKywgoL1YF1a2y4CGp+gfjxE9MSNIpmPRbdVHvQWzEc68SGoJYH1Q7bM
QJ7cZg4Qr+4=
=D5UB
-----END PGP SIGNATURE-----

--Sig_/9FmO31../+OH1BUi+4oTm/4--
