Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784CAB64E
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028987; cv=none; b=qbAPYSq/47wxh0YwbntaZB4dyMIDOV8d7bI5UPPknuUfUOGCX34JR2MVGklNJdBwmX3CMAdlayPWx4dlmvdOL2ClTwJYPCyi5wO37djqUliYtcT4vpx+o/+QTu3hZheXQ3ds/a1a7ExABMtLi638wZqVJwMT9+6E1Cs0j5z+WPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028987; c=relaxed/simple;
	bh=9VWZf5s+uzx4tafWyR1OuLWJzY0bKyrd/k+NfVXRGe0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nzCVvgiYmX2biIoBjz2jBjVG5KLvd56vGiFWgs5XYGOAGMx+dbYpK/YPc2oZVY/w1FO4PssPi9yA9XNrfLEfeZtq8+STzgRam+5IdsXB97hUWiY6yf3FIHqQ/g4h2dTFBzHiDkCCJSPOiMCN4EX0uh1zgJ3+IlYlKo3wiEDScN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HFwj1TKE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HFwj1TKE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721028984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6G+MFvNfZqLS/3nuqoEbQHGFcrg04JPY59zile/8xU=;
	b=HFwj1TKEhR1AXWHwCt71EgdTUqPoNUs6dSY2yr7SZznNWN75Atc/xzwU0k4sDBHQX6xMRI
	C7RB68dcPzurMonRuX9gcaM5bGku3beSBXOtmp3gcwhi5CE8LJ5b/iW+3sIMMf1rxr2VWb
	5T8U/XbG46Ytd8B9/GBBUh5U2LsdQCw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-kc3ezngrM--lKqhEzuNzMw-1; Mon,
 15 Jul 2024 03:36:20 -0400
X-MC-Unique: kc3ezngrM--lKqhEzuNzMw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E15451955D4A;
	Mon, 15 Jul 2024 07:36:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6EC511955D44;
	Mon, 15 Jul 2024 07:36:16 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 03/15] mdadm/Grow: fix coverity issue RESOURCE_LEAK
Date: Mon, 15 Jul 2024 15:35:52 +0800
Message-Id: <20240715073604.30307-4-xni@redhat.com>
In-Reply-To: <20240715073604.30307-1-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 53 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7ae967bda067..632be7db8d38 100644
--- a/Grow.c
+++ b/Grow.c
@@ -485,6 +485,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		int bitmap_fd;
 		int d;
 		int max_devs = st->max_devs;
+		int err = 0;
 
 		/* try to load a superblock */
 		for (d = 0; d < max_devs; d++) {
@@ -525,13 +526,14 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			return 1;
 		}
 		if (ioctl(fd, SET_BITMAP_FILE, bitmap_fd) < 0) {
-			int err = errno;
+			err = errno;
 			if (errno == EBUSY)
 				pr_err("Cannot add bitmap while array is resyncing or reshaping etc.\n");
 			pr_err("Cannot set bitmap file for %s: %s\n",
 				devname, strerror(err));
-			return 1;
 		}
+		close(bitmap_fd);
+		return err;
 	}
 
 	return 0;
@@ -3083,6 +3085,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	int done;
 	struct mdinfo *sra = NULL;
 	char buf[SYSFS_MAX_BUF_SIZE];
+	bool located_backup = false;
 
 	/* when reshaping a RAID0, the component_size might be zero.
 	 * So try to fix that up.
@@ -3165,8 +3168,10 @@ static int reshape_array(char *container, int fd, char *devname,
 			goto release;
 		}
 
-		if (!backup_file)
+		if (!backup_file) {
 			backup_file = locate_backup(sra->sys_name);
+			located_backup = true;
+		}
 
 		goto started;
 	}
@@ -3612,15 +3617,15 @@ started:
 			mdstat_wait(30 - (delayed-1) * 25);
 	} while (delayed);
 	mdstat_close();
-	if (check_env("MDADM_GROW_VERIFY"))
-		fd = open(devname, O_RDONLY | O_DIRECT);
-	else
-		fd = -1;
 	mlockall(MCL_FUTURE);
 
 	if (signal_s(SIGTERM, catch_term) == SIG_ERR)
 		goto release;
 
+	if (check_env("MDADM_GROW_VERIFY"))
+		fd = open(devname, O_RDONLY | O_DIRECT);
+	else
+		fd = -1;
 	if (st->ss->external) {
 		/* metadata handler takes it from here */
 		done = st->ss->manage_reshape(
@@ -3632,6 +3637,8 @@ started:
 			fd, sra, &reshape, st, blocks, fdlist, offsets,
 			d - odisks, fdlist + odisks, offsets + odisks);
 
+	if (fd >= 0)
+		close(fd);
 	free(fdlist);
 	free(offsets);
 
@@ -3701,6 +3708,8 @@ out:
 	exit(0);
 
 release:
+	if (located_backup)
+		free(backup_file);
 	free(fdlist);
 	free(offsets);
 	if (orig_level != UnSet && sra) {
@@ -3839,6 +3848,7 @@ int reshape_container(char *container, char *devname,
 			pr_err("Unable to initialize sysfs for %s\n",
 			       mdstat->devnm);
 			rv = 1;
+			close(fd);
 			break;
 		}
 
@@ -4717,6 +4727,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 	unsigned long long *offsets;
 	unsigned long long  nstripe, ostripe;
 	int ndata, odata;
+	int fd, backup_fd = -1;
 
 	odata = info->array.raid_disks - info->delta_disks - 1;
 	if (info->array.level == 6)
@@ -4732,9 +4743,18 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 		 * been used
 		 */
 		old_disks = cnt;
+
+	if (backup_file) {
+		backup_fd = open(backup_file, O_RDONLY);
+		if (backup_fd < 0) {
+			pr_err("Can't open backup file %s : %s\n",
+				backup_file, strerror(errno));
+			return -EINVAL;
+		}
+	}
+
 	for (i=old_disks-(backup_file?1:0); i<cnt; i++) {
 		struct mdinfo dinfo;
-		int fd;
 		int bsbsize;
 		char *devname, namebuf[20];
 		unsigned long long lo, hi;
@@ -4747,12 +4767,9 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 		 * else restore data and update all superblocks
 		 */
 		if (i == old_disks-1) {
-			fd = open(backup_file, O_RDONLY);
-			if (fd<0) {
-				pr_err("backup file %s inaccessible: %s\n",
-					backup_file, strerror(errno));
+			if (backup_fd < 0)
 				continue;
-			}
+			fd = backup_fd;
 			devname = backup_file;
 		} else {
 			fd = fdlist[i];
@@ -4907,6 +4924,8 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 				pr_err("Error restoring backup from %s\n",
 					devname);
 			free(offsets);
+			if (backup_fd >= 0)
+				close(backup_fd);
 			return 1;
 		}
 
@@ -4923,6 +4942,8 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 				pr_err("Error restoring second backup from %s\n",
 					devname);
 			free(offsets);
+			if (backup_fd >= 0)
+				close(backup_fd);
 			return 1;
 		}
 
@@ -4984,8 +5005,14 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 			st->ss->store_super(st, fdlist[j]);
 			st->ss->free_super(st);
 		}
+		if (backup_fd >= 0)
+			close(backup_fd);
 		return 0;
 	}
+
+	if (backup_fd >= 0)
+		close(backup_fd);
+
 	/* Didn't find any backup data, try to see if any
 	 * was needed.
 	 */
-- 
2.32.0 (Apple Git-132)

