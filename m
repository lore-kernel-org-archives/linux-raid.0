Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749323A8E4
	for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 21:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718142937; cv=none; b=Hgjq9J5vYIg84UeTl1pKNJ9p1wLn4ZS9RooBxaOD0xzfe2SMuXkg03/mUkomsCL3F91zY58Df5M2maG08Mzj8ME2V+0M0acH72cwF8kdmhcYhjvNMk1LBNxY3wMvCJ2WReae7ejjNLaBeHU/vlr6hlo9kVAIgYfnyZz0WUyvgFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718142937; c=relaxed/simple;
	bh=ydcszPds9Q8wjYTmWNKsRyQpCOtFVJM1WY0wGDAnSsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ca8qGTD2P0GKtAdFSpRTrNj2nNquPqGes/hz11C/zfkYcb6YN8frkqLcQAPG4DeNNjTHmvNpqMqLUJZ1/sMnlR5kg8Wlc0DoUpE9PWMUnEQrSsSoPX3U7/SJi4dtJnOPzhjWrMkaOvgew7skoUNgRiQv6HvP+1nRXI5J/3zNSHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b1in5q+m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1in5q+m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718142934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+TqKYAez/hxTqVfmLssX0Ecvqh+J6mwoKVVrjhsfLRk=;
	b=b1in5q+mQAG5ar75E01kvoGdOBXk2j2u7aYNQnxhiv+HaKYVZd1kN12lmzpz2E4pKMVSg+
	jXj+/UhugsPolTASFD0SBIgnJt/tcJj6AdN+mwG0EJJ4hCZHjTCLwdX44RA9CnIn/Jg7nV
	uMgH3dT3GHW6/WiWLTgRadu+IW8Nz+Q=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-ibfwDUc6Od6nZRPr3O5V4A-1; Tue,
 11 Jun 2024 17:55:33 -0400
X-MC-Unique: ibfwDUc6Od6nZRPr3O5V4A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9171F19560B6;
	Tue, 11 Jun 2024 21:55:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A08891956053;
	Tue, 11 Jun 2024 21:55:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45BLtTDJ846787
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 17:55:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45BLtSgh846784;
	Tue, 11 Jun 2024 17:55:28 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
        Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH] dm-raid: Fix WARN_ON_ONCE check for sync_thread in raid_resume
Date: Tue, 11 Jun 2024 17:55:28 -0400
Message-ID: <20240611215528.846776-1-bmarzins@redhat.com>
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
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index abe88d1e6735..74184989fd15 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4102,7 +4102,7 @@ static void raid_resume(struct dm_target *ti)
 			rs_set_capacity(rs);
 
 		WARN_ON_ONCE(!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery));
-		WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+		WARN_ON_ONCE(mddev->sync_thread);
 		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
 		mddev_lock_nointr(mddev);
 		mddev->ro = 0;
-- 
2.45.0

