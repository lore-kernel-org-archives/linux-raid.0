From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Tue, 20 Dec 2011 10:38:45 +1100
Message-ID: <20111220103845.0b9ae8e2@notabene.brown>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
	<CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
	<20111215150314.7e5694c7@notabene.brown>
	<CABE8wwvfzxM1e2S7XOotMHWT40JF6sbRH3mW688dpuWmwoCtZQ@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A060EEA@IRSMSX101.ger.corp.intel.com>
	<CABE8wwu1RNQsHPHZ7xWNsQ6-qym4LHQjsnf+LT8qrZpdHkQ-Hg@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A061319@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uKRP/zNqKJzmDcxpaZ.4I=Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A061319@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/uKRP/zNqKJzmDcxpaZ.4I=Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Dec 2011 08:32:07 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:


> I've checked, you are right. OROM check will resolve problem.
> Do you post your patch or I should do it? We are short of time regarding =
Neil's plans about v3.2.3
>=20
>

I've created a commit myself.  See below.

Thanks,
NeilBrown

=46rom 5fe62b9455b6b43f050f3a52610ce1048a44623c Mon Sep 17 00:00:00 2001
From: "Williams, Dan J" <dan.j.williams@intel.com>
Date: Wed, 14 Dec 2011 18:21:07 -0800
Subject: [PATCH] imsm: FIX: UT '08imsm-overlap' fails

Make test for all sub arrays having the same number of devices
dependant on the option ROM requirements being checked.
08imsm-overlap disables the OROM check but then fails because this
test causes it to.

Reported-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-intel.c b/super-intel.c
index 9074485..0e77537 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5314,12 +5314,6 @@ static int validate_geometry_imsm_volume(struct supe=
rtype *st, int level,
=20
 	mpb =3D super->anchor;
=20
-	if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddisks) {
-		fprintf(stderr, Name ": the option-rom requires all "
-			"member disks to be a member of all volumes.\n");
-		return 0;
-	}
-
 	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, =
verbose)) {
 		fprintf(stderr, Name ": RAID gemetry validation failed. "
 			"Cannot proceed with the action(s).\n");
@@ -5398,6 +5392,11 @@ static int validate_geometry_imsm_volume(struct supe=
rtype *st, int level,
 		fprintf(stderr, Name ": The option-rom requires all member"
 			" disks to be a member of all volumes\n");
 		return 0;
+	} else if (super->orom && mpb->num_raid_devs > 0 &&
+		   mpb->num_disks !=3D raiddisks) {
+		fprintf(stderr, Name ": The option-rom requires all member"
+			" disks to be a member of all volumes\n");
+		return 0;
 	}
=20
 	/* retrieve the largest free space block */

--Sig_/uKRP/zNqKJzmDcxpaZ.4I=Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTu/LBTnsnt1WYoG5AQLsnQ/+NHIOewTDudFiiUbjg+0mkojjHgSv5VWd
oJSt5DUEoyXO0y75Ql9xvt/EYLeE9n0u5xpzr2iOOitR1YWKds+eTaLtFNabOgvm
sfPdovLz1DsoYuTEYlGpB2DQRFjxG8YmGQjTUyPZ3V4Boj6phw3MEf01gA1e3uDg
mNaRb2ov9c5k9q5emoBZX8gCwKc/fKZsJ5qRPnfzQ/qj8I6s/YFuYBH8G1TAHgWY
hLhquAGb/op1NTRsHLmIOuwvQgUbUFAHhx/xSMKSenY834xca85HQdphjOaWVOov
6iVotjjUE0uMRPWZsYqWpIoKzcJooh/Z1+Cs2/G16vbjc4XDAhC1w70xWzCwlXtC
+juGJ9wzHVobI5w71vP0cNAubwXuE3GTstRuLvHgwU8kULfFWaT4ykdTQAe0Le9q
OVlqn2deCqpv9y+8flLxX4qK3y8CJanqiNWCUt8Y8QcM28RLFnZGxAo4N66apyOf
7q++mtQgeai+lqvVPfVAwUw/OfH0JYEIgOx9JQ1Leh1ITXrusOrUsc6GsGdGf6tv
KptBTvMdwEMnXHvRNMSdIKJzNVncbk5XeMDjSftQ3vPcEYOhEEOkYQyFDvUZR2gL
5FO11BmL9JhzgpaI4ZcuE0ZLTxKaSY62JCkPOb4m14fIEHuXtjuRvx7CLPT30EwB
oaoYYDIhPVg=
=HkYj
-----END PGP SIGNATURE-----

--Sig_/uKRP/zNqKJzmDcxpaZ.4I=Z--
