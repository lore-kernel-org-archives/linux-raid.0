Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7942B3D579
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029012; cv=none; b=bKacwTn2PD6q9ivV63bp77t7JMohNKkvyi8f49BvmZAwmQX9+R1+RBD3HlzxNvdywlht9aoEmOD2RYZToBDAQGPinZ2tcDtg7oMS9hnvOKwFGYfHpHFrZXZ0x62yjf+foBSbxun0zXhp6C0nSnm+YPCPMdYsz0UuQMRKDz9z4oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029012; c=relaxed/simple;
	bh=04RfBQoaqsZ/DtLO4SAiuUcnyHjXDmwzzZa0c0DariU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q9FIRTRvq+pfElJ9wR95raSXjyJJUAYmUjmniva+uiECQu7Kd989ff8wNMiLXD1rUCHuTAGvAJcdnEeqkD3S71SVCwR+cb2Wtr32UEPKhLNrUvTWz7Fom3kCPQFKBR4ABGwiR5JIpyu9R7K9UqYpJ6senSFYXcdkIIUlzT4bQBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V8hc+33R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8hc+33R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhEwUJ8DZ7u+HZS56OwK7iZ5wgpEvxcNmmDX0SKWsO8=;
	b=V8hc+33R1NsdRZElmE/R2ms9HfhcOwvqu3ClxsnvHlkBZLZdzgMiPabFImDIp268FDhv+a
	qDi9QnK4bPFFA66WNwiNuKotEvJHw4UUGKyzIBexj0F+oWG7Dx2jwkVQChtPENDgwcUnTM
	fqp8qWVUTZLVZ3LgeNri6nIdZvXv8IU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-r98wFUQJMNifhfjC_LARTw-1; Mon,
 15 Jul 2024 03:36:47 -0400
X-MC-Unique: r98wFUQJMNifhfjC_LARTw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 247591955BF1;
	Mon, 15 Jul 2024 07:36:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B6E2B1955D42;
	Mon, 15 Jul 2024 07:36:43 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 11/15] mdadm/super0: fix coverity issue CHECKED_RETURN and EVALUATION_ORDER
Date: Mon, 15 Jul 2024 15:36:00 +0800
Message-Id: <20240715073604.30307-12-xni@redhat.com>
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
 super0.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/super0.c b/super0.c
index 9b8a1bd63bb7..6f43b1671d44 100644
--- a/super0.c
+++ b/super0.c
@@ -83,6 +83,9 @@ static void examine_super0(struct supertype *st, char *homehost)
 	int d;
 	int delta_extra = 0;
 	char *c;
+	unsigned long expected_csum = 0;
+
+	expected_csum = calc_sb0_csum(sb);
 
 	printf("          Magic : %08x\n", sb->md_magic);
 	printf("        Version : %d.%02d.%02d\n",
@@ -187,11 +190,11 @@ static void examine_super0(struct supertype *st, char *homehost)
 	printf("Working Devices : %d\n", sb->working_disks);
 	printf(" Failed Devices : %d\n", sb->failed_disks);
 	printf("  Spare Devices : %d\n", sb->spare_disks);
-	if (calc_sb0_csum(sb) == sb->sb_csum)
+	if (expected_csum == sb->sb_csum)
 		printf("       Checksum : %x - correct\n", sb->sb_csum);
 	else
 		printf("       Checksum : %x - expected %lx\n",
-		       sb->sb_csum, calc_sb0_csum(sb));
+		       sb->sb_csum, expected_csum);
 	printf("         Events : %llu\n",
 	       ((unsigned long long)sb->events_hi << 32) + sb->events_lo);
 	printf("\n");
@@ -1212,7 +1215,8 @@ static int locate_bitmap0(struct supertype *st, int fd, int node_num)
 
 	offset += MD_SB_BYTES;
 
-	lseek64(fd, offset, 0);
+	if (lseek64(fd, offset, 0) < 0)
+		return -1;
 	return 0;
 }
 
-- 
2.32.0 (Apple Git-132)

