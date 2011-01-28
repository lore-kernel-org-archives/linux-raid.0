From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 2/2] 11spare-migration: pass conditions for tests 9 and 12
 should be reversed
Date: Fri, 28 Jan 2011 16:48:33 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17701BDF1@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

From a134fc58a6af107a05304a574ad6346cba3fff46 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 27 Jan 2011 16:19:45 +0100
Subject: [PATCH 2/2] 11spare-migration: pass conditions for tests 9 and 12 should be reversed

Test 9: We do not block spare migration between different metadatas.
test 13: Migrated spare must belong the same domain as destination -
there is no additional condition for action.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 tests/11spare-migration |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/11spare-migration b/tests/11spare-migration
index 02d19fa..01693e4 100644
--- a/tests/11spare-migration
+++ b/tests/11spare-migration
@@ -232,7 +232,7 @@ tidyup
 
 test9()
 {
-dsc "Test 9: imsm and native 1.2 - spare should not be shared"
+dsc "Test 9: imsm and native 1.2 - spare should be shared"
 setupdevs 0 10 11 imsm
 setupdevs 1 8 9 1.2
 createconfig a
@@ -240,7 +240,7 @@ createconfig domain0 noplatform spare 8 9 10 11 12
 monitor 0 1
 mdadm -a /dev/$c1 $dev12
 mdadm --fail /dev/$v0 $dev10
-chksparemoved $c1 $c0 $dev12 n
+chksparemoved $c1 $c0 $dev12
 tidyup
 }
 
@@ -303,7 +303,7 @@ tidyup
 
 test13()
 {
-dsc "Test 13: Common domain, two containers, fail a disk in container, action is below spare, the spare should not be moved"
+dsc "Test 13: Common domain, two containers, fail a disk in container, action is below spare, the spare should be moved regadless of action"
 setupdevs 0 0 1 $platform
 setupdevs 1 4 5 $platform
 # same domain but different action on 4 5 6
@@ -313,7 +313,7 @@ createconfig domain-$platform $platform include 4 5 6
 monitor 0 1
 mdadm -a /dev/$c1 $dev6
 mdadm --fail /dev/$v0 $dev0
-chksparemoved $c1 $c0 $d6 n
+chksparemoved $c1 $c0 $d6
 tidyup
 }
 
-- 
1.6.4.2

