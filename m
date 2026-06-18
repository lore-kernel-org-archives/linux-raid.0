Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CF83DB32F;
	Thu, 18 Jun 2026 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781774549; cv=none; b=NPlMglx57R+Ot6xgduywCkFw4oWNjxtYSQS7GIbojykCYCeOJq+ZJ6910KEhiN89ESgzwiNqix2QuTGuIWgxiDCYf3KZ/gb5BAq8UdHaZgPETM4O+cBxK69cqrLX714vZd/tcShtz5lVGNjPQWQESzgDy/isRA7D2TKxA0gDa+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781774549; c=relaxed/simple;
	bh=/FtcL4izDLLq2ERBhWdYwBURCJu45DGxuNoxv72dGWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Md0mR5jdKXXmg5FR8CxSXaTOx9cJ1GaQ3OpO6zP5KmL7A186rW+dHzNuzXrlTusUeWDyc1WmBZWvVBQD+gt6kK/LY28E0DJ+/GKIJ7R8tl9g/WLhtRVe7fagJCFt+kM4SeI+XuZK8xVjqqwihdcPWa0s4/SbDv5m5fx0O6yGWi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9516368C4E; Thu, 18 Jun 2026 11:22:24 +0200 (CEST)
Date: Thu, 18 Jun 2026 11:22:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] xor/kunit: add a benchmark
Message-ID: <20260618092224.GB17530@lst.de>
References: <20260617054416.3841334-1-hch@lst.de> <20260617054416.3841334-3-hch@lst.de> <20260617171448.GD785086@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617171448.GD785086@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 17, 2026 at 05:14:48PM +0000, Eric Biggers wrote:
> The #ifdef can be avoided using kunit_skip(), as the crypto and CRC
> tests do:
> 
>     if (!IS_ENABLED(CONFIG_XOR_BENCHMARK))
>             kunit_skip(test, "not enabled");

I saw that, but what's the point or just not compiling it?

> > +		static_assert(ARRAY_SIZE(len_to_test) == 2);
> > +		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
> > +				nr, speed[0], speed[1]);
> 
> As mentioned in the other thread, this measures the speed at which the
> source data is consumed, which differs from the code in
> lib/raid/xor/xor-core.c that measures the speed at which the destination
> data is produced.  Probably best to make them consistent.

The throughput for the generated parity isn't very interesting.  It is
the overall throughput that determines the performance.  And yes,
the selection benchmark is a complete mess - the single disk XOR is
not a relevant performance metric.

