From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 2/2] Assemble: allow to assemble spares on their own
Date: Tue, 4 Jan 2011 14:06:30 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759F4E@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From eb737197e6a3a43f6724003900a87410acec9495 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 4 Jan 2011 12:18:18 +0100
Subject: [PATCH 2/2] Assemble: allow to assemble spares on their own
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

If we find spares but no members of given array
we create container with just spares.

This allows auto assemble to pick up all lose imsm spares when there
is no config file.
When there is a valid config file and any array is assembled from it
we don't try auto assembly so we will not assemble spares that don't
match any array.
To remedy this we must add
ARRAY metadata=imsm UUID=00000000:00000000:00000000:00000000
to config file.
This container will include all remaining spares.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Assemble.c |   66 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index ed59e8b..7ea1783 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -554,28 +554,50 @@ int Assemble(struct supertype *st, char *mddev,
 		if (tst)
 			tst->ss->free_super(tst);
 	}
-
+	
+	/* Check if we found some imsm spares but no members */
+	if (!st || !st->sb)
+		for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
+			if (tmpdev->used != 3)
+				continue;
+			tmpdev->used = 1;
+			content = &info;
+			if (!st)
+				st = super_imsm.match_metadata_desc("imsm");
+			if (!st->sb) {
+				/* we need sb from one of the spares */
+				int dfd = dev_open(tmpdev->devname, O_RDONLY);
+				if (dfd < 0 ||
+				    st->ss->load_super(st, dfd, NULL))
+					tmpdev->used = 2;
+				if (dfd > 0)
+					close(dfd);
+			}
+		}
+	else
 	/* Now reject spares that don't match domains of identified members */
-	for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
-		struct stat stb;
-		if (tmpdev->used != 3)
-			continue;
-		if (stat(tmpdev->devname, &stb)< 0) {
-			fprintf(stderr, Name ": fstat failed for %s: %s\n",
-				tmpdev->devname, strerror(errno));
-			tmpdev->used = 2;
-		} else {
-			struct dev_policy *pol = NULL;
-			pol = devnum_policy(stb.st_rdev);
-			if (domain_test(domains, pol, NULL))
-				/* take this spare if domains match */
-				tmpdev->used = 1;
-			else
-				/* if domains don't match mark as unused */
-				tmpdev->used = 0;
-			dev_policy_free(pol);
+		for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
+			struct stat stb;
+			if (tmpdev->used != 3)
+				continue;
+			if (stat(tmpdev->devname, &stb)< 0) {
+				fprintf(stderr, Name ": fstat failed for %s: "
+					"%s\n", tmpdev->devname,
+					strerror(errno));
+				tmpdev->used = 2;
+			} else {
+				struct dev_policy *pol = NULL;
+				pol = devnum_policy(stb.st_rdev);
+				if (domain_test(domains, pol, NULL))
+					/* take this spare if domains match */
+					tmpdev->used = 1;
+				else
+					/* if domains don't match
+					* mark as unused */
+					tmpdev->used = 0;
+				dev_policy_free(pol);
+			}
 		}
-	}
 	domain_free(domains);
 	
 	if (!st || !st->sb || !content)
@@ -890,8 +912,10 @@ int Assemble(struct supertype *st, char *mddev,
 		if (content->array.level != LEVEL_MULTIPATH)
 			if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
 				if (!(devices[j].i.disk.state
-				      & (1<<MD_DISK_FAULTY)))
+				      & (1<<MD_DISK_FAULTY))) {
+					devices[j].uptodate = 1;
 					sparecnt++;
+				}
 				continue;
 			}
 		/* If this devices thinks that 'most_recent' has failed, then
-- 
1.7.1

