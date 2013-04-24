From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Explicitly turn off bad block support
Date: Wed, 24 Apr 2013 16:24:02 +1000
Message-ID: <20130424162402.5f49cacf@notabene.brown>
References: <1366378224.14427.1.camel@f16>
	<20130422105228.3948c69f@notabene.brown>
	<1EBA319B-13B9-4E75-A62F-C3F180A08C07@redhat.com>
	<20130423100515.5c4c3ee6@notabene.brown>
	<05873438-4768-4B95-A84B-076676764C82@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PvPOD0M.K3h2p8Q87.HpBeT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05873438-4768-4B95-A84B-076676764C82@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/PvPOD0M.K3h2p8Q87.HpBeT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Apr 2013 22:48:50 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Apr 22, 2013, at 7:05 PM, NeilBrown wrote:
>=20
> > On Mon, 22 Apr 2013 11:29:48 -0500 Brassow Jonathan <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >>=20
> >> On Apr 21, 2013, at 7:52 PM, NeilBrown wrote:
> >>=20
> >>> On Fri, 19 Apr 2013 08:30:24 -0500 Jonathan Brassow <jbrassow@redhat.=
com>
> >>> wrote:
> >>>=20
> >>>> DM RAID:  Explicitly turn off bad block support
> >>>>=20
> >>>> DM RAID does not currently use the bad block tracking available in
> >>>> MD.  'badblocks.shift' must be set to '-1' in order to explicitly
> >>>> tell MD not to perform bad block related functions, like
> >>>> narrow_write_error().
> >>>>=20
> >>>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> >>>>=20
> >>>> Index: linux-upstream/drivers/md/dm-raid.c
> >>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>> --- linux-upstream.orig/drivers/md/dm-raid.c
> >>>> +++ linux-upstream/drivers/md/dm-raid.c
> >>>> @@ -170,8 +170,10 @@ static struct raid_set *context_alloc(st
> >>>> 	rs->md.delta_disks =3D 0;
> >>>> 	rs->md.recovery_cp =3D 0;
> >>>>=20
> >>>> -	for (i =3D 0; i < raid_devs; i++)
> >>>> +	for (i =3D 0; i < raid_devs; i++) {
> >>>> 		md_rdev_init(&rs->dev[i].rdev);
> >>>> +		rs->dev[i].rdev.badblocks.shift =3D -1; /* No bad block support */
> >>>> +	}
> >>>>=20
> >>>> 	/*
> >>>> 	 * Remaining items to be initialized by further RAID params:
> >>>>=20
> >>>=20
> >>> Thanks, but I don't think this is the right fix.
> >>> md_rdev_init really should set shift to -1, because we can only suppo=
rt
> >>> badblocks if the metadata explicitly supports it.
> >>>=20
> >>> What do you think of this instead?
> >>=20
> >> I like it much better.  It means that the proper initialization is don=
e centrally, rather than expecting every super block type to know enough to=
 turn off things they may not know about.  I considered this, but went alon=
g with the idea that it was the responsibility of the individual superblock=
 handlers.
> >>=20
> >=20
> > :-)
> >=20
> > Does this need to go to -stable?  Which versions, do you know?
>=20
> dm-raid was introduce in 2.6.38, I believe.  A quick check shows your pat=
ch applies to v3.1+ (although I've only compiled and tested 3.9-rc8).  I wo=
uld like to see the patch go into stable.
>=20

OK, I've tagged it for -stable.  I won't try to get it into 3.9 as I think =
it
is too late, but it'll go into 3.10-rc1 and then to the relevant -stables.

Thanks,
NeilBrown

--Sig_/PvPOD0M.K3h2p8Q87.HpBeT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXd6gjnsnt1WYoG5AQLjbw//YCHAu5tm3ZOi7Pl3IBJUre9RfqHQ4hhg
p+T+Rvh29E/t9i12+f6KsL4hf4btadsNLhiBlzW8wBKQIfFnWeMPcfseHzUS1IPG
+1AfB6EwkgfGN7mVRP9buCfrgkSqr3iEhDtb4Svd7uerRPHGrEjpumkozV30KMjJ
bStDCpitJ1HVlBO3kuilzloVOOob+qYCxKJbePKEGHALWxK3PJPOVGzg5pNYYuxa
UZSEP0h5KuxkTsDFJREwQ00cPa7TmF+++tON3pyTBGVqNOSsZkA/FedpgyIzU1it
dWucRJnYkvBlrjAWnTZmflpsOh2pTwGy5NtTu9BswmquiaD66lmSBeg2nK3y2bkI
NDwOCnH+RIi82O4oU4Quw96il8KZf4jBxZLhcnn1wG1jzL8PxsONA537X1kOOr2J
Gm4duuixd65gaYkWs2di8AMylcSLTbQL1+dm8hHe43tQNBbRGDsxV4R1mpXbKz7f
y51mkoMYZb5p/jJPXFK6PwT6RwTPxyvzfdWs10cdp1Tmi4VRgpr0qKzooPslYRU8
gWraAVPvpqfKOE2MWUdVZs5AlfV5KU4Qfsctvpl8LI3rdwAcGAHiZPNRarmjZssY
UIYUvHwPQtFSu17vzccYwkBnLeZYe6LzhSk+ux3+RRybQ3vexiOIKhC9uYKIHEda
NwWtjfgA1P0=
=jXYp
-----END PGP SIGNATURE-----

--Sig_/PvPOD0M.K3h2p8Q87.HpBeT--
