From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Always run Grow_continue() for started array.
Date: Thu, 6 Oct 2011 15:00:04 +1100
Message-ID: <20111006150004.7c99a184@notabene.brown>
References: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
	<20111004155349.27434.70639.stgit@gklab-128-013.igk.intel.com>
	<20111005135909.13fe29d9@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A0368E5@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3wusoM/OIgoa+lq=IhLGi+R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A0368E5@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/3wusoM/OIgoa+lq=IhLGi+R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 5 Oct 2011 07:04:01 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of NeilBrown
> > Sent: Wednesday, October 05, 2011 4:59 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Willia=
ms,
> > Dan J
> > Subject: Re: [PATCH 1/3] Always run Grow_continue() for started array.
> >=20
> > On Tue, 04 Oct 2011 17:53:49 +0200 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> >=20
> > > So far there were 2 reshape continuation cases:
> > >  1. array is started /e.g. reshape was already invoked during initrd
> > >                       start-up stage using "--freeze-reshape" option/
> > > 2. array is not started yet /"normal" assembling array under reshape
> > > case/
> > >
> > > This patch narrows continuation cases in to single one. To do this
> > > array should be started /set readonly in to array_state/ before
> > > calling
> > > Grow_continue() function.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> >=20
> > I mostly like this patch.
> > However it seems to have lost something in Grow_continue.
> > The distinction between ->reshape_active=3D=3D1 and ->reshape_active=3D=
=3D2 is
> > lost.
> >=20
> > =3D=3D1 means just this array is in the middle of a reshape.
> > =3D=3D2 means that the whole container is being reshaped and after this=
 array is
> > done we need to move on to the next one.
> >=20
> > Was there are reason you removed that?  If not, please put it back.
>=20
> In both cases metadata is updated already and container _reshape() goes (=
somehow) directly to reshape array.
> In container reshape case mdmon moves changes to next array for reshape a=
nd container_reshape() will continue with next one.
>=20
> In case that single array is reshaped only mdmon finalizes reshape and co=
ntainer_reshape() finds no more arrays under reshape,
> So this would means end of work also.
>=20
> In my opinion during reshape continuation we do not need to know if this =
is container or single array reshape,
> Both cases can be handled by container_reshape() /external metadata/ and =
we do not need to track what kind of reshape occurs.
>=20
> Let me know your opinion.

Yes, that makes sense.

I don't seem to have the original patch any more.  If you could send it aga=
in
I'll apply it.

NeilBrown


--Sig_/3wusoM/OIgoa+lq=IhLGi+R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTo0nxDnsnt1WYoG5AQIv8w//YiJpYbmpqzay3tBLXfMhBg5GaZKy+sXV
lWzzWWoEFdBGp00/VeHWXS1K58gV90HZp/rdA7N6i2hftLb/U/njLQD5EYFjIM3h
v38wYNGuDbOgwGLKboYtFmEspyCpGjmdi0tRq7dYqEkExjxqLVJ5L4UcQDtLhlfv
R6HtCFT7snOY6QJJM8J8cd93Q6LNkozcRMQfDmJvXnBhYLdKDYh41LyHTaG7pUvD
KrxAxwsG6NEw/b0nr5o5B8CcVQWA/baO59oArORkU0xcI/ixIF2qk6hqw/h85nt4
OREArgejhx7YcCSyZaj+VWrTyzpdQmZ55copMc7kIAhqC1+lluic24B42X5pqxj6
6L3nUB9sND/cRpKDHPbYRYaI5v2ylwsPpzKWn1/7jNvSTrH4kcGOWcVMnS1/2okd
m9fSNSKwtM45zGsX39Bjv07UPrN50GTsQUj6dpj+3vCphqJKxsUKdrGegzgmlpfa
4uFNEgVFxiVQUPcYz9L+5mcRsaCZr+LqArV8dmSsSFzWHfCRFWiea/nEVQF7iDtS
7HQ8ah6cN3o33131c9c2O9eSWqPiYNMhxUKPebpDKs+7+A3B+gVRCnYeAMCTebrG
pDlPUyNX4VKluCAgW1J8nwh1dhxZBEVM9O/prt7kqyp1stsHTiGJgXzBV1MFfMaC
PPpH5kncb+g=
=DM/F
-----END PGP SIGNATURE-----

--Sig_/3wusoM/OIgoa+lq=IhLGi+R--
