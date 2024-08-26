Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91663646;
	Mon, 26 Aug 2024 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724636430; cv=none; b=ALnQ4FuKirr4GGv46Xtunj9Z49ihKvizeTNLQuUv+ZQnUshesaba6Wl31aiwihvqQWciVq1fud87M9NIywalDutim3uaiE1vyh3PCwd7srkpiNisdHFNFgHQHMFwdMTV04YBXXImiNefPjadHvoFKuf3reRPYs+XtZ5ENa/Ecz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724636430; c=relaxed/simple;
	bh=Sci0TpGKbuQ2zy3eLwfa7dvA/LBjtSRi+O+a9PtNyOA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MgmNXZ0rFjc1xlD9JNe9WGNOh4VblWRq4l2i/7/vg722YEeO4hpk4mqq1WVQ6kBmO5z6qaPJZjtOg0Fyupbg8/IVujC12B+4tKMbk+5DqJNpv3HRgWxXuPXknZhp1giNfj3dwGsnS9TBXKDvKItLDRGR/NdQP27qX+ppNLnkpKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsYJp6RR7z4f3jsB;
	Mon, 26 Aug 2024 09:40:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 56F2F1A0359;
	Mon, 26 Aug 2024 09:40:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXfoQI3ctmLxDsCg--.4376S3;
	Mon, 26 Aug 2024 09:40:25 +0800 (CST)
Subject: Re: [PATCH md-6.12 00/41] md/md-bitmap: introduce bitmap_operations
 and make structure internel
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, mariusz.tkaczyk@linux.intel.com, l@damenly.org,
 xni@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
 <aecb239d-9bcd-457a-8501-3e7a2fb028b4@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0c613549-5efb-5416-7308-658fc5f10341@huaweicloud.com>
Date: Mon, 26 Aug 2024 09:40:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aecb239d-9bcd-457a-8501-3e7a2fb028b4@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXfoQI3ctmLxDsCg--.4376S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrW5ZFyfKF13GF48JrW7twb_yoW7Zr4kpF
	WDt345Kw43C3Z3W3W5AryvyFyrtrykt3srJr1rC34rCFyDJF9Iqr48W3W0v34kWr48AFsx
	Xr15tr4fWr17XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUpwZcUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/22 14:50, Paul Menzel 写道:
> Dear Yu,
> 
> 
> Thank you for this patch series.
> 
> 
> Am 22.08.24 um 04:46 schrieb Yu Kuai:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Changes from RFC v1:
>>   - add patch 1-8 to prevent dereference bitmap directly, and the last
>>   patch to make bitmap structure internel.
>>   - use plain function alls "bitmap_ops->xxx()" directly;
>>
>> Changes from RFC v2:
>>   - some coding style.
>>
>> The background is that currently bitmap is using a global spin_lock,
>> cauing lock contention and huge IO performance degration for all raid
> 
> cau*s*ing
> degra*da*tion
> 
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
> 
> however
> 
>> we're working on it.
> 
> It’d be great if you shared the benchmark data, and how this can be 
> verified on other setups, so performance does not degrade on some 
> sometimes.

Performance is not tested yet. Because this set doesn't have much
functional changes, jus some code cleanup.

Thanks,
Kuai

> 
> 
> Kind regards,
> 
> Paul
> 
> 
>> Yu Kuai (41):
>>    md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
>>    md/md-bitmap: replace md_bitmap_status() with a new helper
>>      md_bitmap_get_stats()
>>    md: use new helper md_bitmap_get_stats() in update_array_info()
>>    md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
>>    md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
>>    md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
>>    md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct
>>      md_bitmap_stats
>>    md/md-cluster: use helper md_bitmap_get_stats() to get pages in
>>      resize_bitmaps()
>>    md/md-bitmap: add a new helper md_bitmap_set_pages()
>>    md/md-bitmap: introduce struct bitmap_operations
>>    md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
>>    md/md-bitmap: merge md_bitmap_create() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_load() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
>>    md/md-bitmap: make md_bitmap_print_sb() internal
>>    md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_status() into bitmap_operations
>>    md/md-bitmap: remove md_bitmap_setallbits()
>>    md/md-bitmap: merge bitmap_write_all() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations
>>    md/md-bitmap: remove the parameter 'aborted' for md_bitmap_end_sync()
>>    md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
>>    md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_sync_with_cluster() into
>>      bitmap_operations
>>    md/md-bitmap: merge md_bitmap_unplug_async() into md_bitmap_unplug()
>>    md/md-bitmap: merge bitmap_unplug() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
>>    md/md-bitmap: pass in mddev directly for md_bitmap_resize()
>>    md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
>>    md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_copy_from_slot() into struct
>>      bitmap_operation.
>>    md/md-bitmap: merge md_bitmap_set_pages() into struct
>>      bitmap_operations
>>    md/md-bitmap: merge md_bitmap_free() into bitmap_operations
>>    md/md-bitmap: merge md_bitmap_wait_behind_writes() into
>>      bitmap_operations
>>    md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
>>    md/md-bitmap: make in memory structure internal
>>
>>   drivers/md/dm-raid.c     |   7 +-
>>   drivers/md/md-bitmap.c   | 560 +++++++++++++++++++++++++++++----------
>>   drivers/md/md-bitmap.h   | 268 ++++---------------
>>   drivers/md/md-cluster.c  |  91 ++++---
>>   drivers/md/md.c          | 155 +++++++----
>>   drivers/md/md.h          |   3 +-
>>   drivers/md/raid1-10.c    |   9 +-
>>   drivers/md/raid1.c       |  78 +++---
>>   drivers/md/raid10.c      |  73 ++---
>>   drivers/md/raid5-cache.c |   8 +-
>>   drivers/md/raid5.c       |  62 ++---
>>   11 files changed, 752 insertions(+), 562 deletions(-)
>>
> 
> .
> 

