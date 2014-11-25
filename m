From: NeilBrown <neilb@suse.de>
Subject: Re: Is it possible to grow a (far) RAID 10?
Date: Wed, 26 Nov 2014 08:19:15 +1100
Message-ID: <20141126081915.58d7fa71@notabene.brown>
References: <54744AEE.10908@aei.mpg.de>
	<81fe7d20d731393c86a6ca557d71adaa@kruemel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cuBC/rN7l_lpgKVy=Z2sEQ/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <81fe7d20d731393c86a6ca557d71adaa@kruemel.org>
Sender: linux-raid-owner@vger.kernel.org
To: cvb@kruemel.org
Cc: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, linux RAID <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cuBC/rN7l_lpgKVy=Z2sEQ/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Nov 2014 12:01:58 +0100 cvb@kruemel.org wrote:

> Hi
>=20
> Am 2014-11-25 10:25, schrieb Carsten Aulbert:
> > Without much thinking, I would simply follow the wiki page, mark a
> > device as failed, remove it, repartition it, add it again, and wait
> > for sync to complete. Repeat for all 4 devices and finally --grow with
> > mdadm (followed by xfs resizing) - and of course, all online, while
> > machine is in flight.
>=20
> That is exactoy what I did with my RAID 10 a bit more than a year ago.=20
> It basically worked, but there was one caveat... some part (the=20
> ---grow?) which required a certain kernel version for which I had booted=
=20
> a live CD back then...
>=20
> The thing is, I can't exactly remember what the caveat was. And as I'm=20
> about to grow the RAID again (having replaced all hard drives already),=20
> I have been looking for the related mails in the archive of this list,=20
> but I can't seem to find them...
>=20
> So I guess we'll have to hope that Neil replies again.

I recommend creating some loop-back block devices and experimenting.

But I'm fairly sure that "far" RAID10 arrays cannot be reshaped at all.

NeilBrown

--Sig_/cuBC/rN7l_lpgKVy=Z2sEQ/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHTyUznsnt1WYoG5AQIlwBAAp4uQo8XqteGTGceU7WbSHdEWJe361PKT
K4MjbQIBiS+ke4JPR9IkA1oyrgMXjLqLdfLfs++kY2fuexcNcuXMNlIPkVV7y60Z
dpdcADGJCbuRvzcbA2BgGCSQJEAigTQvyEqGjN8lZblqz/VepfI7xANEx7okBWpX
1K4olJo9lCoKJxRLVZEKFWzR+4KbjY5YGkmO/xOnNfMdK07XyNenAIHGR0Mk70PV
GZpFM9Z5lKystBD6yxL3fy/H6ErlWpDdSeOemZaPtM1N+OxphdCbLknWKXJmWlFF
4aUYGx69SXJaaTDjZrVRmdY59AuCT5cTItXdGk0zmn6f67PEF/TiWyC7dEmGaGWZ
Sh2dpTp+Qrf6VEbC5Ok4QxnwsNvLXTFT95CUApQiq6ePa2e0125NjOdkGdzngm1D
5BQPv+sHd664FG1P5r+syLXBkiy5ecd3FLOqiTr6x13Xeywk/ha65HcTn0J2l7K7
6/GwyAwa7VoUCVX1x6jAZU6ePRdMb4NesUUN7Uap1IQub1T+IpqevSfgco/5U+Gu
0m+NZOi+ybA0tdY+a71XzDP/QAyjAr2KEQzxX805vB9+H/HDrDGoStazBhnKnNEp
xkazyoA3EthKODgIxq+3anAwG4ao+1dthJXeeEGJekQLtbQaiga/0cxqenFMyNbA
gYrxC/uJoRw=
=ikvM
-----END PGP SIGNATURE-----

--Sig_/cuBC/rN7l_lpgKVy=Z2sEQ/--
