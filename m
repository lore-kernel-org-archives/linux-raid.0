From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 3/4] mdadm/Create:declaring an existing struct within same function
Date: Sat,  1 Apr 2017 20:51:44 +0800
Message-ID: <20170401125145.14440-4-zlliu@suse.com>
References: <20170401125145.14440-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170401125145.14440-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Create:declaring 'struct stat stb' twice within the same
function, rename stb as stb2 when declares 'struct stat'
at the second time.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Create.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Create.c b/Create.c
index e43c1d6..619e68a 100644
--- a/Create.c
+++ b/Create.c
@@ -865,7 +865,7 @@ int Create(struct supertype *st, char *mddev,
 		for (dnum=0, raid_disk_num=0, dv = devlist ; dv ;
 		     dv=(dv->next)?(dv->next):moved_disk, dnum++) {
 			int fd;
-			struct stat stb;
+			struct stat stb2;
 			struct mdinfo *inf = &infos[dnum];
 
 			if (dnum >= total_slots)
@@ -921,9 +921,9 @@ int Create(struct supertype *st, char *mddev,
 							dv->devname);
 						goto abort_locked;
 					}
-					fstat(fd, &stb);
-					inf->disk.major = major(stb.st_rdev);
-					inf->disk.minor = minor(stb.st_rdev);
+					fstat(fd, &stb2);
+					inf->disk.major = major(stb2.st_rdev);
+					inf->disk.minor = minor(stb2.st_rdev);
 				}
 				if (fd >= 0)
 					remove_partitions(fd);
@@ -944,8 +944,8 @@ int Create(struct supertype *st, char *mddev,
 
 				if (!have_container) {
 					/* getinfo_super might have lost these ... */
-					inf->disk.major = major(stb.st_rdev);
-					inf->disk.minor = minor(stb.st_rdev);
+					inf->disk.major = major(stb2.st_rdev);
+					inf->disk.minor = minor(stb2.st_rdev);
 				}
 				break;
 			case 2:
-- 
2.10.2

