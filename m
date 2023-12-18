Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A374D1D15F
	for <linux-raid@vger.kernel.org>; Mon, 18 Dec 2023 15:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="URYbrVEE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702911968; x=1734447968;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BKOvrAqbodM7/4Em6LUcEqfQF+GtIO5uZJcAeezJKSo=;
  b=URYbrVEEna8pCy8QHv+aveH+BJLFPbiBzxfUd38Iljjvgp1w+cl6iY9F
   Iq/4lK6FWlGtt0Az5jRzNVEHFIw3bR8whVQjLaAeHDjqlRom0iHuOfPnw
   Uvz6OJinZMB6OjUaZR2Z73VmUptmIQ27UAmsrnqyUE8phOl4lCl6Zpqp6
   /aOeW7VbL4c9fgowKP6YqXYkzM8YYc/ExwL7bySawqqwnICGufvjxUN4n
   HLhPWk0gDlXQZHpHn0h5yvMirTB+sny9du4JCzp+Oizdy9cEoAgBmIwZQ
   vWYszouRDhY0s6tUasmkctP5k6IJm6FbwhNMTUkxEfW19Jfuc+5Fr28yR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="395251485"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="395251485"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 07:06:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="725355136"
X-IronPort-AV: E=Sophos;i="6.04,285,1695711600"; 
   d="scan'208";a="725355136"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orsmga003.jf.intel.com with ESMTP; 18 Dec 2023 07:06:05 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH] Remove all "if zeros"
Date: Mon, 18 Dec 2023 16:03:51 +0100
Message-Id: <20231218150351.10120-1-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No more random encounters of "if zeros".
Remove all "if 0" code blocks.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Assemble.c    |  6 -----
 Detail.c      |  7 ------
 super-intel.c | 28 ----------------------
 super1.c      | 20 ----------------
 sysfs.c       | 66 ---------------------------------------------------
 5 files changed, 127 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 5be58e4066c5..bf3fa291a6e0 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1806,12 +1806,6 @@ try_again:
 					       i, mddev, devices[j].devname);
 			}
 		}
-#if 0
-		if (!(super.disks[i].i.disk.state & (1 << MD_DISK_FAULTY))) {
-			pr_err("devices %d of %s is not marked FAULTY in superblock, but cannot be found\n",
-			       i, mddev);
-		}
-#endif
 	}
 	if (c->force && !clean && !is_container(content->array.level) &&
 	    !enough(content->array.level, content->array.raid_disks,
diff --git a/Detail.c b/Detail.c
index 57ac336fc312..aaa3dd6e0ee7 100644
--- a/Detail.c
+++ b/Detail.c
@@ -603,13 +603,6 @@ int Detail(char *dev, struct context *c)
 		}
 
 		if ((st && st->sb) && (info && info->reshape_active)) {
-#if 0
-This is pretty boring
-			printf("     Reshape pos'n : %llu%s\n",
-			       (unsigned long long) info->reshape_progress << 9,
-			       human_size((unsigned long long)
-					  info->reshape_progress << 9));
-#endif
 			if (info->delta_disks != 0)
 				printf("     Delta Devices : %d, (%d->%d)\n",
 				       info->delta_disks,
diff --git a/super-intel.c b/super-intel.c
index 05d3b0562ea3..589031e317d2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2976,34 +2976,6 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	memcpy(uuid, buf, 4*4);
 }
 
-#if 0
-static void
-get_imsm_numerical_version(struct imsm_super *mpb, int *m, int *p)
-{
-	__u8 *v = get_imsm_version(mpb);
-	__u8 *end = mpb->sig + MAX_SIGNATURE_LENGTH;
-	char major[] = { 0, 0, 0 };
-	char minor[] = { 0 ,0, 0 };
-	char patch[] = { 0, 0, 0 };
-	char *ver_parse[] = { major, minor, patch };
-	int i, j;
-
-	i = j = 0;
-	while (*v != '\0' && v < end) {
-		if (*v != '.' && j < 2)
-			ver_parse[i][j++] = *v;
-		else {
-			i++;
-			j = 0;
-		}
-		v++;
-	}
-
-	*m = strtol(minor, NULL, 0);
-	*p = strtol(patch, NULL, 0);
-}
-#endif
-
 static __u32 migr_strip_blocks_resync(struct imsm_dev *dev)
 {
 	/* migr_strip_size when repairing or initializing parity */
diff --git a/super1.c b/super1.c
index 1da71b98d29e..dfde4629508b 100644
--- a/super1.c
+++ b/super1.c
@@ -544,26 +544,6 @@ static void examine_super1(struct supertype *st, char *homehost)
 		break;
 	}
 	printf("\n");
-#if 0
-	/* This turns out to just be confusing */
-	printf("    Array Slot : %d (", __le32_to_cpu(sb->dev_number));
-	for (i = __le32_to_cpu(sb->max_dev); i > 0 ; i--)
-		if (__le16_to_cpu(sb->dev_roles[i-1]) != MD_DISK_ROLE_SPARE)
-			break;
-	for (d = 0; d < i; d++) {
-		int role = __le16_to_cpu(sb->dev_roles[d]);
-		if (d)
-			printf(", ");
-		if (role == MD_DISK_ROLE_SPARE)
-			printf("empty");
-		else
-			if(role == MD_DISK_ROLE_FAULTY)
-				printf("failed");
-			else
-				printf("%d", role);
-	}
-	printf(")\n");
-#endif
 	printf("   Device Role : ");
 	role = role_from_sb(sb);
 	if (role >= MD_DISK_ROLE_FAULTY)
diff --git a/sysfs.c b/sysfs.c
index 94d02f53a768..decb02b8d80f 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -803,72 +803,6 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
 	return rv;
 }
 
-#if 0
-int sysfs_disk_to_sg(int fd)
-{
-	/* from an open block device, try find and open its corresponding
-	 * scsi_generic interface
-	 */
-	struct stat st;
-	char path[256];
-	char sg_path[256];
-	char sg_major_minor[10];
-	char *c;
-	DIR *dir;
-	struct dirent *de;
-	int major, minor, rv;
-
-	if (fstat(fd, &st))
-		return -1;
-
-	snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device",
-		 major(st.st_rdev), minor(st.st_rdev));
-
-	dir = opendir(path);
-	if (!dir)
-		return -1;
-
-	de = readdir(dir);
-	while (de) {
-		if (strncmp("scsi_generic:", de->d_name,
-			    strlen("scsi_generic:")) == 0)
-			break;
-		de = readdir(dir);
-	}
-	closedir(dir);
-
-	if (!de)
-		return -1;
-
-	snprintf(sg_path, sizeof(sg_path), "%s/%s/dev", path, de->d_name);
-	fd = open(sg_path, O_RDONLY);
-	if (fd < 0)
-		return fd;
-
-	rv = read(fd, sg_major_minor, sizeof(sg_major_minor));
-	close(fd);
-	if (rv < 0 || rv == sizeof(sg_major_minor))
-		return -1;
-	else
-		sg_major_minor[rv - 1] = '\0';
-
-	c = strchr(sg_major_minor, ':');
-	*c = '\0';
-	c++;
-	major = strtol(sg_major_minor, NULL, 10);
-	minor = strtol(c, NULL, 10);
-	snprintf(path, sizeof(path), "/dev/.tmp.md.%d:%d:%d",
-		 (int) getpid(), major, minor);
-	if (mknod(path, S_IFCHR|0600, makedev(major, minor))==0) {
-			fd = open(path, O_RDONLY);
-			unlink(path);
-			return fd;
-	}
-
-	return -1;
-}
-#endif
-
 int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 {
 	/* from an open block device, try to retrieve it scsi_id */
-- 
2.26.2

