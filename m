Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BCE19479
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 06:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714976367; cv=none; b=S1/CXscg1zdtKVXOAc04NMGqH1Crce+yMb8EKjUyY9Y7Yhsl6XFYYBsvRu/YwSOOq1wLXhUp9wnh22LY+p3Cp6t4+fzEhV1rloxxspZ5emQJNbMhXjO+Ln4aWvSvdE24RttgYQDaGQG+pMgPgbjxLHnGC6PVfpZpF+aZUE5Ug9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714976367; c=relaxed/simple;
	bh=mP4Z2YqxVlDkH01nupx5v7i7kOnlPNdfinNgS+r7f1g=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tFdccdwKzr294zBSIbu9XTHY0OSXYGTe0ovNZI5bKbRDPQk1nBrtnLO3HgBCKFe0c2dmBIDXMymEyzqmRDDGUPCzYU4f8XSmQuLeVa/qqMaMGYMHL4h1oQaNvqupvnwjvgM9QDeTT/z3ShtEgtFQ2XU+lDe/SFTgcZNdOOE8vLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VXrpW4tlhz4f3mVd
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 14:19:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E7B7E1A0568
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 14:19:20 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBFndjhmHV+ULw--.36738S3;
	Mon, 06 May 2024 14:19:20 +0800 (CST)
Subject: Re: regression: CPU soft lockup with raid10: check slab-out-of-bounds
 in md_bitmap_get_counter
To: Nigel Croxon <ncroxon@redhat.com>, Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
 <a86ab399-ab3c-946c-0c2d-0f38bbde382a@huaweicloud.com>
 <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
 <75f30327-67b5-eca5-5cc8-f821ff0aeee7@huaweicloud.com>
 <14c84bbe-88e3-4ab4-afcc-2fef6397d6f4@redhat.com>
 <CAPhsuW7Tx4imRWgGsYsDJmNe3ih0pfyB1s_CGrSZ-=QQBaNBaQ@mail.gmail.com>
 <12b8b2c2-39c8-42fb-b260-43a755b5ea20@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7b795cda-54a3-c131-3407-b1012ee7ef82@huaweicloud.com>
Date: Mon, 6 May 2024 14:19:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <12b8b2c2-39c8-42fb-b260-43a755b5ea20@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBFndjhmHV+ULw--.36738S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtFy3KFWUKF15KF15Ar4xWFg_yoW7CrWfpr
	1ktFyUGrWrJr18Xr1Utw1UJryUtr17A3WUZr1kAFy8JFsrtrnIqw1UWryqgF1DJr48Ar17
	tr45Jw1IvryUJw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/04/30 19:07, Nigel Croxon 写道:
> 
> On 4/25/24 12:52 PM, Song Liu wrote:
>> On Thu, Apr 25, 2024 at 5:10 AM Nigel Croxon <ncroxon@redhat.com> wrote:
>>>
>>> On 4/24/24 2:57 AM, Yu Kuai wrote:
>>>> Hi, Nigel
>>>>
>>>> 在 2024/04/21 20:30, Nigel Croxon 写道:
>>>>> On 4/20/24 2:09 AM, Yu Kuai wrote:
>>>>>> Hi,
>>>>>>
>>>>>> 在 2024/04/20 3:49, Nigel Croxon 写道:
>>>>>>> There is a problem with this commit, it causes a CPU#x soft lockup
>>>>>>>
>>>>>>> commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5
>>>>>>> Author: Li Nan <linan122@huawei.com>
>>>>>>> Date:   Mon May 15 21:48:05 2023 +0800
>>>>>>> md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
>>>>>>>
>>>>>> Did you found this commit by bisect?
>>>>>>
>>>>> Yes, found this issue by bisecting...
>>>>>
>>>>>>> Message from syslogd@rhel9 at Apr 19 14:14:55 ...
>>>>>>>    kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s!
>>>>>>> [mdX_resync:6976]
>>>>>>>
>>>>>>> dmesg:
>>>>>>>
>>>>>>> [  104.245585] CPU: 7 PID: 3588 Comm: mdX_resync Kdump: loaded Not
>>>>>>> tainted 6.9.0-rc4-next-20240419 #1
>>>>>>> [  104.245588] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>>>>>>> BIOS 1.16.2-1.fc38 04/01/2014
>>>>>>> [  104.245590] RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
>>>>>>> [  104.245598] Code: 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90
>>>>>>> 90 90 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 90 90 90 fb 65 ff
>>>>>>> 0d 95 9f 75 76 <74> 05 c3 cc cc cc cc 0f 1f 44 00 00 c3 cc cc cc cc
>>>>>>> cc cc cc cc cc
>>>>>>> [  104.245601] RSP: 0018:ffffb2d74a81bbf8 EFLAGS: 00000246
>>>>>>> [  104.245603] RAX: 0000000000000000 RBX: 0000000001000000 RCX:
>>>>>>> 000000000000000c
>>>>>>> [  104.245604] RDX: 0000000000000000 RSI: 0000000001000000 RDI:
>>>>>>> ffff926160ccd200
>>>>>>> [  104.245606] RBP: ffffb2d74a81bcd0 R08: 0000000000000013 R09:
>>>>>>> 0000000000000000
>>>>>>> [  104.245607] R10: 0000000000000000 R11: ffffb2d74a81bad8 R12:
>>>>>>> 0000000000000000
>>>>>>> [  104.245608] R13: 0000000000000000 R14: ffff926160ccd200 R15:
>>>>>>> ffff926151019000
>>>>>>> [  104.245611] FS:  0000000000000000(0000)
>>>>>>> GS:ffff9273f9580000(0000) knlGS:0000000000000000
>>>>>>> [  104.245613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>> [  104.245614] CR2: 00007f23774d2584 CR3: 0000000104098003 CR4:
>>>>>>> 0000000000370ef0
>>>>>>> [  104.245616] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>>>>>> 0000000000000000
>>>>>>> [  104.245617] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>>>>>> 0000000000000400
>>>>>>> [  104.245618] Call Trace:
>>>>>>> [  104.245620]  <IRQ>
>>>>>>> [  104.245623]  ? watchdog_timer_fn+0x1e3/0x260
>>>>>>> [  104.245630]  ? __pfx_watchdog_timer_fn+0x10/0x10
>>>>>>> [  104.245634]  ? __hrtimer_run_queues+0x112/0x2a0
>>>>>>> [  104.245638]  ? hrtimer_interrupt+0xff/0x240
>>>>>>> [  104.245640]  ? sched_clock+0xc/0x30
>>>>>>> [  104.245644]  ? __sysvec_apic_timer_interrupt+0x54/0x140
>>>>>>> [  104.245649]  ? sysvec_apic_timer_interrupt+0x6c/0x90
>>>>>>> [  104.245652]  </IRQ>
>>>>>>> [  104.245653]  <TASK>
>>>>>>> [  104.245654]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>>>> [  104.245659]  ? _raw_spin_unlock_irq+0x13/0x30
>>>>>>> [  104.245661]  md_bitmap_start_sync+0x6b/0xf0
>>>> Can you give the following patch a test as well? I believe this is
>>>> the root cause why page > bitmap->pages, dm-raid is using the wrong
>>>> bitmap size.
>>>>
>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>>> index abe88d1e6735..d9c65ef9c9fb 100644
>>>> --- a/drivers/md/dm-raid.c
>>>> +++ b/drivers/md/dm-raid.c
>>>> @@ -4052,7 +4052,8 @@ static int raid_preresume(struct dm_target *ti)
>>>>                 mddev->bitmap_info.chunksize !=
>>>> to_bytes(rs->requested_bitmap_chunk_sectors)))) {
>>>>                  int chunksize =
>>>> to_bytes(rs->requested_bitmap_chunk_sectors) ?:
>>>> mddev->bitmap_info.chunksize;
>>>>
>>>> -               r = md_bitmap_resize(mddev->bitmap,
>>>> mddev->dev_sectors, chunksize, 0);
>>>> +               r = md_bitmap_resize(mddev->bitmap,
>>>> mddev->resync_max_sectors,
>>>> +                                    chunksize, 0);
>>>>                  if (r)
>>>>                          DMERR("Failed to resize bitmap");
>>>>          }
>>>>
>>>> Thanks,
>>>> Kuai
>>> Hello Kaui,
>>>
>>> Tested and found no issues. Good to go..
>>>
>>> -Nigel
>> Thanks for the fixes and the tests.
>>
>> For the next step, do we need both patches or just one of them?
>>
>> Song
>>
> They both fix the problem independently without the other.

Sorry that I forgot to reply here, we discussed this on slack...

For md/raid, we already apply the first patch to fix the soft lockup
problem, for dm-raid, other than the second patch to fix wrong bitmap
size, we still need more changes, because some fields in mddev for
dm-raid10 and dm-raid5 are different, while dm-raid doesn't distinguish
them. I'm working on that, however, I'm not that familiar with dm-raid
and I need more time. :)

Thanks,
Kuai

> 
> -Nigel
> 
> .
> 

