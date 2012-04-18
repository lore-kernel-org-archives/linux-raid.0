From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 00/24] Allow bitmaps to be resized.
Date: Wed, 18 Apr 2012 13:35:05 +1000
Message-ID: <20120418133505.7350f98a@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
	<CA+res+S-pvi11i_JH=O2dDGMc3n2wErwpMaWoW3KKFsAHVMN3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kPA0ujxWaw05UocsuR/jsiw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+S-pvi11i_JH=O2dDGMc3n2wErwpMaWoW3KKFsAHVMN3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kPA0ujxWaw05UocsuR/jsiw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 10:07:37 +0800 Jack Wang <jack.wang.usish@gmail.com>
wrote:

> Dear Neil,
>=20
> Thanks for your good works.
> One query about current grow supporting  status:
>=20
> as the raid wiki show : the RAID level 1/4/5/6 array can be grown . In
> my test I can grow raid 1 add disk or remove disk through mdadm grow,
> but change level from 1 to 4 or 5 will fail. the simaliar command work
> for change level between 4/5/6, change 1 to 10 fail too.
>=20
> My kernel version is 3.2.15. mdadm version 3.2.3.

You can definitely change from RAID1 to RAID5 and I think to RAID4.
But you are right that you cannot change RAID1 to RAID10 yet.  That should =
be
easy enough to add, and now that RAID10 can be reshaped, it would make sens=
e.

NeilBrown


--Sig_/kPA0ujxWaw05UocsuR/jsiw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT442aTnsnt1WYoG5AQLF/w//eRXy44ANo4Shxsk9YtbFk5iNKxZUGfiJ
Kzs8a2DdLINoF6UT5iRFgBKxKJPYEqCojyY9aNElpnCxDDkbLzGf2GiKkBK2faTu
y7CONzBeLdGdi2fPiKEj+lUNmN1ens1JCQ+gCxGuWLl8navrdSeOg2lR+Gav9sGv
XFNxakpUcDlmqm3l8hU7FOTd6R0nmHMxshKppQxoMz3QXq1EmoqhmcqRaqz6SBvk
KS1ocuuZnEmLqvvZFo/RmSTNBCTjAS6efW7yTpoM2oQQ0ixc6jxj69dxC/oiFaiY
POKFBK71kdv2pBkHLDMKOD5grJaZrZqNx57Xt8/R2YZ05j6iKEDi7yWLYDKPMQoW
JpZu12y8R7fgociPhFOzoHBROy+NvGl4d68OkSrjcsvTSoRkt+/+r3mR84YcWCpE
/y4kMx2fiWExcGf3+YK1rplxON2kZTrwon1em9rtySf3FTcrMtMhZKbFOQiB/R+U
8RjhBDJ0qIa0wC3iDUvgSTLAw5FZbLfg4HM/O9IJcPWuyL1oRD1b0FYHSthjIbmu
4sbF7EogYtanaKIl5UmgsP44TwMmRs1SE6a0js7s4niUyjVQxeoMLhS7jzh+UFYf
4xL+ICj79oWnkEpPIRF7BuH+10dIjno9J016Ik+afec1NqZxNK4H6PLPZHM2doPI
BARpeTmw57o=
=w/PG
-----END PGP SIGNATURE-----

--Sig_/kPA0ujxWaw05UocsuR/jsiw--
