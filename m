From: Dave Reisner <dreisner@archlinux.org>
Subject: [PATCH] mdadm: autodetect being run in an initramfs
Date: Thu, 27 Sep 2012 10:41:03 -0400
Message-ID: <1348756863-21081-1-git-send-email-dreisner@archlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: teg@jklm.no, dreisner@archlinux.org
List-Id: linux-raid.ids

Key off of the existance of /etc/initrd-release as an indicator that
mdadm is running in early userspace and set the __offroot flag. This
allows the same udev-based assembly rules to be valid both off and on
root and, moreover, will propagate to mdmon, should it need to be
started.

Signed-off-by: Dave Reisner <dreisner@archlinux.org>
---
 mdadm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index 4c7c5ea..557e00b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1106,6 +1106,11 @@ int main(int argc, char *argv[])
 		exit(0);
 	}
 
+	/* auto-detect being on an initramfs
+	 * http://www.freedesktop.org/wiki/Software/systemd/InitrdInterface */
+	if (access("/etc/initrd-release", F_OK) == 0)
+		__offroot = 1;
+
 	if (!mode && devs_found) {
 		mode = MISC;
 		devmode = 'Q';
-- 
1.7.12.1

