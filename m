From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Tue, 12 Mar 2013 12:32:24 +1100
Message-ID: <20130312123224.62018981@notabene.brown>
References: <wrfj1ubvi88x.fsf@redhat.com>
	<20130305080010.6285b435@notabene.brown>
	<wrfjlia2fd6h.fsf@redhat.com>
	<20130306131804.0b39752a@notabene.brown>
	<wrfj4ngog9h0.fsf@redhat.com>
	<20130312093231.72c54735@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nr/TFzCtyH2mT3o68cBnbTh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130312093231.72c54735@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Eryu Guan <eguan@redhat.com>
List-Id: linux-raid.ids

--Sig_/nr/TFzCtyH2mT3o68cBnbTh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Mar 2013 09:32:31 +1100 NeilBrown <neilb@suse.de> wrote:

> On Wed, 06 Mar 2013 10:31:55 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>=20

> >=20
> > I am attaching the test script I am running too. It was written by Eryu
> > Guan.
>=20
> Thanks for that.  I've tried using it but haven't managed to trigger a BUG
> yet.  What size are the loop files?  I mostly use fairly small ones, but
> maybe it needs to be bigger to trigger the problem.

Shortly after I wrote that I got a bug-on!  It hasn't happened again though.

This was using code without that latest patch I sent.  The bug was
		BUG_ON(s->uptodate !=3D disks);

in the check_state_compute_result case of handle_parity_checks5() which is
probably the same cause as your most recent BUG.

I've revised my thinking a bit and am now running with this patch which I
think should fix a problem that probably caused the symptoms we have seen.

If you could run your tests for a while too and is whether it will still cr=
ash
for you, I'd really appreciate it.

Thanks,
NeilBrown



Subject: [PATCH] md/raid5: ensure sync and recovery don't happen at the same
 time.

A number of problems can occur due to races between
resync/recovery and discard.

- if sync_request calls handle_stripe() while a discard is
  happening on the stripe, it might call handle_stripe_clean_event
  before all of the individual discard requests have completed
  (so some devices are still locked, but not all).
  Since commit ca64cae96037de16e4af92678814f5d4bf0c1c65
     md/raid5: Make sure we clear R5_Discard when discard is finished.
  this will cause R5_Discard to be cleared for the parity device,
  so handle_stripe_clean_event will not be called when the other
  devices do become unlocked, so their ->written will not be cleared.
  This ultimately leads to a WARN_ON in init_stripe and a lock-up.

- If handle_stripe_clean_event does clear R5_UPTODATE at an awkward
  time for resync, it can lead to s->uptodate being less than disks
  in handle_parity_checks5(), which triggers a BUG (because it is
  one).

So:
 - keep R5_Discard  on the parity device until all other devices have
   completed their discard request
 - make sure don't try to have a 'discard' and a 'sync' action at
   the same time.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 51af9da..c216dd3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2609,6 +2609,8 @@ handle_failed_sync(struct r5conf *conf, struct stripe=
_head *sh,
 	int i;
=20
 	clear_bit(STRIPE_SYNCING, &sh->state);
+	if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
+		wake_up(&conf->wait_for_overlap);
 	s->syncing =3D 0;
 	s->replacing =3D 0;
 	/* There is nothing more to do for sync/check/repair.
@@ -2782,6 +2784,7 @@ static void handle_stripe_clean_event(struct r5conf *=
conf,
 {
 	int i;
 	struct r5dev *dev;
+	int discard_pending =3D 0;
=20
 	for (i =3D disks; i--; )
 		if (sh->dev[i].written) {
@@ -2810,9 +2813,23 @@ static void handle_stripe_clean_event(struct r5conf =
*conf,
 						STRIPE_SECTORS,
 					 !test_bit(STRIPE_DEGRADED, &sh->state),
 						0);
-			}
-		} else if (test_bit(R5_Discard, &sh->dev[i].flags))
-			clear_bit(R5_Discard, &sh->dev[i].flags);
+			} else if (test_bit(R5_Discard, &dev->flags))
+				discard_pending =3D 1;
+		}
+	if (!discard_pending &&
+	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
+		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
+		clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+		if (sh->qd_idx >=3D 0) {
+			clear_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
+			clear_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags);
+		}
+		/* now that discard is done we can proceed with any sync */
+		clear_bit(STRIPE_DISCARD, &sh->state);
+		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))
+			set_bit(STRIPE_HANDLE, &sh->state);
+
+	}
=20
 	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
 		if (atomic_dec_and_test(&conf->pending_full_writes))
@@ -3464,9 +3481,15 @@ static void handle_stripe(struct stripe_head *sh)
 		return;
 	}
=20
-	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
-		set_bit(STRIPE_SYNCING, &sh->state);
-		clear_bit(STRIPE_INSYNC, &sh->state);
+	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
+		spin_lock(&sh->stripe_lock);
+		/* Cannot process 'sync' concurrently with 'discard' */
+		if (!test_bit(STRIPE_DISCARD, &sh->state) &&
+		    test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
+			set_bit(STRIPE_SYNCING, &sh->state);
+			clear_bit(STRIPE_INSYNC, &sh->state);
+		}
+		spin_unlock(&sh->stripe_lock);
 	}
 	clear_bit(STRIPE_DELAYED, &sh->state);
=20
@@ -3626,6 +3649,8 @@ static void handle_stripe(struct stripe_head *sh)
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
+		if (test_and_clear_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags))
+			wake_up(&conf->wait_for_overlap);
 	}
=20
 	/* If the failed drives are just a ReadError, then we might need
@@ -4222,6 +4247,13 @@ static void make_discard_request(struct mddev *mddev=
, struct bio *bi)
 		prepare_to_wait(&conf->wait_for_overlap, &w,
 				TASK_UNINTERRUPTIBLE);
 		spin_lock_irq(&sh->stripe_lock);
+		if (test_bit(STRIPE_SYNCING, &sh->state)) {
+			set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
+			spin_unlock_irq(&sh->stripe_lock);
+			release_stripe(sh);
+			schedule();
+			goto again;
+		}
 		for (d =3D 0; d < conf->raid_disks; d++) {
 			if (d =3D=3D sh->pd_idx || d =3D=3D sh->qd_idx)
 				continue;
@@ -4233,6 +4265,7 @@ static void make_discard_request(struct mddev *mddev,=
 struct bio *bi)
 				goto again;
 			}
 		}
+		set_bit(STRIPE_DISCARD, &sh->state);
 		finish_wait(&conf->wait_for_overlap, &w);
 		for (d =3D 0; d < conf->raid_disks; d++) {
 			if (d =3D=3D sh->pd_idx || d =3D=3D sh->qd_idx)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2afd835..996bdf3 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -324,6 +324,7 @@ enum {
 	STRIPE_COMPUTE_RUN,
 	STRIPE_OPS_REQ_PENDING,
 	STRIPE_ON_UNPLUG_LIST,
+	STRIPE_DISCARD,
 };
=20
 /*

--Sig_/nr/TFzCtyH2mT3o68cBnbTh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT6FqDnsnt1WYoG5AQK29BAAqZImkQ361RdhCs2AKRr3bOaR+rLeg6ZN
AKgrHtsCmm9Go+++GsQTgtHyiDBAUu85bcwSHFHEUNvluE60Ymsxj/uDKpxFQWod
d/W0RNqx15F2mgm4EAvhtBhxuKkr26qJFMuaQ6xyoxXXNAi5qsYGcJ0zeDFynIN5
mJJ31VhbOhuP0WRWqujmJ8wkJiwzMXp45VlQsOsL+rUpgskQPMQeQIh9g5XyZjY+
VVlUu8fdJqutPU2QEGMXx7M48l9TlaCuNf4GftPd+18YUbwxhyHeHTUJmQA1wt1Q
Ji7BpRaEwfaraA2NNLBlmYMcZXSB3L5Jb8VUqZ6NhMF3tMiqo/UuVkDtHMCcLa9X
SKkeYsFRLt54YyIhc6+MB8rBaF55pNygO3lOPdunmsL7tM+THbjOdKsXhyhoazYW
ruz43P+UK2oZn/wePlw3SCZGV7CadNs9EC0CEOaInh6bzZWYuyPUcV5770W+C86j
FSrsTcGIaqshqaw9m19vU8VJn9OyqONtNvOXop5zGdrWYY3sH2tPm2GnRXuA7Ize
VCWZIN/Mve3271v8cmw4MjXHFuU25CungPdfr3HVKVpO2W8ET+AhkTdxEMH/4zhE
qwaX92DRAGRDJMcQ/90p3wM+rhH2oJYslqOQkTrKU0p+noVUyxGE+vPzpARIrrFL
IO7GkhEe+TA=
=iJ2w
-----END PGP SIGNATURE-----

--Sig_/nr/TFzCtyH2mT3o68cBnbTh--
