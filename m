Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1210200AB
	for <linux-raid@vger.kernel.org>; Mon, 19 Feb 2024 06:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324006; cv=none; b=tEqb/ZwTi61kbqiPJq15SK/EOmkpWmXe3AzBqM/FGS/clG5mIN0JrISd6jZSCk4ZvraIwLRTaSourqFKdeyPBL5Wy9y/h4Gj3lGiqqDe/mNcTB3HY3/B2nu51awSzn1l3PZfQq7MZv9dSEv+ETKxRbBX+J4B3FIr20eFo/TUQc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324006; c=relaxed/simple;
	bh=p3zF3ZqBApEKi6a/GhK0dmTJTW+SmZ/mHlGibr6LBm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nqq89dQPu1pDHpcsYYYNmynAiEOM4gyGydflxzX5v8r2JfAHktZ7gp80dLqHBaUsGEWh+XXE2vi3/tMFY4PMK5IByjjoMUMO4c37p0cJnKoaWZPFe+D27D8IeqesX9a/gl5OJn5baxaGJOYAsAYq6JD7BKMa1UCvrEEGBYo03L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGW3ALIm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGW3ALIm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708324003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rR6JN4gU7y3tOWM/kqUBGRZmH6XeMtMRLTOjNJqe0CU=;
	b=ZGW3ALImMCQhsrkXS6Y/zpzYWzmyM+vGbt9ECu+dPp/ijD8lNiN+0WQFZ6luTJaZ/Uyvwp
	GvE/Vszi9TZvQ1Z0sVDIx9U/E+BjfZ/wmhsssKyM8dXULGqg2sz3C6jw9eoKQt/dFUXUPU
	sFgC5XJMs7vI8LSNuRh4tqEIGGEexIE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-9qAQDWPuP8WJxXpc_iyWiw-1; Mon, 19 Feb 2024 01:26:39 -0500
X-MC-Unique: 9qAQDWPuP8WJxXpc_iyWiw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABDCB185A781;
	Mon, 19 Feb 2024 06:26:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29C1548B;
	Mon, 19 Feb 2024 06:26:33 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	neilb@suse.de,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH RFC 2/2] md: Set MD_RECOVERY_FROZEN before stop sync thread
Date: Mon, 19 Feb 2024 14:26:20 +0800
Message-Id: <20240219062621.92960-3-xni@redhat.com>
In-Reply-To: <20240219062621.92960-1-xni@redhat.com>
References: <20240219062621.92960-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

After patch commit f52f5c71f3d4b ("md: fix stopping sync thread"), dmraid
stops sync thread asynchronously. The calling process is:
dev_remove->dm_destroy->__dm_destroy->raid_postsuspend->raid_dtr

raid_postsuspend does two jobs. First, it stops sync thread. Then it
suspend array. Now it can stop sync thread successfully. But it doesn't
set MD_RECOVERY_FROZEN. It's introduced by patch f52f5c71f3d4b. So after
raid_postsuspend, the sync thread starts again. raid_dtr can't stop the
sync thread because the array is already suspended.

This can be reproduced easily by those commands:
while [ 1 ]; do
vgcreate test_vg /dev/loop0 /dev/loop1
lvcreate --type raid1 -L 400M -m 1 -n test_lv test_vg
lvchange -an test_vg
vgremove test_vg -ff
done

Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 54790261254d..77e3af7cf6bb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6337,6 +6337,7 @@ static void __md_stop_writes(struct mddev *mddev)
 void md_stop_writes(struct mddev *mddev)
 {
 	mddev_lock_nointr(mddev);
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
-- 
2.32.0 (Apple Git-132)

