Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AB4E55F
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 06:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714370824; cv=none; b=H/A7P0VwtKei0KB+5kdgpePYJch+V2uY7yIFU6AMvGm+B+mMxZBDbAjH5Mc1hE7clNvIcMlPXkCQR6RqHt6ZYPQFQ765pZw2lnXkB7jRjPweZ/+jzRMThMXmmOm3vRmuaNV8TkKPCyfuNpvsgCRgb6ILOB6sAx3ehO9KHEZ44Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714370824; c=relaxed/simple;
	bh=N+jbT5M1YxITwMyIhie2YPO8pDbYym73cCyvY34QdN4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=luvRF6NiF7wo7Oid+nD8mA2pf2BhQT+Z7UjFZjz1C/1Wenk8Y4H7DrdNPW9VNDfNLTdlFgoflzUc7HCl1RXRrGi3FiIA2rpMQwe5Ylj/GFZNFKzkmOGJgZoPjZv+dJMqLcjXOLH0rnJpCM+NglxNIv/LuBidFk3h8H1WA5D2/Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VSXnH6yL9zXnR8;
	Mon, 29 Apr 2024 14:03:15 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id A496A180AA0;
	Mon, 29 Apr 2024 14:06:52 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Apr 2024 14:06:52 +0800
Subject: Re: General Protection Fault in md raid10
To: Colgate Minuette <rabbit@minuette.net>, <linux-raid@vger.kernel.org>, Yu
 Kuai <yukuai1@huaweicloud.com>
CC: "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <8365123.T7Z3S40VBb@sparkler> <4561772.LvFx2qVVIh@sparkler>
 <8e23d023-bac2-e5a4-15a0-1636099b0cab@huaweicloud.com>
 <12425258.O9o76ZdvQC@sparkler>
From: Yu Kuai <yukuai3@huawei.com>
Message-ID: <90f685e1-9c55-d9c5-79d4-9ef354b3b703@huawei.com>
Date: Mon, 29 Apr 2024 14:06:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <12425258.O9o76ZdvQC@sparkler>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Hi,

在 2024/04/29 12:30, Colgate Minuette 写道:
> On Sunday, April 28, 2024 8:12:01 PM PDT Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/04/29 10:18, Colgate Minuette 写道:
>>> On Sunday, April 28, 2024 6:02:30 PM PDT Yu Kuai wrote:
>>>> Hi,
>>>>
>>>> 在 2024/04/29 3:41, Colgate Minuette 写道:
>>>>> Hello all,
>>>>>
>>>>> I am trying to set up an md raid-10 array spanning 8 disks using the
>>>>> following command
>>>>>
>>>>>> mdadm --create /dev/md64 --level=10 --layout=o2 -n 8 /dev/sd[efghijkl]1
>>>>>
>>>>> The raid is created successfully, but the moment that the newly created
>>>>> raid starts initial sync, a general protection fault is issued. This
>>>>> fault happens on kernels 6.1.85, 6.6.26, and 6.8.5 using mdadm version
>>>>> 4.3. The raid is then completely unusable. After the fault, if I try to
>>>>> stop the raid using>
>>>>>
>>>>>> mdadm --stop /dev/md64
>>>>>
>>>>> mdadm hangs indefinitely.
>>>>>
>>>>> I have tried raid levels 0 and 6, and both work as expected without any
>>>>> errors on these same 8 drives. I also have a working md raid-10 on the
>>>>> system already with 4 disks(not related to this 8 disk array).
>>>>>
>>>>> Other things I have tried include trying to create/sync the raid from a
>>>>> debian live environment, and using near/far/offset layouts, but both
>>>>> methods came back with the same protection fault. Also ran a memory test
>>>>> on the computer, but did not have any errors after 10 passes.
>>>>>
>>>>> Below is the output from the general protection fault. Let me know of
>>>>> anything else to try or log information that would be helpful to
>>>>> diagnose.
>>>>>
>>>>> [   10.965542] md64: detected capacity change from 0 to 120021483520
>>>>> [   10.965593] md: resync of RAID array md64
>>>>> [   10.999289] general protection fault, probably for non-canonical
>>>>> address
>>>>> 0xd071e7fff89be: 0000 [#1] PREEMPT SMP NOPTI
>>>>> [   11.000842] CPU: 4 PID: 912 Comm: md64_raid10 Not tainted
>>>>> 6.1.85-1-MANJARO #1 44ae6c380f5656fa036749a28fdade8f34f2f9ce
>>>>> [   11.001192] Hardware name: ASUS System Product Name/TUF GAMING
>>>>> X670E-PLUS WIFI, BIOS 1618 05/18/2023
>>>>> [   11.001482] RIP: 0010:bio_copy_data_iter+0x187/0x260
>>>>> [   11.001756] Code: 29 f1 4c 29 f6 48 c1 f9 06 48 c1 fe 06 48 c1 e1 0c
>>>>> 48
>>>>> c1 e6 0c 48 01 e9 48 01 ee 48 01 d9 4c 01 d6 83 fa 08 0f 82 b0 fe ff ff
>>>>> <48> 8b 06 48 89 01 89 d0 48 8b 7c 06 f8 48 89 7c 01 f8 48 8d 79 08
>>>>> [   11.002045] RSP: 0018:ffffa838124ffd28 EFLAGS: 00010216
>>>>> [   11.002336] RAX: ffffca0a84195a80 RBX: 0000000000000000 RCX:
>>>>> ffff89be8656a000 [   11.002628] RDX: 0000000000000642 RSI:
>>>>> 000d071e7fff89be RDI: ffff89beb4039df8 [   11.002922] RBP:
>>>>> ffff89bd80000000 R08: ffffa838124ffd74 R09: ffffa838124ffd60 [
>>>>> 11.003217] R10: 00000000000009be R11: 0000000000002000 R12:
>>>>> ffff89be8bbff400 [   11.003522] R13: ffff89beb4039a00 R14:
>>>>> ffffca0a80000000 R15: 0000000000001000 [   11.003825] FS:
>>>>> 0000000000000000(0000) GS:ffff89c5b8700000(0000) knlGS: 0000000000000000
>>>>> [   11.004126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> [   11.004429] CR2: 0000563308baac38 CR3: 000000012e900000 CR4:
>>>>> 0000000000750ee0
>>>>> [   11.004737] PKRU: 55555554
>>>>> [   11.005040] Call Trace:
>>>>> [   11.005342]  <TASK>
>>>>> [   11.005645]  ? __die_body.cold+0x1a/0x1f
>>>>> [   11.005951]  ? die_addr+0x3c/0x60
>>>>> [   11.006256]  ? exc_general_protection+0x1c1/0x380
>>>>> [   11.006562]  ? asm_exc_general_protection+0x26/0x30
>>>>> [   11.006865]  ? bio_copy_data_iter+0x187/0x260
>>>>> [   11.007169]  bio_copy_data+0x5c/0x80
>>>>> [   11.007474]  raid10d+0xcad/0x1c00 [raid10
>>>>> 1721e6c9d579361bf112b0ce400eec9240452da1]
>>>>
>>>> Can you try to use addr2line or gdb to locate which this code line
>>>> is this correspond to?
>>>>
>>>> I never see problem like this before... And it'll be greate if you
>>>> can bisect this since you can reporduce this problem easily.
>>>>
>>>> Thanks,
>>>> Kuai
>>>
>>> Can you provide guidance on how to do this? I haven't ever debugged kernel
>>> code before. I'm assuming this would be in the raid10.ko module, but don't
>>> know where to go from there.
>>
>> For addr2line, you can gdb raid10.ko, then:
>>
>> list *(raid10d+0xcad)
>>
>> and gdb vmlinux:
>>
>> list *(bio_copy_data_iter+0x187)
>>
>> For git bisect, you must find a good kernel version, then:
>>
>> git bisect start
>> git bisect bad v6.1
>> git bisect good xxx
>>
>> Then git will show you how many steps are needed and choose a commit for
>> you, after compile and test the kernel:
>>
>> git bisect good/bad
>>
>> Then git will do the bisection based on your test result, at last
>> you will get a blamed commit.
>>
>> Thanks,
>> Kuai
>>
> 
> I don't know of any kernel that is working for this, every setup I've tried
> has had the same issue.

This's really wried, is this the first time you ever using raid10? Did
you try some older kernel like v5.10 or v4.19?

> 
> (gdb) list *(raid10d+0xa52)
> 0x6692 is in raid10d (drivers/md/raid10.c:2480).
> 2475    in drivers/md/raid10.c
> 
> (gdb) list *(bio_copy_data_iter+0x187)
> 0xffffffff814c3a77 is in bio_copy_data_iter (block/bio.c:1357).
> 1352    in block/bio.c

Thanks for this, I'll try to take a look at related code.

Kuai

> 
> uname -a
> Linux debian 6.1.0-18-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.76-1
> (2024-02-01) x86_64 GNU/Linux
> 
> -Colgate
> 
> 
> 
> .
> 
