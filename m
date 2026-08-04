Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAA5439F75;
	Tue,  4 Aug 2026 09:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785834077; cv=none; b=fmGrvsGF235zGJi03aICQTUT918lmfpNppdT8UxnXrrSHdX4DDq0ILLoa/ZNy61WRATVLA1+xBXLHpwRVp67Gs32rqe5pRoyJx7nWrjsIj6n77zWXYoquRPjSfWZotaZvIKt3RVOe4pwTUv0w4Ezj0fMPtBUjiVl2hj59lIGLk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785834077; c=relaxed/simple;
	bh=lG37Ok1BvRjKCvFv8QPXZv1RoiVVJ5047JNXKq5KR5A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QSscaOpq85oO7nG1e46/UC7AAT7upmroqH3olZouaWRG1E0XPr5P6uAsa+iBfdF5i6FoXLx0eSeDAAOOPL2MwpE5FBMouJBntpUf6Bi7jhXdXOPcQl6+bXlw3w8cagzpdsg+yWTgFmnLxKKM81HpSdNcb+iEZGraKCfirWBCcyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Pt8s5CgG; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Pt8s5CgG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785834071; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=hA+RaalsMF6QC3oBb9QvAFuy8Ng02GF4CBQGrK7YGUA=;
	b=Pt8s5CgGhmbU9XvFyY6RCRG88lFwnaruIilTgmBysxswC3IIgaRDO2rRuP+1si10DkcxYIZgDTTQkyBZ6ycefRgOCq12yg7RO+qsi5Bv9OY7InJtQrF+SzJzC5fG9GJCimQzz1YOl8L1YnzpSDn2uV3WGDpshfdXdR+KpkJNek8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X8NSL.V_1785834070;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X8NSL.V_1785834070 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 17:01:10 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: yukuai@fygo.io
Cc: joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	magiclinan@didiglobal.com,
	sashiko-bot@kernel.org,
	song@kernel.org,
	xiao@kernel.org,
	yunye.zhao@linux.alibaba.com
Subject: Re: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during recovery
Date: Tue,  4 Aug 2026 17:01:10 +0800
Message-Id: <20260804090110.111062-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <67ed4a7f-f250-42e4-8833-662d35a68e75@fygo.io>
References: <67ed4a7f-f250-42e4-8833-662d35a68e75@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kuai,

> By re-add a disk, this is really a resync, and bitmap can be used in
> this case to skip clean bits. In this case, I still think the correct
> solution, for old bitmap, is to let bitmap_start_sync() return much
> bigger skipped blocks.

Thanks for the correction.  Just to describe how md currently drives it:
with no resync pending, md_choose_sync_action() takes the re-added member
as a spare from remove_and_add_spares(), then clears MD_RECOVERY_SYNC and
sets MD_RECOVERY_RECOVER (md.c:10151-10163).  md_sync_position() then
starts the sweep at rdev->recovery_offset (md.c:9557) and
md_sync_max_sectors() bounds it by mddev->dev_sectors (md.c:9489).  So a
re-add runs raid10_sync_request()'s recovery branch, in device address
space, rather than the resync branch.

md_run() defaults the bitmap/resync space to the device space, and raid10
is the only personality that overrides it:

	md_run()  resync_max_sectors = mddev->dev_sectors	md.c:6753
	raid5     resync_max_sectors = mddev->dev_sectors	raid5.c:8090
	raid10    resync_max_sectors = raid10_size(mddev, 0, 0)	raid10.c:4149

So in the recovery branch sync_blocks is in array sectors while the return
value advances a device cursor - for a near layout the two differ by
raid_disks / near_copies (raid10_find_virt(), raid10.c:699).

If I read you right, you would prefer this fixed on the bitmap side rather
than in raid10.c.  For the recovery branch to use the reported span
directly, that span has to be in the device address space, so md-bitmap.c
would need the raid10 geometry.  I will look into how that can be
implemented.

Thanks,
Yunye
