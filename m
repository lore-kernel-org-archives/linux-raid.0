From: Jes.Sorensen@redhat.com
Subject: [PATCH 12/19] Manage_subdevs(): avoid leaking super
Date: Tue,  1 Nov 2011 16:09:28 +0100
Message-ID: <1320160175-18976-13-git-send-email-Jes.Sorensen@redhat.com>
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
 Manage.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Manage.c b/Manage.c
index 613a549..170af57 100644
--- a/Manage.c
+++ b/Manage.c
@@ -623,10 +623,12 @@ int Manage_subdevs(char *devname, int fd,
 
 			if (add_dev == dv->devname) {
 				if (!get_dev_size(tfd, dv->devname, &ldsize)) {
+					st->ss->free_super(st);
 					close(tfd);
 					return 1;
 				}
 			} else if (!get_dev_size(tfd, NULL, &ldsize)) {
+				st->ss->free_super(st);
 				close(tfd);
 				tfd = -1;
 				continue;
@@ -643,6 +645,7 @@ int Manage_subdevs(char *devname, int fd,
 						"       Add --force is you "
 						"really wan to add this device.\n",
 						add_dev, devname);
+					st->ss->free_super(st);
 					close(tfd);
 					return 1;
 				}
@@ -657,6 +660,7 @@ int Manage_subdevs(char *devname, int fd,
 			    array.major_version == 0 &&
 			    md_get_version(fd)%100 < 2) {
 				close(tfd);
+				st->ss->free_super(st);
 				tfd = -1;
 				if (ioctl(fd, HOT_ADD_DISK,
 					  (unsigned long)stb.st_rdev)==0) {
@@ -707,6 +711,7 @@ int Manage_subdevs(char *devname, int fd,
 				/* FIXME this is a bad test to be using */
 				if (!tst->sb) {
 					close(tfd);
+					st->ss->free_super(st);
 					fprintf(stderr, Name ": cannot load array metadata from %s\n", devname);
 					return 1;
 				}
@@ -716,6 +721,7 @@ int Manage_subdevs(char *devname, int fd,
 				    array_size) {
 					close(tfd);
 					tfd = -1;
+					st->ss->free_super(st);
 					if (add_dev != dv->devname)
 						continue;
 					fprintf(stderr, Name ": %s not large enough to join array\n",
@@ -768,6 +774,7 @@ int Manage_subdevs(char *devname, int fd,
 							if (tfd < 0) {
 								fprintf(stderr, Name ": failed to open %s for"
 									" superblock update during re-add\n", dv->devname);
+								st->ss->free_super(st);
 								return 1;
 							}
 
@@ -790,6 +797,7 @@ int Manage_subdevs(char *devname, int fd,
 							if (rv != 0) {
 								fprintf(stderr, Name ": failed to update"
 									" superblock during re-add\n");
+								st->ss->free_super(st);
 								return 1;
 							}
 						}
@@ -799,11 +807,13 @@ int Manage_subdevs(char *devname, int fd,
 							if (verbose >= 0)
 								fprintf(stderr, Name ": re-added %s\n", add_dev);
 							count++;
+							st->ss->free_super(st);
 							continue;
 						}
 						if (errno == ENOMEM || errno == EROFS) {
 							fprintf(stderr, Name ": add new device failed for %s: %s\n",
 								add_dev, strerror(errno));
+							st->ss->free_super(st);
 							if (add_dev != dv->devname)
 								continue;
 							return 1;
-- 
1.7.6.4

