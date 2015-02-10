From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Tue, 10 Feb 2015 13:50:17 +1100
Message-ID: <20150210135017.7659e49c@notabene.brown>
References: <54D3D24E.5060303@cybernetics.com>
	<20150206085133.2c1ab892@notabene.brown>
	<20150206113930.GK23123@twins.programming.kicks-ass.net>
	<20150209121357.29f19d36@notabene.brown>
	<20150209091000.GN5029@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wMd/doZnmBXJf9nN073BVL9"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150209091000.GN5029@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

--Sig_/wMd/doZnmBXJf9nN073BVL9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Feb 2015 10:10:00 +0100 Peter Zijlstra <peterz@infradead.org> wro=
te:

> On Mon, Feb 09, 2015 at 12:13:57PM +1100, NeilBrown wrote:
> > I had to re-read the code (And your analysis) a couple of times to be s=
ure ...
>=20
> Sorry :-)

My point was that actually reading it (rather than assuming I knew what it
said) actually helped!

>=20
> > However, when io_schedule() explicitly calls blk_flush_plug(), then
> > @from_schedule=3Dfalse variant is used, and the unplug functions are al=
lowed to
> > allocate memory and block and maybe even call mempool_alloc() which mig=
ht
> > call io_schedule().
> >=20
> > This shouldn't be a problem as blk_flush_plug() spliced out the plug li=
st, so
> > any recursive call will find an empty list and do nothing.
>=20
> Unless, something along the way stuck something back on, right? So
> should we stick an:
>=20
> 	WARN_ON(current->in_iowait);
>=20
> somewhere near where things are added to this plug list? (and move the
> blk_flush_plug() call inside of where that's actually true of course).

No, I don't think so.

It is certainly possible that some request on plug->cb_list could add
something to plug->list - which is processed after ->cb_list.

I think the best way to think about this is that the *problem* was that a
wait_event loop could spin without making any progress.   So any time that
clear forward progress is made it is safe sleep without necessitating the
warning.  Hence sched_annotate_sleep() is reasonable.
blk_flush_plug() with definitely have dispatched some requests if it
might_sleep(), so the sleep is OK.


>=20
> The only thing that really goes wrong then is if people 'forget' to put
> a loop around io_schedule().

You mean like in congestion_wait() ??

Though that is mostly called inside a loop...


NeilBrown

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 92f4b4b288dd..7334be27823d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1111,6 +1111,14 @@ static inline void blk_flush_plug(struct task_struct=
 *tsk)
 {
 	struct blk_plug *plug =3D tsk->plug;
=20
+	/*
+	 * Any sleeping in blk_flush_plug() should not
+	 * trigger the "do not call blocking ops" warning
+	 * as it makes clear forward process (requests are
+	 * dispatched) and so it will not cause indefinite
+	 * looping in a higher level wait loop.
+	 */
+	sched_annotate_sleep();
 	if (plug)
 		blk_flush_plug_list(plug, false);
 }

--Sig_/wMd/doZnmBXJf9nN073BVL9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNlx6Tnsnt1WYoG5AQII4xAAvxIL9CCTxIJZCpSM8/BOsv6ynSaZTiHD
E7mGWVZLh9jCimmx5yFEoBUOEPaVFcA1fZDVzS/UgyGYlG/0rT6plthNkyzpEXcm
eWcAzuFFxFmxSxZxuaiaq+qyJBBONgEb+UH8e/OnJf+x1Dl/x3E6a1qaz5gqD9VX
leeiSNcWGhxP9VfMgI8AVOuZxM8dmqhAP5u52mTF/MMA1tHu2UzwSN5bTj6ctEdP
8Bc4+TPHXjUj3sZJWZMiOciggjx4eOECwfgF0XINgk7DtAZXblfKqjxj6xb5fHhD
UNt1ZQLuuyNcJc/P8Evn3/+aDheWNfMW3o4+RQJJ+XZZmfoMm0tGdj6ostdZiPoy
vYScpHE0bGW1use+1cNIfr/snAVpcyY2JpKtl3TRJT2EWqZJeyozcI0jhtPc49O2
Vi6s9W5dalca0qUgYLrhsOpY5QIk+f/lGHq4SWc64JbxTtUnBa9Pz5lmxYfiTx15
xftIoGA3D9/6q+/nXKqu1kawyk5G6Md7FBfobtIXbjiP7GcK36tYLJj9Q+uOgEcT
sen5DLZ521d88C62fgW1KHuh7YSsddy9J45W8lCzyjt+IOhYneWdmu2bPvUJ2dYm
teUNPNPJS1Aw9ihr2BtO/PFLyiQV0saOS+PlE+zpLhbj4Y5zOeDB+XUprykTXgLT
QN1M3WCgeVs=
=nVw3
-----END PGP SIGNATURE-----

--Sig_/wMd/doZnmBXJf9nN073BVL9--
