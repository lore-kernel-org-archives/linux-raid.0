Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED23176255
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978085; cv=none; b=f6SWPrdDUiwaLpHtNelxtQZGBeAsiKF4wr75hyObxPwgEesVos2/OwBfVWwFhe3K06xaJGKn4GyLAItB1X0zZc4uxXQmAC5qxcSXYa8IdhW5KlKdIdeNuFmwbeMcfbjtrlA3QxrBWMwHSov/A/enm00ffjLD0aQmC7WpO5CtyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978085; c=relaxed/simple;
	bh=IlO+U7VohfoLf89LPR5XJ50biir8krIRhEaYnyuKfV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nNaYjt/Bjgsm9dGi18BIt7oyIWuHTt65GNIb4fSTBKibS3yvb6sCS2XWaQPbiQ2wmMQLTalhYhCw9zuoDleOfPbm9udHOxsnquhZYzw19e/yi/SKhO2NATztNuSdy+6lp53xfvMyDenbIExZlMsQEKMVaGSqnuCHTxAvUVZIek4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EM2Kh1bS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EM2Kh1bS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uavE+59TdFA2XJpXArYke+vPgatIoUtCCehLUla01BE=;
	b=EM2Kh1bS7M7vfiFzOcOQAJx0pyBliQO8pWRuyyrWX/fuRtz9lbSucwx1eu2F3fnpf837YX
	4WNqV35XfpB2vrjzL16n19G7ghn0sFYOZKPEezCLZGzYz/wfxyY/4f9/dzoFHnv4VJhzOa
	CUs09H5+4XN5yUAv3+VCBKLo7GVQkco=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-kJ4V07_kP7SRe-Quaz1CuA-1; Fri,
 26 Jul 2024 03:14:37 -0400
X-MC-Unique: kJ4V07_kP7SRe-Quaz1CuA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8C071955D53;
	Fri, 26 Jul 2024 07:14:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2C14819560AE;
	Fri, 26 Jul 2024 07:14:33 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 04/14] mdadm/Incremental: fix coverity issues.
Date: Fri, 26 Jul 2024 15:14:06 +0800
Message-Id: <20240726071416.36759-5-xni@redhat.com>
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

There are two issues PW.PARAMETER_HIDDEN (declaration hides
parameter 'devname') and INTEGER_OVERFLOW.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Incremental.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 83db071214ee..33e6814de9d0 100644
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
+		char *dev_path_name = NULL;
 		unsigned long long devsectors;
 		char *pathlist[2];
 
@@ -1142,14 +1142,14 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		domain_free(domlist);
 		domlist = NULL;
 
-		if (asprintf(&devname, "/dev/disk/by-path/%s", de->d_name) != 1) {
-			devname = NULL;
+		if (asprintf(&dev_path_name, "/dev/disk/by-path/%s", de->d_name) != 1) {
+			dev_path_name = NULL;
 			goto next;
 		}
-		fd = open(devname, O_RDONLY);
+		fd = open(dev_path_name, O_RDONLY);
 		if (fd < 0)
 			goto next;
-		if (get_dev_size(fd, devname, &devsectors) == 0)
+		if (get_dev_size(fd, dev_path_name, &devsectors) == 0)
 			goto next;
 		devsectors >>= 9;
 
@@ -1188,8 +1188,8 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		if (chosen == NULL || chosen_size < info.component_size) {
 			chosen_size = info.component_size;
 			free(chosen);
-			chosen = devname;
-			devname = NULL;
+			chosen = dev_path_name;
+			dev_path_name = NULL;
 			if (chosen_st) {
 				chosen_st->ss->free_super(chosen_st);
 				free(chosen_st);
@@ -1199,7 +1199,7 @@ static int partition_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		}
 
 	next:
-		free(devname);
+		free(dev_path_name);
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
2.32.0 (Apple Git-132)

