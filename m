From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH 2/2] shorten remove rules
Date: Sun,  4 Sep 2011 14:42:44 +0200
Message-ID: <1315140164-6991-3-git-send-email-soltys@ziu.info>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This implicitly adds ddf containers to remove rules.

Signed-off-by: Michal Soltys <soltys@ziu.info>
---
 udev-md-raid.rules |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index 02172de..56201f2 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -3,10 +3,8 @@
 SUBSYSTEM!="block", GOTO="md_end"
 
 # handle potential components of arrays
-ENV{ID_FS_TYPE}=="linux_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=="linux_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=="isw_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=="isw_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
+ENV{ID_FS_TYPE}=="*_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
+ENV{ID_FS_TYPE}=="*_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
 
 # handle md arrays
 ACTION!="add|change", GOTO="md_end"
-- 
1.7.5.3

