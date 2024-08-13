Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2E661FDA;
	Tue, 13 Aug 2024 07:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723533692; cv=none; b=t2cH8/MUsg3cE2Pie4EGrmCLU6+as9ta1DEyn7r1CjTe27VfV+SsU0IBw+bmbnd3y2/6/d5dM1Jao1l5ifbAJuB+Jmbr7mKfizMQcIP/3c5EvSoIIOImTsIqsXQDhO8TGu2xinAuWu1brD6IW0GRMShq4MoO50JSv17T5gQxL6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723533692; c=relaxed/simple;
	bh=cWBNJPe8NO2mYCdEyRfOZ58MOL3BKWORB1hAY3Znjto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efBIyBxR9Pa+hBKAiQJmNsAfhekWh38szcxBuwOQiI2DU2FETuYJy1tnJSNlP8Pl2v9Za+90A98izHMHYj/M4qVuez+hv9o4eF5EEwm1R9dXtegCNJFYzWiLOTRhm/Yxdw/qvtrtFqXljzGzVuH12onMkL77AlygUcK8Q+FVuxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x+G1aCv0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x+G1aCv0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O41PghY9V6lKoOv9CZfMpzgNhd6Z29o3tiejHWQkJio=; b=x+G1aCv0MXeWBqV1MARqgN8Yzt
	hY24pD/Llm5/14s88MSSL4SKxZXB5eTFWhuk3tM8C03cGbtU7bN8tSy5v8ilF6uLoeR2C4EpNSJmg
	r4p6dvEle/6uoHhph8vF0OwO7TRtQDugDl1D2hleRzTfodaE6uf14ryxO9sbC5sbj9fGw6Ahlh6O/
	lsoqXfRJMCddh4LaWx0gCKfNXooNR9iktip9DVSl0ZC3YJ6G9iMAsbF8p3ZvivWC7n5BpDNlzmSDM
	hs4nXxr+OlzrpHQyCfOFbLn1CEl3HM/30lgGrAmfJyWZQeR0e+wNhHlkBxXGRwGv9BXftjvyy1yKB
	Dr3sO8XQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdlqT-00000002h54-2Q3M;
	Tue, 13 Aug 2024 07:21:29 +0000
Date: Tue, 13 Aug 2024 00:21:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH RFC -next 00/26] md/md-bitmap: introduce bitmap_operations
Message-ID: <ZrsJeabpeFdXVfIb@infradead.org>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Aug 10, 2024 at 10:08:28AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The background is that currently bitmap is using a global spin_lock,
> cauing lock contention and huge IO performance degration for all raid
> levels.
> 
> However, it's impossible to implement a new lock free bitmap with
> current situation that md-bitmap exposes the internal implementation
> with lots of exported apis. Hence bitmap_operations is invented, to
> describe bitmap core implementation, and a new bitmap can be introduced
> with a new bitmap_operations, we only need to switch to the new one
> during initialization.
> 
> And with this we can build bitmap as kernel module, but that's not
> our concern for now.
> 
> Noted I just compile this patchset, not tested yet.

Refactoring the bitmap code to be modular seems like a good idea.

But I'd just turn this into plain function calls and maybe a hidden
data structure if you feel really fancy.  No need to introduce expensive
indirect calls and a separate module.

