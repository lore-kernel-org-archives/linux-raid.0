From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] Define _POSIX_C_SOURCE if undefined
Date: Wed, 13 Jan 2016 07:59:24 +0000
Message-ID: <1452671964-35006-1-git-send-email-raj.khem@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
List-Id: linux-raid.ids

typecast second argument of connect() API to use struct sockaddr*

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 config.c | 3 +++
 mdmon.c  | 2 +-
 msg.c    | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/config.c b/config.c
index c58c8fe..b308b6c 100644
--- a/config.c
+++ b/config.c
@@ -63,6 +63,9 @@
  * but may not wrap over lines
  *
  */
+#ifndef _POSIX_C_SOURCE
+#define _POSIX_C_SOURCE 200809L
+#endif
 
 #ifndef CONFFILE
 #define CONFFILE "/etc/mdadm.conf"
diff --git a/mdmon.c b/mdmon.c
index ee12b7c..e4b73d9 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -235,7 +235,7 @@ static int make_control_sock(char *devname)
 	addr.sun_family = PF_LOCAL;
 	strcpy(addr.sun_path, path);
 	umask(077); /* ensure no world write access */
-	if (bind(sfd, &addr, sizeof(addr)) < 0) {
+	if (bind(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
 		close(sfd);
 		return -1;
 	}
diff --git a/msg.c b/msg.c
index 754630b..45cd450 100644
--- a/msg.c
+++ b/msg.c
@@ -170,7 +170,7 @@ int connect_monitor(char *devname)
 
 	addr.sun_family = PF_LOCAL;
 	strcpy(addr.sun_path, path);
-	if (connect(sfd, &addr, sizeof(addr)) < 0) {
+	if (connect(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
 		close(sfd);
 		return -1;
 	}
-- 
2.7.0

