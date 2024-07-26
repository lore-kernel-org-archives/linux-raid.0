Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1EB176FA2
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978115; cv=none; b=DIrIraNm+Vfp9ZcV+30PWYi4JBhluNRcCfNlOyrHajqHhX9T2SsziXkilrwDsCIVw5UqzBbNns2xylS+Byrb0m1ZhxE9Oy8v62GC59uPRFPR9QlZf/kqBx100TZ48pxN9fNQwkS6BnyEcj+dVI2w7iBHyyYE08tM5q9PVMqXBjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978115; c=relaxed/simple;
	bh=LmXPjAEBosm2hFuKsUW8PjdDpHSgdmohCm+M5cLgT3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CBa9Tg0Dmr3SR9tQtcix+ivq0Uv6gk9Mvqi0ky8yRKsEYDj9l2ZtKuYKHn37ONGJjRRNLSaL/ZYNKA22yD0O/98jHyD/jXFCtKXFEQVYzFQW29bFL5rPuwq6eMenJZTTQQe0av2RgX2aLdLaSD4GlPw84AnFO8z1Q8cDnYWxrjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b5nNATiK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5nNATiK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KleBwO/LlmCNT7LsqpIvnrOHFBRJIfftyaNFqmaX4Hk=;
	b=b5nNATiKr5dTmQKcT0S7QMibovyy35DoeoLGEEC3QR1oLRtpNyxcX5V8Yqrj1d2wbyXTZ4
	/nrmRF+IWr/bgNQO4evtnVXQHCG0uXAjrGXtF3fxuGNcDVevx92stAIcgLxK7FXk1dyEUt
	6zRnFJXPQATcInOlHULRbFrQpptHm/g=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-cJgdoQFdNl-HwQ4vq9fWOg-1; Fri,
 26 Jul 2024 03:15:07 -0400
X-MC-Unique: cJgdoQFdNl-HwQ4vq9fWOg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40CBF19560BF;
	Fri, 26 Jul 2024 07:15:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D88D119560AE;
	Fri, 26 Jul 2024 07:15:03 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 13/14] mdadm/super1: fix coverity issue EVALUATION_ORDER
Date: Fri, 26 Jul 2024 15:14:15 +0800
Message-Id: <20240726071416.36759-14-xni@redhat.com>
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

Fix evaluation order problems in super1.c

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 24bc10269dbf..243eeb1a0174 100644
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
2.32.0 (Apple Git-132)

