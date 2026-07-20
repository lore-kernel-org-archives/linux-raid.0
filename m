Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C14F235045;
	Mon, 20 Jul 2026 06:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528441; cv=none; b=p4l/m55z4NuIUBq3oyzm1+zyxkpemaILHA0Kqu3rhZtq8NjYeQT+VTZzUGn3rjBx+2gDfeF+6IazpX9DD2vtC14J/B0lPmhek0C+eZYIkqr96LBRjm/W0Uo6UltHBY1nvCHJIM+FEOfBARX70ZHg1rK3IV9yej9RGmfCQQK87Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528441; c=relaxed/simple;
	bh=Baal0uqnNyXL2c4/a+ed4TzaILPB0CYvf9p8AmJr2oA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rJ/tLNEABe7pXdnAoAQ4g68o2pfxJ1qhIOD4IhMziMIUPc2Jp6Wf+jtkWmlT1in8AfvArJ1otthIZ5euw15OKixhVwmWDZz1ftan5HVXpmKYb/G9/3W3qA/g+k4Pa4t7BNAw8GGUtsbRfOEImwk7leVTjvcBpgi0jkSjyLwzofE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GnHnS1Vu; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GnHnS1Vu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784528427; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=bI2r72nbTUuXwx8i+nfeTcgcOhOf1UakBrDJM9zuSYo=;
	b=GnHnS1VuFL8ujel+TXnNZVNh+y+y3BkmrJmU0nIXNipnhwydNdHCov5tDmRQv/XbzpaiX5CGyBouWnfnm5br2Ga3yHNTSbzPbpjVgVeHk04jOCBjX4BUOkShuRGYir0lCJZvHJisunCcQCER3EQN/qHI0N9uTI70qdSe0FT4EBg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X7O9rU5_1784528426;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X7O9rU5_1784528426 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 14:20:27 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>
Cc: Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: fix soft lockup during resync when sync is repeatedly skipped
Date: Mon, 20 Jul 2026 14:20:26 +0800
Message-Id: <20260720062026.19245-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <7abeaff6-1387-4046-bea3-f1b04465addd@fygo.io>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com> <7abeaff6-1387-4046-bea3-f1b04465addd@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kuai,

On 2026/7/17 14:27, Yu Kuai wrote:
>> md_do_sync()'s main loop advances io_sectors only when I/O is actually
>> issued (skipped == 0).  When sync_request() keeps returning skipped == 1,
>> io_sectors never increases, [...]
>
> That's not expected, io_sectors should always increase in the skip case.

Sorry, my description was not accurate. The problem is not that io_sectors
stays 0. md_do_sync()'s loop exit condition is j == max_sectors, and in
raid10_sync_request()'s recovery path sectors is always 128, so for a very
large max_sectors the loop iterates a huge number of times.

raid10_sync_request(), recovery branch:

    max_sync = RESYNC_PAGES << (PAGE_SHIFT-9);      /* 128 */
    must_sync = md_bitmap_start_sync(mddev, sect, &sync_blocks, true);
    if (sync_blocks < max_sync)   /* sync_blocks huge, never true */
        max_sync = sync_blocks;   /* so max_sync stays 128 */
    ...
    if (biolist == NULL) {
        *skipped = 1;
        return max_sync;          /* 128; the large span is discarded */
    }

Back in md_do_sync()'s main loop, j then crawls forward 128 sectors per
call until it reaches max_sectors:

    while (j < max_sectors) {
        sectors = mddev->pers->sync_request(mddev, j, max_sectors, &skipped);
        if (!skipped)             /* skipped == 1 -> io_sectors stays 0 */
            io_sectors += sectors;
        j += sectors;             /* j += 128 only */
        if (last_check + window > io_sectors || j == max_sectors)
            continue;
    }

From the vmcore:

    sync_blocks returned = 0x5ED03680 (~1.59e8 sectors), clamped to 128
    recovery max_sectors = dev_sectors = 2^40
    iterations = 2^40 / 128 = 2^33 (~8.6e9)

> What kernel version you're testing?

6.6.102. I also tested mainline and hit the same problem.

> If this is latest kernel, bitmap_start_sync() need to be fixed. It can't
> return skip while setting skipping sectors to 0.

bitmap_start_sync() is actually fine -- it returns a large clean span
(0x5ED03680 above). The recovery path just discards it: max_sync is only
ever clamped down, so it returns 128 regardless.

> And since this is dead loop, a cond_resched() will not fix anything.

Agreed -- cond_resched() only stops the watchdog; the thread still spins
~8.6e9 no-op iterations and pins a CPU for ~313s.

For v2 I'd fix this at the source: make the recovery path honour the clean
span reported by the bitmap instead of capping the skip at 128. Does that
direction look right to you?

Thanks,
Yunye
