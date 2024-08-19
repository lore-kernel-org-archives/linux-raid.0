Received: from mail-108-mta33.mxroute.com (mail-108-mta33.mxroute.com [136.175.108.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEB9158845
	for <linux-raid@vger.kernel.org>; Mon, 19 Aug 2024 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724056139; cv=none; b=YfmyLXt6EVWcNZQyc3pxqPRyADaEEreYuog2zj0eioTnp0ou/sz9lIohy19wCIfItLDkE2bBoCtAsN+iiXzRHORpzgsifjQ+XjintW28CVp8fYgpMIaYmeAlCl7UoJiOPdUSialXyyU+XSycyoQLUaY90sFoKkOMCERlHIqG6Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724056139; c=relaxed/simple;
	bh=oQGQxgUO3zawwCQVQz1DUylwswq9NEBI/BBR8myQvvc=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=ogrJxJ1TJ2v08yyhn6DMGNc21HyKIvqdxBF17dc2/LCOSHiDS8LIdv0wa4Ba+dNwIFETH1NdmLUxaUKGX//4XSi2iJBHDEFvZOG0+3+NnaIEYhm03/e4Ot/+1qE6FYanyX9x5UCW1eex0ZMtWRhNOUklHN2D64+1y5mLw0t47W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=p2MFnUBl; arc=none smtp.client-ip=136.175.108.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="p2MFnUBl"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta33.mxroute.com (ZoneMTA) with ESMTPSA id 19169bc35610000a78.009
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 19 Aug 2024 08:23:47 +0000
X-Zone-Loop: 1cb15e05f60c283364dc749f5094f4fc4a4ff7346966
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Uq4/snHlLaa23xbtt6IYG0SH/3Fbq0A0tU0FyDfFTLI=; b=p2MFnUBlRBSB96Y+4i+K0KsU13
	IXFm17js6jjDhYw565mtEgBzfNp+CIf7MwfBYCU2l3nE4/UHawpKfeXqqBXdIJMRywRXHMeiePM2m
	d4eoVVBIaAxhMuMcs9J9bJ/zjTi348S9EpOqhhNv7eVgAE1avVX4tnLWYEqBNrrJepDTxKaQg+L5G
	SIKBnGEGQGpW96KH//hFq2KFKDzV8YKyO4CPrskSRpEXoFz58i4+H87COIqa8QRxG5H2VYgA9gH4u
	7oODqyF/GmPwbAVwPWLLQvLODbpVkznEccRuZ/ebzBexNLjNYxcIodR7OfOQVXMMLqRYvUFuGuTKm
	voreOjXg==;
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, hch@infradead.org, song@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH RFC -next v2 00/41] md/md-bitmap: introduce
 bitmap_operations and make structure internel
Date: Mon, 19 Aug 2024 16:18:15 +0800
In-reply-to: <20240814071113.346781-1-yukuai1@huaweicloud.com>
Message-ID: <wmkcor9k.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org
X-Spam: Yes


On Wed 14 Aug 2024 at 15:10, Yu Kuai <yukuai1@huaweicloud.com> 
wrote:

> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v2:
>  - add patch 1-8 to prevent dereference bitmap directly, and the 
>  last
>  patch to make bitmap structure internel.
>  - use plain function alls "bitmap_ops->xxx()" directly;
>
> The background is that currently bitmap is using a global 
> spin_lock,
> cauing lock contention and huge IO performance degration for all 
> raid
> levels.
>
> However, it's impossible to implement a new lock free bitmap 
> with
> current situation that md-bitmap exposes the internal 
> implementation
> with lots of exported apis. Hence bitmap_operations is invented, 
> to
> describe bitmap core implementation, and a new bitmap can be 
> introduced
> with a new bitmap_operations, we only need to switch to the new 
> one
> during initialization.
>
Is the new bitmap in plan?
>
> And with this we can build bitmap as kernel module, but that's 
> not
> our concern for now.
>
> Noted I just compile this patchset, not tested yet.
>

I've looked through the patchset almostly. The changes are quite
straightforward. IMO, it's good timing to  test it and drop RFC in 
next
version.

> Yu Kuai (41):
>   md/raid1: use md_bitmap_wait_behind_writes() in 
>   raid1_read_request()
>   md/md-bitmap: replace md_bitmap_status() with a new helper
>     md_bitmap_get_stats()
>   md: use new helper md_bitmap_get_stats() in 
>   update_array_info()
>   md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
>   md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
>   md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
>   md/md-bitmap: add 'behind_writes' and 'behind_wait' into 
>   struct
>     md_bitmap_stats
>   md/md-cluster: use helper md_bitmap_get_stats() to get pages 
>   in
>     resize_bitmaps()
>   md/md-bitmap: add a new helper md_bitmap_set_pages()
>   md/md-bitmap: introduce struct bitmap_operations
>   md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
>   md/md-bitmap: merge md_bitmap_create() into bitmap_operations
>   md/md-bitmap: merge md_bitmap_load() into bitmap_operations
>   md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
>   md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
>   md/md-bitmap: make md_bitmap_print_sb() internal
>   md/md-bitmap: merge md_bitmap_update_sb() into 
>   bitmap_operations
>   md/md-bitmap: merge md_bitmap_status() into bitmap_operations
>   md/md-bitmap: remove md_bitmap_setallbits()
>   md/md-bitmap: merge bitmap_write_all() into bitmap_operations
>   md/md-bitmap: merge md_bitmap_dirty_bits() into 
>   bitmap_operations
>   md/md-bitmap: merge md_bitmap_startwrite() into 
>   bitmap_operations
>   md/md-bitmap: merge md_bitmap_endwrite() into 
>   bitmap_operations
>   md/md-bitmap: merge md_bitmap_start_sync() into 
>   bitmap_operations
>   md/md-bitmap: remove the parameter 'aborted' for 
>   md_bitmap_end_sync()
>   md/md-bitmap: merge md_bitmap_end_sync() into 
>   bitmap_operations
>   md/md-bitmap: merge md_bitmap_close_sync() into 
>   bitmap_operations
>   md/md-bitmap: mrege md_bitmap_cond_end_sync() into 
>   bitmap_operations
>   md/md-bitmap: merge md_bitmap_sync_with_cluster() into
>     bitmap_operations
>   md/md-bitmap: merge md_bitmap_unplug_async() into 
>   md_bitmap_unplug()
>   md/md-bitmap: merge bitmap_unplug() into bitmap_operations
>   md/md-bitmap: merge md_bitmap_daemon_work() into 
>   bitmap_operations
>   md/md-bitmap: pass in mddev directly for md_bitmap_resize()
>   md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
>   md/md-bitmap: merge get_bitmap_from_slot() into 
>   bitmap_operations
>   md/md-bitmap: merge md_bitmap_copy_from_slot() into struct
>     bitmap_operation.
>   md/md-bitmap: merge md_bitmap_set_pages() into struct
>     bitmap_operations
>   md/md-bitmap: merge md_bitmap_free() into bitmap_operations
>   md/md-bitmap: merge md_bitmap_wait_behind_writes() into
>     bitmap_operations
>   md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
>   md/md-bitmap: make in memory structure internal
>
>  drivers/md/dm-raid.c     |   7 +-
>  drivers/md/md-bitmap.c   | 561 
>  +++++++++++++++++++++++++++++----------
>  drivers/md/md-bitmap.h   | 272 ++++---------------
>  drivers/md/md-cluster.c  |  79 +++---
>  drivers/md/md.c          | 133 ++++++----
>  drivers/md/md.h          |   3 +-
>  drivers/md/raid1-10.c    |   9 +-
>  drivers/md/raid1.c       |  78 +++---
>  drivers/md/raid10.c      |  73 ++---
>  drivers/md/raid5-cache.c |   8 +-
>  drivers/md/raid5.c       |  62 ++---
>  11 files changed, 731 insertions(+), 554 deletions(-)
