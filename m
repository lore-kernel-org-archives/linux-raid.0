From: Jes.Sorensen@redhat.com
Subject: [PATCH 06/13] Handle malloc() errors in Manage.c
Date: Wed, 26 Oct 2011 17:30:19 +0200
Message-ID: <1319643026-11501-7-git-send-email-Jes.Sorensen@redhat.com>
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
 Manage.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Manage.c b/Manage.c
index 2d8c916..024318b 100644
--- a/Manage.c
+++ b/Manage.c
@@ -143,6 +143,11 @@ static void remove_devices(int devnum, char *path)
 	be = base + strlen(base);
 
 	path2 = malloc(strlen(path)+20);
+	if (!path2) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		exit(1);
+	}
 	strcpy(path2, path);
 	pe = path2 + strlen(path2);
 	
@@ -898,8 +903,12 @@ int Manage_subdevs(char *devname, int fd,
 				 * As we are "--re-add"ing we must find a spare slot
 				 * to fill.
 				 */
-				char *used = malloc(array.raid_disks);
-				memset(used, 0, array.raid_disks);
+				char *used = calloc(array.raid_disks, 1);
+				if (!used) {
+					fprintf(stderr, Name ": %s unable to "
+						"allocate memory\n", __func__);
+					return -ENOMEM;
+				}
 				for (j=0; j< tst->max_devs; j++) {
 					mdu_disk_info_t disc2;
 					disc2.number = j;
-- 
1.7.6.4

