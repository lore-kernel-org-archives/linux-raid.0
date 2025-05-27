Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD0F226533;
	Tue, 27 May 2025 08:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748334168; cv=none; b=oBr4wLZeX2cLPDcOITZ7q5+myTL1DfNZZh+G9TPf8iBWHDFXkPEhsbD5t1zdapWgjdMhcxoZUbCPp5Cngy/GvamB1ddpUz4VRuYFLizXlSU6vtq1fuwXgW/1z0JgmAU57M3ddKp1zlTXZ9b275G8afr23qdiwYFi8qaXAL/wTHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748334168; c=relaxed/simple;
	bh=JypY7yX0SrgoyQM6IbnHdS5brOQ4qWa1WNntDkT6Zsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGHzfxDl1QfBun6L2LbSy21be9Kn9P1Mu92/eV6WL7PuU/E2szgE1hP0RTNlLKMPC8oY3c37DvK9yd0Bci6+k4WHyhzZGThQFhoqugVtljnmp6i6eXKo0NZRL7I3PWz2ZgUvqe8xO6DM+VdU5Xbqa0IxSYXADYOMC86Sj9fE9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2AE8067373; Tue, 27 May 2025 10:22:42 +0200 (CEST)
Date: Tue, 27 May 2025 10:22:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	song@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 12/23] md/md-bitmap: add macros for lockless bitmap
Message-ID: <20250527082241.GB32045@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-13-yukuai1@huaweicloud.com> <20250526064013.GE12811@lst.de> <40af768d-373c-4a56-8af5-82aeabe49515@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40af768d-373c-4a56-8af5-82aeabe49515@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 26, 2025 at 04:12:06PM +0800, Yu Kuai wrote:
>>> +#define BITMAP_SB_SIZE 1024
>>
>> And while we're at it: this is still duplicated in llbitmap.c later.
>> But shouldn't it simply be replaced with a sizeof on struct bitmap_super_s?
>
> Sorry that I forgot to explain why it's still in .c
>
> sizeof(struct bitmap_super_s) is actually 256 bytes, while by default,
> 1k is reserved, perhaps I can name it as BITMAP_DATA_OFFSET ?

Sounds good.

