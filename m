Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3EA2C1A2;
	Sun, 28 Jul 2024 00:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127676; cv=none; b=hQiAACvweJP309CgE5EDuMNbaCWSyAn+pbhXy2WqwUgwll6i8wYXuimfbEwf+hmasaN/tx9G/JT7NTxQF70d3PROpOoyccgpDa+l6iDZvYChtC+0//EbFVDrM1Se3FGmSpR/UQrYFB4M7clKJYxCdEI0mZwXAw1QiKUmlY/19YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127676; c=relaxed/simple;
	bh=vWqmkpky7y998daZb3LhdfZBvGnVTPtYWq8CRGlpCOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYJ8a5mj07oJ8vUbaQPnM1Tw5MWLRlTIkRjHD7gnefmqILOldCI8SVzuAVbf8AF/RoaHGfIOYM8xuWT2g9kQEpaMX5zXF5HgOozIFSS40upyZ2vexrPtzKpHjOIVSMPZujBQ47JKBFmuXc2E7xpesZGgQsOq25IM3v/brUAUZv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaJalnMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaJalnMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B012DC32781;
	Sun, 28 Jul 2024 00:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722127676;
	bh=vWqmkpky7y998daZb3LhdfZBvGnVTPtYWq8CRGlpCOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaJalnMvIS/iCMnZLyey/mOblm02NEIEsYNrX5R5wBkeIhLoId//PQxjQ0YmFqnDa
	 V0aCTjezD25cfR09snCzaCwhfBPhCJ2d3V7DwdvU7v8XrvjCz9K8w7TpyBZF4oKtop
	 AhSZQgVAqDBTrPCjCGFIrEjhO9IQ61REGaN0DRne905qpYiPrdHsFEAuV4QM+TNAqd
	 bRRqW2mL0VzFt23hz6cYsY5LTkpqPpD997Kj5dm6iBwsepDiZ90iFf60ajBHvOXw4e
	 cLvNQ8PsI3OcqRwiHoLOydH4IUrWR8R91CPhcfWcfRwA6IsQnAepfMfFmFSSv2SDHV
	 qpZ8S2YIXzbeg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 08/16] md: do not delete safemode_timer in mddev_suspend
Date: Sat, 27 Jul 2024 20:47:25 -0400
Message-ID: <20240728004739.1698541-8-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728004739.1698541-1-sashal@kernel.org>
References: <20240728004739.1698541-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.2
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit a8768a134518e406d41799a3594aeb74e0889cf7 ]

The deletion of safemode_timer in mddev_suspend() is redundant and
potentially harmful now. If timer is about to be woken up but gets
deleted, 'in_sync' will remain 0 until the next write, causing array
to stay in the 'active' state instead of transitioning to 'clean'.

Commit 0d9f4f135eb6 ("MD: Add del_timer_sync to mddev_suspend (fix
nasty panic))" introduced this deletion for dm, because if timer fired
after dm is destroyed, the resource which the timer depends on might
have been freed.

However, commit 0dd84b319352 ("md: call __md_stop_writes in md_stop")
added __md_stop_writes() to md_stop(), which is called before freeing
resource. Timer is deleted in __md_stop_writes(), and the origin issue
is resolved. Therefore, delete safemode_timer can be removed safely now.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240508092053.1447930-1-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff6975..09c55d9a2c542 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -479,7 +479,6 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	 */
 	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 
-- 
2.43.0

