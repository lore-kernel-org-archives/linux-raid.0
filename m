From: NeilBrown <neilb@suse.de>
Subject: [PATCH/RFC/RFT] md: allow resync to go faster when there is
 competing IO.
Date: Thu, 19 Feb 2015 17:04:18 +1100
Message-ID: <20150219170418.57ab0e86@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//HUq_7zsUpcA4ZcJAAlh8.i"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//HUq_7zsUpcA4ZcJAAlh8.i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi all,
 as you probably know, when md is doing resync and notices other IO it
 throttles the resync to a configured "minimum", which defaults to
 1MB/sec/device.

 On a lot of modern devices, that is extremely slow.

 I don't want to change the default (not all drives are the same) so I
 wanted to come up with something that it a little bit dynamic.

 After a bit of pondering and a bit of trial and error, I have the followin=
g.
 It sometimes does what I want.  I don't think it is ever really bad.

 I'd appreciate it if people could test it on different hardware, different
 configs, different loads.

 What I have been doing is running
  while :; do cat /sys/block/md0/md/sync_speed; sleep 5;=20
  done > /root/some-file

 while a resync is happening and a load is being imposed.

 I do this with the old kernel and with this patch applied, then use
 gnuplot to look at the sync_speed graphs.

 I'd like to see that the new code is never slower than the old, and rarely=
 more
 than 20% of the available throughput when there is significant load.

 Any test results or other observations most welcome,

Thanks,
NeilBrown



When md notices non-sync IO happening while it is trying
to resync (or reshape or recover) it slows down to the
set minimum.

The default minimum might have made sense many years ago
but the drives have become faster.  Changing the default
to match the times isn't really a long term solution.

This patch changes the code so that instead of waiting until the speed
has dropped to the target, it just waits until pending requests
have completed, and then waits about as long again.
This means that the delay inserted is a function of the speed
of the devices.

Test show that:
 - for some loads, the resync speed is unchanged.  For those loads
   increasing the minimum doesn't change the speed either.
   So this is a good result.  To increase resync speed under such
   loads we would probably need to increase the resync window
   size.

 - for other loads, resync speed does increase to a reasonable
   fraction (e.g. 20%) of maximum possible, and throughput of
   the load only drops a little bit (e.g. 10%)

 - for other loads, throughput of the non-sync load drops quite a bit
   more.  These seem to be latency-sensitive loads.

So it isn't a perfect solution, but it is mostly an improvement.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 94741ee6ae69..ce6624b3cc1b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7669,11 +7669,20 @@ void md_do_sync(struct md_thread *thread)
 			/((jiffies-mddev->resync_mark)/HZ +1) +1;
=20
 		if (currspeed > speed_min(mddev)) {
-			if ((currspeed > speed_max(mddev)) ||
-					!is_mddev_idle(mddev, 0)) {
+			if (currspeed > speed_max(mddev)) {
 				msleep(500);
 				goto repeat;
 			}
+			if (!is_mddev_idle(mddev, 0)) {
+				/*
+				 * Give other IO more of a chance.
+				 * The faster the devices, the less we wait.
+				 */
+				unsigned long start =3D jiffies;
+				wait_event(mddev->recovery_wait,
+					   !atomic_read(&mddev->recovery_active));
+				schedule_timeout_uninterruptible(jiffies-start);
+			}
 		}
 	}
 	printk(KERN_INFO "md: %s: %s %s.\n",mdname(mddev), desc,

--Sig_//HUq_7zsUpcA4ZcJAAlh8.i
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOV84jnsnt1WYoG5AQJclw/+M7Bjq4ygNIymCrSzNVX89ylXt3vn+Wz5
JWTxKSbdL3JSLAC/Y4PA3P9T/2LYV3tXP6qN646bNQ74SCNwUkZ7cjMJuXWwUptv
dzViL4ff1hRT4jxsjAKZdSrtR5ofXkMiFqk/NPUoqu3YJZ41Dpe1DQBUwr7VErv9
QX/+VmlOFcr7PNevdqXA5PvqVzzj3sXRYPzdMhHFfdX+TwdvyuEtDiJFCktHYhnG
3DMMiJs41WQzqDtEnhr5e+RUZ1kNlJ1zv3986yYqeP5ISGJa0rl8geOctiCZYRiA
z0wwe65V6K5c525SBgKXzXZohC/yitmXJHZrC/3l/U3vg3Ys3FtWx288mvuxy2Ar
bC4MPGks6m4Cseu2okbJ6Erl29TxZFd57rDT8MxQymlIc7S/NCiARQV3YYHHxOaa
vOOFg2wtiNnpyWfl54lNOHAVEKOztyIuclZVfolzQZVcj41cS4x48U0Jd+jvF4ls
LYJPlwUa8mmpPENdky1ygXUfGLPCRUAEI8KVs8qZghj4sUKK9YyAmbioIzcCBToJ
/5ZqL3RsMW39XFccehthVJmSFKAEYkH7aj9XEUx6/DP6AInnunv1m9hkAfYGSEyC
/lggAxaDaUQwDU2R3nB10Uqi+yIZeaschNv3k8Qg45jCw0ET3pSfYYRJgZTgq2S0
dIkCVDRqIaY=
=IAoJ
-----END PGP SIGNATURE-----

--Sig_//HUq_7zsUpcA4ZcJAAlh8.i--
