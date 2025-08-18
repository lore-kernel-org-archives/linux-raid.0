Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42131DC075;
	Mon, 18 Aug 2025 06:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497917; cv=none; b=F5vvbKoPrCuxkpQl+ii2TyAGSFzfjoDQiYXnZVjYHvLAHZ73KE7UnjaXVzUmJuYhOTrFHKv0X2wGJCuqI4mz54wY8oV1kfzlYmO4h0A1R2/gl2XWTHlZO85v0bu//HaygW2susHoED/ymfPJcvIMGs99AtzD5ETpcNu875m2LRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497917; c=relaxed/simple;
	bh=gvgGwRBTrUDJK7ICfwrCyAPLE4fapCBnf1KZyNBQ6qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tChuywb2Lz60reSg4D/FKsR7ePJFjbdtu2ya/6TxvQe0dDyPmUsjmmIf8hadlcpqbByChI5StpGVXII7eOyDZ52mLJBV9f9KxmBx9Npj8sTgNf90KYZ6CJUsWs3CFpOrcdjVM40PTsrfIxZWqKyZdwjV6OXb8RckitDRTXWhrpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G3yljLYy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G3yljLYy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v5X2+QvXc8JJyNSaaL1xliidRSYMQ5/OwHCSVyNzHxc=; b=G3yljLYy83oMDK4o1Oxjoz9H+U
	sDcRvvub+B2xGF+abpgOS9ggX3p2XieMTqiSGPf8Bn4o3mzbikrFUscObuPH2XkdPb9zngc1GmHuq
	8YihdLdfLRnPrQNGjPNOs16ep4ubbi/a6L2B4m8D9fOyULzlKYBQlxIvznS4j0COC3EcGKRjrdNqh
	NdWzNP+YYRV3x/4qwYsGVH371D2KGK/NyKX73G4/6MxrQhuuziiPcqZIox10MwEFrEsESkh9gs6XB
	gpCdY02BMkLpGlLshDJ8yBZlYV4Lhoo/W9lqAD73mFltYIGXdhoabDJRqFpWDHM2amnpWxTUqF1NT
	VfUdPsgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1untCT-00000006cZx-3zOq;
	Mon, 18 Aug 2025 06:18:33 +0000
Date: Sun, 17 Aug 2025 23:18:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
Message-ID: <aKLFuQX8ndDxLTVs@infradead.org>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
 <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 18, 2025 at 02:14:06PM +0800, Yu Kuai wrote:
> Please take a look at the first patch, nothing special, the new flag
> will be passed to the top device.

But passing it on will be incorrect in many cases, e.g. for any
write caching solution.  And that is a much more common use case
than stacking different raid level using block layer stacking.

