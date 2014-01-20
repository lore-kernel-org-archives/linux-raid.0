From: NeilBrown <neilb@suse.de>
Subject: Re: MDADM 3.3 broken?
Date: Mon, 20 Jan 2014 15:34:21 +1100
Message-ID: <20140120153421.456f864f@notabene.brown>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
	<20131120114833.695fc9d4@notabene.brown>
	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
	<20131120133016.7de2d400@notabene.brown>
	<528E710F.1050901@arcor.de>
	<CAGRSmLtfL+Pzcy0CdfvUpcX3Z90-wEVTg46Q2iFRbJsxuSeyBQ@mail.gmail.com>
	<5293C789.3020703@arcor.de>
	<CAGRSmLsHSwELK_jd=PEckDpSBVCfrt9cHBvG_cH9esMYtLu5Jg@mail.gmail.com>
	<529674CB.5040808@arcor.de>
	<CAGRSmLsOBr2GdSD5wa9K_2cKYqaE95SGMbfHJ-BsjDnEfk72cw@mail.gmail.com>
	<CAGRSmLvUrKT8zArpJsFrA=X9KZ7iMyqOWvyeaRBcQ3h0dcGU6Q@mail.gmail.com>
	<20131207141648.069eb003@notabene.brown>
	<CAGRSmLugnbB=_xTOPYnzTBvrOPZoHi8oSzs53-_cdBgttb7VXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wPY7NNdbuHf9fhc3f1hTka6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLugnbB=_xTOPYnzTBvrOPZoHi8oSzs53-_cdBgttb7VXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/wPY7NNdbuHf9fhc3f1hTka6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Dec 2013 13:01:50 -0800 "David F." <df7729@gmail.com> wrote:

> Hi,
>=20
> Just wondering if this gave you guys everything you needed to figure
> out the issue?

I had everything but time.  I've now made the time and have the fix (I hope=
).

Please try the current HEAD of git://neil.brown.name/mdadm/
The important patch is below.

>=20
> Also, any idea on when 3.4 may be out with the various fixes?

I hope to release 3.3.1 some time in February.  Based on past experience it
should be out before Easter, but no promises.

NeilBrown

=46rom f0e876ce03a63f150bb87b2734c139bc8bb285b2 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 20 Jan 2014 15:27:29 +1100
Subject: [PATCH] DDF: fix detection of failed devices during assembly.

When we call "getinfo_super", we report the working/failed status
of the particular device, and also (via the 'map') the working/failed
status of every other device that this metadata is aware of.

It is important that the way we calculate "working or failed" is
consistent.
As it is, getinfo_super_ddf() will report a spare as "working", but
every other device will see it as "failed", which leads to failure to
assemble arrays with spares.

For getinfo_super_ddf (i.e. for the container), a device is assumed
"working" unless flagged as DDF_Failed.
For getinfo_super_ddf_bvd (for a member array), a device is assumed
"failed" unless DDF_Online is set, and DDF_Failed is not set.

Reported-by: "David F." <df7729@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-ddf.c b/super-ddf.c
index d526d8ad3da9..4242af86fea9 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1913,6 +1913,7 @@ static void getinfo_super_ddf(struct supertype *st, s=
truct mdinfo *info, char *m
 	info->disk.major =3D 0;
 	info->disk.minor =3D 0;
 	if (ddf->dlist) {
+		struct phys_disk_entry *pde =3D NULL;
 		info->disk.number =3D be32_to_cpu(ddf->dlist->disk.refnum);
 		info->disk.raid_disk =3D find_phys(ddf, ddf->dlist->disk.refnum);
=20
@@ -1920,12 +1921,19 @@ static void getinfo_super_ddf(struct supertype *st,=
 struct mdinfo *info, char *m
 						  entries[info->disk.raid_disk].
 						  config_size);
 		info->component_size =3D ddf->dlist->size - info->data_offset;
+		if (info->disk.raid_disk >=3D 0)
+			pde =3D ddf->phys->entries + info->disk.raid_disk;
+		if (pde &&
+		    !(be16_to_cpu(pde->state) & DDF_Failed))
+			info->disk.state =3D (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
+		else
+			info->disk.state =3D 1 << MD_DISK_FAULTY;
 	} else {
 		info->disk.number =3D -1;
 		info->disk.raid_disk =3D -1;
 //		info->disk.raid_disk =3D find refnum in the table and use index;
+		info->disk.state =3D (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
 	}
-	info->disk.state =3D (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
=20
 	info->recovery_start =3D MaxSector;
 	info->reshape_active =3D 0;
@@ -1943,8 +1951,6 @@ static void getinfo_super_ddf(struct supertype *st, s=
truct mdinfo *info, char *m
 		int i;
 		for (i =3D 0 ; i < map_disks; i++) {
 			if (i < info->array.raid_disks &&
-			    (be16_to_cpu(ddf->phys->entries[i].state)
-			     & DDF_Online) &&
 			    !(be16_to_cpu(ddf->phys->entries[i].state)
 			      & DDF_Failed))
 				map[i] =3D 1;
@@ -2017,7 +2023,11 @@ static void getinfo_super_ddf_bvd(struct supertype *=
st, struct mdinfo *info, cha
 		info->disk.raid_disk =3D cd + conf->sec_elmnt_seq
 			* be16_to_cpu(conf->prim_elmnt_count);
 		info->disk.number =3D dl->pdnum;
-		info->disk.state =3D (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
+		info->disk.state =3D 0;
+		if (info->disk.number >=3D 0 &&
+		    (be16_to_cpu(ddf->phys->entries[info->disk.number].state) & DDF_Onli=
ne) &&
+		    !(be16_to_cpu(ddf->phys->entries[info->disk.number].state) & DDF_Fai=
led))
+			info->disk.state =3D (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
 	}
=20
 	info->container_member =3D ddf->currentconf->vcnum;

--Sig_/wPY7NNdbuHf9fhc3f1hTka6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtynTTnsnt1WYoG5AQKGxg/+OLDsS6+Cx+XFvlX9gnREuXEIEi31bY8w
UZXlif4as6AZJ2al7Qor+wgZmZ3Bv8c9x0OjhGZxnuU5ULCZlCjDY6ugHQBqD2SD
orFku4B7kEcDgZFOMuUOxdTnxX2kXolRuPYbbw4zsSakI+O5fAvHyNuDMnfb2755
m/kqH3GercqNCmC1ecEAfa5jpf/S9HO48sMrPjQo4OMvdqb5PzhvE8rB36KGGEda
E63pq+k3qdG2T+cH23CMQiCGJBopihuS0lFzRziAt5L1OhWGi6VRycqkKC50nrsJ
IAG/wYMricN2hxehRh6RwDU48yugXMLhwj9C1RKpZ8lYyvVA0sAYQWFluIB+XGYZ
caQtSJUtRfq6iSmL3C0AHGwTiu1IY43m+LubV364k+F8Yx+wKkZOsp0HWdWPli/D
SAs6OBuXz0GHSGiEMqfTrczT9Zp5lQY/uM6ayoyFk3LDROhylXv0s6gd1BSRu913
W8epUVWG9pIt+q2GyrPISXK5JgNU4hDVaOXJap5BYvv1Rkm8oJ+uUno5Fw5ma6dA
c13oBq6EHEQ4b64BMIxYMs8TFZa4I5Dzos5p10HjdieWTjTCPo0aH7a9D1W2HGO9
E8oyW8Hl42z9KjyDoarJUOna7Kkk/EGB7Xg37qBPvv8sJ8Yll5aVTgXWmsNtqZMx
lkL7bS0oLpU=
=1UFJ
-----END PGP SIGNATURE-----

--Sig_/wPY7NNdbuHf9fhc3f1hTka6--
