Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EFF3D2FE1;
	Tue,  3 Feb 2026 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136249; cv=none; b=gXkh1/yl1i70x/EpW2OopkJTe5P6ouYZIJbrL569QwV3PEckJEnTk7BIch7e6HBPVsiD8xyJA+R1m5IFNGVt3LB28hh/ZTCdDd1vuCILC6msdB666caPiOVwLYc20a/GDUcGj7ueJoXmmICzzcUIduqgraEXNcEw2Xp4970qBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136249; c=relaxed/simple;
	bh=ExtYXo5Z/x9M8rWSJStRiQE1SyLEmFSjaTx5Eyi1o54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fs6jQn+GWAlyEXxhQVCoYcHIYEDGJFSHHiVgTZvPsBv2+MM6EYpE4NeElFUDsrQoEt2s2ZDdC+C4f8GiSdQPvtSOLHLm+PZizpm+cNxFFX1GlyPMjTMn3Xpj6JxYwTM25cngKJUkseQ65qDux8HeWJsvl4ElS8kREM8ciGPjkGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bBYMNmSx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bBYMNmSx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=3u+4PUTELnJcS5q6E1NYtbmOtyp1QP47E5lHoXacbEs=; b=bBYMNmSxYMHyXPVvlx6ejCnPyg
	FydOZUsc05mDFpCEDXDVxkIRNYWbEIS1m8CeE5q1vHCDu9OivMOzbNuPcyof0+AkSRYv+/H57nCJ7
	q2kspQgDqYitVYdkUXtCT8ehbcvqrOdLhFJ8yfO12gt72Hx91X0f1z5yCAcDRKTWPJtcl9iaQ7XQy
	4cL7qy/ev8qhQZYAXipIn+aM1Au0hJLkHq0FVzroAtWMoh58tCJq66FuD6LJzGAvz7eNZz+qzl1WL
	fCSHZ5/tdBPkEKpk8NR1a/uTs9KM1fjLmqb96Jl50kQ5IVlwSZ0K9KtySKuJPddegi67v9oTvvE49
	nmu7XGcA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnJIT-00000006xCg-0WBD;
	Tue, 03 Feb 2026 16:30:37 +0000
Date: Tue, 3 Feb 2026 08:30:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
	yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Message-ID: <aYIirWALBGrMxmbw@infradead.org>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
 <aYGkSwDZTLLbjm6p@infradead.org>
 <40f37494-cf9c-4bc3-aa38-75c76b5d988e@plouf.fr.eu.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40f37494-cf9c-4bc3-aa38-75c76b5d988e@plouf.fr.eu.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 03, 2026 at 09:08:18AM +0100, Pascal Hambourg wrote:
> On 03/02/2026 à 08:31, Christoph Hellwig wrote:
> > Just curious, but what kind of devices do you see that have
> > permanent bad blocks at a fixed location that are not fixed by
> > rewriting the sector?
> 
> I have seen this with several hard disk drives of various brands, even
> though SMART attribute #5 (reallocated sector count) had not reached the
> limit.

Weird.  Can you share the models?  I'm especially curious if these
are consumer of enterprise drives and of what vintage.
