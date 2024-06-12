Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18A61822E4
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 18:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718215972; cv=none; b=i4AvCijL5jEyzDL5bLGRwNLbZbrPgMaX8tMZDLsuttuBh6xp6fLrhx6/5HWC7jeqdfQ2/xu7u4gPy6Dj64DoN2NeGlahFA9qgB0gxQ3R4gJDit5I/hkuZy/Fp1L9jGjK82BqdVxEXgmCtFkXjM9BgZEBOUMyccgxMCHh0czbIE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718215972; c=relaxed/simple;
	bh=iVXrOtRgUikq/kRqWyEVF8Pf1e3/CM0+Ve2sNTybHHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R52EAvJjj/dRtRECzOMCTQrrdPFP5xZrTvBGxsKtFD5EbY8UXeInfkV9xWXU5Z5hPKwjjWTipD2hvukq7olTQI2PTqv0lktfwyU6UaHw9guUIJoPHRqpfiUBF35R/XLPeVvbJBrTTjPheD1C3m6O3ilOg430fZSjtoGAuyruR7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vu5N9LY9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vu5N9LY9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718215969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w7vWKn9KHTR9q/2X4Fv+IWneQC7w0Q3JqVaG/ZuiGD8=;
	b=Vu5N9LY9hXHhctPG5jSJPCKah/dbCQKSODhkHA7dlmSQSN6M6qGnMW5qUZNZ9xDRpVm/Qb
	NMG+1IGy55Vs05NvpmdE5Lug3SPmrS/sJAnPrPlyCG+RG2XsrxvQcE3yT7LWH6a6LM6e7p
	R8O37Xa4qDW98e5EXq9bpLbOENboXt4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-gsOkTSEBNAe-Z8zo2A4YeQ-1; Wed,
 12 Jun 2024 14:12:46 -0400
X-MC-Unique: gsOkTSEBNAe-Z8zo2A4YeQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAFEF1945CAA;
	Wed, 12 Jun 2024 18:12:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3331F1956058;
	Wed, 12 Jun 2024 18:12:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45CICMAZ877586
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 14:12:22 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45CICMHw877585;
	Wed, 12 Jun 2024 14:12:22 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
        Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v2] dm-raid: Fix WARN_ON_ONCE check for sync_thread in raid_resume
Date: Wed, 12 Jun 2024 14:12:22 -0400
Message-ID: <20240612181222.877577-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

rm-raid devices will occasionally trigger the following warning when
being resumed after a table load because DM_RECOVERY_RUNNING is set:

WARNING: CPU: 7 PID: 5660 at drivers/md/dm-raid.c:4105 raid_resume+0xee/0x100 [dm_raid]

The failing check is:
WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));

This check is designed to make sure that the sync thread isn't
registered, but md_check_recovery can set MD_RECOVERY_RUNNING without
the sync_thread ever getting registered. Instead of checking if
MD_RECOVERY_RUNNING is set, check if sync_thread is non-NULL.

Fixes: 16c4770c75b1 ("dm-raid: really frozen sync_thread during suspend")
Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
Changes in v2:
 - Move mddev_lock_nointr() earlier to protect dereference and use
   rcu_dereference_protected() to access sync_thread

 drivers/md/dm-raid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index abe88d1e6735..b149ac46a990 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4101,10 +4101,11 @@ static void raid_resume(struct dm_target *ti)
 		if (mddev->delta_disks < 0)
 			rs_set_capacity(rs);
 
+		mddev_lock_nointr(mddev);
 		WARN_ON_ONCE(!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery));
-		WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+		WARN_ON_ONCE(rcu_dereference_protected(mddev->sync_thread,
+						       lockdep_is_held(&mddev->reconfig_mutex)));
 		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
-		mddev_lock_nointr(mddev);
 		mddev->ro = 0;
 		mddev->in_sync = 0;
 		md_unfrozen_sync_thread(mddev);
-- 
2.43.0

