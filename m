Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C34B4204F
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636324; cv=none; b=cr+kuOJd7hB49PLRxm36ejJypi8TVBGwKfhv8R1tmbl9Mxxhqw1kGqwFUr6fbXgZNj9UK0sawPLuI5MKcMvYg08I1jArNKIGmqZIYYt9WMrMIo3Fxw0O2ZGQK7GTf7Gwfpgi0dNKpbE1fFvjFA6gPe/L8CjRu937Br80KIxRLBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636324; c=relaxed/simple;
	bh=dJcl2i5i2pi5sf5Y91I4ams1vuSc+BZ9eq4FToo9RoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MFzWYkKMEB3Cu/FXlxbkVVlJYzEXuqVZxcCXtGH4yw2loYyxpV00Pkr+LnCdYnqDV6HGY2Y56faKxqNUrdkSTFxi775JDa1AmGAzMBKF5RT2C+AqbOnPXSjC+RTU2Qqo3pRggsDtWXOxodmHXovUU2WJbxcb0SK5eCh6ygiOze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gfjtgd5i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfjtgd5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nsjj+39nqEItGgE3TCdYcb1M8TKpAyzyPskLtoLwQrs=;
	b=gfjtgd5imiQovoMBJI8iKzKkhvALmpvIwh+53P20qtjIMfZYKBMUu4lrefN6cC48JKKvHO
	QCJV3dTLat5vcqQkuDgdNkK0Ni2ZRR6F6TYFOJVg76u3ezjzIbqmMwze/XtNnlQQUetDyO
	tiZFu83JBRuwDsLqWRNlpznxWUdfC5o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-118-_6XPLAe5Ngma2rh-Nvv0Zg-1; Mon,
 22 Jul 2024 04:18:34 -0400
X-MC-Unique: _6XPLAe5Ngma2rh-Nvv0Zg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A99E61955D58;
	Mon, 22 Jul 2024 08:18:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 45167195605F;
	Mon, 22 Jul 2024 08:18:29 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 14/14] mdadm/super1: fix coverity issue RESOURCE_LEAK
Date: Mon, 22 Jul 2024 16:17:36 +0800
Message-Id: <20240722081736.20439-15-xni@redhat.com>
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

Fix resource leak problems in super1.c

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super1.c b/super1.c
index 243eeb1a..9c9c7dd1 100644
--- a/super1.c
+++ b/super1.c
@@ -923,10 +923,12 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
 	offset <<= 9;
 	if (lseek64(fd, offset, 0) < 0) {
 		pr_err("Cannot seek to bad-blocks list\n");
+		free(bbl);
 		return 1;
 	}
 	if (read(fd, bbl, size) != size) {
 		pr_err("Cannot read bad-blocks list\n");
+		free(bbl);
 		return 1;
 	}
 	/* 64bits per entry. 10 bits is block-count, 54 bits is block
@@ -947,6 +949,7 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
 
 		printf("%20llu for %d sectors\n", sector, count);
 	}
+	free(bbl);
 	return 0;
 }
 
-- 
2.41.0

