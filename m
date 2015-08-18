From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
Subject: [PATCH 1/2] udev: Set SYSTEMD_READY to 1 when the array becomes active
Date: Tue, 18 Aug 2015 13:51:32 +0200
Message-ID: <1439898693-936-2-git-send-email-thomas@archlinux.org>
References: <1439898693-936-1-git-send-email-thomas@archlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1439898693-936-1-git-send-email-thomas@archlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
List-Id: linux-raid.ids

In some cases, the rules set SYSTEMD_READY to 0 in order to tell systemd
to delay activation of the .device unit. It should also be set to 1 when
the array is ready.
---
 udev-md-raid-arrays.rules | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/udev-md-raid-arrays.rules b/udev-md-raid-arrays.rules
index c95ec7b..90d1aa5 100644
--- a/udev-md-raid-arrays.rules
+++ b/udev-md-raid-arrays.rules
@@ -17,6 +17,8 @@ TEST!="md/array_state", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 ATTR{md/array_state}=="|clear|inactive", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 LABEL="md_ignore_state"
 
+ENV{SYSTEMD_READY}="1"
+
 IMPORT{program}="BINDIR/mdadm --detail --export $devnode"
 ENV{DEVTYPE}=="disk", ENV{MD_NAME}=="?*", SYMLINK+="disk/by-id/md-name-$env{MD_NAME}", OPTIONS+="string_escape=replace"
 ENV{DEVTYPE}=="disk", ENV{MD_UUID}=="?*", SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}"
-- 
2.5.0
