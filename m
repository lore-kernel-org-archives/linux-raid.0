From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Wed, 29 Oct 2014 08:41:13 +1100
Message-ID: <20141029084113.57f6ae6a@notabene.brown>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.wn7fGgeABPAl+rdUSg/3lC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141027162748.593451be@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids

--Sig_/.wn7fGgeABPAl+rdUSg/3lC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Oct 2014 16:27:48 -0400 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> Hi Neil,
>=20
> We've encountered changes in MD and mdadm that have broken our automated
> disk removal script.  In the past, we've been able to run the following
> after a RAID1 disk component removal:
>=20
> % echo fail > /sys/block/md3/md/dev-sdr5/state
> % echo remove > /sys/block/md3/md/dev-sdr5/state
>=20
> However, the latest RHEL6.6 code drop has rebased to sufficiently recent
> MD kernel and mdadm changes, in which the previous commands occasionally
> fail like so:
>=20
> * MD array is usually resyncing or checking
> * Component disk /dev/sdr removed via HBA sysfs PCI removal
> * Following UDEV rule fires:
>=20
> SUBSYSTEM=3D=3D"block", ACTION=3D=3D"remove", ENV{ID_PATH}=3D=3D"?*", \
>         RUN+=3D"/sbin/mdadm -If $name --path $env{ID_PATH}"
>=20
> % mdadm --detail /dev/md3
> /dev/md3:
>         Version : 1.1
>   Creation Time : Tue Oct 14 17:31:59 2014
>      Raid Level : raid1
>      Array Size : 25149440 (23.98 GiB 25.75 GB)
>   Used Dev Size : 25149440 (23.98 GiB 25.75 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Wed Oct 15 14:22:34 2014
>           State : active, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
>=20
>            Name : localhost.localdomain:3
>            UUID : 40ed68ee:ba41d4cd:28c361ed:be7470b8
>          Events : 142
>=20
>     Number   Major   Minor   RaidDevice State
>        0      65       21        0      faulty
>        1      65        5        1      active sync   /dev/sdj5
>=20
> All attempts to remove this device fail:=20
>=20
> % echo remove > /sys/block/md3/md/dev-sdr5/state
> -bash: echo: write error: Device or resource busy
>=20
> This can be traced to state_store():
>=20
>         } else if (cmd_match(buf, "remove")) {
>                 if (rdev->raid_disk >=3D 0)
>                         err =3D -EBUSY;
>=20
> After much debugging and systemtapping, I think I've figured out that the
> sysfs scripting may fail after the following combination of changes:
>=20
> mdadm  8af530b07fce "Enhance incremental removal."
> kernel 30b8feb730f9 "md/raid5: avoid deadlock when raid5 array has unack
>                      badblocks during md_stop_writes"
>=20
> With these two changes:
>=20
> 1 - On the user side, mdadm is trying to set the array_state to read-auto
>     on incremental removal (as invoked by UDEV rule).=20
>=20
> 2 - Kernel side, md_set_readonly() will set the MD_RECOVERY_FROZEN flag,
>     wake up the mddev->thread and if there is a sync_thread, it will set
>     MD_RECOVERY_INTR and then wait until the sync_thread is set to NULL.
>=20
>     When md_check_recovery() gets a chance to run as part of the
>     raid1d() mddev->thread, it may or may not ever get to
>     an invocation of remove_and_add_spares(), for there are but *many*
>     conditional early exits along the way -- for example, if
>     MD_RECOVERY_FROZEN is set, the following condition will bounce out of
>     the routine:
>=20
>                 if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recov=
ery) ||
>                     test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))      =
      =20
>                         goto unlock;
>=20
>     the next time around, MD_RECOVERY_NEEDED will have been cleared, so
>     all future tests will return 0 and the negation will always take the
>     early exit path.
>=20
>     Back in md_set_readonly(), it may notice that the MD is still in use,
>     so it clears the MD_RECOVERY_FROZEN and then returns -EBUSY, without
>     setting mddev->ro.  But the damage has been done as conditions have
>     been set such that md_check_recovery() will never call
>     remove_and_add_spares().
>=20
> This would also explain why an "idle" sync_action clears the wedge: it
> sets MD_RECOVERY_NEEDED allowing md_check_recovery() to continue executing
> to remove_and_add_spares().
>=20
> As far as I can tell, this is what is happening to prevent the "remove"
> write to /sys/block/md3/md/dev-sdr5/state from succeeding.  There are
> certainly a lot of little bit-states between disk removal, UDEV mdadm, and
> various MD kernel threads, so apologies if I missed an important
> transition.
>=20
> Would you consider writing "idle" to the MD array sync_action file as a
> safe and reasonable intermediate workaround step for our script?
>=20
> And of course, any suggestions to whether this is intended behavior (ie,
> the removed component disk is failed, but stuck in the array)?
>=20
> This is fairly easy for us to reproduce with multiple MD arrays per disk
> (one per partition) and interrupting a raid check on all of them
> (especially when they are delayed waiting for the first to finish) by
> removing the component disk via sysfs PCI removal.  We can provide
> additional debug or testing if required.
>=20

Hi Joe,
 thanks for the details analysis!!

I think the correct fix would be that MD_RECOVERY_NEEDED should be set after
clearing MD_RECOVERY_FROZEN, like the patch below.
Can you confirm that it works for you?

Writing 'idle' should in general be safe, so that could be used as an inter=
im.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c03d87b6890a..2c73fcb82593 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5261,6 +5261,7 @@ static int md_set_readonly(struct mddev *mddev, struc=
t block_device *bdev)
 		printk("md: %s still in use.\n",mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		err =3D -EBUSY;
@@ -5275,6 +5276,8 @@ static int md_set_readonly(struct mddev *mddev, struc=
t block_device *bdev)
 		mddev->ro =3D 1;
 		set_disk_ro(mddev->gendisk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		err =3D 0;
 	}
@@ -5318,6 +5321,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		return -EBUSY;

--Sig_/.wn7fGgeABPAl+rdUSg/3lC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFANeTnsnt1WYoG5AQI3fRAApqUgGTn8qC2LHo7PijJASbUYWxDsJxhT
IQNDeaN66hnPhE1Zven/QrZ27Eoyx54mRinto48cU3Gke/LwCWeIKdkRDC17Yhv+
mxBM8beSLKf/VARzkc8ScnovE1NnPdykk4bUHsz21XVRhVFAWyAdOJzzEzu1T/+v
0L4pXdCZ5gW6EhzAR7Da+wDbmz5/fN5Iu8c87zO+/fDTB6U4B8vQPoJWRP5z4TOm
6rswo3GfdSYyRH5oM7XpRAa6Uh1oVnWBuaFQHTzzMCLU8sskPqmtxnD9uSGOu9SV
8MvXrOve/VJhNXZvtx9TyBjCjq7ZrPWWAVh9Jo3V+yLHpJ5PTdR2xNRFYKV0vJMP
07Dwpttoy9m8fp6OCOrdSCToDZA3/T8IXbroKGt027KLoVuePL32NO6YgAgCpMX6
HTtPptjKpzhzGCiytd5sMJmmwx6HBxh698JBZWj/ciTbb6N1X25LPrDb+HtS6UAm
wSbHRDPsn5F+g3xvs7vwq64m4yG1SjvEEB6qZmaDrlRTHX9VHZ2hzas5E4nt2xUa
YbZJQgYzhdILfyxPBzjcFei+nHvhYIuGf9IP45NREDtKm9mSiepJPuF/UNcgn4Yc
uUVY9CHfdb8N9rl6jn3IxqQ4g1HFVucyxEAZZ9za/UL6UYfAmVSulOc911T7htKR
UR8H7avV/ik=
=H0Q1
-----END PGP SIGNATURE-----

--Sig_/.wn7fGgeABPAl+rdUSg/3lC--
