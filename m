From: Jes.Sorensen@redhat.com
Subject: [PATCH 15/19] Manage_runstop(): Avoid memory leak
Date: Tue,  1 Nov 2011 16:09:31 +0100
Message-ID: <1320160175-18976-16-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Manage.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/Manage.c b/Manage.c
index 39a9b20..d5110a7 100644
--- a/Manage.c
+++ b/Manage.c
@@ -183,6 +183,7 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 	 * quiet < 0 means we will try again if it fails.
 	 */
 	mdu_param_t param; /* unused */
+	int rv = 0;
 
 	if (runstop == -1 && md_get_version(fd) < 9000) {
 		if (ioctl(fd, STOP_MD, 0)) {
@@ -261,7 +262,8 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 				fprintf(stderr, Name
 					": failed to stop array %s: %s\n",
 					devname, strerror(errno));
-				return 1;
+				rv = 1;
+				goto out;
 			}
 
 			/* Give monitor a chance to act */
@@ -273,7 +275,8 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 					": failed to completely stop %s"
 					": Device is busy\n",
 					devname);
-				return 1;
+				rv = 1;
+				goto out;
 			}
 		} else if (mdi &&
 			   mdi->array.major_version == -1 &&
@@ -301,9 +304,8 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 							"member %s still active\n",
 							devname, m->dev);
 					free_mdstat(mds);
-					if (mdi)
-						sysfs_free(mdi);
-					return 1;
+					rv = 1;
+					goto out;
 				}
 		}
 
@@ -328,9 +330,8 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 						"process, mounted filesystem "
 						"or active volume group?\n");
 			}
-			if (mdi)
-				sysfs_free(mdi);
-			return 1;
+			rv = 1;
+			goto out;
 		}
 		/* prior to 2.6.28, KOBJ_CHANGE was not sent when an md array
 		 * was stopped, so We'll do it here just to be sure.  Drop any
@@ -355,8 +356,11 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
 		map_lock(&map);
 		map_remove(&map, devnum);
 		map_unlock(&map);
+	out:
+		if (mdi)
+			sysfs_free(mdi);
 	}
-	return 0;
+	return rv;
 }
 
 int Manage_resize(char *devname, int fd, long long size, int raid_disks)
-- 
1.7.6.4

