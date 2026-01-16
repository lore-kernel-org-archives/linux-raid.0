Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D62C159E
	for <linux-raid@vger.kernel.org>; Fri, 16 Jan 2026 02:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768529137; cv=none; b=HDKCa0M2hG2B0Y/GK25GY+8tZwYSFgktxj+K+r3Im/uGXf+exVQ1ifFQax48+E9R8uOJL/VWVLEqSHpQAPhFFI7FiSNrEKLKE/iEx8qXEhwfobqsKUuJJv581EqJ07vwVQLkGPdSpwekoRSNyaxJnq9AfZicfL8wbIQc9UK1ERU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768529137; c=relaxed/simple;
	bh=IHOLMn/id9J5uiXABhqWApUXqFFpk6oUqyYCcfdZvFE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kcVzIyWEKVRwrTPI69I15brcwjuMWQ8TR24l0f0GH79HqnDx80tZNv/mYqW08vHMOq9Ih/Pomo59NFkwNuVGnB/watjUQrcLiBraHTbphZ5LhgDorKqoFskkUuEypPp363MeXqi7Fx0GwPrDT4eIhxodYo5/nVjoD+UsnhsUlpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=u2nJFcr7; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="u2nJFcr7"
Received: from NEET (p3068147-ipxg00a01tokaisakaetozai.aichi.ocn.ne.jp [114.144.245.147])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 60G24cvh008823
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 16 Jan 2026 11:04:38 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=GCLnS5dKbEpaIJJw6hFEFK+mO1zv1CfsIcuYbq9NKAw=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1768529078; v=1;
        b=u2nJFcr7wm5C+ldgoqREibnsVoZur4jRvi5RS82L5SbOhFaMKtd7uuZZUYRkH+0A
         nVSdhoPr/PZMXr9QjwkdweKFAqPEkadhn+W4pPrrbaPuBoPIKSU4xfsUwDrY4G0C
         dyMpp9DPMIPD8bycwdxjL0pz2w23B4vaP2XylKuv95zwQBui+fd6XzVdULurzB8V
         ThyFaIT4Hc1TKs3Wh+e36Is5mP+u1sL6Eq5xIZ3VtHL2uv+QkUqfr8yW+QWe3WX4
         BK3VcQM/mUohAMhKLuuO2Vh9GUpW9q2s4FrKTE2gAn9vhmOkzqSZ5ClMAIH8sjZf
         jGFnLk3osy4S2/V4EmqASg==
Message-ID: <b2cc7f6e-b029-48d8-9c1a-cc8bdbdc4f1a@mgml.me>
Date: Fri, 16 Jan 2026 11:04:37 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Kenta Akagi <k@mgml.me>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, song@kernel.org, yukuai@fnnas.com,
        shli@fb.com, mtkaczyk@kernel.org
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when
 using FailFast
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
References: <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com>
 <0106019b9349bf39-5460c782-3d63-43cb-a56e-e34760ce51cd-000000@ap-northeast-1.amazonses.com>
 <CALTww282Kyg9ERXeSiY5Thd-O40vEXjAXsD8A2PxEsd-h-Cg3Q@mail.gmail.com>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <CALTww282Kyg9ERXeSiY5Thd-O40vEXjAXsD8A2PxEsd-h-Cg3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2026/01/07 12:35, Xiao Ni wrote:
> On Tue, Jan 6, 2026 at 8:30 PM Kenta Akagi <k@mgml.me> wrote:
>>
>> Hi,
>> Thank you for reviewing.
>>
>> On 2026/01/06 11:57, Li Nan wrote:
>>>
>>>
>>> 在 2026/1/5 22:40, Kenta Akagi 写道:
>>>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
>>>> if the error handler is called on the last rdev in RAID1 or RAID10,
>>>> the MD_BROKEN flag will be set on that mddev.
>>>> When MD_BROKEN is set, write bios to the md will result in an I/O error.
>>>>
>>>> This causes a problem when using FailFast.
>>>> The current implementation of FailFast expects the array to continue
>>>> functioning without issues even after calling md_error for the last
>>>> rdev.  Furthermore, due to the nature of its functionality, FailFast may
>>>> call md_error on all rdevs of the md. Even if retrying I/O on an rdev
>>>> would succeed, it first calls md_error before retrying.
>>>>
>>>> To fix this issue, this commit ensures that for RAID1 and RAID10, if the
>>>> last In_sync rdev has the FailFast flag set and the mddev's fail_last_dev
>>>> is off, the MD_BROKEN flag will not be set on that mddev.
>>>>
>>>> This change impacts userspace. After this commit, If the rdev has the
>>>> FailFast flag, the mddev never broken even if the failing bio is not
>>>> FailFast. However, it's unlikely that any setup using FailFast expects
>>>> the array to halt when md_error is called on the last rdev.
>>>>
>>>
>>> In the current RAID design, when an IO error occurs, RAID ensures faulty
>>> data is not read via the following actions:
>>> 1. Mark the badblocks (no FailFast flag); if this fails,
>>> 2. Mark the disk as Faulty.
>>>
>>> If neither action is taken, and BROKEN is not set to prevent continued RAID
>>> use, errors on the last remaining disk will be ignored. Subsequent reads
>>> may return incorrect data. This seems like a more serious issue in my opinion.
>>
>> I agree that data inconsistency can certainly occur in this scenario.
>>
>> However, a RAID1 with only one remaining rdev can considered the same as a plain
>> disk. From that perspective, I do not believe it is the mandatory responsibility
>> of md raid to block subsequent writes nor prevent data inconsistency in this situation.
>>
>> The commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10") that introduced
>> BROKEN for RAID1/10 also does not seem to have done so for that responsibility.
>>
>>>
>>> In scenarios with a large number of transient IO errors, is FailFast not a
>>> suitable configuration? As you mentioned: "retrying I/O on an rdev would
>>
>> It seems be right about that. Using FailFast with unstable underlayer is not good.
>> However, as md raid, which is issuer of FailFast bios,
>> I believe it is incorrect to shutdown the array due to the failure of a FailFast bio.
> 
> Hi all
> 
> I understand @Li Nan 's point now. The badblock can't be recorded in
> this situation and the last working device is not set to faulty. To be
> frank, I think consistency of data is more important. Users don't
> think it's a single disk, they must think raid1 should guarantee the
> consistency. But the write request should return an error when calling
> raid1_error for the last working device, right? So there is no
> consistency problem?

Hi all,

I understand that when md_error is issued for the last remaining rdev, 
the array should be stopped except in the failfast case, also, 
it is no longer appropriate to treat an RAID1 array that has lost 
redundancy as "just a normal single drive" [1].

I will post an PATCH v7 based on v5.

[1] commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")

Thanks.

> 
> hi, Kenta. I have a question too. What will you do in your environment
> after the network connection works again? Add those disks one by one
> to do recovery?
> 
> Best Regards
> Xiao
> 
>>
>> Thanks,
>> Akagi
>>
>>> succeed".
>>>
>>> --
>>> Thanks,
>>> Nan
>>>
>>>
>>
> 
> 

