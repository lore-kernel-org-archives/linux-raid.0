Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE81137B41E;
	Fri,  7 Aug 2026 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093528; cv=none; b=Z114b95t8f9/9ixXWqZEGpasYE6gLKitdbLDVJoCvIMAl8nMQHU9IaKiS6UOQxL1nYk/QthYgEAuuS5gqttLTwfbfYWeHbh/fAtBe2fc3uV/XsxiAOdwhXJvQ5DFtLH6RUcLBfbCOeRn3PG3LJfWyoRyJCfgT+DUy8S5xcdvNOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093528; c=relaxed/simple;
	bh=SysRwysjioaUBGh2tbo/9oB7KnroLL+PXYIJWCtRgLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=biwzbcq1Fxy9+BQK4yqJrLWMpYaPEKwo0ZSUrFjXOEEoXqn7SCdhTWNrmjUHOd+pgAldIvrvnTOK5a9PQ7f0e3v3PmDXDkynuJbgyoR1ixKYRKGmRt5C1XQm0khpZ8W/8wKBRMCNxY9gYKER4LeGXWh+MIS0BM+cIrffjtIpm08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=I+ljOwe8; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="I+ljOwe8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786093520; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=rTtUvz8lNmfZbd4EKCYqEPHh9f6vtBo2v1yGvHhJwWs=;
	b=I+ljOwe8E1LCkszrGfwB95O46hWGra2hWqV/C1rylMuBYAfS47nsH8dOt8ouU8S544lvaSe0hCreadNXbw7zRmARW9AqWBmjj0JggFl2SahAxn1pqSDSP2tCWHjleLU/7zlPYUr8D9rRW+nu/uophAwLPdn0zL6jbS59uBtmJ7s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X8WIKlz_1786093519;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X8WIKlz_1786093519 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 07 Aug 2026 17:05:20 +0800
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
Date: Fri,  7 Aug 2026 17:05:19 +0800
Message-Id: <20260807090519.122115-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <e22f9816-fb97-49aa-a4d2-b098ccafb654@fygo.io>
References: <e22f9816-fb97-49aa-a4d2-b098ccafb654@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kuai,

On 2026/8/7, Yu Kuai wrote:
>> If I read you right, you would prefer this fixed on the bitmap side
>> rather than in raid10.c.
>
> I still don't get why

Sorry, I misread your earlier reply.  I had read it as "the whole thing
belongs in md-bitmap.c", i.e. that bitmap_start_sync() should hand back a
device-space span, which is why I said md-bitmap.c would need the raid10
geometry.  That is not what you were saying.

I think the split is this: the first half belongs in md, in array address
space - bitmap_start_sync() should report a much larger clean span,
ideally up to the full array size - and the second half, the array ->
member conversion and the minimum over the members, is what 3/3 already
does.

> Check the code, currently raid10 do not map the max_sync, which is RESYNC_PAGES, back
> to rdev sector, and use it directly. I wonder is this safe for raid10 with chunksize less
> than RESYNC_PAGES?

Good point, v2 does not address that.  Let me think it through properly
and handle it in the next version.

Thanks,
Yunye
