From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 3/3] Assemble loose imsm spares.
Date: Thu, 23 Dec 2010 15:13:48 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E5CFBA3@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 93a06ce304e80ad8d4956a87203fc8c084f2c384 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 23 Dec 2010 12:29:52 +0100
Subject: [PATCH 3/3] Assemble loose imsm spares.
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

All imsm spares (uuid=0:0:0:0) that do not match any array
will fall into spares_imsm container in auto assembly mode.
This also applies when there is no config file. Previously
no spares were assembled as there were no domains defined in such case.

When assembling spare container we don't look at domains.
Spares assembled on their own need to be considered uptodate.
Spares do not set st because it prevents auto assembly of subarrays,
so when assebling spare container we will use superblock of first spare.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Assemble.c |   20 +++++++++++++++++++-
 mdadm.c    |   12 ++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 4b8ab5c..e6da702 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -553,6 +553,22 @@ int Assemble(struct supertype *st, char *mddev,
 		struct stat stb;
 		if (tmpdev->used != 3)
 			continue;
+		/* If assembling spare container don't look at domains */
+		if (ident->uuid_set &&
+		    !memcmp(ident->uuid, uuid_zero, sizeof(int[4]))) {
+			tmpdev->used = 1;
+			content=&info;
+			if (!st->sb) {
+				/* we need sb from one of the spares */
+				int dfd = dev_open(tmpdev->devname, O_RDONLY);
+				if (dfd < 0 ||
+				    st->ss->load_super(st, dfd, NULL))
+					tmpdev->used = 2;
+				if (dfd > 0)
+					close(dfd);
+			}
+			continue;
+		}
 		if (stat(tmpdev->devname, &stb)< 0) {
 			fprintf(stderr, Name ": fstat failed for %s: %s\n",
 				tmpdev->devname, strerror(errno));
@@ -883,8 +899,10 @@ int Assemble(struct supertype *st, char *mddev,
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
diff --git a/mdadm.c b/mdadm.c
index 2ffe94f..d4c0ad4 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1350,6 +1350,18 @@ int main(int argc, char *argv[])
 				fprintf(stderr, Name ": No arrays found in config file\n");
 				rv = 1;
 			}
+			/* Try to assemble container with spares */
+			ident.uuid_set = 1;
+			memset(ident.uuid, 0, sizeof(int[4]));
+			if (!ss)
+				ss = super_imsm.match_metadata_desc("imsm");
+			if (Assemble(ss, "spares_imsm", &ident,
+				     NULL, backup_file, invalid_backup,
+				     readonly, runstop, update,
+				     homehost, require_homehost,
+				     verbose-quiet, force) == 0)
+				rv = 0;
+			free(ss);
 		}
 		break;
 	case BUILD:
-- 
1.7.1

