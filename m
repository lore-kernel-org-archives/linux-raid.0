Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5ADB667;
	Sun, 28 Jul 2024 00:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127703; cv=none; b=H2d/GElTMUGri2oEBp/EJSEEAb/AhJweqofukIccHUcQG3Whk9Rki5gEB0Dnp1FYl2KHycR+4y7SLC9vE1xX+pBsL2faZqF+2xC1IECGIi6GkJYRs7db7mCrE8YY+Ets2GYnQF9cHyPKFuaJ8g7EccpTUo2eXgs0FZPD9XRCBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127703; c=relaxed/simple;
	bh=UwW1Ptyf9lHH/SEd7oQPafQJINmKAtPTLvBqfDVLT2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRp97AkTpdSG5r31mEH4Fzt7pyhd34sULyuAoBxota0GVcUlW6uaIzwPwFyU6QL17LWAjdiXG6ZzdKAnQ0FdkMq5g81KYLa3TKCIJvfumyhkadHFDPCd53dBO/C1skal7NGsn9axDD5DdLVUSArK+7glkmUisH6VRQT+qRbpuyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rmwjarPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rmwjarPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7250C32781;
	Sun, 28 Jul 2024 00:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722127702;
	bh=UwW1Ptyf9lHH/SEd7oQPafQJINmKAtPTLvBqfDVLT2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmwjarPNtIzQurLyV20Hlj4kbOJo0PJeRS5k615HQGkRq2ntbfnpGs919Iq126i/q
	 5fiOyDfTI/EfXKc/3LRbVdC4exm72weZsxZ6519uvOwBSi+FKN942j5Os/QdujM3+M
	 xj5OujmNSmXKP8MDWpfhhRxyfhS8slLqTJgiR8nDRlv91NreXdxiPcHI26XUl4abBO
	 KjB3UXChU2rTdYx3ldCnqdMnqhqaM9L+c/588HglkNxffwDWPh8SjsOyS45Hg7jvCI
	 wLzsLhx2wY95aD1HBQE7EQgtKfnL9EVwAmRm8pgckmCCsJtAowZfX6S0Lu3VGVIxMl
	 iRlIRmXxRc5VA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 5/9] md: do not delete safemode_timer in mddev_suspend
Date: Sat, 27 Jul 2024 20:48:06 -0400
Message-ID: <20240728004812.1701139-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728004812.1701139-1-sashal@kernel.org>
References: <20240728004812.1701139-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.43
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
index e4d3741234d90..60a79db9d9300 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -456,7 +456,6 @@ void mddev_suspend(struct mddev *mddev)
 	clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 }
-- 
2.43.0

