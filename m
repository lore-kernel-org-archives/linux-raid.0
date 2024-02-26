Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0791CD36
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 11:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708945463; cv=none; b=aNYjdBVvvKuwv4hqY1a/2Ftlm3+/ThFL3OYrvyJTA+u7hxjn11DYvhdH2aH/O3N4HQGuhwGuZp1C6NbBuedSFQasOnPrC1yDcGtsgrpNvOxIHmkb8mg+QpN/ccGT4lpUDBnGRSp/R0Bc4UGdure+Vh+F1qROlyJk19LA2SYV07A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708945463; c=relaxed/simple;
	bh=v7C8ugB6Vr2W66GTbtzQ8MxV0zjTX2LRiEtuJcgOsSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZnFkNKEON0KholClDbosCoMyJcoIS85Y41yL/8NdzKpzoqoqCv4wntwqCUSxYffJvuklwpdeWrqY+9Z4r/7iE6MYVbk4+sEHnFZxSeoJD9aO959csUOVrvba6rgWF0lkXh7TBCw+RZhUhQEhA1cf6A9t6TIsp+wWdu5fEHIFfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4CEE868CFE; Mon, 26 Feb 2024 12:04:15 +0100 (CET)
Date: Mon, 26 Feb 2024 12:04:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, song@kernel.org,
	guoqing.jiang@linux.dev, linux-raid@vger.kernel.org, colyli@suse.de,
	hare@suse.de
Subject: Re: [PATCH] md/md-bitmap: fix incorrect usage for sb_index
Message-ID: <20240226110414.GA28930@lst.de>
References: <20240223121128.28985-1-heming.zhao@suse.com> <20240223153713.GA1366@lst.de> <a19824b2-f1c5-460f-9688-35d8c4c1605e@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a19824b2-f1c5-460f-9688-35d8c4c1605e@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Feb 24, 2024 at 04:41:43PM +0800, Heming Zhao wrote:
> maybe I misunderstood your meaning, do you mean: you don't like the design of the bitmap, and you hope/plan to drop it?
> bitmap is a journal-like stuff. we could get an idea from filesystem journal, just write data status to the bitmap area, rather than managing it in kernel memory. with this idea, writing data protection may involve more simpler code, the replay will become more complex.

The main problem with the dm-bitmap code is the way it does I/O.  Using
->bmap to try to map blocks ahead is cumbersome, and unsafe in many
ways.  If you want to keep the MD bitmap code alive someone needs to
rewrite it to go through the file systems read_iter/write_iter ops
and do direct I/O.

