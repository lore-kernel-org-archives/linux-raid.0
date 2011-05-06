From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 13:31:59 +0600
Message-ID: <20110506133159.30c66519@natsu>
References: <20110506071752.GA22063@www2.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2B=GTVJ._1xv_m7v=Fd7SW+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110506071752.GA22063@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?UTF-8?B?SsO4cm4=?= Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2B=GTVJ._1xv_m7v=Fd7SW+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 6 May 2011 09:17:52 +0200
Keld J=C3=B8rn Simonsen <keld@keldix.com> wrote:

> I would like linux MD raid10 functionality to be part of the Linux MD
> RAID1 module, and be called raid1. This is in accordance with the
> use of the RAID1 term as standadized by SNIA. In fact the RAID10-offset
> layout is an implementation of a SNIA RAID specification. The RAID10-near
> layout is an implementation of a simple RAID layout. And the RAID10-far
> layout is just another layout far a mirrored RAID.  So all these types
> could just be defined as different RAID1 layouts.

RAID1 is RAID1, RAID10 is RAID10.
RAID1 on 4 drives is very different from RAID10 on 4 drives.
Don't add confusion by trying to rename RAID10 to RAID1.

--=20
With respect,
Roman

--Sig_/2B=GTVJ._1xv_m7v=Fd7SW+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3Do+8ACgkQTLKSvz+PZwhlzACZAbZ47QeCx5LL7ZMuYyFyM9in
Nb4AoIvOTllopaX0EcwK3qRsRG2h0lrr
=s6/9
-----END PGP SIGNATURE-----

--Sig_/2B=GTVJ._1xv_m7v=Fd7SW+--
