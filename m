Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100D115EFB9
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044893; cv=none; b=GBRr3JDeIsx4DMTW4/Wm//mNoptr0UXNkkXp1rfLzzM4B/3Jgpx/GtIxIQqEu/DyWffvyJyVXPDwphd2qOZ5ouPJrPfiMkcdu+7+gUYgprjBjhYzGi8kiw/rfDAh5E6ieSiaWcHGIS5tk99Vkp6Sh+sqMxoL7Xba1zL5/BVSTfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044893; c=relaxed/simple;
	bh=QhSYxdhsq3hvM2Nd7sjS3TUsSIhsjWOKWBEziaPJ8i4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s7E4WgLaqZDc4skP6YMlr8QdM8r/PHtH1h+itHR/rVopy+D8kCqa0+wSu+hGPf0qQnLKzYattfFEp0jLQKNxDlpN79fsrJc1g+mZz2Jfmd2h8z4eTjuu9xmAO8d/k1Hj9v7byEA+Bnx4+qDGL9WicHm40NPUcqoh3IANoTDO79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZibtNhqp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZibtNhqp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HC0VZKh/qNGFi7wtrdTq0IQi5hLwfOqLQKq/H2n9vk=;
	b=ZibtNhqpktUOqLiPGkYIYkXWMyCxlRDs71AYOfKgPxO9WiorD9kjTY40+cRS9SZNUvYYF1
	W1s78hiODFvBCZo9r2RF9o+7NLqud6/z9Y3+z1C6sr8zRk63SaB84+SZ7P6uanhCK9fjPO
	dSwFYk0ggQfRKtSk3Ah9EpRytcTDoi4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-a1tt4afGOj2YioXHMrYjjQ-1; Wed,
 11 Sep 2024 04:54:49 -0400
X-MC-Unique: a1tt4afGOj2YioXHMrYjjQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5E631953965;
	Wed, 11 Sep 2024 08:54:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 613A0195608A;
	Wed, 11 Sep 2024 08:54:45 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 03/10] mdadm/Grow: Can't open raid when running --grow --continue
Date: Wed, 11 Sep 2024 16:54:25 +0800
Message-Id: <20240911085432.37828-4-xni@redhat.com>
In-Reply-To: <20240911085432.37828-1-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

It passes 'array' as devname in Grow_continue. So it fails to
open raid device. Use mdinfo to open raid device.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6b621aea4ecc..2a7587315817 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3688,9 +3688,12 @@ started:
 		set_array_size(st, info, info->text_version);
 
 	if (info->new_level != reshape.level) {
-		if (fd < 0)
-			fd = open(devname, O_RDONLY);
-		impose_level(fd, info->new_level, devname, verbose);
+		fd = open_dev(sra->sys_name);
+		if (fd < 0) {
+			pr_err("Can't open %s\n", sra->sys_name);
+			goto out;
+		}
+		impose_level(fd, info->new_level, sra->sys_name, verbose);
 		close(fd);
 		if (info->new_level == 0)
 			st->update_tail = NULL;
-- 
2.32.0 (Apple Git-132)

