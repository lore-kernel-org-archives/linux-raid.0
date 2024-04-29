Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373715F861
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396065; cv=none; b=qif9eMqnvI9dIihqzvjx91QZ7v6noHA1dudRJmTyEcCVoYtUyCh8xdKo0Frrw5frKw1UbZkIUZuSIeVy3E3oQurToIAxRDoNs6HgMl/eNHzGo3UJfxqHJ0J6SGX7lhWogQALrDlH5rPPUC1l7vqPQ1d4NYwMLZhwFZAJ0YSmHHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396065; c=relaxed/simple;
	bh=yyUkO+f/thE/bRB5h1EKYSShRiZ2mEU6xANVpHuw9zU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I9VYlEnz6e+hQlkUyy+6xozcq+tdrm82mKt8rstmmwB1lXAe3qWy5Z8XHhYz2HPheNlZTxTzJ4x1mLZC1JTbwjGMnRjBqCXYoQw4me2I0IO3IQE5nDsGAHpM0wwX19zhFzlNzh7lvfvxMfkwShOHvGVKTpcGRgpJpLjO6hT51o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OztOBtkp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OztOBtkp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396063; x=1745932063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yyUkO+f/thE/bRB5h1EKYSShRiZ2mEU6xANVpHuw9zU=;
  b=OztOBtkpT+U6oKLB2tosLx2glP4wsw3fSJm1cKQJiTbQoLA3pQUSyCFs
   7byN0J1z9AcZ3kig+qGo1UsU7Ny9O/hk4A+9KxpEdh+e+1u3RiJzLWXUV
   JNiO5+zzfe7+VfkzkRCTofcwmKW19Ex2zlxtKk3QudGvqKArrXn3Dlt8I
   H272tYPb9b6kXMdsFJRU+Ie4iyEgGBH9sAlB7e0dUVwe9kO344Gn0Q9kA
   dXACIe5/284xmrSkJ94gfwstd5ygp88r+7i9GGCvz3Xo/RAJbF5YrD3ig
   jqfe397U896lQD6U2PIesvYELlkoR7bxa4tu1som2gu7BFCz/WCJN/Az9
   Q==;
X-CSE-ConnectionGUID: Piu6eXEQQiaui25obAlV0g==
X-CSE-MsgGUID: ByNeAPHTRvW6ChPuvIaveg==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554406"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554406"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:07:43 -0700
X-CSE-ConnectionGUID: SYd1RZ5BTuOHJ3LLSYiL8g==
X-CSE-MsgGUID: fiqs+Ty+SnSdbIUx5b0E8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609866"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:07:42 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 1/8] mdadm: pass struct context for external reshapes
Date: Mon, 29 Apr 2024 15:07:13 +0200
Message-Id: <20240429130720.260452-2-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429130720.260452-1-mateusz.kusiak@intel.com>
References: <20240429130720.260452-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch alters mutiple functions calls so the context is passed to
external reshape functions.

There are two main reasons behind it:
- reduces number of arguments passed and unifies them,
- imsm code will make use of context in incoming patches.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Assemble.c    |  7 ++----
 Grow.c        | 68 +++++++++++++++++++++------------------------------
 mdadm.c       |  2 +-
 mdadm.h       | 11 +++------
 super-intel.c |  6 ++---
 5 files changed, 37 insertions(+), 57 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index f6c5b99e25e2..f5e9ab1f0853 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1197,9 +1197,7 @@ static int start_array(int mdfd,
 			rv = sysfs_set_str(content, NULL,
 					   "array_state", "readonly");
 			if (rv == 0)
-				rv = Grow_continue(mdfd, st, content,
-						   c->backup_file, 0,
-						   c->freeze_reshape);
+				rv = Grow_continue(mdfd, st, content, 0, c);
 		} else if (c->readonly &&
 			   sysfs_attribute_available(content, NULL,
 						     "array_state")) {
@@ -2180,8 +2178,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 				st->update_tail = &st->updates;
 		}
 
-		err = Grow_continue(mdfd, st, content, c->backup_file,
-				    0, c->freeze_reshape);
+		err = Grow_continue(mdfd, st, content, 0, c);
 	} else switch(content->array.level) {
 		case LEVEL_LINEAR:
 		case LEVEL_MULTIPATH:
diff --git a/Grow.c b/Grow.c
index 074f19956e17..f477b438e810 100644
--- a/Grow.c
+++ b/Grow.c
@@ -864,8 +864,7 @@ static void wait_reshape(struct mdinfo *sra)
 
 static int reshape_super(struct supertype *st, unsigned long long size,
 			 int level, int layout, int chunksize, int raid_disks,
-			 int delta_disks, char *backup_file, char *dev,
-			 int direction, int verbose)
+			 int delta_disks, char *dev, int direction, struct context *c)
 {
 	/* nothing extra to check in the native case */
 	if (!st->ss->external)
@@ -876,9 +875,8 @@ static int reshape_super(struct supertype *st, unsigned long long size,
 		return 1;
 	}
 
-	return st->ss->reshape_super(st, size, level, layout, chunksize,
-				     raid_disks, delta_disks, backup_file, dev,
-				     direction, verbose);
+	return st->ss->reshape_super(st, size, level, layout, chunksize, raid_disks,
+				     delta_disks, dev, direction, c);
 }
 
 static void sync_metadata(struct supertype *st)
@@ -1764,9 +1762,8 @@ static int reshape_container(char *container, char *devname,
 			     int mdfd,
 			     struct supertype *st,
 			     struct mdinfo *info,
-			     int force,
-			     char *backup_file, int verbose,
-			     int forked, int restart, int freeze_reshape);
+			     struct context *c,
+			     int forked, int restart);
 
 /**
  * prepare_external_reshape() - prepares update on external metadata if supported.
@@ -2004,9 +2001,8 @@ int Grow_reshape(char *devname, int fd,
 			goto release;
 		}
 
-		if (reshape_super(st, s->size, UnSet, UnSet, 0, 0, UnSet, NULL,
-				  devname, APPLY_METADATA_CHANGES,
-				  c->verbose > 0)) {
+		if (reshape_super(st, s->size, UnSet, UnSet, 0, 0, UnSet,
+				  devname, APPLY_METADATA_CHANGES, c)) {
 			rv = 1;
 			goto release;
 		}
@@ -2124,10 +2120,8 @@ size_change_error:
 			int err = errno;
 
 			/* restore metadata */
-			if (reshape_super(st, orig_size, UnSet, UnSet, 0, 0,
-					  UnSet, NULL, devname,
-					  ROLLBACK_METADATA_CHANGES,
-					  c->verbose) == 0)
+			if (reshape_super(st, orig_size, UnSet, UnSet, 0, 0, UnSet,
+			                  devname, ROLLBACK_METADATA_CHANGES, c) == 0)
 				sync_metadata(st);
 			pr_err("Cannot set device size for %s: %s\n",
 				devname, strerror(err));
@@ -2338,8 +2332,7 @@ size_change_error:
 		 */
 		close_fd(&fd);
 		rv = reshape_container(container, devname, -1, st, &info,
-				       c->force, c->backup_file, c->verbose,
-				       0, 0, 0);
+				       c, 0, 0);
 		frozen = 0;
 	} else {
 		/* get spare devices from external metadata
@@ -2356,13 +2349,13 @@ size_change_error:
 		}
 
 		/* Impose these changes on a single array.  First
-		 * check that the metadata is OK with the change. */
+		 * check that the metadata is OK with the change.
+		 */
 
 		if (reshape_super(st, 0, info.new_level,
 				  info.new_layout, info.new_chunk,
 				  info.array.raid_disks, info.delta_disks,
-				  c->backup_file, devname,
-				  APPLY_METADATA_CHANGES, c->verbose)) {
+				  devname, APPLY_METADATA_CHANGES, c)) {
 			rv = 1;
 			goto release;
 		}
@@ -3668,9 +3661,8 @@ int reshape_container(char *container, char *devname,
 		      int mdfd,
 		      struct supertype *st,
 		      struct mdinfo *info,
-		      int force,
-		      char *backup_file, int verbose,
-		      int forked, int restart, int freeze_reshape)
+		      struct context *c,
+		      int forked, int restart)
 {
 	struct mdinfo *cc = NULL;
 	int rv = restart;
@@ -3683,8 +3675,7 @@ int reshape_container(char *container, char *devname,
 	    reshape_super(st, 0, info->new_level,
 			  info->new_layout, info->new_chunk,
 			  info->array.raid_disks, info->delta_disks,
-			  backup_file, devname, APPLY_METADATA_CHANGES,
-			  verbose)) {
+			  devname, APPLY_METADATA_CHANGES, c)) {
 		unfreeze(st);
 		return 1;
 	}
@@ -3695,7 +3686,7 @@ int reshape_container(char *container, char *devname,
 	 */
 	ping_monitor(container);
 
-	if (!forked && !freeze_reshape)
+	if (!forked && !c->freeze_reshape)
 		if (continue_via_systemd(container, GROW_SERVICE, NULL))
 			return 0;
 
@@ -3705,7 +3696,7 @@ int reshape_container(char *container, char *devname,
 		unfreeze(st);
 		return 1;
 	default: /* parent */
-		if (!freeze_reshape)
+		if (!c->freeze_reshape)
 			printf("%s: multi-array reshape continues in background\n", Name);
 		return 0;
 	case 0: /* child */
@@ -3802,12 +3793,12 @@ int reshape_container(char *container, char *devname,
 			flush_mdmon(container);
 
 		rv = reshape_array(container, fd, adev, st,
-				   content, force, NULL, INVALID_SECTORS,
-				   backup_file, verbose, 1, restart,
-				   freeze_reshape);
+				   content, c->force, NULL, INVALID_SECTORS,
+				   c->backup_file, c->verbose, 1, restart,
+				   c->freeze_reshape);
 		close(fd);
 
-		if (freeze_reshape) {
+		if (c->freeze_reshape) {
 			sysfs_free(cc);
 			exit(0);
 		}
@@ -4970,8 +4961,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist,
 	return 1;
 }
 
-int Grow_continue_command(char *devname, int fd,
-			  char *backup_file, int verbose)
+int Grow_continue_command(char *devname, int fd, struct context *c)
 {
 	int ret_val = 0;
 	struct supertype *st = NULL;
@@ -5157,7 +5147,7 @@ int Grow_continue_command(char *devname, int fd,
 
 	/* continue reshape
 	 */
-	ret_val = Grow_continue(fd, st, content, backup_file, 1, 0);
+	ret_val = Grow_continue(fd, st, content, 1, c);
 
 Grow_continue_command_exit:
 	if (cfd > -1)
@@ -5171,7 +5161,7 @@ Grow_continue_command_exit:
 }
 
 int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
-		  char *backup_file, int forked, int freeze_reshape)
+		  int forked, struct context *c)
 {
 	int ret_val = 2;
 
@@ -5187,14 +5177,12 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 		st->ss->load_container(st, cfd, st->container_devnm);
 		close(cfd);
 		ret_val = reshape_container(st->container_devnm, NULL, mdfd,
-					    st, info, 0, backup_file, 0,
-					    forked, 1 | info->reshape_active,
-					    freeze_reshape);
+					    st, info, c, forked, 1 | info->reshape_active);
 	} else
 		ret_val = reshape_array(NULL, mdfd, "array", st, info, 1,
-					NULL, INVALID_SECTORS, backup_file,
+					NULL, INVALID_SECTORS, c->backup_file,
 					0, forked, 1 | info->reshape_active,
-					freeze_reshape);
+					c->freeze_reshape);
 
 	return ret_val;
 }
diff --git a/mdadm.c b/mdadm.c
index 3f1912884d49..d18619db86bf 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1636,7 +1636,7 @@ int main(int argc, char *argv[])
 				c.delay = DEFAULT_BITMAP_DELAY;
 			rv = Grow_addbitmap(ident.devname, mdfd, &c, &s);
 		} else if (grow_continue)
-			rv = Grow_continue_command(ident.devname, mdfd, c.backup_file, c.verbose);
+			rv = Grow_continue_command(ident.devname, mdfd, &c);
 		else if (s.size > 0 || s.raiddisks || s.layout_str ||
 			 s.chunk != 0 || s.level != UnSet ||
 			 s.data_offset != INVALID_SECTORS) {
diff --git a/mdadm.h b/mdadm.h
index 2640b39687f7..0ade4bebc400 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1235,9 +1235,8 @@ extern struct superswitch {
 	int (*reshape_super)(struct supertype *st,
 			     unsigned long long size, int level,
 			     int layout, int chunksize, int raid_disks,
-			     int delta_disks, char *backup, char *dev,
-			     int direction,
-			     int verbose); /* optional */
+			     int delta_disks, char *dev, int direction,
+			     struct context *c);
 	int (*manage_reshape)( /* optional */
 		int afd, struct mdinfo *sra, struct reshape *reshape,
 		struct supertype *st, unsigned long blocks,
@@ -1541,8 +1540,7 @@ extern int Grow_reshape(char *devname, int fd,
 extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 			int *fdlist, int cnt, char *backup_file, int verbose);
 extern int Grow_continue(int mdfd, struct supertype *st,
-			 struct mdinfo *info, char *backup_file,
-			 int forked, int freeze_reshape);
+			 struct mdinfo *info, int forked, struct context *c);
 extern int Grow_consistency_policy(char *devname, int fd,
 				   struct context *c, struct shape *s);
 
@@ -1552,8 +1550,7 @@ extern int restore_backup(struct supertype *st,
 			  int spares,
 			  char **backup_filep,
 			  int verbose);
-extern int Grow_continue_command(char *devname, int fd,
-				 char *backup_file, int verbose);
+extern int Grow_continue_command(char *devname, int fd, struct context *c);
 
 extern int Assemble(struct supertype *st, char *mddev,
 		    struct mddev_ident *ident,
diff --git a/super-intel.c b/super-intel.c
index 1faab6077f9e..417da2672504 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -12153,10 +12153,8 @@ exit:
 }
 
 static int imsm_reshape_super(struct supertype *st, unsigned long long size,
-			      int level,
-			      int layout, int chunksize, int raid_disks,
-			      int delta_disks, char *backup, char *dev,
-			      int direction, int verbose)
+			      int level, int layout, int chunksize, int raid_disks,
+			      int delta_disks, char *dev, int direction, struct context *c)
 {
 	int ret_val = 1;
 	struct geo_params geo;
-- 
2.39.2

