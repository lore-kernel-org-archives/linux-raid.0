Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FD316A38B
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636313; cv=none; b=Bx6q91mBexfxhtxrdtL8FcyuvlvEvksnIefAYnHSoB18RC7lieXPCNNtYoECQ7eaQsAO106lHa11opVWhw9TFxzNCix+5F/tnPo3tnpggh6RnTZtGi94ix+bpqP3qiNJQ+6zGl82LajOpf0oqVVDcLoIa3seM5FY+CjfOLUm7Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636313; c=relaxed/simple;
	bh=+Gpbcoblu2LLOBZ7uPxh56hc3wjq37XPSQVTKpMohes=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GJsvIFKFgvrfoIbVrRgvv6dSL7MwgYHJ+n+jBfO8kJCh51Ch7zZreagAe1sNKhzgG07CYxhyZ2Bg6fVJ7IPw9k41E2essPlMlLxM3fdgRNqE/Tdhw5kQ3bW5nQZ4qKCjhV07Cw/HZGHw4OKIl9I2SPzjZx/rI3FReLJVK4AMxJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BICItHMf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BICItHMf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nf5NChEWcNeYOC6BMAgvpWlkiDxDM3s9rHFFm4FX7WY=;
	b=BICItHMfDC8lpa3Ehir9HEOP1ngTBEzIfd3bJbQ+g7p5GmM/zZ0xRBJ+Md9f0RFFTWSDvK
	1bHqH9tVf+ix7aSl0cMiE5PPtusEug09Gljer3+zsOh6ZvEVppd/33funGqsO8GfRIfJ5t
	dtjYI5h/lH38/6PgkwY46DbqbevdQlg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-nf7zB8V4O8eZwEr_ipaPsg-1; Mon,
 22 Jul 2024 04:18:27 -0400
X-MC-Unique: nf7zB8V4O8eZwEr_ipaPsg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C3641955D4A;
	Mon, 22 Jul 2024 08:18:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B8501195605A;
	Mon, 22 Jul 2024 08:18:23 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 12/14] mdadm/super1: fix coverity issue DEADCODE
Date: Mon, 22 Jul 2024 16:17:34 +0800
Message-Id: <20240722081736.20439-13-xni@redhat.com>
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

optimal_space is at most 2046. So space can't be larger than UINT16_MAX.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/super1.c b/super1.c
index 4e4c7bfd..24bc1026 100644
--- a/super1.c
+++ b/super1.c
@@ -1466,8 +1466,6 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 						__le32_to_cpu(sb->chunksize));
 			if (space > optimal_space)
 				space = optimal_space;
-			if (space > UINT16_MAX)
-				space = UINT16_MAX;
 		}
 
 		sb->ppl.offset = __cpu_to_le16(offset);
-- 
2.41.0

