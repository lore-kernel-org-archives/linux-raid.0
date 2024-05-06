Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EAF7FBB6
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715003533; cv=none; b=TSrl3zvPDztL2pA6p0AU608+ldgR0cJfIkWtrmF3P5qj0U/cLk2xxlOpktIwzMXWEXCJOpSVERUx0qCSoYpwjLVLBGvmPJZmbpAseM2UHP76r001A8K/nzASFs8Hjikd35PZkPIRofN13UbxTavXwh0T8YNkIaGjAEz9fZtPfqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715003533; c=relaxed/simple;
	bh=nqe4lLnojW6JKK8wueD+hSfDDWZfdo4SzYD0vOs6wOc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=c2Y+zF/63Pi/Me3EdyRvzVLXSP3HO6CG5/BhcIN+7MdHmaJliddfrpAOM4AbGkX0HRHe94hnTG3nrH4HFeQQr4lN1a7V22PpQiuxYhp3P2GhzLtIWfAtHjVBiD2/MSoZffnbhlqYfAyZ+AjCMAFSF6sRqncXU7JvIxyvsGb5sXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VY2rw57jFz4f3knx
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 21:52:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id F20751A0572
	for <linux-raid@vger.kernel.org>; Mon,  6 May 2024 21:52:05 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ6E4DhmoVKxLw--.404S3;
	Mon, 06 May 2024 21:52:05 +0800 (CST)
Subject: Re: regression: CPU soft lockup with raid10: check slab-out-of-bounds
 in md_bitmap_get_counter
To: Heinz Mauelshagen <heinzm@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Nigel Croxon <ncroxon@redhat.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, Xiao Ni <xni@redhat.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
 <a86ab399-ab3c-946c-0c2d-0f38bbde382a@huaweicloud.com>
 <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
 <75f30327-67b5-eca5-5cc8-f821ff0aeee7@huaweicloud.com>
 <14c84bbe-88e3-4ab4-afcc-2fef6397d6f4@redhat.com>
 <CAPhsuW7Tx4imRWgGsYsDJmNe3ih0pfyB1s_CGrSZ-=QQBaNBaQ@mail.gmail.com>
 <12b8b2c2-39c8-42fb-b260-43a755b5ea20@redhat.com>
 <7b795cda-54a3-c131-3407-b1012ee7ef82@huaweicloud.com>
 <CAM23Vxr6unOdZoBQZBML_uxDGc_pquktfY=R6n=kDPcWG0Jsvg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d408b95e-344a-8a92-5754-2cc9afc3c65c@huaweicloud.com>
Date: Mon, 6 May 2024 21:52:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAM23Vxr6unOdZoBQZBML_uxDGc_pquktfY=R6n=kDPcWG0Jsvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ6E4DhmoVKxLw--.404S3
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWfWF4kJr4kWrWrWr18uFg_yoWxWF17pr
	1ktFyUGrWrJr1kXr1Utw1UJry8tr1DA3WUZr1kAFy8JFsrtrnFqw1UWryqgF1DJr48Ar17
	tr45Jr1IvFyUJw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/06 20:44, Heinz Mauelshagen 写道:
> Hi,
> 
> what fields are you referring to?

For this problem, the field is: dev_sectors, for raid10, it's rdev size,
for raid456, it's array size. And dm-raid is using it as bitmap size.

And while review related code, I found following quite strage as well:

mddev->resync_max_sectors = mddev->dev_sectors;

I'm still checking following fields now, for both md/raid and dm-raid,
with the respect how sync_thread should work:

dev_sectors
resync_max_sectors
array_sectors
recovery_cp
recovery_offset
reshape_position

Thanks,
Kuai

> 
> Thanks,
> Heinz
> 
> On Mon, May 6, 2024 at 8:19 AM Yu Kuai <yukuai1@huaweicloud.com 
> <mailto:yukuai1@huaweicloud.com>> wrote:
> 
>     Hi,
> 
>     在 2024/04/30 19:07, Nigel Croxon 写道:
>      >
>      > On 4/25/24 12:52 PM, Song Liu wrote:
>      >> On Thu, Apr 25, 2024 at 5:10 AM Nigel Croxon <ncroxon@redhat.com
>     <mailto:ncroxon@redhat.com>> wrote:
>      >>>
>      >>> On 4/24/24 2:57 AM, Yu Kuai wrote:
>      >>>> Hi, Nigel
>      >>>>
>      >>>> 在 2024/04/21 20:30, Nigel Croxon 写道:
>      >>>>> On 4/20/24 2:09 AM, Yu Kuai wrote:
>      >>>>>> Hi,
>      >>>>>>
>      >>>>>> 在 2024/04/20 3:49, Nigel Croxon 写道:
>      >>>>>>> There is a problem with this commit, it causes a CPU#x soft
>     lockup
>      >>>>>>>
>      >>>>>>> commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5
>      >>>>>>> Author: Li Nan <linan122@huawei.com
>     <mailto:linan122@huawei.com>>
>      >>>>>>> Date:   Mon May 15 21:48:05 2023 +0800
>      >>>>>>> md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
>      >>>>>>>
>      >>>>>> Did you found this commit by bisect?
>      >>>>>>
>      >>>>> Yes, found this issue by bisecting...
>      >>>>>
>      >>>>>>> Message from syslogd@rhel9 at Apr 19 14:14:55 ...
>      >>>>>>>    kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s!
>      >>>>>>> [mdX_resync:6976]
>      >>>>>>>
>      >>>>>>> dmesg:
>      >>>>>>>
>      >>>>>>> [  104.245585] CPU: 7 PID: 3588 Comm: mdX_resync Kdump:
>     loaded Not
>      >>>>>>> tainted 6.9.0-rc4-next-20240419 #1
>      >>>>>>> [  104.245588] Hardware name: QEMU Standard PC (Q35 + ICH9,
>     2009),
>      >>>>>>> BIOS 1.16.2-1.fc38 04/01/2014
>      >>>>>>> [  104.245590] RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
>      >>>>>>> [  104.245598] Code: 00 00 00 00 00 66 90 90 90 90 90 90 90
>     90 90
>      >>>>>>> 90 90 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 90 90 90 fb
>     65 ff
>      >>>>>>> 0d 95 9f 75 76 <74> 05 c3 cc cc cc cc 0f 1f 44 00 00 c3 cc
>     cc cc cc
>      >>>>>>> cc cc cc cc cc
>      >>>>>>> [  104.245601] RSP: 0018:ffffb2d74a81bbf8 EFLAGS: 00000246
>      >>>>>>> [  104.245603] RAX: 0000000000000000 RBX: 0000000001000000 RCX:
>      >>>>>>> 000000000000000c
>      >>>>>>> [  104.245604] RDX: 0000000000000000 RSI: 0000000001000000 RDI:
>      >>>>>>> ffff926160ccd200
>      >>>>>>> [  104.245606] RBP: ffffb2d74a81bcd0 R08: 0000000000000013 R09:
>      >>>>>>> 0000000000000000
>      >>>>>>> [  104.245607] R10: 0000000000000000 R11: ffffb2d74a81bad8 R12:
>      >>>>>>> 0000000000000000
>      >>>>>>> [  104.245608] R13: 0000000000000000 R14: ffff926160ccd200 R15:
>      >>>>>>> ffff926151019000
>      >>>>>>> [  104.245611] FS:  0000000000000000(0000)
>      >>>>>>> GS:ffff9273f9580000(0000) knlGS:0000000000000000
>      >>>>>>> [  104.245613] CS:  0010 DS: 0000 ES: 0000 CR0:
>     0000000080050033
>      >>>>>>> [  104.245614] CR2: 00007f23774d2584 CR3: 0000000104098003 CR4:
>      >>>>>>> 0000000000370ef0
>      >>>>>>> [  104.245616] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>      >>>>>>> 0000000000000000
>      >>>>>>> [  104.245617] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>      >>>>>>> 0000000000000400
>      >>>>>>> [  104.245618] Call Trace:
>      >>>>>>> [  104.245620]  <IRQ>
>      >>>>>>> [  104.245623]  ? watchdog_timer_fn+0x1e3/0x260
>      >>>>>>> [  104.245630]  ? __pfx_watchdog_timer_fn+0x10/0x10
>      >>>>>>> [  104.245634]  ? __hrtimer_run_queues+0x112/0x2a0
>      >>>>>>> [  104.245638]  ? hrtimer_interrupt+0xff/0x240
>      >>>>>>> [  104.245640]  ? sched_clock+0xc/0x30
>      >>>>>>> [  104.245644]  ? __sysvec_apic_timer_interrupt+0x54/0x140
>      >>>>>>> [  104.245649]  ? sysvec_apic_timer_interrupt+0x6c/0x90
>      >>>>>>> [  104.245652]  </IRQ>
>      >>>>>>> [  104.245653]  <TASK>
>      >>>>>>> [  104.245654]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>      >>>>>>> [  104.245659]  ? _raw_spin_unlock_irq+0x13/0x30
>      >>>>>>> [  104.245661]  md_bitmap_start_sync+0x6b/0xf0
>      >>>> Can you give the following patch a test as well? I believe this is
>      >>>> the root cause why page > bitmap->pages, dm-raid is using the
>     wrong
>      >>>> bitmap size.
>      >>>>
>      >>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>      >>>> index abe88d1e6735..d9c65ef9c9fb 100644
>      >>>> --- a/drivers/md/dm-raid.c
>      >>>> +++ b/drivers/md/dm-raid.c
>      >>>> @@ -4052,7 +4052,8 @@ static int raid_preresume(struct
>     dm_target *ti)
>      >>>>                 mddev->bitmap_info.chunksize !=
>      >>>> to_bytes(rs->requested_bitmap_chunk_sectors)))) {
>      >>>>                  int chunksize =
>      >>>> to_bytes(rs->requested_bitmap_chunk_sectors) ?:
>      >>>> mddev->bitmap_info.chunksize;
>      >>>>
>      >>>> -               r = md_bitmap_resize(mddev->bitmap,
>      >>>> mddev->dev_sectors, chunksize, 0);
>      >>>> +               r = md_bitmap_resize(mddev->bitmap,
>      >>>> mddev->resync_max_sectors,
>      >>>> +                                    chunksize, 0);
>      >>>>                  if (r)
>      >>>>                          DMERR("Failed to resize bitmap");
>      >>>>          }
>      >>>>
>      >>>> Thanks,
>      >>>> Kuai
>      >>> Hello Kaui,
>      >>>
>      >>> Tested and found no issues. Good to go..
>      >>>
>      >>> -Nigel
>      >> Thanks for the fixes and the tests.
>      >>
>      >> For the next step, do we need both patches or just one of them?
>      >>
>      >> Song
>      >>
>      > They both fix the problem independently without the other.
> 
>     Sorry that I forgot to reply here, we discussed this on slack...
> 
>     For md/raid, we already apply the first patch to fix the soft lockup
>     problem, for dm-raid, other than the second patch to fix wrong bitmap
>     size, we still need more changes, because some fields in mddev for
>     dm-raid10 and dm-raid5 are different, while dm-raid doesn't distinguish
>     them. I'm working on that, however, I'm not that familiar with dm-raid
>     and I need more time. :)
> 
>     Thanks,
>     Kuai
> 
>      >
>      > -Nigel
>      >
>      > .
>      >
> 

