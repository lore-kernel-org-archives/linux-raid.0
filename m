Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DFE22EF4
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028986; cv=none; b=jCq0HvuhbHWFe33qOk996Sc/j3OejKwj25e/NBP4scL9AmrEFaMUoX8bxnJdSB6vlt84c+cHltM2kfeZIb8POhe+HBgtqoQhB2yCQ3QaXusuQ2+PFLZ34Sv0jzmsQGIL+lt41gxadozzsYST5L0MvAYONOZEdhTh0Wx01UynvJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028986; c=relaxed/simple;
	bh=nlrmSKLWr1SyN8Sl8qyvVsgDkmwcac7qgoRWs/HQjhM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M67j5RPfj38ssLQ3tWhce+eQpU6APG5LzzFEDHctvLU107aKElMZ5kccPjoVtFylk5zCtL0gSZCnx/DflObhyI73LJkzWM0LVYzbQMc4lQa2eEuTT8qPbd5dfxeIv71Pcws6ragCjjKFgGkcHnecB8OTb4BtoMAhajXeJWjnXYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PvUsxFjf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PvUsxFjf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721028983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KRDUCZjDAzEW7/IayESWkRmLOJklcsR1oBMPDxBBPdc=;
	b=PvUsxFjffBsOe8gVCLWcmqO0PaMRj0HCt4+yypMOgYhQ4pVrPziVoSFjHsbZ9fm53oz5Ip
	1uUCRiwEG47W/v9gHhTQ4MZefzKHjxsNvBT5qOvtkVGtoluR7CBrCTlu0VNpiwpcdYMqwB
	+BwRpOzAN+uk2cn2K8NYpPOLvFQmiSQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-StsmyDBMMFiy9fC9boI_-A-1; Mon,
 15 Jul 2024 03:36:17 -0400
X-MC-Unique: StsmyDBMMFiy9fC9boI_-A-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73C8F1955D5E;
	Mon, 15 Jul 2024 07:36:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E7C581955D42;
	Mon, 15 Jul 2024 07:36:13 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 02/15] mdadm/Grow: fix coverity issue CHECKED_RETURN
Date: Mon, 15 Jul 2024 15:35:51 +0800
Message-Id: <20240715073604.30307-3-xni@redhat.com>
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

