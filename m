From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] FIX: Bad block verification during assembling array
Date: Thu, 16 Dec 2010 14:34:54 +0100
Message-ID: <20101216133454.8504.60474.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

We need to refuse to assemble an arrays with bad blocks.
Initially there was condition in container_content function
that returns error value in the case when metadata store information
about bad blocks.
When the container_content function is called from functions NOT connected
with assemble (Kill_subarray, Detail) we get faulty error return value.
Patch introduces new flag in array.status - MD_SB_BBM_ERRORS. It is set
in container_content when bad blocks are detected and can be checked by
container_content caller.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Assemble.c    |    7 +++++++
 Incremental.c |    6 ++++++
 md_p.h        |    1 +
 super-intel.c |   14 ++++++++------
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 7293ee6..34c0aad 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -435,6 +435,13 @@ int Assemble(struct supertype *st, char *mddev,
 			     content;
 			     content = content->next) {
 
+				/* do not assemble arrays that might have bad blocks */
+				if (content->array.state & (1<<MD_SB_BBM_ERRORS)) {
+					fprintf(stderr, Name ": BBM log found in metadata. "
+								"Cannot activate array(s).\n");
+					tmpdev->used = 2;
+					goto loop;
+				}
 				if (!ident_matches(ident, content, tst,
 						   homehost, update,
 						   report_missmatch ? devname : NULL))
diff --git a/Incremental.c b/Incremental.c
index 9399f5b..75acfb6 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1402,6 +1402,12 @@ static int Incremental_container(struct supertype *st, char *devname,
 	if (map_lock(&map))
 		fprintf(stderr, Name ": failed to get exclusive lock on "
 			"mapfile\n");
+	/* do not assemble arrays that might have bad blocks */
+	if (list->array.state & (1<<MD_SB_BBM_ERRORS)) {
+		fprintf(stderr, Name ": BBM log found in metadata. "
+					"Cannot activate array(s).\n");
+		list = NULL;
+	}
 
 	for (ra = list ; ra ; ra = ra->next) {
 		int mdfd;
diff --git a/md_p.h b/md_p.h
index 4594a36..6c79a3d 100644
--- a/md_p.h
+++ b/md_p.h
@@ -100,6 +100,7 @@ typedef struct mdp_device_descriptor_s {
  */
 #define MD_SB_CLEAN		0
 #define MD_SB_ERRORS		1
+#define MD_SB_BBM_ERRORS	2
 
 #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
 
diff --git a/super-intel.c b/super-intel.c
index 2070869..8d7cd05 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4874,13 +4874,11 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	struct imsm_super *mpb = super->anchor;
 	struct mdinfo *rest = NULL;
 	unsigned int i;
+	int bbm_errors = 0;
 
-	/* do not assemble arrays that might have bad blocks */
-	if (imsm_bbm_log_size(super->anchor)) {
-		fprintf(stderr, Name ": BBM log found in metadata. "
-				"Cannot activate array(s).\n");
-		return NULL;
-	}
+	/* check for bad blocks */
+	if (imsm_bbm_log_size(super->anchor))
+		bbm_errors = 1;
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev;
@@ -4997,6 +4995,10 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 		rest = this;
 	}
 
+	/* if array has bad blocks, set suitable bit in array status */
+	if (bbm_errors)
+		rest->array.state |= (1<<MD_SB_BBM_ERRORS);
+
 	return rest;
 }
 

