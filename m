Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC9A80639
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382801; cv=none; b=gbiSH/PK3n5IJmp7OsRRgsgq2IpeTpXL6aQFkPdRAkiiMHxm84z8rhrcYPsBujyqsjgDD7oZTpX0KPtKyZacCL7bh+caFhBtn7CiwU1qpa1kWg0VHaaZcjK0uul7yQxWFM3gI9grhGg3Sai5PvMzJ2eyG+etW+edpYD9PKRrFvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382801; c=relaxed/simple;
	bh=Gx93Blqp1G3u0lc4XQcpy3av5gZJvDn07VJPxZwqz+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aiE5vwQkznu/XSyXzFT9BkZff3ekmm3rWXssz7OH9miMfHzIcNCaVa11CUfwlLYI60q427MN3Tg4BMBGqnWPOuX5TDbB7EubTH9vZNi1nhvKe0lqKcCIt1kKNqotjUQv6WrPpY5WPJIXNQ2EAVhmq6ioUSwBajmPJYb/zshCzY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPaH/C49; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPaH/C49"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YSyNQqc/HjNEV3o9OAYNsxxnYWQQVYDjci/r8AtfnPc=;
	b=iPaH/C494ucHxVZIWQJMbgEsgo9nTD8GGoOLisu3St+s0BCujzdeImrUNi7XlN/3fj4+6u
	SNJbtRTWxVP394WKsuwBybtnkZk4yIDEwawswWB/VWAl7nbYndfyKeI0lsdCq9yFW7j08q
	bbXwSL5WVC3+TdrDJAIyTeFf2Tcs1m0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-PKi_PJC4OTSyGi8vp3ES0w-1; Fri,
 19 Jul 2024 05:53:12 -0400
X-MC-Unique: PKi_PJC4OTSyGi8vp3ES0w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 526B11954223;
	Fri, 19 Jul 2024 09:53:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CABAB1955F65;
	Fri, 19 Jul 2024 09:53:08 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 13/14] mdadm/super1: fix coverity issue EVALUATION_ORDER
Date: Fri, 19 Jul 2024 17:52:18 +0800
Message-Id: <20240719095219.9705-14-xni@redhat.com>
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
 super1.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 24bc1026..243eeb1a 100644
--- a/super1.c
+++ b/super1.c
@@ -340,6 +340,9 @@ static void examine_super1(struct supertype *st, char *homehost)
 	unsigned long long sb_offset;
 	struct mdinfo info;
 	int inconsistent = 0;
+	unsigned int expected_csum = 0;
+
+	expected_csum = calc_sb_1_csum(sb);
 
 	printf("          Magic : %08x\n", __le32_to_cpu(sb->magic));
 	printf("        Version : 1");
@@ -507,13 +510,13 @@ static void examine_super1(struct supertype *st, char *homehost)
 		printf("\n");
 	}
 
-	if (calc_sb_1_csum(sb) == sb->sb_csum)
+	if (expected_csum == sb->sb_csum)
 		printf("       Checksum : %x - correct\n",
 		       __le32_to_cpu(sb->sb_csum));
 	else
 		printf("       Checksum : %x - expected %x\n",
 		       __le32_to_cpu(sb->sb_csum),
-		       __le32_to_cpu(calc_sb_1_csum(sb)));
+		       __le32_to_cpu(expected_csum));
 	printf("         Events : %llu\n",
 	       (unsigned long long)__le64_to_cpu(sb->events));
 	printf("\n");
-- 
2.41.0

