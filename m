From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH] Check and remove bitmap first when reshape to raid0
Date: Mon, 21 Dec 2015 16:23:49 +0800
Message-ID: <1450686229-6157-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If reshape one raid device with bitmap to raid0, the reshape progress will
start. But it'll fail and lose some components. So it should remove bitmap 
first. 

And it shouldn't close fd when try to call open_dev_excl. Because it's an
input argument. It should be closed in the function who open it. 

There are some places that return(1) directly but don't free subarray and
close cfd in Grow_reshape. So add fallback: to do free(subarray) and 
close(cfd).

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6dfb9c9..f892023 100755
--- a/Grow.c
+++ b/Grow.c
@@ -1591,6 +1591,17 @@ int Grow_reshape(char *devname, int fd,
 		return 1;
 	}
 
+	if (s->level == 0 && array.state & (1<<MD_SB_BITMAP_PRESENT)) {
+                array.state &= ~(1<<MD_SB_BITMAP_PRESENT);
+                if (ioctl(fd, SET_ARRAY_INFO, &array)!= 0) {
+                        if (array.state & (1<<MD_SB_CLUSTERED))
+                                pr_err("failed to remove clustered bitmap.\n");
+                        else
+                                pr_err("failed to remove internal bitmap.\n");
+                        return 1;
+                }
+        }
+
 	/* in the external case we need to check that the requested reshape is
 	 * supported, and perform an initial check that the container holds the
 	 * pre-requisite spare devices (mdmon owns final validation)
@@ -1603,7 +1614,6 @@ int Grow_reshape(char *devname, int fd,
 			cfd = open_dev_excl(st->container_devnm);
 		} else {
 			container = st->devnm;
-			close(fd);
 			cfd = open_dev_excl(st->devnm);
 			fd = cfd;
 		}
@@ -1619,8 +1629,8 @@ int Grow_reshape(char *devname, int fd,
 		if (rv) {
 			pr_err("Cannot read superblock for %s\n",
 				devname);
-			free(subarray);
-			return 1;
+			rv = 1;
+			goto fallback;
 		}
 
 		/* check if operation is supported for metadata handler */
@@ -1644,8 +1654,8 @@ int Grow_reshape(char *devname, int fd,
 					pr_err("cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
 					       devname, container);
 					sysfs_free(cc);
-					free(subarray);
-					return 1;
+					rv = 1;
+					goto fallback;
 				}
 			}
 			sysfs_free(cc);
@@ -1665,7 +1675,8 @@ int Grow_reshape(char *devname, int fd,
 		       s->raiddisks - array.raid_disks,
 		       s->raiddisks - array.raid_disks == 1 ? "" : "s",
 		       array.spare_disks + added_disks);
-		return 1;
+		rv = 1;
+		goto fallback;
 	}
 
 	sra = sysfs_read(fd, NULL, GET_LEVEL | GET_DISKS | GET_DEVS
@@ -1678,17 +1689,20 @@ int Grow_reshape(char *devname, int fd,
 	} else {
 		pr_err("failed to read sysfs parameters for %s\n",
 			devname);
-		return 1;
+		rv = 1;
+		goto fallback;
 	}
 	frozen = freeze(st);
 	if (frozen < -1) {
 		/* freeze() already spewed the reason */
 		sysfs_free(sra);
-		return 1;
+		rv = 1;
+		goto fallback;
 	} else if (frozen < 0) {
 		pr_err("%s is performing resync/recovery and cannot be reshaped\n", devname);
 		sysfs_free(sra);
-		return 1;
+		rv = 1;
+		goto fallback;
 	}
 
 	/* ========= set size =============== */
@@ -2084,6 +2098,11 @@ release:
 	sysfs_free(sra);
 	if (frozen > 0)
 		unfreeze(st);
+fallback:
+	if (cfd > -1)
+		close(cfd);
+	if (subarray)
+		free(subarray);
 	return rv;
 }
 
-- 
2.4.3

