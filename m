Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2988B2727F5
	for <linux-raid@vger.kernel.org>; Thu, 16 Oct 2025 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760616258; cv=none; b=HOLTybHUQqDp6+YqUMlc22m+1BHn5sax8NfL1FYe0g0hMEueX2/ggWZxz2Krw/cqCdK0wOkTF0mwsVbntv8G3kPoPKbZp67V7xjMaJEv5uAQZsc77sFrz0SJJquvmQtas2zEePsDAt6+j5s691FsVqsWNa19iZaZd/NJskJ61bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760616258; c=relaxed/simple;
	bh=q0+TEain4zzUs8UPppcD7v1yAPTfSLi1+UEtefi7cJA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b+pP+BXjtmigibjWhe7944BXfCWP5m+0YUDn6vTQLcxvBBMz3tDdm6IvlThm9cxRJ5lifRYiFUaGF8xu0jVaR46UkrTwDQRAiVOjjFkfB81JTRaxKq9rG/71AmwyVd299uZ7qTCbQtl1wAwB6laejdrG79Poublmg2au+R811N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VK5T7sye; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VK5T7sye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760616255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8uUVYASMOGzHm+oOi7wD443zrWZG5BfC/1LNANGfhPM=;
	b=VK5T7syePHCYCeHXGQOnxRvR5tTbEogAv7W/OmOqYWLdpRTcWtg5VwTJeEG8In20oDxl2X
	yaM8hLOEOaLPctpmDaGz/tKhTjxxMDBv3JpRe4HZzT7pWRjoNDsjRLCd/Y7a1viGj4Nh0J
	xFL2pWw/jNn90VLheSPP8IGdCTMT8oE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-1EmaSav7M0qE4zYsPonMGA-1; Thu,
 16 Oct 2025 08:04:09 -0400
X-MC-Unique: 1EmaSav7M0qE4zYsPonMGA-1
X-Mimecast-MFC-AGG-ID: 1EmaSav7M0qE4zYsPonMGA_1760616248
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C66E1800657;
	Thu, 16 Oct 2025 12:04:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB85E1956056;
	Thu, 16 Oct 2025 12:04:04 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@kernel.org,
	mtkaczyk@kernel.org
Subject: [PATCH 1/1] mdadm: Create array with sync del gendisk mode
Date: Thu, 16 Oct 2025 20:04:01 +0800
Message-Id: <20251016120402.42401-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

kernel patch 9e59d609763f ("md: call del_gendisk in control path") calls
del_gendisk in sync way. After the patch mentioned just now, device node
(/dev/md0 .e.g) will disappear after mdadm --stop command. It resolves the
problem raid can be created again because raid can be created when opening
device node. Then regression tests will be interrupted.

But it causes an error when assembling array which has been fixed by pr182.
But upstream people think it's not right to do so. Because people will
encounter error who using old mdadm version. So in kernel space,
25db5f284fb8 ("md: add legacy_async_del_gendisk mod") is used to fix this
problem. The default is async mode.

We need to set sync mode when creating array to use sync mode to del gendisk.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdadm.h  |  6 ++++++
 mdopen.c | 32 ++++++++++++++++++++------------
 sysfs.c  | 30 ++++++++++++++++++++++++++++++
 util.c   | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+), 12 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 84bd2c915fc2..18847424ad0a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -141,6 +141,8 @@ struct dlm_lksb {
 #define MDMON_DIR "/run/mdadm"
 #endif /* MDMON_DIR */
 
+#define MD_MOD_ASYNC_DEL_GENDISK "legacy_async_del_gendisk"
+
 /* FAILED_SLOTS is where to save files storing recent removal of array
  * member in order to allow future reuse of disk inserted in the same
  * slot for array recovery
@@ -855,6 +857,8 @@ extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   unsigned long long start, unsigned long long length,
 			   char *src_buf);
 extern bool sysfs_is_libata_allow_tpm_enabled(const int verbose);
+extern bool init_md_mod_param(char *buffer, int bsize);
+extern void restore_md_mod_param(char *buffer);
 
 #ifndef Sendmail
 #define Sendmail "/usr/lib/sendmail -t"
@@ -1794,6 +1798,8 @@ extern void set_dlm_hooks(void);
 extern void sleep_for(unsigned int sec, long nsec, bool wake_after_interrupt);
 extern bool is_directory(const char *path);
 extern bool is_file(const char *path);
+extern bool get_md_mod_parameter(const char *name, char *buffer, int bsize);
+extern bool set_md_mod_parameter(const char *name, const char *value);
 extern int s_gethostname(char *buf, int buf_len);
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
diff --git a/mdopen.c b/mdopen.c
index 57252b646137..ffae1df0275e 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -139,7 +139,7 @@ char *find_free_devnm(void)
 int create_mddev(char *dev, char *name, int trustworthy,
 		 char *chosen, int block_udev)
 {
-	int mdfd;
+	int mdfd = -1;
 	struct stat stb;
 	int num = -1;
 	struct createinfo *ci = conf_get_create_info();
@@ -147,6 +147,12 @@ int create_mddev(char *dev, char *name, int trustworthy,
 	char devname[37];
 	char devnm[32];
 	char cbuf[400];
+	char md_mod_param[64];
+
+	if (!init_md_mod_param(md_mod_param, sizeof(md_mod_param))) {
+		pr_err("%s:%d init md module parameters fail\n", __func__, __LINE__);
+		return -1;
+	}
 
 	if (!udev_is_available())
 		block_udev = 0;
@@ -173,7 +179,7 @@ int create_mddev(char *dev, char *name, int trustworthy,
 			    (strcmp(cname, "md") != 0 && strcmp(cname, "md_d") != 0)) {
 				pr_err("%s is an invalid name for an md device.  Try /dev/md/%s\n",
 					dev, dev+5);
-				return -1;
+				goto out;
 			}
 
 			/* recreate name: /dev/md/0 or /dev/md/d0 */
@@ -186,11 +192,11 @@ int create_mddev(char *dev, char *name, int trustworthy,
 		 */
 		if (strchr(cname, '/') != NULL) {
 			pr_err("%s is an invalid name for an md device.\n", dev);
-			return -1;
+			goto out;
 		}
 		if (cname[0] == 0) {
 			pr_err("%s is an invalid name for an md device (empty!).\n", dev);
-			return -1;
+			goto out;
 		}
 		if (num < 0) {
 			/* If cname  is 'N' or 'dN', we get dev number
@@ -283,7 +289,7 @@ int create_mddev(char *dev, char *name, int trustworthy,
 	if (num < 0 && cname && ci->names) {
 		sprintf(devnm, "md_%s", cname);
 		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
-			return -1;
+			goto out;
 		if (!create_named_array(devnm)) {
 			devnm[0] = 0;
 			udev_unblock();
@@ -292,7 +298,7 @@ int create_mddev(char *dev, char *name, int trustworthy,
 	if (num >= 0) {
 		sprintf(devnm, "md%d", num);
 		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
-			return -1;
+			goto out;
 		if (!create_named_array(devnm)) {
 			devnm[0] = 0;
 			udev_unblock();
@@ -305,7 +311,7 @@ int create_mddev(char *dev, char *name, int trustworthy,
 
 			if (!_devnm) {
 				pr_err("No avail md devices - aborting\n");
-				return -1;
+				goto out;
 			}
 			strcpy(devnm, _devnm);
 		} else {
@@ -313,11 +319,11 @@ int create_mddev(char *dev, char *name, int trustworthy,
 			if (mddev_busy(devnm)) {
 				pr_err("%s is already in use.\n",
 				       dev);
-				return -1;
+				goto out;
 			}
 		}
 		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
-			return -1;
+			goto out;
 		create_named_array(devnm);
 	}
 
@@ -340,14 +346,14 @@ int create_mddev(char *dev, char *name, int trustworthy,
 			    stb.st_rdev != devnm2devid(devnm)) {
 				pr_err("%s exists but looks wrong, please fix\n",
 					devname);
-				return -1;
+				goto out;
 			}
 		} else {
 			if (mknod(devname, S_IFBLK|0600,
 				  devnm2devid(devnm)) != 0) {
 				pr_err("failed to create %s\n",
 					devname);
-				return -1;
+				goto out;
 			}
 			if (chown(devname, ci->uid, ci->gid))
 				perror("chown");
@@ -356,7 +362,7 @@ int create_mddev(char *dev, char *name, int trustworthy,
 			if (stat(devname, &stb) < 0) {
 				pr_err("failed to stat %s\n",
 						devname);
-				return -1;
+				goto out;
 			}
 			add_dev(devname, &stb, 0, NULL);
 		}
@@ -395,6 +401,8 @@ int create_mddev(char *dev, char *name, int trustworthy,
 	if (mdfd < 0)
 		pr_err("unexpected failure opening %s\n",
 			devname);
+out:
+	restore_md_mod_param(md_mod_param);
 	return mdfd;
 }
 
diff --git a/sysfs.c b/sysfs.c
index c030d634b155..44c4ab9e2134 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -1269,3 +1269,33 @@ bool sysfs_is_libata_allow_tpm_enabled(const int verbose)
 		return true;
 	return false;
 }
+
+bool init_md_mod_param(char *buffer, int bsize)
+{
+	bool ret = true;
+
+	/*
+	 * Init md module parameter legacy_async_del_gendisk to N
+	 */
+	if (get_linux_version() >= 6018000) {
+		ret = get_md_mod_parameter(MD_MOD_ASYNC_DEL_GENDISK, buffer, bsize);
+		if (!ret)
+			return ret;
+
+		ret = set_md_mod_parameter(MD_MOD_ASYNC_DEL_GENDISK, "N");
+	}
+
+	return ret;
+}
+
+void restore_md_mod_param(char *buffer)
+{
+	bool ret = true;
+
+	if (get_linux_version() >= 6018000) {
+		ret = set_md_mod_parameter(MD_MOD_ASYNC_DEL_GENDISK, buffer);
+		if (!ret)
+			pr_err("restore %s to %s fail\n", buffer,
+					MD_MOD_ASYNC_DEL_GENDISK);
+	}
+}
diff --git a/util.c b/util.c
index 43d1c119d013..ce6f320e70e3 100644
--- a/util.c
+++ b/util.c
@@ -2557,3 +2557,57 @@ bool is_file(const char *path)
 
 	return true;
 }
+
+bool get_md_mod_parameter(const char *name, char *buffer, int bsize)
+{
+	char path[256];
+	int bytes_read;
+	int fd;
+	int ret = true;
+
+	snprintf(path, sizeof(path), "/sys/module/md_mod/parameters/%s", name);
+
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		pr_err("Can't open %s\n", path);
+		return false;
+	}
+
+	bytes_read = read(fd, buffer, bsize-1);
+	if (bytes_read < 0) {
+		pr_err("Failed to read %s\n", path);
+		ret = false;
+		goto out;
+	}
+
+	buffer[bytes_read] = '\0';
+	if (buffer[bytes_read-1] == '\n')
+		buffer[bytes_read-1] = '\0';
+
+out:
+	close(fd);
+	return ret;
+}
+
+bool set_md_mod_parameter(const char *name, const char *value)
+{
+	char path[256];
+	int fd;
+	bool ret = true;
+
+	snprintf(path, sizeof(path), "/sys/module/md_mod/parameters/%s", name);
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0) {
+		pr_err("Can't open %s\n", path);
+		return false;
+	}
+
+	if (write(fd, value, strlen(value)) != (ssize_t)strlen(value)) {
+		pr_err("Failed to write to %s\n", path);
+		ret = false;
+	}
+
+	close(fd);
+	return ret;
+}
-- 
2.32.0 (Apple Git-132)

