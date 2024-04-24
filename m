Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84348157E6C
	for <linux-raid@vger.kernel.org>; Wed, 24 Apr 2024 06:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713941838; cv=none; b=ZJSBrAMFuetKkY2EDPnhAJnPVv3Hm9iwZLf07KJaQ+JrH14JCvC/XtqSMDECF5HSBYEJlRy6vbzEFcUjUn2rX9r1mVbSktc4oNGB1LNMn0Q3KBk6ZxhQKCM+O4X1zlP1t/Z2SeNOWdcsH/jis6b8wJ1K4dzrQ+VusL7qC/3U9RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713941838; c=relaxed/simple;
	bh=evqMq3oiQDgBRYC+R5tRtBN+zAszN83nHRG0+3X2OSI=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nrBfle8E+To3CjbI9ExeAS8NV3/XUgN3NnFLYpbwx5GuYpWBU+oLMb6WybuZonvq47S4PRfRqseV69G5/1KeybOJyJ9CbGNQQ01omuE2zM7kusUDow3/9mooPR3L6cNedyDWmSymi0+sjO9qTfznwqkLWAxPABt2RBMCoTjXr0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VPVCf5hZnz4f3nJh
	for <linux-raid@vger.kernel.org>; Wed, 24 Apr 2024 14:57:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 03B141A1098
	for <linux-raid@vger.kernel.org>; Wed, 24 Apr 2024 14:57:12 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBFGrShmimJEKw--.5182S3;
	Wed, 24 Apr 2024 14:57:11 +0800 (CST)
Subject: Re: regression: CPU soft lockup with raid10: check slab-out-of-bounds
 in md_bitmap_get_counter
To: Nigel Croxon <ncroxon@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 linux-raid@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Xiao Ni <xni@redhat.com>, song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
 <a86ab399-ab3c-946c-0c2d-0f38bbde382a@huaweicloud.com>
 <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <75f30327-67b5-eca5-5cc8-f821ff0aeee7@huaweicloud.com>
Date: Wed, 24 Apr 2024 14:57:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBFGrShmimJEKw--.5182S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Ar45AF43ur17tF17WrW7Jwb_yoW3AFWkpr
	1ktFyUGrWrGr18Xr12yr1DJryUtr1DA3WDCr1kua48uF47JwnIq34UWF1qgF1DJr48CF12
	qw15Jw1S9Fy5Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Nigel

在 2024/04/21 20:30, Nigel Croxon 写道:
> 
> On 4/20/24 2:09 AM, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/04/20 3:49, Nigel Croxon 写道:
>>> There is a problem with this commit, it causes a CPU#x soft lockup
>>>
>>> commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5
>>> Author: Li Nan <linan122@huawei.com>
>>> Date:   Mon May 15 21:48:05 2023 +0800
>>> md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
>>>
>>
>> Did you found this commit by bisect?
>>
> Yes, found this issue by bisecting...
> 
>>> Message from syslogd@rhel9 at Apr 19 14:14:55 ...
>>>   kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s! 
>>> [mdX_resync:6976]
>>>
>>> dmesg:
>>>
>>> [  104.245585] CPU: 7 PID: 3588 Comm: mdX_resync Kdump: loaded Not 
>>> tainted 6.9.0-rc4-next-20240419 #1
>>> [  104.245588] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), 
>>> BIOS 1.16.2-1.fc38 04/01/2014
>>> [  104.245590] RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
>>> [  104.245598] Code: 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 
>>> 90 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 90 90 90 fb 65 ff 0d 95 
>>> 9f 75 76 <74> 05 c3 cc cc cc cc 0f 1f 44 00 00 c3 cc cc cc cc cc cc 
>>> cc cc cc
>>> [  104.245601] RSP: 0018:ffffb2d74a81bbf8 EFLAGS: 00000246
>>> [  104.245603] RAX: 0000000000000000 RBX: 0000000001000000 RCX: 
>>> 000000000000000c
>>> [  104.245604] RDX: 0000000000000000 RSI: 0000000001000000 RDI: 
>>> ffff926160ccd200
>>> [  104.245606] RBP: ffffb2d74a81bcd0 R08: 0000000000000013 R09: 
>>> 0000000000000000
>>> [  104.245607] R10: 0000000000000000 R11: ffffb2d74a81bad8 R12: 
>>> 0000000000000000
>>> [  104.245608] R13: 0000000000000000 R14: ffff926160ccd200 R15: 
>>> ffff926151019000
>>> [  104.245611] FS:  0000000000000000(0000) GS:ffff9273f9580000(0000) 
>>> knlGS:0000000000000000
>>> [  104.245613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  104.245614] CR2: 00007f23774d2584 CR3: 0000000104098003 CR4: 
>>> 0000000000370ef0
>>> [  104.245616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>>> 0000000000000000
>>> [  104.245617] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
>>> 0000000000000400
>>> [  104.245618] Call Trace:
>>> [  104.245620]  <IRQ>
>>> [  104.245623]  ? watchdog_timer_fn+0x1e3/0x260
>>> [  104.245630]  ? __pfx_watchdog_timer_fn+0x10/0x10
>>> [  104.245634]  ? __hrtimer_run_queues+0x112/0x2a0
>>> [  104.245638]  ? hrtimer_interrupt+0xff/0x240
>>> [  104.245640]  ? sched_clock+0xc/0x30
>>> [  104.245644]  ? __sysvec_apic_timer_interrupt+0x54/0x140
>>> [  104.245649]  ? sysvec_apic_timer_interrupt+0x6c/0x90
>>> [  104.245652]  </IRQ>
>>> [  104.245653]  <TASK>
>>> [  104.245654]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>> [  104.245659]  ? _raw_spin_unlock_irq+0x13/0x30
>>> [  104.245661]  md_bitmap_start_sync+0x6b/0xf0

Can you give the following patch a test as well? I believe this is
the root cause why page > bitmap->pages, dm-raid is using the wrong
bitmap size.

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index abe88d1e6735..d9c65ef9c9fb 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4052,7 +4052,8 @@ static int raid_preresume(struct dm_target *ti)
                mddev->bitmap_info.chunksize != 
to_bytes(rs->requested_bitmap_chunk_sectors)))) {
                 int chunksize = 
to_bytes(rs->requested_bitmap_chunk_sectors) ?: 
mddev->bitmap_info.chunksize;

-               r = md_bitmap_resize(mddev->bitmap, mddev->dev_sectors, 
chunksize, 0);
+               r = md_bitmap_resize(mddev->bitmap, 
mddev->resync_max_sectors,
+                                    chunksize, 0);
                 if (r)
                         DMERR("Failed to resize bitmap");
         }

Thanks,
Kuai
>>
>> Looks like you trigger the condition from md_bitmap_get_counter():
>>
>> page >= bitmap->pages
>>
>> by the command lvextend + lvchange --syncaction. And because
>> md_bitmap_get_counter() return NULL with sync_blocks set to 0,
>> raid10_sync_request() can't make progress and stuck in a dead loop.
>>
>> There are two problems here:
>>
>> 1) Looks like lvextend doesn't resize the bitmap, I don't know about
>> lvextend but this can explain why the condition can be triggered.
>>
>> 2) raid10_sync_request() should handle this case, by:
>>  a) keeping syncing ranges beyond bitmap;
>>  b) skip syncing reanges beyond bitmap;
>>
>> Following is a patch to fix this problem by 2-b, which is the same
>> before 301867b1c16805aebbc306aafa6ecdc68b73c7e5. However, 1) still need
>> to be fixed, otherwise, data beyond bitmap ranges will never sync.
>>
>> Nigel, can you give this patch a test?
>>
> Hello Kuai,
> 
> I tested your patch under this failing environment and it works.
> 
> -Nigel
> 
>> Thanks,
>> Kuai
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 9672f75c3050..26e40991369a 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -1424,15 +1424,17 @@ __acquires(bitmap->lock)
>>         sector_t chunk = offset >> bitmap->chunkshift;
>>         unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
>>         unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << 
>> COUNTER_BYTE_SHIFT;
>> -       sector_t csize;
>> +       sector_t csize = ((sector_t)1) << bitmap->chunkshift;
>>         int err;
>>
>> +
>>         if (page >= bitmap->pages) {
>>                 /*
>>                  * This can happen if bitmap_start_sync goes beyond
>>                  * End-of-device while looking for a whole page or
>>                  * user set a huge number to sysfs bitmap_set_bits.
>>                  */
>> +               *blocks = csize - (offset & (csize - 1));
>>                 return NULL;
>>         }
>>         err = md_bitmap_checkpage(bitmap, page, create, 0);
>> @@ -1441,8 +1443,7 @@ __acquires(bitmap->lock)
>>             bitmap->bp[page].map == NULL)
>>                 csize = ((sector_t)1) << (bitmap->chunkshift +
>>                                           PAGE_COUNTER_SHIFT);
>> -       else
>> -               csize = ((sector_t)1) << bitmap->chunkshift;
>> +
>>         *blocks = csize - (offset & (csize - 1));
>>
>>         if (err < 0)
>>
>>> [  104.245668] raid10_sync_request+0x25c/0x1b40 [raid10]
>>> [  104.245676]  ? is_mddev_idle+0x132/0x150
>>> [  104.245680]  md_do_sync+0x64b/0x1020
>>> [  104.245683]  ? __pfx_autoremove_wake_function+0x10/0x10
>>> [  104.245690]  md_thread+0xa7/0x170
>>> [  104.245693]  ? __pfx_md_thread+0x10/0x10
>>> [  104.245696]  kthread+0xcf/0x100
>>> [  104.245700]  ? __pfx_kthread+0x10/0x10
>>> [  104.245704]  ret_from_fork+0x30/0x50
>>> [  104.245707]  ? __pfx_kthread+0x10/0x10
>>> [  104.245710]  ret_from_fork_asm+0x1a/0x30
>>> [  104.245714]  </TASK>
>>>
>>> When you run the reproducer script below...
>>>
>>> #!/bin/sh
>>> vg=t
>>> lv=t
>>> devs="/dev/sd[c-j]"
>>> sz=3G
>>> isz=2G
>>> path=/dev/$vg/$lv
>>> mnt=/mnt/$lv
>>>
>>> vgcreate -y $vg $devs
>>> lvcreate --yes --nosync --type raid10 -i 2 -n $lv -L $sz $vg
>>>
>>> mkfs.xfs $path
>>> mkdir -p $mnt
>>> mount $path $mnt
>>> df -h
>>>
>>> for i in {1..10}
>>> do
>>>      lvextend -y -L +$isz -r $path
>>>      lvs
>>> done
>>>
>>> lvs -a -o +devices
>>> lvchange --syncaction check $path
>>> #lvs -ovgname,lvname,copypercent t/t         <-- this cmd to watch
>>>
>>>
>>> .
>>>
>>
>>
> 
> .
> 

