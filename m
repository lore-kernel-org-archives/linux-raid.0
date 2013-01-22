From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM-RAID: Fix RAID10's check for sufficient redundancy
Date: Tue, 22 Jan 2013 16:52:21 +1100
Message-ID: <20130122165221.6b610ddd@notabene.brown>
References: <1357783259.9103.5.camel@f16>
	<1357783352.9103.7.camel@f16>
	<20130110170340.6f4d0508@notabene.brown>
	<05723465-2748-4BF8-8268-63989289E5A2@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aiyYngd+/NG8TuaWTbhNyZ."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05723465-2748-4BF8-8268-63989289E5A2@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: linux-raid.ids

--Sig_/aiyYngd+/NG8TuaWTbhNyZ.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jan 2013 09:02:36 -0600 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jan 10, 2013, at 12:03 AM, NeilBrown wrote:
>=20
> > On Wed, 09 Jan 2013 20:02:32 -0600 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >>=20
> >> On Wed, 2013-01-09 at 20:00 -0600, Jonathan Brassow wrote:
> >>> DM RAID:  Fix RAID10's check for sufficient redundancy
> >>>=20
> >>> Before attempting to activate a RAID array, it is checked for suffici=
ent
> >>> redundancy.  That is, we make sure that there are not too many failed
> >>> devices - or devices specified for rebuild - to undermine our ability=
 to
> >>> activate the array.  The current code performs this check twice - onc=
e to
> >>> ensure there were not too many devices specified for rebuild by the u=
ser
> >>> ('validate_rebuild_devices') and again after possibly experiencing a =
failure
> >>> to read the superblock ('analyse_superblocks').  Neither of these che=
cks are
> >>> sufficient.  The first check is done properly but with insufficient
> >>> information about the possible failure state of the devices to make a=
 good
> >>> determination if the array can be activated.  The second check is sim=
ply
> >>> done wrong in the case of RAID10 because it doesn't account for the
> >>> independence of the stripes (i.e. mirror sets).  The solution is to u=
se the
> >>> properly written check ('validate_rebuild_devices'), but perform the =
check
> >>> after the superblocks have been read and we know which devices have f=
ailed.
> >>> This gives us one check instead of two and performs it in a location =
where
> >>> it can be done right.
> >>>=20
> >>> Only RAID10 was affected and it was affected in the following ways:
> >>> - the code did not properly catch the condition where a user specified
> >>>  a device for rebuild that already had a failed device in the same mi=
rror
> >>>  set.  (This condition would, however, be caught at a deeper level in=
 MD.)
> >>> - the code triggers a false positive and denies activation when devic=
es in
> >>>  independent mirror sets have failed - counting the failures as thoug=
h they
> >>>  were all in the same set.
> >>>=20
> >>> The most likely place this error was introduced (or this patch should=
 have
> >>> been included) is in commit 4ec1e369 - first introduced in v3.7-rc1.
> >>>=20
> >>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> >>=20
> >> Neil,
> >>=20
> >> This patch should apply cleanly on top of recent changes, but will not
> >> apply cleanly on an older kernel (like 3.7) due to version # changes a=
nd
> >> introduction of the new 'far' and 'offset' RAID10 algorithms.  If you
> >> think this fix should be pushed back into 3.7 rather than just applying
> >> on the latest code, I will make a patch for 3.7 - although I'm not
> >> certain how I'd handle the version number conflict.
> >=20
> > Thanks Jon, I've applied that patch.
> >=20
> > I can't say if it should be back-ported.  What is the worst-case scenar=
io if
> > something goes wrong?  Do the current user-space code contain appropria=
te
> > tests itself too?
> >=20
> > I don't see how version numbers will be a concern - they are just comme=
nts in
> > a 'Documentation' file aren't they?   If necessary, add extra text to e=
xplain
> > any possible confusion.
>=20
> The first condition mentioned above isn't that big of a problem since MD =
will catch the error deeper down.  The second problem can be pretty bad, bu=
t is somewhat limited.  The array will run as you would expect while it is =
active.  It is only when you attempt to re-activate or repair the array tha=
t the problem would occur.  In that case, it would only activate if there a=
re 'copies - 1' or less failed devices present.  This doesn't count any spa=
res that may have been introduced.  So, if you had a 2-stripe, 2-copy array=
 (i.e. 'AA BB') and 2 of the devices failed ('A- B-'), you would not be abl=
e to reactivate the array unless you replaced at least one of the devices w=
ith a spare (e.g. 'A- BS').  There is no corruption or anything, but loosin=
g more than one device and not having any spares would leave you in a pickl=
e.

Yes, sounds like that is worth backporting.  Care to write a patch?

>=20
> The version number is tricky because we use it to determine what features=
 a target has.  Testing of a particular feature keys off of this number rat=
her than the kernel version.  I will have unit tests to make sure this bug =
is fixed and does not resurface, but it will only run if version =3D 1.4.2.=
  I can't assign the 3.7 kernel with 1.4.2 because that also implies that t=
he 'far' and 'offset' algorithms are there (introduced in 1.4.1).  Tests fo=
r those algorithms would then fail because the feature isn't actually there=
.  What I could do is choose 1.3.2 (one more than the 3.7 version number, 1=
.3.1).  This would signal the fix but avoid implying Mikulas' changes or th=
e new algorithms.  Then I would simply test for '(version =3D=3D 1.3.2) || =
(version > 1.4.1)' for this particular unit test.  For the average bloke, t=
hings would just work the way they expect.

Why not test for (version >=3D 1.3.2) ?? Or doesn't version comparison work
that way?

NeilBrown


>=20
>  brassow


--Sig_/aiyYngd+/NG8TuaWTbhNyZ.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUP4pFTnsnt1WYoG5AQKalxAAmwOpbYSkmrrBNj/+lyAdJdMOQarDqtnL
+L7QBPiyWMPV4CHubLjaQ3bSJ0+EWsdaxJ0Nq2EwPGBIGndUjMAhu7Ev+YGSATZi
M0SaT6+CRJqoXRy7TDIfCg6/DE+WEy5tLxxjiUV+23r3SIPRN1NIrYzHdjfuk2mc
vo6TmO6gqimB45CR1aqWcYe9JO8KMf864YAlHqPNEJBx4EHcMcS1TV/fFuNrOrLJ
n3hMQH2jjiMtsI8Jjhhs7nhAHBHnsEUyNDFCK9NRLAuuyr4ksqANaJW6rkOoAsZc
hDHgqWYpoo3/GYO8egWoJNEiDNtzNd94jhLNqDz0qHxu10WG8a/fs45lZ8f+5FDI
z4narddu4S3uZgvAAQhmFP08l4jUSovV9PWZ4koy7Gkk12RP/WaLUOmRcHXW94lm
sD0InNxmcDDTBvLjumB9zt9hI5NR1IZrO9IGG3wT4tLVgwVFH3WvhUvxngagIFvf
bJETbbrnMY3jTtPN9d0gL14klrv8N7OgMcQeRO8Owu6v1qzQoTnQz1A+ygVBwTHK
q1sG/xHFJVclppqekrBRxLWRmnESoIZKc/aIp7fPZLy7vXXAGWwnT/eoFoMyENn9
1L38YhtO/COStonlxVZ7rvEvFhnIOqC5lPTvDKef6IMZhpXYlGdCgmWBVuSM/Apn
SnX8sr3Wzlk=
=qzjP
-----END PGP SIGNATURE-----

--Sig_/aiyYngd+/NG8TuaWTbhNyZ.--
