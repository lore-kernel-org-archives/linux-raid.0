From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with disk replacement
Date: Mon, 22 Jul 2013 13:04:15 +1000
Message-ID: <20130722130415.44b85e93@notabene.brown>
References: <45ae92bb.4ffb.13ff2092e1d.Coremail.13691222965@163.com>
	<7945ee0b.7d5e.13ff2acdc3f.Coremail.13691222965@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5jQPLx0ohSDP8osBWJu3eYe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7945ee0b.7d5e.13ff2acdc3f.Coremail.13691222965@163.com>
Sender: linux-raid-owner@vger.kernel.org
To: qindehua <13691222965@163.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5jQPLx0ohSDP8osBWJu3eYe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jul 2013 00:46:22 +0800 (CST) qindehua <13691222965@163.com> wro=
te:

> Hi Neil,
> I use kernel 3.9.6 and found data may lost while replacing a RAID disk us=
ing --replace.
>=20
> Here is the steps of the test case:
> 1. Create 3-drives RAID5 and wait for resync done (I use 1GB disks in Vir=
tualBox machine)
> 2. Calculate the md5sum on the whole raid: dd if=3D/dev/md1 bs=3D1M iflag=
=3Ddirect | md5sum
> 3. add two spare disks to the raid: mdadm /dev/md1 -a /dev/sdi -a /dev/sdj
> 4. mdadm --replace a disk then --fail another disk:
>    mdadm /dev/md1 --replace /dev/sdb; sleep 3; mdadm /dev/md1 -f /dev/sdc
> 5. wait for recovery done
> 6. recalculate the md5sum on the whole raid: dd if=3D/dev/md1 bs=3D1M ifl=
ag=3Ddirect | md5sum
>=20
> The md5sum of step 6 is NOT identical with that of step 2, this means dat=
a is corrupted.
> I found in step 4, when another disk was made failed, the replacing proce=
ss was stopped,
> and started recovering of the failed disk, and afterwards the replacing n=
ot continue.

Hi Qin,
 thanks for the report.  I can easily reproduce the bug.

I think this will fix it.  Could you please test and confirm that it fixes
the problem for you too.

Thanks,
NeilBrown


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

This bug was introduced in commit 9a3e1101b827a59ac9036a672f5fa8d5279d0fe2
(md/raid5:  detect and handle replacements during recovery.)
which introduced replacement for raid5.
That was in 3.3-rc3, so any stable kernel since then would benefit
from this fix.

Cc: stable@vger.kernel.org (3.3+)
Reported-by: qindehua <13691222965@163.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bf094a..f0aa7abd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3607,8 +3607,8 @@ static void handle_stripe(struct stripe_head *sh)
 			handle_parity_checks5(conf, sh, &s, disks);
 	}
=20
-	if (s.replacing && s.locked =3D=3D 0
-	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
+	if ((s.replacing || s.syncing) && s.locked =3D=3D 0
+	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
 		/* Write out to replacement devices where possible */
 		for (i =3D 0; i < conf->raid_disks; i++)
 			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
@@ -3617,7 +3617,9 @@ static void handle_stripe(struct stripe_head *sh)
 				set_bit(R5_LOCKED, &sh->dev[i].flags);
 				s.locked++;
 			}
-		set_bit(STRIPE_INSYNC, &sh->state);
+		if (s.replacing)
+			set_bit(STRIPE_INSYNC, &sh->state);
+		set_bit(STRIPE_REPLACED, &sh->state);
 	}
 	if ((s.syncing || s.replacing) && s.locked =3D=3D 0 &&
 	    test_bit(STRIPE_INSYNC, &sh->state)) {
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

--Sig_/5jQPLx0ohSDP8osBWJu3eYe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeyhLznsnt1WYoG5AQJYVw/8DJ63LEsSJ5dPddZs9vYWF4nofGg1W7Ph
R6qem8M+L4L9Dwfu2aqtcq0yCwT7uuNiu0pJSD2WkgEYa1E5E4bmj1wFsmMhxjff
irgNIJdsQoISTidcE8hjG+RpmipAD72qe10yJyRVato9ddBtH6dy/ze2qsF/YnyJ
mndA0k5w9DQycHT5+iQ1EDqDsdIo37nD8PO5o0FvWBDKJOCGYs0vFKGSv/nEUs5t
XpVmH8kGl13KMOuZ8RSZq5GRJJFXQcK2FSA7TfXf7SaXsE5Dj3P/dsJjXhGJE3vL
UVUVifboGfPuMEvdEI14GodpPgt3/ne/Bhockm1HjpJoBcU7HGb0nIPV7RnOLiWe
+lEBF01KKZAqfR2gV9WOZwrp3XPGfLEeAQojIIemUmHYivie/P/0YEAbozcoAG8y
Lk7I1LPDCm91lHDShWdAGzSHMnNC8AkFecLZ2GvvHHQbPM3qeOvdGjB9GX8pxmnH
bP3o4xDyNyCQofOvKa6MxXtBaYfCV19AMhq98zjAZsqv4J2u+712L7NuxCHCn1CC
L76iFj9OND/TqkHUlI9YWdvanZVSNUcCudBd6gmnOSX0+BoNx6ZYkD/sDYy1vIB/
Oy3mx1JyFhV7Eau+xP/yxkmcDTGyiBnOjU0omXDnFjzEGPxZW81VbQFlRdxu+RjI
wJJNnTo2Y+c=
=G4M4
-----END PGP SIGNATURE-----

--Sig_/5jQPLx0ohSDP8osBWJu3eYe--
