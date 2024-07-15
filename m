Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F343EA98
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029017; cv=none; b=QKXS8JJ+6iFtiY/Or21eRYIbF+s6IxoAk/LAA4ez89Lj/L0vCvmH8PP/KQevmLt17yNaOT66FYPdJeLeC4fFyg5y89rqMgZ9dcOk9bksdOI6nDO5AsHmbQ5giaATTAQutlbc9Ir9wyQ6RiGJ3KDPv10F2ApVvvaPocWUwwdZGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029017; c=relaxed/simple;
	bh=Cvj3SZRkZWRMk2KNF6HndE2+4OaQ32KB0X0Y1vD/PkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N0ol4yDVYIPwDqHiUdYhaWBBnymtLsxxtBwoQSk83v0sXPW3JQ9ir/Ed3Xns+RqOXjeh/QmOVV0x5Hq8+tgPcFPs2AZWelCEmw8CoMBj/hnjVF9ZgIuXIoclEmf7q3qeMVfeZ5VxmCMNjyi7i8CWhZmSVhlIGveXptoMM326JDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bJ6Lw7ho; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bJ6Lw7ho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eZSXHtXZkTZMVa/stIcI/tq71/f1YuLWNTUXuCFojS8=;
	b=bJ6Lw7ho2DcgtjgOHiUX8xnHdHJ3qZHV2Uy3aQs52Qm51v5p+5t9RRxdGZPAOpN0GI2S4Q
	mDOpO4bJyAfsWUxu99jWO5jKso1NamLoHp5JZwMHr6GuV8IOgh69DINXfKue026d3Yhu3M
	c5FOJ98GyYIBEkq6b4t1BcXybPyKOJY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-mzotbJfMN6iuJEc-nQKa-Q-1; Mon,
 15 Jul 2024 03:36:53 -0400
X-MC-Unique: mzotbJfMN6iuJEc-nQKa-Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9A611955D50;
	Mon, 15 Jul 2024 07:36:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5607C1955D42;
	Mon, 15 Jul 2024 07:36:49 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 13/15] mdadm/super1: fix coverity issue DEADCODE
Date: Mon, 15 Jul 2024 15:36:02 +0800
Message-Id: <20240715073604.30307-14-xni@redhat.com>
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

optimal_space is at most 2046. So space can't be larger than UINT16_MAX.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/super1.c b/super1.c
index 4e4c7bfd15ae..24bc10269dbf 100644
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
2.32.0 (Apple Git-132)

