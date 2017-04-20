From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 4/4] Create: tell udev device is not ready when first
 created.
Date: Thu, 20 Apr 2017 12:40:06 +1000
Message-ID: <149265600601.31004.323865505557190368.stgit@noble>
References: <149265560315.31004.3851231165281498425.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149265560315.31004.3851231165281498425.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When an array is created the content is not initializes,
so it could have remnants of an old filesystem or md array
etc on it.
udev will see this and might try to activate it, which is almost
certainly not what is wanted.

So create a temporary udev rules files to set ENV{SYSTEMD_READY}="0"
while the creation event is processed.  This is fairly uniformly
used to suppress actions based on the contents of the device.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 Create.c |    9 +++++++++
 lib.c    |   22 ++++++++++++++++++++++
 mdadm.h  |    2 ++
 3 files changed, 33 insertions(+)

diff --git a/Create.c b/Create.c
index 6ca092449880..915ba6f49fe8 100644
--- a/Create.c
+++ b/Create.c
@@ -605,9 +605,11 @@ int Create(struct supertype *st, char *mddev,
 
 	/* We need to create the device */
 	map_lock(&map);
+	udev_block();
 	mdfd = create_mddev(mddev, name, c->autof, LOCAL, chosen_name);
 	if (mdfd < 0) {
 		map_unlock(&map);
+		udev_unblock();
 		return 1;
 	}
 	/* verify if chosen_name is not in use,
@@ -620,6 +622,7 @@ int Create(struct supertype *st, char *mddev,
 			chosen_name);
 		close(mdfd);
 		map_unlock(&map);
+		udev_unblock();
 		return 1;
 	}
 	mddev = chosen_name;
@@ -1053,9 +1056,15 @@ int Create(struct supertype *st, char *mddev,
 		pr_err("not starting array - not enough devices.\n");
 	}
 	close(mdfd);
+	/* Give udev a moment to process the Change event caused
+	 * by the close.
+	 */
+	usleep(100*1000);
+	udev_unblock();
 	return 0;
 
  abort:
+	udev_unblock();
 	map_lock(&map);
  abort_locked:
 	map_remove(&map, fd2devnm(mdfd));
diff --git a/lib.c b/lib.c
index b640634ef6f2..c38dd7cf1660 100644
--- a/lib.c
+++ b/lib.c
@@ -163,6 +163,28 @@ char *fd2devnm(int fd)
 	return NULL;
 }
 
+/* When we create a new array, we don't want the content to
+ * be immediately examined by udev - it is probably meaningless.
+ * So create /run/udev/rules.d/01-mdadm-create.rules to tell udev
+ * that the device isn't ready.
+ */
+static char udev_path[] = "/run/udev/rules.d/01-mdadm-create.rules";
+void udev_block(void)
+{
+	FILE *f;
+
+	f = fopen(udev_path, "w");
+	if (f) {
+		fputs("KERNEL==\"md*\", ENV{SYSTEMD_READY}=\"0\"\n", f);
+		fclose(f);
+	}
+}
+
+void udev_unblock(void)
+{
+	unlink(udev_path);
+}
+
 /*
  * convert a major/minor pair for a block device into a name in /dev, if possible.
  * On the first call, walk /dev collecting name.
diff --git a/mdadm.h b/mdadm.h
index f1f643c794d4..fa4d71fc91f0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1556,6 +1556,8 @@ extern char *stat2kname(struct stat *st);
 extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 extern char *fd2devnm(int fd);
+extern void udev_block(void);
+extern void udev_unblock(void);
 
 extern int in_initrd(void);
 


