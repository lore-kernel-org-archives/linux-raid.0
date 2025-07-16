Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157BBEC2;
	Wed, 16 Jul 2025 11:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752665867; cv=none; b=VW5cBU1+mm2gSnctJneLfk3GHZZJ+VkS411JiMNFJPbVb0Om6vDmsJmt5cq2Ry/x5v5PZjXz3adDztW2wg62s2jPpdefHoWswp0sm1uu2cnk3Z39VRnwX126VpwBFC03ETyHFP0IM6M6MZabslYHkyfnF+oW7SePA/AR0+IR3x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752665867; c=relaxed/simple;
	bh=MOPSi9Bb3LFrmeoMpHo3oH6F76676ME7hCVTXozg4OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKd2AYIrBq+JD+75dy8j22HxhSIJdiklhstcnPdsfDiPbJcfxBpy7H7mHp11+T5CgswmPXTAFrB8EiQwrPdZJgmKt1nyoQ6ByiqN5kIch6DBwlQJ9pA0GuEcEaC1P/yKZHT7PJREvs1OFZT86+ZA0NHLbCbyinGn1Ugpacm+uFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 13F0168B05; Wed, 16 Jul 2025 13:37:39 +0200 (CEST)
Date: Wed, 16 Jul 2025 13:37:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: colyli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Xiao Ni <xni@redhat.com>,
	Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <20250716113737.GA31369@lst.de>
References: <20250715180241.29731-1-colyli@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715180241.29731-1-colyli@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 16, 2025 at 02:02:41AM +0800, colyli@kernel.org wrote:
> From: Coly Li <colyli@kernel.org>
> 
> Currently in md_submit_bio() the incoming request bio is split by
> bio_split_to_limits() which makes sure the bio won't exceed
> max_hw_sectors of a specific raid level before senting into its
> .make_request method.
> 
> For raid level 4/5/6 such split method might be problematic and hurt
> large read/write perforamnce. Because limits.max_hw_sectors are not
> always aligned to limits.io_opt size, the split bio won't be full
> stripes covered on all data disks, and will introduce extra read-in I/O.
> Even the bio's bi_sector is aligned to limits.io_opt size and large
> enough, the resulted split bio is not size-friendly to corresponding
> raid456 level.

So why don't you set a sane max_hw_sectors value instead of duplicating
the splitting logic?

