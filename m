Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E21F2EBDEB
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 07:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765955622; cv=none; b=hF/5BM4pV6f98rWg+IpHabYr5YPHa+gN2q3JqhlYAYdNkoXvivoz1Sp0ZnlTmg+S9d18qQQr7oj3hFXW3P86uJBLqgtEC1shNAfXmtxMhINQ91yHwj+in4Fr80IK0qrwsmFcBRirSLGUTl76bqGBT7TWWZikYIMdaocSW4buPNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765955622; c=relaxed/simple;
	bh=6WfEW9sP0dbRcV/RCQEXYpUx5jedEvdCZDySmIGp1OQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=unTszGGZkLfoMzBsT1RJVf4+wKKl0LcKEaIOVUc/91mYCfIhh23NrWMs4gKVMAMjsASR6ikpsfOAwCPbhMZ6mAI1RZ9zKGEw214L3By6nDnVLihGdyxOrLjBTyWmUrEcMKpD1+T2iAhLgmA+zmCttTet3JKMTeA/0WZk0cshvOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MNuAFfGq; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MNuAFfGq"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6496a8dc5a7so7376559a12.2
        for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 23:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765955619; x=1766560419; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AtwGDR6BP1cuFwkobHgVJEeeHCtd9EJbqTXVT/crUiE=;
        b=MNuAFfGqwDqKpcGKr/7zI+yHSfjogzZ5XxoMYVhlYMypkko9Ognlf+lKwonHoLLTN0
         K/S8hBzkRQ7BQeRp2ly5DtwHntaLW6DJQNmUING/m79F4wwwbaSIDnFcwHgJHKe+2YM7
         cbPqCn17W79MmU533rKGkb2f/Ar7Qp38/xlddzsUKrnAUJ4JzY/gWBcpDUFeHUcRfP2O
         Z6hMzqP784u6vtkwShz+vYzyHmeYRpqrImlZ+YFEOyPHwlqlR2oNPO2fy0hGsBEHmZ3q
         y78Q5peJedJX0Njxeeg6xe0FscctE+Mc40phMAoRGPKi5I6eGhtp5YdO9DaDXwO2CEtX
         GUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765955619; x=1766560419;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AtwGDR6BP1cuFwkobHgVJEeeHCtd9EJbqTXVT/crUiE=;
        b=vys29Xb3HH0ttfMudWyIHW0d135iR+PLiVcu3OjyWew3TFYVgJbRZm2KHR/y49tgIU
         d7aYF70NVeh9Dr150KG2CI1Wf/eqNN0x46I4a180zsdJnbX7n138M5TA4QxM3xQnmit2
         q+z7VBaORGN3njmPNaehdUlRYXH7A6GrzeurzvajIxbTexqRQXHLctv7MkH6jMgSwBdR
         HVMAYgOBsEFU2B5kvAY653q9MYbUYTyazCwMAC/P6UPQIhEu6tMheJ17/tNbQ3zMs8qI
         33GZ5U+e5JyT5WeBfSryK4Ltm0ZubAh6QS7t9R/lP8ojuAE0npEq2MBxthfVD6pq0Ltr
         RvxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjFJwP9ziX8Lzwfm56hWhXt/1HF4sJ0RkIWhMKhVP66Jb0xi/yZHYsbOC3VON22o6MzisrBGaaSfQS@vger.kernel.org
X-Gm-Message-State: AOJu0YyJKyVRzUcw8ldAZnztimcmlLGj4hWoq68JDb18tZy3CDCJ6XwC
	t/tX/DSQOQIjLTAMCDaMEaOcrCakDURV/UZBU9GZmhhp6g7f7XIpW9Jv
X-Gm-Gg: AY/fxX4NfUcZjR6bXLIY59nyBwNT4bgwTn5Ifa/IvBHLPCgt7QgxrB9nwE0SkdeouGL
	J1Gy3YUuJn/z8UNVsN1P8w7iuagzSG57qhl2B5/Yn0v0AoOmohsn/vXiAmhhim7t3CHFAZNq82M
	GK70xjaFEJpNUJ9GJlsdKa+xEPtyr9c+jZ/w8JJgwBoGhl3AWnvG9r+6IoEw9kp9vp7/8JhsHM3
	pQQhac3E2qjzO5i090x8rWGiQmv9X6hw82VCLVmHyORiZ7MiQM0Y6AhS6f+JCvQJHOKTrbMCj6A
	7xSrSoHLatCM7FXMq1Pg0NVI/819GTosgifrzXSoYOTaNjrJuvUCiQ2R9BtLxsywgcgFrclr5NN
	reY7bC4SfRXA63KIgjRsHQzg3WofEuTIE7tN8p8i4RQrwvyUtII+SfdpCMoxPjfFgqDR90D5WdC
	oSF2I7JTHW1dt1p0er2zQC4uMpsr9NKdob8DGf23X0kTn52DtHoPs=
X-Google-Smtp-Source: AGHT+IErCDfQca49lH2zqS1wy7LIa23ebTlQ/275i0tDmxP0Ri4FcDOCu9/li6x73be7wwN0OibGBw==
X-Received: by 2002:a05:6402:d5f:b0:640:ceef:7e4d with SMTP id 4fb4d7f45d1cf-6499b304e57mr12214088a12.32.1765955618454;
        Tue, 16 Dec 2025 23:13:38 -0800 (PST)
Received: from [192.168.179.27] (p57afaeaa.dip0.t-ipconnect.de. [87.175.174.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b44620bb8sm621373a12.14.2025.12.16.23.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 23:13:38 -0800 (PST)
Message-ID: <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com>
Date: Wed, 17 Dec 2025 08:13:37 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
To: yukuai@fnnas.com, linux-raid@vger.kernel.org, linan122@huawei.com,
 xni@redhat.com
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
Content-Language: en-US
From: BugReports <bugreports61@gmail.com>
In-Reply-To: <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,


...

We'll have to backport following patch into old kernels to make new arrays to assemble in old
kernels.

....


The md array which i am talking about was not created with kernel 6.19, 
it was created sometime in 2024.

It was just used in kernel 6.19 and that broke compatibility with my 
6.18 kernel.


Br !


Am 17.12.25 um 08:06 schrieb Yu Kuai:
> Hi,
>
> 在 2025/12/17 14:58, BugReports 写道:
>> Hi,
>>
>> i hope i am reaching out to the correct mailing list and this is the
>> way to correctly report issues with rc kernels.
>>
>> I installed kernel 6.19-rc 1 recently (with linux-tkg, but that should
>> not matter).  Booting the 6.19 rc1 kernel worked fine and i could
>> access my md raid 1.
>>
>> After that i wanted to switch back to kernel 6.18.1 and noticed the
>> following:
>>
>> - I can not access the raid 1 md anymore as it does not assemble anymore
>>
>> - The following error message shows up when i try to assemble the raid:
>>
>> |mdadm: /dev/sdc1 is identified as a member of /dev/md/1, slot 0.
>> mdadm: /dev/sda1 is identified as a member of /dev/md/1, slot 1.
>> mdadm: failed to add /dev/sda1 to /dev/md/1: Invalid argument mdadm:
>> failed to add /dev/sdc1 to /dev/md/1: Invalid argument - The following
>> error shows up in dmesg: ||[Di, 16. Dez 2025, 11:50:38] md: md1
>> stopped. [Di, 16. Dez 2025, 11:50:38] md: sda1 does not have a valid
>> v1.2 superblock, not importing! [Di, 16. Dez 2025, 11:50:38] md:
>> md_import_device returned -22 [Di, 16. Dez 2025, 11:50:38] md: sdc1
>> does not have a valid v1.2 superblock, not importing! [Di, 16. Dez
>> 2025, 11:50:38] md: md_import_device returned -22 [Di, 16. Dez 2025,
>> 11:50:38] md: md1 stopped. - mdadm --examine used with kerne 6.18
>> shows the following : ||cat mdadmin618.txt /dev/sdc1: Magic : a92b4efc
>> Version : 1.2 Feature Map : 0x1 Array UUID :
>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host
>> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1
>> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB
>> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data
>> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :
>> before=264112 sectors, after=0 sectors State : clean Device UUID :
>> 9f185862:a11d8deb:db6d708e:a7cc6a91 Internal Bitmap : 8 sectors from
>> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512
>> entries available at offset 16 sectors Checksum : f11e2fa5 - correct
>> Events : 2618 Device Role : Active device 0 Array State : AA ('A' ==
>> active, '.' == missing, 'R' == replacing) /dev/sda1: Magic : a92b4efc
>> Version : 1.2 Feature Map : 0x1 Array UUID :
>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host
>> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1
>> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB
>> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data
>> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :
>> before=264112 sectors, after=0 sectors State : clean Device UUID :
>> fc196769:0e25b5af:dfc6cab6:639ac8f9 Internal Bitmap : 8 sectors from
>> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512
>> entries available at offset 16 sectors Checksum : 4d0d5f31 - correct
>> Events : 2618 Device Role : Active device 1 Array State : AA ('A' ==
>> active, '.' == missing, 'R' == replacing)|
>> |- Mdadm --detail shows the following in 6.19 rc1 (i am using 6.19
>> output as it does not work anymore in 6.18.1): ||/dev/md1: Version :
>> 1.2 Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1 Array
>> Size : 1929939968 (1840.53 GiB 1976.26 GB) Used Dev Size : 1929939968
>> (1840.53 GiB 1976.26 GB) Raid Devices : 2 Total Devices : 2
>> Persistence : Superblock is persistent Intent Bitmap : Internal Update
>> Time : Tue Dec 16 13:14:10 2025 State : clean Active Devices : 2
>> Working Devices : 2 Failed Devices : 0 Spare Devices : 0 Consistency
>> Policy : bitmap Name : gamebox:1 (local to host gamebox) UUID :
>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Events : 2618 Number Major Minor
>> RaidDevice State 0 8 33 0 active sync /dev/sdc1 1 8 1 1 active sync
>> /dev/sda1|
>>
>>
>> I didn't spot any obvious issue in the mdadm --examine on kernel 6.18
>> pointing to why it thinks this is not a valid 1.2 superblock.
>>
>> The mdraid still works nicely on kernel 6.19 but i am unable to use it
>> on kernel 6.18 (worked fine before booting 6.19).
>>
>> Is kernel 6.19 rc1 doing adjustments on the md superblock when the md
>> is used which are not compatible with older kernels (the md was
>> created already in Nov 2024)?
> I believe this is because lbs is now stored in metadata of md arrays, while this field is still
> not defined in old kernels, see dtails in the following set:
>
> [PATCH v9 0/5] make logical block size configurable - linan666 <https://lore.kernel.org/linux-raid/20251103125757.1405796-1-linan666@huaweicloud.com/>
>
> We'll have to backport following patch into old kernels to make new arrays to assemble in old
> kernels.
>
> https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huaweicloud.com
>
> +CC Nan, would you mind backport above patch into stable kernels?
>
>>
>> Many thx !
>>
>>
>>
