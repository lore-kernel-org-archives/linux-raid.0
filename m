Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80B8166301
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636316; cv=none; b=gpAC/VGqAGKq0kAI5W9nD4wXjAq9/V/uRgBTaBdtpYmcA5qVigYhPUdd06uishpyCfFXahQdm6SA7H5/jme4LHVLGNZT69k0b/oZDcXZBcKgQ6QSl1pmNRAE8bOkdqoCyp53oJ8dY+3VPM8VcDrKfT2Vcb/8IHfWWkAXjUL1ntc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636316; c=relaxed/simple;
	bh=Kw88mGN1ylNewGbnNML6JayAGHOTLugYAGIkWDdqBk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qwjPnOrEvBAFhU13u1ngYOix/2vmO9qaCQlKzVMCuom7s/CmyKxzO4EFFQka/FAMw8Ne7Q8axBa/CwzsmtfBmP84kuPpqamGKkWkaszzofIylpYp8WAiBTGnSKsCi1OTzWNNEcAYTHdfvBvGZNXgrBdEY2e3hylXN7DfGj04pn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ESPWB1/p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ESPWB1/p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RHTHi2Kr32WklCRfMoLDCM8IVMHwOL7YozXyt3+SOMU=;
	b=ESPWB1/pdo+q1w7j8LXRRvpMl4Y5JOXN9Zvc4821qdAzufOyuz7dTb2czPkTYqkcTXBA4i
	4ozSIMPi6gm5Bz8NX4dSjNbr2pEJuCL0BzYROqeTn3SHRKc1sZg1jBT64lmHQu5RjtrviE
	YiQZrrJU82daq9j4eecw0HMmBuW25zI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-NhCdKdmEOrWyOMQZRvbtMA-1; Mon,
 22 Jul 2024 04:18:30 -0400
X-MC-Unique: NhCdKdmEOrWyOMQZRvbtMA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5345C1955D48;
	Mon, 22 Jul 2024 08:18:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CFCB195605F;
	Mon, 22 Jul 2024 08:18:26 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 13/14] mdadm/super1: fix coverity issue EVALUATION_ORDER
Date: Mon, 22 Jul 2024 16:17:35 +0800
Message-Id: <20240722081736.20439-14-xni@redhat.com>
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

Fix evaluation order problems in super1.c

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

