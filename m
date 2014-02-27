From: NeilBrown <neilb@suse.de>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Thu, 27 Feb 2014 14:19:09 +1100
Message-ID: <20140227141909.697fecd3@notabene.brown>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
	<CAGRgLy5OkpZnfOpPS+16Tiep8eisOu9XnK7EcvZygwg22DVTqQ@mail.gmail.com>
	<20120607212434.4d6211d6@notabene.brown>
	<CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
	<20120627172255.40ee3a19@notabene.brown>
	<CAGRgLy5iDmGqi4kFGuJGVjw++cbLBVGK6VgA=znDGiZVTJfYGg@mail.gmail.com>
	<CAGRgLy6pzRCPjCFT7Pots0QqSC_T_PRqN19-quCxxLoPDjqbfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6uEzWaESvthfpqsoQzxrm1g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6pzRCPjCFT7Pots0QqSC_T_PRqN19-quCxxLoPDjqbfQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Andrei Warkentin <andrey.warkentin@gmail.com>, Yair Hershko <yair@zadarastorage.com>
List-Id: linux-raid.ids

--Sig_/6uEzWaESvthfpqsoQzxrm1g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Feb 2014 15:02:27 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> HI Neil,
> can you please comment what do you think of this change.

Sorry for not replying earlier.

I think the core problem you are addressing is fixed by:

commit f466722ca614edcd14f3337373f33132117c7612
Author: NeilBrown <neilb@suse.de>
Date:   Mon Dec 9 12:04:56 2013 +1100

    md: Change handling of save_raid_disk and metadata update during recove=
ry.

Can you confirm if that is the case?

With respect to the split-brain issue, I see that you would like every
superblock to know which devices are truly operational and which are still
recovering - a distinction which my current code doesn't allow.

You want to know this because if you can see only 2 drives from a 4-drive
RAID6 then:
 - if the other 2 devices are believed to be fully functional, then we risk=
 a
   split-brain situation and shouldn't start the array
 - if either of the other devices is missing or still recovering, then there
   is no risk of split brain and the array can be started.

With the current code you might refuse to start an array because it looks
like it both other drives could be fully functional where in fact they are
still recovering.
This at least fails safely, but it may be that we want to absolutely minimi=
se
the number of false-failures.

However I would hope that the total amount of time that the array spends
recovering a device would be a very small fraction of the total time that t=
he
array is active.  If that is true, then the number of times you get a crash
during recovery will be a small fraction of the total crashes, so the number
of false-failures should be a small fraction of the reported failures.

So I don't see this as a big problem.

With respect to the "biggest problem" you note in the split-brain document
you reference:  this is an issue that has been in the back of my mind for
many years, wondering how much I should care and to what extent it should be
"fixed".  Whenever I have come close to fixing it, I've managed to convince
myself that I shouldn't.

We only record a device as 'failed' if a write fails.  And if a write fails
then that device is clearly inconsistent with the rest of the array.  So it
really seems appropriate to record that fact.
I could possibly be convinced that there comes a point where updating
superblocks any further is completely pointless, but I would need to be
certain that it wouldn't leave a suggestion that the array was more coherent
than it really is.

Thanks,
NeilBrown


>=20
> Thanks,
> Alex.
>=20
> On Wed, Feb 19, 2014 at 11:51 AM, Alexander Lyakas
> <alex.bolshoy@gmail.com> wrote:
> > Hello Neil, Andrei,
> > I don't how much you recall of this old discussion.
> >
> > Basically, the change that you made means that md doesn't update the
> > superblock on the recovering device, until recovery completes. As a
> > result, when assembling such array, the recovering device has an old
> > event count in the superblock and is not picked during assembly. So
> > later, user has to re-add it manually.
> > This is true for a device that failed and was re-added. For a fresh
> > device, saved_raid_disk=3D=3D-1, so its superblock will still be updated
> > (and sucn device will be picked on assembly).
> >
> > On the other hand, MD updates the superblock of the In_sync devices
> > and marks the recovering device as having a valid array slot (not
> > 0xFFFF or 0xFFFE, which are treated similarly today).
> >
> > What do you think of the following change:
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 561a65f..4bbc7e3 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -1854,8 +1854,6 @@ retry:
> >                         sb->dev_roles[i] =3D cpu_to_le16(0xfffe);
> >                 else if (test_bit(In_sync, &rdev2->flags))
> >                         sb->dev_roles[i] =3D cpu_to_le16(rdev2->raid_di=
sk);
> > -               else if (rdev2->raid_disk >=3D 0)
> > -                       sb->dev_roles[i] =3D cpu_to_le16(rdev2->raid_di=
sk);
> >                 else
> >                         sb->dev_roles[i] =3D cpu_to_le16(0xffff);
> >         }
> >
> > Basically, we do not mark the slot of the recovering device, until its
> > recovery completes. So during assembly, we will not pick it, as
> > before. For a fresh drive, there will be a regression - we will not
> > pick it as well on assembly.
> >
> > The reason I am considering this change is another old discussion that
> > we had - considering split-brain resolution, and the proposal I made
> > in:
> > https://docs.google.com/document/d/1sgO7NgvIFBDccoI3oXp9FNzB6RA5yMwqVN3=
_-LMSDNE
> >
> > Basically, when MD marks recovering devices as having a valid raid
> > slot in the superblock of In_sync devices, then on array assembly we
> > don't know whether sucn device is recovering or In_sync (if it is
> > inaccessible during assembly). So we have to assume it is In_sync and
> > thus can potentially cause split-brain.
> >
> >
> > What do you think of this change?
> >
> > Thanks,
> > Alex.
> >
> >
> > On Wed, Jun 27, 2012 at 9:22 AM, NeilBrown <neilb@suse.de> wrote:
> >> On Thu, 7 Jun 2012 15:47:46 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> >> wrote:
> >>
> >>> Thanks for commenting, Neil,
> >>>
> >>> On Thu, Jun 7, 2012 at 2:24 PM, NeilBrown <neilb@suse.de> wrote:
> >>> > On Thu, 7 Jun 2012 10:22:24 +0300 Alexander Lyakas <alex.bolshoy@gm=
ail.com>
> >>> > wrote:
> >>> >
> >>> >> Hi again Neil, and Andrey,
> >>> >>
> >>> >> looking at this email thread:
> >>> >> http://www.spinics.net/lists/raid/msg36236.html
> >>> >> between you and Andrey, the conclusion was:
> >>> >> "So the correct thing to do is to *not* update the metadata on the
> >>> >> recovering device until recovery completes.  Then if it fails and =
is
> >>> >> re-added, it will look just the same as when it was re-added the f=
irst
> >>> >> time, and will do a bitmap-based recovery."
> >>> >>
> >>> >> I have two doubts about this decision:
> >>> >> 1) Since the event count on the recovering drive is not updated, t=
his
> >>> >> means that after reboot, when array is re-assembled, this drive wi=
ll
> >>> >> not be added to the array, and the user will have to manually re-a=
dd
> >>> >> it. I agree this is a minor thing.
> >>> >
> >>> > Still, if it can be fixed it should be.
> >>> >
> >>> >> 2) There are places in mdadm, which check for recovery_offset on t=
he
> >>> >> drive and take decisions based upon that. Specifically, if there is
> >>> >> *no* recovery offset, the data on this drive is considered to be
> >>> >> consistent WRT to the failure time of the drive. So, for example, =
the
> >>> >> drive can be a candidate for bumping up events during "force
> >>> >> assembly". Now, when superblock on such drive is not updated during
> >>> >> recovery (so there is *no* recovery offset), mdadm will think that=
 the
> >>> >> drive is consistent, while in fact, its data is totally unusable u=
ntil
> >>> >> after recovery completes. That's because we have updated parts of =
the
> >>> >> drive, but did not complete bringing the whole drive in-sync.
> >>> >
> >>> > If mdadm would consider updating the event count if not recovery ha=
d started,
> >>> > then surely it is just as valid to do so once some recovery has sta=
rted, even
> >>> > if it hasn't completed.
> >>>
> >>> The patch you accepted from me ("Don't consider disks with a valid
> >>> recovery offset as candidates for bumping up event count") actually
> >>> attempts to protect from that:)
> >>>
> >>> I don't understand why "it is just as valid to do so once some
> >>> recovery has started". My understanding is that once recovery of a
> >>> drive has started, its data is not consistent between different parts
> >>> of the drive, until the recovery completes. This is because md does
> >>> bitmap-based recovery, and not kind of journal/transaction-log based
> >>> recovery.
> >>>
> >>> However, one could argue that for force-assembly case, when data
> >>> anyways can come up as partially corrupted, this is less important.
> >>
> >> Exactly.  And mdadm only updates event counts in the force-assembly ca=
se so
> >> while it might not be ideal, it is the best we can do.
> >>
> >>>
> >>> I would still think that there is value in recoding in a superblock
> >>> that a drive is recovering.
> >>
> >> Probably.  It is a bit unfortunate that if you stop an array that is
> >> recovering after a --re-add, you cannot simply 'assemble' it again and
> >> get it back to the same state.
> >> I'll think more on that.
> >>
> >> Meanwhile, this patch might address your other problem.  It allows --r=
e-add
> >> to work if a non-bitmap rebuild fails and is then re-added.
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index c601c4b..d31852e 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -5784,7 +5784,7 @@ static int add_new_disk(struct mddev * mddev, md=
u_disk_info_t *info)
> >>                         super_types[mddev->major_version].
> >>                                 validate_super(mddev, rdev);
> >>                 if ((info->state & (1<<MD_DISK_SYNC)) &&
> >> -                   (!test_bit(In_sync, &rdev->flags) ||
> >> +                   (test_bit(Faulty, &rdev->flags) ||
> >>                      rdev->raid_disk !=3D info->raid_disk)) {
> >>                         /* This was a hot-add request, but events does=
n't
> >>                          * match, so reject it.
> >>
> >>
> >>>
> >>> >
> >>> >>
> >>> >> Can you pls comment on my doubts?
> >>> >
> >>> > I think there is probably room for improvement here but I don't thi=
nk there
> >>> > are any serious problems.
> >>> >
> >>> > However I'm about to go on leave for a couple of week so I'm unlike=
ly to
> >>> > think about it for a while. I've made a note to look at it properly=
 when I
> >>> > get back.
> >>> >
> >>>
> >>> Indeed, don't you think about this while you are resting!
> >>
> >> :-)
> >>
> >>
> >> Thanks.  I did have a very enjoyable break.
> >>
> >> NeilBrown


--Sig_/6uEzWaESvthfpqsoQzxrm1g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUw6urTnsnt1WYoG5AQJXyA/5AVYrIJk2Qn2xd91xBohC2+Z2c1Mssdm3
4dGoIgHw2Q1N20aBtIJZlRkU1r3PwRVnu1KigyzGHQqEwaxSpaU7FKU9M0Vp265w
BhN9Cn+fN3lLv8CSuuuePdXWXa7UFcdiLriv8+AhLITEcBSmoOm+z7x9r+V1lXle
T4k45C5mWaGuFEtPiZakWLoELG3n9tdtCcjuB4x/VkJXLhuA6jnk1f/ySFzmmAWf
L27Gf7YZkJuNRKpIsI32/F6tk0g5NgylYitG1h/7/TaXsoNTpjO/lRLnTerTVnsh
rNjZaut7j70ZED/76KyCWq8ViVtrZk7GXeS/8MtRQPewoahfGyuOGxCeaie7ii62
4qINFqNQbM6+nu5Y1ni2+7gxIV/uQNKlTT8V/ogL47/7RLtz7aMx9ocYRMJjfITO
cQq4Ley7Sg1gyGiWZXR/XlZOraKykuFmuE+1hQm/hzDN4+bfFiSJzgP7ock6ekrY
nYK4XBKJcRwEOouV24qPN0VdSWh/SXG7Xm2lUZPtHz1iSledlEm7wNRP9cgjzhdz
EWaXTEHKcBgemuSLD81mcm7bEiioba/7/1ZJkRXpZQXo9ObqNUEtRiF7+L02es5l
zm7SfA6Xc4k8UmEi81Au0mud6e2PKIZDcK934RgI/7mJaE01zmbZjVDA4HeN6Gn0
x2mRnRdwz4o=
=h6j0
-----END PGP SIGNATURE-----

--Sig_/6uEzWaESvthfpqsoQzxrm1g--
