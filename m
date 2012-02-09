From: NeilBrown <neilb@suse.de>
Subject: Re: metadata 1.2 advantages?
Date: Thu, 9 Feb 2012 12:02:47 +1100
Message-ID: <20120209120247.1d2629c2@notabene.brown>
References: <4F323A00.8050506@profihost.ag>
	<4F32F435.60405@zytor.com>
	<20120209105934.36189d93@notabene.brown>
	<4F331570.7010800@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XH.zcJ.1W+IAOqjUIA2jU/S"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F331570.7010800@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XH.zcJ.1W+IAOqjUIA2jU/S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 08 Feb 2012 16:38:08 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/08/2012 03:59 PM, NeilBrown wrote:
> > On Wed, 08 Feb 2012 14:16:21 -0800 "H. Peter Anvin" <hpa@zytor.com>
> > wrote:
> >=20
> >> On 02/08/2012 01:01 AM, Stefan Priebe - Profihost AG wrote:
> >>> Hi,
> >>>=20
> >>> for now i'm still using grub 0.97 which can only understand
> >>> metadata 0.9. Are there any advantages of the 1.2 metadata
> >>> format?
> >>>=20
> >>=20
> >> There are a lot of advantages to the 1.x metadata format, but 1.0
> >> is the easiest for bootloaders to deal with.  1.0, 1.1 and 1.2 is
> >> the same format, just with the superblock in different places.
> >=20
> > Hi Peter, wasn't it you who told be that 1.2 was best for boot
> > loaders, as 1.0 uses block 0 which the bootloader also wants, while
> > 1.2 uses a later block. That is why 1.2 is the default.
> >=20
>=20
> No, 1.1 uses block 0 which the bootloader wants.
>=20
> Bootloaders need no special enabling to support 0.9 or 1.0 RAID-1.
> 1.2 requires special enabling, but is workable.

Doh - of course. Wasn't thinking straight.
So 1.0 is good for boot loaders
   1.1 is bad for boot loaders
   1.2 is OK for boot loaders and good for other reasons (resizeable device=
s).

Thanks,
NeilBrown

--Sig_/XH.zcJ.1W+IAOqjUIA2jU/S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzMbNznsnt1WYoG5AQIYehAAj9TNkK2NouFpSoEhHHPoy7nj5xegj7HJ
fD9aMgHzksbH9RMBdnDP6+UVMaqlLRFQoecszqUQltki7PyOc/J//14OQBhZfn+9
OBul9Ve0hfPWL3fcsz3jXBMjlkS6TOws7anR7hH/2WfQJyIUIwdQZ36hvjlCs7ch
WZYvVKxLSGClTwU+/kKxjbxWr+bat9OFwbRflXMseIuCmtqZ25J/vjyq+YyfJT7P
1FKvZoZfUnAzedT3c4gN8uOub6Hf/16vNsio9Vu8NTuER6xSb+begbu5srGDkB6p
OQQCWpaEs1u8c6GLz374/4kxYq4iMmOux4hJaMqaPwq9L436k+NwLzKwg1Vc8GHN
UpX7Sk89rs45MfC+0OTOMQBZmVVLf0tizKNuQ5N+06Wvhp52w0Q0j5j4W97Lt4jN
vnDYsKmxMP2xWox1LZ1rgipF14la3mlHnW0u/oiSNOdhrqX8AWLWp+NGuoOjNbAP
Zb31GAUDTEz996Oiudgm4xbCrdheqXR7e7N0t83e5upUuvg2uhK3gnbQiQgmZCgK
NwH1pDwqIFxinBzSJ67H45+MSNTfxt4H4WbqnnpQ3U+7OYEUmvkYcpNiCb+vpo67
72NREex7AZZ7CBJWstboqNdJ60OJOSlwI7KHzJyLOInHWdgL7TMhaOWZR7NmYOqp
HS8nK/K9fp0=
=Bc1Y
-----END PGP SIGNATURE-----

--Sig_/XH.zcJ.1W+IAOqjUIA2jU/S--
