Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D05F1C3C18;
	Mon, 26 May 2025 06:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748240908; cv=none; b=TJCGShMpMQVrgprikc7e78lyWh8ze7MDkkfDkK+JZCaIUUzftaQHPL1DMWHZANgr+JdNsJRAmheY46yc67WWPQbS56ObFGkE/sD0UtpQYJptIKehX3BBgIW5VBXyYnqlSUhMoopgySZa+VCAp5k1DIDtect8msyfPpkcYP2BuZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748240908; c=relaxed/simple;
	bh=hpF2quL5NBOgDWSbAfGBeyqz/PY54wjXC0YRoqtTGdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pU8vVh8n6xm7DdoTEKxpOgELEncMIt0fZczOem0MPqR8lHldfcTY3BFfA+bh6OqnpEiv3MGuiGaObmY2ng7/bGJk5KaVxkmQel1qjB7IiAheGKrwTC7pV7I6b2n0E3V7dHrRs1h/HPUk4nXurzgaDJPAZ5JmcvAE0sq+qD/CCEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EF2B68AFE; Mon, 26 May 2025 08:28:21 +0200 (CEST)
Date: Mon, 26 May 2025 08:28:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 01/23] md: add a new parameter 'offset' to
 md_super_write()
Message-ID: <20250526062820.GA12730@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-2-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-2-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 24, 2025 at 02:12:58PM +0800, Yu Kuai wrote:
> -void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
> -		   sector_t sector, int size, struct page *page)
> +void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> +		       sector_t sector, int size, struct page *page,
> +		       unsigned int offset)

Maybe add a little command explaining what it does?

> +extern void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> +			      sector_t sector, int size, struct page *page,
> +			      unsigned int offset);

No need for the extern.  Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

