From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Modify read error handle for RAID-4,5,6.
Date: Thu, 28 Jun 2012 10:04:04 +1000
Message-ID: <20120628100404.7fa60770@notabene.brown>
References: <201205261052422815923@gmail.com>
	<20120627143228.21ee4baa@notabene.brown>
	<201206271403526562112@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qIpg2xWLDEbpEZzH9jMSdza"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206271403526562112@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/qIpg2xWLDEbpEZzH9jMSdza
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jun 2012 14:03:55 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On 2012-06-27 12:32 NeilBrown <neilb@suse.de> Wrote:
> >On Sat, 26 May 2012 10:52:50 +0800 "majianpeng" <majianpeng@gmail.com> w=
rote:
> >
> >> When RAID-4,5,6 degraded and met read-error, it will eject the rdev.An=
d then
> >> the RAID will fail and lost data.Because the function of set-badsector=
,when=20
> >> this occur,it will set-badsector,not ejecting the rdev.
> >> When RAID-4,5,6 met read-error, it will re-write if RAID was not degra=
de.But if=20
> >> re-write error,it will eject the rdev and RAID will degrade and it wil=
l take too
> >> long time for recoverying.So I add judgement for controling how may re=
-write-error
> >> can eject the rdev.
> >>=20
> >> I do those for flexible controling the read-error for different situat=
ion.
> >> =09
> >
> >Thanks.
> >
> >>=20
> >> majianpeng (2):
> >>   md/raid456: When readed error and raid was degraded,it try to
> >>     set badsector, not ejecting the rdev.
> >
> >I've applied this one.  I also added 'set_bad =3D 1' in the case where
> >the re-write failed.
> >
> >>   md/raid456:Add interface for contorling eject rdev when re-write
> >>     failed.
> >
> >I haven't applied this.  I'm not entirely sure what the point of counting
> >the errors was, but I don't think it is necessary.
> Using raid456,the first object is to protect data.But in some situation, =
the user
> can endure lost some data instead of raid degraed or failed.
> After introduce the badblocks, I think md-driver should do flexible contr=
oling for
> error.The controling can control by different user for different requirme=
nt.

I cannot see the point of that control though.

Sure you *always* want to record a bad block if possible, if the alternative
is ejecting the whole device?
I don't see where the choice would be between "lost data" or "degraded arra=
y".

Maybe if the failing device caused large delays then you want to eject it
soon rather than struggling on with it.  However my belief is that if you
don't want long delays, then you should tell the device to fail rather than
impose long delays.  It is not something that md should care about.

So: still a little confused.

NeilBrown

--Sig_/qIpg2xWLDEbpEZzH9jMSdza
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+ufdDnsnt1WYoG5AQLBtw//ZXvGBjOhXwEKyHQxY6fKYimvvPP/Nmau
HvRLKP7Dk6q1zwxCBl7p4ib5dKdn6gNdnLeaV7amJcEes5yVCIP+e0L55DXckRis
xe3e3GNPDhUXC4ljveKdhkt9dLgfUuq+EQJi4gixDRgDHV7U+7m8ov2d05Z3WcpV
bY1dzKRbDTPH3mY6jaaGh/gX3gC2JT9ao1reea9quQFK3v5BbOOmIB+ZK4yRKoTb
DKln5byuLGGdIXDOWYQaP0i01CarlvETJaKW/biFuSwGR0x2KNT4VOVlyvySWEUs
jqM7KANv1gdVVLdInqx8KNIpVIUsnsSUhSdG5uyMhPoW6Ws4apKMK1eak3BrOFs8
AfWXzmpLCBtFwE8r9kjbftlKVy2mUSLPp+wePzs17qzEx5PnOgq1+ju60Cod37IN
RJiT9JOf+d6gcvdo0FbxhP64hTrax1sneMbXLt8FlrBomgZbuhxQMAIiA2zxuS+M
BYi6fTlIhDjjrlyXoj+omdMkg2vWZUekPMKwsVZL2It+YloxEPkSLUoFy+YuYOba
xh28jtr87A+Av7jVdjUmd/0HHIVHDzTrRTSnp8kPKYHL6mC8TEIPEpU4f4rtqFqb
lj18GLp+l87ZJVzeFM0p/8gVJwuG6XJXoCUFufsQ0Y0LceWKYZIHsokYpSD5x/KL
KoP2+fR0TEI=
=2r92
-----END PGP SIGNATURE-----

--Sig_/qIpg2xWLDEbpEZzH9jMSdza--
