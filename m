Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BB82F5A
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 02:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731551762; cv=none; b=E3+bYtIa+3OoCXrZi/fr0wQoEy1DIqBQyECmoN8U1ak70AgAdW0OnyHQSzuIzmqvZr3FOZuNnDAhyao0SHfaxgizegyOJypSwASsMvNFP/RCR4DztDDJXy/L6gZ5HCUJZRSMa1AfiApnl7bor7iYG+6c2/4kgSJpOHl3n800OYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731551762; c=relaxed/simple;
	bh=ZAZOKx5ieZO6H6CHur0xQw4akERJd20VPJH+E+A3ELY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UODCC5HZfQN7BUXYxz8waHnwwM4LsM6/d8Pz/unUVNvoMOpuO+UKhxqy8rFq0F3Jmkbw1Xily9YmFZTQXAGsK/KaSb+JeZjZRzITMMXtLsB6dWgh2pr9DF+pWoIGJ5BxHoPrhVppU6cAxxj+wIVRxpzfkW3bsBBcVDdHExeEX/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xpkll3bdrz4f3jXc
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 10:35:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B82AC1A0194
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 10:35:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYUDYjVnFMbmBg--.35949S3;
	Thu, 14 Nov 2024 10:35:49 +0800 (CST)
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, linux-raid@vger.kernel.org,
 Jinpu Wang <jinpu.wang@ionos.com>,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com>
 <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
 <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com>
 <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
 <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com>
 <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3fbe69c8-375c-c397-d40d-bc26d4aeda1a@huaweicloud.com>
Date: Thu, 14 Nov 2024 10:35:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYUDYjVnFMbmBg--.35949S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw1DWrW8WF4fKF4rWr1DGFg_yoW7Zr4xpF
	WUKFnFgw48W345Jr12vw1Uuw15tanF9FWUXr4xXw18XFyvqryDJw4xJrW5CF9xJryF9343
	tw4Yq34xtw1DtaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/14 0:46, Haris Iqbal 写道:
> On Wed, Nov 13, 2024 at 8:46 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/11/11 21:56, Haris Iqbal 写道:
>>> On Mon, Nov 11, 2024 at 2:39 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> 在 2024/11/11 21:29, Haris Iqbal 写道:
>>>>> Hello,
>>>>>
>>>>> I gave both the patches a try, and here are my findings.
>>>>>
>>>>
>>>> Thanks for the test!
>>>>
>>>>> With the first patch by Yu, I did not see any hang or errors. I tried
>>>>> a number of bitmap chunk sizes, and ran fio for few hours, and there
>>>>> was no hang.
>>>>
>>>> This is good news! However, there is still a long road for my approch
>>>> to land, this requires a lot of other changes to work.
>>>>>
>>>>> With the second patch Xiao, I hit the following BUG_ON on the first
>>>>> minute of my fio run.
>>>>
>>>> This is sad. :(
>>>>>
>>>>> [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
>>>>> [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
>>>>> loaded Not tainted 6.11.5-storage
>>>>> #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
>>>>> [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/2021
>>>>> [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
>>>>> [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
>>>>
>>>> Can you provide the addr2line of this?
>>>>
>>>> gdb raid456.ko
>>>> list *(__add_stripe_bio+0x23f)
>>>
>>> Sorry. I missed the first line while copying.
>>>
>>> [  113.902680] kernel BUG at drivers/md/raid5.c:3525!
>>
>> Can you give the following patch a test again, on the top of Xiao's
>> patch.
>>
>> Thanks,
>> Kuai
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 6e318598a7b6..189f784aed00 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3516,7 +3516,7 @@ static void __add_stripe_bio(struct stripe_head
>> *sh, struct bio *bi,
>>                   bip = &sh->dev[dd_idx].toread;
>>           }
>>
>> -       while (*bip && (*bip)->bi_iter.bi_sector < bi->bi_iter.bi_sector)
>> +       while (*bip && (*bip)->bi_iter.bi_sector <= bi->bi_iter.bi_sector)
>>                   bip = &(*bip)->bi_next;
>>
>>           if (!forwrite || previous)
> 
> Still hangs. Following is the stack trace.
> 
> [   22.702034] netconsole-setup: Test log message to verify netconsole
> configuration.
> [  134.949923] Oops: general protection fault, probably for
> non-canonical address 0x761acac3b7d57b17: 0000 [#1] PREEMPT SMP PTI
> [  134.950621] CPU: 35 UID: 0 PID: 833 Comm: md300_raid5 Kdump: loaded
> Not tainted 6.11.5-storage
> #6.11.5-1+feature+v6.11+20241113.0858+ed8e31b5~deb12
> [  134.951414] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/2021
> [  134.951814] RIP: 0010:rnbd_dev_bi_end_io+0x1b/0x70 [rnbd_server]
> [  134.952185] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
> 0f 1e fa 0f 1f 44 00 00 55 b8 ff ff ff ff 53 48 8b 6f 40 48 89 fb 48
> 8b 55 08 <f0
> [  134.953311] RSP: 0018:ffffb5b94818fb80 EFLAGS: 00010282
> [  134.953624] RAX: 00000000ffffffff RBX: ffff96e6a1d8aa80 RCX: 00000000802a0016
> [  134.954051] RDX: 761acac3b7d57aa7 RSI: 00000000802a0016 RDI: ffff96e6a1d8aa80
> [  134.954476] RBP: ffff96d705c7d8b0 R08: 0000000000000001 R09: 0000000000000001
> [  134.954901] R10: ffff96d730c59d40 R11: 0000000000000000 R12: ffff96d71b3e5000
> [  134.955326] R13: 0000000000000000 R14: ffff96d730c589d8 R15: ffff96d715882e20
> [  134.955752] FS:  0000000000000000(0000) GS:ffff96f63fbc0000(0000)
> knlGS:0000000000000000
> [  134.956237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  134.956578] CR2: 00007fb5962bbe00 CR3: 000000060882c006 CR4: 00000000001706f0
> [  134.957003] Call Trace:
> [  134.957151]  <TASK
> [  134.957274]  ? die_addr+0x36/0x90
> [  134.957480]  ? exc_general_protection+0x1bc/0x3c0
> [  134.957762]  ? asm_exc_general_protection+0x26/0x30
> [  134.958054]  ? rnbd_dev_bi_end_io+0x1b/0x70 [rnbd_server]
> [  134.958377]  md_end_clone_io+0x42/0xa0
> [  134.958602]  md_end_clone_io+0x42/0xa0
> [  134.958826]  handle_stripe_clean_event+0x240/0x430 [raid456]
> [  134.959168]  handle_stripe+0x783/0x1cb0 [raid456]
> [  134.959452]  ? common_interrupt+0x13/0xa0
> [  134.959690]  handle_active_stripes.constprop.0+0x353/0x540 [raid456]
> [  134.960073]  raid5d+0x41a/0x600 [raid456]
> 
> Maybe the same BIO handled twice - and so the clone (for IO-acct) got
> put again (somehow) into md_account_bio()?

I think the last change is reasonable, the BUG_ON() can be avoided and
bio chain won't be messed up.

The problem here looks like bio reference is not correct, I'll need some
time to sort that out, too complicated in raid5.

Meanwhile, can you try the following workround? I just revert the
changes that I think introduce this problem, noted that performace can
be degraded.

Thanks,
Kuai

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f09e7677ee9f..07aa453bdb2f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5874,17 +5874,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
                         wait_on_bit(&dev->flags, R5_Overlap, 
TASK_UNINTERRUPTIBLE);
                         return 0;
                 }
-       }
-
-       for (dd_idx = 0; dd_idx < sh->disks; dd_idx++) {
-               struct r5dev *dev = &sh->dev[dd_idx];
-
-               if (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
-                       continue;
-
-               if (dev->sector < ctx->first_sector ||
-                   dev->sector >= ctx->last_sector)
-                       continue;

                 __add_stripe_bio(sh, bi, dd_idx, forwrite, previous);
                 clear_bit((dev->sector - ctx->first_sector) >>

