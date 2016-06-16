From: Nikhil Kshirsagar <nkshirsa@redhat.com>
Subject: [PATCH] mdadm: protecting sys_name overflow
Date: Thu, 16 Jun 2016 09:29:03 +0530
Message-ID: <57622407.1050907@redhat.com>
Reply-To: nkshirsa@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000604060409090708090403"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000604060409090708090403
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

(Corrected indentation and code formatting, and re-posting this patch.)

Devices with names larger than 31 bytes will overflow the sys_name array.

This patch enables mdadm to fail and log a message if a long device name
is going to cause a buffer overflow.

Signed-off-by: Nikhil Kshirsagar <nkshirsa@redhat.com>

--------------000604060409090708090403
Content-Type: text/x-patch;
 name="0001-Protecting-overflow-of-sys_name.-If-a-long-device-na.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Protecting-overflow-of-sys_name.-If-a-long-device-na.pa";
 filename*1="tch"

From 8198c463c3199c8207dd16cefac23197b16d8a09 Mon Sep 17 00:00:00 2001
From: Nikhil Kshirsagar <nkshirsa@redhat.com>
Date: Thu, 16 Jun 2016 09:25:07 +0530
Subject: [PATCH] Protecting overflow of sys_name. If a long device name is
 going to cause a buffer overflow, we fail with a log message.

---
 sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sysfs.c b/sysfs.c
index 8379ca8..d346fe9 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -283,6 +283,13 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			}
 
 		}
+
+		/*  strlen computes length of string *not* including the terminating null character. */
+		if (strlen(de->d_name) >= sizeof(dev->sys_name)) {
+			pr_err("Device name %s larger than currently supported by mdadm\n",de->d_name);
+			free(dev);
+			goto abort;
+		}
 		strcpy(dev->sys_name, de->d_name);
 		dev->disk.raid_disk = strtoul(buf, &ep, 10);
 		if (*ep) dev->disk.raid_disk = -1;
-- 
1.8.3.1


--------------000604060409090708090403--
