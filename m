Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CD2176235
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978077; cv=none; b=f633o5XuCh3qegxBbqwMsy30uhPPxTe0YASrpgmYCp+rUwBdDUrfVyM9PQbeIB9S7U2sLKwCjfsX1oqFjn8SU0mNAVAnbO9Os5m6XQ4VvtwgnWmoeCEf2Tf1c/6Uii0cYDYo8JEYMH/dVcBZUSEsiTyAhRDxUh16A8Mye1yRFcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978077; c=relaxed/simple;
	bh=cSOX5y1/l3UQBicevscDgtDNkzUyHEXhlcSiOUka1VA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kFFRdz/Ri4TuTyxeMlnRRDck4hIAok1CW/KJkIfF+Y4Zf72QNhvgZq3W8yUVbeLs/hZebpxJ64iUJcVM3EdJ5lYdSCGwaZOyFGYQ+1TlY/cwVh2hhAATntLl0H610VZenxHQG8x/qE5pcAmeV8G2/PoS7ryBOT98DViS+Uy9vU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=enV8m+Tz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enV8m+Tz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZbZS+8U930KI0ROygojYwvXETsd6lrIE5jyhVbx7V4=;
	b=enV8m+TztChEBLMIErpbe9EZ+v5tBtKAri1y3SGYgv0q9ip98BtHiv6F7HJ1j33VKTgqDd
	vfZ6d32Uw/mYzs62WpfQFPB7dkPwPWZHcMMXgAc8rafZxBMrFT0fujSFy0tUsEhTtD5biU
	xMM4dQ/QpIVj1UruG9cafy+MTF6/IPU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-542-g3OYB7N-NzewDikYpFDu_A-1; Fri,
 26 Jul 2024 03:14:30 -0400
X-MC-Unique: g3OYB7N-NzewDikYpFDu_A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F05C81955D44;
	Fri, 26 Jul 2024 07:14:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6634319560AE;
	Fri, 26 Jul 2024 07:14:25 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 02/14] mdadm/Grow: fix coverity issue RESOURCE_LEAK
Date: Fri, 26 Jul 2024 15:14:04 +0800
Message-Id: <20240726071416.36759-3-xni@redhat.com>
In-Reply-To: <20240726071416.36759-1-xni@redhat.com>
References: <20240726071416.36759-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix some resource leak problems.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/Grow.c b/Grow.c
index 7ae967bda067..907a6e1b9e22 100644
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
@@ -3632,6 +3635,7 @@ started:
 			fd, sra, &reshape, st, blocks, fdlist, offsets,
 			d - odisks, fdlist + odisks, offsets + odisks);
 
+	close_fd(&fd);
 	free(fdlist);
 	free(offsets);
 
@@ -3701,6 +3705,8 @@ out:
 	exit(0);
 
 release:
+	if (located_backup)
+		free(backup_file);
 	free(fdlist);
 	free(offsets);
 	if (orig_level != UnSet && sra) {
@@ -3839,6 +3845,7 @@ int reshape_container(char *container, char *devname,
 			pr_err("Unable to initialize sysfs for %s\n",
 			       mdstat->devnm);
 			rv = 1;
+			close_fd(&fd);
 			break;
 		}
 
@@ -4717,6 +4724,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 	unsigned long long *offsets;
 	unsigned long long  nstripe, ostripe;
 	int ndata, odata;
+	int fd, backup_fd = -1;
 
 	odata = info->array.raid_disks - info->delta_disks - 1;
 	if (info->array.level == 6)
@@ -4732,9 +4740,18 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
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
@@ -4747,12 +4764,9 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
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
@@ -4907,6 +4921,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 				pr_err("Error restoring backup from %s\n",
 					devname);
 			free(offsets);
+			close_fd(&backup_fd);
 			return 1;
 		}
 
@@ -4923,6 +4938,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 				pr_err("Error restoring second backup from %s\n",
 					devname);
 			free(offsets);
+			close_fd(&backup_fd);
 			return 1;
 		}
 
@@ -4984,8 +5000,12 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 			st->ss->store_super(st, fdlist[j]);
 			st->ss->free_super(st);
 		}
+		close_fd(&backup_fd);
 		return 0;
 	}
+
+	close_fd(&backup_fd);
+
 	/* Didn't find any backup data, try to see if any
 	 * was needed.
 	 */
-- 
2.32.0 (Apple Git-132)

