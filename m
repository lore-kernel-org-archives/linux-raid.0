From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Create: Allow to create two volumes of different
 sizes within one container
Date: Wed, 21 Sep 2011 16:55:00 +1000
Message-ID: <20110921165500.2df0b15e@notabene.brown>
References: <20110919165220.9239.2939.stgit@gklab-128-192.igk.intel.com>
	<20110919165230.9239.4775.stgit@gklab-128-192.igk.intel.com>
	<20110921133123.05d03613@notabene.brown>
	<CAA9_cmdkRFqUzj3rdOmNWhTBg=8Wk+LEoaPozawdjQvF0YGb7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fzn.N8lhnWxzDvMpghclHyh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmdkRFqUzj3rdOmNWhTBg=8Wk+LEoaPozawdjQvF0YGb7g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Lukasz Orlowski <lukasz.orlowski@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fzn.N8lhnWxzDvMpghclHyh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Sep 2011 23:31:03 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Tue, Sep 20, 2011 at 8:31 PM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 19 Sep 2011 18:52:31 +0200 Lukasz Orlowski
> > <lukasz.orlowski@intel.com> wrote:
> >
> >> Allows to create RAID 5 volume on 3 disks and then RAID 1 volume on 2
> >> disks withing the same container.
> >>
> >> Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>
> >> ---
> >> =A0super-intel.c | =A0 =A06 ++++++
> >> =A01 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/super-intel.c b/super-intel.c
> >> index a78d723..616853b 100644
> >> --- a/super-intel.c
> >> +++ b/super-intel.c
> >> @@ -5041,6 +5041,12 @@ static int validate_geometry_imsm_volume(struct=
 supertype *st, int level,
> >> =A0 =A0 =A0 if (!super)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >>
> >> + =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddisks)=
 {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option-rom requi=
res all "
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to be a member=
 of all volumes.\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 if (!validate_geometry_imsm_orom(super, level, layout, rai=
ddisks, chunk, verbose)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": RAID gemetry valid=
ation failed. "
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Cannot proceed with the a=
ction(s).\n");
> >>
> >
> > This patch doesn't make sense.
> >
> > Firstly the description seems backwards. =A0The purpose of this patch s=
eems to
> > disallow the creation of two volumes with different numbers of devices,=
 but
> > the description seems to say that it allows it. =A0But that is a small =
point.
> >
> > ->num_disks is the number of devices in the container including spares.=
 =A0This
> > patch would allow the first array in a container to have fewer devices =
than
> > the container with the rest being spares. =A0However the second array w=
ould have
> > to have the same number of devices as the container - even if this is m=
ore
> > than the first array.
> >
> > Presumably what you really want to do is:
> > =A0if num_raid_devs > 0, then find the relevant imsm_map, and then chec=
k if
> > =A0 =A0 map->num_members =3D=3D raiddisks
> > =A0and fail if they are not equal.
> >
>=20
> Yeah, the changelog is backwards, and this breaks tests/08imsm-overlap
> because it does not honor IMSM_NO_PLATFORM.  How about the attached?

Better (though text/plain attachments are preferred over
application/octet-stream....)

However there still seems to be confusion over num_disks versus num_members.

You compare num_disks to raiddisks but my understanding is that num_disks c=
an
include spares while raiddisks definitely doesn't.  Am I confused or are yo=
u?

NeilBrown


>=20
> Lukasz, please copy me on patch submissions.
>=20
> Thanks,
> Dan


--Sig_/fzn.N8lhnWxzDvMpghclHyh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeYpEG5fc6gV+Wb0RAjX/AJsEO21UlnY3gn6QIkM3pM9nHx12QQCfR111
f1jkm+I15tLkLmceptD7ZYY=
=CKtq
-----END PGP SIGNATURE-----

--Sig_/fzn.N8lhnWxzDvMpghclHyh--
