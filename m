From: Nikhil Kshirsagar <nkshirsa@redhat.com>
Subject: [PATCH] mdadm: protecting sys_name overflow
Date: Wed, 15 Jun 2016 15:39:58 +0530
Message-ID: <57612976.6030801@redhat.com>
Reply-To: nkshirsa@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030406060503080401060607"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030406060503080401060607
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

Devices with names larger than 31 bytes will overflow the sys_name array.

This patch enables mdadm to fail and log a message if a long device name
is going to cause a buffer overflow.

Signed-off-by: Nikhil Kshirsagar <nkshirsa@redhat.com>

--------------030406060503080401060607
Content-Type: text/x-patch;
 name="0001-Protecting-overflow-of-sys_name.-If-a-long-device-na.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Protecting-overflow-of-sys_name.-If-a-long-device-na.pa";
 filename*1="tch"

From 705aec84c6abf5b09c4202aec7cade9824ca7f12 Mon Sep 17 00:00:00 2001
From: root <root@nkshirsa.pnq.csb>
Date: Wed, 15 Jun 2016 15:23:12 +0530
Subject: [PATCH] Protecting overflow of sys_name. If a long device name is
 going to cause a buffer overflow, we fail with a log message.

---
 sysfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sysfs.c b/sysfs.c
index 8379ca8..68b8b95 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -283,6 +283,15 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			}
 
 		}
+                /*  strlen computes length of string *not* including the terminating null character. */
+
+                if(strlen(de->d_name) >= sizeof(dev->sys_name))
+                {
+                  pr_err("Device name %s larger than currently supported by mdadm\n",de->d_name);
+                  free(dev);
+                  goto abort;
+
+                }
 		strcpy(dev->sys_name, de->d_name);
 		dev->disk.raid_disk = strtoul(buf, &ep, 10);
 		if (*ep) dev->disk.raid_disk = -1;
-- 
1.8.3.1


--------------030406060503080401060607--
