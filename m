From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 5/5] Detail: handle non-existent arrays better.
Date: Mon, 27 Mar 2017 14:36:56 +1100
Message-ID: <149058581623.15679.14330532500949622569.stgit@noble>
References: <149058575542.15679.9804611071393072863.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149058575542.15679.9804611071393072863.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you call "mdadm --detail" with a device file for an array which
doesn't exist, such as by
  mknod /dev/md57 b 9 57
  mdadm --detail /dev/md57

you get an unhelpful message about and inactive RAID0, and return
status is '0'.  This is confusing.

So catch this possibility and print a more useful message, and
return a non-zero status.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 Detail.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Detail.c b/Detail.c
index 509b0d418768..d9d1b7092167 100644
--- a/Detail.c
+++ b/Detail.c
@@ -110,6 +110,14 @@ int Detail(char *dev, struct context *c)
 	if (ioctl(fd, GET_ARRAY_INFO, &array) == 0) {
 		inactive = 0;
 	} else if (errno == ENODEV && sra) {
+		if (sra->array.major_version == -1 &&
+		    sra->array.minor_version == -1 &&
+		    sra->devs == NULL) {
+			pr_err("Array associated with md device %s does not exist.\n", dev);
+			close(fd);
+			sysfs_free(sra);
+			return rv;
+		}
 		array = sra->array;
 		inactive = 1;
 	} else {


