From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 17/35] Removed uuid setting for imsm spares
Date: Mon, 16 Aug 2010 10:50:39 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9E4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 26f00c6c0b78edb782256d510c5b37bc1a12e05b Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Wed, 23 Jun 2010 12:10:15 +0100
Subject: [PATCH 17/35] Removed uuid setting for imsm spares

Setting UUID of a spare based on first array from config
that may belong to different domain can prevent assembly of that array.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 super-intel.c |   34 +---------------------------------
 1 files changed, 1 insertions(+), 33 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9551ad1..4dcc654 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1495,38 +1495,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	uuid_from_super_imsm(st, info->uuid);
 }
 
-/* check the config file to see if we can return a real uuid for this spare */
-static void fixup_container_spare_uuid(struct mdinfo *inf)
-{
-	struct mddev_ident_s *array_list;
-
-	if (inf->array.level != LEVEL_CONTAINER ||
-	    memcmp(inf->uuid, uuid_match_any, sizeof(int[4])) != 0)
-		return;
-
-	array_list = conf_get_ident(NULL);
-
-	for (; array_list; array_list = array_list->next) {
-		if (array_list->uuid_set) {
-			struct supertype *_sst; /* spare supertype */
-			struct supertype *_cst; /* container supertype */
-
-			_cst = array_list->st;
-			if (_cst)
-				_sst = _cst->ss->match_metadata_desc(inf->text_version);
-			else
-				_sst = NULL;
-
-			if (_sst) {
-				memcpy(inf->uuid, array_list->uuid, sizeof(int[4]));
-				free(_sst);
-				break;
-			}
-		}
-	}
-}
-
-
 static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev, int failed);
 static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev);
 
@@ -1643,7 +1611,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 		uuid_from_super_imsm(st, info->uuid);
 	else {
 		memcpy(info->uuid, uuid_match_any, sizeof(int[4]));
-		fixup_container_spare_uuid(info);
+		/* must be uuid_match_any for spares to assemble */
 	}
 }
 
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

