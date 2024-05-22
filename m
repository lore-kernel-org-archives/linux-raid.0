Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9729946522
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367870; cv=none; b=UoFIaUsW+xL39e/3+o/QVD2Fmjn5gHUwbYldXPhLoM/zK3b+mDRVtxK4ix2QeO4fazL9uOpUj1NqeTos6VF5r1nxhn8BtWMzG9IpC3QI/4dqaop1jb6dbfRtHoZ+ejf6koSsJVeoBjbPKERR5ETLBd6uxF6KGHl/+zT5vdwWouM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367870; c=relaxed/simple;
	bh=Qcc7jICJqMRBE+LMXdOfMb7w0nRbJvUxn7pgMvEe+9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rT0EixWctGBQ0rGAd8sB9sxXYlPoSbqDRILJ1SMvUHzP47Uq54yJO1wOqs2QehAx4KxBmy8RmcmffTP3fkHQer4p//6zXv4+0FtnpcXk+yaX+jGFvVPLPMnwic44dEeI2kc2PIovO6efXJfCAkFvjbytJCocNPGP7sV/xMNWU7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G802Z7hN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G802Z7hN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XkTS2orXNgaZRm+RPcvf2QgflS7N1q7aEo4BAOLTF0U=;
	b=G802Z7hNZtsWly3GhmpvZvFCuG9cb5zLl6mLdMHLhHFvnjbKqab+HX+PPjpXMK/HvlAc2y
	lksoDIBj7UHutJcl/TUYyeYWAMAUxYeB2UOm3wqtqI3IDSu/Bhc2Ve3yQ9BkBmEi6bRXDx
	b6WYGgh0LFxbSmXR4m4zWmm1+UgjHSQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-8VCWnn4lMJW7MiGnq1xcGw-1; Wed, 22 May 2024 04:51:04 -0400
X-MC-Unique: 8VCWnn4lMJW7MiGnq1xcGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FD2E812296;
	Wed, 22 May 2024 08:51:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8BF2C15BB1;
	Wed, 22 May 2024 08:51:01 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 01/19] Change some error messages to info level
Date: Wed, 22 May 2024 16:50:38 +0800
Message-Id: <20240522085056.54818-2-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

These logs are not error logs. Change them to info level.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Assemble.c | 16 ++++++----------
 Manage.c   |  2 +-
 util.c     |  4 ++--
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 83dced19ceba..65cdb737382a 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1209,23 +1209,19 @@ static int start_array(int mdfd,
 		if (rv == 0) {
 			sysfs_rules_apply(mddev, content);
 			if (c->verbose >= 0) {
-				pr_err("%s has been started with %d drive%s",
+				pr_info("%s has been started with %d drive%s",
 				       mddev, okcnt, okcnt==1?"":"s");
 				if (okcnt < (unsigned)content->array.raid_disks)
-					fprintf(stderr, " (out of %d)",
-						content->array.raid_disks);
+					printf(" (out of %d)", content->array.raid_disks);
 				if (rebuilding_cnt)
-					fprintf(stderr, "%s %d rebuilding",
-						sparecnt?",":" and",
+					printf("%s %d rebuilding", sparecnt?",":" and",
 						rebuilding_cnt);
 				if (sparecnt)
-					fprintf(stderr, " and %d spare%s",
-						sparecnt,
+					printf(" and %d spare%s", sparecnt,
 						sparecnt == 1 ? "" : "s");
 				if (content->journal_clean)
-					fprintf(stderr, " and %d journal",
-						journalcnt);
-				fprintf(stderr, ".\n");
+					printf(" and %d journal", journalcnt);
+				printf(".\n");
 			}
 			if (content->reshape_active &&
 			    is_level456(content->array.level)) {
diff --git a/Manage.c b/Manage.c
index 96e5ee5427a2..5db72b778fbe 100644
--- a/Manage.c
+++ b/Manage.c
@@ -463,7 +463,7 @@ done:
 	}
 
 	if (verbose >= 0)
-		pr_err("stopped %s\n", devname);
+		pr_info("stopped %s\n", devname);
 	map_lock(&map);
 	map_remove(&map, devnm);
 	map_unlock(&map);
diff --git a/util.c b/util.c
index bf79742fe44e..48c97545a42a 100644
--- a/util.c
+++ b/util.c
@@ -633,9 +633,9 @@ int check_ext2(int fd, char *name)
 	bsize = sb[24]|(sb[25]|(sb[26]|sb[27]<<8)<<8)<<8;
 	size = sb[4]|(sb[5]|(sb[6]|sb[7]<<8)<<8)<<8;
 	size <<= bsize;
-	pr_err("%s appears to contain an ext2fs file system\n",
+	pr_info("%s appears to contain an ext2fs file system\n",
 		name);
-	cont_err("size=%lluK  mtime=%s", size, ctime(&mtime));
+	pr_info("size=%lluK  mtime=%s", size, ctime(&mtime));
 	return 1;
 }
 
-- 
2.32.0 (Apple Git-132)

