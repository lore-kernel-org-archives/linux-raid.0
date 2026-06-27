Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F911B6D08
	for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 10:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782556173; cv=none; b=l8RaxXP5Y+n2eAx3E0BgIem5lOA+04i3/OJX0ILhbJGzXtAnlY+MFPwJUc/yWuGroAWqWIuVJGFKIDK0hnIvqBxyIaSKZrPT5+2zUwPP5lWhZgrlShFJIs+hcJh/BIfy3D5ustBkd9FsU4GqQwyGipTB1dE2S9ar0mA/x1VbIyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782556173; c=relaxed/simple;
	bh=cqAXNhJzzTY5lCPFMsu2uFDAzDsN75CxZtG8mcyrl8o=;
	h=To:Date:Message-Id:From:Subject:Content-Type:Cc:Mime-Version; b=NDx9o6LnvbWzVu1JsDlcPyutBJuWsp9n73BkC7zsdeTWWdvsc5OhBSGaqhwTNvtMS/TiQguZbuVIc3+d3oozbwc8u51nfjkVcZuY1qej+RcKd64Nhv52U6UHw3w0jVffJgIQqD0h7tCxo6si7AOmgcW2P7dcs+4XJC4A6YarREA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=lQjrmQgG; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="lQjrmQgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782556161;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jLJtdTu3VOn3FZ4EHtXi4IJwGfI7XBVpABlH3O29Le8=;
 b=lQjrmQgGlEMKW0HEsHS8Vo4ydKOYIjvanUehGix1n2Du6ibqi6jDGyfpAy59Lx/wqYnbKN
 FwQ4RTVLJKZITnaYdDJMNm6lijDmp6sytUoUXgVSZSWBT9AJ6Akqq72n2xREBj+/tV4x8L
 MkXvfBIVqwJKgd0CIywajImFx3dD59wu96cdiHvq5uJmLQ+OCwYGchTuC1PId5AlQ5rtR+
 VkTw1Zs+YhcuKThq3EkuP1eEbFoW9sJErvRfaDaf3Epyxiz8/l3fKizFAhUon+4bnL9NDf
 +XpFZ42M5F+1Q06xSj1KoyFaGrNMhJvTntFD1q5hGANqBqzJ3+X+1UtNeY+OHA==
X-Original-From: chencheng@fnnas.com
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Date: Sat, 27 Jun 2026 18:29:09 +0800
Message-Id: <20260627102909.141036-1-chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md: protect read mddev->recovery in md_sync_action()
X-Lms-Return-Path: <lba+26a3fa5ff+a49481+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0
Received: from fedora ([27.47.238.101]) by smtp.feishu.cn with ESMTPS; Sat, 27 Jun 2026 18:29:18 +0800
Content-Transfer-Encoding: 7bit

From: Chen Cheng <chencheng@fnnas.com>

md_sync_action() read mddev->recovery in lockless path, use READ_ONCE()
instead of u64 plain read.

Fixes: e792a4c2156a3 ("md: add new helpers for sync_action")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c5c50640b684..f4415c1a79d9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5074,11 +5074,11 @@ static enum sync_action md_get_active_sync_action(struct mddev *mddev)
 	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
 }
 
 enum sync_action md_sync_action(struct mddev *mddev)
 {
-	unsigned long recovery = mddev->recovery;
+	unsigned long recovery = READ_ONCE(mddev->recovery);
 	enum sync_action active_action;
 
 	/*
 	 * frozen has the highest priority, means running sync_thread will be
 	 * stopped immediately, and no new sync_thread can start.
-- 
2.54.0
