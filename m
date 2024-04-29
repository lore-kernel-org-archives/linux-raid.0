Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D8E7490
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 03:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714360335; cv=none; b=G/6kdvyU6v2vYVKMymlaaj0jVPPy6tV9iRnm4als/su2O6g2ENRiKADbelzY0UTLrTw37BY9aIFXBKUu8Mn/Px6o/sDlNdwCD6UeJTKOKp0d+qkVhCAaia6Aq+cWm1vHw8YwjVIXBdWXoG5F3f8rjyQlapGW00VPDCxuspN9NGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714360335; c=relaxed/simple;
	bh=tDL9ZzuKIHC4A8mUb8GOmTsiEgOE7w7hQBXLZzg//eQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CXU1M12/NDypzRPXxQk7rsC8LqjUVhpMG5RoraTILxwNS2f2o94xJMLrGeeTHsn61jUuqoFxN8+Ykw7P8arpeyV4IME3a1e28r5ypT1dxvzLStlPrOvng85qPFQoWWdzd6vwjMGJ6urUfzOfGiPBO9V9ttr5ULcazPA/sORyPlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VSSzb6CdXz4f3kjD
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 11:11:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A68321A0175
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 11:12:03 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxACEC9mTjv9LA--.51176S3;
	Mon, 29 Apr 2024 11:12:03 +0800 (CST)
Subject: Re: General Protection Fault in md raid10
To: Colgate Minuette <rabbit@minuette.net>, linux-raid@vger.kernel.org,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <8365123.T7Z3S40VBb@sparkler>
 <208eb375-4859-3b32-59d6-7243f9892f1e@huaweicloud.com>
 <4561772.LvFx2qVVIh@sparkler>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8e23d023-bac2-e5a4-15a0-1636099b0cab@huaweicloud.com>
Date: Mon, 29 Apr 2024 11:12:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4561772.LvFx2qVVIh@sparkler>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxACEC9mTjv9LA--.51176S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw43Wr4DZFWUXF1DAF1UWrg_yoWrZrWUpF
	W7tF17Crs5twn7Jws2qr1kC3W8trsrZFWUWr4UXr1vy3Z8WF10qry8trWjkFy7Wws8A342
	vF98tas0qr90yaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
	6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxv
	r21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaUUUUU
	U==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/04/29 10:18, Colgate Minuette 写道:
> On Sunday, April 28, 2024 6:02:30 PM PDT Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/04/29 3:41, Colgate Minuette 写道:
>>> Hello all,
>>>
>>> I am trying to set up an md raid-10 array spanning 8 disks using the
>>> following command
>>>
>>>> mdadm --create /dev/md64 --level=10 --layout=o2 -n 8 /dev/sd[efghijkl]1
>>>
>>> The raid is created successfully, but the moment that the newly created
>>> raid starts initial sync, a general protection fault is issued. This
>>> fault happens on kernels 6.1.85, 6.6.26, and 6.8.5 using mdadm version
>>> 4.3. The raid is then completely unusable. After the fault, if I try to
>>> stop the raid using>
>>>> mdadm --stop /dev/md64
>>>
>>> mdadm hangs indefinitely.
>>>
>>> I have tried raid levels 0 and 6, and both work as expected without any
>>> errors on these same 8 drives. I also have a working md raid-10 on the
>>> system already with 4 disks(not related to this 8 disk array).
>>>
>>> Other things I have tried include trying to create/sync the raid from a
>>> debian live environment, and using near/far/offset layouts, but both
>>> methods came back with the same protection fault. Also ran a memory test
>>> on the computer, but did not have any errors after 10 passes.
>>>
>>> Below is the output from the general protection fault. Let me know of
>>> anything else to try or log information that would be helpful to
>>> diagnose.
>>>
>>> [   10.965542] md64: detected capacity change from 0 to 120021483520
>>> [   10.965593] md: resync of RAID array md64
>>> [   10.999289] general protection fault, probably for non-canonical
>>> address
>>> 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
>>> [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted
>>> 6.1.85-1-MANJARO #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
>>> [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING
>>> X670E-PLUS WIFI, BIOS 1618 05/18/2023
>>> [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
>>> [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1 0c 48
>>> c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff ff
>>> <48> 8b 06 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08
>>> [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
>>> [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX:
>>> ffff89be8656a000 [   11.002628] RDX: 0000000000000642 RSI:
>>> 000d071e7fff89be RDI: ffff89beb4039df8 [   11.002922] RBP:
>>> ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60 [
>>> 11.003217] R10: 00000000000009be R11: 0000000000002000 R12:
>>> ffff89be8bbff400 [   11.003522] R13: ffff89beb4039a00 R14:
>>> ffffca0a80000000 R15: 0000000000001000 [   11.003825] FS:
>>> 0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS: 0000000000000000
>>> [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   11.004429] CR2: 0000563308baac38 CR3: 000000012e900000 CR4:
>>> 0000000000750ee0
>>> [   11.004737] PKRU: 55555554
>>> [   11.005040] Call Trace:
>>> [   11.005342]  <TASK>
>>> [   11.005645]  ? __die_body.cold+0x1a/0x1f
>>> [   11.005951]  ? die_addr+0x3c/0x60
>>> [   11.006256]  ? exc_general_protection+0x1c1/0x380
>>> [   11.006562]  ? asm_exc_general_protection+0x26/0x30
>>> [   11.006865]  ? bio_copy_data_iter+0x187/0x260
>>> [   11.007169]  bio_copy_data+0x5c/0x80
>>> [   11.007474]  raid10d+0xcad/0x1c00 [raid10
>>> 1721e6c9d579361bf112b0ce400eec9240452da1]
>>
>> Can you try to use addr2line or gdb to locate which this code line
>> is this correspond to?
>>
>> I never see problem like this before... And it'll be greate if you
>> can bisect this since you can reporduce this problem easily.
>>
>> Thanks,
>> Kuai
>>
> 
> Can you provide guidance on how to do this? I haven't ever debugged kernel
> code before. I'm assuming this would be in the raid10.ko module, but don't
> know where to go from there.

For addr2line, you can gdb raid10.ko, then:

list *(raid10d+0xcad)

and gdb vmlinux:

list *(bio_copy_data_iter+0x187)

For git bisect, you must find a good kernel version, then:

git bisect start
git bisect bad v6.1
git bisect good xxx

Then git will show you how many steps are needed and choose a commit for
you, after compile and test the kernel:

git bisect good/bad

Then git will do the bisection based on your test result, at last
you will get a blamed commit.

Thanks,
Kuai
> 
> -Colgate
> 
> 
> .
> 

