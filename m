From: NeilBrown <neilb@suse.de>
Subject: Re: Strange / inconsistent behavior with mdadm -I -R
Date: Wed, 27 Mar 2013 16:53:32 +1100
Message-ID: <20130327165332.7118740c@notabene.brown>
References: <51422D10.3040000@arcor.de>
	<20130318103510.45bdd4a8@notabene.brown>
	<5148AE98.9020203@arcor.de>
	<20130321122205.3fdca38c@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/blTn.Tn1lvRH3y8O_jWCSAq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130321122205.3fdca38c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/blTn.Tn1lvRH3y8O_jWCSAq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Mar 2013 12:22:05 +1100 NeilBrown <neilb@suse.de> wrote:

> On Tue, 19 Mar 2013 19:29:44 +0100 Martin Wilck <mwilck@arcor.de> wrote:
>=20
> > On 03/18/2013 12:35 AM, NeilBrown wrote:
> >=20
> > > With -R, it only stays inactive until we have the minimum devices nee=
ded for
> > > a functioning array.  Then it will switch to 'read-auto' or, if the a=
rray is
> > > known and all expected devices are present, it will switch to 'active=
'.
> >=20
> > That's the point - I see the array switch to active *before* all
> > expected devices are present. That causes further additions to fail.
> >=20
> > > Maybe if you could provide a sequence of "mdadm" commands that produc=
es an
> > > outcome different to what you would expect - that would reduce the ch=
ance
> > > that I get confused.
> >=20
> > Here is the sequence of mdadm commands to illustrate what I mean.
> > I have a RAID10 array and I add the devices using mdadm -I -R in the
> > sequence 1,3,2,4. After adding device 3, the array will be started in
> > auto-read-only mode, which is fine.
> >=20
> > But then as soon as the next disk (/dev/tosh/rd2) is added, the array
> > switches to "active" although it is neither written to, nor all disks
> > have been added yet. Consequently, adding disk 4 fails.
> >=20
> > I expected the array to remain "auto-read-only" until either all 4
> > devices are present, or it is opened for writing. This is how the
> > container case is behaving (almost - it doesn't switch to active
> > automatically until it's written to).
> >=20
> > # ./mdadm -C /dev/md0 -l 1 -n 4 /dev/tosh/rd[1-4] -pn2
> > mdadm: array /dev/md0 started.
> > (wait for initial build to finish)
> > # mdadm -S /dev/md0
> > mdadm: stopped /dev/md0
> > # ./mdadm -v -I /dev/tosh/rd1 -R
> > mdadm: /dev/tosh/rd1 attached to /dev/md/0, not enough to start (1).
> > # ./mdadm -v -I /dev/tosh/rd3 -R
> > mdadm: /dev/tosh/rd3 attached to /dev/md/0, which has been started.
> > # cat /proc/mdstat
> > Personalities : [raid1] [raid10]
> > md0 : active (auto-read-only) raid10 dm-6[2] dm-4[0]
> >       2094080 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
> > # ./mdadm -v -I /dev/tosh/rd2 -R; cat /proc/mdstat
> > mdadm: /dev/tosh/rd2 attached to /dev/md/0 which is already active.
> > Personalities : [raid1] [raid10]
> > md0 : active raid10 dm-5[1] dm-6[2] dm-4[0]
> >       2094080 blocks super 1.2 512K chunks 2 near-copies [4/2] [U_U_]
> >       [>....................]  recovery =3D  0.0% (0/1047040)
> > finish=3D1090.6min speed=3D0K/sec
> > (wait for recovery to finish)
> > # ./mdadm -v -I /dev/tosh/rd4 -R
> > mdadm: can only add /dev/tosh/rd4 to /dev/md/0 as a spare, and
> > force-spare is not set.
> > mdadm: failed to add /dev/tosh/rd4 to existing array /dev/md/0: Invalid
> > argument.
> >=20
> > Thanks,
> > Martin
>=20
> Thanks, that makes is all very clear.
>=20
> The problem is that the ADD_NEW_DISK ioctl automatically converts from
> read-auto to active.
> There are two approaches I could take to addressing this.
> 1/ change ADD_NEW_DISK to not cause that conversion.  I think that would =
need
>    to be conditional as some times it really should be changed.
> 2/ change mdadm to not use ADD_NEW_DISK but instead add the disk my setti=
ng it
>    up via sysfs.
>=20
> I'm not sure which is best and neither is completely straight forward.
> So for now:  I'll get back to you.

I spend a while experimenting and such and I now have a patch which I am
happy with and I think fixes your issue.  It is included below.

If you could test and confirm, I'd appreciate it.

I'll try to get to your DDF patches soon, but it might not be until next we=
ek.

NeilBrown


=46rom ca16ef8db7f0392066735262d848825c00f67d77 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 27 Mar 2013 16:32:31 +1100
Subject: [PATCH] md: Allow devices to be re-added to a read-only array.

When assembling an array incrementally we might want to make
it device available when "enough" devices are present, but maybe
not "all" devices are present.
If the remaining devices appear before the array is actually used,
they should be added transparently.

We do this by using the "read-auto" mode where the array acts like
it is read-only until a write request arrives.

Current an add-device request switches a read-auto array to active.
This means that only one device can be added after the array is first
made read-auto.  This isn't a problem for RAID5, but is not ideal for
RAID6 or RAID10.
Also we don't really want to switch the array to read-auto at all
when re-adding a device as this doesn't really imply any change.

So:
 - remove the "md_update_sb()" call from add_new_disk().  This isn't
   really needed as just adding a disk doesn't require a metadata
   update.  Instead, just set MD_CHANGE_DEVS.  This will effect a
   metadata update soon enough, once the array is not read-only.

 - Allow the ADD_NEW_DISK ioctl to succeed without activating a
   read-auto array, providing the MD_DISK_SYNC flag is set.
   In this case, the device will be rejected if it cannot be added
   with the correct device number, or has an incorrect event count.

 - Teach remove_and_add_spares() to be careful about adding spares
   when the array is read-only (or read-mostly) - only add devices
   that are thought to be in-sync, and only do it if the array is
   in-sync itself.

 - In md_check_recovery, use remove_and_add_spares in the read-only
   case, rather than open coding just the 'remove' part of it.

Reported-by: Martin Wilck <mwilck@arcor.de>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aeceedf..a31cc0d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5810,7 +5810,7 @@ static int add_new_disk(struct mddev * mddev, mdu_dis=
k_info_t *info)
 		else
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
=20
-		md_update_sb(mddev, 1);
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		if (mddev->degraded)
 			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -6490,6 +6490,24 @@ static int md_ioctl(struct block_device *bdev, fmode=
_t mode,
 		err =3D md_set_readonly(mddev, bdev);
 		goto done_unlock;
=20
+	case ADD_NEW_DISK:
+		/* We can support ADD_NEW_DISK on read-only arrays
+		 * on if we are re-adding a preexisting device.
+		 * So require mddev->pers and MD_DISK_SYNC.
+		 */
+		if (mddev->pers) {
+			mdu_disk_info_t info;
+			if (copy_from_user(&info, argp, sizeof(info)))
+				err =3D -EFAULT;
+			else if (!(info.state & (1<<MD_DISK_SYNC)))
+				/* Need to clear read-only for this */
+				break;
+			else
+				err =3D add_new_disk(mddev, &info);
+			goto done_unlock;
+		}
+		break;
+
 	case BLKROSET:
 		if (get_user(ro, (int __user *)(arg))) {
 			err =3D -EFAULT;
@@ -7671,17 +7689,36 @@ static int remove_and_add_spares(struct mddev *mdde=
v)
 		    !test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
 			spares++;
-		if (rdev->raid_disk < 0
-		    && !test_bit(Faulty, &rdev->flags)) {
-			rdev->recovery_offset =3D 0;
-			if (mddev->pers->
-			    hot_add_disk(mddev, rdev) =3D=3D 0) {
-				if (sysfs_link_rdev(mddev, rdev))
-					/* failure here is OK */;
-				spares++;
-				md_new_event(mddev);
-				set_bit(MD_CHANGE_DEVS, &mddev->flags);
-			}
+		if (rdev->raid_disk >=3D 0)
+			continue;
+		if (test_bit(Faulty, &rdev->flags))
+			continue;
+		if (mddev->ro &&
+		    rdev->saved_raid_disk < 0)
+			continue;
+
+		rdev->recovery_offset =3D 0;
+		if (rdev->saved_raid_disk >=3D 0 && mddev->in_sync) {
+			spin_lock_irq(&mddev->write_lock);
+			if (mddev->in_sync)
+				/* OK, this device, which is in_sync,
+				 * will definitely be noticed before
+				 * the next write, so recovery isn't
+				 * needed.
+				 */
+				rdev->recovery_offset =3D mddev->recovery_cp;
+			spin_unlock_irq(&mddev->write_lock);
+		}
+		if (mddev->ro && rdev->recovery_offset !=3D MaxSector)
+			/* not safe to add this disk now */
+			continue;
+		if (mddev->pers->
+		    hot_add_disk(mddev, rdev) =3D=3D 0) {
+			if (sysfs_link_rdev(mddev, rdev))
+				/* failure here is OK */;
+			spares++;
+			md_new_event(mddev);
+			set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		}
 	}
 	if (removed)
@@ -7789,22 +7826,16 @@ void md_check_recovery(struct mddev *mddev)
 		int spares =3D 0;
=20
 		if (mddev->ro) {
-			/* Only thing we do on a ro array is remove
-			 * failed devices.
+			/* On a read-only array we can:
+			 * - remove failed devices
+			 * - add already-in_sync devices if the array itself
+			 *   is in-sync.
+			 * As we only add devices that are already in-sync,
+			 * we can activate the spares immediately.
 			 */
-			struct md_rdev *rdev;
-			rdev_for_each(rdev, mddev)
-				if (rdev->raid_disk >=3D 0 &&
-				    !test_bit(Blocked, &rdev->flags) &&
-				    test_bit(Faulty, &rdev->flags) &&
-				    atomic_read(&rdev->nr_pending)=3D=3D0) {
-					if (mddev->pers->hot_remove_disk(
-						    mddev, rdev) =3D=3D 0) {
-						sysfs_unlink_rdev(mddev, rdev);
-						rdev->raid_disk =3D -1;
-					}
-				}
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			remove_and_add_spares(mddev);
+			mddev->pers->spare_active(mddev);
 			goto unlock;
 		}
=20

--Sig_/blTn.Tn1lvRH3y8O_jWCSAq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUVKJXDnsnt1WYoG5AQKDphAAiyxOl42HUk/rP2tU3b7GESZgI7ZizNAU
X/fRbCh9LkO3IjyZ2HO2n114zr24ig3K1LlOXb3BcfqfBs65aX/Z/vuENJHNoa+i
Xiex27w4d5/arQfwcW+ybjKocwexdlstijhINl1ySdTx8kxjZfl2BhQfJy6q59S3
Q7kpNpl1tHOT600ny0he8PjjWfn53hNQa4Mj8nm521cqGeLU/s63KHzUSt2rwD/Q
GYujWXqLIx8ka6Hw0iM1+4XOqOablatTfq/WFGsxjnil0KT2C9GwPDIB18iiIeRl
MLpHo9RJvFZrcoPIZXtyGA71/US3P9EGd889CSY0ZSz144Nk/AoNG6xCkG6oCXht
A06fWMCgR9seezYpyigX+swjZ5RR/rsd5O03V/PFxFhL4RljkSL8wAhRYmWRWyQd
IT22HMOYyFypReiLEkK8wguh6CNn67qVAcCtI4bZy+rfBwh5JNC9LfWKp89knwYI
8IsrF77zCjN32v8bxj4jUPRzqDtaI50/S+U2aSRkfcLsSjxA7Qcuz+kjdkllfPwg
fjAJFVcl45bBNUTJXNtUgBrnWl2AqvQ4e725Xzvi9r8zNKnOgpl7PtgaV5gRjVWO
++hZI5n77NLnQsLY9f73sT23/MKPWUHVS5rh6pR/q1EqA7KLmL4XxU1DDqeWUuii
w1eCtT2v2l0=
=JEM5
-----END PGP SIGNATURE-----

--Sig_/blTn.Tn1lvRH3y8O_jWCSAq--
