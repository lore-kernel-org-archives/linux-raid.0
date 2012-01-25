From: Jes.Sorensen@redhat.com
Subject: [PATCH 4/4] Spawn mdmon with --offroot if mdadm was launched with --offroot
Date: Wed, 25 Jan 2012 16:18:04 +0100
Message-ID: <1327504684-9219-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
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
index 78f28d5..1efa3e8 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -181,6 +181,7 @@ int main(int argc, char *argv[])
 		 */
 		case OffRootOpt:
 			argv[0][0] = '@';
+			__offroot = 1;
 			continue;
 
 		case ':':
diff --git a/mdadm.h b/mdadm.h
index fec93aa..d862b3e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1383,3 +1383,5 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 
 #define PROCESS_DELAYED -2
 #define PROCESS_PENDING -3
+
+extern int __offroot;
diff --git a/util.c b/util.c
index 6985a70..4ba44e6 100644
--- a/util.c
+++ b/util.c
@@ -32,6 +32,8 @@
 #include	<dirent.h>
 #include	<signal.h>
 
+int __offroot;
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
+				if (__offroot) {
+					execl(paths[i], "mdmon", "--offroot",
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

