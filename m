Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064DF176AB6
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978114; cv=none; b=BeY71uBWbg1/HgwLf6IbkrsBGDzyLVJbj4pOabtpggUcfdALu4+DdmRGTKGvglknr8r8/yFxSvLq29ou8NPHDSZbMwy5c8eKQFjgw8o0U8mGADt2dI2CZn/DoAct//2BGb+Y0C1G4v4RJYK3qQNzxEALJCjbD0fQx+mzKRjTqPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978114; c=relaxed/simple;
	bh=V+zXZbJgDyBPenD0c5qiKDpT+aQzBt7IfeoYwYBQxVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n1nunyD0pTgo9ax+S+t+CJoOM/XHpCIr8IAx5ZFduSgG8sg2ZtZYSddkARl/sOkU+6mgE8q3HGiymy9IuXNNTbTIstswsMEC3PJ/W9XzbEdUFhun3+ePfA3dsFeITfwglkiqpwYNdsI7kO0xmfJFSVZaqlkXclTyQQ8d5K24G70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QV51+zqt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QV51+zqt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hv9jq78OuV0w889CMuzeafnKXeA/VUKWQvplB4JzTM8=;
	b=QV51+zqtZngMNsfXs0MMLdpbCzAIVCvDnAxxV2Fiqn9jgRhHw6X3q2fKNE7ulp9bzHJCiB
	u8/t3PO/xd8f2sfDdoMUEDz84/mvMoSRqdeo1VsNIc2ap3mBMU/+sSmFdmGuSWKH5CFK1I
	aaHU17mUlNnwG9y2jD8ehN1rGF9GhcM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-94eXCbpsPf6Xkjz_NrC9nA-1; Fri,
 26 Jul 2024 03:15:10 -0400
X-MC-Unique: 94eXCbpsPf6Xkjz_NrC9nA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90E691955D50;
	Fri, 26 Jul 2024 07:15:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 172C019560AE;
	Fri, 26 Jul 2024 07:15:06 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 14/14] mdadm/super1: fix coverity issue RESOURCE_LEAK
Date: Fri, 26 Jul 2024 15:14:16 +0800
Message-Id: <20240726071416.36759-15-xni@redhat.com>
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

Fix resource leak problems in super1.c

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super1.c b/super1.c
index 243eeb1a0174..9c9c7dd14c15 100644
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
2.32.0 (Apple Git-132)

