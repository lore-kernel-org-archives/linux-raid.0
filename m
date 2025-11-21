Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E592FB983;
	Fri, 21 Nov 2025 05:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702062; cv=none; b=cHiYM/SjX9YUun/Nv3oQqTAqoebJ9parzYbCX3YuNUS2JjgGPQ8zDtbnMBYIOqxO5IxD44HNNpPRXoH1rUQYt4lcxDZ4FhMBGuhuv/iwoDhhPoMktIHjOWu6xbXCURAbMYdYOzjgCMHMEF96+dUcBT533vKG96oEQbfIfXQLAV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702062; c=relaxed/simple;
	bh=1t5HNSEerc3b6cfSvsSN6hrE9PL80lCiXEwFQX75d1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1B4x9zIZEdnO+rrCUAQI4BSC8uz7cKen6pPrD7z2DyFjfTM+NbPtz9EUND7XQZA9jeTwDFLuYVksTpj6973CQklq2wCeAPlXmRwh2Ob6syyPFxEbr6174VQlL0M7+3IYzWfJUzZ0JS4vGvbn0vyZr/KndzUB/HQDHJCbYIUFq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2FAC16AAE;
	Fri, 21 Nov 2025 05:14:20 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 6/7] md/raid10: align bio to io_opt
Date: Fri, 21 Nov 2025 13:14:05 +0800
Message-ID: <20251121051406.1316884-8-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251121051406.1316884-1-yukuai@fnnas.com>
References: <20251121051406.1316884-1-yukuai@fnnas.com>
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
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 84be4cc7e873..f6a4bb26fb4a 100644
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

