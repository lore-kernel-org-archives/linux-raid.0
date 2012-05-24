From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/4] raid1: percpu dispatch for write request if bitmap
 supported
Date: Thu, 24 May 2012 15:34:12 +1000
Message-ID: <20120524153412.106d5a0c@notabene.brown>
References: <20120523072619.670179001@kernel.org>
	<20120523072838.580242059@kernel.org>
	<20120524133402.0f217e71@notabene.brown>
	<20120524051709.GA1191@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3ybLLc_wjwzEv.aXEgd5cxG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120524051709.GA1191@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/3ybLLc_wjwzEv.aXEgd5cxG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 May 2012 13:17:09 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, May 24, 2012 at 01:34:02PM +1000, NeilBrown wrote:
> > On Wed, 23 May 2012 15:26:21 +0800 Shaohua Li <shli@kernel.org> wrote:
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
> > > If bitmap support is enabled, write requests can only be dispatched a=
fter dirty
> > > bitmap is flushed out. After bitmap is flushed, how write requests are
> > > dispatched doesn't impact correctness. A natural idea is to distribut=
e request
> > > dispatch to several threads. With this patch, requests are added to a=
 percpu
> > > list first. After bitmap is flushed, then the percpu list requests wi=
ll
> > > dispatched in a workqueue. In this way, above bottleneck is removed.
> > >=20
> > > In a 4k randwrite test with a 2 disks setup, below patch can provide =
10% ~ 50%
> > > performance improvements depending on numa binding.
> >=20
> > Those numbers are quite impressive so there is certainly room for impro=
vement
> > here.  I'm not sure that I'm entirely comfortable with the approach tho=
ugh.
> >=20
> > Passing the request to a per-cpu thread does make sense, but a generic
> > per-cpu thread feels dangerous as we don't know what else might be queu=
ed to
> > that thread and because of the potential for deadlocks between memory
> > allocation and generic_make_request (as mentioned in previous email) I =
find
> > it hard to convince myself that this approach is entirely safe.
>=20
> No problem, we can use a separate workqueue.

A separate set of per-cpu workqueues for each md array doesn't sound like a
good idea to me - if we can possibly avoid it.

>=20
> > I wonder if we might take a very different approach and try to do every=
thing
> > in the one process.  i.e. don't hand tasks off to other threads at all =
- at
> > least in the common case.=20
> > So we could change plugger_unplug (in md.c) so that:
> >=20
> >  - if current->bio_list is NULL, (meaning all requests have been submit=
ted
> >    and there is no risk of deadlock) we call bitmap_unplug and then sub=
mit
> >    all the queued writes.
> >  - if current->bio_list is not NULL, then we just wakeup the md thread =
to
> >    do the work.
>=20
> The current->bio_list check does make sense. I'm going to do the check fo=
r the
> 1 and 3 patches.
>=20
> But I believe we can't call generic_make_request in unplug. For example,
> schedule()->unplug->generic_make_request->get_request_wait()->schedule().=
 At

My ideas was to only submit the queued writes from a normal call to
blk_finish_plug.  Calls that come from schedule would use the current
approach of signalling the md thread to take over.  There must be a way to
tell the difference - maybe just a new flag to the unplug callback.

NeilBrown


> least this will cause some request not dispatch. And last time I did simi=
lar
> experiment for raid0 (request is added to a per-disk plug_cb list, not di=
rectly
> dispatch) to reduce lock contention, I found nasty oops.
>=20
> Thanks,
> Shaohua


--Sig_/3ybLLc_wjwzEv.aXEgd5cxG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT73IVDnsnt1WYoG5AQKFWQ//dUq3Txqg/PyzWr+swlkFxLNz47zuUdA2
cM8bahm+1rigrHNg8iURtT046WJ4bqOVA5G5mOhTcesjmoQiJ8JXMUvqlVgNsCzj
wn0hKMwuOU7awppW/IlkhXy4URVhx6jHZneu2XsfqYTZVDiIRvH5veAkkl3yKY4v
6MiXU1d9qVSKvxbaF1hvBSdeS2E9F5OG3wlqAIo3xWG7HRtCG6tnUenKCP2oTe8S
J2yetHifyUS+pGQtJcO7Yr9MDMQIpIcxGw9/QkHHuzFmtmAE9JawVuUNp9ZtMjHR
+XnlWZc5p8tx7GNRWlAYquQBSACq1m2K/AJTrH+B9/rdkB2QiPlpcPxw2MUMcw2B
ooJEE3vPoUqJYHz91J4pfsme2/gt9AYOjOH6+CmxDJ2CZ/VJpx94O1G/ToLS67Qi
qX3yjC/ZRlzKjInTNgXiDGTgX2RJcwzy1u0tj9LU8SfIKXroHO1qvyLpl/6HRdwi
ktkpyTrUikGa+iRzNRrvwZB4uywAxZYgopzFRFKrzRe0XS/dL6+DvZjTzlQKk+p2
deRQ6DKACyp0MGqq4sRQXiR7sdFJtXdYB355hXkOVY1jSrRHR2SsVl9ECe8EZnyr
Amvu1E3ulxg3hvmir/s6v94kFumk9qXWZkilUoBGBOAFb1lkCB/lFVQoyRxObygN
yUdpigDSyqk=
=S4Ym
-----END PGP SIGNATURE-----

--Sig_/3ybLLc_wjwzEv.aXEgd5cxG--
