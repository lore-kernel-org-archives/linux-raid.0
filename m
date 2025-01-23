Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4650538B
	for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643817; cv=none; b=qARIJWg/bJk4FKwbA/x9JW6nIRR9kMazZ8TFE158R1x/3q50SNtYP5YYnPD6DKT40c6rVb5jCNoHkCAx57zjidLg3CxirTaA5vnuh2gJa4kT6oL2kuSGUuCEcITAgGcouQwAnXBao3Xld6HJrSD4yOrmiSNnayvZKkg1VQ0PyB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643817; c=relaxed/simple;
	bh=FcBgOUbBT9JEtGqhqNujMGx8qTpQm+1sw/dKgHE+T3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=S0W3wE7x8wqImccHZDHSAYU1bFIDKHx5+2ATm9QIBUASnWcFKs7MYnGCbHHWYRIFbnXIf1Vk8duLvhN0aKN8wcCfMU32u1NqvPQThCO7BbKUOu+Nr1bMuuml22iqrSCpS8WFNfluA4b6gwdvtEnWpYTo5UyPNY6r35Yy7MSp3NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.43] (g43.guest.molgen.mpg.de [141.14.220.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 24A1B61E64781;
	Thu, 23 Jan 2025 15:49:37 +0100 (CET)
Message-ID: <f33df1a3-c274-4c6a-9359-b0cf0869bee2@molgen.mpg.de>
Date: Thu, 23 Jan 2025 15:49:36 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Huge lock contention during raid5 build time
To: Anton Gavriliuk <antosha20xx@gmail.com>
References: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
Content-Language: en-US
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Anton,


Thank you for your report.

Am 23.01.25 um 14:56 schrieb Anton Gavriliuk:

> I'm building mdadm raid5 (3+1), based on Intel's NVMe SSD P4600.
> 
> Mdadm next version
> 
> [root@memverge2 ~]# /home/anton/mdadm/mdadm --version
> mdadm - v4.4-13-ge0df6c4c - 2025-01-17
> 
> Maximum performance I saw ~1.4 GB/s.
> 
> [root@memverge2 md]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
>        4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
>        [==============>......]  recovery = 71.8% (1122726044/1562681344) finish=5.1min speed=1428101K/sec
>        bitmap: 0/12 pages [0KB], 65536KB chunk
> 
> Perf top shows huge spinlock contention
> 
> Samples: 180K of event 'cycles:P', 4000 Hz, Event count (approx.):
> 175146370188 lost: 0/0 drop: 0/0
> Overhead  Shared Object                             Symbol
>    38.23%  [kernel]                                  [k] native_queued_spin_lock_slowpath
>     8.33%  [kernel]                                  [k] analyse_stripe
>     6.85%  [kernel]                                  [k] ops_run_io
>     3.95%  [kernel]                                  [k] intel_idle_irq
>     3.41%  [kernel]                                  [k] xor_avx_4
>     2.76%  [kernel]                                  [k] handle_stripe
>     2.37%  [kernel]                                  [k] raid5_end_read_request
>     1.97%  [kernel]                                  [k] find_get_stripe
> 
> Samples: 1M of event 'cycles:P', 4000 Hz, Event count (approx.): 717038747938
> native_queued_spin_lock_slowpath  /proc/kcore [Percent: local period]
> Percent │       testl     %eax,%eax
>          │     ↑ je        234
>          │     ↑ jmp       23e
>     0.00 │248:   shrl      $0x12, %ecx
>          │       andl      $0x3,%eax
>     0.00 │       subl      $0x1,%ecx
>     0.00 │       shlq      $0x5, %rax
>     0.00 │       movslq    %ecx,%rcx
>          │       addq      $0x36ec0,%rax
>     0.01 │       addq      -0x7b67b2a0(,%rcx,8),%rax
>     0.02 │       movq      %rdx,(%rax)
>     0.00 │       movl      0x8(%rdx),%eax
>     0.00 │       testl     %eax,%eax
>          │     ↓ jne       279
>    62.27 │270:   pause
>    17.49 │       movl      0x8(%rdx),%eax
>     0.00 │       testl     %eax,%eax
>     1.66 │     ↑ je        270
>     0.02 │279:   movq      (%rdx),%rcx
>     0.00 │       testq     %rcx,%rcx
>          │     ↑ je        202
>     0.02 │       prefetchw (%rcx)
>          │     ↑ jmp       202
>     0.00 │289:   movl      $0x1,%esi
>     0.02 │       lock
>          │       cmpxchgl  %esi,(%rbx)
>          │     ↑ je        129
>          │     ↑ jmp       20e
> 
> Are there any plans to optimize spinlock contention ?
> 
> Latest PCI 5.0 NVMe SSDs have tremendous performance characteristics,
> but huge spinlock contention just kills that performance.

What Linux version do you test with? A lot of work is going into this in 
the last two years. I also remember the patch *[RFC V9] md/bitmap: 
Optimize lock contention.* [1]. It’d be great if you could help testing.


Kind regards,

Paul


[1]: 
https://lore.kernel.org/linux-raid/DM6PR12MB319444916C454CDBA6FCD358D83D2@DM6PR12MB3194.namprd12.prod.outlook.com/
