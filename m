From: Jes.Sorensen@redhat.com
Subject: [PATCH 14/19] Managa_ro(): free() mdi before exiting
Date: Tue,  1 Nov 2011 16:09:30 +0100
Message-ID: <1320160175-18976-15-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Manage.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/Manage.c b/Manage.c
index 170af57..39a9b20 100644
--- a/Manage.c
+++ b/Manage.c
@@ -44,6 +44,7 @@ int Manage_ro(char *devname, int fd, int readonly)
 #ifndef MDASSEMBLE
 	struct mdinfo *mdi;
 #endif
+	int rv = 0;
 
 	if (md_get_version(fd) < 9000) {
 		fprintf(stderr, Name ": need md driver version 0.90.0 or later\n");
@@ -75,7 +76,8 @@ int Manage_ro(char *devname, int fd, int readonly)
 
 				vers[9] = mdi->text_version[0];
 				sysfs_set_str(mdi, NULL, "metadata_version", vers);
-				return 1;
+				rv = 1;
+				goto out;
 			}
 		} else {
 			char *cp;
@@ -90,29 +92,37 @@ int Manage_ro(char *devname, int fd, int readonly)
 			if (mdi->array.level <= 0)
 				sysfs_set_str(mdi, NULL, "array_state", "active");
 		}
-		return 0;
+		goto out;
 	}
 #endif
 	if (ioctl(fd, GET_ARRAY_INFO, &array)) {
 		fprintf(stderr, Name ": %s does not appear to be active.\n",
 			devname);
-		return 1;
+		rv = 1;
+		goto out;
 	}
 
 	if (readonly>0) {
 		if (ioctl(fd, STOP_ARRAY_RO, NULL)) {
 			fprintf(stderr, Name ": failed to set readonly for %s: %s\n",
 				devname, strerror(errno));
-			return 1;
+			rv = 1;
+			goto out;
 		}
 	} else if (readonly < 0) {
 		if (ioctl(fd, RESTART_ARRAY_RW, NULL)) {
 			fprintf(stderr, Name ": failed to set writable for %s: %s\n",
 				devname, strerror(errno));
-			return 1;
+			rv = 1;
+			goto out;
 		}
 	}
-	return 0;
+out:
+#ifndef MDASSEMBLE
+	if (mdi)
+		sysfs_free(mdi);
+#endif
+	return rv;
 }
 
 #ifndef MDASSEMBLE
-- 
1.7.6.4

