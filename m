Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B97A1EA73;
	Fri, 20 Sep 2024 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726841397; cv=none; b=LSF8S5sRNGD5kRoEF8mPi9ZDukeGksluxlb0vEz1mmr2opaokb4xpZ+wRAKGELxZMyJ+rYt0MYwZmYBQ8qcwx/SKa6/3pSEFy7p5GydKhYTJDLyJU6BrHAF3SkTM5CJcv++nZ6lhT38oT2+2OjxOhlY3lQuT1hYsqux2nFHox6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726841397; c=relaxed/simple;
	bh=IehmrvLOlj3Ng+RF7jXULPjQ3hPsjZUhnFZ9LgSOaOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFJ9mpDf4vwEDtM/l8NEN8kRYMLBDelollQc9c+s5E7+Ejx1WZwaSYyiHB0bfG9KRSzaIuMCJ1NsPN6kqNyjz65XM5OwWy+Rmh4gGZsmNUV/fN3udnfsHLB3JjsSBLgIyiJzy6wjkzHISPJDN/r5Vh23YZDyY6koucyBwvzLNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C9CEE227AA8; Fri, 20 Sep 2024 16:09:51 +0200 (CEST)
Date: Fri, 20 Sep 2024 16:09:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH RFC 3/6] block: Handle bio_split() errors in
 bio_submit_split()
Message-ID: <20240920140951.GB2517@lst.de>
References: <20240919092302.3094725-1-john.g.garry@oracle.com> <20240919092302.3094725-4-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919092302.3094725-4-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 19, 2024 at 09:22:59AM +0000, John Garry wrote:
> +		if (IS_ERR(split)) {
> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
> +			bio_endio(bio);
> +			return NULL;
> +		}

This could use a goto to have a single path that ends the bio and
return NULL instead of duplicating the logic.

