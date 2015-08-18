From: =?UTF-8?q?Thomas=20B=C3=A4chler?= <thomas@archlinux.org>
Subject: [PATCH 2/2] udev: Work around race condition on array activation
Date: Tue, 18 Aug 2015 13:51:33 +0200
Message-ID: <1439898693-936-3-git-send-email-thomas@archlinux.org>
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

When an array is activated, it is possible for the md/array_state property to be "clean",
while the array is not accessible. This leads to a situation where systemd is told to
activate the block device unit while it is not ready yet.

This causes a race condition in combination with the LVM2 udev rules: Since ID_FS_TYPE is not
set yet, LVM2 does not look at the device. When a change event occurs later, ID_FS_TYPE is set
to LVM2_member and LVM2 sets SYSTEMD_WANTS to call a service to activate the LVM volume.
However, systemd has already activated the device at that time and the change to SYSTEMD_WANTS
is ignored.

To solve this, in addition to checking md/array_state, also check the size property: If size
is 0, the array is not ready and should not be treated as such.
---
 udev-md-raid-arrays.rules | 1 +
 1 file changed, 1 insertion(+)

diff --git a/udev-md-raid-arrays.rules b/udev-md-raid-arrays.rules
index 90d1aa5..08f3cad 100644
--- a/udev-md-raid-arrays.rules
+++ b/udev-md-raid-arrays.rules
@@ -15,6 +15,7 @@ ENV{DEVTYPE}=="partition", GOTO="md_ignore_state"
 ATTR{md/metadata_version}=="external:[A-Za-z]*", ATTR{md/array_state}=="inactive", GOTO="md_ignore_state"
 TEST!="md/array_state", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 ATTR{md/array_state}=="|clear|inactive", ENV{SYSTEMD_READY}="0", GOTO="md_end"
+ATTR{size}=="0", ENV{SYSTEMD_READY}="0", GOTO="md_end"
 LABEL="md_ignore_state"
 
 ENV{SYSTEMD_READY}="1"
-- 
2.5.0
