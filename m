Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFCF4D98EF;
	Thu, 23 Jul 2026 13:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784814974; cv=none; b=Ejj05HLAGGdbA0bKYtldb4CRnfBF8F3Ga+U4oO7RWGQQp/tNj0vnrgU2pANI6G5hbcCozX8ZzloaGdIGcitEH/BGJL/QKS6gC1ZJA7o+1X6aT1DsY8DF01zb4hm9d7dtQf6IJyYHhcRXmIqEPuCaKFV5jKxrIli5t3C09ez6BC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784814974; c=relaxed/simple;
	bh=urCA+GgVdz1b+HfsPe6dOn2NDcT/bTNRXhBkmyYNk/8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nb3l91pICJC2HUGZJfTeUNuWuN7ICLu10irYcaX/KdOpEEzUlrWHW9MWh7ngFEDFHyRaz5FmQuzpKnYhf9hQLalI65VBFoZfk8bG7ccBPJs070XvZHVWt+Xv0DCN9HfmMUHf2ivCnEATfdc3uSmUiyVPRKWalfxqF7uyW1O3tNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=b55fYvXJ; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="b55fYvXJ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784814946; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=oZ+Cf5N5adrT2q/yc6Pli6T3HIhz3F5tsUmqStQxS9o=;
	b=b55fYvXJR6Dk8K1PwUcsxpnZTG8MyA8rBJL+q0rFzDlnYT2sccehmHDbzsYaLStQKTCwfBHoWTRztK8fFliYsH88ChMp3XHl7DQ/frQgPkVZ6HVi3bcy/nZXEKayW0IEI/jQeZrBpg4gb20GuqTEh7TGbN5At34ZlzYDuYzdvAw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7gKXcP_1784814945;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X7gKXcP_1784814945 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 21:55:46 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>
Subject: [PATCH v2 2/3] md: add cond_resched() to md_do_sync()'s skip path
Date: Thu, 23 Jul 2026 21:55:34 +0800
Message-Id: <20260723135535.101995-3-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
 <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When sync_request() reports a skipped region (*skipped == 1),
md_do_sync()'s main loop advances the cursor and takes an early
continue:

	j += sectors;
	...
	if (last_check + window > io_sectors || j == max_sectors)
		continue;

If the personality returns a small span per call (raid10 recovery
returns only 128 sectors), syncing a large, mostly clean array iterates
this branch an enormous number of times without ever yielding the CPU.
On a non-preemptive kernel the resync thread then trips the soft-lockup
watchdog:

  watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
   md_bitmap_start_sync+0x6f/0xe0
   raid10_sync_request+0x2c9/0x1530 [raid10]
   md_do_sync+0x810/0x1030
   md_thread+0xa7/0x150

Add a cond_resched().  This does not reduce the wasted iterations; the
excessive iteration count is a raid10 problem addressed separately.

Cc: stable@vger.kernel.org
Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..c2e8b203c4db 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9881,8 +9881,10 @@ void md_do_sync(struct md_thread *thread)
 			 */
 			md_new_event();
 
-		if (last_check + window > io_sectors || j == max_sectors)
+		if (last_check + window > io_sectors || j == max_sectors) {
+			cond_resched();
 			continue;
+		}
 
 		last_check = io_sectors;
 	repeat:
-- 
2.19.1.6.gb485710b

