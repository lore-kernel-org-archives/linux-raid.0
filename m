From: NeilBrown <neilb@suse.de>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Thu, 18 Sep 2014 11:05:23 +1000
Message-ID: <20140918110523.3ee5c064@notabene.brown>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
	<20140908171702.5b2853fc@notabene.brown>
	<CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/C4Lfc0+BDkhW39vmGl.F_db"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/C4Lfc0+BDkhW39vmGl.F_db
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Sep 2014 20:57:13 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> On Mon, Sep 8, 2014 at 10:17 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 7 Sep 2014 17:18:16 +0300 Alexander Lyakas <alex.bolshoy@gmail.=
com>
> > wrote:
> >
> >> Hi Neil,
> >> we see the following issue:
> >>
> >> # RAID1 has 2 drives A and B, drive B is recovering
> >> # READ request arrives
> >> # read_balanace selects drive B to read from, because READ sector
> >> comes before B->recovery_offset
> >> # READ is issued to drive B, but fails (drive B fails again)
> >>
> >> Now raid1_end_read_request() has the following code:
> >>
> >>     if (uptodate)
> >>         set_bit(R1BIO_Uptodate, &r1_bio->state);
> >>     else {
> >>         /* If all other devices have failed, we want to return
> >>          * the error upwards rather than fail the last device.
> >>          * Here we redefine "uptodate" to mean "Don't want to retry"
> >>          */
> >>         unsigned long flags;
> >>         spin_lock_irqsave(&conf->device_lock, flags);
> >>         if (r1_bio->mddev->degraded =3D=3D conf->raid_disks ||
> >>             (r1_bio->mddev->degraded =3D=3D conf->raid_disks-1 &&
> >>              !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
> >>             uptodate =3D 1;
> >>         spin_unlock_irqrestore(&conf->device_lock, flags);
> >>     }
> >>
> >> According to this code uptodate wrongly becomes 1, because:
> >> r1_bio->mddev->degraded =3D=3D conf->raid_disks-1 is TRUE
> >> and
> >> !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags) is also TRUE
> >>
> >> Indeed, drive B is not marked as Faulty, but also not marked as In_syn=
c.
> >> However, this function treats !Faulty being equal to In_Sync, so it
> >> decides that the last good drive failed, so it does not retry the
> >> READ.
> >>
> >> As a result, there is IO error, while we should have retried the READ
> >> from the healthy drive.
> >>
> >> This is happening in 3.8.13, but your master branch seems to have the
> >> same issue.
> >>
> >> What is a reasonable fix?
> >> 1) Do not read from drives which are !In_sync (a bit scary to read
> >> from such drive)
> >
> > It is perfectly safe to read from a !In_sync device providing you are b=
efore
> > ->recovery_offset.
> >
> >
> >> 2) replace !Faulty to In_sync check
> >
> > That probably makes sense... though that could race with raid1_spare_ac=
tive().
> > If a read-error returned just after raid1_spare_active() set In_sync, a=
nd
> > before 'count' was subtracted from ->degraded, we would still set uptod=
ate
> > when we shouldn't.
> > It probably make sense to put all of raid1_spare_active inside the spin=
lock -
> > it doesn't get call often enough that performance is an issue (I hope).
> >
> > So:
> >  1/ change !Faulty to In_sync
> >  2/ extend the spinlock in raid1_spare_active to cover the whole functi=
on.
>=20
>=20
> I made these fixes and reproduced the issue. However, the result is
> not what we expect:
>=20
> # raid1_end_read_request() now indeed adds the r1_bio into retry_list,
> as we wanted
> # raid1d calls fix_read_error()
> # fix_read_error() searches for an In_sync drive to read the data
> from. It finds such drive (this is our good drive A)
> # now fix_read_error() wants to rewrite the bad area. But it rewrites
> only on those drives that are In_sync (except the drive it got the
> data from). In our case, it never tries to rewrite the data on drive B
> (drive B is not marked Faulty and not marked In_sync). As a result,
> md_error() is not called, so drive B is still not marked as Failed
> when fix_read_error() completes
> # so handle_read_error() retries the original READ by calling
> read_balance(), which again in my case selects the recovering drive
> B...
>=20
> And then the whole flow repeats itself again and again...and READ
> never completes.
>=20
> Maybe we should not allow selecting recovering drives for READ? Or
> some other approach?
>=20

Thanks for the testing and analysis.
Presumably we just want handle_read_error() to write to all non-faulty
devices, not just the InSync ones.
i.e. the following patch.

Thanks,
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6a9c73435eb8..a95f9e179e6f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2153,7 +2153,7 @@ static void fix_read_error(struct r1conf *conf, int r=
ead_disk,
 			d--;
 			rdev =3D conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags))
+			    !test_bit(Faulty, &rdev->flags))
 				r1_sync_page_io(rdev, sect, s,
 						conf->tmppage, WRITE);
 		}
@@ -2165,7 +2165,7 @@ static void fix_read_error(struct r1conf *conf, int r=
ead_disk,
 			d--;
 			rdev =3D conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags)) {
+			    !test_bit(Faulty, &rdev->flags)) {
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);

--Sig_/C4Lfc0+BDkhW39vmGl.F_db
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBov0znsnt1WYoG5AQJ1gRAAp1jLAhQiPdhzk6f3ERV1ZWrHcekN6DuC
uLE9MXm7dSkjM720DbqttYSTetVrKx/WxAQY+vWcN2I4LeaEuWELLEayfWnrpCEe
oCaLUtaLXc8gAH2QIyQD6+E8Koe43ortpaerhImOIUJyUkSadYfnRGMcQjG3iKNT
nmeUL3/3ixeN0fvjxwqO3/xw05KOwuQT0fDTGUMwH2ZZeZ0CWKwXsGTugmf29zMY
tenykYZiyWUaewLJgiATNGiXZkkpM1BYJcVgH0podYvFovYew52aNM+qsegS/tWk
6jnp0kWwO3kzv/bWfQcimI8rwFiNGo2pMb364L925ZEuHLUMaoWisut3zSfxTBlM
xipsyr77i5/sCKP55xpuo3dB28hzx5hHa0h7BYqBkvGF+f7IU7y09mkGkM8gQexz
BFnN2SbfntTSYqoXT9I3JXCYWJ1FSQQsHOTy5kTH9L5R1fo/+ghsvmOOH6dpj9VN
NKpn0kCSMcdXbrZwHaB79Fo8uDEmdqAz2I2HQ7Gz1NIWTutAzBWAXb3pEMYmnbxU
NtUYzdCA+VwBu30hiELJXznuqlCAShp+8s11LaEfZTLoflDLp5Tb8dytybP11sKB
9ya2fcfMuIdaB072IDd+GfkCVHmGdNN3U57Tc34sspVPZBc0f0Sddpa9pVPU6gX8
+N1hSoyAzt0=
=kezI
-----END PGP SIGNATURE-----

--Sig_/C4Lfc0+BDkhW39vmGl.F_db--
