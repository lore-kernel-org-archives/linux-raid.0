From: NeilBrown <neilb@suse.de>
Subject: Re: metadata 1.2 advantages?
Date: Thu, 9 Feb 2012 10:59:34 +1100
Message-ID: <20120209105934.36189d93@notabene.brown>
References: <4F323A00.8050506@profihost.ag>
	<4F32F435.60405@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aO+7/ymRd8dGYtkaT2kMfvN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F32F435.60405@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aO+7/ymRd8dGYtkaT2kMfvN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Feb 2012 14:16:21 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/08/2012 01:01 AM, Stefan Priebe - Profihost AG wrote:
> > Hi,
> >=20
> > for now i'm still using grub 0.97 which can only understand metadata
> > 0.9. Are there any advantages of the 1.2 metadata format?
> >=20
>=20
> There are a lot of advantages to the 1.x metadata format, but 1.0 is the
> easiest for bootloaders to deal with.  1.0, 1.1 and 1.2 is the same
> format, just with the superblock in different places.

Hi Peter,
 wasn't it you who told be that 1.2 was best for boot loaders, as 1.0 uses
block 0 which the bootloader also wants, while 1.2 uses a later block.
That is why 1.2 is the default.

??

NeilBrown

--Sig_/aO+7/ymRd8dGYtkaT2kMfvN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzMMZjnsnt1WYoG5AQKgzw//WbEjPXOEPt2DXksBFJzQ3ETtGeESjiHv
RQW46YXHfUc9nPCxW/Ukh8nLXzkmSUPbDGG7nx6vSiK4fyLwD6/lRUlcbr5lsqzX
NF1UyLlFJD0ZjGuM/23dIyv/Y5nqVa1eaCQUgoH3dZWT0PKgpj3A5fZ175MID73M
ljymXksOrvHXOvvpaW5uPxkg5kWHkPcuowmLkiF540upsCL1w32PeVdAKzgGVxb2
NV7WAGP0WYB42uPVwqhgYJqKSdpoWrRF+WPzaQHqkA4Tn4qzADmxKsCW7LfsMRnl
hHKvNreTPoGtsc5SZgMjEF78Bbk9Qc1iTlSEJXCQCFPWwaZ2DHz9zRFX0ln68YLF
j3SFxyvQZBVDiO7WzyT/ql2O/atnRB466S71AEL6aorM0tKVGyCzN0uGTAuxszsN
lffuGWaIFr14RMnXGPHBoxavooZXMCj0Lj2l42fIHk8FS0nKttAYhwm+mJJF+4o2
o0jgCW/IGraLoEArINGWhxt+GMbycb5jJ7MjE2wZGLhWHxjbKAkpAkT2aAo+/mWg
YFE4dFo3Ssx9YQma3LvRGCkAggdngwmLiOdpdvj02iBsiCTtlDyi6lOWrxMRmVDR
WacyDVo2Nz0EPUlLMUCHIY4oUGvhyA3ge/O4mV8o7n1O/5uo+DAAsIU9OXe93KsL
X+YsOYknAwo=
=ICkd
-----END PGP SIGNATURE-----

--Sig_/aO+7/ymRd8dGYtkaT2kMfvN--
