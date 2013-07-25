From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with disk replacement
Date: Thu, 25 Jul 2013 17:32:53 +1000
Message-ID: <20130725173253.11ec4ec6@notabene.brown>
References: <45ae92bb.4ffb.13ff2092e1d.Coremail.13691222965@163.com>
	<7945ee0b.7d5e.13ff2acdc3f.Coremail.13691222965@163.com>
	<20130722130415.44b85e93@notabene.brown>
	<3391fc7f.14685.14005e82e81.Coremail.qindehua@163.com>
	<20130723132124.3bb0bcaf@notabene.brown>
	<b97941b.229e0.14010b931c5.Coremail.qindehua@163.com>
	<20130725164531.72f316c8@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VPswcRoMTCSYZu9idijfnNu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130725164531.72f316c8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: qindehua <qindehua@163.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VPswcRoMTCSYZu9idijfnNu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jul 2013 16:45:31 +1000 NeilBrown <neilb@suse.de> wrote:

> On Wed, 24 Jul 2013 20:48:27 +0800 (CST) qindehua <qindehua@163.com> wrot=
e:
>=20
> > Hi Neil,
> > I found another problem that the raid5 thread may run into an endless l=
oop in a rare circumstance.
> >=20
> > I have tested with or without the patch of "md/raid5: fix interaction o=
f 'replace' and 'recovery'",
> > the problem will not happen without the patch. So it is the patch that =
introduce this problem.
> >=20
> > Here is the fast steps to reproduce the problem:
> > 1. create 3-drives RAID5 with --assume-clean (I use 1GB disks in Virtua=
lBox machine)
> >    mdadm -C /dev/md1 -l 5 -n 3 --assume-clean /dev/sd[b-d]
> >=20
> > 2. change speed_limit_min and speed_limit_max to small number:
> >    echo 1 > /proc/sys/dev/raid/speed_limit_min
> >    echo 10 > /proc/sys/dev/raid/speed_limit_max
> >=20
> > 3. add three spare disks to the raid:
> >    mdadm /dev/md1 -a /dev/sde -a /dev/sdf -a /dev/sdg
> >=20
> > 4. replace three raid disks with this procedure:
> >    	for disk in sdb sdc sdd
> > 	do
> > 		mdadm /dev/md1 --replace /dev/$disk
> > 		echo "idle" >  /sys/block/md1/md/sync_action
> > 		sleep 3
> > 	done
> >=20
> > After step 4 the md1_raid5 process then ran into endless loop with 99% =
CPU usage.
> > The problem will not happen if there is no step 2. Also it will not hap=
pen if
> > only two disks were replaced.
>=20
> Thanks a lot for the  testing!
>=20
> This was missing from the previous patch:
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 1c3b279..e6e24c3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3524,6 +3524,7 @@ static void handle_stripe(struct stripe_head *sh)
>  		    test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
>  			set_bit(STRIPE_SYNCING, &sh->state);
>  			clear_bit(STRIPE_INSYNC, &sh->state);
> +			clear_bit(STRIPE_REPLACED, &sh->state);
>  		}
>  		spin_unlock(&sh->stripe_lock);
>  	}
>=20
>=20
> and that omission caused the problem you saw.
>=20
> However after looking at the code more closely I'm not sure that is the o=
nly
> problem.  So I won't push out a revised patch until I am sure.
> Maybe I don't actually need the new "STRIPE_REPLACED" flag after all.
>=20

Hi again.

Here is the patch which I think is correct and I hope to submit tomorrow.

NeilBrown


=46rom f94c0b6658c7edea8bc19d13be321e3860a3fa54 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 22 Jul 2013 12:57:21 +1000
Subject: [PATCH] md/raid5: fix interaction of 'replace' and 'recovery'.

If a device in a RAID4/5/6 is being replaced while another is being
recovered, then the writes to the replacement device currently don't
happen, resulting in corruption when the replacement completes and the
new drive takes over.

This is because the replacement writes are only triggered when
's.replacing' is set and not when the similar 's.sync' is set (which
is the case during resync and recovery - it means all devices need to
be read).

So schedule those writes when s.replacing is set as well.

In this case we cannot use "STRIPE_INSYNC" to record that the
replacement has happened as that is needed for recording that any
parity calculation is complete.  So introduce STRIPE_REPLACED to
record if the replacement has happened.

For safety we should also check that STRIPE_COMPUTE_RUN is not set.
This has a similar effect to the "s.locked =3D=3D 0" test.  The latter
ensure that now IO has been flagged but not started.  The former
checks if any parity calculation has been flagged by not started.
We must wait for both of these to complete before triggering the
'replace'.

Add a similar test to the subsequent check for "are we finished yet".
This possibly isn't needed (is subsumed in the STRIPE_INSYNC test),
but it makes it more obvious that the REPLACE will happen before we
think we are finished.

Finally if a NeedReplace device is not UPTODATE then that is an
error.  We really must trigger a warning.

This bug was introduced in commit 9a3e1101b827a59ac9036a672f5fa8d5279d0fe2
(md/raid5:  detect and handle replacements during recovery.)
which introduced replacement for raid5.
That was in 3.3-rc3, so any stable kernel since then would benefit
from this fix.

Cc: stable@vger.kernel.org (3.3+)
Reported-by: qindehua <13691222965@163.com>
Tested-by: qindehua <qindehua@163.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bf094a..78ea443 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3462,6 +3462,7 @@ static void handle_stripe(struct stripe_head *sh)
 		    test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 			set_bit(STRIPE_SYNCING, &sh->state);
 			clear_bit(STRIPE_INSYNC, &sh->state);
+			clear_bit(STRIPE_REPLACED, &sh->state);
 		}
 		spin_unlock(&sh->stripe_lock);
 	}
@@ -3607,19 +3608,23 @@ static void handle_stripe(struct stripe_head *sh)
 			handle_parity_checks5(conf, sh, &s, disks);
 	}
=20
-	if (s.replacing && s.locked =3D=3D 0
-	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
+	if ((s.replacing || s.syncing) && s.locked =3D=3D 0
+	    && !test_bit(STRIPE_COMPUTE_RUN, &sh->state)
+	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
 		/* Write out to replacement devices where possible */
 		for (i =3D 0; i < conf->raid_disks; i++)
-			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
-			    test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
+			if (test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
+				WARN_ON(!test_bit(R5_UPTODATE, &sh->dev[i].flags));
 				set_bit(R5_WantReplace, &sh->dev[i].flags);
 				set_bit(R5_LOCKED, &sh->dev[i].flags);
 				s.locked++;
 			}
-		set_bit(STRIPE_INSYNC, &sh->state);
+		if (s.replacing)
+			set_bit(STRIPE_INSYNC, &sh->state);
+		set_bit(STRIPE_REPLACED, &sh->state);
 	}
 	if ((s.syncing || s.replacing) && s.locked =3D=3D 0 &&
+	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index b0b663b..70c4932 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -306,6 +306,7 @@ enum {
 	STRIPE_SYNC_REQUESTED,
 	STRIPE_SYNCING,
 	STRIPE_INSYNC,
+	STRIPE_REPLACED,
 	STRIPE_PREREAD_ACTIVE,
 	STRIPE_DELAYED,
 	STRIPE_DEGRADED,

--Sig_/VPswcRoMTCSYZu9idijfnNu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfDUpjnsnt1WYoG5AQLghw//e+KUOWKNHmX2qwJQi7SmHJ3c+pwiaNUr
p47Jx7X7rEszTVsOckvjnQKF+9BOyBDtj1MgR288xZn9m7tyAwilf938BCVZvczf
qRxpdxZg4NjbaY+A8hIq2v78Gd5nLC6Oshk1FKXYvZG5nntbgmKN5T5nJ8YEyTAb
fcjyqgDYXKSN/xX/t4eV45l0n/IFq3YOAjqHmFkVvGgK44irHHv1RbkCr7iIYNgF
aE/tOaHAUli/8UsrGH8GCR5hQfMyY9zSDDBMt2OJsyaDEL3natk1UhueQrOuxzEJ
KS6trHyzSGfAR2+BPrauk/Ofz89Vvq3M0cwLD/j3Tk7UhKSeZou1DLJCBlgN/yrs
e7+hxjBQBhTS6JT5ozYo/aFmJJSIiuyNCXWE/pWLkJzH9yC3YYcE2Zx0OrW5qoOX
7agpBgs+ykzcizFVeCWyL3N4jW8ZDurS3fUSmxN7V1//ueMmHK3arMfwN00QNmYy
uCjIr/H7eA9qF7kTHFWPppRdnorzUgvadBW4y8CZ/VfZHYWH5fVsk5O17n1RWfVx
N7svgDt8kjmR2lo8oNSSlFB5lIh6zmQjHUbK0reuMMbtkqYgfj2eSQEzsBCOSeou
HxBIgL+XVFwfoMBYqMlqGuWRCNbcArwsOqlICqWoCiHwKJisLR/8M072xfPBG+Py
5a5VTfL0ExA=
=f0oo
-----END PGP SIGNATURE-----

--Sig_/VPswcRoMTCSYZu9idijfnNu--
