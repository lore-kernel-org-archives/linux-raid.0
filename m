From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 2/3] mdadm/mdstat: fixup a number of '==' broken formatting
Date: Mon,  9 Oct 2017 16:21:13 +0800
Message-ID: <1507537274-29350-3-git-send-email-zlliu@suse.com>
References: <1507537274-29350-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507537274-29350-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

This commit doesn't change any codes, just tidy up the
code formatting.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdstat.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index 0d44050..6c906a7 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -158,11 +158,11 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		char devnm[32];
 		int in_devs = 0;
 
-		if (strcmp(line, "Personalities")==0)
+		if (strcmp(line, "Personalities") == 0)
 			continue;
-		if (strcmp(line, "read_ahead")==0)
+		if (strcmp(line, "read_ahead") == 0)
 			continue;
-		if (strcmp(line, "unused")==0)
+		if (strcmp(line, "unused") == 0)
 			continue;
 		insert_here = NULL;
 		/* Better be an md line.. */
@@ -187,9 +187,9 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		for (w=dl_next(line); w!= line ; w=dl_next(w)) {
 			int l = strlen(w);
 			char *eq;
-			if (strcmp(w, "active")==0)
+			if (strcmp(w, "active") == 0)
 				ent->active = 1;
-			else if (strcmp(w, "inactive")==0) {
+			else if (strcmp(w, "inactive") == 0) {
 				ent->active = 0;
 				in_devs = 1;
 			} else if (ent->active > 0 &&
@@ -197,13 +197,13 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 				 w[0] != '(' /*readonly*/) {
 				ent->level = xstrdup(w);
 				in_devs = 1;
-			} else if (in_devs && strcmp(w, "blocks")==0)
+			} else if (in_devs && strcmp(w, "blocks") == 0)
 				in_devs = 0;
 			else if (in_devs) {
 				char *ep = strchr(w, '[');
 				ent->devcnt +=
 					add_member_devname(&ent->members, w);
-				if (ep && strncmp(w, "md", 2)==0) {
+				if (ep && strncmp(w, "md", 2) == 0) {
 					/* This has an md device as a component.
 					 * If that device is already in the
 					 * list, make sure we insert before
@@ -226,31 +226,31 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 			} else if (w[0] == '[' && isdigit(w[1])) {
 				ent->raid_disks = atoi(w+1);
 			} else if (!ent->pattern &&
-				 w[0] == '[' &&
-				 (w[1] == 'U' || w[1] == '_')) {
+				   w[0] == '[' &&
+				   (w[1] == 'U' || w[1] == '_')) {
 				ent->pattern = xstrdup(w+1);
-				if (ent->pattern[l-2]==']')
+				if (ent->pattern[l-2] == ']')
 					ent->pattern[l-2] = '\0';
 			} else if (ent->percent == RESYNC_NONE &&
-				   strncmp(w, "re", 2)== 0 &&
+				   strncmp(w, "re", 2) == 0 &&
 				   w[l-1] == '%' &&
-				   (eq=strchr(w, '=')) != NULL ) {
+				   (eq = strchr(w, '=')) != NULL ) {
 				ent->percent = atoi(eq+1);
-				if (strncmp(w,"resync", 6)==0)
+				if (strncmp(w,"resync", 6) == 0)
 					ent->resync = 1;
-				else if (strncmp(w, "reshape", 7)==0)
+				else if (strncmp(w, "reshape", 7) == 0)
 					ent->resync = 2;
 				else
 					ent->resync = 0;
 			} else if (ent->percent == RESYNC_NONE &&
 				   (w[0] == 'r' || w[0] == 'c')) {
-				if (strncmp(w, "resync", 4)==0)
+				if (strncmp(w, "resync", 4) == 0)
 					ent->resync = 1;
-				if (strncmp(w, "reshape", 7)==0)
+				if (strncmp(w, "reshape", 7) == 0)
 					ent->resync = 2;
-				if (strncmp(w, "recovery", 8)==0)
+				if (strncmp(w, "recovery", 8) == 0)
 					ent->resync = 0;
-				if (strncmp(w, "check", 5)==0)
+				if (strncmp(w, "check", 5) == 0)
 					ent->resync = 3;
 
 				if (l > 8 && strcmp(w+l-8, "=DELAYED") == 0)
@@ -289,7 +289,8 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 			e->next = rv;
 			rv = e;
 		}
-	} else rv = all;
+	} else
+		rv = all;
 	return rv;
 }
 
-- 
2.6.6

