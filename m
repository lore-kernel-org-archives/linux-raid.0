From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH] udev rules: use $tempnode, check for supported types, comments
Date: Thu,  8 Sep 2011 09:25:08 +0200
Message-ID: <1315466708-5431-2-git-send-email-soltys@ziu.info>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
 <1315466708-5431-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315466708-5431-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Few things adjusted in addition to
0f82fe603a42f37f1e2a6f826b4164811bf2d188:

- keep strict tests for supported types
- when accessing the device, use $tempnode
- few more comments

Signed-off-by: Michal Soltys <soltys@ziu.info>
---
 udev-md-raid.rules |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index e251ac5..f564f70 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -2,10 +2,19 @@
 
 SUBSYSTEM!="block", GOTO="md_end"
 
-# handle potential components of arrays
-ENV{ID_FS_TYPE}=="*_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=="*_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=="*_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
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

