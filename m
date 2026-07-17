Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C638C399000;
	Fri, 17 Jul 2026 06:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784270628; cv=none; b=ab7y88vKEvY8WikpcnW31B53bkDWfywmw4+2nOj9/5SHrcOZ2Zoe5otsWkpNW9svAJPpR4LeNEoG9RnluXva+hDI35h/pEBUribD+C8DECguArMFbbg8qBnK+Zxg9Qcr2Qo5dK3d6E0pGkigDH7dXrj/2hjOfB21FVyDWNUl8w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784270628; c=relaxed/simple;
	bh=mEKUkAdFma2B6Wn3DxHFG3oRqr3rHyK/u4tvUcgQcNE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P5Joqz/nweLuphycpz/hSMgFCvcyral1s65swV9ChZz7UUOPHeUjeXVsUmVkKh3OJcRTuA0SYqELXxhm1E6HY9cC8p/vxajrY4Ots+T0l9RWbue0H6D5O78i7m1SIh9I3WZQK1NnQRzIeWLLJZiS+z1Hrs1Y3/beWneXpK6Ym8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yiTvNDdq; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yiTvNDdq"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784270604; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=+mv+ESJR7OjY8D7lW5H7qflglJe9sk/ZUAVxDWgOnFA=;
	b=yiTvNDdqBFW3nndDVFAVRuvh6Ryh/FBNrFnkpR57TAmXx87fcCxmwjIumavpbWXIxVLBYp3BH6xe35WXN9wnfpqxCZp/GGe8sh1EQVslOIXXiH70oEKFR6B7jf6se0Qm9NAqMDCP1I4GK9rr+/J7+vNW+MpDSbf4ygTyesES13g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7GPrL-_1784270603;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X7GPrL-_1784270603 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Jul 2026 14:43:23 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>
Subject: [PATCH] md: fix soft lockup during resync when sync is repeatedly skipped
Date: Fri, 17 Jul 2026 14:27:43 +0800
Message-Id: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md_do_sync()'s main loop advances io_sectors only when I/O is actually
issued (skipped == 0).  When sync_request() keeps returning skipped == 1,
io_sectors never increases, the "last_check + window > io_sectors" test
stays true, and every iteration takes the continue branch:

	sectors = mddev->pers->sync_request(mddev, j, max_sectors, &skipped);
	...
	if (!skipped)
		io_sectors += sectors;
	j += sectors;
	...
	if (last_check + window > io_sectors || j == max_sectors)
		continue;

During recovery or resync of a large array with a sparse bitmap, many
regions that need no syncing are skipped:

	raid10_sync_request()
	  md_bitmap_start_sync()	-> must_sync = false (no bitmap page)
	  /* every mirror skipped */
	  biolist == NULL -> *skipped = 1; return max_sync;

j then traverses the whole skipped range while io_sectors stays
unchanged.  On a non-preemptive kernel the resync thread (mdX_resync)
hogs the CPU for a long time and eventually triggers a soft lockup:

  watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
   md_bitmap_start_sync+0x6f/0xe0
   raid10_sync_request+0x2c9/0x1530 [raid10]
   md_do_sync+0x810/0x1030
   md_thread+0xa7/0x150

Add cond_resched() to this continue path.

Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
---
 drivers/md/md.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..e7411b033490 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9881,9 +9881,10 @@ void md_do_sync(struct md_thread *thread)
 			 */
 			md_new_event();
 
-		if (last_check + window > io_sectors || j == max_sectors)
+		if (last_check + window > io_sectors || j == max_sectors) {
+			cond_resched();
 			continue;
-
+		}
 		last_check = io_sectors;
 	repeat:
 		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP )) {
-- 
2.19.1.6.gb485710b

