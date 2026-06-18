Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11C41E0E14
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 02:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781751476; cv=none; b=F0LaYwv8HcPh5nUhBSF4b7LZ+dVBVgahtnuFPqrb7SDW5QxJdfCaPKHtHVvdiA9YHOEq90HEOCA3tPE6kOJP0j1xgAKeyF1lDwZQ1fspkerHOX8NmDP2PHoEFkZ2CmQBsIgeASTU8X7cC9OUWe3jzWkfdAEq2dpYTKELBJo4Lgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781751476; c=relaxed/simple;
	bh=/+Dp81K70IwWqTnRgMrnfsphVKYjQbV9LhAbltJxesE=;
	h=Mime-Version:Content-Type:Cc:From:Message-Id:To:Subject:Date; b=O+yjwxGHbzBUlHNVsPNipeBkTSjSzD/gDYuYiNA7HLubnK70Hw/GrF2YAyxrRZO2y4pl4Y+Nh6zXGnftUJpR4x6mFguSLhYPs82eufTqju+zJ3yYZLz0k8p2bICBSo0QNiTC/eaSZWD5f0FAsuLcxjRH2aMxflLO9YnkObKq/r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=P/enYr1O; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="P/enYr1O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781751469;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2FFBI3WHEacoqD04s8wfoksWUTh1W7V1TTUgd/m4zOY=;
 b=P/enYr1OOrgwvbhcNFT4Uwlp+dOJb6GP7E7Vfy8QgHPdAO1zohWs6G0LbVoXOmtZy3z3E6
 w9wiCscPhBRWefnAPyK7ThNr0ZNTZmuZmPiL2m+TpVezCUNTfWhuuG1lEO47NPLfOSESbt
 fVytV33fxtsmrN9+eOloJsate6DdoN9Cjku1evDMwnldHwarxO9TjkDxr0bbrFuCRQEa/m
 7mSe2oNmtfDRNFIJ/54LtwVSvGLdfOFiRhdiRf6ldNF1LHIoqM1ArWi3e5mxJHs3CvL+Kd
 pzmulIrVB5P9/u9lI2Z2jdSwSq1qmCxljzQ7jPajaTMH7ZnkG9+QatCHWmMuEg==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>, 
	<linux-kernel@vger.kernel.org>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <20260618025735.915113-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a335eac+128bef+vger.kernel.org+chencheng@fnnas.com>
Received: from localhost.localdomain ([183.34.170.8]) by smtp.feishu.cn with ESMTPS; Thu, 18 Jun 2026 10:57:47 +0800
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <yukuai@fnnas.com>
Subject: [PATCH] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Thu, 18 Jun 2026 10:57:35 +0800
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.54.0

From: Chen Cheng <chencheng@fnnas.com>

Once the 32-bit seq wraps, a newer bm_seq can look smaller
than old, so .. covert to wrap-safe calculate way.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6d01c35b5499..a08230aac711 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -997,11 +997,11 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 			md_wakeup_thread(conf->mddev->thread);
 
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
-		    sh->batch_head->bm_seq > seq)
+		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
 	}
 
-- 
2.54.0
