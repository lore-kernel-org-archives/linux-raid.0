From: Jes.Sorensen@redhat.com
Subject: [PATCH 03/13] Try to catch malloc() failures in Assemble.c
Date: Wed, 26 Oct 2011 17:30:16 +0200
Message-ID: <1319643026-11501-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Assemble.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 2000dd0..6337681 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -706,7 +706,17 @@ int Assemble(struct supertype *st, char *mddev,
 	bitmap_done = 0;
 	content->update_private = NULL;
 	devices = malloc(num_devs * sizeof(*devices));
+	if (!devices) {
+		close(mdfd);
+		return -ENOMEM;
+	}
 	devmap = calloc(num_devs * content->array.raid_disks, 1);
+	if (!devmap) {
+		close(mdfd);
+		free(devices);
+		return -ENOMEM;
+	}
+
 	for (tmpdev = devlist; tmpdev; tmpdev=tmpdev->next) if (tmpdev->used == 1) {
 		char *devname = tmpdev->devname;
 		struct stat stb;
@@ -847,6 +857,16 @@ int Assemble(struct supertype *st, char *mddev,
 				int newbestcnt = i+10;
 				int *newbest = malloc(sizeof(int)*newbestcnt);
 				int c;
+				if (!newbest) {
+					if (best)
+						free(best);
+					close(mdfd);
+					free(devices);
+					free(devmap);
+					fprintf(stderr, Name ": %s unable to "
+						"allocate memory\n", __func__);
+					return -ENOMEM;
+				}
 				for (c=0; c < newbestcnt; c++)
 					if (c < bestcnt)
 						newbest[c] = best[c];
@@ -912,8 +932,14 @@ int Assemble(struct supertype *st, char *mddev,
 	/* now we have some devices that might be suitable.
 	 * I wonder how many
 	 */
-	avail = malloc(content->array.raid_disks);
-	memset(avail, 0, content->array.raid_disks);
+	avail = calloc(content->array.raid_disks, 1);
+	if (!avail) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		close(mdfd);
+		free(devices);
+		free(devmap);
+	};
 	okcnt = 0;
 	sparecnt=0;
 	rebuilding_cnt=0;
@@ -1172,6 +1198,13 @@ int Assemble(struct supertype *st, char *mddev,
 	if (content->reshape_active) {
 		int err = 0;
 		int *fdlist = malloc(sizeof(int)* bestcnt);
+		if (!fdlist) {
+			fprintf(stderr, Name ": %s unable to allocate memory\n",
+				__func__);
+			close(mdfd);
+			free(devices);
+			return -ENOMEM;
+		}
 		if (verbose > 0)
 			fprintf(stderr, Name ":%s has an active reshape - checking "
 				"if critical section needs to be restored\n",
-- 
1.7.6.4

