From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 33/35] update udev rules to support --path parameter with
 remove action
Date: Mon, 16 Aug 2010 11:03:34 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA1F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 8f83e0b036cbbae47105e728c5bb30f504b73c74 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 14 Jul 2010 16:34:59 +0200
Subject: [PATCH 33/35] update udev rules to support --path parameter with remove action

in order to enable changes added in previous patches, udev needs
to pass <path-id> to mdadm. All "remove" actions of raid members has been
updated with --path <path-id>.
---
 udev-md-raid.rules |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index 712c5e5..05277c4 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -3,9 +3,9 @@
 SUBSYSTEM!="block", GOTO="md_end"
 
 # handle potential components of arrays
-ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
 ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm -I $tempnode"
-ENV{ID_FS_TYPE}=="isw_raid_member", ENV{rd_NO_MDIMSM}!="?*", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=="isw_raid_member", ENV{rd_NO_MDIMSM}!="?*", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
 ENV{ID_FS_TYPE}=="isw_raid_member", ENV{rd_NO_MDIMSM}!="?*", ACTION=="add", RUN+="/sbin/mdadm -I $tempnode"
 
 # handle md arrays
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

