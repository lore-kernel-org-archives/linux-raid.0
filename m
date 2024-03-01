Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA2239AC4
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306512; cv=none; b=q4m7YfucW8Rob41iE9wOZzlOeq8IgnqxMDxuJzh3PrbuGE58mMYtscfxO1EsFPB7rRgP+EK+kQDYujQnw3RthXEZr5DB0oCjBu13V3O0WfDKp3BEDsCEXoqcCVxwSf6z70dQeh6cofs+K81SyeRdfRpB2i+V/XZn9PhNKq2bqRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306512; c=relaxed/simple;
	bh=twKyr/AQCXonyQJFYLl2e+MyrEq0SqDqPOri9QgRcZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pw+lcMV4pwyKG9/vvg9GmKno88ua/eyYXlNIHkYyzXLwKbEnnw9jRN4QdGHdrjGlnZV7nIdfPY8Pn5GOfD+cmtG0/WScSjLiqGNa/D3of6mQ+7DGIBNQJiPuD8ldrIt+2gFc+bR7YeMN1lNC3eePQ2gW7gT0mDHrDmw+AVCQCYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UHOnPZTB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UHOnPZTB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709306509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TJ5epbe1waIGIp78Jg9/7z1apy7Rzqgqd/bd6euDGg=;
	b=UHOnPZTBhQHKEgQxZPk9siQ1t9DlpvgRNqVIwRaLGOKleFFdopsnUVEcCcN0XuXqTHxG1Z
	+l8lqgsSuslqwKGP4kP0ab3DLK3QAr7FuVbSa4ccTgD/af4Bq1YLOl5Vi4fcoawO50KSDw
	8Rx8O17kcINHGG6/Wx+nFi8Mo1TPmw0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-IPu4BHsoMYWHmc_VPCy4ew-1; Fri,
 01 Mar 2024 10:21:48 -0500
X-MC-Unique: IPu4BHsoMYWHmc_VPCy4ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0248282D3CE;
	Fri,  1 Mar 2024 15:21:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26010112132A;
	Fri,  1 Mar 2024 15:21:42 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 3/4] md: Set MD_RECOVERY_FROZEN before stop sync thread
Date: Fri,  1 Mar 2024 23:21:27 +0800
Message-Id: <20240301152128.13465-4-xni@redhat.com>
In-Reply-To: <20240301152128.13465-1-xni@redhat.com>
References: <20240301152128.13465-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

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
index c4624814d94c..c96a3bb073c4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6340,6 +6340,7 @@ static void __md_stop_writes(struct mddev *mddev)
 void md_stop_writes(struct mddev *mddev)
 {
 	mddev_lock_nointr(mddev);
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
-- 
2.32.0 (Apple Git-132)

