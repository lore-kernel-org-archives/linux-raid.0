Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072F5125BA
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636308; cv=none; b=ke7AT5cUzuiWmum6H3aAizELnAxlB+YUgwUAX0R/LDCjBBfkOEGbRLhLz8OoWel/D/+juqkwZ+xM0yyRZF51ixHf1Dom6QiqggTODdn0uR56P5+GpG3e3RHRj4WdEj322ASGwssAFvRfbAwHzpSKwWnwvR7pwVlAZrSb/UXHt4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636308; c=relaxed/simple;
	bh=71cgIz/lOVv/bACkTTf8AXuS29dZrBx6eveht24RqN4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l+llZwt+uy6nlnd8AgGSOR11T/rkm/KVAXWsb2G1jQUQx2FybTNAdJro2i1gPcaoBRHvnFL1EjtWyxPVrwszrxBx8GVlG6E0T9/54OcPEAXZ91yzPtVAB2ti1TrJ82Y5ibe9x6xf5DiJYgDrmiiKLEAxuWaV13/i5x87UvQhHsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONqSoenO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONqSoenO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+R0nRuutItaX6gGXrvCCzatdbIzRNRp+pi8DULEBJl0=;
	b=ONqSoenO9P/p7LG7ybg1Aqf72KiSHiIoAfipKolcW0YvjAAoo53vIJaxISX9ZSjPz1suU5
	d3Lc/MsMgokd/wt3ekoUAIkDAKyzIRYm42eipHrxplgzhBVVQY0V5d6F56WGMKj7U9L3Pk
	Jl8Ay0ohPFYS97Ajs0EGllDN9BfpzXA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-492-yeIWe30xNEqueTIRlBwuMg-1; Mon,
 22 Jul 2024 04:18:23 -0400
X-MC-Unique: yeIWe30xNEqueTIRlBwuMg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 018901955D4A;
	Mon, 22 Jul 2024 08:18:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50F1E195605A;
	Mon, 22 Jul 2024 08:18:19 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 11/14] mdadm/super1: fix coverity issue CHECKED_RETURN
Date: Mon, 22 Jul 2024 16:17:33 +0800
Message-Id: <20240722081736.20439-12-xni@redhat.com>
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

It needs to check return value when functions return value.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/super1.c b/super1.c
index 81d29a65..4e4c7bfd 100644
--- a/super1.c
+++ b/super1.c
@@ -260,7 +260,10 @@ static int aread(struct align_fd *afd, void *buf, int len)
 	n = read(afd->fd, b, iosize);
 	if (n <= 0)
 		return n;
-	lseek(afd->fd, len - n, 1);
+	if (lseek(afd->fd, len - n, 1) < 0) {
+		pr_err("lseek fails\n");
+		return -1;
+	}
 	if (n > len)
 		n = len;
 	memcpy(buf, b, n);
@@ -294,14 +297,20 @@ static int awrite(struct align_fd *afd, void *buf, int len)
 		n = read(afd->fd, b, iosize);
 		if (n <= 0)
 			return n;
-		lseek(afd->fd, -n, 1);
+		if (lseek(afd->fd, -n, 1) < 0) {
+			pr_err("lseek fails\n");
+			return -1;
+		}
 	}
 
 	memcpy(b, buf, len);
 	n = write(afd->fd, b, iosize);
 	if (n <= 0)
 		return n;
-	lseek(afd->fd, len - n, 1);
+	if (lseek(afd->fd, len - n, 1) < 0) {
+		pr_err("lseek fails\n");
+		return -1;
+	}
 	return len;
 }
 
@@ -2667,7 +2676,10 @@ static int locate_bitmap1(struct supertype *st, int fd, int node_num)
 	}
 	if (mustfree)
 		free(sb);
-	lseek64(fd, offset<<9, 0);
+	if (lseek64(fd, offset<<9, 0) < 0) {
+		pr_err("lseek fails\n");
+		ret = -1;
+	}
 	return ret;
 }
 
-- 
2.41.0

