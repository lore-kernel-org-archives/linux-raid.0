From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm(IMSM): Unsupported attributes : 40000000
Date: Tue, 9 Aug 2011 08:51:17 +1000
Message-ID: <20110809085117.5d910aed@notabene.brown>
References: <CACHinyGxah6Utp+ed0WKH58BO8-sOn+QX9DPCy9QGNjuDde=eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACHinyGxah6Utp+ed0WKH58BO8-sOn+QX9DPCy9QGNjuDde=eQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Steinborn <thestonewell@googlemail.com>
Cc: linux-raid@vger.kernel.org, Adam Kwolek <adam.kwolek@intel.com>, Krzysztof Wojcik <krzysztof.wojcik@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Sat, 6 Aug 2011 20:55:47 +0200 Thomas Steinborn
<thestonewell@googlemail.com> wrote:

> Hi,
>=20
> after updating to mdadm 3.2.2 (by way of upgrading from Fedora 14 to
> 15) from 3.1.5 I am no longer able to boot my IMSM raid, which I was
> able to for the last 5 years or so.
>=20
> The errors I am getting are:
>=20
>   mdadm(IMSM): Unsupported attributes : 40000000
>   mdadm: IMSM metadata loading not allowed due to attributes incompat=
ibility.
>=20
> I tracked that down to the patch at
>=20
> http://www.spinics.net/lists/raid/msg34783.html
>=20
> According to that patch 40000000 means=A0#define MPB_ATTRIB_NEVER_USE
> __cpu_to_le32(0x40000000). Any advice why an unused but aparently set
> attribute should stop the raid to boot?
>=20
> For now I am up and running with 3.1.5 but would like to keep up with
> the latest mdadm if possible.
>=20
> Thanks
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the report.

It looks like we need something like the following.

Adam/Kryzysztof:  Is this patch reasonable?

Thanks,
NeilBrown





=46rom 418f9b368a1200370695527d22aba8c3606172c5 Mon Sep 17 00:00:00 200=
1
=46rom: NeilBrown <neilb@suse.de>
Date: Tue, 9 Aug 2011 08:49:34 +1000
Subject: [PATCH] IMSM: allow some array attribute bits to be ignored.

Some bits are not handled by mdadm, but their presence should not
cause failure.
In particular MPB_ATTRIB_NEVER_USE appears harmless.

Reported-by: Thomas Steinborn <thestonewell@googlemail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-intel.c b/super-intel.c
index dcab5f9..ddf4de9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -74,14 +74,17 @@
=20
 /* Define all supported attributes that have to be accepted by mdadm
  */
-#define MPB_ATTRIB_SUPPORTED		MPB_ATTRIB_CHECKSUM_VERIFY | \
+#define MPB_ATTRIB_SUPPORTED	       (MPB_ATTRIB_CHECKSUM_VERIFY | \
 					MPB_ATTRIB_2TB             | \
 					MPB_ATTRIB_2TB_DISK        | \
 					MPB_ATTRIB_RAID0           | \
 					MPB_ATTRIB_RAID1           | \
 					MPB_ATTRIB_RAID10          | \
 					MPB_ATTRIB_RAID5           | \
-					MPB_ATTRIB_EXP_STRIPE_SIZE
+					MPB_ATTRIB_EXP_STRIPE_SIZE)
+
+/* Define attributes that are unused but not harmful */
+#define MPB_ATTRIB_IGNORED		(MPB_ATTRIB_NEVER_USE)
=20
 #define MPB_SECTOR_CNT 2210
 #define IMSM_RESERVED_SECTORS 4096
@@ -1141,11 +1144,14 @@ void examine_migr_rec_imsm(struct intel_super *=
super)
 static int imsm_check_attributes(__u32 attributes)
 {
 	int ret_val =3D 1;
-	__u32 not_supported =3D (MPB_ATTRIB_SUPPORTED)^0xffffffff;
+	__u32 not_supported =3D MPB_ATTRIB_SUPPORTED^0xffffffff;
+
+	not_supported &=3D ~MPB_ATTRIB_IGNORED;
=20
 	not_supported &=3D attributes;
 	if (not_supported) {
-		fprintf(stderr, Name "(IMSM): Unsupported attributes : %x\n", not_su=
pported);
+		fprintf(stderr, Name "(IMSM): Unsupported attributes : %x\n",
+			(unsigned)__le32_to_cpu(not_supported));
 		if (not_supported & MPB_ATTRIB_CHECKSUM_VERIFY) {
 			dprintf("\t\tMPB_ATTRIB_CHECKSUM_VERIFY \n");
 			not_supported ^=3D MPB_ATTRIB_CHECKSUM_VERIFY;
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
