From: NeilBrown <neilb@suse.de>
Subject: Re: debugging md2_resync hang at raise_barrier
Date: Thu, 1 Mar 2012 12:34:18 +1100
Message-ID: <20120301123418.1254f763@notabene.brown>
References: <20120229184413.13db7143@bettercgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j/E2H/.bBihGt5/faO+_2Lb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120229184413.13db7143@bettercgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ray Morris <support@bettercgi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/j/E2H/.bBihGt5/faO+_2Lb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Feb 2012 18:44:13 -0600 Ray Morris <support@bettercgi.com> wrote:

> I am attempting to debug a hang in raid1 and possibly one raid5.
> I have experienced the same problem with many kernel versions
> over a couple of years, and with disparate hardware.
>=20
> My current plan, if noone more experienced suggests I do otherwise, is
> to compile a kernel with some printk() in strategic locations and try to=
=20
> narrow down the problem. I know very little about kernel work, so I am=20
> seeking suggestions from those who know better than I.
>=20
> In the case logged below, it appears to hang at raise_barrier in md2_resy=
nc
> at raise_barrier, then further access to the device hangs. I'm just a Per=
l=20
> programmer who dabbles in C, but my intuition said I check that if perhap=
s=20
> lower_barrier had been called with conf->barrier already at zero, so that=
's
> the one printk I've added so far. It may take a week or more before it=20
> crashes again, so is there any more debugging I should add before waiting=
=20
> for it to hang?
>=20
> Also below is some older logging from similar symptoms with raid5,=20
> hanging at raid5_quiesce. I got rid of the raid5 in hopes of getting=20
> rid of the problem, but if anyone has suggestions on how to further=20
> debug that I maybe be able to add a raid5 array.
>=20
> The load when I've noticed it is rsync to LVM volumes with snapshots.
> After some discussion, lvm-devel suggested linux-raid would be the next=20
> logical step. Tested kernels include 2.6.32-220.4.1.el6.x86_64=20
> 2.6.32.26-175.fc12.x86_64, vmlinuz-2.6.32.9-70.fc12.x86_64, and others.
> Since I already have updated the kernel several times in the last couple=
=20
> of years, I figured I'd try some debugging with the current EL 6 kernel.
>=20
> Anyway, any thoughts on how to debug, where to stick some printk, other=20
> debugging functions?=20

I might know what is happening.

It is kind-a complicated and involved the magic code in
block/blk-core.c:generic_make_request which turns recursive calls into tail
recursion.

The fs sends a request to dm.
dm split it in 2 for some reason and sends them both to md.
This involves them getting queued in generic_make_request.
The first gets actioned by md/raid1 and converted into a request to the
underlying device (it must be a read request for this to happen - so just o=
ne
device).  This gets added to the queue and is counted in nr_pending.

At this point sync_request is called by another thread and it tries to
raise_battier.  It gets past the first hurdle, increments ->barrier, and
waits for nr_pending to hit zero.

Now the second request from dm to md is passed to raid1.c:make_request where
it tries to wait_barrier.  This blocks because ->barrier is up, and we have=
 a
deadlock - the request to the underlying device will not progress until this
md request progresses, and it is stuck.

This patch might fix it.  Maybe.  If it compiles.

NeilBrown

Index: linux-2.6.32-SLE11-SP1/drivers/md/raid1.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.32-SLE11-SP1.orig/drivers/md/raid1.c	2012-03-01 12:28:05.0000=
00000 +1100
+++ linux-2.6.32-SLE11-SP1/drivers/md/raid1.c	2012-03-01 12:28:22.427992913=
 +1100
@@ -695,7 +695,11 @@ static void wait_barrier(conf_t *conf)
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		conf->nr_waiting++;
-		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
+		wait_event_lock_irq(conf->wait_barrier,
+				    !conf->barrier ||
+				    (current->bio_tail &&
+				     current->bio_list &&
+				     conf->nr_pending),
 				    conf->resync_lock,
 				    raid1_unplug(conf->mddev->queue));
 		conf->nr_waiting--;


--Sig_/j/E2H/.bBihGt5/faO+_2Lb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT07SGjnsnt1WYoG5AQIUBg/+N5XvqOoWmNAcGQp4gKpRZMceWof47eqV
TmI/Bsf6Na2wEzlpZmiqvMib+Z5A91rQ9haKG8mxnKFUxKbN0lNMO/gzQLO9hIOd
tJ+Ab9d1dmMFzKdrQDYZZtyYxgCndXfhQsHh18Vs3kiPA937C6qX+XGyfy5TgvnE
swc3sVGWjB+RzABGr7UBn097jlJLovfwVlP5s5+wesjud3rSdoF9moj3Vtywn6y0
hCJj+qXQ+wg3K0PVUleZuwHynQIc5KCCAzjLlKcW3yMdg3MJ9qlDUTqzOLVDsP39
ZsgatXAOiRWDuy2K/zwXtE38OinP5SYpYKPeB7DNfVljDYDYIAFxDvubtpCcEJmO
qcRcYpfqUtkFfXKdMU8HgtFieIoK2CsVm7C4ne4Q+WUMePHJVzmjlrb4X5Pjuey4
L8FH2hcA+kJRKOTRgTGgsjf6HhJhU6gU/08QC/jsJzqMvcR2vD6zabBjJ9R8o+By
0s7yaWvrw7PaUER/MwFnMu0CtB7hlfi/zZEPnoBbroa7fffr0CVTMzr11ICKsmvq
9OdUGwh1CndXpezGV0ACTXjyruVIENuV+pzqCxYVlD9RDgQTbnuzdaMQXaxXFXCD
rlVdvwTJjIJ3YCXNEwsMS4a5yHSTzBj27cerqnhVKdgApXo9z2x+wBc2CgdViox8
fTiuP7ysJpo=
=kh2p
-----END PGP SIGNATURE-----

--Sig_/j/E2H/.bBihGt5/faO+_2Lb--
