From: Jes.Sorensen@redhat.com
Subject: [PATCH 4/4] Spawn mdmon with --preboot if mdadm was launched with --preboot
Date: Mon, 23 Jan 2012 12:18:25 +0100
Message-ID: <1327317505-14782-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdadm.c |    1 +
 mdadm.h |    2 ++
 util.c  |   17 +++++++++++++----
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 6c38064..e401bb3 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -181,6 +181,7 @@ int main(int argc, char *argv[])
 		 */
 		case PreBootOpt:
 			argv[0][0] = '@';
+			__preboot = 1;
 			continue;
 
 		case ':':
diff --git a/mdadm.h b/mdadm.h
index 10b420f..0eb820c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1383,3 +1383,5 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 
 #define PROCESS_DELAYED -2
 #define PROCESS_PENDING -3
+
+extern int __preboot;
diff --git a/util.c b/util.c
index 6985a70..e31930e 100644
--- a/util.c
+++ b/util.c
@@ -32,6 +32,8 @@
 #include	<dirent.h>
 #include	<signal.h>
 
+int __preboot;
+
 /*
  * following taken from linux/blkpg.h because they aren't
  * anywhere else and it isn't safe to #include linux/ * stuff.
@@ -1622,10 +1624,17 @@ int start_mdmon(int devnum)
 				skipped = 0;
 
 		for (i=0; paths[i]; i++)
-			if (paths[i][0])
-				execl(paths[i], "mdmon",
-				      devnum2devname(devnum),
-				      NULL);
+			if (paths[i][0]) {
+				if (__preboot) {
+					execl(paths[i], "mdmon", "--preboot",
+					      devnum2devname(devnum),
+					      NULL);
+				} else {
+					execl(paths[i], "mdmon",
+					      devnum2devname(devnum),
+					      NULL);
+				}
+			}
 		exit(1);
 	case -1: fprintf(stderr, Name ": cannot run mdmon. "
 			 "Array remains readonly\n");
-- 
1.7.8.3

