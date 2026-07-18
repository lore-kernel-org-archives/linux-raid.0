Received: from sg-3-30.ptr.tlmpb.com (sg-3-30.ptr.tlmpb.com [101.45.255.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A61A279DC8
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 03:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784347084; cv=none; b=WUjy0yGx17WSLrSjdCbL6wOXPHCHWY33MX5TadIoNk6QAIOUUYpCU/pnbuKLAeSEd63tmktrTWNTrbpwfV48YSDnbEl4rKxk2UoXdUMMEmuavcMISPm7Rhvs5vCjhoDt0l8fUhmfqNvOEN0Id/TTKG1iUbsCMuMay8i54hk+I/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784347084; c=relaxed/simple;
	bh=bLC49C1y2Zrv8Szte5dF0aZO55IyksZVXSqvwCHgkGM=;
	h=From:Message-Id:Cc:Subject:To:Date:Mime-Version:Content-Type; b=J5+pk3RPq3rW8LpkMitJYPkUvhueCglhx/PwmB1HiYR0TtiM8hXNKINUKy0/qcuacg+U+/FchWBYcGjg7QtOEMj0MVOE/+5CYoXtRivC4kxBj3v09rxZtvPSj2MYSD7xwdJXIZov+H+w995Ybeji/hAfGlUzhrBBxJCvZ96PeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=RsZoz9k/; arc=none smtp.client-ip=101.45.255.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="RsZoz9k/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784346169;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=YM4PnXM/j1vE5qfrs53d3v7JkyDKT4G0ya55CDBjepQ=;
 b=RsZoz9k/b0HmChhN7xXY757iGga8faHc0W27hPwcLE0V/EX63TgjGz116l08W71n9hI3qZ
 JaqnyBGS40/FGFNXCn+IHFmgjPv2cSHshwZ72lTXOP1K7YyftspyeV3Z8KuDWaDkLvzoEu
 V8ZdTi5UCwOsyT8CFV2D9wnhG9LS9TbIlwsqyyz+Z46Z+Deb2jLzI0QJN7X1g+A8dE+1c7
 8u1pnNy+NPNELmWq+VWwhuufnoBqnwdUlONb2+5atW8AXF98fmZoILGPFKQe33m+Bl3fAi
 Rvw0iHW3ZCgJ0GRx7N2xrugvt9VLdVVgwgxLPVwOpbW1pttGXiJym47Io4pmRA==
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260718034236.4119093-1-chencheng@fnnas.com>
Received: from fedora ([183.34.161.69]) by smtp.feishu.cn with ESMTPS; Sat, 18 Jul 2026 11:42:47 +0800
Cc: <chencheng@fnnas.com>, <chencheng@fygo.io>, 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] md/bitmap: resume array on backlog_store() error path
Content-Transfer-Encoding: 7bit
X-Original-From: chencheng@fnnas.com
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Date: Sat, 18 Jul 2026 11:42:36 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5af637+08fd8b+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

backlog_store() suspends the array before checking whether a write-mostly
device exists. If no such device exists, the error path only unlocks
reconfig_mutex and leaves the array suspended, blocking subsequent I/O.

Use mddev_unlock_and_resume() to release both states.

Fixes: 58226942ad3d ("md: use new apis to suspend array before mddev_create/destroy_serial_pool")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 028b9ca8ce52..3e40cb45d473 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2854,11 +2854,11 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 		}
 	}
 	if (!has_write_mostly) {
 		pr_warn_ratelimited("%s: can't set backlog, no write mostly device available\n",
 				    mdname(mddev));
-		mddev_unlock(mddev);
+		mddev_unlock_and_resume(mddev);
 		return -EINVAL;
 	}
 
 	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->serial_info_pool) {
-- 
2.54.0
