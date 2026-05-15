Received: from sg-3-30.ptr.tlmpb.com (sg-3-30.ptr.tlmpb.com [101.45.255.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D98640B6F5
	for <linux-raid@vger.kernel.org>; Fri, 15 May 2026 09:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778837480; cv=none; b=TifiXEe5drsxp4NOQO0jnpUIjLj4Qhm60qRdR9QxNC3RdBhmxu+wsfvmRdtUn1sV//YybOphWaOFs6uWJ0ROpiitu2LGJzKq3Rpzdo1f4CPgAAYa54DDKdj0opxIlcpwKpLwkYl7JZ2mwQBsOUO0QxZzYLV/T0V/xejsURiknIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778837480; c=relaxed/simple;
	bh=2opvUb4OtaoiL4k3wiPurNwrs5IfTPEgV53KDxFBQdw=;
	h=Content-Type:Mime-Version:Subject:Message-Id:From:Cc:Date:To; b=dC/AtscQmp2GBVZMQkYxXSD0z4k/zxeVEusbjFFaaabY0Bf1P8VDy6DWKDEL2KJbmngY++8ErkL7n308nS0DjDSjRCe4JUcVJMF9gsH2xT7GZxWTTX1au6nultRVjsCDvmj4rFzTtwvuMfCGqm4kxIsNJ9iQCteJZdO9cl52E0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=FHXHk9ni; arc=none smtp.client-ip=101.45.255.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="FHXHk9ni"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1778837435;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ANACnnkkHh07fsvxobSrkre4lrT57jSbJan6Hvii+tg=;
 b=FHXHk9niCriZJZ4sSq7MqRqP1+gSgmQbEdi3KHL2hUYH41Mj8XG3e8Lmu4yRsKimKhuK3g
 p/t05aFIPnn460N/8cLPFGPdv88Dy6enhLFU/sOJtr1MGA29arevXDoYLEjCQRmhUw9Kj5
 2j88vC67Q/7zARuKtbG8n6ZWPX1kxfjsDW+NYQrvxaiVZmhzDdOrezdhDeZlNlvDpnjtmD
 +w92PnutLryyCaIIuYpMXrAn2mPMImVOdZhq6V8lcswnAynrnpO+9/0o5ZiYuC1s2N4o3/
 PbupduiETgsXTyKd/IwyOje9heGUa8+RRNoPEL5WF+4alpQ50t5+XwENfbucNA==
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([113.111.244.134]) by smtp.feishu.cn with ESMTPS; Fri, 15 May 2026 17:30:32 +0800
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] raid10_handle_discard() reuses r10bio objects from r10bio_pool.
Message-Id: <20260515093019.3436882-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
From: "Chen Cheng" <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a06e7b9+278cbb+vger.kernel.org+chencheng@fnnas.com>
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Date: Fri, 15 May 2026 17:30:19 +0800
To: "Yu Kuai" <yukuai@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

put_all_bios() always drops devs[i].bio, but it only drops
devs[i].repl_bio when r10_bio->read_slot < 0. If discard reuses an
r10bio that was previously used for a read, read_slot can still be
non-negative, and discard cleanup can skip bio_put() on repl_bio.

Reset read_slot to -1 when preparing an r10bio for discard so the
replacement bio is always released correctly.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 39085e7dd6d2..7dc2a5a127e8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1727,6 +1727,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
-- 
2.54.0
