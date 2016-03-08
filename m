From: Jes.Sorensen@redhat.com
Subject: [PATCH 5/8] {platform,super}-intel: Fix two resource leaks
Date: Tue,  8 Mar 2016 12:30:49 -0500
Message-ID: <1457458252-20203-6-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The code did not free 'dir' allocated by opendir(). An additional
benefit is that this simplifies the for() loops.

Fixes: 60f0f54d ("IMSM: Add support for VMD")
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 platform-intel.c | 7 ++++++-
 super-intel.c    | 6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 88818f3..c60fd9e 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -724,8 +724,10 @@ char *vmd_domain_to_controller(struct sys_dev *hba, char *buf)
 		return NULL;
 
 	dir = opendir("/sys/bus/pci/drivers/vmd");
+	if (!dir)
+		return NULL;
 
-	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
+	for (ent = readdir(dir); ent; ent = readdir(dir)) {
 		sprintf(path, "/sys/bus/pci/drivers/vmd/%s/domain/device",
 			ent->d_name);
 
@@ -734,8 +736,11 @@ char *vmd_domain_to_controller(struct sys_dev *hba, char *buf)
 
 		if (strncmp(buf, hba->path, strlen(buf)) == 0) {
 			sprintf(path, "/sys/bus/pci/drivers/vmd/%s", ent->d_name);
+			closedir(dir);
 			return realpath(path, buf);
 		}
 	}
+
+	closedir(dir);
 	return NULL;
 }
diff --git a/super-intel.c b/super-intel.c
index 158f4e8..e1bee75 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1781,7 +1781,10 @@ static int print_vmd_attached_devs(struct sys_dev *hba)
 	 * this hba
 	 */
 	dir = opendir("/sys/bus/pci/drivers/nvme");
-	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
+	if (!dir)
+		return 1;
+
+	for (ent = readdir(dir); ent; ent = readdir(dir)) {
 		int n;
 
 		/* is 'ent' a device? check that the 'subsystem' link exists and
@@ -1814,6 +1817,7 @@ static int print_vmd_attached_devs(struct sys_dev *hba)
 		free(rp);
 	}
 
+	closedir(dir);
 	return 0;
 }
 
-- 
2.5.0

