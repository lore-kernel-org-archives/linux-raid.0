Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1534810A12
	for <linux-raid@vger.kernel.org>; Sat, 20 Apr 2024 06:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713593412; cv=none; b=KLQRqqDKj7wXe2BeuJCaxpkPS95dJz49/s2jti+FLsTkyN9IkJCHjlxMGiG3xrBR1bjl8Y5hNhjZCc25XDnDXaPIzpFk9oX7zjvaCJIE5HjBOPvD7qmwd+imqetP2HAc1ahFqmEKAZwGdUbXWfT1UbRUKjWtNwuf5VWNR0EcYHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713593412; c=relaxed/simple;
	bh=XhNkzvWCvgiEdDy0pjQQx1mqWyvnpRA/c5bzk9qVRCA=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DuLhPTylUd5cNdbdHfoATP7YBB/TBaWQz1vXPoj85CEUREofra767DAlcK2p1zCrb8YBRUgzq5VSqo3tsffAJxABryf2Bbec9XnRwByhkyZvJEREgNB+QIlx7mhjFTqSPF4FRPKdCniv6zBsm+fBhGkdP9VNq2obN3JJQE5gXag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VM1M65GLyz4f3jjk
	for <linux-raid@vger.kernel.org>; Sat, 20 Apr 2024 14:09:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 763791A0D08
	for <linux-raid@vger.kernel.org>; Sat, 20 Apr 2024 14:09:59 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn9g41XCNm1prYKQ--.43166S3;
	Sat, 20 Apr 2024 14:09:59 +0800 (CST)
Subject: Re: regression: CPU soft lockup with raid10: check slab-out-of-bounds
 in md_bitmap_get_counter
To: Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
 Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
 song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a86ab399-ab3c-946c-0c2d-0f38bbde382a@huaweicloud.com>
Date: Sat, 20 Apr 2024 14:09:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn9g41XCNm1prYKQ--.43166S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr45KryrCw4xur4kZrW8WFg_yoW7uryxpr
	47KryxGr48Gry8Xr47Ar1UJr10qrnrAF1UCFn5u348uFW5X39xJ345CF1UKF1DJrykuFya
	vw45Aw1Fka45ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/04/20 3:49, Nigel Croxon 写道:
> There is a problem with this commit, it causes a CPU#x soft lockup
> 
> commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5
> Author: Li Nan <linan122@huawei.com>
> Date:   Mon May 15 21:48:05 2023 +0800
> md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
> 

Did you found this commit by bisect?

> Message from syslogd@rhel9 at Apr 19 14:14:55 ...
>   kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s! 
> [mdX_resync:6976]
> 
> dmesg:
> 
> [  104.245585] CPU: 7 PID: 3588 Comm: mdX_resync Kdump: loaded Not 
> tainted 6.9.0-rc4-next-20240419 #1
> [  104.245588] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
> 1.16.2-1.fc38 04/01/2014
> [  104.245590] RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
> [  104.245598] Code: 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 
> 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 90 90 90 fb 65 ff 0d 95 9f 75 
> 76 <74> 05 c3 cc cc cc cc 0f 1f 44 00 00 c3 cc cc cc cc cc cc cc cc cc
> [  104.245601] RSP: 0018:ffffb2d74a81bbf8 EFLAGS: 00000246
> [  104.245603] RAX: 0000000000000000 RBX: 0000000001000000 RCX: 
> 000000000000000c
> [  104.245604] RDX: 0000000000000000 RSI: 0000000001000000 RDI: 
> ffff926160ccd200
> [  104.245606] RBP: ffffb2d74a81bcd0 R08: 0000000000000013 R09: 
> 0000000000000000
> [  104.245607] R10: 0000000000000000 R11: ffffb2d74a81bad8 R12: 
> 0000000000000000
> [  104.245608] R13: 0000000000000000 R14: ffff926160ccd200 R15: 
> ffff926151019000
> [  104.245611] FS:  0000000000000000(0000) GS:ffff9273f9580000(0000) 
> knlGS:0000000000000000
> [  104.245613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  104.245614] CR2: 00007f23774d2584 CR3: 0000000104098003 CR4: 
> 0000000000370ef0
> [  104.245616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [  104.245617] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
> 0000000000000400
> [  104.245618] Call Trace:
> [  104.245620]  <IRQ>
> [  104.245623]  ? watchdog_timer_fn+0x1e3/0x260
> [  104.245630]  ? __pfx_watchdog_timer_fn+0x10/0x10
> [  104.245634]  ? __hrtimer_run_queues+0x112/0x2a0
> [  104.245638]  ? hrtimer_interrupt+0xff/0x240
> [  104.245640]  ? sched_clock+0xc/0x30
> [  104.245644]  ? __sysvec_apic_timer_interrupt+0x54/0x140
> [  104.245649]  ? sysvec_apic_timer_interrupt+0x6c/0x90
> [  104.245652]  </IRQ>
> [  104.245653]  <TASK>
> [  104.245654]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> [  104.245659]  ? _raw_spin_unlock_irq+0x13/0x30
> [  104.245661]  md_bitmap_start_sync+0x6b/0xf0

Looks like you trigger the condition from md_bitmap_get_counter():

page >= bitmap->pages

by the command lvextend + lvchange --syncaction. And because
md_bitmap_get_counter() return NULL with sync_blocks set to 0,
raid10_sync_request() can't make progress and stuck in a dead loop.

There are two problems here:

1) Looks like lvextend doesn't resize the bitmap, I don't know about
lvextend but this can explain why the condition can be triggered.

2) raid10_sync_request() should handle this case, by:
  a) keeping syncing ranges beyond bitmap;
  b) skip syncing reanges beyond bitmap;

Following is a patch to fix this problem by 2-b, which is the same
before 301867b1c16805aebbc306aafa6ecdc68b73c7e5. However, 1) still need
to be fixed, otherwise, data beyond bitmap ranges will never sync.

Nigel, can you give this patch a test?

Thanks,
Kuai

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9672f75c3050..26e40991369a 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1424,15 +1424,17 @@ __acquires(bitmap->lock)
         sector_t chunk = offset >> bitmap->chunkshift;
         unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
         unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << 
COUNTER_BYTE_SHIFT;
-       sector_t csize;
+       sector_t csize = ((sector_t)1) << bitmap->chunkshift;
         int err;

+
         if (page >= bitmap->pages) {
                 /*
                  * This can happen if bitmap_start_sync goes beyond
                  * End-of-device while looking for a whole page or
                  * user set a huge number to sysfs bitmap_set_bits.
                  */
+               *blocks = csize - (offset & (csize - 1));
                 return NULL;
         }
         err = md_bitmap_checkpage(bitmap, page, create, 0);
@@ -1441,8 +1443,7 @@ __acquires(bitmap->lock)
             bitmap->bp[page].map == NULL)
                 csize = ((sector_t)1) << (bitmap->chunkshift +
                                           PAGE_COUNTER_SHIFT);
-       else
-               csize = ((sector_t)1) << bitmap->chunkshift;
+
         *blocks = csize - (offset & (csize - 1));

         if (err < 0)

> [  104.245668]  raid10_sync_request+0x25c/0x1b40 [raid10]
> [  104.245676]  ? is_mddev_idle+0x132/0x150
> [  104.245680]  md_do_sync+0x64b/0x1020
> [  104.245683]  ? __pfx_autoremove_wake_function+0x10/0x10
> [  104.245690]  md_thread+0xa7/0x170
> [  104.245693]  ? __pfx_md_thread+0x10/0x10
> [  104.245696]  kthread+0xcf/0x100
> [  104.245700]  ? __pfx_kthread+0x10/0x10
> [  104.245704]  ret_from_fork+0x30/0x50
> [  104.245707]  ? __pfx_kthread+0x10/0x10
> [  104.245710]  ret_from_fork_asm+0x1a/0x30
> [  104.245714]  </TASK>
> 
> When you run the reproducer script below...
> 
> #!/bin/sh
> vg=t
> lv=t
> devs="/dev/sd[c-j]"
> sz=3G
> isz=2G
> path=/dev/$vg/$lv
> mnt=/mnt/$lv
> 
> vgcreate -y $vg $devs
> lvcreate --yes --nosync --type raid10 -i 2 -n $lv -L $sz $vg
> 
> mkfs.xfs $path
> mkdir -p $mnt
> mount $path $mnt
> df -h
> 
> for i in {1..10}
> do
>      lvextend -y -L +$isz -r $path
>      lvs
> done
> 
> lvs -a -o +devices
> lvchange --syncaction check $path
> #lvs -ovgname,lvname,copypercent t/t         <-- this cmd to watch
> 
> 
> .
> 

