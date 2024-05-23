Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B0C134A5;
	Thu, 23 May 2024 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716479081; cv=none; b=PydRrOncLwf1ClPdl13cTBbaXkEKeGNELA3iWOwLNjTAaGkKhfNvIF/ZjassquYPcz4zc/WjsQvdxHTUu6bxPMkUddy49zlL83idaqwIIlSeXcpxFNigYjRYhZu+dWZn5yevDbktO7k6E2RvbnQkwZZOZEZyBUtCzGbhnmAQLZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716479081; c=relaxed/simple;
	bh=iopavRPbhnH+EHMJrXECqzF9kHqjZsi99nb9brY79SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBSn8jVECV5T722HpLs0tIlUaDw8ZR1Zc6ODY9Nw6wpu2ykjJuM6lP8BREgV9ocdgEhWuvpWUaZSxxK6Yn1WyXxADW6dFMplLhaEZdmn4ypn+cGqXdp8xtZP4I3pC4FaZTB3uGSGZ3sfKxvcxMkAKvwbZxjDqm4Yxn6rXTo0pxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 10CE568BFE; Thu, 23 May 2024 17:44:36 +0200 (CEST)
Date: Thu, 23 May 2024 17:44:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
	axboe@kernel.dk, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH for-6.10-rc1] block: fix blk_validate_limits() to
 properly handle stacked devices
Message-ID: <20240523154435.GA1783@lst.de>
References: <20240522025117.75568-1-snitzer@kernel.org> <20240522142458.GB7502@lst.de> <Zk4h-6f2M0XmraJV@kernel.org> <Zk6haNVa5JXxlOf1@fedora> <Zk9i7V2GRoHxBPRu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk9i7V2GRoHxBPRu@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 23, 2024 at 11:38:21AM -0400, Mike Snitzer wrote:
> Sure, we could elevate it to blk_validate_limits (and callers) but
> adding a 'stacking' parameter is more intrusive on an API level.
> 
> Best to just update blk_set_stacking_limits() to set a new 'stacking'
> flag in struct queue_limits, and update blk_stack_limits() to stack
> that flag up.
> 
> I've verified this commit to work and have staged it in linux-next via
> linux-dm.git's 'for-next', see:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=cedc03d697ff255dd5b600146521434e2e921815
> 
> Jens (and obviously: Christoph, Ming and others), I'm happy to send
> this to Linus tomorrow morning if you could please provide your
> Reviewed-by or Acked-by.  I'd prefer to keep the intermediate DM fix
> just to "show the work and testing".

A stacking flag in the limits is fundamentally wrong, please don't
do this.
