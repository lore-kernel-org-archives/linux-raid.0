From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 02/17] Update of udev rules to support IMSM devices
Date: Fri, 29 Oct 2010 15:14:56 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FB5@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From b9b2b4d5eeedcfe3cc908fc72b3f097def2ff443 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 27 Oct 2010 16:21:17 +0200
Subject: [PATCH 02/17] Update of udev rules to support IMSM devices

ID_FS_TYPE for IMSM members is set to isw_raid_member, so they must also
be handled in udev.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 udev-md-raid.rules |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index a4a57ac..1d89833 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -5,6 +5,8 @@ SUBSYSTEM!="block", GOTO="md_end"
 # handle potential components of arrays
 ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
 ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
+ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
+ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
 
 # handle md arrays
 ACTION!="add|change", GOTO="md_end"
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

