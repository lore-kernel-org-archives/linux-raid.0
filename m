Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A0981219
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382761; cv=none; b=Ze2nhPRhEXsRf+a2fzDBSqvSipc22KpK3W9jyDbtQNWnCuVmYx8PgGhK2nC8OmF96WjRGywyOKf6xvUPfOO++Qt3w4nJlyiRjncbZdki562uxHGVtlUf0byrt7hLqWuwRR0fk/whgzzYtl+j4CYPKV2TXifhG3WRo8nbYw6iU5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382761; c=relaxed/simple;
	bh=Devao37hOL61IKa1Z+08kl0n2K1I33kDApFkZ0e2n/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j9Jk7TULFj2O5K7IXSFF5YxGBAm5TuAKcrOsxoadq4qwlUBbtFnEbsaZkPzljpJkzEu9TXdBzmp8HvzaFthBJiMO5sfvVBx/oShGOgPiRnzQ/7jlfvqUucMSeuljtJ4cuLQ55UBoco4s8rYGhgEPahnX5Cv+hHNtuEr3nAGFJyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8IktyAQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8IktyAQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OrIOlGTiEKqkbFU1orYVwzdhM9vx6ISHo/Vbu/TQHvI=;
	b=i8IktyAQjsqu5mqW0VQglJxiB7Biv5SFwRC6MfZHFZBk6Cev8J8r2Yc9ixEXhgWWKkdzdP
	CpENMzS0caqcoxl9y+ucJXssA2vN9IRxZ1cRyQ0jeqOMWYoYQITsrmv6mnX36rr86uFOHC
	6yKn0UPhmnP+60MHuGkItKYxyt5rbgk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-7tl1OR4PMPeODKufQDIBKw-1; Fri,
 19 Jul 2024 05:52:37 -0400
X-MC-Unique: 7tl1OR4PMPeODKufQDIBKw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 480EA1905990;
	Fri, 19 Jul 2024 09:52:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AFF6319560B2;
	Fri, 19 Jul 2024 09:52:33 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 03/14] mdadm/Grow: fix coverity issue STRING_OVERFLOW
Date: Fri, 19 Jul 2024 17:52:08 +0800
Message-Id: <20240719095219.9705-4-xni@redhat.com>
In-Reply-To: <20240719095219.9705-1-xni@redhat.com>
References: <20240719095219.9705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Grow.c b/Grow.c
index e18f1db0..2270993c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1694,6 +1694,8 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 					/* Current RAID6 layout has a RAID5
 					 * equivalent - good
 					 */
+					if (strlen(ls) > (40-1))
+						return "layout %s length is bigger than destination";
 					strcat(strcpy(layout, ls), "-6");
 					l = map_name(r6layout, layout);
 					if (l == UnSet)
-- 
2.41.0

