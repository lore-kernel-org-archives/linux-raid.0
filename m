From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] policy: NULL path isn't really acceptable - use the devname
Date: Thu, 19 Dec 2013 13:02:12 +0100
Message-ID: <20131219120212.16976.96892.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

According to:
	commit b451aa4846c5ccca5447a6b6d45e5623b8c8e961
	Fix handling for "auto" line in mdadm.conf

a NULL path isn't really acceptable and the devname should be used instead.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 policy.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/policy.c b/policy.c
index b4f3943..104695d 100644
--- a/policy.c
+++ b/policy.c
@@ -200,26 +200,25 @@ static char *disk_path(struct mdinfo *disk)
 	int rv;
 
 	by_path = opendir(symlink);
-	if (!by_path)
-		return NULL;
-	prefix_len = strlen(symlink);
-
-	while ((ent = readdir(by_path)) != NULL) {
-		if (ent->d_type != DT_LNK)
-			continue;
-		strncpy(symlink + prefix_len,
-			ent->d_name,
-			sizeof(symlink) - prefix_len);
-		if (stat(symlink, &stb) < 0)
-			continue;
-		if ((stb.st_mode & S_IFMT) != S_IFBLK)
-			continue;
-		if (stb.st_rdev != makedev(disk->disk.major, disk->disk.minor))
-			continue;
+	if (by_path) {
+		prefix_len = strlen(symlink);
+		while ((ent = readdir(by_path)) != NULL) {
+			if (ent->d_type != DT_LNK)
+				continue;
+			strncpy(symlink + prefix_len,
+					ent->d_name,
+					sizeof(symlink) - prefix_len);
+			if (stat(symlink, &stb) < 0)
+				continue;
+			if ((stb.st_mode & S_IFMT) != S_IFBLK)
+				continue;
+			if (stb.st_rdev != makedev(disk->disk.major, disk->disk.minor))
+				continue;
+			closedir(by_path);
+			return xstrdup(ent->d_name);
+		}
 		closedir(by_path);
-		return xstrdup(ent->d_name);
 	}
-	closedir(by_path);
 	/* A NULL path isn't really acceptable - use the devname.. */
 	sprintf(symlink, "/sys/dev/block/%d:%d", disk->disk.major, disk->disk.minor);
 	rv = readlink(symlink, nm, sizeof(nm)-1);

