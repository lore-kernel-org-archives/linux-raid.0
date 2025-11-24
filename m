Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DE322A4D8;
	Mon, 24 Nov 2025 06:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965948; cv=none; b=ik5yFT7UJOYA7sYWlh3CYojSoYgBtNC8NetaHAzLUqd1Xzxa62IVP93N//gqsj2jpiHGU/qo2OAkXvrFwP/A57fEPH9Zp4AGiIpgsDLVTOtxOxhyaxOXs6FZ1tCrqSEYTMI4uw0exSoBihEjnCw3f8qqoXiB+HDXSJbuf6ef00Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965948; c=relaxed/simple;
	bh=b91I3Xtz94sY70J4NWdlUmmQNLfTHM3GSNW92lDHvpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t60dqbyaS70yBBK3hTFlJIjIBvZFlKpdWuPKSGx9y5Ia4LJVTZxedClWf9Z/zDTuX66HZgnOtzsajp1BE/gMxM4O9LXQfU65nXC5+cw7baKNDRAwMLYzM34wUvQEuRK3tK1YvHEYRP5wvc+u3PMHPOkLHL9EVc2qx4EqzhpZPVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2393C19422;
	Mon, 24 Nov 2025 06:32:26 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 10/11] md/raid0: align bio to io_opt
Date: Mon, 24 Nov 2025 14:32:02 +0800
Message-ID: <20251124063203.1692144-11-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124063203.1692144-1-yukuai@fnnas.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com>
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
index 01cce0c3eab7..c94c6f78767f 100644
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
@@ -391,6 +390,8 @@ static int raid0_set_limits(struct mddev *mddev)
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+
+	md_config_align_limits(mddev, &lim);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.51.0

