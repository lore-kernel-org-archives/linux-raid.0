From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] Increase buffer for sysfs disk state
Date: Thu, 27 Oct 2016 11:34:16 +0200
Message-ID: <1477560856-17310-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Bad block support has incremented sysfs disk state reported by kernel
("external_bbl") so it became longer than 20 bytes. It causes reshape to
fail as it reads truncated entry from sysfs.

Increase buffer so it can accommodate the string including all state
values currently implemented in kernel at the same time.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Grow.c        | 6 ++++--
 monitor.c     | 4 ++--
 super-intel.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7402597..9f1570e 100755
--- a/Grow.c
+++ b/Grow.c
@@ -4017,8 +4017,10 @@ static int grow_backup(struct mdinfo *sra,
 			if (sd->disk.state & (1<<MD_DISK_FAULTY))
 				continue;
 			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
-				char sbuf[20];
-				if (sysfs_get_str(sra, sd, "state", sbuf, 20) < 0 ||
+				char sbuf[100];
+
+				if (sysfs_get_str(sra, sd, "state",
+						  sbuf, sizeof(sbuf)) < 0 ||
 				    strstr(sbuf, "faulty") ||
 				    strstr(sbuf, "in_sync") == NULL) {
 					/* this device is dead */
diff --git a/monitor.c b/monitor.c
index 1704a59..15181ce 100644
--- a/monitor.c
+++ b/monitor.c
@@ -136,8 +136,8 @@ static enum sync_action read_action( int fd)
 
 int read_dev_state(int fd)
 {
-	char buf[60];
-	int n = read_attr(buf, 60, fd);
+	char buf[100];
+	int n = read_attr(buf, sizeof(buf), fd);
 	char *cp;
 	int rv = 0;
 
diff --git a/super-intel.c b/super-intel.c
index 4bb9059..f9d0a04 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11408,9 +11408,10 @@ int check_degradation_change(struct mdinfo *info,
 			if (sd->disk.state & (1<<MD_DISK_FAULTY))
 				continue;
 			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
-				char sbuf[20];
+				char sbuf[100];
+
 				if (sysfs_get_str(info,
-					sd, "state", sbuf, 20) < 0 ||
+					sd, "state", sbuf, sizeof(sbuf)) < 0 ||
 					strstr(sbuf, "faulty") ||
 					strstr(sbuf, "in_sync") == NULL) {
 					/* this device is dead */
-- 
1.8.3.1

