From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH] udev rules: add ddf, shorten checks, use $tempnode
Date: Tue,  6 Sep 2011 23:39:13 +0200
Message-ID: <1315345153-1673-2-git-send-email-soltys@ziu.info>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
 <1315345153-1673-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315345153-1673-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch adjusts few minor details:

- add ddf to incremental assembly/removal
- shorten the rules, with initial test for supported types
- when accessing the device, use $tempnode
- few more comments

Signed-off-by: Michal Soltys <soltys@ziu.info>
---
 udev-md-raid.rules |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index c2105bc..f564f70 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -2,13 +2,19 @@
 
 SUBSYSTEM!="block", GOTO="md_end"
 
-# handle potential components of arrays
-ENV{ID_FS_TYPE}=="linux_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=="linux_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
-ENV{ID_FS_TYPE}=="isw_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=="isw_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
+# handle potential components of arrays (the ones supported by md)
+ENV{ID_FS_TYPE}=="ddf_raid_member|isw_raid_member|linux_raid_member", GOTO="md_inc"
+GOTO="md_inc_skip"
+
+LABEL="md_inc"
+
+# remember you can limit what gets auto/incrementally assembled by
+# mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
+ACTION=="add", RUN+="/sbin/mdadm --incremental $tempnode"
+ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
+ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="/sbin/mdadm -If $name"
+
+LABEL="md_inc_skip"
 
 # handle md arrays
 ACTION!="add|change", GOTO="md_end"
-- 
1.7.5.3

