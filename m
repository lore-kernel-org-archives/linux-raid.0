From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: External bitmap, questions
Date: Sat, 19 Feb 2011 17:14:37 +0500
Message-ID: <20110219171437.3a6200e6@natsu>
References: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
	<20110219154924.2218c87c@notabene.brown>
	<AANLkTimpQ2=EM97ELX3z4c=Yf6gDp=Ekdn6m+ws6O8rm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_4sGrJF=vZ9FaG84/PpBlRX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimpQ2=EM97ELX3z4c=Yf6gDp=Ekdn6m+ws6O8rm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_4sGrJF=vZ9FaG84/PpBlRX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Feb 2011 04:55:32 +0000
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> > External bitmaps use 'BMAP' to find where the file lives on the device =
and
> > then writes directly to the device - not through the filesystem.
> >
> > So as long as there is no tail-packing to block migration happening it
> > should work fine.
> >
> > I haven't looked inside ext4 but I am fairly confident that external
> > bitmaps will work properly.
> >
> > NeilBrown
> >
> >
>=20
> Thanks, Neil. Are there any differences between using an internal or
> external bitmap? Also, does one need a bitmap at all when not planning
> to "mess" with the array? (does it provide any other purpose?)

I have successfully stored an external bitmap on XFS for a brief time.
However it proved difficult to ensure that the device storing the bitmap is
mounted, accessible and writable prior to boot scripts attempting to run th=
e md
arrays, so since then I just switched to an internal bitmap. The negative
performance it had can be minimized to almost zero by using a larger bitmap
chunk size.

--=20
With respect,
Roman

--Sig_/_4sGrJF=vZ9FaG84/PpBlRX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1ftC0ACgkQTLKSvz+PZwiZ+wCfU4oC+xYm31Osba5/vZ2Zg2UW
9DgAnRTSKdAXcawOkCvQs0xd7kqHUK6v
=Q+PW
-----END PGP SIGNATURE-----

--Sig_/_4sGrJF=vZ9FaG84/PpBlRX--
