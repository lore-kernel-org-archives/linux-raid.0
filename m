Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AE9442C;
	Tue, 27 May 2025 08:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748334436; cv=none; b=lXjgt6oc47LdEkob+PQGgoyFj+qaNZkepHls1gorS8k3L5SPDy7FXGFJHXrHby4BBH1OntwpzymqTkrtKd70iovkXs1fGOQMO6KReGUS18RcKbEZFVM1SIkavumu3aznx6RNoqPT0mFUBau4LgqrUMf8H7vyChXrDJ/Dyiuxq2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748334436; c=relaxed/simple;
	bh=hJ/yvw4xKCM5g2rBvzuVOE4sVh19EftCd2yLyIE2AK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IHQU95mFTcptYINIeIEup07wFNbqgRmVmmp4U3T3JukdtEeetgL+Z30QkAnIn6SfKbHr3dLtOmG5YEC9mWUkH28sZb554qJrgkGH5jjW0fB0PsBfKTWpGsXftjmb2DfOi5UFyGf53Asmg2BE8gr2SkgFM/HWTvm8ybEB+TOVeEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1BDE967373; Tue, 27 May 2025 10:27:10 +0200 (CEST)
Date: Tue, 27 May 2025 10:27:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 15/23] md/md-llbitmap: implement llbitmap IO
Message-ID: <20250527082709.GA32108@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-16-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-16-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI, I still find splitting the additioon of the new md-llbitmap.c into
multiple patches not helpful for reviewing it.  I'm mostly reviewing
the applied code and hope I didn't forget to place anything into the
right mail.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> new file mode 100644
> index 000000000000..1a01b6777527
> --- /dev/null
> +++ b/drivers/md/md-llbitmap.c
> @@ -0,0 +1,571 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#ifdef CONFIG_MD_LLBITMAP

Please don't ifdef the entire code in a sourc file, instead just compile
it conditionally:


md-mod-y        += md.o md-bitmap.o 
md-mod-$(CONFIG_MD_LLBITMAP) += md-llbitmap.o

> +	BitNeedSync,
> +	/* data is synchronizing */
> +	BitSyncing,
> +	nr_llbitmap_state,

Any reason nr_llbitmap_state, doesn't follow the naming scheme of the other
bits,?

> +	BitmapActionStale,
> +	nr_llbitmap_action,

Same here?

> +			if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))

Overly long line.
