Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CE0B64E
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029016; cv=none; b=pMR/LkyM5LhQacvxwQ13+nZbmIU/27M0kkM8q3oaMRJXixkdOF4LgBwy5VECVpP+YHHu0gCrFuOrNKsXzEQQCN7ph/7aIq74OjYslCA+aNjm+MSAqInp0Uvd74wEpmCuckVXHiMmpHuCw5TzM9cAZSdYGGDUl0Vtbh891T3Lt2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029016; c=relaxed/simple;
	bh=LQa9di7kzLAhuIlm7z+xPowIoBzwBAcdFe42nYsVqXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UZnvo1F++IfJf16lM+kflb9VB9y+YCHFesaSjKoSn3q4T63jNZJn4rNxLt6ZF1qXN2PZg1O4Hk+pZfMtA5GWNEkidsTIb9OjrP/5c0eU1ZfNsFmonw5oLAI/fraQoXES2gm5w9wc5pY5SqkN2sAzJ0iQYqZTsLRmqDLR8FsLFFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bffU4YO8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bffU4YO8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U2Qr+L4B1EiNvjohhXwl+5lJAApo5oTLfO46DtuWceg=;
	b=bffU4YO89IvDs1O4Ln2khytFs1GNPugFuKUlqx+5jqzrrGVyDbQ8zjVx3mvfEVs9aU0wYq
	8qCTeCRsfu1+e7QOOs3sZWKe8f5jXv6fQxwKhx1a7ZHvgoabD7lYJDc/0iHVqcrv30AZEQ
	hL+3tgfRk0sOlvzCEJS/52SgNnBnphw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-nzpB5RVnO6a9B-kOSefmxA-1; Mon,
 15 Jul 2024 03:36:50 -0400
X-MC-Unique: nzpB5RVnO6a9B-kOSefmxA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9475A1956095;
	Mon, 15 Jul 2024 07:36:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B8CC1955D42;
	Mon, 15 Jul 2024 07:36:46 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 12/15] mdadm/super1: fix coverity issue CHECKED_RETURN
Date: Mon, 15 Jul 2024 15:36:01 +0800
Message-Id: <20240715073604.30307-13-xni@redhat.com>
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

