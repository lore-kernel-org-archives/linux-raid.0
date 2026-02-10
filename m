Received: from sg-1-33.ptr.blmpb.com (sg-1-33.ptr.blmpb.com [118.26.132.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF6033066A
	for <linux-raid@vger.kernel.org>; Tue, 10 Feb 2026 07:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770707615; cv=none; b=Nh8lYrhxY8lSHQsqCHhFDVE/VVxGq6LINLLt5iyBByvBUpOsAKG0/co0ev3b5NTYRJmBVkxKFiykN+1YPLpKJKBTHMUBF2AizySFqlt036ep8Zdp52Yu4oWXAw0xeQvYIYBalTQBaKXC4tO3DcwT9KqriRBas4SMM+bNMKCzHv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770707615; c=relaxed/simple;
	bh=2pnE9yfQmXN4KbgwupOv6RTp/pZmtEzPGOWwHkIRwsQ=;
	h=Message-Id:Mime-Version:To:From:Content-Type:Date:Cc:Subject; b=pIfrD7OvDGN3Aj6kb9R4LuHBaZBNSBk5zol8kICQRjzCFPsBxByTUBkLyNzhJbE56+eWEmGSRh6EUjDc+lajYpcP0Ymad9j1+5iFDS35T8LWjd2A2gmKGQMsp8++2ak0I9v3Ns6LrPIeF/ZPXPZd4p8Nh0DzrlLfZuTBL6HeMXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=KRQb9FRe; arc=none smtp.client-ip=118.26.132.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="KRQb9FRe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770707600;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=wAA6LX7LBRyZjtQxwL19L2I3w0rzMiaTr7+8y7bAjTU=;
 b=KRQb9FRe3/dSIVk0iFCNd92fI0Jo9gPwpWyKAx4QBy2dyloWuaGoIiNrI7jFx/e6RxfC/R
 Su4Rmymu2vqoMKF5JNzymKnnkxhNVgWnYsgoxuKtms7hFa6sVMJrdpSm6lOlIsPodS4fS2
 SANdrwJtg6OSwouip9pXS94dnWpxKq/zFL2iNHPUODF/Uh530RGFOmLkcX+FVOj7PMepvE
 yf8jluIaeN5KMwjYXdZmuHpwROjVsgX6ICLrGn+fF2iecCBlPB01nhvyV2jt8VL/8KOB9Y
 IHUhsLp3lDPJdpqBcQtvT8leBZjkw0zlUyE6uDtbTeVA8o6yF7ZuHCkXzTxHiQ==
Message-Id: <20260210124114.169207-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <song@kernel.org>, <yukuai@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "chencheng" <chencheng@fnnas.com>
X-Original-From: chencheng <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Feb 2026 20:41:14 +0800
Received: from c ([113.111.140.189]) by smtp.feishu.cn with ESMTPS; Tue, 10 Feb 2026 15:13:17 +0800
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+2698ada8e+f6e8c8+vger.kernel.org+chencheng@fnnas.com>
Cc: "chencheng" <chencheng@fnnas.com>
Subject: [PATCH] md: suppress spurious superblock update warning for dm-raid

dm-raid have external metadata management (mddev->external = 1) and
no persistent superblock (mddev->persistent = 0). For these arrays,
there's no superblock to update, so the warning is spurious.

Signed-off-by: chencheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a..e30b658641e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2790,7 +2790,9 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	if (!md_is_rdwr(mddev)) {
 		if (force_change)
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-		pr_err("%s: can't update sb for read-only array %s\n", __func__, mdname(mddev));
+		if (!mddev_is_dm(mddev))
+			pr_err_ratelimited("%s: can't update sb for read-only array %s\n",
+					   __func__, mdname(mddev));
 		return;
 	}
 
-- 
2.51.0
