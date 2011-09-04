From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH 1/2] udev rules: don't incrementally autoassemble everything
Date: Sun,  4 Sep 2011 14:42:43 +0200
Message-ID: <1315140164-6991-2-git-send-email-soltys@ziu.info>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315140164-6991-1-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All native and imsm arrays were autoassembled unconditionally (excluding
forgotten ddf containers).

This caused few issues:

- mdadm.conf configuration irrelevant - container or not - everything
  was assembled as soon as any component device was found during the boot

- problems with any 65-md-inc* rules often present, that also allow
  more fine-grained control - e.g. dracut's ones allow incremental assembly
  limited to certain uuids

Signed-off-by: Michal Soltys <soltys@ziu.info>
---
 udev-md-raid.rules |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index c2105bc..02172de 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -5,10 +5,8 @@ SUBSYSTEM!="block", GOTO="md_end"
 # handle potential components of arrays
 ENV{ID_FS_TYPE}=="linux_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
 ENV{ID_FS_TYPE}=="linux_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=="linux_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
 ENV{ID_FS_TYPE}=="isw_raid_member", ENV{ID_PATH}!="", ACTION=="remove", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
 ENV{ID_FS_TYPE}=="isw_raid_member", ENV{ID_PATH}=="", ACTION=="remove", RUN+="/sbin/mdadm -If $name"
-ENV{ID_FS_TYPE}=="isw_raid_member", ACTION=="add", RUN+="/sbin/mdadm --incremental $env{DEVNAME}"
 
 # handle md arrays
 ACTION!="add|change", GOTO="md_end"
-- 
1.7.5.3

