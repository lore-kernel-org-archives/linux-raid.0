From: Jes.Sorensen@redhat.com
Subject: [PATCH 02/11] Define and use SUPER1_SIZE for allocations
Date: Tue, 20 Mar 2012 17:54:07 +0100
Message-ID: <1332262456-5109-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Use a #define rather than calculate the size of the superblock buffer
on every allocation.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/super1.c b/super1.c
index 4e3bf7b..4c75f21 100644
--- a/super1.c
+++ b/super1.c
@@ -102,6 +102,8 @@ struct misc_dev_info {
 
 #define	MD_FEATURE_ALL			(1|2|4)
 
+#define SUPER1_SIZE	(1024 + 512 + sizeof(struct misc_dev_info))
+
 #ifndef offsetof
 #define offsetof(t,f) ((size_t)&(((t*)0)->f))
 #endif
@@ -835,8 +837,7 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 	int rfd;
 	char defname[10];
 
-	if (posix_memalign((void**)&sb, 512, (1024 + 512 + 
-			   sizeof(struct misc_dev_info))) != 0) {
+	if (posix_memalign((void**)&sb, 512, SUPER1_SIZE) != 0) {
 		fprintf(stderr, Name
 			": %s could not allocate superblock\n", __func__);
 		return 0;
@@ -1221,15 +1222,12 @@ static int compare_super1(struct supertype *st, struct supertype *tst)
 		return 1;
 
 	if (!first) {
-		if (posix_memalign((void**)&first, 512,
-			       1024 + 512 +
-			       sizeof(struct misc_dev_info)) != 0) {
+		if (posix_memalign((void**)&first, 512, SUPER1_SIZE) != 0) {
 			fprintf(stderr, Name
 				": %s could not allocate superblock\n", __func__);
 			return 1;
 		}
-		memcpy(first, second, 1024 + 512 + 
-		       sizeof(struct misc_dev_info));
+		memcpy(first, second, SUPER1_SIZE);
 		st->sb = first;
 		return 0;
 	}
@@ -1336,9 +1334,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
-	if (posix_memalign((void**)&super, 512,
-		       1024 + 512 +
-		       sizeof(struct misc_dev_info)) != 0) {
+	if (posix_memalign((void**)&super, 512, SUPER1_SIZE) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n",
 			__func__);
 		return 1;
-- 
1.7.7.6

