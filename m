Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D11139E;
	Mon, 26 May 2025 06:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748241621; cv=none; b=GnTMQTZ0VKX9Z2s0yw9ewpyPkt880PgzehNo2oNgKbcpIH4Uv9nGtvdmW3+fmA1PXrkV6buoknKDYYkDNsgepOkTXgONHfDPK5seBNKHWwpfiuFvI0G9FOYDOOFxmgwR2jqolkkn7OiQETp/BIOi2H3r2NuQ+eRsNF3NjAlWH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748241621; c=relaxed/simple;
	bh=BEH8ywRf93wwIy/O+SSOVmh0GTy3nBSZcbgXS+ihSx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1mIOTRsbj1RYCSEo+MMnblsn2s50BCn2o13Nl13zS1yZJH7Z0guNAF/USm9SMW1NGM4MtpaPzK7IvVp5h1sLcdhBq9gO3MD3CEW8gh5zSn8Dx/xKMJ7OQph71qXbAtASYGbcxdfSNt3aPyyo1AO9WaiucmQmDPApXR7F4ydjes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D99E68D0D; Mon, 26 May 2025 08:40:13 +0200 (CEST)
Date: Mon, 26 May 2025 08:40:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 12/23] md/md-bitmap: add macros for lockless bitmap
Message-ID: <20250526064013.GE12811@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-13-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-13-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 24, 2025 at 02:13:09PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Also move other values to md-bitmap.h and update comments.

Hmm.  The commit message looks very confusing to me.

I think this should be two patches:

 1) move defines relevant to the disk format from md-bitmap.c to md-bitmap.h
 2) add new bits for llbitmap (and explain what they are).

> +#define BITMAP_SB_SIZE 1024

And while we're at it: this is still duplicated in llbitmap.c later.
But shouldn't it simply be replaced with a sizeof on struct bitmap_super_s?

(and when cleaning thing up, rename that to bitmap_super without
the _s and use it instead of the typedef at least for all new code)?
