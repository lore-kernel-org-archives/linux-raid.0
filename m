Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D1B2E92BC
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410806; cv=none; b=qi0+kSAwru73GPQK+KUbQCplYVvqZEvu3Nf0DQG2aKMwTB/Xj6bt78665PzWxacCz2lcFxrN3Dtxh62hLpJkUST14jMQfdC/aRCG3vcliYOeoiiDQPj5AvSgPIqP0Ub0jTCPqDxA0mptjllqlNEAq+1RDmqxkb2WIm9LLoR7s5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410806; c=relaxed/simple;
	bh=FvDJ3PXx7WTjXPV2mZAIdQFFtOA5IdOuT//UUvQxIX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKyj+PwrkBG9/rPJkjgSVhM6u9gY5A1SxMwsiSRY14aiDJqJRJwvVa+mwmInRf69tBae4VgfdHiVDDfdGEKOPk5mMaKnKfm7Hu+SpFx0kjalVwmHaTFUNywnsoFKdFYi45Qc5Egkb26Vo8Hs5/kFm6Uxtvr8QDsxWIlBWK0KEOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4130CC19421;
	Wed, 14 Jan 2026 17:13:23 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH v5 11/12] md/raid0: align bio to io_opt
Date: Thu, 15 Jan 2026 01:12:39 +0800
Message-ID: <20260114171241.3043364-12-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260114171241.3043364-1-yukuai@fnnas.com>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The impact is not so significant for raid0 compared to raid5, however
it's still more appropriate to issue IOs evenly to underlying disks.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid0.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f3814a69cd13..0ae44e3bfff2 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -29,8 +29,7 @@ module_param(default_layout, int, 0644);
 	 (1L << MD_HAS_PPL) |		\
 	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
 	 (1L << MD_FAILLAST_DEV) |	\
-	 (1L << MD_SERIALIZE_POLICY) |	\
-	 (1L << MD_BIO_ALIGN))
+	 (1L << MD_SERIALIZE_POLICY))
 
 /*
  * inform the user of the raid configuration
@@ -398,6 +397,8 @@ static int raid0_set_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+
+	md_config_align_limits(mddev, &lim);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.51.0

