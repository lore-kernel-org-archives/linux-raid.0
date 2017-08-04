From: NeilBrown <neilb@suse.com>
Subject: [PATCH 1/4] Error messages should end with a newline character.
Date: Fri, 04 Aug 2017 15:30:02 +1000
Message-ID: <150182460218.25561.3726334188052988614.stgit@noble>
References: <150182450644.25561.9683614144764209335.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150182450644.25561.9683614144764209335.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add "\n" to the end of error messages which don't already
have one.  Also spell "opened" correctly.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 Build.c  |    4 ++--
 Grow.c   |    4 ++--
 Manage.c |    2 +-
 mdopen.c |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Build.c b/Build.c
index 70ba06843796..962c2e3776b9 100644
--- a/Build.c
+++ b/Build.c
@@ -181,7 +181,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 			int major = BITMAP_MAJOR_HI;
 #if 0
 			if (s->bitmap_chunk == UnSet) {
-				pr_err("%s cannot be openned.", s->bitmap_file);
+				pr_err("%s cannot be opened.\n", s->bitmap_file);
 				goto abort;
 			}
 #endif
@@ -193,7 +193,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 			}
 			bitmap_fd = open(s->bitmap_file, O_RDWR);
 			if (bitmap_fd < 0) {
-				pr_err("%s cannot be openned.", s->bitmap_file);
+				pr_err("%s cannot be opened.\n", s->bitmap_file);
 				goto abort;
 			}
 		}
diff --git a/Grow.c b/Grow.c
index 4ecb1d8449ae..9305db6b6df4 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3183,7 +3183,7 @@ static int reshape_array(char *container, int fd, char *devname,
 
 		if (info2) {
 			if (sysfs_init(info2, fd, st->devnm)) {
-				pr_err("unable to initialize sysfs for %s",
+				pr_err("unable to initialize sysfs for %s\n",
 				       st->devnm);
 				free(info2);
 				goto release;
@@ -5127,7 +5127,7 @@ int Grow_continue_command(char *devname, int fd,
 		}
 
 		if (sysfs_init(content, fd2, mdstat->devnm)) {
-			pr_err("Unable to initialize sysfs for %s, Grow cannot continue",
+			pr_err("Unable to initialize sysfs for %s, Grow cannot continue.\n",
 			       mdstat->devnm);
 			ret_val = 1;
 			close(fd2);
diff --git a/Manage.c b/Manage.c
index 04b9398c2e4f..6b6112f7abc9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1423,7 +1423,7 @@ int Manage_subdevs(char *devname, int fd,
 			}
 			add_devlist = conf_get_devs();
 			if (add_devlist == NULL) {
-				pr_err("no devices to scan for missing members.");
+				pr_err("no devices to scan for missing members.\n");
 				continue;
 			}
 			for (dp = &add_devlist; *dp; dp = & (*dp)->next)
diff --git a/mdopen.c b/mdopen.c
index c4f1c12c2dcd..3c0052f2db23 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -198,7 +198,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 			return -1;
 		}
 		if (cname[0] == 0) {
-			pr_err("%s is an invalid name for an md device (empty!).", dev);
+			pr_err("%s is an invalid name for an md device (empty!).\n", dev);
 			return -1;
 		}
 		if (num < 0) {


