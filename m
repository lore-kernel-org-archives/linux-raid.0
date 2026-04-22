Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C854737DEA9
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 02:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776825240; cv=none; b=bxr3QzG62jGGx9a/cnkVQstfVY4NomTeIE5T4iEqeB3QHo7c8iKnuOjk1HqCK5GW/mC4xVD3OIQ9GkHW5SJS8Wev27CCAgB5l7i7mz3/DDhFA7XKCtCqaHPf0dX5ab4JTaKAeqOeF+w2Xu4b8LwCKY+AkxITnenVSZDOH2FEH5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776825240; c=relaxed/simple;
	bh=GsWgbh7nx6t/enD0kHPUY7lbLJtK6uP7yCbrIoQKFT0=;
	h=In-Reply-To:Subject:Message-Id:To:Date:Mime-Version:Cc:References:
	 Content-Type:From; b=hmdNgZrLAboR0FFbuGcMk67EX7auXv0gNB1+prEdUw1cMFwEhD+Qlw74ZnIVgeBeUF7GAcT+xHeD2BusFPotSp5nqiOEap+C8Yx0g09hXF8TR6cqxHzT5BTt25AtfYMuMbgWQeKSoLgGaAa3aa/szZl9yToDxHz7LYyFMs1W9Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=j17iMPTT; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="j17iMPTT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776825217;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ugfv4TOy4GTI8IpHF+EnqwsM/9LVazP+ZkzIPaUtWFQ=;
 b=j17iMPTTYRbC7OlfX4PwVFgKHzHKbnYC0BFABY/uloQRIzkExdyK1t95qFzATpWi2EULMA
 6gzv/YJ1sj40iq3RhojLwqzHQHGeFqyoFW8Km/3A42xHn/EPHhhmSe8zSfk3qBoJBuC8NG
 Cf+mtgo3KxKVDAc97CDTDaG3IBCJ7L/3KpNNffsSftpCbe07fSm0f8VTgePnQT04ACXn2Q
 jObV9N44P9wBNxu/azbMI+LLPBFAt1tBtwokAPv4XTDR5AfJ0z/xeGjfEF5Zqg0+qG78et
 QgnowOIbu3NRYbzN84vB82ikv5v93WBngKsRtU5/FM1Garu4HyEoWlPPtzFrdw==
In-Reply-To: <20260422023317.796326-1-chencheng@fnnas.com>
Received: from localhost.localdomain ([113.111.140.171]) by smtp.feishu.cn with ESMTPS; Wed, 22 Apr 2026 10:33:34 +0800
Subject: [PATCH 4/4] md/raid10: reset read_slot when reusing r10bio for discard
Message-Id: <20260422023317.796326-4-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+269e8337f+6419f4+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
To: <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
Date: Wed, 22 Apr 2026 10:33:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>
X-Original-From: chencheng@fnnas.com
X-Mailer: git-send-email 2.53.0
References: <20260422023317.796326-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
From: "Chen Cheng" <chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

raid10_handle_discard() reuses r10bio objects from r10bio_pool.

put_all_bios() always drops devs[i].bio, but it only drops
devs[i].repl_bio when r10_bio->read_slot < 0. If discard reuses an
r10bio that was previously used for a read, read_slot can still be
non-negative, and discard cleanup can skip bio_put() on repl_bio.

Reset read_slot to -1 when preparing an r10bio for discard so the
replacement bio is always released correctly.
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3edde440623a..19d7f6f62beb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1764,6 +1764,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->read_slot = -1;
 	r10_bio->used_nr_devs = geo->raid_disks;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
-- 
2.53.0
