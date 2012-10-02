From: NeilBrown <neilb@suse.de>
Subject: Re: MD RAID Bug 7/15/12
Date: Tue, 2 Oct 2012 15:07:40 +1000
Message-ID: <20121002150740.717a9448@notabene.brown>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com>
	<20121001130242.745b7ca3@notabene.brown>
	<42BA87F6-C5A3-4321-A4C7-0DCF0A9DF79D@rightthisminute.com>
	<20121002114920.1029bed7@notabene.brown>
	<0B674309-5CBC-4C36-983F-AB75D9C2BDDB@rightthisminute.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q3GRbmtqIavjImWoj06h7GW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0B674309-5CBC-4C36-983F-AB75D9C2BDDB@rightthisminute.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Munoz <mark.munoz@rightthisminute.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Q3GRbmtqIavjImWoj06h7GW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Oct 2012 19:33:50 -0700 Mark Munoz <mark.munoz@rightthisminute.co=
m>
wrote:


> So I am now thinking that during my shutdown this weekend the device /dev=
/md0 as part of the array /dev/md2 was affected by the bug as well as 18 of=
 the 19 devices contained inside of /devm/md1

Yes, I agree, so:

> >>=20
> >> sudo mdadm --create --assume-clean /dev/md2 --level=3D0 --chunk=3D64 -=
-metadata=3D1.2 --raid-devices=3D2 /dev/md0 /dev/md1

This is the correct thing to do.

NeilBrown



--Sig_/Q3GRbmtqIavjImWoj06h7GW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGp2nDnsnt1WYoG5AQJvvw/+KwpxUgAmV6TJ+t2oRYtHI8cfCy1zt88s
zby/Y7EvnouPqiA5t32P9eh/DljGggm4h6aHiAkHRfVRQYhZyTINrWd7CS0bgCx0
ThtkGYyPEyuclayRKnTRzr9pdqv8HQxsYKh/wyb05zpvXTYkIKFpas52kBYPYi/H
SSuA2v5TCvcdlc+pUdg5Y4NCC/3UqE3iXkXVLKTtRSzYo27E13iBeidlqcAULTV6
mcV1rVM5Yzk3lhqnODwo5ALlXVIHmz+JHg31naxeBgGuyp/d4/Au6bDKPKSE6DNS
Gi4QANa6TXfOhxpXgAmi0MfDkhgtrT/ViSFORpLFtBqp/vOQJoIl5P4QVrb0oy5x
/UyhzCsd7waDIUPnG3EWIjVLM17IP7N4TqwuBxjs3ho45FaHwYK+eZvapP9vBYXD
Igi/4OgdfgdsHHnj7+b4qhTL+8DuMoBBfdFRsiqiBgfX8oPPu9cifeVGzgSDttXM
nn+InOsdoCb7oumjV0CTa+XF/YuogS7lPEtvqoTRTYsj4oBgG4EavRYNDCX2RLaj
BNp7A3FATd4A9irB1BomFqsCPdTTsQPfaFgn+RP2Ax6rzZd/Uz9NbeNSV2ooKf9S
FZ+rbV57topHUDBFzI5A0k1G6/esi46IAx3BRGG8lx8lwaNJIMOaqAovqubffj/T
Z+bwwXOp2U4=
=JFKR
-----END PGP SIGNATURE-----

--Sig_/Q3GRbmtqIavjImWoj06h7GW--
