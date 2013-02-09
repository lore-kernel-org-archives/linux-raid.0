From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
Subject: [PATCH 1/2] Modernize udev rules
Date: Sat,  9 Feb 2013 18:48:38 +0100
Message-ID: <1360432119-15910-1-git-send-email-thomas@archlinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
List-Id: linux-raid.ids

* $tempnode is deprecated, use $devnode
* blkid -o udev output is deprecated, use IMPORT{builtin}="blkid" instead
---
 udev-md-raid.rules | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/udev-md-raid.rules b/udev-md-raid.rules
index cc7f5ef..ea97261 100644
--- a/udev-md-raid.rules
+++ b/udev-md-raid.rules
@@ -10,7 +10,7 @@ LABEL="md_inc"
 
 # remember you can limit what gets auto/incrementally assembled by
 # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
-ACTION=="add", RUN+="/sbin/mdadm --incremental $tempnode --offroot"
+ACTION=="add", RUN+="/sbin/mdadm --incremental $devnode --offroot"
 ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="/sbin/mdadm -If $name --path $env{ID_PATH}"
 ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="/sbin/mdadm -If $name"
 
@@ -31,7 +31,7 @@ TEST!="md/array_state", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 ATTR{md/array_state}=="|clear|inactive", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 LABEL="md_ignore_state"
 
-IMPORT{program}="/sbin/mdadm --detail --export $tempnode"
+IMPORT{program}="/sbin/mdadm --detail --export $devnode"
 ENV{DEVTYPE}=="disk", ENV{MD_NAME}=="?*", SYMLINK+="disk/by-id/md-name-$env{MD_NAME}", OPTIONS+="string_escape=replace"
 ENV{DEVTYPE}=="disk", ENV{MD_UUID}=="?*", SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}"
 ENV{DEVTYPE}=="disk", ENV{MD_DEVNAME}=="?*", SYMLINK+="md/$env{MD_DEVNAME}"
@@ -40,7 +40,7 @@ ENV{DEVTYPE}=="partition", ENV{MD_UUID}=="?*", SYMLINK+="disk/by-id/md-uuid-$env
 ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[^0-9]", SYMLINK+="md/$env{MD_DEVNAME}%n"
 ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[0-9]", SYMLINK+="md/$env{MD_DEVNAME}p%n"
 
-IMPORT{program}="/sbin/blkid -o udev -p $tempnode"
+IMPORT{builtin}="blkid"
 OPTIONS+="link_priority=100"
 OPTIONS+="watch"
 ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
-- 
1.8.1.3

