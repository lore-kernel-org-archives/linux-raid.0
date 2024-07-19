Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE3681AB4
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382789; cv=none; b=BsyITDaMMkweJMp9LNwCxtLwsRtlnVl6/ATp3GzObwtdjPkOwUM8YT3QIV3cdwJ3zSPlwICNz8a2ZFXowOMNd3BO8KFZzxJfeXW7KBGlkxsfH9r/M7FL0/Fdk3P7ZeseHuZPc6noHZrnZnpWuv/XBF2O/1+aVNU/1THvjrJC1X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382789; c=relaxed/simple;
	bh=zYlhC+RzXS+dXLTnzdux/DzcoWy4STdUjgBWIEtPIX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AyQM5agqghUJjTmHv47aoh+nLoZmxp1/Ie1KkwWGZecA+kEEVAqUzqFX/DjRcNVRhimFW+aYrKN3cmF2QGt9kJsAl/Dhud9S3MwvzYFoIgl+DgX9wE9/dZnhMMRxzepAv5YtIZsMYT0KNXpBD7YcX2imS2SQdfOgP3SqlYM8D+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZeWYs0JS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZeWYs0JS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZioNE88KkDmd39pjshp/1fTonsZtSFlhVBL8Jb5jY8=;
	b=ZeWYs0JST6dD9UlH8Ui2cy8iV2XoVWen+cenM/a/p1R6Q+3Kqt1TWKTO3mIU2YXV4EhFWc
	MkisBCAxj5F88QWYqWjZ7yaLbV8Q//Ak2cU0yOfuquManAe6nuKk5FpLoS/yyR6WWkFmDv
	Tv4C6tTVkLckf9WVtyzDZu6zdNAaNVA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-Aksc9XWUNYycWCh2NXkAXg-1; Fri,
 19 Jul 2024 05:53:05 -0400
X-MC-Unique: Aksc9XWUNYycWCh2NXkAXg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F81B1955F49;
	Fri, 19 Jul 2024 09:53:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F089D1956046;
	Fri, 19 Jul 2024 09:53:01 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 11/14] mdadm/super1: fix coverity issue CHECKED_RETURN
Date: Fri, 19 Jul 2024 17:52:16 +0800
Message-Id: <20240719095219.9705-12-xni@redhat.com>
In-Reply-To: <20240719095219.9705-1-xni@redhat.com>
References: <20240719095219.9705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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

