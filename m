From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Thu, 12 Sep 2013 14:59:43 +1000
Message-ID: <20130912145943.6844547d@notabene.brown>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
	<20130905121123.27968f9f@notabene.brown>
	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
	<CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
	<20130911093518.794bbb21@notabene.brown>
	<5230D7C8.6080908@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p1oONK+o6ICHx30o9SdWXkH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5230D7C8.6080908@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/p1oONK+o6ICHx30o9SdWXkH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 22:51:20 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 09/11/2013 01:35 AM, NeilBrown wrote:
> > I think this patch will help.  The last hunk in particular should make =
the
> > difference.
> >=20
> > Please let me know if it fixes the problem.
>=20
> Thanks for figuring this out. Indeed I forgot the possibility that
> secondary LBA may be unused when I wrote that code.
>=20
> Are you going to fix this directly? Otherwise I might go over it,
> double-check, and submit a patch.
>=20

I've applied that patch I previously proposed (plus compile fix).  Feel free
to double-check anyway and  submit a patch if you find anything.

Thanks,
NeilBrown

--Sig_/p1oONK+o6ICHx30o9SdWXkH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFKPznsnt1WYoG5AQKQwhAApf6KVEVeABLBtRn5wpfvCGtlAiYi00K1
6g20sM+ZODOKDQPsznBgr3jZGhoYgHqbXoBBU3DIfX5EN56s8yM1OANpZLNsGahD
7IwdzeRKwtlF0JS2i1WBW9OpWl2F4JgzYn9zhAbouk3CwXPmi1D8PscUHwc6LmbY
swn2aXROrE9yGY9GcU9elqrFBWnzYrFhS6hZRHcjXUH7Ni3ptqYkXlIgBaGDxRLF
2ii3EpOtsaOrMJsB2QS1bskqKLokjrvX2x40/pEGLN83/z+b5aMhCISjliL4CsQO
/Lfs5LdfyZ3FhYEqckiW0i9Nyl7R8fMoY5Cdtjs5tmD6EVIsVsZaPvvu3eHe1MGN
6V/QWV2V5WAnJ9bERQXlAUKVAELuLD/bd1v343L6uDzH2+5XYouZMMYwnyzP3c4C
pmyOsEfxEAMDRJSQiWRYHkpeTxv15cKaYECfudsW6ldKm6Hbn5qFdG1h19gtR1Pu
YxYNcQdv4TDpyR0LWAltL4RykK7S2ws5TgFuWSPOLDTvAnX3OZBkWsj8ZoLg/P73
aTUPtjNEmrYZSthUK2OUU5Paik8H07TeFVp44ID3jLdHnEZ60kPqnATqXwHY7GX7
bwGLriTHxnv71nt82jOfKObm/UVbt+IyzAugCgpnKMT5jsT7eIgdwFsFwkqT1pQa
jbmcl5tlDDg=
=G74c
-----END PGP SIGNATURE-----

--Sig_/p1oONK+o6ICHx30o9SdWXkH--
