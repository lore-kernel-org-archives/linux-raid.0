From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: External bitmap, questions
Date: Sat, 19 Feb 2011 17:32:46 +0500
Message-ID: <20110219173246.72a6aaca@natsu>
References: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
	<20110219154924.2218c87c@notabene.brown>
	<AANLkTimpQ2=EM97ELX3z4c=Yf6gDp=Ekdn6m+ws6O8rm@mail.gmail.com>
	<20110219171437.3a6200e6@natsu>
	<AANLkTinyG9idKMethaqzAqvpTe30-UwhkJ=_BMzc39Tr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Cg2i4refBp7yCrXKsAx4aoP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinyG9idKMethaqzAqvpTe30-UwhkJ=_BMzc39Tr@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Cg2i4refBp7yCrXKsAx4aoP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Feb 2011 12:20:41 +0000
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> I ended up storing the bitmap on my root filesystem (ext4) for now.
> It's currently at the default size but I think I'll recreate it with
> 64MB size.

Thing is, the root filesystem is initially mounted read-only, after that
perhaps fsck is executed if needed, and only a bit later it is remounted
read-write. You need to check at which point in this process your distro's
boot scripts initialize md arrays, and whether or not you will end up trying
to do that with their bitmaps on a read-only FS.

--=20
With respect,
Roman

--Sig_/Cg2i4refBp7yCrXKsAx4aoP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1fuG8ACgkQTLKSvz+PZwjQgACggT2U9qN+J5eFsPFvxSKXm2k0
g9gAnRq5wmuM/CPL8+IxknIjypvNOA2l
=0TtO
-----END PGP SIGNATURE-----

--Sig_/Cg2i4refBp7yCrXKsAx4aoP--
