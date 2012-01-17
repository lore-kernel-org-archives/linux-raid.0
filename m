From: Jes.Sorensen@redhat.com
Subject: [PATCH 4/4] Spawn mdmon with --initrd if mdadm was launched with --initrd
Date: Tue, 17 Jan 2012 11:48:50 +0100
Message-ID: <1326797330-4488-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
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
index c0ccf55..3edf2f1 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -182,6 +182,7 @@ int main(int argc, char *argv[])
 		case InitrdOpt:
 			c = argv[0];
 			c[0] = '@';
+			__initrd = 1;
 			continue;
 
 		case ':':
diff --git a/mdadm.h b/mdadm.h
index d1ac1e8..fddd98d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1383,3 +1383,5 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 
 #define PROCESS_DELAYED -2
 #define PROCESS_PENDING -3
+
+extern int __initrd;
diff --git a/util.c b/util.c
index 6985a70..89299b8 100644
--- a/util.c
+++ b/util.c
@@ -32,6 +32,8 @@
 #include	<dirent.h>
 #include	<signal.h>
 
+int __initrd;
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
+				if (__initrd) {
+					execl(paths[i], "mdmon", "--initrd",
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

