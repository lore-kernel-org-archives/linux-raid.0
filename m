Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DA31662F6
	for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 17:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737652150; cv=none; b=q1ItKhfyzMLjMtX8a6e3OGFfe0mQFnCS8rTqpCpE7FZBms1haGdkFo5jTXstIuJuNWugNEXRZjgYQ8ZuzDnbQMOD/4DjSMGzrASpztM+tRbde+onCjz3MSKo40avb+QcrWhE0xbVq58lFDkiLygDd+IGmuy2o2nsIQDptMvngJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737652150; c=relaxed/simple;
	bh=7vSMNbGsM5mTdzUc1kRDcLoUlKiJolA/SMShEao/nk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pmMbtr/jGJYLSPV2y+CIncegJ18OO+oaTu5MnpT4JWMtgXe0KmtE02/fYmAKE7Y5Rh9KqM2rrtfywPggyaHzhdM47p+feRgdC9odBLJcjZMisHigMQElOir8g38Luoh7CovlCl/nXG1B82TSJGQZSURhXawZB75sCDpc5ArNvm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEgAZgjQ; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEgAZgjQ"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ee709715d9so1840695a91.3
        for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 09:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737652148; x=1738256948; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YnXDPIdnDoH6wl3zff3Sja0h3MRVU8pmspoymPvEZDs=;
        b=EEgAZgjQ2p3NBOmKroHZa5nqM92AzXLLwHB4jFwXmsmDAsc4Awmytc9NPiiudrm+ti
         bUlEWFq0SO74MayhThIapfoVetbNVBc9j3JXPvDXUkjSCTcE4NErYJT4uuNWDnVgkRaZ
         Bgrzw6qawSt0opVfKzWTwwUR5+9mK04YhVp0iF/UextV2N+I+qW1tkvC9ey2Mw6Zaoh2
         d5mZDjjNZJ2jRg7zSIFlCweQh5KYARMqPZIsypz8dPgXBfRcyiEZW2hxFzBySVO8a9FK
         lWH215uhSeyJ+dwNue7+ZODq2/rTvsmZquz4rp73S2Nt3f0HgZ0oLn6EYfAa5tK9nyOQ
         Pjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737652148; x=1738256948;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YnXDPIdnDoH6wl3zff3Sja0h3MRVU8pmspoymPvEZDs=;
        b=eC9rWX+zW/Ymjb/dTdHxUAz4jwUtDFGvKaW5SXPoi6QVOjDpyMfQd6fvUb34GjKb9S
         JxFvQe6VkxGBLrQ9mqplQJMSIZdnfMaYURuKuEhjbuXT2NSSdOvA8K9xjKiB/i1ihwZj
         WdcGWbGRjMF//SwBrVGc8w7PWTxj2DhxRT7HkNy8+MByawUpKqumrXkYmvrIDuXjY7/d
         AYI/tpnIECwN2p/7EAS9lQl/5Rr6mKWFWocKd8j86FAp8HPOSRcfSCQY3ujkG6EhxoF7
         /M9qRC3BOELMOgzL3sa7wUBNNWhgLFBDIb8AhoUyej/+2h3Y6w/YBoaGc5fSu9i6clu+
         59zg==
X-Forwarded-Encrypted: i=1; AJvYcCVQgFtULXbvcYajaYm6ZlgKaPN/rPTp5TG+E9wcR9fc+f78eF+iI0NekBDHDsPVt7Mw3AMMxXifatgi@vger.kernel.org
X-Gm-Message-State: AOJu0YyiuWk2EqAA77quZRWwUybuNg2hSehCJ+4XPYxdUJ51oKpoDk9o
	XgVI6darnChEkRk/xGfZGZ23rQInqDbAvgjWMGAdamQH9B4Vet/T
X-Gm-Gg: ASbGncvbMkx5u3gHJfhNZVcLvlmQJ7cAvMs32T3HWqUfMVYt+qlgkkXnxzjmrXiLXU4
	O16WCQw0vj8DdzRRuZKemy7MiIbwmzXMrGoLSthKkBRLDVO6Xo4o2RPfo6ZofMr/EipqPgEIW0t
	/DuDKLL4BEk3xp+Q/D9wSbY+DyXGxv78swiIEPUfRJRnysKGs/p2XQ5v8RV5ZTT79VBhiR0YZLw
	WudCs2gfemGidXGcexL5LbFDEtP7Lx4Fo3HsjCNQe+T7WFiM0b5fjDyPXg6u6MHQJVgl7LjGrjX
	afW8GraTXwsqChLcVC/1uMwYA1KO97NBgLFKFLJ2r45xgpDvGwR19pQ58MU=
X-Google-Smtp-Source: AGHT+IFyYj1KBjNQjbs0twvT2H/qlv8SCETcXk87GUZ/fx08jHiYh9eqfMtfGURCoenhDami74l8Gw==
X-Received: by 2002:a05:6a00:ad8a:b0:72d:8fa2:99ac with SMTP id d2e1a72fcca58-72daf975d73mr38237883b3a.13.1737652147754;
        Thu, 23 Jan 2025 09:09:07 -0800 (PST)
Received: from [192.168.1.31] (ip68-231-38-120.ph.ph.cox.net. [68.231.38.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a6b3373sm169548b3a.64.2025.01.23.09.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 09:09:07 -0800 (PST)
Message-ID: <eb7a2b91-5eca-45c4-afe1-ed0bf5b7ed09@gmail.com>
Date: Thu, 23 Jan 2025 10:09:06 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Huge lock contention during raid5 build time
To: Anton Gavriliuk <antosha20xx@gmail.com>,
 Paul Menzel <pmenzel@molgen.mpg.de>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org
References: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
 <f33df1a3-c274-4c6a-9359-b0cf0869bee2@molgen.mpg.de>
 <CAAiJnjq6Cw6WfZFKAXA=xW5RjcUb0805=6u7fzM7oyANkzoHCg@mail.gmail.com>
Content-Language: en-US
From: Paul E Luse <paulluselinux@gmail.com>
In-Reply-To: <CAAiJnjq6Cw6WfZFKAXA=xW5RjcUb0805=6u7fzM7oyANkzoHCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 9:56 AM, Anton Gavriliuk wrote:
>> What Linux version do you test with?
> 
> Currently on Centos Stream 10.
> 
> [root@memverge2 ~]# uname -r
> 6.12.0-43.el10.x86_64
> 
> I can switch to the Rocky 9.5 if required.
> 
>> I also remember the patch *[RFC V9] md/bitmap:
>> Optimize lock contention.* [1]. It’d be great if you could help testing.
> 
> Ohh, I have thought that the patch already included in the mdadm
> version (mdadm - v4.4-13-ge0df6c4c - 2025-01-17)
> 
> If the patch is not yet applied to the latest mdadm version, how
> exactly to do that ?


mdadmd is the CLI tool for mdraid, it's not the RAID code.  The issue in 
question and the patch mentioned is against the kernel module.  Last 
time I checked Shushu and his team were re-basing against the version at 
the time as I was helping them with performance testing. I'm fairly 
certain it never made it beyond RFC.

Unfortunately my company has moved some things around and I have very 
limited time to spend here but still have equipment and the ability to 
help with performance testing.

Kuai I thought was working on something as well and a former colleague 
of mine, Artur, had an early patch out to help address this however he 
has also moved on (sadly).

-Paul

> 
> I'm not a Linux developer, but I would be glad to test that patch.
> 
> Anyway, I believe that mdadm should be optimized for the latest PCIe
> gen 5.0 NVMe SSDs.
> 
> Anton
> 
> чт, 23 янв. 2025 г. в 16:49, Paul Menzel <pmenzel@molgen.mpg.de>:
>>
>> Dear Anton,
>>
>>
>> Thank you for your report.
>>
>> Am 23.01.25 um 14:56 schrieb Anton Gavriliuk:
>>
>>> I'm building mdadm raid5 (3+1), based on Intel's NVMe SSD P4600.
>>>
>>> Mdadm next version
>>>
>>> [root@memverge2 ~]# /home/anton/mdadm/mdadm --version
>>> mdadm - v4.4-13-ge0df6c4c - 2025-01-17
>>>
>>> Maximum performance I saw ~1.4 GB/s.
>>>
>>> [root@memverge2 md]# cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
>>>         4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
>>>         [==============>......]  recovery = 71.8% (1122726044/1562681344) finish=5.1min speed=1428101K/sec
>>>         bitmap: 0/12 pages [0KB], 65536KB chunk
>>>
>>> Perf top shows huge spinlock contention
>>>
>>> Samples: 180K of event 'cycles:P', 4000 Hz, Event count (approx.):
>>> 175146370188 lost: 0/0 drop: 0/0
>>> Overhead  Shared Object                             Symbol
>>>     38.23%  [kernel]                                  [k] native_queued_spin_lock_slowpath
>>>      8.33%  [kernel]                                  [k] analyse_stripe
>>>      6.85%  [kernel]                                  [k] ops_run_io
>>>      3.95%  [kernel]                                  [k] intel_idle_irq
>>>      3.41%  [kernel]                                  [k] xor_avx_4
>>>      2.76%  [kernel]                                  [k] handle_stripe
>>>      2.37%  [kernel]                                  [k] raid5_end_read_request
>>>      1.97%  [kernel]                                  [k] find_get_stripe
>>>
>>> Samples: 1M of event 'cycles:P', 4000 Hz, Event count (approx.): 717038747938
>>> native_queued_spin_lock_slowpath  /proc/kcore [Percent: local period]
>>> Percent │       testl     %eax,%eax
>>>           │     ↑ je        234
>>>           │     ↑ jmp       23e
>>>      0.00 │248:   shrl      $0x12, %ecx
>>>           │       andl      $0x3,%eax
>>>      0.00 │       subl      $0x1,%ecx
>>>      0.00 │       shlq      $0x5, %rax
>>>      0.00 │       movslq    %ecx,%rcx
>>>           │       addq      $0x36ec0,%rax
>>>      0.01 │       addq      -0x7b67b2a0(,%rcx,8),%rax
>>>      0.02 │       movq      %rdx,(%rax)
>>>      0.00 │       movl      0x8(%rdx),%eax
>>>      0.00 │       testl     %eax,%eax
>>>           │     ↓ jne       279
>>>     62.27 │270:   pause
>>>     17.49 │       movl      0x8(%rdx),%eax
>>>      0.00 │       testl     %eax,%eax
>>>      1.66 │     ↑ je        270
>>>      0.02 │279:   movq      (%rdx),%rcx
>>>      0.00 │       testq     %rcx,%rcx
>>>           │     ↑ je        202
>>>      0.02 │       prefetchw (%rcx)
>>>           │     ↑ jmp       202
>>>      0.00 │289:   movl      $0x1,%esi
>>>      0.02 │       lock
>>>           │       cmpxchgl  %esi,(%rbx)
>>>           │     ↑ je        129
>>>           │     ↑ jmp       20e
>>>
>>> Are there any plans to optimize spinlock contention ?
>>>
>>> Latest PCI 5.0 NVMe SSDs have tremendous performance characteristics,
>>> but huge spinlock contention just kills that performance.
>>
>> What Linux version do you test with? A lot of work is going into this in
>> the last two years. I also remember the patch *[RFC V9] md/bitmap:
>> Optimize lock contention.* [1]. It’d be great if you could help testing.
>>
>>
>> Kind regards,
>>
>> Paul
>>
>>
>> [1]:
>> https://lore.kernel.org/linux-raid/DM6PR12MB319444916C454CDBA6FCD358D83D2@DM6PR12MB3194.namprd12.prod.outlook.com/
> 

