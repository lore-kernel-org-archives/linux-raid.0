From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: do not overwrite existing devices' symlinks
Date: Mon, 23 Jan 2012 13:06:52 +0100
Message-ID: <20120123120652.20165.47998.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If the device's name is given in /etc/mdadm.conf, create_mddev()
does not check if the map contains a device of this name (mdopen.c:140).
If it does, the symlink of that name will be overwritten.

create_mddev() has been changed. Now it checks if the map contains
a device of the name given in /etc/mdadm.conf.
If it does, the appropriate suffix is added to the given name.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 mdopen.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index eac1c1f..3078de6 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -147,10 +147,12 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	char *cname;
 	char devname[20];
 	char cbuf[400];
+	struct map_ent *map = NULL;
+	int dev_conflict = 0;
+
 	if (chosen == NULL)
 		chosen = cbuf;
 
-
 	if (autof == 0)
 		autof = ci->autof;
 
@@ -277,17 +279,21 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 	else
 		sprintf(devname, "/dev/md%d", num);
 
-	if (cname[0] == 0 && name) {
+	if ((cname[0] != 0) && map_by_name(&map, cname))
+		dev_conflict = 1;
+
+	if ((cname[0] == 0 && name) || dev_conflict) {
 		/* Need to find a name if we can
 		 * We don't completely trust 'name'.  Truncate to
 		 * reasonable length and remove '/'
 		 */
 		char *cp;
-		struct map_ent *map = NULL;
 		int conflict = 1;
 		int unum = 0;
 		int cnlen;
-		strncpy(cname, name, 200);
+
+		if (!dev_conflict)
+			strncpy(cname, name, 200);
 		cname[200] = 0;
 		while ((cp = strchr(cname, '/')) != NULL)
 			*cp = '-';
@@ -312,7 +318,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 		}
 	}
 
-	if (dev && dev[0] == '/')
+	if ((dev && dev[0] == '/') && (!dev_conflict))
 		strcpy(chosen, dev);
 	else if (cname[0] == 0)
 		strcpy(chosen, devname);

