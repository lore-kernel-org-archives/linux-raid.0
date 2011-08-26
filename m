From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/9] sysfs: fix sysfs_disk_to_scsi_id
Date: Thu, 25 Aug 2011 19:14:19 -0700
Message-ID: <20110826021419.28015.64805.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Not sure how this ever worked, but now we just try to parse a directory
name that looks like <host>:<bus>:<target>:<lun>.

Array creation segfaults on Fedora 14 without this.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 sysfs.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index 56813b7..2146264 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -709,9 +709,9 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 	/* from an open block device, try to retrieve it scsi_id */
 	struct stat st;
 	char path[256];
-	char *c1, *c2;
 	DIR *dir;
 	struct dirent *de;
+	int host, bus, target, lun;
 
 	if (fstat(fd, &st))
 		return 1;
@@ -723,32 +723,22 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 	if (!dir)
 		return 1;
 
-	de = readdir(dir);
-	while (de) {
-		if (strchr(de->d_name, ':'))
+	for (de = readdir(dir); de; de = readdir(dir)) {
+		int count;
+
+		if (de->d_type != DT_DIR)
+			continue;
+
+		count = sscanf(de->d_name, "%d:%d:%d:%d", &host, &bus, &target, &lun);
+		if (count == 4)
 			break;
-		de = readdir(dir);
 	}
 	closedir(dir);
 
 	if (!de)
 		return 1;
 
-	c1 = de->d_name;
-	c2 = strchr(c1, ':');
-	*c2 = '\0';
-	*id = strtol(c1, NULL, 10) << 24; /* host */
-	c1 = c2 + 1;
-	c2 = strchr(c1, ':');
-	*c2 = '\0';
-	*id |= strtol(c1, NULL, 10) << 16; /* bus */
-	c1 = c2 + 1;
-	c2 = strchr(c1, ':');
-	*c2 = '\0';
-	*id |= strtol(c1, NULL, 10) << 8; /* target */
-	c1 = c2 + 1;
-	*id |= strtol(c1, NULL, 10); /* lun */
-
+	*id = (host << 24) | (bus << 16) | (target << 8) | (lun << 0);
 	return 0;
 }
 

