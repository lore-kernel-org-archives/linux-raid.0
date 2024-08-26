Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156DA1FBA;
	Mon, 26 Aug 2024 01:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724636607; cv=none; b=hd349mg3m7iNwa5eNl/9IkBiL0oHXAGjMKx38irgBOZPtmsP11UwSMN0GFx9DvGSuXgk5NfNqKC7ggTlaFc1RwH3Rp+00rhVsNOPQ5w9B1MFiCzurlgpO+1tpY+VOGzb0V1pHo5X2xi7Apl14DcyiOsTuQD8veWt/z1bnUk/Aps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724636607; c=relaxed/simple;
	bh=tb8xukPUWVGasCOY0qWx24Vd45avp325MTiMtlU+LjE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VikuqDVAnolBucuCkGuisG3yVR0MUv/or6AfRBLNFn2t8lxCPAcp8hpVpPT6d1Pew+5KUuO7pJtoB9Q8B9BxyYFuD57jmTWtUw+tsbedg7SzIsaRi3TinV/E5FEuDWIsyP1sye51ozx3vr4cfw0RTlKvH9Ngvipj4G722bIgVWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsYNG6bXpz4f3jk1;
	Mon, 26 Aug 2024 09:43:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C0B9B1A06D7;
	Mon, 26 Aug 2024 09:43:20 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB37IK23ctmTkHsCg--.7068S3;
	Mon, 26 Aug 2024 09:43:20 +0800 (CST)
Subject: Re: [PATCH md-6.12 00/41] md/md-bitmap: introduce bitmap_operations
 and make structure internel
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, mariusz.tkaczyk@linux.intel.com, l@damenly.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
 <CALTww28Pj6kPSc_JGX3ya6B5bgUUyoHxVXd6BnCZ1P-ub404bw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9ee3a3a7-303e-62d9-42ec-b2b4cd05cd55@huaweicloud.com>
Date: Mon, 26 Aug 2024 09:43:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww28Pj6kPSc_JGX3ya6B5bgUUyoHxVXd6BnCZ1P-ub404bw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB37IK23ctmTkHsCg--.7068S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Wry8KF47uw1fCrW7ZFy8Grg_yoW7Ar1DpF
	WDt3WYkw43JF1fW3WYkryvyFyrtryktrsrJr1rCw1rCa4DAF9xXr48u3WIy3s7Wry5GFsx
	Xr45tF1rWr17XaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoWlkDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/22 16:38, Xiao Ni 写道:
> On Thu, Aug 22, 2024 at 10:52 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Changes from RFC v1:
>>   - add patch 1-8 to prevent dereference bitmap directly, and the last
>>   patch to make bitmap structure internel.
>>   - use plain function alls "bitmap_ops->xxx()" directly;
>>
>> Changes from RFC v2:
>>   - some coding style.
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
>> And with this we can build bitmap as kernel module, but that's not
>> our concern for now.
>>
>> This version was tested with mdadm tests. There are still few failed
>> tests in my VM, howerver, it's the test itself need to be fixed and
>> we're working on it.
> 
> Hi Kuai
> 
> Do you run lvm2 test regression tests? It's better to run lvm2
> regression tests for such a big change.

Not yet, again because there are not much functional changes. I can run
lvm2 test later.

> 
> And by the way, does this patch set have a conflict with patch set
> "[RFC V7] md/bitmap: Optimize lock contention". I haven't read the
> patches, it's an optimization for the bitmap lock too.

Of course there will be context conflict. After someone is applied, the
other one must rebase.

Thanks,
Kuai

> 
> Best Regards
> Xiao
>>
>> Yu Kuai (41):
>>    md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
>>    md/md-bitmap: replace md_bitmap_status() with a new helper
>>      md_bitmap_get_stats()
>>    md: use new helper md_bitmap_get_stats() in update_array_info()
>>    md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
>>    md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
>>    md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
>>    md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct
>>      md_bitmap_stats
>>    md/md-cluster: use helper md_bitmap_get_stats() to get pages in
>>      resize_bitmaps()
>>    md/md-bitmap: add a new helper md_bitmap_set_pages()
>>    md/md-bitmap: introduce struct bitmap_operations
>>    md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
>>    md/md-bitmap: merge md_bitmap_create() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_load() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
>>    md/md-bitmap: make md_bitmap_print_sb() internal
>>    md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_status() into bitmap_operations
>>    md/md-bitmap: remove md_bitmap_setallbits()
>>    md/md-bitmap: merge bitmap_write_all() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations
>>    md/md-bitmap: remove the parameter 'aborted' for md_bitmap_end_sync()
>>    md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
>>    md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_sync_with_cluster() into
>>      bitmap_operations
>>    md/md-bitmap: merge md_bitmap_unplug_async() into md_bitmap_unplug()
>>    md/md-bitmap: merge bitmap_unplug() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
>>    md/md-bitmap: pass in mddev directly for md_bitmap_resize()
>>    md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
>>    md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_copy_from_slot() into struct
>>      bitmap_operation.
>>    md/md-bitmap: merge md_bitmap_set_pages() into struct
>>      bitmap_operations
>>    md/md-bitmap: merge md_bitmap_free() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_wait_behind_writes() into
>>      bitmap_operations
>>    md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
>>    md/md-bitmap: make in memory structure internal
>>
>>   drivers/md/dm-raid.c     |   7 +-
>>   drivers/md/md-bitmap.c   | 560 +++++++++++++++++++++++++++++----------
>>   drivers/md/md-bitmap.h   | 268 ++++---------------
>>   drivers/md/md-cluster.c  |  91 ++++---
>>   drivers/md/md.c          | 155 +++++++----
>>   drivers/md/md.h          |   3 +-
>>   drivers/md/raid1-10.c    |   9 +-
>>   drivers/md/raid1.c       |  78 +++---
>>   drivers/md/raid10.c      |  73 ++---
>>   drivers/md/raid5-cache.c |   8 +-
>>   drivers/md/raid5.c       |  62 ++---
>>   11 files changed, 752 insertions(+), 562 deletions(-)
>>
>> --
>> 2.39.2
>>
> 
> 
> 
> .
> 

