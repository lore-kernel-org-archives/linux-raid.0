Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7C618A94F
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725522129; cv=none; b=u0KEquIhunhN2KlNbIeSnIiKwGGJ2jXl0MZ2PPeBHUGkq3gi3k/9WSjpKY88LZAtSN2PiXHlb5PYTL7j46qkAl+cW8vkR2k8X41cD9wAsKFWHAQvNL2PHCfYQuHW/UBVv1B38sMa335rpBdIXI7YptWN6ricnCrVN0ZqxDnFtcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725522129; c=relaxed/simple;
	bh=YaS4QTV6BhHesn3/EvZYMFani3Y+ue+oyPkqpdW93gQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QkUXXbt+1G6KRAiPqIwrcXyrD51QGZNDX5wHqrugHlgQw6Jq32lqs7HbK6LJ+5A3nJU3NmbnTViIXxtLq0nleAewatnrOF5GSIsb2iKVoLcT/iGPJrr5C8R+j3a78rAltqiiA37GDuyS/V9E560Q6qn+jIbQ0dqN2hs9hOS5MFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WzrsR4y7Zz4f3jMs
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 15:41:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BBF1D1A1706
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 15:42:02 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAHPMjJYNlmin3KAQ--.8743S3;
	Thu, 05 Sep 2024 15:42:02 +0800 (CST)
Subject: Re: [PATCH md-6.12 v14 1/1] md: generate CHANGE uevents for md device
To: Song Liu <song@kernel.org>, Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240902083816.26099-1-kinga.stefaniuk@intel.com>
 <20240902083816.26099-2-kinga.stefaniuk@intel.com>
 <CAPhsuW4WTvtQrjusPfGy+C03iXigOdEANQezxqC1XxQ=h5KzBg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e6828f60-e5ae-5c11-1828-f6d75fbfddf7@huaweicloud.com>
Date: Thu, 5 Sep 2024 15:42:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4WTvtQrjusPfGy+C03iXigOdEANQezxqC1XxQ=h5KzBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHPMjJYNlmin3KAQ--.8743S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurWrJFyxJF1UJrWkuFW7urg_yoWrCr4fpa
	y3Ca90yr10yw1rAay3JF4kXr1fZa98KasxG392k3y7Z3WUuFnrtF13Kw1a9F9xWry8Wa17
	Za9IgrWkur98AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/09/05 5:51, Song Liu 写道:
> On Mon, Sep 2, 2024 at 1:38 AM Kinga Stefaniuk
> <kinga.stefaniuk@intel.com> wrote:
>>
>> In mdadm commit 49b69533e8 ("mdmonitor: check if udev has finished
>> events processing") mdmonitor has been learnt to wait for udev to finish
>> processing, and later in commit 9935cf0f64f3 ("Mdmonitor: Improve udev
>> event handling") pooling for MD events on /proc/mdstat file has been
>> deprecated because relying on udev events is more reliable and less bug
>> prone (we are not competing with udev).
>>
>> After those changes we are still observing missing mdmonitor events in
>> some scenarios, especially SpareEvent is likely to be missed. With this
>> patch MD will be able to generate more change uevents and wakeup
>> mdmonitor more frequently to give it possibility to notice events.
>> MD has md_new_events() functionality to trigger events and with this
>> patch this function is extended to generate udev CHANGE uevents. It
>> cannot be done directly because this function is called on interrupts
>> context, so appropriate workqueue is created. Uevents are less time
>> critical, it is safe to use workqueue. It is limited to CHANGE event as
>> there is no need to generate other uevents for now.
>> With this change, mdmonitor events are less likely to be missed. Our
>> internal tests suite confirms that, mdmonitor reliability is (again)
>> improved.
>> Start using irq methods on all_mddevs_lock, because it can be reached
>> by interrupt context.
>>
>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
>> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
> 
> I am seeing new failures from mdadm tests, for example, test 01replace.
> Please run these tests and fix the issues.

I just test this myself in my VM, I didn't see 01replace failed,
howerver, test 13imsm-r0_r5_3d-grow-r0_r5_4d start to hang:

[16098.862049] INFO: task systemd-udevd:57927 blocked for more than 368 
seconds.^M
[16098.863049]       Not tainted 6.11.0-rc1-00078-g761e5afb6ddb-dirty #362^M
[16098.863802] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.^M
[16098.865773] ^M
[16098.865773] Showing all locks held in the system:^M
[16098.866702] 1 lock held by khungtaskd/31:^M
[16098.867233]  #0: ffffffff8a789b40 (rcu_read_lock){....}-{1:2}, at: 
debug_show_all_locks+0x46/0x320^M
[16098.868589] 1 lock held by systemd-journal/203:^M
[16098.869276] 1 lock held by systemd-udevd/57927:^M
[16098.869966]  #0: ffff8881a61fa1a8 
(mapping.invalidate_lock#2){++++}-{3:3}, at: 
page_cache_ra_unbounded+0x73/0x2d0^M
[16098.871477] 4 locks held by mdadm/58163:^M
[16098.872099]  #0: ffff88817d4b4400 (sb_writers#5){.+.+}-{0:0}, at: 
vfs_write+0x32d/0x470^M
[16098.873303]  #1: ffff888193dcd688 (&of->mutex#2){+.+.}-{3:3}, at: 
kernfs_fop_write_iter+0x143/0x280^M
[16098.874620]  #2: ffff8881323cb010 (kn->active#98){.+.+}-{0:0}, at: 
kernfs_fop_write_iter+0x153/0x280^M
[16098.876005]  #3: ffff888193d4a0a8 
(&mddev->suspend_mutex){+.+.}-{3:3}, at: mddev_suspend+0x59/0x380 [md_mod]^M

[root@fedora ~]# cat /proc/57927/stack
[<0>] wait_woken+0xa4/0xd0
[<0>] raid5_make_request+0x994/0x2080 [raid456]
[<0>] md_handle_request+0x17a/0x4b0 [md_mod]
[<0>] md_submit_bio+0x7c/0x130 [md_mod]
[<0>] __submit_bio+0x12b/0x190
[<0>] submit_bio_noacct_nocheck+0x22b/0x6a0
[<0>] submit_bio_noacct+0x259/0xac0
[<0>] submit_bio+0x58/0x1d0
[<0>] mpage_readahead+0x195/0x280
[<0>] blkdev_readahead+0x1d/0x30
[<0>] read_pages+0x6e/0x550
[<0>] page_cache_ra_unbounded+0x1c6/0x2d0
[<0>] do_page_cache_ra+0x4f/0x80
[<0>] force_page_cache_ra+0x78/0xc0
[<0>] page_cache_sync_ra+0x60/0x460
[<0>] filemap_get_pages+0x13f/0xba0
[<0>] filemap_read+0x122/0x590
[<0>] blkdev_read_iter+0x7a/0x210
[<0>] vfs_read+0x27f/0x400
[<0>] ksys_read+0x85/0x180
[<0>] __x64_sys_read+0x21/0x30
[<0>] x64_sys_call+0x45e7/0x4600
[<0>] do_syscall_64+0xd5/0x230
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Does user space need to change as well?

Thanks,
Kuai

> 
> Thanks,
> Song
> 
> 
> .
> 

