Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795838749;
	b=0nZ2eWbysLywxbFHHB3D5SexmTR2AOLvsv9x1c74JzPT5KMc0HV5/IuMFIxmCkNdSW3+
	 jaEbLPsYgItLNpm/nEVJbZjy7osHonIum2zrokGFpZ3RI5gJ15Y1YXCBkgTtFYeq95E07
	 Woyq3p3YTIKlYx28SqOaC5W9CzIAwGWsyJreN6xf13sZeaUPwEFWXzWixDigRzeNIKlXa
	 EIdzLg6bzz57vlePsR+f3VImFEliwflQdZgnTaqBXhEh55mF8zTxOfL/3U/1foVfhjTth
	 tkyeg15NhJAGtmCMq/G5vf0xGln75XczOg1GkgA2gzWvnU3w1TgclUPGERu+z/S5BBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795838749;
	h=DMARC-Filter:DKIM-Signature:Cc:X-Original-From:X-Lms-Return-Path:
	 From:Date:Mime-Version:X-Mailer:Content-Transfer-Encoding:
	 Content-Type:To:Subject:Message-Id:Received;
	bh=ALp6HnmQsKol/hofmSCsgnP6QluqgfFWpTWFFSfdrvM=;
	b=G39xkVLSDucn7B3dHCVLQ2oVGD/8OtQvVxwlIppWJ784oX4aWNzWeuw714o0CllzAItb
	 lzBcipX9G/gK75ExUuRQad/BXmRuD90SnKJYBGfqbQz2ffv4SyJ2D4WM5Dr9POB3MntVC
	 F7bgGGbjqYs35qMBzdJ2wGQp/xykT4gZ2szUEeMsEnhGOBUbJgn2UTtbMqHnNZoCYWj19
	 l2yGparv+Z1CfR5dP6fLnsCvppJMNfk/hGB7SwXrkBcSR1t6j+a0Z7It9O+HaVa17eXwV
	 IkIIGYl8VsP5WcpyXcHOyD9VePhcD4pjahmln2MiUKGQh6DcBVfpczd/iDqAlaNPHBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=iI4nDPBM;
	arc=none smtp.remote-ip=209.127.231.55
Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B196606A31C
	for <linux-raid@vger.kernel.org>; Sat, 28 Nov 2026 04:05:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B196606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=iI4nDPBM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795838741;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ALp6HnmQsKol/hofmSCsgnP6QluqgfFWpTWFFSfdrvM=;
 b=iI4nDPBMsyg+kxxRYhRxFgK/qFxxaXXvOBvarQYwDG/rqSX9/E5EQAMaAMJkua7Knvsm8M
 PcP6tiDPwXsEcz3pOVDt4xYcT+LsS7tNhug4wOi0CzNp3doKtSLeOaOVuIC29xAzXVkOgA
 bgtSkV4CaovMJ0Ajf+Fhc6ATVFYEYdYmqMSAOTz9dcCqMrdIvD89hjXhUu3l3BrsDRH+Bo
 2EneEDW9HVV0Y12Q1GOhB+O3mNra6iYot/XvJVizbXUB79LnaW0xRl7Be/RR867MxUxmUo
 hDrERbWvlzcdbvkKXtqDfealPERBQPN4gbiNG+5N0jnsHZbhxwWK+ly4DJUYfQ==
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <nixiao@fygo.io>, 
	<linux-raid@vger.kernel.org>, <chencheng@fygo.io>
X-Original-From: Chen Cheng <chencheng@fygo.io>
X-Lms-Return-Path: <lba+26b0a5314+f6b722+vger.kernel.org+chencheng@fygo.io>
From: "Chen Cheng" <chencheng@fygo.io>
Date: Sat, 28 Nov 2026 12:05:27 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fygo.io>
Subject: [PATCH] md: identify array and device in metadata write errors
Message-Id: <20261128040527.3087280-1-chencheng@fygo.io>
Received: from fedora ([183.34.169.94]) by smtp.larksuite.com with ESMTPS; Sat, 28 Nov 2026 04:05:40 +0000

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
