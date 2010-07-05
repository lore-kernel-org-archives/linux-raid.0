From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 18/33] Removed uuid setting for imsm spares
Date: Mon, 5 Jul 2010 11:47:26 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC409@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C37@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C37@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:33 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 18/33] Removed uuid setting for imsm spares

Setting UUID of a spare based on first array from config that may belon=
g to different domain can prevent assembly of that array.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
=A0super-intel.c |=A0=A0 34 +---------------------------------
=A01 files changed, 1 insertions(+), 33 deletions(-)

diff --git a/super-intel.c b/super-intel.c index 9551ad1..4dcc654 10064=
4
--- a/super-intel.c
+++ b/super-intel.c
@@ -1495,38 +1495,6 @@ static void getinfo_super_imsm_volume(struct sup=
ertype *st, struct mdinfo *info)
=A0=A0=A0=A0=A0 uuid_from_super_imsm(st, info->uuid);
=A0}
=A0
-/* check the config file to see if we can return a real uuid for this =
spare */ -static void fixup_container_spare_uuid(struct mdinfo *inf) -{
-=A0=A0=A0=A0 struct mddev_ident_s *array_list;
-
-=A0=A0=A0=A0 if (inf->array.level !=3D LEVEL_CONTAINER ||
-=A0=A0=A0=A0 =A0=A0=A0 memcmp(inf->uuid, uuid_match_any, sizeof(int[4]=
)) !=3D 0)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
-
-=A0=A0=A0=A0 array_list =3D conf_get_ident(NULL);
-
-=A0=A0=A0=A0 for (; array_list; array_list =3D array_list->next) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (array_list->uuid_set) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct supertype *_ss=
t; /* spare supertype */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct supertype *_cs=
t; /* container supertype */
-
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 _cst =3D array_list->=
st;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (_cst)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 _ss=
t =3D _cst->ss->match_metadata_desc(inf->text_version);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 _ss=
t =3D NULL;
-
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (_sst) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mem=
cpy(inf->uuid, array_list->uuid, sizeof(int[4]));
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fre=
e(_sst);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bre=
ak;
-=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0 }
-}
-
-
=A0static __u8 imsm_check_degraded(struct intel_super *super, struct im=
sm_dev *dev, int failed);=A0 static int imsm_count_failed(struct intel_=
super *super, struct imsm_dev *dev);
=A0
@@ -1643,7 +1611,7 @@ static void getinfo_super_imsm(struct supertype *=
st, struct mdinfo *info)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uuid_from_super_imsm(st, info->uuid);
=A0=A0=A0=A0=A0 else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memcpy(info->uuid, uuid_match_any, si=
zeof(int[4]));
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fixup_container_spare_uuid(info);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* must be uuid_match_any for spares to=
 assemble */
=A0=A0=A0=A0=A0 }
=A0}
=A0
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
