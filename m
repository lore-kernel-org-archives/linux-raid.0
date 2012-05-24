From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 2/4] raid1: percpu dispatch for write request if bitmap
 supported
Date: Thu, 24 May 2012 13:34:02 +1000
Message-ID: <20120524133402.0f217e71@notabene.brown>
References: <20120523072619.670179001@kernel.org>
	<20120523072838.580242059@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fKqstIenbucSfaP8qcK4npl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120523072838.580242059@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/fKqstIenbucSfaP8qcK4npl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 May 2012 15:26:21 +0800 Shaohua Li <shli@kernel.org> wrote:

> In raid1, all write requests are dispatched in raid1d thread. In fast sto=
rage,
> the raid1d thread is a bottleneck, because it dispatches request too slow=
. Also
> raid1d thread migrates freely, which makes request completion cpu not mat=
ch
> with submission cpu even driver/block layer has such capability. This will
> cause bad cache issue.
>=20
> If bitmap support is enabled, write requests can only be dispatched after=
 dirty
> bitmap is flushed out. After bitmap is flushed, how write requests are
> dispatched doesn't impact correctness. A natural idea is to distribute re=
quest
> dispatch to several threads. With this patch, requests are added to a per=
cpu
> list first. After bitmap is flushed, then the percpu list requests will
> dispatched in a workqueue. In this way, above bottleneck is removed.
>=20
> In a 4k randwrite test with a 2 disks setup, below patch can provide 10% =
~ 50%
> performance improvements depending on numa binding.

Those numbers are quite impressive so there is certainly room for improveme=
nt
here.  I'm not sure that I'm entirely comfortable with the approach though.

Passing the request to a per-cpu thread does make sense, but a generic
per-cpu thread feels dangerous as we don't know what else might be queued to
that thread and because of the potential for deadlocks between memory
allocation and generic_make_request (as mentioned in previous email) I find
it hard to convince myself that this approach is entirely safe.

I wonder if we might take a very different approach and try to do everything
in the one process.  i.e. don't hand tasks off to other threads at all - at
least in the common case.

So we could change plugger_unplug (in md.c) so that:

 - if current->bio_list is NULL, (meaning all requests have been submitted
   and there is no risk of deadlock) we call bitmap_unplug and then submit
   all the queued writes.
 - if current->bio_list is not NULL, then we just wakeup the md thread to
   do the work.

In the common case bio_list should be NULL (I think) and everything is done
in the one process.  It is only when memory is tight and we reschedule while
waiting for memory that the md thread will be called on and hopefully slower
performance then won't be so noticeable.

We probably want separate queues of pending writes for each CPU (or each
thread) so that each "plugger_unplug" only submits the writes that were
queued by that process - so that if multiple threads are submitting writes =
at
the same time, they don't end up handling each other's requests.

This might end up flushing the bitmap slightly more often - the current code
allocates one "md_plug_cb" for each different thread that is concurrently
writing to a given md device, and don't trigger the flush until all of them
unplug.  My proposal above would trigger it when any thread triggers the
final unplug.  I wonder if that makes any difference in practice.

Anyway, could you explore the possibility of submitting the requests in
plugger_unplug when current->bio_list is NULL?
Possibly you could:
  get mddev_check_plugged to return the md_plug_cb
  link all the md_plug_cb's for one mddev together
  store the list of queued write requests in that md_plug_cb

Make sense?

Thanks,
NeilBrown

--Sig_/fKqstIenbucSfaP8qcK4npl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT72sKjnsnt1WYoG5AQIUhRAAs06PUuFBs/P5uo49YS364Rbk6lZMy3e7
Pzh+VGpWT7Z0xQpEgRjKAIvvaLEEm9gRiA13xGlSBpiSFeZzTKN8LwOJBe9BQN70
yhgI6QpsWBw/FPXkwpMmD7/C5GeI+um20B7bz+l5qkFK8g9vo0NBx86QFseZuQx7
QmaY2JYZdo8564TfhTmzMc3sAbSTisQ3OUKY5aK5fH0YxCkToLwS0n5rNSG+rm5u
qIEaUlEqf+oHar5qLl/Z2+O6erwuqh+GuymLNdRj8JDuuEklHcCtxR52GpUuk6Yi
SCHyawMilNE0pfqr8m59CZ4m4HcfBMeBDehMI7X/0FOZaJVlZLOCSzduOCotdl4z
bylJ6Z6GkyAkM0SqGvLFBh6jzIecXQbWQyWvps/OKqh1i78vNx3mvYQ4heButVzH
HmF6+yiwR+GfF7oRlhWgV6l7DX/nL1sVL360kOeAxGufbEw2+lMkz3KufAgL1dyD
5oXjtzrE86K2BwhtUkZhjswEeTQVC0rhvK/CeBK/pVrzpniIf87IZhIdak4mdC3h
x6DkbV6afomf92qOzn55VD+UbUeeJPjeGgtHFq3bvH+eeLBnID7DbFaSn9KpSSbv
omx3N6wxDmVrMV9PQc7zydadVmP+jqQJEjRkCvngVVBRmeolkvAGOVeeqBp2aBU+
5pfxx5DxC3I=
=yoYL
-----END PGP SIGNATURE-----

--Sig_/fKqstIenbucSfaP8qcK4npl--
