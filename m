Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28530FF08
	for <linux-raid@vger.kernel.org>; Thu, 18 Dec 2025 10:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766054520; cv=none; b=bccU99+yjuKzR++KUDa06CgkEqTpcuPKKVMpneh5X/dEKEp8Bcfu09tVLON113mZI6qaTjuzm6R80jpERRyryv7ziMCY5hgnchRNceiTHOWHUcTOofylaEKwjnNgzLKUUUBSE3ZCZrI16BdLz0Qwi4z3IKUIQ3A1WcvWJSYDS9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766054520; c=relaxed/simple;
	bh=dVFDqF8LzNu2tsP27tAp2Snmt3AKTHyPsM2GMFKw0+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=o60bmQdjYncxdKf+JSjr+LsOeUIXFuOZ0kF41JKTCatM0AuztGGe0lMkAS0ruXOUQHRbaSpfOBD1Y5Js1Ugqs/q/eX18bsB0EbWiXZC7QajC5Xhh7VQPB/i5UB1/xVXiYy/Ss5Ajp5MOVKaUTW1cbV6MMcunBuISDWEw//CiEQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=motUOHsC; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="motUOHsC"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso3319145e9.1
        for <linux-raid@vger.kernel.org>; Thu, 18 Dec 2025 02:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766054515; x=1766659315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IArrJzUMyDdF0atNLoZ4WNBPGhcxJI+9mPn8WThtT00=;
        b=motUOHsCGZ6yR6cUtd6Yz7b/iSQ1HZ+11iNNbPj8HDGZOk3AG8AJENebV5Xyqq8/QZ
         GRAK8eOll0ePk3iL0qHjRSB/BfE9t8/I6x9GW4XoVlWIrdxgKCps4D9cfy8QjviJvRM3
         eCD36YkIM2cdwB74H3ga5X4ZD0VF2NRb6Ramj94Uy9bZnJWSM6SwX1C8ZvxAjvAzRuJf
         ws3Nzd1UTY7438/HaJL1SMxjpo9hdoug/3GJ8FVZx85ln1rZPR07zCljLqA5obkzHOzG
         boNNfuULRaG4T+mYLgXXpEjQOcBrlM1lun9vw4Ty4U+yCUnG8jmi9pwAvLqQy+KjULSP
         4+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766054515; x=1766659315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IArrJzUMyDdF0atNLoZ4WNBPGhcxJI+9mPn8WThtT00=;
        b=vhsdjKQhaykJNJWWHaCUKCqZbVwc7n1irhVymQQn7qj7CfVpukAjf1O2rIpMChy+Lt
         kkDgTs51OZ75LETTrowlCbj4roCCTcw4sqjy7K+GDBAh4/7jTrUkRhhlNyldk8R7bfdG
         o0g8B2jHrvkD+iykuagrbKeD5NahsqBn6vm1G5M64v2qacHmYp+fGFG8W0pzDR6RJI2r
         edYpzL+ELut+Mpv8gCcBQRvaZ50rhmUsSvVZdhUM8y7J8Eoag2/DQqf32h4N6/elBD92
         qWptt1lsjQicmMVo3EOtPN4rTrAztiMatwt4GfOxec65A5fo/xoqRx6zMuAsoHYi8S6z
         swrg==
X-Forwarded-Encrypted: i=1; AJvYcCVoRMhEnNWCTCVaW/S4OT+mcE9bFU4tcSH92MPYSdhLmHmrfGeFUHEP4PxQu77Ti2ScHeOIn4rAUg9Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfo0rPTn2IRnxOSnwp6Z+vuwg4xn8J83s2adYI9AoYkwLQlfCX
	2ERzvRRiVB14jGQZAj7Azpvx0l8tKQ0Kh0ti4r1K3kGOVKQ2K6S3HoAGAwL2aw==
X-Gm-Gg: AY/fxX4h+UYea0ODxrn3cRlXLXJAuqOs/4sdlaN4mmPqD3Y2x+tLXogp8UczsL4WwHq
	xbHZoBtnCOV0HlicxuCcOPtLVdlirXmQMAH16jgz+F/yUIGUNRugpAt4OM+d6LI9ZqNlxZ8/vRZ
	pdEKbBy/oD4NbIvw6GgM4H8TVFWQIoNxh5rsTRiESfWy5Ge3BuFFji14/f/CsEhK1rkn11Kbkyq
	yrjeBW0ckdDsDkUjqrt53DPQn1tHOcnFbhaL/a5JGEPNZXth7h+0bAnYQ+acaznitsQJdJ1P179
	/XM+3PLPCppHu+w6TBPXwPMcbIdt3uRov5NVQ52WRsgd6xPqF4neVgC3G9nW8BW+Me1G5PUVHMk
	ZYaE+/AdNBEjtXounTkuu1h+KsZe9Er4fBU26cS7oI60h7h7WNqt2kWWsZFKEH/51SfMq+b+Crz
	rvzTzKluZWTQgPlv9YAxKP032bXtnXN7kX0/NDr1ZXf6IIRkhaUOeA
X-Google-Smtp-Source: AGHT+IEYwZED2BaJEJ4dWmD4I7IADf7zPl8PUA6p4qgBFL66e1SrbFzV6o8X6pUiVmg1v6JcSRF/fg==
X-Received: by 2002:a05:600c:8b73:b0:477:bcb:24cd with SMTP id 5b1f17b1804b1-47a8f9065f4mr181479635e9.22.1766054514569;
        Thu, 18 Dec 2025 02:41:54 -0800 (PST)
Received: from [192.168.179.66] (p57afa6c3.dip0.t-ipconnect.de. [87.175.166.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be32694d6sm31713055e9.9.2025.12.18.02.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 02:41:54 -0800 (PST)
Message-ID: <af9b7a8e-be62-4b5a-8262-8db2f8494977@gmail.com>
Date: Thu, 18 Dec 2025 11:41:53 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
To: Li Nan <linan666@huaweicloud.com>, yukuai@fnnas.com,
 linux-raid@vger.kernel.org, xni@redhat.com
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com>
Content-Language: en-US
From: Bugreports61 <bugreports61@gmail.com>
In-Reply-To: <825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,


reading the threads it was now decided that only newly created arrays 
will get the lbs adjustment and patches to make it work on older kernels 
will not happen:


How do i get back my md raid1 to a state which makes it usable again on 
older kernels ?

Is it  safe to simply mdadm --create --assume-clean /dev/mdX /sdX /sdY 
on kernel 6.18 to get the old superblock 1.2 information back without 
loosing data ?


My thx !


Am 17.12.25 um 14:24 schrieb Li Nan:
>
>
> 在 2025/12/17 15:06, Yu Kuai 写道:
>> Hi,
>>
>> 在 2025/12/17 14:58, BugReports 写道:
>>> Hi,
>>>
>>> i hope i am reaching out to the correct mailing list and this is the
>>> way to correctly report issues with rc kernels.
>>>
>>> I installed kernel 6.19-rc 1 recently (with linux-tkg, but that should
>>> not matter).  Booting the 6.19 rc1 kernel worked fine and i could
>>> access my md raid 1.
>>>
>>> After that i wanted to switch back to kernel 6.18.1 and noticed the
>>> following:
>>>
>>> - I can not access the raid 1 md anymore as it does not assemble 
>>> anymore
>>>
>>> - The following error message shows up when i try to assemble the raid:
>>>
>>> |mdadm: /dev/sdc1 is identified as a member of /dev/md/1, slot 0.
>>> mdadm: /dev/sda1 is identified as a member of /dev/md/1, slot 1.
>>> mdadm: failed to add /dev/sda1 to /dev/md/1: Invalid argument mdadm:
>>> failed to add /dev/sdc1 to /dev/md/1: Invalid argument - The following
>>> error shows up in dmesg: ||[Di, 16. Dez 2025, 11:50:38] md: md1
>>> stopped. [Di, 16. Dez 2025, 11:50:38] md: sda1 does not have a valid
>>> v1.2 superblock, not importing! [Di, 16. Dez 2025, 11:50:38] md:
>>> md_import_device returned -22 [Di, 16. Dez 2025, 11:50:38] md: sdc1
>>> does not have a valid v1.2 superblock, not importing! [Di, 16. Dez
>>> 2025, 11:50:38] md: md_import_device returned -22 [Di, 16. Dez 2025,
>>> 11:50:38] md: md1 stopped. - mdadm --examine used with kerne 6.18
>>> shows the following : ||cat mdadmin618.txt /dev/sdc1: Magic : a92b4efc
>>> Version : 1.2 Feature Map : 0x1 Array UUID :
>>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host
>>> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1
>>> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB
>>> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data
>>> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :
>>> before=264112 sectors, after=0 sectors State : clean Device UUID :
>>> 9f185862:a11d8deb:db6d708e:a7cc6a91 Internal Bitmap : 8 sectors from
>>> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512
>>> entries available at offset 16 sectors Checksum : f11e2fa5 - correct
>>> Events : 2618 Device Role : Active device 0 Array State : AA ('A' ==
>>> active, '.' == missing, 'R' == replacing) /dev/sda1: Magic : a92b4efc
>>> Version : 1.2 Feature Map : 0x1 Array UUID :
>>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host
>>> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1
>>> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB
>>> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data
>>> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :
>>> before=264112 sectors, after=0 sectors State : clean Device UUID :
>>> fc196769:0e25b5af:dfc6cab6:639ac8f9 Internal Bitmap : 8 sectors from
>>> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512
>>> entries available at offset 16 sectors Checksum : 4d0d5f31 - correct
>>> Events : 2618 Device Role : Active device 1 Array State : AA ('A' ==
>>> active, '.' == missing, 'R' == replacing)|
>>> |- Mdadm --detail shows the following in 6.19 rc1 (i am using 6.19
>>> output as it does not work anymore in 6.18.1): ||/dev/md1: Version :
>>> 1.2 Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1 Array
>>> Size : 1929939968 (1840.53 GiB 1976.26 GB) Used Dev Size : 1929939968
>>> (1840.53 GiB 1976.26 GB) Raid Devices : 2 Total Devices : 2
>>> Persistence : Superblock is persistent Intent Bitmap : Internal Update
>>> Time : Tue Dec 16 13:14:10 2025 State : clean Active Devices : 2
>>> Working Devices : 2 Failed Devices : 0 Spare Devices : 0 Consistency
>>> Policy : bitmap Name : gamebox:1 (local to host gamebox) UUID :
>>> 3b786bf1:559584b0:b9eabbe2:82bdea18 Events : 2618 Number Major Minor
>>> RaidDevice State 0 8 33 0 active sync /dev/sdc1 1 8 1 1 active sync
>>> /dev/sda1|
>>>
>>>
>>> I didn't spot any obvious issue in the mdadm --examine on kernel 6.18
>>> pointing to why it thinks this is not a valid 1.2 superblock.
>>>
>>> The mdraid still works nicely on kernel 6.19 but i am unable to use it
>>> on kernel 6.18 (worked fine before booting 6.19).
>>>
>>> Is kernel 6.19 rc1 doing adjustments on the md superblock when the md
>>> is used which are not compatible with older kernels (the md was
>>> created already in Nov 2024)?
>>
>> I believe this is because lbs is now stored in metadata of md arrays, 
>> while this field is still
>> not defined in old kernels, see dtails in the following set:
>>
>> [PATCH v9 0/5] make logical block size configurable - linan666 
>> <https://lore.kernel.org/linux-raid/20251103125757.1405796-1-linan666@huaweicloud.com/>
>>
>> We'll have to backport following patch into old kernels to make new 
>> arrays to assemble in old
>> kernels.
>>
>> https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huaweicloud.com 
>>
>>
>> +CC Nan, would you mind backport above patch into stable kernels?
>>
>
> Sent to stable from 6.18 to 5.10
>
> https://lore.kernel.org/stable/20251217130513.2706844-1-linan666@huaweicloud.com/T/#u 
>
> https://lore.kernel.org/stable/20251217130935.2712267-1-linan666@huaweicloud.com/T/#u 
>
>
