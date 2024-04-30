Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CFE12C490
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 11:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475240; cv=none; b=WjR8quRyrhuWiQ2hF7exRG5GFiqP+/9fQRKTpHNEzIV3qzw0/DSzRU0jvt6V94jkKKCr8oRhs4Xz13Gljrnxw34YTegTSvR4OujOc29X80g2oa1ibkW99shMrwp5VJnSzr8i0zIghOXwOukRr7OAREj25tCoJIR95NvSQnTqaW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475240; c=relaxed/simple;
	bh=sSHOOQDasOSt/KoC1z8vKd09kxq9Lp7tMNKQUlc0eCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TPOijXlLWWcNe7ypmb7XtU7fW9ktjoEmMuSZn1pbjuU0z8l/0BTVv9B7RtmoXnmekS1UqDn3tcAdt/c21jEMbg9KZVban1wrsvw5PX1xn+RfHWy2uKR0PXSp5q84crRB8y1SgXRMe++9OUjH50O5IJLJLUenUrQCiaK5iF11F9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DBZpGDcg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DBZpGDcg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714475237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mW3GNVFoPQQNOKhcxDfUYx5vv+UK/EPU8NVnH3Dh49M=;
	b=DBZpGDcgfvyYRsJXtZ/jHSoGOL+5svtrDF/0kQTnpPxhzrBVZlx2pyGI8xLTR2XCtsIPN/
	JbVfLgGw4Uy9v09yhU0KZB70mCZ0Vj4am4GirXxIsiQ6obHT1lcZazO2IRPn/8nwmgrvKj
	11oD4E07cz+NWpZqsG6c1c8eDL58DSE=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-eMbqvgNjPGOdArRlGN7VVw-1; Tue, 30 Apr 2024 07:07:16 -0400
X-MC-Unique: eMbqvgNjPGOdArRlGN7VVw-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6ea38491322so6960216a34.3
        for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 04:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714475235; x=1715080035;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mW3GNVFoPQQNOKhcxDfUYx5vv+UK/EPU8NVnH3Dh49M=;
        b=GnsFTEmM078jL/hBrCPl1KnHJYDMDH+GILEEBZHNDEnKuKCeUFvH8T2o4WWnOKk1MI
         EDbCeZWOufw2QpGZIcFW8vMzVx8Wm2zAD1K94WF53tUVgRLDw83uAQ6VWWM1R/cfR0Pw
         JfwK/kTsxLul0cqFd9gge3AHpUCBmlzBCgzl43OuKdP3244mxVoBtCZ5olNotaN8+/zb
         LuSuB5AeYeuvGy2PuEfTdoAIUX4ggJBKsyKRAu4K75niyeb/Hw+ZGNaUen+M1kjZ0V70
         5/qmTtVZCWqELZlfCiWqLV+pPYWUTp86ZSQR6tbdxvGU2sEjwn3ncvA4TLLslPrUdVOw
         BPaw==
X-Forwarded-Encrypted: i=1; AJvYcCU2YskjuegbvbVNdK5Ea4+VOiOAxXCP7QXh2LSBH7x0CDHQjC5geuejKjcBNZz0mTcPmduOyXWoWHNb7+pQBdOdxAbdc3UqWEk9Qw==
X-Gm-Message-State: AOJu0YxP8lnNx9cI/8Oa3MLg1za4ISgrxPFk9lWaMBa36/8gdjcgTLKd
	dxalD3nztYV6VwWD5qg6ESCRSmfwPpfA5uhH2wUhuGWANOZM+tOqV1zhpjUPO8qhXKwVs4BSt2A
	ZxnPGEK98IEzhyh6puiP1qui1IDtURItuMDLDY9r/pbWGk/aI9zJswdVIch4LJ3je1JHqxw==
X-Received: by 2002:a05:6870:9a22:b0:23c:3afd:88f6 with SMTP id fo34-20020a0568709a2200b0023c3afd88f6mr2924233oab.16.1714475235006;
        Tue, 30 Apr 2024 04:07:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7w6/aXRQePmgE809l60S6OrNfqGovcWyavw9TP+OtVBdxMg3Rq8Gi4xm/r5XmnX5OVZaWOQ==
X-Received: by 2002:a05:6870:9a22:b0:23c:3afd:88f6 with SMTP id fo34-20020a0568709a2200b0023c3afd88f6mr2924211oab.16.1714475234635;
        Tue, 30 Apr 2024 04:07:14 -0700 (PDT)
Received: from [192.168.50.193] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id c6-20020ac80546000000b00436bb57faddsm11248435qth.25.2024.04.30.04.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 04:07:14 -0700 (PDT)
Message-ID: <12b8b2c2-39c8-42fb-b260-43a755b5ea20@redhat.com>
Date: Tue, 30 Apr 2024 07:07:13 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: regression: CPU soft lockup with raid10: check slab-out-of-bounds
 in md_bitmap_get_counter
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
 <a86ab399-ab3c-946c-0c2d-0f38bbde382a@huaweicloud.com>
 <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
 <75f30327-67b5-eca5-5cc8-f821ff0aeee7@huaweicloud.com>
 <14c84bbe-88e3-4ab4-afcc-2fef6397d6f4@redhat.com>
 <CAPhsuW7Tx4imRWgGsYsDJmNe3ih0pfyB1s_CGrSZ-=QQBaNBaQ@mail.gmail.com>
Content-Language: en-US
From: Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <CAPhsuW7Tx4imRWgGsYsDJmNe3ih0pfyB1s_CGrSZ-=QQBaNBaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/25/24 12:52 PM, Song Liu wrote:
> On Thu, Apr 25, 2024 at 5:10 AM Nigel Croxon <ncroxon@redhat.com> wrote:
>>
>> On 4/24/24 2:57 AM, Yu Kuai wrote:
>>> Hi, Nigel
>>>
>>> 在 2024/04/21 20:30, Nigel Croxon 写道:
>>>> On 4/20/24 2:09 AM, Yu Kuai wrote:
>>>>> Hi,
>>>>>
>>>>> 在 2024/04/20 3:49, Nigel Croxon 写道:
>>>>>> There is a problem with this commit, it causes a CPU#x soft lockup
>>>>>>
>>>>>> commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5
>>>>>> Author: Li Nan <linan122@huawei.com>
>>>>>> Date:   Mon May 15 21:48:05 2023 +0800
>>>>>> md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
>>>>>>
>>>>> Did you found this commit by bisect?
>>>>>
>>>> Yes, found this issue by bisecting...
>>>>
>>>>>> Message from syslogd@rhel9 at Apr 19 14:14:55 ...
>>>>>>    kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s!
>>>>>> [mdX_resync:6976]
>>>>>>
>>>>>> dmesg:
>>>>>>
>>>>>> [  104.245585] CPU: 7 PID: 3588 Comm: mdX_resync Kdump: loaded Not
>>>>>> tainted 6.9.0-rc4-next-20240419 #1
>>>>>> [  104.245588] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>>>>>> BIOS 1.16.2-1.fc38 04/01/2014
>>>>>> [  104.245590] RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
>>>>>> [  104.245598] Code: 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90
>>>>>> 90 90 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 90 90 90 fb 65 ff
>>>>>> 0d 95 9f 75 76 <74> 05 c3 cc cc cc cc 0f 1f 44 00 00 c3 cc cc cc cc
>>>>>> cc cc cc cc cc
>>>>>> [  104.245601] RSP: 0018:ffffb2d74a81bbf8 EFLAGS: 00000246
>>>>>> [  104.245603] RAX: 0000000000000000 RBX: 0000000001000000 RCX:
>>>>>> 000000000000000c
>>>>>> [  104.245604] RDX: 0000000000000000 RSI: 0000000001000000 RDI:
>>>>>> ffff926160ccd200
>>>>>> [  104.245606] RBP: ffffb2d74a81bcd0 R08: 0000000000000013 R09:
>>>>>> 0000000000000000
>>>>>> [  104.245607] R10: 0000000000000000 R11: ffffb2d74a81bad8 R12:
>>>>>> 0000000000000000
>>>>>> [  104.245608] R13: 0000000000000000 R14: ffff926160ccd200 R15:
>>>>>> ffff926151019000
>>>>>> [  104.245611] FS:  0000000000000000(0000)
>>>>>> GS:ffff9273f9580000(0000) knlGS:0000000000000000
>>>>>> [  104.245613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>> [  104.245614] CR2: 00007f23774d2584 CR3: 0000000104098003 CR4:
>>>>>> 0000000000370ef0
>>>>>> [  104.245616] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>>>>> 0000000000000000
>>>>>> [  104.245617] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>>>>> 0000000000000400
>>>>>> [  104.245618] Call Trace:
>>>>>> [  104.245620]  <IRQ>
>>>>>> [  104.245623]  ? watchdog_timer_fn+0x1e3/0x260
>>>>>> [  104.245630]  ? __pfx_watchdog_timer_fn+0x10/0x10
>>>>>> [  104.245634]  ? __hrtimer_run_queues+0x112/0x2a0
>>>>>> [  104.245638]  ? hrtimer_interrupt+0xff/0x240
>>>>>> [  104.245640]  ? sched_clock+0xc/0x30
>>>>>> [  104.245644]  ? __sysvec_apic_timer_interrupt+0x54/0x140
>>>>>> [  104.245649]  ? sysvec_apic_timer_interrupt+0x6c/0x90
>>>>>> [  104.245652]  </IRQ>
>>>>>> [  104.245653]  <TASK>
>>>>>> [  104.245654]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>>>>> [  104.245659]  ? _raw_spin_unlock_irq+0x13/0x30
>>>>>> [  104.245661]  md_bitmap_start_sync+0x6b/0xf0
>>> Can you give the following patch a test as well? I believe this is
>>> the root cause why page > bitmap->pages, dm-raid is using the wrong
>>> bitmap size.
>>>
>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>> index abe88d1e6735..d9c65ef9c9fb 100644
>>> --- a/drivers/md/dm-raid.c
>>> +++ b/drivers/md/dm-raid.c
>>> @@ -4052,7 +4052,8 @@ static int raid_preresume(struct dm_target *ti)
>>>                 mddev->bitmap_info.chunksize !=
>>> to_bytes(rs->requested_bitmap_chunk_sectors)))) {
>>>                  int chunksize =
>>> to_bytes(rs->requested_bitmap_chunk_sectors) ?:
>>> mddev->bitmap_info.chunksize;
>>>
>>> -               r = md_bitmap_resize(mddev->bitmap,
>>> mddev->dev_sectors, chunksize, 0);
>>> +               r = md_bitmap_resize(mddev->bitmap,
>>> mddev->resync_max_sectors,
>>> +                                    chunksize, 0);
>>>                  if (r)
>>>                          DMERR("Failed to resize bitmap");
>>>          }
>>>
>>> Thanks,
>>> Kuai
>> Hello Kaui,
>>
>> Tested and found no issues. Good to go..
>>
>> -Nigel
> Thanks for the fixes and the tests.
>
> For the next step, do we need both patches or just one of them?
>
> Song
>
They both fix the problem independently without the other.

-Nigel

