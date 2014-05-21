From: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Subject: [PATCH] mdadm: Do not reimplment offsetof
Date: Wed, 21 May 2014 12:45:19 -0400
Message-ID: <1400690719-3020-1-git-send-email-crrodriguez@opensuse.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
List-Id: linux-raid.ids

Proper implementations have offsetof in stddef.h
---
 Grow.c      | 5 +----
 super-ddf.c | 5 +----
 super1.c    | 4 +---
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/Grow.c b/Grow.c
index a5a9421..468ab8a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -24,6 +24,7 @@
 #include	"mdadm.h"
 #include	"dlink.h"
 #include	<sys/mman.h>
+#include	<stddef.h>
 #include	<stdint.h>
 #include	<signal.h>
 #include	<sys/wait.h>
@@ -34,10 +35,6 @@
 #include	"md_u.h"
 #include	"md_p.h"
 
-#ifndef offsetof
-#define offsetof(t,f) ((size_t)&(((t*)0)->f))
-#endif
-
 int restore_backup(struct supertype *st,
 		   struct mdinfo *content,
 		   int working_disks,
diff --git a/super-ddf.c b/super-ddf.c
index 37ef665..b03e9b9 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -30,6 +30,7 @@
 #include "mdmon.h"
 #include "sha1.h"
 #include <values.h>
+#include <stddef.h>
 
 /* a non-official T10 name for creation GUIDs */
 static char T10[] = "Linux-MD";
@@ -531,10 +532,6 @@ static int init_super_ddf_bvd(struct supertype *st,
 			      char *name, char *homehost,
 			      int *uuid, unsigned long long data_offset);
 
-#ifndef offsetof
-#define offsetof(t,f) ((size_t)&(((t*)0)->f))
-#endif
-
 #if DEBUG
 static void pr_state(struct ddf_super *ddf, const char *msg)
 {
diff --git a/super1.c b/super1.c
index 1bc5216..7cf9b51 100644
--- a/super1.c
+++ b/super1.c
@@ -22,6 +22,7 @@
  *    Email: <neilb@suse.de>
  */
 
+#include <stddef.h>
 #include "mdadm.h"
 /*
  * The version-1 superblock :
@@ -133,9 +134,6 @@ struct misc_dev_info {
 					|MD_FEATURE_NEW_OFFSET		\
 					)
 
-#ifndef offsetof
-#define offsetof(t,f) ((size_t)&(((t*)0)->f))
-#endif
 static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
 {
 	unsigned int disk_csum, csum;
-- 
1.8.4.5

