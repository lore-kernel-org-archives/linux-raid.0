From: NeilBrown <neilb@suse.de>
Subject: Re: tests/03r5assemV1 issues
Date: Wed, 4 Jul 2012 15:23:27 +1000
Message-ID: <20120704152327.30dcf73e@notabene.brown>
References: <wrfjtxxqcn38.fsf@redhat.com>
	<20120703114459.29c21b8f@notabene.brown>
	<wrfjpq8c96c9.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Bv0RKdpJKRVpJ/ZDx=GqG6t"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjpq8c96c9.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Bv0RKdpJKRVpJ/ZDx=GqG6t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Jul 2012 18:07:02 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Mon, 02 Jul 2012 15:24:43 +0200 Jes Sorensen <Jes.Sorensen@redhat.co=
m>
> > wrote:
> >
> >> Hi Neil,
> >>=20
> >> I am trying to get the test suite stable on RHEL, but I see a lot of
> >> failures in 03r5assemV1, in particular between these two cases:
> >>=20
> >> mdadm -A $md1 -u $uuid $devlist
> >> check state U_U
> >> eval $tst
> >>=20
> >> mdadm -A $md1 --name=3Done $devlist
> >> check state U_U
> >> check spares 1
> >> eval $tst
> >>=20
> >> I have tested it with the latest upstream kernel as well and see the
> >> same problems. I suspect it is simply the box that is too fast, ending
> >> up with the raid check completing inbetween the two test cases?
> >>=20
> >> Are you seeing the same thing there? I tried playing with the max speed
> >> variable but it doesn't really seem to make any difference.
> >>=20
> >> Any ideas for what we can be done to make this case more resilient to
> >> false positives? I guess one option would be to re-create the array
> >> inbetween each test?
> >
> > Maybe it really is a bug?
> > The test harness set the resync speed to be very slow.  A fast box will=
 get
> > through the test more quickly and be more likely to see the array still
> > syncing.
> >
> > I'll try to make time to look more closely.
> > But I wouldn't discount the possibility that the second "mdadm -A" is
> > short-circuiting the recovery somehow.
>=20
> That could certainly explain what I am seeing. I noticed it doesn't
> happen every single time in the same place (from memory), but it is
> mostly in that spot in my case.
>=20
> Even if I trimmed the max speed down to 50 it still happens.

I cannot easily reproduce this.
Exactly which kernel and which mdadm do you find it with - just to make sure
I'm testing the same thing as you?

Thanks,
NeilBrown


--Sig_/Bv0RKdpJKRVpJ/ZDx=GqG6t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/PTTznsnt1WYoG5AQJStxAAlwmerspuLu7O3y7TInCb3CHJblh4rBSE
GxYbxjlKUuYGTWrs3Sn7CiS+aqdzHyB1ro4VoUbL19Yau4SAb+0MNpNda1SKOApG
L8JBP+kUehVV2pNZwqt4uMDCepID/5WJpcOKoaOJZoIn6rxN2Ue51i6ozV7vSoBS
rNyP+3HrfClzHJ/OvEAJtCcr/EQQReMCUz1bhvHHHnjEtKsISEDWKDTPY7MuSZYa
rEIbXz3yPTRfMPYKrSA35Cymw0QteYgjgGNadZovYRkR6GnYjYpoqTZE+EROtHIA
silAuRpmEWFylQuMfrQfyQiCfydwqvfvoV3ps+PQyDEKU/SMn5WiP1jCsceFUphD
Hl/p7t1KI/KodHQLGPqaro6G0LrV8ik//0wnWbc0o0C4FY+Va7sHVlnquW2TKL2t
RWwyZNUr5LewcFau0HsR9v6SogypfwB5uK5/Mv2WoWdGCGE6z67T5lPHWlPmb3S9
wobEsuyqZqel7xELhW/7OBTKkahnGu2wzgpY6CR4A2iSc91R6gJIk7bcV/CZbVb7
VBrY9GWyXS349mxIerg8JC0zWZjsP4y6bS/2VnJ20Ze14MiOCBBWM9jz9K9rCPZN
zJ+hrJ8QIEuTDWy9+e/Xb2QzwhjaMl/BLYZIyQ47jD5VDn7Z6wnabhrsSJxufupR
0ZoMzhpihbE=
=z68t
-----END PGP SIGNATURE-----

--Sig_/Bv0RKdpJKRVpJ/ZDx=GqG6t--
