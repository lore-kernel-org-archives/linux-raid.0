Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4604C23EAB8
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 03:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772594050; cv=none; b=Dh2V7dW/8J8IQfM6rMDpSNfeax8OV/s0AhUaSGak4URHxVYihTSil6aH2B/ysk629m272WtywD9kfjpU0ddSArrBrH9RUJmvCgRmxcZ5wH7tF49oaqJShnry1Ef6dLgqrji+LuRI7wjxhmY+ZEQBCKK+rY/Yo0PHX4BobsUyS/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772594050; c=relaxed/simple;
	bh=78iOZsUkiBGN851Rx80C3XxEJRoLheMHg8+R6ZXVk8E=;
	h=To:Subject:Cc:Date:Content-Type:From:Message-Id:Mime-Version; b=o1a9QbNr82Z5kqUf6IPGXvbdWYNsX8Phl+LHF7Y9Z1O1mAmGRWsTuuVCGGp9nkk5QqNZROcs9IrYZq3yuTRWpVO1pPiAKF7f4I5MdkEZqWVyo3VjijH+6Bbr9pW6nR6Tu/Imeyej9HzKh3ejCAwR7Y3xYdJ3jNTlNBR5Q+eB+OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=JIlsZ3Ds; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="JIlsZ3Ds"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772594041;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZiVGq/r7EouqTcbckTyGYL6lWoh6CUHHi9qNZ+mCJ0o=;
 b=JIlsZ3DsL96loU8hvUSbTgbQIlBM/dK2VJWwjnxCenAfDl7m+h0FVfITQWVvO/ChTY8MJE
 JAmC5rt6GijZOhbUSfnu3Lxeqlz6ufYaXVFu3g9t++HHdxukq0NHfIVe7dS/d/SEdN4C6P
 bO7zPUPRkUkN8zZxIhIh9dX1/4d5KQHst8S/0k4eR9234bbO/DxLXwTrCcmERqNWzRCiNh
 +xgkghGoE/3WrZA/tEmnBKTHfEBHuMmYnmZ9vuX5MNmXUZ9y5wXMLXCmNajOMWrIg/VSRv
 2m6bXEWRmcfZgB+ylcfzSy0nRfuCG/8FWZhVGP0JShsqdchkKMTNhnLg6a1Y0w==
X-Original-From: Chen Cheng <chencheng@fnnas.com>
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
Subject: [PATCH 1/2] md/raid5: remove stale md_raid5_kick_device() declaration
Content-Transfer-Encoding: 7bit
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	"Chen Cheng" <chencheng@fnnas.com>
Date: Wed,  4 Mar 2026 19:09:18 +0800
X-Lms-Return-Path: <lba+269a7a377+7b6065+vger.kernel.org+chencheng@fnnas.com>
Received: from c ([113.111.140.155]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 11:13:58 +0800
X-Mailer: git-send-email 2.51.0
Content-Type: text/plain; charset=UTF-8
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260304110919.15071-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Remove the unused md_raid5_kick_device() declaration from raid5.h -
no definition exists for this function.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 110b1c2d0a86..1c7b710fc9c1 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -801,7 +801,6 @@ raid5_get_dev_page(struct stripe_head *sh, int disk_idx)
 }
 #endif
 
-void md_raid5_kick_device(struct r5conf *conf);
 int raid5_set_cache_size(struct mddev *mddev, int size);
 sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
 void raid5_release_stripe(struct stripe_head *sh);
-- 
2.51.0
