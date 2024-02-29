Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB127D06F
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207558; cv=none; b=t9/JA/xTGsLFObYixFheSCrQ0iGga0o+0oOcEQ/VCX6WZ7u9j+++LnVX3IJ9YE64K/f436dIHKPq75zVksu2bFiP9SC+0e3t70pbo2eISzCroivZ2TjrvcyD/C0oS/YuF1nIEBqVfAs3pkEFdLng/hkKmBzTxmEmG2t+Qf3fc60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207558; c=relaxed/simple;
	bh=Vw6chBCx6qae0jSspj3yH2zF30cVjzVC8DoZ6A7FINw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YOZIdCkneaoi5HKCAHEaQ1gPZaDkQTUvkjO/tBWH6meTE9f1YOY+dnQo30CFmbojtMyN48jNL69Rm0dMRPlDiS+yiRIHsRMCtPSTAaHf/771SUa6zX77oIxGC9rPfMMudvVKueV2VU3rhzHj3hWgTqXqj9b+yxlN77DhJu7W5Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ghqZpdTf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ghqZpdTf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207556; x=1740743556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vw6chBCx6qae0jSspj3yH2zF30cVjzVC8DoZ6A7FINw=;
  b=ghqZpdTfHThV2zth0JBfYe0YbQ/2u4oez31vHgQdvqjrlddaFjTN/9MD
   WAFZO1Bz8SZoN6DGPLPVOL1fQoeBKJhDsIJSoNrnA7TZ9A7Tgt6JFq0Aa
   n6ccnTUWZZOCl1vQdBPINvZXE8UituGVow5P3ETzuRWBJB8qtytw5vr19
   xjhrtV3O3UR7Y7pkGGZDcKmwNSMvwWuC4ZPUsHS4NUVI58pzBnaJLbhHg
   aUHRhNnR47SqYTQIm1yTR64V8rlxbqN5Vd+G4NVQXOwqt3+xroqaIPK0/
   iy3U4k9ci4GioFyqeraqv1sRUCAAYP/p6+zWHgIn7OUz3H+zV3UnloYzB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499449"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499449"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754807"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:34 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 04/13] Manage: implement manage_add_external()
Date: Thu, 29 Feb 2024 12:52:08 +0100
Message-Id: <20240229115217.26543-5-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move external add code to separate function. It is easier to control
error path now. Error messages are adjusted.

No functional changes.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Manage.c | 147 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 86 insertions(+), 61 deletions(-)

diff --git a/Manage.c b/Manage.c
index 77b79cf57554..b3e216cbcec6 100644
--- a/Manage.c
+++ b/Manage.c
@@ -695,6 +695,91 @@ skip_re_add:
 	return 0;
 }
 
+/**
+ * manage_add_external() - Add disk to external container.
+ * @st: external supertype pointer, must not be NULL, superblock is released here.
+ * @fd: container file descriptor, must not have O_EXCL mode.
+ * @disk_fd: device to add file descriptor.
+ * @disk_name: name of the device to add.
+ * @disc: disk info.
+ *
+ * Superblock is released here because any open fd with O_EXCL will block sysfs_add_disk().
+ */
+mdadm_status_t manage_add_external(struct supertype *st, int fd, char *disk_name,
+				   mdu_disk_info_t *disc)
+{
+	mdadm_status_t rv = MDADM_STATUS_ERROR;
+	char container_devpath[MD_NAME_MAX];
+	struct mdinfo new_mdi;
+	struct mdinfo *sra = NULL;
+	int container_fd;
+	int disk_fd = -1;
+
+	snprintf(container_devpath, MD_NAME_MAX, "%s", fd2devnm(fd));
+
+	container_fd = open_dev_excl(container_devpath);
+	if (!is_fd_valid(container_fd)) {
+		pr_err("Failed to get exclusive access to container %s\n", container_devpath);
+		return MDADM_STATUS_ERROR;
+	}
+
+	/* Check if metadata handler is able to accept the drive */
+	if (!st->ss->validate_geometry(st, LEVEL_CONTAINER, 0, 1, NULL, 0, 0, disk_name, NULL,
+				       0, 1))
+		goto out;
+
+	Kill(disk_name, NULL, 0, -1, 0);
+
+	disk_fd = dev_open(disk_name, O_RDWR | O_EXCL | O_DIRECT);
+	if (!is_fd_valid(disk_fd)) {
+		pr_err("Failed to exclusively open %s\n", disk_name);
+		goto out;
+	}
+
+	if (st->ss->add_to_super(st, disc, disk_fd, disk_name, INVALID_SECTORS))
+		goto out;
+
+	if (!mdmon_running(st->container_devnm))
+		st->ss->sync_metadata(st);
+
+	sra = sysfs_read(container_fd, NULL, 0);
+	if (!sra) {
+		pr_err("Failed to read sysfs for %s\n", disk_name);
+		goto out;
+	}
+
+	sra->array.level = LEVEL_CONTAINER;
+	/* Need to set data_offset and component_size */
+	st->ss->getinfo_super(st, &new_mdi, NULL);
+	new_mdi.disk.major = disc->major;
+	new_mdi.disk.minor = disc->minor;
+	new_mdi.recovery_start = 0;
+
+	st->ss->free_super(st);
+
+	if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
+		pr_err("Failed to add %s to container %s\n", disk_name, container_devpath);
+		goto out;
+	}
+	ping_monitor(container_devpath);
+	rv = MDADM_STATUS_SUCCESS;
+
+out:
+	close(container_fd);
+
+	if (sra)
+		sysfs_free(sra);
+
+	if (rv != MDADM_STATUS_SUCCESS && is_fd_valid(disk_fd))
+		/* Metadata handler records this descriptor, so release it only on failure. */
+		close(disk_fd);
+
+	if (st->sb)
+		st->ss->free_super(st);
+
+	return rv;
+}
+
 int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	       struct supertype *tst, mdu_array_info_t *array,
 	       int force, int verbose, char *devname,
@@ -966,68 +1051,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	if (dv->failfast == FlagSet)
 		disc.state |= (1 << MD_DISK_FAILFAST);
 	if (tst->ss->external) {
-		/* add a disk
-		 * to an external metadata container */
-		struct mdinfo new_mdi;
-		struct mdinfo *sra;
-		int container_fd;
-		char devnm[32];
-		int dfd;
-
-		strcpy(devnm, fd2devnm(fd));
-
-		container_fd = open_dev_excl(devnm);
-		if (container_fd < 0) {
-			pr_err("add failed for %s: could not get exclusive access to container\n",
-			       dv->devname);
-			tst->ss->free_super(tst);
+		if (manage_add_external(tst, fd, dv->devname, &disc) != MDADM_STATUS_SUCCESS)
 			goto unlock;
-		}
-
-		/* Check if metadata handler is able to accept the drive */
-		if (!tst->ss->validate_geometry(tst, LEVEL_CONTAINER, 0, 1, NULL,
-		    0, 0, dv->devname, NULL, 0, 1)) {
-			close(container_fd);
-			goto unlock;
-		}
-
-		Kill(dv->devname, NULL, 0, -1, 0);
-		dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
-		if (tst->ss->add_to_super(tst, &disc, dfd,
-					  dv->devname, INVALID_SECTORS)) {
-			close(dfd);
-			close(container_fd);
-			goto unlock;
-		}
-		if (!mdmon_running(tst->container_devnm))
-			tst->ss->sync_metadata(tst);
-
-		sra = sysfs_read(container_fd, NULL, 0);
-		if (!sra) {
-			pr_err("add failed for %s: sysfs_read failed\n",
-			       dv->devname);
-			close(container_fd);
-			tst->ss->free_super(tst);
-			goto unlock;
-		}
-		sra->array.level = LEVEL_CONTAINER;
-		/* Need to set data_offset and component_size */
-		tst->ss->getinfo_super(tst, &new_mdi, NULL);
-		new_mdi.disk.major = disc.major;
-		new_mdi.disk.minor = disc.minor;
-		new_mdi.recovery_start = 0;
-		/* Make sure fds are closed as they are O_EXCL which
-		 * would block add_disk */
-		tst->ss->free_super(tst);
-		if (sysfs_add_disk(sra, &new_mdi, 0) != 0) {
-			pr_err("add new device to external metadata failed for %s\n", dv->devname);
-			close(container_fd);
-			sysfs_free(sra);
-			goto unlock;
-		}
-		ping_monitor(devnm);
-		sysfs_free(sra);
-		close(container_fd);
 	} else {
 		tst->ss->free_super(tst);
 		if (ioctl(fd, ADD_NEW_DISK, &disc)) {
-- 
2.35.3

