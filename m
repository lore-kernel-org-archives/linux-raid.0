From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 05/13] sysfs: simple write to sysfs file
Date: Thu, 22 Apr 2010 23:11:48 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3B9@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Patch adds a simple mechanism to write a value to sysfs file giving its
full path. Existing methods need eg. mdinfo available what is not always necessary/available.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 mdadm.h |    1 +
 sysfs.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 402a8c6..304378a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -419,6 +419,7 @@ extern int sysfs_attr_match(const char *attr, const char *str);
 extern int sysfs_match_word(const char *word, char **list);
 extern int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val);
+extern int sysfs_set_str_simple(char *fname, char *val);
 extern int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, unsigned long long val);
 extern int sysfs_uevent(struct mdinfo *sra, char *event);
diff --git a/sysfs.c b/sysfs.c
index ebf9d8a..a2353d9 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -413,6 +413,27 @@ int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 	return 0;
 }
 
+int sysfs_set_str_simple(char *fname, char *val)
+{
+	int n;
+	int fd;
+
+	if (!fname || !val)
+		return 1;
+
+	fd = open(fname, O_WRONLY | O_NONBLOCK);
+	if (fd < 0)
+		return -1;
+	n = write(fd, val, strlen(val));
+	close(fd);
+	if (n != strlen(val)) {
+		dprintf(Name ": failed to write '%s' to '%s' (%s)\n",
+			val, fname, strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
 int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
 		  char *name, unsigned long long val)
 {
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


