Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5392176AA6
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978107; cv=none; b=hybkeiL+axQ5n3S96ci+sIJuXskark7eRn25NFpEpeY9DwSTpDApFEGUK29U1FjcMbyhWvUwLvEkgO1ku4b8TV+07H60iQWhJGA3D5puNuX14uaSoDHh6lpQsqXWcE5XdXhEH76w1b6Nr91H9UKPqnTDGFO4hbpTS8qlRzOWVhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978107; c=relaxed/simple;
	bh=j0wHeHb039elOZu9QyGFO448gAmLJa6sVM4nJuWZtAw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e26JRIvIPoW6DtZEbFPLuKsIG+aO40td9tGv2OGw48IuJIEgmShdbDz7sDVBc+c8ybIrJRJz/Mzen9F5XHiuKRE+YEA5Lff82V1OwJcfY8FjoWihr5e6b3lnkmkc9d4MATWdAnFo7vuPNLC0fKGzBgaohbt/I/9rcjVeR4NzEaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iw2HWom+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iw2HWom+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BxPl8nzF5V7PbJr8REGdGugpxR+mGh+huydJAmkEfWU=;
	b=Iw2HWom+av+uMA0gk8kkFc3vPc3ULXWcBQVOnVHofvf9CPSsfgMKGo2OwbsFO/Ss3/IqnM
	xp1gaoBHcUjBmf8GwhqM1RociZtjYCexMGulnQ9uGYCgnZqPTo0UVmCC6c9yiPBj2USbve
	UHo4TfMx2/h25aot+rzvE+DC2e2oyJE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-Q1IY_YueOxOpIBwMrLYaYw-1; Fri,
 26 Jul 2024 03:15:01 -0400
X-MC-Unique: Q1IY_YueOxOpIBwMrLYaYw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8891195609F;
	Fri, 26 Jul 2024 07:14:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3DE531955F6B;
	Fri, 26 Jul 2024 07:14:56 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 11/14] mdadm/super1: fix coverity issue CHECKED_RETURN
Date: Fri, 26 Jul 2024 15:14:13 +0800
Message-Id: <20240726071416.36759-12-xni@redhat.com>
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

It needs to check return value when functions return value.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/super1.c b/super1.c
index 81d29a652f36..4e4c7bfd15ae 100644
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
2.32.0 (Apple Git-132)

