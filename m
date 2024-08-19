Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6BE18A95D
	for <linux-raid@vger.kernel.org>; Mon, 19 Aug 2024 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092705; cv=none; b=mJLk2/e/DGELEqz4L7fB4im38G2kO2bpO2y9RARaeYMTEztLWHNqvPhRk3Y/Saa0SRIFHk6IPc2PenEnV7x1/1CwtUbyjB56sLKlFgm1OUPq0NY9t8LCDYuf/35wQPmeC+al0VLdcV4+lzMpbfVYpVD3MOgiTaGeLLKJ8EJ8Jyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092705; c=relaxed/simple;
	bh=U0nOA7Z1A1/Dy25L8IFvcBZsOwg8CiDXCZ/aPn74aWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKGJP8Ma1aUFgc6UTNSVD8kPxnF8X//6nJuseVxV3Yby11us3p3ZRCR4Km2eCb0Z8siRCtdvFYF+sahwZSujrVryUu2HsXWUp/lbAnl6nAxfQTJU8FFwBKz9ww7gXumhO4+6RA6Cl9Q9rjuXH+8phMw/QyciiIZH1BvjRcvYRnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jE8elX3F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jE8elX3F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724092702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRLptKCiXpp4gNIkR9o/h84xalWa/aBGlKLc9592qnI=;
	b=jE8elX3FJnRJBXtZblMq/OacGaknajE9kuAC8UZQY5Ww5yAuLfCKeSzs9wKvMWEWQ1HVyR
	WUHLrcjdqnn+n6+cukhBSeZcFL9QzbhoBs7lxUMPm8KaaJBLJdcYuKLy2Ycmhx2NI6OYPA
	2QNojVbMnKw226hUzk41O358jdNj47U=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-GaVGPgepPiKUezWf1dZNLw-1; Mon,
 19 Aug 2024 14:38:19 -0400
X-MC-Unique: GaVGPgepPiKUezWf1dZNLw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC9771955D57;
	Mon, 19 Aug 2024 18:38:16 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B03EA1955F44;
	Mon, 19 Aug 2024 18:38:13 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	agruenba@redhat.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	netdev@vger.kernel.org,
	vvidic@valentin-vidic.from.hr,
	heming.zhao@suse.com,
	lucien.xin@gmail.com,
	aahringo@redhat.com
Subject: [PATCH dlm/next 06/12] dlm: dlm_config_info config fields to unsigned int
Date: Mon, 19 Aug 2024 14:37:36 -0400
Message-ID: <20240819183742.2263895-7-aahringo@redhat.com>
In-Reply-To: <20240819183742.2263895-1-aahringo@redhat.com>
References: <20240819183742.2263895-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

We are using kstrtouint() to parse common integer fields. This patch
will switch to use unsigned int instead of int as we are parsing
unsigned integer values.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/config.c |  3 ++-
 fs/dlm/config.h | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index d9cde614ddd4..a98f0e746e9e 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -153,7 +153,8 @@ static ssize_t cluster_tcp_port_store(struct config_item *item,
 
 CONFIGFS_ATTR(cluster_, tcp_port);
 
-static ssize_t cluster_set(int *info_field, int (*check_cb)(unsigned int x),
+static ssize_t cluster_set(unsigned int *info_field,
+			   int (*check_cb)(unsigned int x),
 			   const char *buf, size_t len)
 {
 	unsigned int x;
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index 9cb4300cce7c..9abe71453c5e 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -30,17 +30,17 @@ extern const struct rhashtable_params dlm_rhash_rsb_params;
 
 struct dlm_config_info {
 	__be16 ci_tcp_port;
-	int ci_buffer_size;
-	int ci_rsbtbl_size;
-	int ci_recover_timer;
-	int ci_toss_secs;
-	int ci_scan_secs;
-	int ci_log_debug;
-	int ci_log_info;
-	int ci_protocol;
-	int ci_mark;
-	int ci_new_rsb_count;
-	int ci_recover_callbacks;
+	unsigned int ci_buffer_size;
+	unsigned int ci_rsbtbl_size;
+	unsigned int ci_recover_timer;
+	unsigned int ci_toss_secs;
+	unsigned int ci_scan_secs;
+	unsigned int ci_log_debug;
+	unsigned int ci_log_info;
+	unsigned int ci_protocol;
+	unsigned int ci_mark;
+	unsigned int ci_new_rsb_count;
+	unsigned int ci_recover_callbacks;
 	char ci_cluster_name[DLM_LOCKSPACE_LEN];
 };
 
-- 
2.43.0

