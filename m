Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C9122EF4
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029022; cv=none; b=A7BSmEkRwn/FyapC72Olyh1QNGf02nNiNjqd7Rwba2nkSAHqMp5hBCTc3SEsQUuA3RIo9PhcoSEyR2tD2pqBNdNVSb/awOVani+HlAE5R216xIE8uoUMvQaEa43QHuos1IP0C+0qY54e/vC/Efukvlqe/jQmzib88UwHGz00RbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029022; c=relaxed/simple;
	bh=2dvMmnYVsgc7V/o+A1wicsDxR56BX8gDkC6+atrz9Pw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rUEM6UMReHHnIOc0EsCiDV9LPwXflLixo8h+xJct/MNR1wI6sQrt01Cfo10DiR1yhQLHRAjogguphITsfWuPJQr0++b40BkEyb8/pLVYq39e1AEY7C+e2jUc2zMAjLGJrgU+O+U5Ap7pVHrtJHkLzs0TiyaWkASXIFJifDpwjT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UMX3K7fx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMX3K7fx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XpRITL1ijx18ONRTeDcPj+E+dubO+JwZ0gLGE/aa5A=;
	b=UMX3K7fximJhpvnhV5iTjirB/76NoeNHq+nw4jIHQa8CuzGPpkebGiDpeX3wjfC9ViI5W1
	UKiEIlepIbgsFZgXLhUV6xsf+tfL1JWyn1urvBYHYe+FpT9Ykk7dZhoa4bBUq9QGb71oEd
	OqGGr9B4N86sQQfBvFgaQreHYlwphzk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-46igtOfBMK2xtoYrG1-1fQ-1; Mon,
 15 Jul 2024 03:36:56 -0400
X-MC-Unique: 46igtOfBMK2xtoYrG1-1fQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0746E1955BF9;
	Mon, 15 Jul 2024 07:36:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4F0D1955D44;
	Mon, 15 Jul 2024 07:36:53 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 14/15] mdadm/super1: fix coverity issue EVALUATION_ORDER
Date: Mon, 15 Jul 2024 15:36:03 +0800
Message-Id: <20240715073604.30307-15-xni@redhat.com>
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

