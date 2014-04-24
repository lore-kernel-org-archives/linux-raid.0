From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 02/11] make must_be_container() more selective
Date: Thu, 24 Apr 2014 00:22:27 -0700
Message-ID: <20140424072227.4515.73210.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

Cache configurations in mid-assembly may appear to be a "container" as
they are 0-sized and external.  Teach must_be_container() to look for
"external:<metadata name>" as the container identfier from
<sysfs>/md/metadata_version.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/util.c b/util.c
index afb2bb110f24..93f9200fa4c7 100644
--- a/util.c
+++ b/util.c
@@ -1176,18 +1176,19 @@ int get_dev_size(int fd, char *dname, unsigned long long *sizep)
 }
 
 /* Return true if this can only be a container, not a member device.
- * i.e. is and md device and size is zero
+ * i.e. is and md device and the text_version matches an external
+ * metadata format
  */
 int must_be_container(int fd)
 {
-	unsigned long long size;
-	if (md_get_version(fd) < 0)
+	struct mdinfo *sra = sysfs_read(fd, NULL, GET_VERSION);
+	struct superswitch *ss;
+
+	if (!sra)
 		return 0;
-	if (get_dev_size(fd, NULL, &size) == 0)
-		return 1;
-	if (size == 0)
-		return 1;
-	return 0;
+	ss = version_to_superswitch(sra->text_version);
+	sysfs_free(sra);
+	return ss ? ss->external : 0;
 }
 
 /* Sets endofpart parameter to the last block used by the last GPT partition on the device.

