Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF6826D4ED;
	Mon, 18 Aug 2025 05:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755496585; cv=none; b=omlLv2JhpA2u9vsEYifQGm6J9jtTo0d8mNSuLymNbqTLFWYnRRL9UrUjlzR3G2D5iKURjB06r2eCU9rGnmJu2INnyTDIDJH7gtugqXq1VQgk1kdWwKBv5S1wHnMyCQDIEK4Vn/JG0Xjc3H+bvfgzIxi0gduwj6AQTgkfPv9Ypno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755496585; c=relaxed/simple;
	bh=6cRTXzP9RwKPymUOot6yJQZt62HHlzVkWNdLFxEIATE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqf7an9YAs1t7/avJ70GoaCtbtnIYt5DZ+rfksI2DWtQNw45qnNasWGrPshZFG6xGcEG7MbDlVsGPEC2qCdlAZ2oU0DNeA2pPx1AR5CmMEaSZ1KjJJQ/u0TYu6DNWLD3LEXVY21Mv2Yrdg5eVDglUzMT6fxQJHq0W6qK58fIgLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R+HpDEx0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R+HpDEx0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RdIg0BRHZFI5rr+PLH1B+wfSBQrGoDle83wHQDch4e8=; b=R+HpDEx0uzH8bTKfNlB6gjlaFl
	ubaht1ooE01LGrFt6t8lnVZXj5cfca2NTb2z39CgxpoNlCbO1eU+ik3YbZwPFGpReHu54zYq+dr5z
	j8gygb1TicZV3N7ns4FlaMOAaPYmZzNGIqkGjpzb6Bv9fE9X+g9QB67BeccHmr/+bJ9r3ic5idKQT
	kbzGJ3UTEZ5rRYtoRGtCyWc43MHDssh/56Q8BK2YJyiPsR/Wyw+EORp2lXwt5CYO55qiRj8YiR6Si
	00GqkOdxEh2fjntA26VOov9ojUAZG7XX3QnvuP8ovgBZN+OE9QkJMngAbBSJ81BC+xOsWtabk5yKb
	6EKVkaSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unsqy-00000006ab6-2nhA;
	Mon, 18 Aug 2025 05:56:20 +0000
Date: Sun, 17 Aug 2025 22:56:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
Message-ID: <aKLAhOxV1KViVw7w@infradead.org>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 18, 2025 at 11:40:54AM +0800, Yu Kuai wrote:
> Then code will be much complex insdie md code, and we'll have to
> reimplement the stack limits logical with the consideration if each rdev
> is already a stacked rdev. I really do not like this ...

You don't.  You get the stacked value as input and then simply decide
if you want to take it or override it.  The easiest way to do the
latter is to just stash it away in a local variable before calling
queue_limits_stack_bdev and then reapplying it afterwards.

> And in theroy, we can't handle this case just in md code:
> 
> scsi disk -> mdarray -> device mapper/loop/nbd ... -> mdarray

I don't see how the code in this series could handle that either.

