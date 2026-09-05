Received: from sg-3-27.ptr.tlmpb.com (sg-3-27.ptr.tlmpb.com [101.45.255.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4008F45DF65
	for <linux-raid@vger.kernel.org>; Sat,  5 Sep 2026 10:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788605078; cv=none; b=cYrkCAs6vs3YDNwE7fF7piAe/ddB7ZvCf9AYl8138B4ElSZO/iGsiK0loG8/ALs04UG63pwC/buh1kdR/D0kQd0hbXSloYZaU1VIfjs9vsOAxs7PoGD2/8sOMF6DUM3BqVWjQX35N+c6kLSLoqy1CBfzmM4QFairR9BLPdvIT7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788605078; c=relaxed/simple;
	bh=3LS5IxpNW7mSbPP6+nzU8XNGykeoU8q4AXHjLqimIek=;
	h=From:Subject:Mime-Version:Date:To:Message-Id:Cc:Content-Type; b=kqASLKswYziZ3V4ldW5DmLuNTIyFO3C68FJk5sQl4768tK1MgjOpDaVm0/e1w3gXCXhNT7Jd3RPa5xJVoxPo9yXp967gCDuM3H6XpecmI8TIyE4ySLbZbzXMsy3KoEYH7jo9luS17jjwlyWpX+6SUu9m4BnXJYy/utc4nwenKVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=0qpl9SlY; arc=none smtp.client-ip=101.45.255.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="0qpl9SlY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1788605016;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dO/UcKNO87WKC8ZlQdKd4LNnXFAjCa2VErtE3XJa2+E=;
 b=0qpl9SlY2a//WBR3LIlHUO5WiVfh1SWRw+JDBG/EsjHl1Gl41BgInt93mpsc2vHFk6Z/+e
 oqB2ZNn7HwT4C0FGnvTCrVSQR0hcgMYV0vekl+16hDBQHJWbY8ly4Uga20p+sGvHkDBZVZ
 Wr26qhgDWwhpY8hLLdJqd4anY7xxfUeMF+HwhCe3WQKzn1z1oJrD9qEzdavHjXPXVjcEX8
 T6RDTHqHLne5uEMyByyyylnwBU3rtLXubm1Tw/DfcTWeFVAdWekOGAw4bjbK6vog8DN+UV
 K8QArCd8EiMe6TxzGnFV2qnLCeE61N5FkWbr30bcsJL6X+gyVoLTg332D2h9fg==
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH v2] md/raid5: reject raid4/5 arrays with too few disks
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a9bf256+4d7a0e+vger.kernel.org+chencheng@fnnas.com>
Date: Sat,  5 Sep 2026 18:43:23 +0800
X-Original-From: chencheng@fnnas.com
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <xiaoni@fygo.io>
Message-Id: <20260905104323.2202902-1-chencheng@fnnas.com>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>, 
	<syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com>
X-Mailer: git-send-email 2.55.0
Received: from fedora ([183.34.161.2]) by smtp.feishu.cn with ESMTPS; Sat, 05 Sep 2026 18:43:34 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

raid4 requires at least two disks and raid5 requires at least three disks,
but setup_conf() only rejects raid6 arrays with fewer than four disks. As a
result, an invalid raid4 or raid5 array can be assembled with no data disks
and later reach raid5_set_limits().

Reject such arrays before the r5conf is created. This prevents the invalid
geometry from reaching queue limit setup, where roundup_pow_of_two() can be
called with a zero stripe size.

Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a778c82.01d0871a.3a0d52.006a.GAE@google.com/
Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
v1->v2:
- Fix wrong tags
- Check raid-4 also
---
 drivers/md/raid5.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..4d8bb0cf2605 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7655,13 +7655,16 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	     && !algorithm_valid_raid6(mddev->new_layout))) {
 		pr_warn("md/raid:%s: layout %d not supported\n",
 			mdname(mddev), mddev->new_layout);
 		return ERR_PTR(-EIO);
 	}
-	if (mddev->new_level == 6 && mddev->raid_disks < 4) {
-		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
-			mdname(mddev), mddev->raid_disks);
+	if ((mddev->new_level == 4 && mddev->raid_disks < 2) ||
+	    (mddev->new_level == 5 && mddev->raid_disks < 3) ||
+	    (mddev->new_level == 6 && mddev->raid_disks < 4)) {
+		pr_warn("md/raid:%s: not enough configured devices (%d, minimum %d)\n",
+			mdname(mddev), mddev->raid_disks,
+			mddev->new_level - 2);
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (!mddev->new_chunk_sectors ||
 	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
-- 
2.55.0
