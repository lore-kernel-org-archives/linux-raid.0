From: Jes.Sorensen@redhat.com
Subject: [PATCH 05/11] Use 4K buffer alignment for superblock allocations
Date: Tue, 20 Mar 2012 17:54:10 +0100
Message-ID: <1332262456-5109-6-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

To better accommodate 4K sector drives, use 4K buffer alignment for
superblock buffers.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index ca9e4e4..513f406 100644
--- a/super1.c
+++ b/super1.c
@@ -837,7 +837,7 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 	int rfd;
 	char defname[10];
 
-	if (posix_memalign((void**)&sb, 512, SUPER1_SIZE) != 0) {
+	if (posix_memalign((void**)&sb, 4096, SUPER1_SIZE) != 0) {
 		fprintf(stderr, Name
 			": %s could not allocate superblock\n", __func__);
 		return 0;
@@ -1220,7 +1220,7 @@ static int compare_super1(struct supertype *st, struct supertype *tst)
 		return 1;
 
 	if (!first) {
-		if (posix_memalign((void**)&first, 512, SUPER1_SIZE) != 0) {
+		if (posix_memalign((void**)&first, 4096, SUPER1_SIZE) != 0) {
 			fprintf(stderr, Name
 				": %s could not allocate superblock\n", __func__);
 			return 1;
@@ -1332,7 +1332,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 		return 1;
 	}
 
-	if (posix_memalign((void**)&super, 512, SUPER1_SIZE) != 0) {
+	if (posix_memalign((void**)&super, 4096, SUPER1_SIZE) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n",
 			__func__);
 		return 1;
-- 
1.7.7.6

