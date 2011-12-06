From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: Add ability for disable bad block management
Date: Tue, 6 Dec 2011 17:05:25 +1100
Message-ID: <20111206170525.1f4e32ab@notabene.brown>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
	<20111130111403.7efd3875@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A054C28@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Oml7C/vMHvFRhQyWcHQ0HkY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A054C28@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/Oml7C/vMHvFRhQyWcHQ0HkY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Nov 2011 08:17:32 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Wednesday, November 30, 2011 1:14 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Willia=
ms,
> > Dan J
> > Subject: Re: [PATCH] md: Add ability for disable bad block management
> >=20
> > On Thu, 24 Nov 2011 13:19:53 +0100 Adam Kwolek
> > <adam.kwolek@intel.com> wrote:
> >=20
> > > When external metadata doesn't support BBM, mdadm cannot answer
> > > correctly for BBM requests. It causes reshape process being stopped.
> > >
> > > Add ability for external metadata /mdadm/ to disable BBM via sysfs.
> > > md will ignore bad blocks as it is for metadata v0.90.
> >=20
> > This should not be necessary.
> >=20
> > The intention is that a device with a bad block looks exactly like a de=
vice with
> > a failed device.  i.e. 'faulty' and 'blocked' appear in the 'state'
> > file.
> >=20
> > If the metadata doesn't support a bad-block list, it will record that t=
he device
> > has failed and will unblock the device.  At that point the failure is f=
orced.
> > If the metadata does support a bad block list it will just record the b=
ad blocks
> > and acknowledge them, and the unblock the device.  At that point the de=
vice
> > won't be failed, the 'faulty' state will disappear, and it will continu=
e to be
> > used with the known bad blocks.
> >=20
> > What exactly is going wrong that makes you think you need this patch?
>=20
>=20
> When degradation occurs during migration BBM is signaled to mdmon and mdm=
on /monitor.c/ tries to mark disk  '-blocked'
> This operation fails. Momon goes in to loop, and nothing can be done /I c=
annot make it using sysfs/ to signal or remove device.
> In sysfs device is present in /sys/block/mdXXX/md but entry /sys/block/md=
XXX/md/dev-sdX/~block is missing /disk was pulled out/.


I've found a couple of issues.  I'm not sure if they completely explain what
you are seeing.  Could you please test with these two fixes and tell me the
results?

Firstly, I find that writing "-blocked" succeeds (no error returned) but the
"blocked" flag does not get cleared, which is certainly confusing.

This is fixed by:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4adcbb4..7258dc1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2562,7 +2562,8 @@ state_show(struct md_rdev *rdev, char *page)
 		sep =3D ",";
 	}
 	if (test_bit(Blocked, &rdev->flags) ||
-	    rdev->badblocks.unacked_exist) {
+	    (rdev->badblocks.unacked_exist
+	     && !test_bit(Faulty, &rdev->flags))) {
 		len +=3D sprintf(page+len, "%sblocked", sep);
 		sep =3D ",";
 	}


Secondly mdmon writes "-blocked" even when the "blocked" flag is not set.
This succeeds so state_store() calls
		sysfs_notify_dirent_safe(rdev->sysfs_state);

so mdmon/monitor.c is woken up to go around the loop again and it writes
"-blocked" again and so it continues in a loop.

This is fixed by:

diff --git a/monitor.c b/monitor.c
index b002e90..29bde18 100644
--- a/monitor.c
+++ b/monitor.c
@@ -339,7 +339,8 @@ static int read_and_act(struct active_array *a)
 			a->container->ss->set_disk(a, mdi->disk.raid_disk,
 						   mdi->curr_state);
 			check_degraded =3D 1;
-			mdi->next_state |=3D DS_UNBLOCK;
+			if (mdi->curr_state & DS_BLOCKED)
+				mdi->next_state |=3D DS_UNBLOCK;
 			if (a->curr_state =3D=3D read_auto) {
 				a->container->ss->set_array_state(a, 0);
 				a->next_state =3D active;


Finally, when a badblock is added to the list we don't currently notify
rdev->sysfs_state so mdmon doesn't notice straight away and so is delayed in
taking action.  It will only notice when a write blocks.

This is fixed by:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4adcbb4..9cc7983 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7940,6 +7941,7 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t=
 s, int sectors,
 				  s + rdev->data_offset, sectors, acknowledged);
 	if (rv) {
 		/* Make sure they get written out promptly */
+		sysfs_notify_dirent_safe(rdev->sysfs_state);
 		set_bit(MD_CHANGE_CLEAN, &rdev->mddev->flags);
 		md_wakeup_thread(rdev->mddev->thread);
 	}


With these 3 changes in place I get substantially improved behaviour on my
simple test (just doing resync, not reshape).

Thanks,
NeilBrown

--Sig_/Oml7C/vMHvFRhQyWcHQ0HkY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt2wpTnsnt1WYoG5AQJjhhAAvLH7ro3bA+fw6A7rsmd1YgBBIA3Mv6vI
br2jNTZK7F7S3zLLR4FNckiOR9ssVqWFo4pmGcpTwUmuThii/nDTCagYvDYDKE0t
ZibFig8p/k9YfmsBnzPZTifv6ULCJyX2imcI4ALiAavpYDn7ul97bTHGJyYUbG/B
Iy6rAEqlFXhhMOlmWaee1zVyLsV60ZY/AO6j8gcUldBm12hB9IhUJSrjP4dSOqan
CVOLB+Xu8EDX6nPPB07A+2tL2arLj0AYs8w+22ALaoZBhXlgyGOtaz8bZMPt83XM
9mG/+o4Rj6sL0SVlru1xrciA7T8YRWT8mTu9dh9glwws/SCRFSfFuHZrUuukrKgr
Brb2nGOPU7AHHexfrhe155b+p5UDfmPQFxZ7EerBXd7XMemOtN/R4KQ4GXLkIutt
GxjqwLKH0JmVUizsqbPKSVrFsLmArQc4NtBqlz88a50mB9iUVl7VQ3mYPzMZe/yV
X/BUO6mPSc/y4QmAqufZfYhdy4suYfcW1WqWKpwU5ChP5lZQ2K2+4THxNxRj8ehk
Werwp87PsArNwiWtkKGXkEEECNVWqaTvV6mgOmxc7XrLLVx6baMH4YISBQmbx9I8
5eu/TtVXJ8BT8sQtf8AkdAKpCkQDXx+JGfQhHaclT4eyL3qRYeNmWR9hr7ZZrp4m
J5yjL7mHKdk=
=7zpU
-----END PGP SIGNATURE-----

--Sig_/Oml7C/vMHvFRhQyWcHQ0HkY--
