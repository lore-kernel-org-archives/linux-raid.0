Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586FB34EEE4
	for <linux-raid@vger.kernel.org>; Sun, 11 Jan 2026 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768156041; cv=none; b=IOz4H3b9ypMjzB5/9WxeJg0qMfsu42Gc0+3vz4hrWfbFQJvbIxnJbcTBowEt2w1g6qzNB2tPX/lCsDRoCnCjNN79kIUTZ0+GCnmeomV88BvHJwfQITsTeQk86VKv2IRDuFAXgq/vWE9VaMRTlTBbGRl/uqzr9wBcHxUIFkRRraw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768156041; c=relaxed/simple;
	bh=VcvRT2kU2+Gnxw5qLlh6oIKyHJ18/RTCihIZilmokSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/DqpQiHf2az6mq9dP4EFLrLektZ6Gcfzz7uW2SGSOEOfv5jHpkY3i//6x1k2JIecP54hX8dZyJHA52RUf0cHt4R7laaVjBNmjq+211CCgCtZ7NLW5vwRjeQAk1VPeSwVDia3/gm28RvpkTtTuMnmlI90xnevNR3u181KuCxSGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5DAC116C6;
	Sun, 11 Jan 2026 18:27:17 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org,
	linan122@huawei.com
Cc: yukuai@fnnas.com
Subject: [PATCH v3 09/11] md/raid10: align bio to io_opt
Date: Mon, 12 Jan 2026 02:26:49 +0800
Message-ID: <20260111182651.2097070-10-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111182651.2097070-1-yukuai@fnnas.com>
References: <20260111182651.2097070-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The impact is not so significant for raid10 compared to raid5, however
it's still more appropriate to issue IOs evenly to underlying disks.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 09328e032f14..2c6b65b83724 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4008,6 +4008,8 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+
+	md_config_align_limits(mddev, &lim);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.51.0

