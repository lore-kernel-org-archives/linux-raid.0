Received: from sg-3-29.ptr.tlmpb.com (sg-3-29.ptr.tlmpb.com [101.45.255.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D442F707
	for <linux-raid@vger.kernel.org>; Tue, 11 Aug 2026 10:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786444040; cv=none; b=RGVtvpuRer8QXa5hSElnyMTnSH0DULZFaS6Y8t0U5nfyXa7QpdWG2FUR9yygTxwz0JtRlVVTiaUrgGn4ocDGXwT8lZ9mwXviKSyi4ezwAy3upe417D2CnpAYHtyqmydTd+NwGfhixxQ9e2CAck9jIi7IQspyVZt1rVNE6wTXBV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786444040; c=relaxed/simple;
	bh=nNqJnw6dWfsKqDN6/zIT6tMxp/FUFPB5sRUAPveOxWI=;
	h=To:Mime-Version:Content-Type:Subject:Date:Message-Id:Cc:From; b=h1CiG1ZRP42UJaC++O2l8REYCUJqeD06T2nxqsZBKONf38NbRGefBa8v0hdrgX6BfIzYM3E8CKpEG1f49Agg8riTVlttwtYZKrbFD3QDnpisbHjOJRZN5rO7ysrnQbEEcZw+vzNAcTDoc/xj7ME3gJE772QGUlH0UjhNEYVxjM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=vy5kQct3; arc=none smtp.client-ip=101.45.255.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="vy5kQct3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1786443298;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=or7qsoTRDcUrSqtp0cahORvlTJsncX2WyWBQes98vQE=;
 b=vy5kQct3j4p/4JYxgwx7soJLQZHftWB4wigV2AyorP5YfX3iYE4xfbxGZqUiDHe00Jg59d
 inr+PjtihK3Yej3o4KF5LsmencPyChWn2XPSQVELvbVRwhQKibdpm9Saq9yw9JxrUYeVt6
 7pGtQ0bUCI1J3V9JbuJNthSM2Me8vj7eT8+56Xvkx0du+347cdJ5Ss/NsEFQ/qeGAWsoEB
 zrm8+6hDAUa1dGHRy5VjWwrWoGF3yBXOa4x+hOh6PtjuA/1YiLDC4Gi1g6szYIqjaqFr0y
 f7BpGRzCu2KwpBMs796WQ2fExtSn37EtFJJn6Tp3DsRjqCy6U6Diy4Rl9S4N6A==
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a7af621+cb3e2f+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from fedora ([183.34.168.106]) by smtp.feishu.cn with ESMTPS; Tue, 11 Aug 2026 18:14:56 +0800
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH] md/raid5: fail invalid raid5_set_limits() geometry
Date: Tue, 11 Aug 2026 18:14:36 +0800
Message-Id: <20260811101436.458181-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>, 
	<syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com>
From: "Chen Cheng" <chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

Prevent raid5_set_limits() from building a stripe size when the array
geometry reports no data disks.

Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de94ddbfff0c9e6fe030
Fixes: f63f17350e537300312 ("md/raid5: use the atomic queue limit update APIs")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ffb5fcde54a9..c0adb73b1dd4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7825,10 +7825,12 @@ static int raid5_set_limits(struct mddev *mddev)
 	/*
 	 * The read-ahead size must cover two whole stripes, which is
 	 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices.
 	 */
 	data_disks = conf->previous_raid_disks - conf->max_degraded;
+	if (data_disks <= 0)
+		return -EINVAL;
 
 	/*
 	 * We can only discard a whole stripe. It doesn't make sense to
 	 * discard data disk but write parity disk
 	 */
-- 
2.55.0
