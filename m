From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Add ability to restore transiently failed
 devices on resume
Date: Wed, 24 Apr 2013 16:39:03 +1000
Message-ID: <20130424163903.04f068a1@notabene.brown>
References: <1365712023.9799.1.camel@f16>
	<20130422104326.217ef2f8@notabene.brown>
	<503B3DAE-0E23-44AC-B828-74B7BE9B4CE8@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/95aXOvmhy5LB1twdnWlL9Eg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <503B3DAE-0E23-44AC-B828-74B7BE9B4CE8@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: linux-raid.ids

--Sig_/95aXOvmhy5LB1twdnWlL9Eg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Apr 2013 13:57:03 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Apr 21, 2013, at 7:43 PM, NeilBrown wrote:
>=20
> > On Thu, 11 Apr 2013 15:27:03 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >> DM RAID: Add ability to restore transiently failed devices on resume
> >>=20
> >> This patch adds code to the resume function to check over the devices
> >> in the RAID array.  If any are found to be marked as failed and their
> >> superblocks can be read, an attempt is made to reintegrate them into
> >> the array.  This allows the user to refresh the array with a simple
> >> suspend and resume of the array - rather than having to load a
> >> completely new table, allocate and initialize all the structures and
> >> throw away the old instantiation.
> >>=20
> >> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> >=20
> > Is this really a good idea? =20
> > Just because you can read the superblock, that doesn't mean you can rea=
d any
> > other block in the array.
>=20
> True.  To some extent, we are relying on user-space here.  The normal lif=
e of a DM device would consist of:
> 1) constructor (CTR)
> 2) resume
> 3) suspend (sometimes skipped)
> 4) destructor (DTR)
>=20
> It is pretty rare to get a secondary 'resume'.  A DM device is normally s=
uspended so that a different table can be loaded - in which case, the first=
 instance is destroyed (DTR) and the second instance undergoes its first re=
sume.  Another case that does happen, albeit rarely, is a "refresh" (e.g. '=
lvchange --refresh vg/lv').  This operation performs a suspend/resume for t=
he purpose of refreshing the in-kernel target.  This is the situation that =
I am trying to instrument with this patch.  You can see from the patch that=
 it is only secondary 'resumes' where the check is made.
>=20
> To say that there is no other case where a secondary resume would be done=
 would be silly.  I can't account for every case.  However, the user must b=
e resuming an existing target after a suspend (not a CTR) which is somewhat=
 rare.  There must be a failed device in the array for the subsequent super=
block read to be performed and that must succeed for the device to attempt =
revival.  If the device is really still in bad shape, it will fall back to =
'Faulty'.
>=20
> The approach I had been using in user-space was to load a completely new =
(and identical) mapping table.  The old table and structures were discarded=
 and all the state of the devices was lost.  The new table was instantiated=
 with new structures and all devices assumed to be fine.  (It would, of cou=
rse, be noticed that a device had failed and must be recovered, but it woul=
d be assumed that it was alive and able to do so.)  User-space would do thi=
s partially based on the fact that the LVM label could be read from the dis=
k and partially from the fact that the user had made the decision to run th=
e 'lvchange --refresh' command in the first place.  This seems to be far mo=
re messy than possibly reviving the device in the 'resume'.
>=20
> Another possibility is to put this functionality into the 'message' inter=
face.  Any 'refresh' command could use that.  Then, the cases I am unable t=
o account for that issue secondary resumes would not also have the side eff=
ect of trying to revive any failed devices that may exist in the array who =
just happen to have readable superblocks.  However, it is nice to have the =
device suspended when the device revival is attempted.  If we put the reviv=
al code into the 'message' function, I may have to wrap the revival code wi=
th a suspend and resume anyway - not sure yet.
>=20
> Personally, I like having the revival code in the 'resume' over the 'mess=
age' function.  I'll make sure Alasdair gets a copy of this message to see =
if he has an opinion.

Thanks.  You explanation does much to allay my concerns.
If Alasdair doesn't object to a secondary resume always attempted to
reactivate any devices that have been marked as faulty, then I won't object
either.

Thanks,
NeilBrown


>=20
> >=20
> > If the auto-recovery were optional I might consider it, but having it be
> > enforced on every suspend/resume just doesn't seem safe to me.
> >=20
> > Have I misunderstood?
> >=20
> > Is this that hard to achieve in user-space?
> >=20
> >=20
> >> +			if (test_bit(Faulty, &r->flags) && r->sb_page &&
> >> +			    !read_disk_sb(r, r->sb_size)) {
> >=20
> > I know it is fairly widely used, especially for 'strcmp', but I absolut=
ely
> > despise this construct.
> >  !read_disk_sb()
> > sound like
> >  "not read_disk_sb" or "could not read the disk's superblock" but it
> > actually means "did not fail to read the disk's superblock" - the exact
> > reverse.
> > If 0 means success, I like to see an explicit test for 0:
> >   read_disk_sb() =3D=3D 0
>=20
> Ok, I'll try to remember that.  This issue has solved itself though, beca=
use I must switch to using sync_page_io directly anyway.  I'll have to post=
 another patch whether we proceed or decide to change where we put this cod=
e.
>=20
>  brassow


--Sig_/95aXOvmhy5LB1twdnWlL9Eg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXd+CDnsnt1WYoG5AQLqNw//RghmJFIlU4nNAQtX6U1HjCDGvLoDflEf
SdJ8CDTJ24gWyvsqxBgs19wdoZUhn6s9VbNTltkLhQAloqrcepVYqldmYX+grLK2
Iw+q6NGS7eCd7FrzY+CGp8figj0KeVeXhIRgb7tXWisZIkut3XWSyV/G8weHm446
b1+PNfbJFZWn+UONlOywxL3bld4Mpz4l8V/FNubI05YTq99OzXXUcPmOfUqCeK+Z
PJ19MsQmK3BviQO0gt7M5AQyQyiWT5yK0dM0h8fAQ5/FNV5qG4NMhFnUO94C8zln
RVoemRhx5XWQv5tlmlxvaWntYaL51oOWuw0VJlilkuobAYIcXJ0oDIRev52fTSeQ
ZbYDHzkP2Ql/rXkk7df+N0rboi0mGBcou11qG7V+2xLAzG//jskEeJf8WHhdcDDr
9mUk0Vdm6Uycf8Z/+rpvr0dDsoryneEgcz/cBtu3CYkofTECrZFBBnBIrGyayCh+
sUpJCzbAUFcYXhhRXDStSdJrXfnNKglH5BzWjvlBnh4jUYZOBTDCaTlAQFTHGfmy
RLsEK+SYIn37k+lVok0JPmQsyMPCvfvZxHi6fdoNQarMbEUw2EPLFT1dbInURoBs
Iw69H2HufOVG0iEcnumzKMMtVmIi2FPEg1xnqvrdLA6jK+UelwbW+r5w9KK/4yju
uLeg1tmuh4Q=
=BQh8
-----END PGP SIGNATURE-----

--Sig_/95aXOvmhy5LB1twdnWlL9Eg--
