From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Explicitly turn off bad block support
Date: Tue, 23 Apr 2013 10:05:15 +1000
Message-ID: <20130423100515.5c4c3ee6@notabene.brown>
References: <1366378224.14427.1.camel@f16>
	<20130422105228.3948c69f@notabene.brown>
	<1EBA319B-13B9-4E75-A62F-C3F180A08C07@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P2qMbDMu/.08pUbXUjzcw_Y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1EBA319B-13B9-4E75-A62F-C3F180A08C07@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/P2qMbDMu/.08pUbXUjzcw_Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Apr 2013 11:29:48 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Apr 21, 2013, at 7:52 PM, NeilBrown wrote:
>=20
> > On Fri, 19 Apr 2013 08:30:24 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >> DM RAID:  Explicitly turn off bad block support
> >>=20
> >> DM RAID does not currently use the bad block tracking available in
> >> MD.  'badblocks.shift' must be set to '-1' in order to explicitly
> >> tell MD not to perform bad block related functions, like
> >> narrow_write_error().
> >>=20
> >> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> >>=20
> >> Index: linux-upstream/drivers/md/dm-raid.c
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> --- linux-upstream.orig/drivers/md/dm-raid.c
> >> +++ linux-upstream/drivers/md/dm-raid.c
> >> @@ -170,8 +170,10 @@ static struct raid_set *context_alloc(st
> >> 	rs->md.delta_disks =3D 0;
> >> 	rs->md.recovery_cp =3D 0;
> >>=20
> >> -	for (i =3D 0; i < raid_devs; i++)
> >> +	for (i =3D 0; i < raid_devs; i++) {
> >> 		md_rdev_init(&rs->dev[i].rdev);
> >> +		rs->dev[i].rdev.badblocks.shift =3D -1; /* No bad block support */
> >> +	}
> >>=20
> >> 	/*
> >> 	 * Remaining items to be initialized by further RAID params:
> >>=20
> >=20
> > Thanks, but I don't think this is the right fix.
> > md_rdev_init really should set shift to -1, because we can only support
> > badblocks if the metadata explicitly supports it.
> >=20
> > What do you think of this instead?
>=20
> I like it much better.  It means that the proper initialization is done c=
entrally, rather than expecting every super block type to know enough to tu=
rn off things they may not know about.  I considered this, but went along w=
ith the idea that it was the responsibility of the individual superblock ha=
ndlers.
>=20

:-)

Does this need to go to -stable?  Which versions, do you know?

Thanks,
NeilBrown

--Sig_/P2qMbDMu/.08pUbXUjzcw_Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXXQOznsnt1WYoG5AQK8QA/9GUCDzY3WUTNJCqOWcutkhfn7QPnSQNde
V3esOYJE5QPDYYnpsIwtMawb4v5YohiqM4BPnVEM2lCrJga1z4Nl6J+CIHSRyj5B
pn63ZcRanB4ecYqV9yZCsYQXmD7myTS0z29+M1NovAV0HTjjr+VBwXDVNTDxZtYg
9ZEOEUdikohulepoq9SolrnDUHpOwQud4RLCoZJ4PDylUhQICRZp9+yxx08+XT0f
1LfrsCg2GKsn+4RkyPdyi63EyKOrWPNCluOC5IpkT33ndb1jAUWOAnh16HLoPmKk
jvEs4RWBj0bzJKzrR/hrNVsS3xM2zJGgX5mvVm4nfLAVqCx3zAq0rq7qvRlkrbcN
02BayGB4alKcwCI9Zl0hcgS3gHxtDzBb4b0ggLhANLhQqvkwtEuCfKQorMVeFuEd
RMfpAxByO4/zax/GYUoHGhC3eaFQwZA7oZjxcPTDSphPJHEWALcf1p9rz2XiuWTi
TeGj/LOlIV3pm7E2Qej0iU0KPvfqX+n6Ho14JYtnWBI5Z3hTw46hYWGgG0bq4/48
haxOGY4ZNjq9RxKbDYDlICRzOk3muUqgk8T1RPbp5HX7iOjGBOzIJ4Kd+6MZjH26
OMBWUrnDiQ0ZMq9Awne+xiTDhxD22VHGGIlC8ZA6xF6HwWZHf1sxRND7EEde8DzI
5UaqlbIK5M8=
=C0v/
-----END PGP SIGNATURE-----

--Sig_/P2qMbDMu/.08pUbXUjzcw_Y--
