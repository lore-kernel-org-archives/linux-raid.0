From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Sun, 22 Jan 2012 22:20:38 +1100
Message-ID: <20120122222038.659c34fb@notabene.brown>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
	<1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>
	<79556383A0E1384DB3A3903742AAC04A06DAEE@IRSMSX101.ger.corp.intel.com>
	<4F169A24.60109@redhat.com>
	<79556383A0E1384DB3A3903742AAC04A06F09D@IRSMSX101.ger.corp.intel.com>
	<4F16F6C9.1050108@redhat.com>
	<4F16F77C.6000405@redhat.com>
	<79556383A0E1384DB3A3903742AAC04A06F48F@IRSMSX101.ger.corp.intel.com>
	<4F1974AA.4050801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LHf9otBRdA=76IADWoqdYJ+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1974AA.4050801@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "kay@redhat.com" <kay@redhat.com>, "harald@redhat.com" <harald@redhat.com>, "lpoetter@redhat.com" <lpoetter@redhat.com>, "mschmidt@redhat.com" <mschmidt@redhat.com>
List-Id: linux-raid.ids

--Sig_/LHf9otBRdA=76IADWoqdYJ+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jan 2012 15:05:30 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> On 01/19/12 08:25, Kwolek, Adam wrote:
> >>> If there is already a --freeze-reshape option, then I think it is
> >>> > > better to have the boot scripts set that explicitly. The initramfs
> >>> > > stage isn't really something we expect users or admins to mess wi=
th
> >>> > > manually, so it ought to work for that. However if there is no op=
tion
> >>> > > for this, and I just need to set the variable when detecting --in=
itrd,
> >>> > > then I can add that to the patchset no problem.
> >> >=20
> >> > I guess I should add here, that I am not strongly opposed to setting
> >> > freeze_reshape for initrd. I am just wary of setting multiple flags =
magically
> >> > without it being obvious to the user/admin.
> >> >=20
> >> > Cheers,
> >> > Jes
> > Up to you.
>=20
> Ok, I will leave it up to Neil/Kay/Harald - what do you guys think?
> Should we make --initrd set the freeze_reshape flag, or better to expect
> the initramfs scripts to specify it directly?
>

I would like to keep these two options separate.
It might be worth noting in the man page that --freeze-reshape would normal=
ly
be used with --whatever-we-call-the-new-flag, but I don't think they should
be the same option.

thanks,
NeilBrown

--Sig_/LHf9otBRdA=76IADWoqdYJ+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTxvxBjnsnt1WYoG5AQJ+9BAAmSXEHq/jgmKj/nxd9MC4RrkY40DnLpaa
BUaw7akP856WZe5EK59s/0qorLkFhdj85JkKIncUfxPBYCUZWsMsK8NgSoYsX5p/
ak8Eo/rluONFT3Bni74L4CGVHjIVC/8SR19DBm7LsV5AKRzcHFrDc9u6amjSUtTo
nTLIHp2OMI2YBKOSZxBJZuyxRxcygwF6Gtu2ZuY8ncytFJGZ4ZU2n/i0/xLFJ9Dn
URz7iw/NMBFI/nolK5YtQQr1O/jsFj2Q9E+kKImVxeUjm3+FVIKCNHF6ls7Cgl+M
GRdtZJAo7jPPvQRqdS89wkbsiuTAr57vA66PqTXdplHy/mkGPv6lIBEBudng/cOP
joR6GbYD+1NAlWJ3peZ/iJH1y41+5DU8vOrYbGk0ldAqB8U7lVRwni3smHxMSvNP
91/atwl3v9Y85TwFhgYTIQg9nUFnjE236uhLedUxtEPyS+xXLdv27vD9+HmADATX
ic6ST1E6Ho5SjTAmqDP0LSND6U19iSghiGAI1+86r767URggN3ErcmHtfGtPOLl9
sv6DHA/KS71mXa4S4To6wut9xygYhWHEJrUjm24I2gZY0CPkEG9ToDh4zvm/ZctI
bBxMP2ymBFDTjgMBBzhCaEb7YzyRVLBTNSQv4ASDu3GC4WdqN6zF5cV1IcK5wlWS
nIT/MU2kT3o=
=0g13
-----END PGP SIGNATURE-----

--Sig_/LHf9otBRdA=76IADWoqdYJ+--
