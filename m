Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056B885931;
	Sun, 28 Jul 2024 00:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127719; cv=none; b=hv5Tdm1zvg6XGJnJzzIEN0GrRqnjnYkRPrJ6zKxxSbN9/RAILGv+x0gE5Obmc9D4OTGTWzbLdByxetbtnlrdZK0O1A1+RsTm3061quEbBVnJqP99XEXUfpepedLz2BVNtSSli3r/9zhfOsGSYjMa+QxlhiHf2rLaz5Oae8UDEp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127719; c=relaxed/simple;
	bh=PZfwiwBH8g5fqtq581pxbehN+w7UTYxYyMIHwkr/WUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSs/FWvJ8q4VCpsfS7zcq5kVdXHpbImUQgZa6oOhM7jbClO4PKeS4gUxwxUMrm6XjBR/dGMEWMWkbajCSXSmcEX7WRSuRs3iC3ee7KhzIF9/96aj6CjjzJsXBi9iXnIl2HvkZeDrcTeXTdNhx/K3Ktd0YRDMCHMiv7pYpFQEn70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ech+XVR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ech+XVR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30CFC4AF0E;
	Sun, 28 Jul 2024 00:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722127718;
	bh=PZfwiwBH8g5fqtq581pxbehN+w7UTYxYyMIHwkr/WUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ech+XVR7202BOsItxBuqJSn66rH4WE3lyzCPIuBu9dOAvEW4kPgTxzzmlsrMLj5PH
	 EBY+iSL1ACNb+k1e0Z5X98Hq86k0QBfyz0MgsTwJy/zM1MfevtHhW/Qu9N09l7ra3X
	 BeBTOFPoTxRqPLXya/OCUnfWBI2c8bBoPjSHswbmOVV0D8H+rgw4omyiTgVDK0BG7b
	 nkIpen9VhdXvCHgGSUeX9yK3bgTHf/yQJJxyYDziyoCg/YY1NvkqI29XP/uDO/48t5
	 MSdDOdfF+f6IazGk80/t40c0QoVfgQpjb5aPaJy0jxeepzteQAPD+XER3Sd7iNsfvy
	 9Oh45EEkmvoAg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 3/8] md: do not delete safemode_timer in mddev_suspend
Date: Sat, 27 Jul 2024 20:48:25 -0400
Message-ID: <20240728004831.1702511-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728004831.1702511-1-sashal@kernel.org>
References: <20240728004831.1702511-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.102
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
index 506c998c0ca59..4183ba70fc143 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -489,7 +489,6 @@ void mddev_suspend(struct mddev *mddev)
 	clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 }
-- 
2.43.0

