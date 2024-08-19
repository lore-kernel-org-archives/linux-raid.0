Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193FA165F00;
	Mon, 19 Aug 2024 11:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724066005; cv=none; b=ExrHs5rvgvJ+kLEIubJSzndFU9K8LnXIwuCcG0/lY5KMjAH/8w1DLM4PKyRKRfgZ6FWWmD+jERhKQDFeUhJMotoG5HU5RRluhli2DL7IZS35UhUj454C47Q4G8LNgO8QQ7fA3aesXKCSAHE87h9IgAJUBMFJkC8Hx2wz8aeH/9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724066005; c=relaxed/simple;
	bh=VQFn2R2YeXdlqZyMfdnIsDIhlsvQkrDweFjV1PNAU0U=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tqUYEievxmTtovmG1y5IzQk9XpW9Qe0TnEHSDipqw2VCwSaTfEDLA8ExpRzJdIZ7I8sbgkCLdc6nxgLwO0QXh+9ga5R3oztWQMQYixHAKjFI4vGt7DFPxFXXjZ8lDRDEofp56NPVBTkUdYVPvzHJ1ZhEOoatXSKG7oIXZf30BeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WnVM41Rjdz4f3jsB;
	Mon, 19 Aug 2024 19:13:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 40A6F1A0E96;
	Mon, 19 Aug 2024 19:13:18 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB37ILNKMNmfed+CA--.61934S3;
	Mon, 19 Aug 2024 19:13:18 +0800 (CST)
Subject: Re: [PATCH RFC -next v2 00/41] md/md-bitmap: introduce
 bitmap_operations and make structure internel
To: Su Yue <l@damenly.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, hch@infradead.org, song@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
 <wmkcor9k.fsf@damenly.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b4870359-74d5-841b-be99-102d9ec23850@huaweicloud.com>
Date: Mon, 19 Aug 2024 19:13:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <wmkcor9k.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB37ILNKMNmfed+CA--.61934S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrWkuFW7AF17Aw47KF1xXwb_yoW7AF4fpF
	Wkt34Y9w43CFn3W3W5AFyvyFyrtr95twnxJr1rCw1rCFyDAFnIqr48W3W0v3ykWrWrAFsx
	Xr15tr4rWr15ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/19 16:18, Su Yue 写道:
> 
> On Wed 14 Aug 2024 at 15:10, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Changes in v2:
>>  - add patch 1-8 to prevent dereference bitmap directly, and the  last
>>  patch to make bitmap structure internel.
>>  - use plain function alls "bitmap_ops->xxx()" directly;
>>
>> The background is that currently bitmap is using a global spin_lock,
>> cauing lock contention and huge IO performance degration for all raid
>> levels.
>>
>> However, it's impossible to implement a new lock free bitmap with
>> current situation that md-bitmap exposes the internal implementation
>> with lots of exported apis. Hence bitmap_operations is invented, to
>> describe bitmap core implementation, and a new bitmap can be introduced
>> with a new bitmap_operations, we only need to switch to the new one
>> during initialization.
>>
> Is the new bitmap in plan?

Yes, I'm working on this now in my spare time, based on this set.
>>
>> And with this we can build bitmap as kernel module, but that's not
>> our concern for now.
>>
>> Noted I just compile this patchset, not tested yet.
>>
> 
> I've looked through the patchset almostly. The changes are quite
> straightforward. IMO, it's good timing to  test it and drop RFC in next
> version.

I'm testing now, however, I met some problem that's likely related to
the mdadm tests, not this set. I'll send the formal version soon.

Thansk for the review!
Kuai

> 
>> Yu Kuai (41):
>>   md/raid1: use md_bitmap_wait_behind_writes() in   raid1_read_request()
>>   md/md-bitmap: replace md_bitmap_status() with a new helper
>>     md_bitmap_get_stats()
>>   md: use new helper md_bitmap_get_stats() in   update_array_info()
>>   md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
>>   md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
>>   md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
>>   md/md-bitmap: add 'behind_writes' and 'behind_wait' into   struct
>>     md_bitmap_stats
>>   md/md-cluster: use helper md_bitmap_get_stats() to get pages   in
>>     resize_bitmaps()
>>   md/md-bitmap: add a new helper md_bitmap_set_pages()
>>   md/md-bitmap: introduce struct bitmap_operations
>>   md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
>>   md/md-bitmap: merge md_bitmap_create() into bitmap_operations
>>   md/md-bitmap: merge md_bitmap_load() into bitmap_operations
>>   md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
>>   md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
>>   md/md-bitmap: make md_bitmap_print_sb() internal
>>   md/md-bitmap: merge md_bitmap_update_sb() into   bitmap_operations
>>   md/md-bitmap: merge md_bitmap_status() into bitmap_operations
>>   md/md-bitmap: remove md_bitmap_setallbits()
>>   md/md-bitmap: merge bitmap_write_all() into bitmap_operations
>>   md/md-bitmap: merge md_bitmap_dirty_bits() into   bitmap_operations
>>   md/md-bitmap: merge md_bitmap_startwrite() into   bitmap_operations
>>   md/md-bitmap: merge md_bitmap_endwrite() into   bitmap_operations
>>   md/md-bitmap: merge md_bitmap_start_sync() into   bitmap_operations
>>   md/md-bitmap: remove the parameter 'aborted' for   md_bitmap_end_sync()
>>   md/md-bitmap: merge md_bitmap_end_sync() into   bitmap_operations
>>   md/md-bitmap: merge md_bitmap_close_sync() into   bitmap_operations
>>   md/md-bitmap: mrege md_bitmap_cond_end_sync() into   bitmap_operations
>>   md/md-bitmap: merge md_bitmap_sync_with_cluster() into
>>     bitmap_operations
>>   md/md-bitmap: merge md_bitmap_unplug_async() into   md_bitmap_unplug()
>>   md/md-bitmap: merge bitmap_unplug() into bitmap_operations
>>   md/md-bitmap: merge md_bitmap_daemon_work() into   bitmap_operations
>>   md/md-bitmap: pass in mddev directly for md_bitmap_resize()
>>   md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
>>   md/md-bitmap: merge get_bitmap_from_slot() into   bitmap_operations
>>   md/md-bitmap: merge md_bitmap_copy_from_slot() into struct
>>     bitmap_operation.
>>   md/md-bitmap: merge md_bitmap_set_pages() into struct
>>     bitmap_operations
>>   md/md-bitmap: merge md_bitmap_free() into bitmap_operations
>>   md/md-bitmap: merge md_bitmap_wait_behind_writes() into
>>     bitmap_operations
>>   md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
>>   md/md-bitmap: make in memory structure internal
>>
>>  drivers/md/dm-raid.c     |   7 +-
>>  drivers/md/md-bitmap.c   | 561  +++++++++++++++++++++++++++++----------
>>  drivers/md/md-bitmap.h   | 272 ++++---------------
>>  drivers/md/md-cluster.c  |  79 +++---
>>  drivers/md/md.c          | 133 ++++++----
>>  drivers/md/md.h          |   3 +-
>>  drivers/md/raid1-10.c    |   9 +-
>>  drivers/md/raid1.c       |  78 +++---
>>  drivers/md/raid10.c      |  73 ++---
>>  drivers/md/raid5-cache.c |   8 +-
>>  drivers/md/raid5.c       |  62 ++---
>>  11 files changed, 731 insertions(+), 554 deletions(-)
> .
> 

