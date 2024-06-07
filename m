Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DA1BC3F
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 04:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717736024; cv=none; b=ODIsDV2Q0VmMrsvVkVq4foI+pqnlfrgxaIx0eZGDecrzeyjYaNzTTqRsXkpTZam80GrsLoh/S/j6nF2Jy6bU73aB6xKp4BSQSFK6mQsLkHY+uAlRz5b8WXAXdeCVa2NkfpIMHRC/nSVOPL7yznAr/0nQMm32Eg/dInzgjofIu2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717736024; c=relaxed/simple;
	bh=YntjfceF5b90+Ufgi4MH1cH75obZF5qCL7EklouCNz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ka1FhLtB+9XcjfLRw20qh3SuJyvnRYU6rTZDeRDcZc7KljSDVq/eN5QFRWFUWkwWAv6NDH0X8y+CPdLuFu+ZJUHVn+KiCkp5E0hhtxXUFWUa+yCJWSQfhLRwCVZNrut3zE9WA/wVkOjqs4z1OqZIadwpVAtRPyuvM16DoRycmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6065368B05; Fri,  7 Jun 2024 06:53:36 +0200 (CEST)
Date: Fri, 7 Jun 2024 06:53:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: song@kernel.org, yukuai3@huawei.com, hch@lst.de,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/md-bitmap: fix writing non bitmap pages
Message-ID: <20240607045336.GA2857@lst.de>
References: <20240606153223.2460253-1-ofir.gal@volumez.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606153223.2460253-1-ofir.gal@volumez.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 06, 2024 at 06:32:20PM +0300, Ofir Gal wrote:
> +	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) << PAGE_SHIFT;

Please split the line after the "<<".

>  	loff_t sboff, offset = mddev->bitmap_info.offset;
>  	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
>  	unsigned int size = PAGE_SIZE;
> @@ -273,7 +274,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>  		/* DATA METADATA BITMAP - no problems */
>  	}
>  
> -	md_super_write(mddev, rdev, sboff + ps, (int) size, page);
> +	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);

and drop the pointless case here.

With that:


Reviewed-by: Christoph Hellwig <hch@lst.de>
