Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD583F9D5
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978101; cv=none; b=IOoAcTL86G1M8ZZDvLlZIOKWPi7CSrjhp+7/hFiWDCpTSAVdYoC2N24EuazNsG5BvnpFwZuVKT8bJcTI8sQ6NbImbRwSE6+rTv+bf9Td8+d0A7hcfot5qF7cQzfi/bb8wH7KLd6DH9V17nnT9JETmKN7jFKVuYMOrGiFw2eRm4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978101; c=relaxed/simple;
	bh=ydIJjrGCmaPAByC9U4Uiz0N1FToVrqqijBzsxuu9L+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nXnV3RlUlSi6naPGy8mJO21iijXFtZUa9NL9WLEE1mpisEN7omb/NdAcJTsycjNVRTUi2WSq87Jt2AKNr2rQpFTBGA4WOQhit/kBC1umwQPQhQjSpP2zdie/yO2cogap0Eoum3GUkya2/OJt1KCeM6SqxBC//klsyQVV/rpfgk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crwxTE0n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crwxTE0n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6q+XhkDsAU+nYwVFKnLFn5aJ6sPlVUKifAEy7t/7K/4=;
	b=crwxTE0neBVeouZEPQsBNfnnEsRnV9nPmyqqHDKg/c31RHxu0MFj97nktVfiTcUh3vfcAk
	3gHoOYrtiXyHfOG9gghdfRbBEFSJ094ZCfriVPSjlAHODLR9rQSwN96Tf+kpqN3cjl1Huu
	WAZcxvLar6bEDJoJY8MRXVRYwzQ5Udg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-p7l6QzJNNgW_qmktawFElw-1; Fri,
 26 Jul 2024 03:14:57 -0400
X-MC-Unique: p7l6QzJNNgW_qmktawFElw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DE5E195608B;
	Fri, 26 Jul 2024 07:14:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F040219560AE;
	Fri, 26 Jul 2024 07:14:53 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 10/14] mdadm/super0: fix coverity issue CHECKED_RETURN and EVALUATION_ORDER
Date: Fri, 26 Jul 2024 15:14:12 +0800
Message-Id: <20240726071416.36759-11-xni@redhat.com>
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

Fix coverity problems in super0. It needs to check return value when
functions return value. And fix EVALUATION_ORDER problems in super0.c

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

