Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B817139D05;
	Thu, 22 Aug 2024 06:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724309518; cv=none; b=RZy7kxYvl9Zu+wzPt0Yz/0uaIOOiZ8FKzaKNHvspBRz22z+ZHzjK0awEnS8Ev4hyRRe20yJRdjIo9kK838EjxjGMS4eyPucDntHxpWJdU2CkCMfU7anggWja8HVOr5hOxnHCMiIsMpNwsPeHcyYBF7/+ccxmcPS7dfQDKlgp/kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724309518; c=relaxed/simple;
	bh=FKKli69wO8Hyo6tYDhXu7GtACdSLj+GCPbjyKDAcyIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CDyOHN4gCqi4QwvaPoeU+RRmuFnTMNt1YI3M5k3E+wTIVZ77vVOlOCBqW2W8XP6FnUtIEIe6NtSYvDCU0IwwsBg+e1HxW8Au4n42kzYt1oCqU2qwMtsvILr0AKsr9adFUFlJurjl72SlaRbOUOgGYZNAJAuS9NT/2ZvP0EPo9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.3] (ip5f5af532.dynamic.kabel-deutschland.de [95.90.245.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0215761E5FE05;
	Thu, 22 Aug 2024 08:50:42 +0200 (CEST)
Message-ID: <aecb239d-9bcd-457a-8501-3e7a2fb028b4@molgen.mpg.de>
Date: Thu, 22 Aug 2024 08:50:42 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.12 00/41] md/md-bitmap: introduce bitmap_operations
 and make structure internel
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, mariusz.tkaczyk@linux.intel.com, l@damenly.org,
 xni@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Yu,


Thank you for this patch series.


Am 22.08.24 um 04:46 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes from RFC v1:
>   - add patch 1-8 to prevent dereference bitmap directly, and the last
>   patch to make bitmap structure internel.
>   - use plain function alls "bitmap_ops->xxx()" directly;
> 
> Changes from RFC v2:
>   - some coding style.
> 
> The background is that currently bitmap is using a global spin_lock,
> cauing lock contention and huge IO performance degration for all raid

cau*s*ing
degra*da*tion

> levels.
> 
> However, it's impossible to implement a new lock free bitmap with
> current situation that md-bitmap exposes the internal implementation
> with lots of exported apis. Hence bitmap_operations is invented, to
> describe bitmap core implementation, and a new bitmap can be introduced
> with a new bitmap_operations, we only need to switch to the new one
> during initialization.
> 
> And with this we can build bitmap as kernel module, but that's not
> our concern for now.
> 
> This version was tested with mdadm tests. There are still few failed
> tests in my VM, howerver, it's the test itself need to be fixed and

however

> we're working on it.

It’d be great if you shared the benchmark data, and how this can be 
verified on other setups, so performance does not degrade on some sometimes.


Kind regards,

Paul


> Yu Kuai (41):
>    md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
>    md/md-bitmap: replace md_bitmap_status() with a new helper
>      md_bitmap_get_stats()
>    md: use new helper md_bitmap_get_stats() in update_array_info()
>    md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
>    md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
>    md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
>    md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct
>      md_bitmap_stats
>    md/md-cluster: use helper md_bitmap_get_stats() to get pages in
>      resize_bitmaps()
>    md/md-bitmap: add a new helper md_bitmap_set_pages()
>    md/md-bitmap: introduce struct bitmap_operations
>    md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
>    md/md-bitmap: merge md_bitmap_create() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_load() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
>    md/md-bitmap: make md_bitmap_print_sb() internal
>    md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_status() into bitmap_operations
>    md/md-bitmap: remove md_bitmap_setallbits()
>    md/md-bitmap: merge bitmap_write_all() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations
>    md/md-bitmap: remove the parameter 'aborted' for md_bitmap_end_sync()
>    md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
>    md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_sync_with_cluster() into
>      bitmap_operations
>    md/md-bitmap: merge md_bitmap_unplug_async() into md_bitmap_unplug()
>    md/md-bitmap: merge bitmap_unplug() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
>    md/md-bitmap: pass in mddev directly for md_bitmap_resize()
>    md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
>    md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_copy_from_slot() into struct
>      bitmap_operation.
>    md/md-bitmap: merge md_bitmap_set_pages() into struct
>      bitmap_operations
>    md/md-bitmap: merge md_bitmap_free() into bitmap_operations
>    md/md-bitmap: merge md_bitmap_wait_behind_writes() into
>      bitmap_operations
>    md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
>    md/md-bitmap: make in memory structure internal
> 
>   drivers/md/dm-raid.c     |   7 +-
>   drivers/md/md-bitmap.c   | 560 +++++++++++++++++++++++++++++----------
>   drivers/md/md-bitmap.h   | 268 ++++---------------
>   drivers/md/md-cluster.c  |  91 ++++---
>   drivers/md/md.c          | 155 +++++++----
>   drivers/md/md.h          |   3 +-
>   drivers/md/raid1-10.c    |   9 +-
>   drivers/md/raid1.c       |  78 +++---
>   drivers/md/raid10.c      |  73 ++---
>   drivers/md/raid5-cache.c |   8 +-
>   drivers/md/raid5.c       |  62 ++---
>   11 files changed, 752 insertions(+), 562 deletions(-)
> 

