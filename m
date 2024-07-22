Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8606C160873
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636275; cv=none; b=gz6qG0R0I5egZGIoxLpA+I0hQIQTysong4jFA6YgFqU8/gaI2phBm1aeBZpBuIS+ofssyU9LBM04n0mFrkx2lqHDVsliw8m23Irck4BbVQOWC2ttU8Hv/m0sTYHzz+2VOZOwKgSMesTH0q1euaHhVNGeb7mwOxFR4KAkaVtaT8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636275; c=relaxed/simple;
	bh=WBdulrMBQlmpN1KmD3HXkX31L3n9xCYEMzvlwB3JXQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VNEvlKX5jrib8N3uCyl1K+svpQ6rsN3I2CV066O4blLbK7NaM0efgNrOHFJPrxbc4JNiitVkHuQP25m9IHbQxAhhU7ZXxJW9fDD3oNGGqIzCdIUwhJ3HvD7Oakd1GC3gq4iji2APXYcDtT0HHv5ZKlVJ0nDJwvSNiLhmfKkWH+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYqWRRAR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYqWRRAR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cax6fCZlZEQqDOQOY2xd6Aq5ZvSyVomwdfsTuW8+2pk=;
	b=ZYqWRRARVgGu9D5kKFWibPHZxalco32Kitbv3hhpf5x6vwwfXrUu5Eq5xqtJtbLNr/iiPK
	DbvJD6cF3Oi/nL8rX2vzsQnV62z4kki50v304mfXUMv4ygfD4r7tpodBJYHOeI6fqg/Jm2
	Eu5MGVgc73KfXrajzF/zqR225a+mycw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-iJccxKEbP6CkAHRzTJ9F5w-1; Mon,
 22 Jul 2024 04:17:46 -0400
X-MC-Unique: iJccxKEbP6CkAHRzTJ9F5w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AA0F1945114;
	Mon, 22 Jul 2024 08:17:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5DD731955D45;
	Mon, 22 Jul 2024 08:17:42 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/3] mdadm/Grow: fix coverity issue CHECKED_RETURN
Date: Mon, 22 Jul 2024 16:17:23 +0800
Message-Id: <20240722081736.20439-2-xni@redhat.com>
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

It needs to check return value when functions have return value.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index b135930d05b8..7ae967bda067 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3261,7 +3261,12 @@ static int reshape_array(char *container, int fd, char *devname,
 					/* This is a spare that wants to
 					 * be part of the array.
 					 */
-					add_disk(fd, st, info2, d);
+					if (add_disk(fd, st, info2, d) < 0) {
+						pr_err("Can not add disk %s\n",
+								d->sys_name);
+						free(info2);
+						goto release;
+					}
 				}
 			}
 			sysfs_free(info2);
@@ -4413,7 +4418,10 @@ static void validate(int afd, int bfd, unsigned long long offset)
 	 */
 	if (afd < 0)
 		return;
-	lseek64(bfd, offset - 4096, 0);
+	if (lseek64(bfd, offset - 4096, 0) < 0) {
+		pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));
+		return;
+	}
 	if (read(bfd, &bsb2, 512) != 512)
 		fail("cannot read bsb");
 	if (bsb2.sb_csum != bsb_csum((char*)&bsb2,
@@ -4444,12 +4452,19 @@ static void validate(int afd, int bfd, unsigned long long offset)
 			}
 		}
 
-		lseek64(bfd, offset, 0);
+		if (lseek64(bfd, offset, 0) < 0) {
+			pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));
+			goto out;
+		}
 		if ((unsigned long long)read(bfd, bbuf, len) != len) {
 			//printf("len %llu\n", len);
 			fail("read first backup failed");
 		}
-		lseek64(afd, __le64_to_cpu(bsb2.arraystart)*512, 0);
+
+		if (lseek64(afd, __le64_to_cpu(bsb2.arraystart)*512, 0) < 0) {
+			pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));
+			goto out;
+		}
 		if ((unsigned long long)read(afd, abuf, len) != len)
 			fail("read first from array failed");
 		if (memcmp(bbuf, abuf, len) != 0)
@@ -4466,15 +4481,25 @@ static void validate(int afd, int bfd, unsigned long long offset)
 			bbuf = xmalloc(abuflen);
 		}
 
-		lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512, 0);
+		if (lseek64(bfd, offset+__le64_to_cpu(bsb2.devstart2)*512, 0) < 0) {
+			pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));
+			goto out;
+		}
 		if ((unsigned long long)read(bfd, bbuf, len) != len)
 			fail("read second backup failed");
-		lseek64(afd, __le64_to_cpu(bsb2.arraystart2)*512, 0);
+		if (lseek64(afd, __le64_to_cpu(bsb2.arraystart2)*512, 0) < 0) {
+			pr_err("lseek64 fails %d:%s\n", errno, strerror(errno));
+			goto out;
+		}
 		if ((unsigned long long)read(afd, abuf, len) != len)
 			fail("read second from array failed");
 		if (memcmp(bbuf, abuf, len) != 0)
 			fail("data2 compare failed");
 	}
+out:
+	free(abuf);
+	free(bbuf);
+	return;
 }
 
 int child_monitor(int afd, struct mdinfo *sra, struct reshape *reshape,
@@ -5033,7 +5058,11 @@ int Grow_continue_command(char *devname, int fd, struct context *c)
 			goto Grow_continue_command_exit;
 		}
 		content = &array;
-		sysfs_init(content, fd, NULL);
+		if (sysfs_init(content, fd, NULL) < 0) {
+			pr_err("sysfs_init fails\n");
+			ret_val = 1;
+			goto Grow_continue_command_exit;
+		}
 		/* Need to load a superblock.
 		 * FIXME we should really get what we need from
 		 * sysfs
-- 
2.32.0 (Apple Git-132)

