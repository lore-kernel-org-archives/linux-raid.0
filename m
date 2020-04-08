From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] udev: Ignore change event for imsm
Date: Wed,  8 Apr 2020 16:44:52 +0200
Message-ID: <20200408144452.19275-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When adding a device to a container mdadm has to close its file
descriptor before sysfs_add_disk(). This generates change event.
There is race possibility because metadata is already written and other
-I process can place drive differently. As a result device can be added
to two containers simultaneously.
From IMSM perspective there is no need to react for change event. IMSM
doesn't support stacked devices.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 udev-md-raid-assembly.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index 9f055ed0..d668cddd 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -23,7 +23,7 @@ IMPORT{cmdline}="nodmraid"
 ENV{nodmraid}=="?*", GOTO="md_inc_end"
 ENV{ID_FS_TYPE}=="ddf_raid_member", GOTO="md_inc"
 ENV{noiswmd}=="?*", GOTO="md_inc_end"
-ENV{ID_FS_TYPE}=="isw_raid_member", GOTO="md_inc"
+ENV{ID_FS_TYPE}=="isw_raid_member", ACTION!="change", GOTO="md_inc"
 GOTO="md_inc_end"
 
 LABEL="md_inc"
-- 
2.25.0
