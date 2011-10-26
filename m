From: Jes.Sorensen@redhat.com
Subject: [PATCH 04/13] Attempt to catch malloc() failure in Detail.c
Date: Wed, 26 Oct 2011 17:30:17 +0200
Message-ID: <1319643026-11501-5-git-send-email-Jes.Sorensen@redhat.com>
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
 Detail.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/Detail.c b/Detail.c
index ca34abe..4130821 100644
--- a/Detail.c
+++ b/Detail.c
@@ -147,6 +147,11 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 			info = st->ss->container_content(st, subarray);
 		else {
 			info = malloc(sizeof(*info));
+			if (!info) {
+				fprintf(stderr, Name ": %s unable to allocate "
+					"memory\n", __func__);
+				return -ENOMEM;
+			}
 			st->ss->getinfo_super(st, info, NULL);
 		}
 		if (!info)
@@ -227,6 +232,11 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 	}
 
 	disks = malloc(max_disks * sizeof(mdu_disk_info_t));
+	if (!disks) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		return -ENOMEM;
+	}
 	for (d=0; d<max_disks; d++) {
 		disks[d].state = (1<<MD_DISK_REMOVED);
 		disks[d].major = disks[d].minor = 0;
@@ -252,6 +262,11 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 	}
 
 	avail = calloc(array.raid_disks, 1);
+	if (!avail) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		return -ENOMEM;
+	}
 
 	for (d= 0; d < array.raid_disks; d++) {
 		mdu_disk_info_t disk = disks[d];
@@ -563,6 +578,13 @@ This is pretty boring
 				if (devices) {
 					devices = realloc(devices,
 							  strlen(devices)+1+strlen(dv)+1);
+					if (!devices) {
+						fprintf(stderr, Name ": %s "
+							"unable to realloc "
+							"memory\n", __func__);
+						return -ENOMEM;
+					}
+
 					strcat(strcat(devices,","),dv);
 				} else
 					devices = strdup(dv);
-- 
1.7.6.4

