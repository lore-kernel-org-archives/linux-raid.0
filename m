From: NeilBrown <neilb@suse.de>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Mon, 25 Feb 2013 11:04:58 +1100
Message-ID: <20130225110458.2b1b1e2d@notabene.brown>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/csGz=Fu4OHVwgFLX.mBlzcE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130225094350.4b8ef084@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: tbayly@bluehost.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/csGz=Fu4OHVwgFLX.mBlzcE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Feb 2013 09:43:50 +1100 NeilBrown <neilb@suse.de> wrote:

> On Thu, 21 Feb 2013 15:58:24 -0700 Tregaron Bayly <tbayly@bluehost.com> w=
rote:
>=20
> > Symptom:
> > A RAID 1 array ends up with two threads (flush and raid1) stuck in D
> > state forever.  The array is inaccessible and the host must be restarted
> > to restore access to the array.
> >=20
> > I have some scripted workloads that reproduce this within a maximum of a
> > couple hours on kernels from 3.6.11 - 3.8-rc7.  I cannot reproduce on
> > 3.4.32.  3.5.7 ends up with three threads stuck in D state, but the
> > stacks are different from this bug (as it's EOL maybe of interest in
> > bisecting the problem?).
>=20
> Can you post the 3 stacks from the 3.5.7 case?  It might help get a more
> complete understanding.
>=20
> ...
> > Both processes end up in wait_event_lock_irq() waiting for favorable
> > conditions in the struct r1conf to proceed.  These conditions obviously
> > seem to never arrive.  I placed printk statements in freeze_array() and
> > wait_barrier() directly before calling their respective
> > wait_event_lock_irq() and this is an example output:
> >=20
> > Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1=
] Attempting to freeze array: barrier (1), nr_waiting (1), nr_pending (5), =
nr_queued (3)
> > Feb 20 17:47:35 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1=
] Awaiting barrier: barrier (1), nr_waiting (2), nr_pending (5), nr_queued =
(3)
> > Feb 20 17:47:38 sanclient kernel: [4946b55d-bb0a-7fce-54c8-ac90615dabc1=
] Awaiting barrier: barrier (1), nr_waiting (3), nr_pending (5), nr_queued =
(3)
>=20
> This is very useful, thanks.  Clearly there is one 'pending' request that
> isn't being counted, but also isn't being allowed to complete.
> Maybe it is in pending_bio_list, and so counted in conf->pending_count.
>=20
> Could you print out that value as well and try to trigger the bug again? =
 If
> conf->pending_count is non-zero, then it seems very likely the we have fo=
und
> the problem.

Actually  don't bother.  I think I've found the problem.  It is related to
pending_count and is easy to fix.
Could you try this patch please?

Thanks.
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6e5d5a5..fd86b37 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -967,6 +967,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool f=
rom_schedule)
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count +=3D plug->pending_cnt;
 		spin_unlock_irq(&conf->device_lock);
+		wake_up(&conf->wait_barrier);
 		md_wakeup_thread(mddev->thread);
 		kfree(plug);
 		return;

--Sig_/csGz=Fu4OHVwgFLX.mBlzcE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUSqqqjnsnt1WYoG5AQJGvA//eI18KAo4ugLXxszFCfJVh4JhZntz1hSb
M8ZZ1OzF6m3pnJmH+ZwEK4nF16eoo1BzH/mIVf5L4xx8+a74ucdYa0/B6vZjjUxv
1XXPY1v0UkKC7DpDuiDe7La5EI11Tv3BpRKztQlOVQt02Oh5A92UsadvzjB0I7Lu
G6taVhgDIo9gGUXxLSQl8lfwNzfbCfJixOig4z4ENmW8VqTDlxyK9NNhUlcYx0Fm
YTO7Vneg0AOTHzk3WMFxNfwxGai0wK85hxLEOO4ULGumY0edeeey8TYRqJP6EnkS
UyXz/eXMcaJ4CyS4st0AyYHAxNCILnukcP4QEG/JGmM+xQNCIovV2mwqW4ApjssH
LqnDeQTp8wBDeEb1fqiDXtMH8Bm0/qxXSQj5Kp4ZdlgoiW13U96hpplTscHtGO3V
iFl7jGaToTFrs1uKVd5f3DjLOdgsAVOVKhVNFbbT9Fg7Kh/Yn0j1sRO+1E47EvTg
+xQSsHDDPfNlQVtBNqMT+OQ4aVeZKbGmTmEmQcWPq3nN6RhEScstq0B3lQrk9lzQ
3QfsChldqQZp70vlnRorEd4uUFCGVCTeqUrjMMsu3jX3iCg9j96IxijpMkioWVvf
uTRmMxtyctOw+5xIEDpu7vf/HGbHM2FDOIXhhzU28qxhmJdjxWbBpfJFCmHmw1zK
bFXoif/pFU4=
=V7SA
-----END PGP SIGNATURE-----

--Sig_/csGz=Fu4OHVwgFLX.mBlzcE--
