Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DD34204F
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636283; cv=none; b=rjKCXCvLH7nK8QCyDYL7/c/b5niUCtvCHbaNErB5G6aNjsq4EeSDi6bOztiLwzU9Si1BnGs/QiYm9PRz8kCRRrgcw+HM13jLr0fniXMTLNE1CFKym26NxLL5LAgQzJO6SLqnv6ag8mlN1xtBj+PZ/7vOh8vvw/lwtx8GSYZcnrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636283; c=relaxed/simple;
	bh=v5prk+i6MRoyrNFAPDfj2la4ZWsDGRocypupzvhpynU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O5AQoAAfBHUTfRLIOXKMprW53UeSGs5FN7PU9nUF4Bl+EZI64NbSy1keshNBI75I+iRvorfhkx3jiUshlLU15B+8uoRO8rpmN/oS1HhCMdw+pCFB3mXSPUCUV8lEJKXmdrsA9siffbx0JSJFGcm1EGB/Mop221ZXCQZyHvj9MqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RkSiUNME; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RkSiUNME"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZlY+mMta2A3oiEx4NM3RORDbNJbQCIjh4ce7SJj4WE=;
	b=RkSiUNME06nrlwrexf2gPXZsjxGjaBA21jMbD1itMh4UhvabQWYrLUkMVppUOqHW8+3KLZ
	PNJ9abQkVqO7GzDap7JxzxUWRY7JukwLF/QkZY2KDiCbJqt86K+v+v8KLxszF3d6I1stvm
	rhg5NR3o1L8zeX9KL/XRvZed4Y73DUo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-q-wh690aPm-9VsGDupQ6sw-1; Mon,
 22 Jul 2024 04:17:58 -0400
X-MC-Unique: q-wh690aPm-9VsGDupQ6sw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0E821955D47;
	Mon, 22 Jul 2024 08:17:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7AE11195605A;
	Mon, 22 Jul 2024 08:17:55 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 04/14] mdadm/Incremental: fix coverity issues.
Date: Mon, 22 Jul 2024 16:17:26 +0800
Message-Id: <20240722081736.20439-5-xni@redhat.com>
In-Reply-To: <20240722081736.20439-1-xni@redhat.com>
References: <20240722081736.20439-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

There are two issues PW.PARAMETER_HIDDEN and INTEGER_OVERFLOW

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Incremental.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 83db0712..508e2c7c 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -770,7 +770,7 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 			replcnt++;
 		st->ss->free_super(st);
 	}
-	if (max_journal_events >= max_events - 1)
+	if (max_events > 0 && max_journal_events >= max_events - 1)
 		bestinfo->journal_clean = 1;
 
 	if (!avail)
@@ -1113,7 +1113,7 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		int fd = -1;
 		struct mdinfo info;
 		struct supertype *st2 = NULL;
-		char *devname = NULL;
+		char *dev_name = NULL;
 		unsigned long long devsectors;
 		char *pathlist[2];
 
@@ -1142,14 +1142,14 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		domain_free(domlist);
 		domlist = NULL;
 
-		if (asprintf(&devname, "/dev/disk/by-path/%s", de->d_name) != 1) {
-			devname = NULL;
+		if (asprintf(&dev_name, "/dev/disk/by-path/%s", de->d_name) != 1) {
+			dev_name = NULL;
 			goto next;
 		}
-		fd = open(devname, O_RDONLY);
+		fd = open(dev_name, O_RDONLY);
 		if (fd < 0)
 			goto next;
-		if (get_dev_size(fd, devname, &devsectors) == 0)
+		if (get_dev_size(fd, dev_name, &devsectors) == 0)
 			goto next;
 		devsectors >>= 9;
 
@@ -1188,8 +1188,8 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		if (chosen == NULL || chosen_size < info.component_size) {
 			chosen_size = info.component_size;
 			free(chosen);
-			chosen = devname;
-			devname = NULL;
+			chosen = dev_name;
+			dev_name = NULL;
 			if (chosen_st) {
 				chosen_st->ss->free_super(chosen_st);
 				free(chosen_st);
@@ -1199,7 +1199,7 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		}
 
 	next:
-		free(devname);
+		free(dev_name);
 		domain_free(domlist);
 		dev_policy_free(pol2);
 		if (st2)
@@ -1246,7 +1246,7 @@ static int is_bare(int dfd)
 
 	/* OK, first 4K appear blank, try the end. */
 	get_dev_size(dfd, NULL, &size);
-	if (lseek(dfd, size-4096, SEEK_SET) < 0 ||
+	if ((size >= 4096 && lseek(dfd, size-4096, SEEK_SET) < 0) ||
 	    read(dfd, buf, 4096) != 4096)
 		return 0;
 
-- 
2.41.0

