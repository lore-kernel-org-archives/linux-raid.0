From: maximilian attems <max@stro.at>
Subject: [PATCH] [mdadm] Monitor.c s/MAXINT/INT_MAX/g
Date: Wed, 26 Sep 2007 18:12:46 +0200
Message-ID: <1190823168772-git-send-email-max@stro.at>
References: <11908231671738-git-send-email-max@stro.at>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11908231671738-git-send-email-max@stro.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, maximilian attems <max@stro.at>
List-Id: linux-raid.ids

include limits.h directly instead of values.h

Signed-off-by: maximilian attems <max@stro.at>
---
 Monitor.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 246bdc0..8bc3ecc 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -32,7 +32,7 @@
 #include	"md_u.h"
 #include	<sys/wait.h>
 #include	<signal.h>
-#include	<values.h>
+#include	<limits.h>
 #include	<syslog.h>
 
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mailfrom,
@@ -172,7 +172,7 @@ int Monitor(mddev_dev_t devlist,
 			st->utime = 0;
 			st->next = statelist;
 			st->err = 0;
-			st->devnum = MAXINT;
+			st->devnum = INT_MAX;
 			st->percent = -2;
 			st->expected_spares = mdlist->spare_disks;
 			if (mdlist->spare_group)
@@ -192,7 +192,7 @@ int Monitor(mddev_dev_t devlist,
 			st->utime = 0;
 			st->next = statelist;
 			st->err = 0;
-			st->devnum = MAXINT;
+			st->devnum = INT_MAX;
 			st->percent = -2;
 			st->expected_spares = -1;
 			st->spare_group = NULL;
@@ -256,7 +256,7 @@ int Monitor(mddev_dev_t devlist,
 				close(fd);
 				continue;
 			}
-			if (st->devnum == MAXINT) {
+			if (st->devnum == INT_MAX) {
 				struct stat stb;
 				if (fstat(fd, &stb) == 0 &&
 				    (S_IFMT&stb.st_mode)==S_IFBLK) {
@@ -269,7 +269,7 @@ int Monitor(mddev_dev_t devlist,
 
 			for (mse2 = mdstat ; mse2 ; mse2=mse2->next)
 				if (mse2->devnum == st->devnum) {
-					mse2->devnum = MAXINT; /* flag it as "used" */
+					mse2->devnum = INT_MAX; /* flag it as "used" */
 					mse = mse2;
 				}
 
@@ -402,7 +402,7 @@ int Monitor(mddev_dev_t devlist,
 		if (scan) {
 			struct mdstat_ent *mse;
 			for (mse=mdstat; mse; mse=mse->next) 
-				if (mse->devnum != MAXINT &&
+				if (mse->devnum != INT_MAX &&
 				    (strcmp(mse->level, "raid0")!=0 &&
 				     strcmp(mse->level, "linear")!=0)
 					) {
-- 
1.5.3.1

