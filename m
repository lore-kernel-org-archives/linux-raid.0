Received: from sg-3-27.ptr.tlmpb.com (sg-3-27.ptr.tlmpb.com [101.45.255.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E693EF649
	for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 07:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975774; cv=none; b=BHIykaRQ+mmf8jEEcHChc09LPvLRnu+I99q+PG8s/eDDXJTCDPJfA+p9Bz2gBR02qnEzj49gfKarXQPl4FF2BfKfxoRMf+NxKUzMy9ZfyM9KBOluspAhEvNOPta/bpsP7siYB03z1WeInivdf1Qs+o/4hMO3y2MUvQ7ja5gsgmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975774; c=relaxed/simple;
	bh=REG5VM0WoqH87NL2m7oaigwnpybarxJ6L9mxdB2DD1c=;
	h=From:Subject:Content-Type:To:Cc:Message-Id:References:In-Reply-To:
	 Mime-Version:Date; b=VhHqVgMjPo+EKA9mVnnGCc8+8rdKzrgF63Gj0fank3krZlTgEgmzJzzDgJMzjT4JD8Pnp9d79K/af0uEqDpQLa+uNIFRM722A/S8CRT4geQuPQLhtVSv1CEWFmdxU51sKbBzGKh96YOyJhqAv5Mp/BcUe40gCJIQuU+Q5WFOzmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=lYvYXGKR; arc=none smtp.client-ip=101.45.255.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="lYvYXGKR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1789975030;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=GjxHeUMpZWDwj+6VEZihWl8Z9HB3V7h7zjrsvBAGVAI=;
 b=lYvYXGKRg2SuUY10xv5Bkyz++jWL0gAihk0zoN5UCv5nwyQ4749KqkhPel5m90qfJaLt4q
 Cy0XNgr3X+Ko+qS5/PJFQNBvgUABzoCqwFD1dQ3BsYrxKDq0fAHG5DM6Aa61VGNHcernTg
 YE9EXVoXAXdVNzN2+U6U0xJQdf4Hp6HjvEV32GsHbCVTDeR/c1mDiId5G3ZmUwMCCQw/U7
 dBkdaI9JrozcxDIub039OCP9cpjl7OQe3ACouuRxVqW76AD8m6QBiorABLeu209Uk/XFSI
 hnpiFpaR2e6I2h/xNtAE87b3yUdmDJ0XkLECtM+aRDYWwk6PgRzZum5axci7mQ==
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH v2 2/2] md/raid5: reject invalid reshape disks in raid5_run()
X-Mailer: git-send-email 2.55.0
Content-Type: text/plain; charset=UTF-8
To: <yukuai@fygo.io>, <nixiao@fygo.io>, <linux-raid@vger.kernel.org>
Cc: <chencheng@fnnas.com>, "sashiko-bot" <sashiko-bot@kernel.org>
Message-Id: <acf8254263d4d40bd65c5b39058d4527cfb44cd9.1789974245.git.chencheng@fnnas.com>
References: <cover.1789974245.git.chencheng@fnnas.com>
In-Reply-To: <cover.1789974245.git.chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ab0d9f4+a39ab1+vger.kernel.org+chencheng@fnnas.com>
Date: Mon, 21 Sep 2026 15:16:53 +0800
X-Original-From: chencheng@fnnas.com
Received: from fedora ([183.34.169.232]) by smtp.feishu.cn with ESMTPS; Mon, 21 Sep 2026 15:17:07 +0800
Content-Transfer-Encoding: 7bit

From: Chen Cheng <chencheng@fnnas.com>

Check disk count before dividing by data disks while assembling a
reshape, otherwise too few disks can cause division by zero.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260911042717.487AC1F00898@smtp.kernel.org/
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
v1 -> v2:
- Added Link
---
 drivers/md/raid5.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f0390918adb3..5db096de8101 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8053,10 +8053,11 @@ static int raid5_run(struct mddev *mddev)
 		 * the array in read-only mode, so we check for that.
 		 */
 		sector_t here_new, here_old;
 		int old_disks;
 		int max_degraded = (mddev->level == 6 ? 2 : 1);
+		int min_disks = min_raid_disks(mddev->level);
 		int chunk_sectors;
 		int new_data_disks;
 
 		if (journal_dev) {
 			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
@@ -8068,10 +8069,16 @@ static int raid5_run(struct mddev *mddev)
 			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
 				mdname(mddev));
 			return -EINVAL;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
+		if (mddev->raid_disks < min_disks || old_disks < min_disks) {
+			pr_warn("md/raid:%s: invalid reshape disks (%d -> %d, min %d)\n",
+				mdname(mddev), old_disks, mddev->raid_disks,
+				min_disks);
+			return -EINVAL;
+		}
 		/* reshape_position must be on a new-stripe boundary, and one
 		 * further up in new geometry must map after here in old
 		 * geometry.
 		 * If the chunk sizes are different, then as we perform reshape
 		 * in units of the largest of the two, reshape_position needs
-- 
2.55.0
