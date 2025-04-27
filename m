Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0F41A9B53;
	Sun, 27 Apr 2025 10:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745748032; cv=none; b=WSCCQwyPvZfMIn1Nz6n8BtJQtwLfdTDLJRYx4fnyByUHzaxBAqrkxYr2/ZuChbI3jgm1qpH+YUI9i3JD4XsJy1y1d+PsGhs9mXeBv1hG9lH1fo3AcDfUMfiYbmDhWgL0d6o3FYbi+ywnC21Rc5YYOYtCtWa5tqgEz1mzQZRyCac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745748032; c=relaxed/simple;
	bh=2AJESlIzrICkfNVKItN+ZI13DbHRQ2WIsWRmd0Gg2bQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YcesudXeWRCk900HMFEFrTmB8Iop1q8nNz10enKcCvcYRmuzVwjeIVBT4UNt0LIIX/+wARq0ZpwTGFlIXSuCUbAfCzE4/iS22rvqtgyZjSMcRH/MwkhYmcJIMbYEyJ1Nl9O0v2afnUORFxU+xEyzUEuLYL5Dd7R4r/r/ohhd5es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (ip5f5aecdf.dynamic.kabel-deutschland.de [95.90.236.223])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2CCF561E647A7;
	Sun, 27 Apr 2025 11:59:42 +0200 (CEST)
Message-ID: <5b26202c-475f-48be-b6d4-b32b62eff7b1@molgen.mpg.de>
Date: Sun, 27 Apr 2025 11:59:41 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] md: fix is_mddev_idle()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com, ubizjak@gmail.com,
 akpm@linux-foundation.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250427082928.131295-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Thank you for your patch series. Some minor comments below.


Am 27.04.25 um 10:29 schrieb Yu Kuai:
> From: Yu Kuai <yukuai3@huawei.com>

If a full cover letter is not warranted, maybe state, what patch to look 
at? (In this case 8/9.)

> Changes in v2:
>   - add patch 1-5
>   - add reviewed-by in patch 6,7,9
>   - rename mddev->last_events to mddev->normal_IO_events in patch 8
> 
> Yu Kuai (9):
>    blk-mq: remove blk_mq_in_flight()
>    block: reuse part_in_flight_rw for part_in_flight
>    block: WARN if bdev inflight counter is negative
>    block: cleanup blk_mq_in_flight_rw()

cleanup → clean up

>    block: export API to get the number of bdev inflight IO
>    md: record dm-raid gendisk in mddev
>    md: add a new api sync_io_depth

add a new → add new

>    md: fix is_mddev_idle()
>    md: cleanup accounting for issued sync IO

cleanup → clean up

>   block/blk-core.c          |   2 +-
>   block/blk-mq.c            |  22 ++---
>   block/blk-mq.h            |   5 +-
>   block/blk.h               |   1 -
>   block/genhd.c             |  69 ++++++++------
>   drivers/md/dm-raid.c      |   3 +
>   drivers/md/md.c           | 193 +++++++++++++++++++++++++++-----------
>   drivers/md/md.h           |  18 +---
>   drivers/md/raid1.c        |   3 -
>   drivers/md/raid10.c       |   9 --
>   drivers/md/raid5.c        |   8 --
>   include/linux/blkdev.h    |   1 -
>   include/linux/part_stat.h |   2 +
>   13 files changed, 194 insertions(+), 142 deletions(-)



Kind regards,

Paul
