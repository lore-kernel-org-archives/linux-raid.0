Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F26156F20
	for <linux-raid@vger.kernel.org>; Fri, 31 Jan 2025 07:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738309789; cv=none; b=cw2zHM2F50/6DmAsr7e5wSavMzoBKXNYzRMM917cqHzY6Mmrc6N4PPZISsT2+o2Xf4jm3Pqr9SeMqlwc6WxKKTt1K+/LMcNlS1bNE/tlP26/ZsNkAVY6k4104pozdodl7ofFNdguU4DLpRFRdxfJne9hT6GRAjnM4nc18OfjD1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738309789; c=relaxed/simple;
	bh=6Kx/Rwdo73U1i6JtVQ8bEv4MjQbWw57bxaEuowRsF1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCjFb9q9LUr16luntJ4CEexfEDgjUGAB4E00ToVO0oqWc/EUCahDz5+HC3nljSfqZvKKwEgjM+qvsGXgeY224EHK4n+CGaPJIrDMT7sCTilk6j9LYSB8tSdErx57YbXM1l0kRYLQPQsZeIk1WVvlXVmzCU1EViVB4Ik05HDrCvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 974D168B05; Fri, 31 Jan 2025 08:49:44 +0100 (CET)
Date: Fri, 31 Jan 2025 08:49:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Coly Li <colyli@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] md: Fix linear_set_limits()
Message-ID: <20250131074944.GA16678@lst.de>
References: <20250129225636.2667932-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250129225636.2667932-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 29, 2025 at 02:56:35PM -0800, Bart Van Assche wrote:
> queue_limits_cancel_update() must only be called if
> queue_limits_start_update() is called first. Remove the
> queue_limits_cancel_update() call from linear_set_limits() because
> there is no corresponding queue_limits_start_update() call.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> This bug was discovered by annotating all mutex operations with clang
> thread-safety attributes and by building the kernel with clang and
> -Wthread-safety.

Can you send patches for that?

