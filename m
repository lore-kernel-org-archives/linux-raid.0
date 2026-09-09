Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE613A874C;
	Wed,  9 Sep 2026 06:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788935369; cv=none; b=nwqUwtFTtN94AjyBCgxNlAiLzTnEgQ3X5Ch8x7eNqKTjLlB41vYekJoFfGHTOACQ3aGAn229Rv80GkfuWA6fYdQTqoEopJ7pVK6nYigsLRxWhOtpHqWDgKdtZVXCjfg5suwtAdoLvKicaE3acoZ4ZeEORR2OcHZDmwtfAh0bI80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788935369; c=relaxed/simple;
	bh=iBrhBs3dBvbB3gaiOiwEW/gKXYKIcf9QStPkMhyfOHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkoUi/lMh/dfMQq1KICS9SpJA9ax1clTmiRLO+foWd1Z2vKipQ8WMn75XiOmfvFoI3bZBkCpWAVG7GWi6sV6/T0iZ92FfI495ttE2z7JYvhczsG996lKgfRTWHL5BeIJfUsTTT9oNt3VXbd/SR7ukty73VYZInOscUKANVFLJaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 404BB68BFE; Wed,  9 Sep 2026 08:29:23 +0200 (CEST)
Date: Wed, 9 Sep 2026 08:29:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jack Wang <jinpu.wang@ionos.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>, abd.masalkhi@gmail.com,
	linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>, tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 1/6] block: add queue_limits_start_update_trylock()
Message-ID: <20260909062923.GB29874@lst.de>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com> <20260907133929.1081540-2-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907133929.1081540-2-jinpu.wang@ionos.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 07, 2026 at 03:39:24PM +0200, Jack Wang wrote:
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
> 
> Some callers must not wait for q->limits_lock, because they hold
> something the current holder waits for.  md is one: its
> check_sb_changes() runs with reconfig_mutex held, while a
> queue_attr_store() holding limits_lock waits in blk_mq_freeze_queue()
> for I/O that can be waiting for a superblock update needing that mutex.
> 
> Add a trylock variant of queue_limits_start_update() for them.

I don't think this is a good idea, please fix the lock ordering
instead.

> Assisted-by: Claude:claude-opus-5

But if not please try to come up with helpers like this based on
your own.  We don't really need this amount of AI slop.

> + * Like queue_limits_start_update(), but fails instead of waiting when another
> + * update is in flight.  For callers that must not block on q->limits_lock
> + * because they hold something its current owner is waiting for.
> + *
> + * Context: process context.
> + */
> +static inline bool
> +queue_limits_start_update_trylock(struct request_queue *q,
> +				  struct queue_limits *lim)
> +	__cond_acquires(true, &q->limits_lock)
> +{
> +	if (!mutex_trylock(&q->limits_lock))
> +		return false;
> +
> +	*lim = q->limits;
> +
> +	return true;
> +}
> +
>  int queue_limits_commit_update_frozen(struct request_queue *q,
>  		struct queue_limits *lim) __releases(&q->limits_lock);
>  int queue_limits_commit_update(struct request_queue *q,
> -- 
> 2.43.0
---end quoted text---
