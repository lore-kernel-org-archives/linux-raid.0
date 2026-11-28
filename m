Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795836823;
	b=MkuKjnPZhap60HWUxOMbOSDgcG4noRiwYRpejeMByQHcn/of4RyApUhDH4XKE7tB/Ltw
	 aG9rlu6Kx+4uCz7vlMM/IwEa0oGJP6b1p0PZhMH52hUTEJEwmR2mCucWg/EUq2psc+Twn
	 423PlOZOuMFADPuqdJ2ZBvS3ibleHhpEwGxolMJ+Vr7A7X0IC/6XklvfFgZRf4v/YsU1N
	 /nvSTb3BBJp1on+XCxpqWx7al7ImJJ3qnQxrNOojt35WeYkTXiM1ojRNgM2YNEqGErAR8
	 i512YZg1mqPcHejAciPJLjzG663QoMRSGidoQP1hcnPolhQQsZD3WMADV7hQQmbXNWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795836823;
	h=DMARC-Filter:DKIM-Signature:To:Mime-Version:Content-Type:Date:
	 Received:Cc:Subject:Message-Id:X-Lms-Return-Path:X-Mailer:
	 Content-Transfer-Encoding:From:X-Original-From;
	bh=ALp6HnmQsKol/hofmSCsgnP6QluqgfFWpTWFFSfdrvM=;
	b=tIYYZ9k1djVVeZFkcnt/B1M3OgPljDWLZWwCPBqAz/59n9oJ0vEC6O4N85MbAh1o3f9F
	 PWlMRBFpTWGRMEu0XCeA6IQOZGzZUNTJVAyI/XftKdi82oplaAspCDHsBT6UXPeb3kTSK
	 BRJ2U1HFjQASBadDNxbPHTBHDm4S9wyjrdo7+ga30cc49+DyIBztGjoZrhSYnHwo/JEu5
	 2qRkrJzv45jpainvSMaJ7OJSn/6nJmeL61AMNuaHUrPnzFLmW2OIhbw4XCKy6z8yQ1qo4
	 NyMLSYKAZ/LI8VpObLOxpELy50gdREynjMGuaH9xRmxSMYXyhoZhxzPshi/BQDGD5OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fnnas.com;
	spf=pass smtp.mailfrom=fnnas.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=oHZRv1Ed;
	arc=none smtp.remote-ip=209.127.231.26
Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCC2606A31C
	for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2026 03:33:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BCC2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=oHZRv1Ed
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1795836818;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ALp6HnmQsKol/hofmSCsgnP6QluqgfFWpTWFFSfdrvM=;
 b=oHZRv1Ed4VZmwFgQkC8nSJ60rZvvewfbIwPcyAnBScgHNoo9qxWP6vXMxGkXgLuvry/kHj
 CJ2zIPTJw25Qgp4zF+hZSd0vsd6ZcIccgAX7xFHBXjXeTtoVfSdVaj/De19yiKXdd/rN7I
 /s9e9iLwhwOofi4ua4u6iJ540l3++0gxYGmctRWLUWBrTuexOF9xVmfVOgteLxzjzSVhht
 uySjPDsBbK3Tu0c6qFjOg1W3sfH/3OevYsS5MxXxcDbmrs9ddzLHVvIqgIrpnOV8BYpw/z
 mobit6K9uQIAp+/4mzlAW313VdsRKxizzh5huZIIgec/t1bNIZwCqEMrWEHCbg==
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Sat, 28 Nov 2026 11:33:16 +0800
Received: from fedora ([183.34.169.94]) by smtp.feishu.cn with ESMTPS; Sat, 28 Nov 2026 11:33:26 +0800
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <nixiao@fygo.io>, 
	<linux-raid@vger.kernel.org>, <chencheng@fygo.io>
Subject: [PATCH] md: identify array and device in metadata write errors
Message-Id: <20261128033316.3082583-1-chencheng@fygo.io>
X-Lms-Return-Path: <lba+26b0a4b86+3b67ec+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 7bit
From: "Chen Cheng" <chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fygo.io>

The error log in super_written() does not show which array or device
failed. Add both names to help locate the failed write.

Signed-off-by: Chen Cheng <chencheng@fygo.io>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..5c4c721dbba4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1107,11 +1107,12 @@ static void super_written(struct bio *bio)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
 
 	if (bio->bi_status) {
-		pr_err("md: %s gets error=%d\n", __func__,
+		pr_err("md: %s: %pg: %s gets error=%d\n",
+		       mdname(mddev), bio->bi_bdev, __func__,
 		       blk_status_to_errno(bio->bi_status));
 		md_error(mddev, rdev);
 		if (!test_bit(Faulty, &rdev->flags)
 		    && (bio->bi_opf & MD_FAILFAST)) {
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
-- 
2.56.0
