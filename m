Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FFE2C0F83
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455194; cv=none; b=bCLhHdGtJbjgNhtzN6IT4QpSLNONuvEhFxqT0fA+5TAZlEKTHzoXj7GxHI2psmg1G/911UrTJzVRcs7zkhn0v+nqfT6KgHRq9bCEPSP0EqJ4wRjBsdlBMVZNxLgL8HogAeSYDwuRSSs9dCrZvLfokz4wb88By4JVbST4n+z1l80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455194; c=relaxed/simple;
	bh=2qscii3tVh5B8HqwYWbfnseGtHSluGtv6DMTLIVxfJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3WA3Qxke8TMwB7NrGNitdmmWUd9O8HXIkfIW1/cDWesQ1YT+wSJBTFCeHLt53W8Wi/1tKES1/AbryzenZjqPgeFK7Un+XY2ZdOoTCSnNbYawaaUXASyNrpienMUQH3YftwyXKyoyMerupLHQhVoOtFHAVCGtnHXHADqfU12qLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32031C19422;
	Sat,  3 Jan 2026 15:46:29 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 10/11] md/raid0: align bio to io_opt
Date: Sat,  3 Jan 2026 23:45:42 +0800
Message-ID: <20260103154543.832844-11-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
References: <20260103154543.832844-1-yukuai@fnnas.com>
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

