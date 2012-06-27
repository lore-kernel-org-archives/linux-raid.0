From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Wed, 27 Jun 2012 17:22:55 +1000
Message-ID: <20120627172255.40ee3a19@notabene.brown>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
	<CAGRgLy5OkpZnfOpPS+16Tiep8eisOu9XnK7EcvZygwg22DVTqQ@mail.gmail.com>
	<20120607212434.4d6211d6@notabene.brown>
	<CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ethdYtXCGcnIU9+3go57jKV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: andrey.warkentin@gmail.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ethdYtXCGcnIU9+3go57jKV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jun 2012 15:47:46 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Thanks for commenting, Neil,
>=20
> On Thu, Jun 7, 2012 at 2:24 PM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 7 Jun 2012 10:22:24 +0300 Alexander Lyakas <alex.bolshoy@gmail.=
com>
> > wrote:
> >
> >> Hi again Neil, and Andrey,
> >>
> >> looking at this email thread:
> >> http://www.spinics.net/lists/raid/msg36236.html
> >> between you and Andrey, the conclusion was:
> >> "So the correct thing to do is to *not* update the metadata on the
> >> recovering device until recovery completes. =A0Then if it fails and is
> >> re-added, it will look just the same as when it was re-added the first
> >> time, and will do a bitmap-based recovery."
> >>
> >> I have two doubts about this decision:
> >> 1) Since the event count on the recovering drive is not updated, this
> >> means that after reboot, when array is re-assembled, this drive will
> >> not be added to the array, and the user will have to manually re-add
> >> it. I agree this is a minor thing.
> >
> > Still, if it can be fixed it should be.
> >
> >> 2) There are places in mdadm, which check for recovery_offset on the
> >> drive and take decisions based upon that. Specifically, if there is
> >> *no* recovery offset, the data on this drive is considered to be
> >> consistent WRT to the failure time of the drive. So, for example, the
> >> drive can be a candidate for bumping up events during "force
> >> assembly". Now, when superblock on such drive is not updated during
> >> recovery (so there is *no* recovery offset), mdadm will think that the
> >> drive is consistent, while in fact, its data is totally unusable until
> >> after recovery completes. That's because we have updated parts of the
> >> drive, but did not complete bringing the whole drive in-sync.
> >
> > If mdadm would consider updating the event count if not recovery had st=
arted,
> > then surely it is just as valid to do so once some recovery has started=
, even
> > if it hasn't completed.
>=20
> The patch you accepted from me ("Don't consider disks with a valid
> recovery offset as candidates for bumping up event count") actually
> attempts to protect from that:)
>=20
> I don't understand why "it is just as valid to do so once some
> recovery has started". My understanding is that once recovery of a
> drive has started, its data is not consistent between different parts
> of the drive, until the recovery completes. This is because md does
> bitmap-based recovery, and not kind of journal/transaction-log based
> recovery.
>=20
> However, one could argue that for force-assembly case, when data
> anyways can come up as partially corrupted, this is less important.

Exactly.  And mdadm only updates event counts in the force-assembly case so
while it might not be ideal, it is the best we can do.

>=20
> I would still think that there is value in recoding in a superblock
> that a drive is recovering.

Probably.  It is a bit unfortunate that if you stop an array that is
recovering after a --re-add, you cannot simply 'assemble' it again and
get it back to the same state.
I'll think more on that.

Meanwhile, this patch might address your other problem.  It allows --re-add
to work if a non-bitmap rebuild fails and is then re-added.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c601c4b..d31852e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5784,7 +5784,7 @@ static int add_new_disk(struct mddev * mddev, mdu_dis=
k_info_t *info)
 			super_types[mddev->major_version].
 				validate_super(mddev, rdev);
 		if ((info->state & (1<<MD_DISK_SYNC)) &&
-		    (!test_bit(In_sync, &rdev->flags) ||
+		    (test_bit(Faulty, &rdev->flags) ||
 		     rdev->raid_disk !=3D info->raid_disk)) {
 			/* This was a hot-add request, but events doesn't
 			 * match, so reject it.


>=20
> >
> >>
> >> Can you pls comment on my doubts?
> >
> > I think there is probably room for improvement here but I don't think t=
here
> > are any serious problems.
> >
> > However I'm about to go on leave for a couple of week so I'm unlikely to
> > think about it for a while. I've made a note to look at it properly whe=
n I
> > get back.
> >
>=20
> Indeed, don't you think about this while you are resting!

:-)


Thanks.  I did have a very enjoyable break.

NeilBrown

--Sig_/ethdYtXCGcnIU9+3go57jKV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+q00Dnsnt1WYoG5AQIEOA/8CULDjRqwnbjmocP0SeMBI8Do2bM0XkmH
k9M8ziu+PNppvm1L1zrZ6GY1SWbqpwXLgYDMtNBnLuHGrAAihKL0pGDzesd+jJ8s
rfTqKC/zotqBH2haKLciKLb7KyhWYFKUPt/tnwyipzKlavN59Sm2jpIvEqBYhWlK
AgfdSN8EIysLjo4xaxfVPepE9m1u333ucdF5LEQcnc5kwq7KAYyIP7Uh0k3Jj98k
KS9jiBHh7oGyDtevNV9oCXLUxjfBQtZFv17Sc3aZTfAXl1pJe/wuu/IEdVPwrsDE
tp+piZddo2gHvHuEkWOGOSsvmnOQZ5Bhs9nHnXWhTUJXX0Z02Layou3xmtSEs2Bl
ROUIbL3eJgbGTQvZLkyD8W7jxZu50mlGFNv6wNkYEdCxlutkbbZo8ZeXwFIzru10
gqkdWB7ghEWRUyaDnDBOJwtaPGU8ck+mwEBg9L8yfWOsGNhhiTBj2F2/jisrsL9S
bR2Sf4408ggyaJ61nZuVvLIN1d09gaIqiJTB7Q2lsGxqSDxdOl+X/z8dtO3JEa9h
kM6MuiLI3CG+n82KQYesK2n6Ym5h06cz2Zw1O4/qbbK8v/HrtinaccwXol2MPJL7
/ix0IpiT84+rRjtxfKe4eNCqO4Ph5HYlnzmqCbPws0kdtr+tCwFh0cGV0tsg7MzK
qpvdq5f9EZU=
=gg0/
-----END PGP SIGNATURE-----

--Sig_/ethdYtXCGcnIU9+3go57jKV--
