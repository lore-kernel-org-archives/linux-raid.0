Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4CF7F7DB
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382760; cv=none; b=o5MAJXlNmJZKwbBn+lIyAvOfYF0DwVG2wF58ICSVA4Yf3vjbyTqUVc4l5jUfXgxbeFAXyPIOo3+1Pym+rxI+U+s5zCocIv77ldgqlLTS5P0PRKWYcWUcSBxb9V4Tnrp3p2pc1wCtNF/yadtxlEsbGX0nDJQDlOwfsj0vw2XobXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382760; c=relaxed/simple;
	bh=Mkuz4aFa3Mt9Eho1ZuS2nqiR4w1jkV+Lmg7ovi2k+/U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lN9ryi0D/i32mFRB4yWlc9EHR4OrEfbNlBtbEn+eBk3GfhwxZLGvmV9nO8SHJdfXO8uffO/ZL20D1sejFvp0/BFYyTsNJDftjlPHK8X0EtVga+wZgeWHMgZqUqINYEWQPNcGYMt5CSeXaF3IqlaLeCoCXLmyD4liScOP20zMlVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jd5f3TTu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jd5f3TTu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z9KniFELSEl/QXFcEm1yd11Q/lhSQ8p3pKQWaroJElo=;
	b=Jd5f3TTuEMJbdvwhQ3pjH9qNODfP0+vSrbE8l/PmqaH+4jwBff240AbhsrcYP+qHeCijvV
	RDhV6ol84QeRoY2qTfuL2Fpr0fg7Ekg6WHCua7560+fNIsdalPNA7R3edG0tZwJ9vooQOC
	+ytk00sL/VYfp0cVzv1qeQz8cziJTV4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-378-A2FrIXznMo2ysXuA3ecoIQ-1; Fri,
 19 Jul 2024 05:52:34 -0400
X-MC-Unique: A2FrIXznMo2ysXuA3ecoIQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEA1719560B0;
	Fri, 19 Jul 2024 09:52:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2757619560B2;
	Fri, 19 Jul 2024 09:52:29 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 02/14] mdadm/Grow: fix coverity issue RESOURCE_LEAK
Date: Fri, 19 Jul 2024 17:52:07 +0800
Message-Id: <20240719095219.9705-3-xni@redhat.com>
In-Reply-To: <20240719095219.9705-1-xni@redhat.com>
References: <20240719095219.9705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7ae967bd..e18f1db0 100644
--- a/Grow.c
+++ b/Grow.c
@@ -530,8 +530,10 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 				pr_err("Cannot add bitmap while array is resyncing or reshaping etc.\n");
 			pr_err("Cannot set bitmap file for %s: %s\n",
 				devname, strerror(err));
+			close_fd(&bitmap_fd);
 			return 1;
 		}
+		close_fd(&bitmap_fd);
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
@@ -3612,15 +3617,13 @@ started:
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
 	if (st->ss->external) {
 		/* metadata handler takes it from here */
 		done = st->ss->manage_reshape(
@@ -3632,6 +3635,8 @@ started:
 			fd, sra, &reshape, st, blocks, fdlist, offsets,
 			d - odisks, fdlist + odisks, offsets + odisks);
 
+	if (fd >= 0)
+		close_fd(&fd);
 	free(fdlist);
 	free(offsets);
 
@@ -3701,6 +3706,8 @@ out:
 	exit(0);
 
 release:
+	if (located_backup)
+		free(backup_file);
 	free(fdlist);
 	free(offsets);
 	if (orig_level != UnSet && sra) {
@@ -3839,6 +3846,7 @@ int reshape_container(char *container, char *devname,
 			pr_err("Unable to initialize sysfs for %s\n",
 			       mdstat->devnm);
 			rv = 1;
+			close_fd(&fd);
 			break;
 		}
 
@@ -4717,6 +4725,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 	unsigned long long *offsets;
 	unsigned long long  nstripe, ostripe;
 	int ndata, odata;
+	int fd, backup_fd = -1;
 
 	odata = info->array.raid_disks - info->delta_disks - 1;
 	if (info->array.level == 6)
@@ -4732,9 +4741,18 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 		 * been used
 		 */
 		old_disks = cnt;
+
+	if (backup_file) {
+		backup_fd = open(backup_file, O_RDONLY);
+		if (!is_fd_valid(backup_fd)) {
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
@@ -4747,12 +4765,9 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 		 * else restore data and update all superblocks
 		 */
 		if (i == old_disks-1) {
-			fd = open(backup_file, O_RDONLY);
-			if (fd<0) {
-				pr_err("backup file %s inaccessible: %s\n",
-					backup_file, strerror(errno));
+			if (!is_fd_valid(backup_fd))
 				continue;
-			}
+			fd = backup_fd;
 			devname = backup_file;
 		} else {
 			fd = fdlist[i];
@@ -4907,6 +4922,8 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 				pr_err("Error restoring backup from %s\n",
 					devname);
 			free(offsets);
+			if (is_fd_valid(backup_fd))
+				close_fd(&backup_fd);
 			return 1;
 		}
 
@@ -4923,6 +4940,8 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 				pr_err("Error restoring second backup from %s\n",
 					devname);
 			free(offsets);
+			if (is_fd_valid(backup_fd))
+				close_fd(&backup_fd);
 			return 1;
 		}
 
@@ -4984,8 +5003,14 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 			st->ss->store_super(st, fdlist[j]);
 			st->ss->free_super(st);
 		}
+		if (is_fd_valid(backup_fd))
+			close_fd(&backup_fd);
 		return 0;
 	}
+
+	if (is_fd_valid(backup_fd))
+		close_fd(&backup_fd);
+
 	/* Didn't find any backup data, try to see if any
 	 * was needed.
 	 */
-- 
2.41.0

