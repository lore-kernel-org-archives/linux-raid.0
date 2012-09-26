From: NeilBrown <neilb@suse.de>
Subject: Re: sync action not working/ignored
Date: Wed, 26 Sep 2012 11:47:39 +1000
Message-ID: <20120926114739.7527aa1c@notabene.brown>
References: <20120923002734.Horde.j1X3SZk8pphQXjtWHRF5P_A@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OHdYz4OCAGUN6+3kRK2UjgK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120923002734.Horde.j1X3SZk8pphQXjtWHRF5P_A@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander =?ISO-8859-1?Q?K=FChn?= <alexander.kuehn@nagilum.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OHdYz4OCAGUN6+3kRK2UjgK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Sep 2012 00:27:34 +0200 Alexander K=FChn
<alexander.kuehn@nagilum.de> wrote:

> Hi,
> for some reason linux appears to be ignoring my sync_action requests:
> root@nas:~# uname -a
> Linux nas 3.5.4 #1 SMP Sat Sep 15 15:41:21 CEST 2012 x86_64 GNU/Linux
> root@nas:~# echo /sys/block/md*/md/sync_action
> /sys/block/md1/md/sync_action
> root@nas:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6] sde[8] =20
> sdc[2] sda[1]
>        11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2 =20
> [7/7] [UUUUUUU]
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
> root@nas:~# echo check >/sys/block/md1/md/sync_action
> root@nas:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6] sde[8] =20
> sdc[2] sda[1]
>        11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2 =20
> [7/7] [UUUUUUU]
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
> root@nas:~# echo repair >/sys/block/md1/md/sync_action
> root@nas:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6] sde[8] =20
> sdc[2] sda[1]
>        11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2 =20
> [7/7] [UUUUUUU]
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
> root@nas:~# mdadm -Q --detail /dev/md1
> /dev/md1:
>          Version : 1.2
>    Creation Time : Thu Sep  9 20:43:43 2010
>       Raid Level : raid5
>       Array Size : 11719408128 (11176.50 GiB 12000.67 GB)
>    Used Dev Size : 1953234688 (1862.75 GiB 2000.11 GB)
>     Raid Devices : 7
>    Total Devices : 7
>      Persistence : Superblock is persistent
>=20
>    Intent Bitmap : Internal
>=20
>      Update Time : Sat Sep 22 23:28:50 2012
>            State : active
>   Active Devices : 7
> Working Devices : 7
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>           Layout : left-symmetric
>       Chunk Size : 64K
>=20
>             Name : nas:1  (local to host nas)
>             UUID : 5dbc572f:0e6b18bd:125db183:3511c054
>           Events : 109708
>=20
>      Number   Major   Minor   RaidDevice State
>         5       8       16        0      active sync   /dev/sdb
>         1       8        0        1      active sync   /dev/sda
>         2       8       32        2      active sync   /dev/sdc
>         8       8       64        3      active sync   /dev/sde
>         6       8       80        4      active sync   /dev/sdf
>         7       8       48        5      active sync   /dev/sdd
>         9       8       96        6      active sync   /dev/sdg
>=20
> Nothing in dmesg/syslog.
> No idea what's going on. :(

Thanks for the report.

I've queued up a patch which will cause changes to sync_action to clear the
read-auto status.

NeilBrown

=46rom f1b6162a19c8217acd7762de03eeb80cea6d399b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 26 Sep 2012 11:46:00 +1000
Subject: [PATCH] md: writing to sync_action should clear the read-auto stat=
e.
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

In some cases array are started in 'read-auto' state where in
nothing gets written to any device until the array is written
to.  The purpose of this is to make accidental auto-assembly
of the wrong arrays less of a risk, and to allow arrays to be
started to read suspend-to-disk images without actually changing
anything (as might happen if the array were dirty and a
resync seemed necessary).

Explicitly writing the 'sync_action' for a read-auto array currently
doesn't clear the read-auto state, so the sync action doesn't
happen, which can be confusing.

So allow any successful write to sync_action to clear any read-auto
state.

Reported-by: Alexander K=FChn <alexander.kuehn@nagilum.de>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 373b3eb..e868f0c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4296,6 +4296,13 @@ action_store(struct mddev *mddev, const char *page, =
size_t len)
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 	}
+	if (mddev->ro =3D=3D 2) {
+		/* A write to sync_action is enough to justify
+		 * canceling read-auto mode
+		 */
+		mddev->ro =3D 0;
+		md_wakeup_thread(mddev->sync_thread);
+	}
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);




--Sig_/OHdYz4OCAGUN6+3kRK2UjgK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGJeuznsnt1WYoG5AQK5fg//dhBL4SQXgdy35wqWWeJH1DIt3kXSpL6e
eBimsHHVd49EGJ15Acb1lNrA1dmg2H0Ip0V3Ssqi9p8Gml6oxIfK17/S5+wa7oHn
KtkFoFXgsx1Sj25s0HdEpCpHml8fZ1G4B96Zp4BtpSL8c3+S9TutmtoZmaG7/Glg
sRQ88APdSAc9VtnFm6egBmd09hYncYFughnEqkh5Y5lqsl4RJz8KnM7Qm80Eso62
K2WEJiinUCL2S4an3/i7Qp7XKBXfuwImUHv0c6yh+vu+2Eb/m7IPIOC++zjpISqj
ryy4oC58azOTCSq6kSmClLGLSiDa1u50/FP35vbfOAaBpIzIlxiRKlp2WUB4z5GM
grnBA3C94IlWRvUPC2vXwrBc5G3IrqXcbckfkNNA52ElLxiG+lKbfnyPVMFvmjza
NCo08grPNsXVXq1FUn5KgTDuwiajRpK+5rwhor3Bj3S1GQqYUKo4ZU9FJvmWFFGh
C5lrNth6zh04F9P7dOyNnFmwHt672mJdXgNGLBoM+Q3YtxNIcviHbOvFjsfqZ+10
FY27il4Z7W1d5K+G4k90oCfvbjJ5YHZ5ear76uo72fjyIbIOO+BXjPmyG5IwKXHF
KHy0yuk+PyB51QLuzzNDNttyvh6+er1YjxwXAWCPHy49oTqUQtQSR38h8/JjjwwD
Uyt/QAp3HUE=
=3R3k
-----END PGP SIGNATURE-----

--Sig_/OHdYz4OCAGUN6+3kRK2UjgK--
