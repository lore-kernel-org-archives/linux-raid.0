From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Mon, 9 Feb 2015 12:13:57 +1100
Message-ID: <20150209121357.29f19d36@notabene.brown>
References: <54D3D24E.5060303@cybernetics.com>
	<20150206085133.2c1ab892@notabene.brown>
	<20150206113930.GK23123@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/454rLpD2zVlna7.fkUiQ5o1"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150206113930.GK23123@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

--Sig_/454rLpD2zVlna7.fkUiQ5o1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Feb 2015 12:39:30 +0100 Peter Zijlstra <peterz@infradead.org> wro=
te:

> On Fri, Feb 06, 2015 at 08:51:33AM +1100, NeilBrown wrote:
> > That is exactly what is happening here.  However I don't think that is =
an
> > "observed problem" but rather an "observed false-positive".
> >=20
> > If nothing inside the outer loop blocks, then in particular
> > generic_make_request will not be called, so nothing will be added to the
> > queue that blk_schedule_flush_plug flushes.
> > So the first time through the loop, a call the 'schedule()' may not act=
ually
> > block, but every subsequent time it will.
> > So there is no actual problem here.
> >=20
> > So I'd be included to add sched_annotate_sleep() in blk_flush_plug_list=
().
> >=20
> > Peter: what do you think is the best way to silence this warning.
>=20
> > > Call Trace:
>=20
> > >  [<ffffffff8027ee62>] __might_sleep+0x82/0x90
> > >  [<ffffffff803bee06>] generic_make_request_checks+0x36/0x2d0
> > >  [<ffffffff803bf0b3>] generic_make_request+0x13/0x100
> > >  [<ffffffff8054983b>] raid1_unplug+0x12b/0x170
> > >  [<ffffffff803c1302>] blk_flush_plug_list+0xa2/0x230
> > >  [<ffffffff80646383>] io_schedule+0x43/0x80
> > >  [<ffffffff80646787>] bit_wait_io+0x27/0x50
>=20
> Well, I don't know. I don't particularly like the whole blk_flush_plug()
> thing scheduling while on its way to schedule. If you ever end up
> calling io_schedule() from it there's 'fun'.
>=20
> Also, how likely is it to actually schedule when doing all that? This
> block layer stuff is somewhat impenetrable for me, too many callbacks.
>=20
> You have some words on how its unlikely, but I can't even find _where_
> it would schedule :/ All I see is a loop calling ->make_request_fn() and
> god only knows where that ends up.
>=20
> So there appear to be two blk_flush_plug() variants, one with an
> @from_schedule =3D true, which seems to really try not to schedule, which
> seems to suggest the 'false' one (the one above) is meant to schedule?
>=20
> If scheduling is the rule rather than the exception, the above is
> properly broken.
>=20
> But again, I don't know.

I had to re-read the code (And your analysis) a couple of times to be sure =
...

As you say, when schedule() calls blk_schedule_flush_plug(), the
@from_schedule=3Dtrue variant is used and the unplug code doesn't block.
So there is no problem there.

However, when io_schedule() explicitly calls blk_flush_plug(), then
@from_schedule=3Dfalse variant is used, and the unplug functions are allowe=
d to
allocate memory and block and maybe even call mempool_alloc() which might
call io_schedule().

This shouldn't be a problem as blk_flush_plug() spliced out the plug list, =
so
any recursive call will find an empty list and do nothing.

Worst case is that a wait_event loop that calls io_schedule() (i.e.
wait_on_bit_io()) might not block in the first call to io_schedule()
if the unplugging needed to wait.  Every subsequent call will block as
required as there is nothing else to add requests to the plug queue.

So as long as wait_on_bio_io() can cope with a single false wakeup (which it
can), there is no problem here.

>=20
> If you're confident that scheduling is rare for _ALL_ (current and
> future) block device implementations, not just the raid one, then you
> can annotate blk_flush_plug_list() I suppose.
>=20
> Otherwise I would suggest adding them one at a time in whatever blk
> device thing likes to go schedule on us. Also, add a comment that
> explains why its rare for the future us who need to look at it again.

It isn't that scheduling is "rare" - it is that it can only occur once in a
loop which doesn't expect it.

So I propose the following, though I haven't tested it.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e628cb11b560..b0f12ab3df23 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4374,6 +4374,11 @@ void __sched io_schedule(void)
=20
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	/* Any sleeping in blk_flush_plug() should not
+	 * trigger the "do not call blocking ops" warning
+	 * as it can only happen once in a wait_event loop.
+	 */
+	sched_annotate_sleep();
 	blk_flush_plug(current);
 	current->in_iowait =3D 1;
 	schedule();
@@ -4390,6 +4395,11 @@ long __sched io_schedule_timeout(long timeout)
=20
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
+	/* Any sleeping in blk_flush_plug() should not
+	 * trigger the "do not call blocking ops" warning
+	 * as it can only happen once in a wait_event loop.
+	 */
+	sched_annotate_sleep();
 	blk_flush_plug(current);
 	current->in_iowait =3D 1;
 	ret =3D schedule_timeout(timeout);


--Sig_/454rLpD2zVlna7.fkUiQ5o1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNgJ1Tnsnt1WYoG5AQJyYQ//QVp2tM8N++7LZgzyysrdhgHch5QKT8r/
HjtQFvPgoIxH1FNqEEk+0KcZ9q7NgLnAiizUpaBrsDyt4VVWL3wk+NVqduE8h/Ns
GG++6tVD3NW8dsPmz6r0xKPTQCWou+Yaz77/GNtI6ra5Homyph8Gv41OIRX9A8HF
UQAvbE97cil4lLZcnj0n7W6jrb5r8FCx8Dp3fRRDgE1ILAIjZd3CA/ibSm73z/FB
SIXv/dINd8sUP8lL5ge8s/sOHmjrWm+vVqub4zbV3TiCSC+OZW71NgBuoMv/t6Al
gVPw5wnPjpmPEfxaRbp0tKypzLm6A6NvMaZHzWl39JiyikuXOqJMtF5P6YDpvZIO
9k30k0IdUVUABmzd5s5EP+Bu4oQtJhzkEczgjSfCzMRGYEDC4x2S2p7r/4gP6E7z
MUqNICrklezMjM1WF8XEud9Y8HYvEkvnsPtz0orJd7ZRvmhkdUD6WKpuAofaL8RW
AMPngSdOjNNhAEVyaLjqDfR3ywos3rYDoAOx+VeW/UNEPMJWsKxj3pwED3Jq4jbZ
aOr+U5UhZ79z3o84lqUSHn9sRsKyC+ZNwlBlX7WqrX/dmB9cHZp0Cf6kHgwGaM+Z
4ZrqamyZZX4b+BoTJuJicm1EsD0F6AV1hHtS1cyfko173sHTw7rVx903zX5yJo4z
p8wdXUPMy10=
=SE7F
-----END PGP SIGNATURE-----

--Sig_/454rLpD2zVlna7.fkUiQ5o1--
