Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99D32F7F05
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036841; cv=none; b=AJb2WlXXHzOEwT1AoxL6hUNWowfVute7bNLuWQXDhm5JaHQy2LJ0sq0RPYwkJdrltwhQve8cT28uRI5IICbbWVcNF8HLDD/R2+JzCABlCfn+cERbMiPy2768JSiWPZ6yrs8+OpnT+OjHX0DkHRlZ/9rUzhwAjzEcMhzGcAte7Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036841; c=relaxed/simple;
	bh=szdIFnVZgylGKc2n0BYaZd+N/k33uRy5wb8YdUPKLKg=;
	h=Content-Type:To:Mime-Version:Subject:References:In-Reply-To:Cc:
	 From:Date:Message-Id; b=erYizgz4xuWDhjQoCwMmJwNeGEVyebLkO0iFopxwsYkjAMV1rvaDBFmK8UHW6QMJxzobbOvzxEZ43PL1Af5mNacoJiS358XmdwIMwelRe5Ea64m/WSny9DlIcRWg+TcKmzkvEgV5/qtTWdwdUBrWrTaK53HhroXY6CPXDKeMZi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=B4nZGQAr; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="B4nZGQAr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1787036829;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=GVV+VGR8AtIgAO3oYYtjKPhEqqtvJkvnoSHCoX8aQR0=;
 b=B4nZGQArrt8A+ISbZ+SoSG5ekm8/ZS8EUUfhzcN5zh9j6qAomOqMloTuEoiotFyPmXL/3j
 6dySPqwopxv2K6oLQO98pA2/89R8fZ03a0phsPoB7KcyfoHUnAlY3GvFPJkNTfb6c1tj9N
 kRTODY3HcoedNLrbIiFObcfyHCK7seDHFHRc+03vZLr8/VvDGhHFJPPB36Udy6NUrLnmpy
 P5/9V/WtFKeGCrPMFlEDQcTXEOfhcAUyH+t9qptBisr+yvnvm4xRAap15gQYX+OhFIGYAq
 n4bhyoqv52PeSzw9n+vTuof4BN9isEdFpEudD4izg/HAPrawWCBIXCh8iK6oVg==
X-Mailer: git-send-email 2.55.0
X-Original-From: chencheng@fnnas.com
X-Lms-Return-Path: <lba+26a84049b+c49943+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <xiaon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [RFC PATCH 4/5] md/raid1: use rot policy when no nonrot disk is readable
References: <20260818070646.1029149-1-chencheng@fnnas.com>
In-Reply-To: <20260818070646.1029149-1-chencheng@fnnas.com>
Received: from fedora ([183.34.162.43]) by smtp.feishu.cn with ESMTPS; Tue, 18 Aug 2026 15:07:06 +0800
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Tue, 18 Aug 2026 15:06:45 +0800
Message-Id: <20260818070646.1029149-5-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit

From: Chen Cheng <chencheng@fnnas.com>

has_nonrot selects mixed policy or rot-only policy.

Current:
1. has_nonrot is true if conf->nonrot_disks > 0.
2. nonrot_disks counts every nonrot disk.
3. A Faulty disk, a rebuild disk, and a WriteMostly disk still
   count.

Problem:
1. The array is NVMe + HDD. The NVMe fails. Only the HDD can
   take reads.
2. nonrot_disks is still 1. The code thinks this is a mixed
   array.
3. Sequential reads on the HDD do not stay on the HDD. Mixed
   policy will not keep a rot disk.
4. Every read still advances the nonrot round-robin, though no
   nonrot disk can take the read.

Improve:
1. Look at disks that can take this read.
2. If none of them is nonrot, use the rot-only policy.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid1.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 523b55d42779..f476d4dea4be 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -793,10 +793,28 @@ struct read_balance_ctl {
 static int raid1_rr_pos(int disk, int start, int n)
 {
 	return ((disk % n) - start + n) % n;
 }
 
+static bool raid1_has_readable_nonrot(struct r1conf *conf,
+				      struct r1bio *r1_bio)
+{
+	int disk;
+
+	for (disk = 0; disk < conf->raid_disks * 2; disk++) {
+		struct md_rdev *rdev;
+
+		if (r1_bio->bios[disk] == IO_BLOCKED)
+			continue;
+		rdev = conf->mirrors[disk].rdev;
+		if (rdev_readable(rdev, r1_bio) &&
+		    test_bit(Nonrot, &rdev->flags))
+			return true;
+	}
+	return false;
+}
+
 static bool is_better_disk(unsigned int pending, int disk, bool nonrot,
 			   const struct read_balance_ctl *ctl,
 			   int rr_start, int n)
 {
 	if (ctl->min_pending_disk < 0)
@@ -814,11 +832,11 @@ static bool is_better_disk(unsigned int pending, int disk, bool nonrot,
 
 static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	int disk;
 	int rr_start = 0;
-	bool has_nonrot = READ_ONCE(conf->nonrot_disks);
+	bool has_nonrot = raid1_has_readable_nonrot(conf, r1_bio);
 	struct read_balance_ctl ctl = {
 		.closest_dist_disk      = -1,
 		.closest_dist           = MaxSector,
 		.min_pending_disk       = -1,
 		.min_pending            = UINT_MAX,
-- 
2.55.0
