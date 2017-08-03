From: jcejka@suse.com
Subject: [PATCH] mdadm: allow to assemble /dev/md_xxx named arrays.
Date: Thu,  3 Aug 2017 18:32:36 +0200
Message-ID: <20170803163236.28958-1-jcejka@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Josef Cejka <jcejka@suse.com>
List-Id: linux-raid.ids

From: Josef Cejka <jcejka@suse.com>

Allow to assemble arrays using /dev/md_xxx name format
both from cmdline like mdadm -A /dev/md_xxx
or using ASSEMBLE directive in mdadm.conf

Signed-off-by: Josef Cejka <jcejka@suse.com>
---
 config.c |  5 +++--
 mdopen.c | 26 ++++++++++++++++----------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/config.c b/config.c
index 48e0278..113ef01 100644
--- a/config.c
+++ b/config.c
@@ -389,6 +389,7 @@ void arrayline(char *line)
 			 *  /dev/md/{anything}
 			 *  /dev/mdNN
 			 *  /dev/md_dNN
+			 *  /dev/md_XXX
 			 *  <ignore>
 			 *  or anything that doesn't start '/' or '<'
 			 */
@@ -397,8 +398,8 @@ void arrayline(char *line)
 			    (w[0] != '/' && w[0] != '<') ||
 			    (strncmp(w, "/dev/md", 7) == 0 &&
 			     is_number(w + 7)) ||
-			    (strncmp(w, "/dev/md_d", 9) == 0 &&
-			     is_number(w + 9))) {
+			    (strncmp(w, "/dev/md_", 8) == 0 &&
+			     strlen(w) > 8)) {
 				/* This is acceptable */;
 				if (mis.devname)
 					pr_err("only give one device per ARRAY line: %s and %s\n",
diff --git a/mdopen.c b/mdopen.c
index c4f1c12..0f3a244 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -174,19 +174,25 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 				num = strtoul(e, NULL, 10);
 			strcpy(cname, dev+5);
 			cname[e-(dev+5)] = 0;
-			/* name *must* be mdXX or md_dXX in this context */
+			/* name is not mdXX or md_dXX */
 			if (num < 0 ||
 			    (strcmp(cname, "md") != 0 && strcmp(cname, "md_d") != 0)) {
-				pr_err("%s is an invalid name for an md device.  Try /dev/md/%s\n",
-					dev, dev+5);
-				return -1;
+				if (strncmp(cname, "md_", 3) != 0) {
+					pr_err("%s is an invalid name for an md device.  Try /dev/md/%s\n",
+						dev, dev+5);
+					return -1;
+				}
+				/* /dev/md_<string> format */
+				strcpy(cname, dev+8);
+				num = -1;
+			} else {
+				if (strcmp(cname, "md") == 0)
+					use_mdp = 0;
+				else
+					use_mdp = 1;
+				/* recreate name: /dev/md/0 or /dev/md/d0 */
+				sprintf(cname, "%s%d", use_mdp?"d":"", num);
 			}
-			if (strcmp(cname, "md") == 0)
-				use_mdp = 0;
-			else
-				use_mdp = 1;
-			/* recreate name: /dev/md/0 or /dev/md/d0 */
-			sprintf(cname, "%s%d", use_mdp?"d":"", num);
 		} else
 			strcpy(cname, dev);
 
-- 
2.12.3

