Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305A7280309
	for <linux-raid@vger.kernel.org>; Mon, 19 May 2025 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747662923; cv=none; b=oA2T+N6Bray/UZ0/SEhzauV0e2ETjo4uh1jU7Yo2pQFfnx8lhwmrqIrQl7lov9MTm7z4fvfVZOH5jVSAVNYeOY2qndOegD5I5+JzHdUCz+ERpycVTPZdZH6xZ57oddVb1ym3dzDxje3ZHimZ2fwjAda0vuKPI4xC7h3VM0Eem9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747662923; c=relaxed/simple;
	bh=NMSN0qZx1d/bqkEDlX05gfU639E4dQQt5fRo3TFKakg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UDQctSDyyOczJRg6seMP9nzZUotAEqabd6CsMlP8NIxWPObK5oR3hJ8AmxBBE4yRf0gfcqzZaT0/pqqI32a1gle8DAe9/xR6034Luq5WXRZdvW99aWMKIp7JJrZndmNveptHxZ9zSz50Kca+gCFiRq3rCo+7D0TZJhFmq0Q/d68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TDwcu1/p; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDwcu1/p"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so33583125e9.1
        for <linux-raid@vger.kernel.org>; Mon, 19 May 2025 06:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747662920; x=1748267720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=chGazsrmzVy3Y/+yv9fBy99AyhTdQ1RXrLWAh6np3ZI=;
        b=TDwcu1/pRZcEUDdQMkJAs6bjIKkcP8x7Me1DkbOFSCZan+f/AxeZap0xAOWc/X5QFO
         28NItHldkkUjMbWl9VEMexsIDQBoibs7kpZHgFDQ/2lClRC/QkE9b/o3oWXJTbJt8C28
         UyE8EIVwCbfnNffzDAfYigqSj8a/Dhs1t/YT5GuWGNXiAkolotwkKbSOkd5obq+Sk5io
         jGcHcdquWYAZxv99Nsrs4v9uA8Py4CHSqLtzT0QRmglNmpL7GJFUwa4fIYPTuxy91XiS
         DNX/fbKot4L+S+MvizVAZf03XqzQsa2Woq0u+liK9mbWozpex/rrPRAUXXFtv2mFMV5w
         qJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747662920; x=1748267720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=chGazsrmzVy3Y/+yv9fBy99AyhTdQ1RXrLWAh6np3ZI=;
        b=B+5x4BVpQqiOpWBh97n5pn52JNpFb5l63eWGFqkKWna3BfXFVI5Ta/xg+F35qRDLKK
         0ybU2MMJf/SkDDctqD4C8oGeIOq42Gm3pNb8XhVNb7BqvaFkogE9F3Hi5BrCeXH4WV68
         szpi3MjeyrxXTRxb+uWSkqTgaqsQDX1fSv4ncwIWVm2oPCCuIXSjGyyNZJHxSiZIcFoa
         vhNvgG50KSwe2+RZD2OdENl/OErFJpFcQ63qicB2kqc1NWZuiXMhmFd6ezxvuPEOrZ6h
         KVAM8N3B55vB6P4QIojqW2lxK+UFV2dAY/7HmqNmJ/dmO0JthqPrrqBZt+nCYYEISyuv
         nYGg==
X-Forwarded-Encrypted: i=1; AJvYcCVCHYY3OG6ynFt3isE2gYE9M77HvMaU3k/GiYoDrOw3FiGw6kCYsYlhcNR8JfmDMrpVBqjZRU+zcdiX@vger.kernel.org
X-Gm-Message-State: AOJu0YxKX+l+Lik105IkdeLz8RVS7Rp6n72oMUosGDrzuUWkQgv8Qtzq
	Prgl4ey6fLE/inrpO1cxcmJMwUnjLm1UV/gCFZC5AvHksATiZsW7zsXS
X-Gm-Gg: ASbGncvZkhJ3XKc+4bBfm5ciHnXQy7yypijiLQgyaR+rATr9Ott7wwrEFPlkXMSAvod
	I6OCLK+dJNorj2ndYszN525e0d6RA+5P5OsQ0OkZcqTGT9+DTxNITkX6kYEQAZXZEAMn007Urem
	Bewo9L7Fspu+C9/cVw197zpvCTL9d72c7xbotGGNT2KdGSaXH77BWBINZOX+n7wDWb6vl+uVogD
	tAEcWkOevu9G0jwFO+vyKE6hLxcwByGS3967ou7yTIa5EIdI8qruBX4XO3BwxCLu542tDpc5hop
	44HATFVtyWEcEzOpJ8jZEtcXpddLJDkLgwiENHW37EV5rm/5B004XkRzw6SiPgH6Jj96
X-Google-Smtp-Source: AGHT+IGTV2F0Ie3YiH/a41xukybg0Vv7cUWZ9oCKJfnf7qhaDkr5xbFeDgBR1PRBIzwRzXRjj1GeWA==
X-Received: by 2002:a05:600c:3d0d:b0:442:ea3b:9d72 with SMTP id 5b1f17b1804b1-442f84ca3ecmr152079945e9.5.1747662920177;
        Mon, 19 May 2025 06:55:20 -0700 (PDT)
Received: from [10.43.17.62] ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442fd583efasm135560755e9.29.2025.05.19.06.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 06:55:19 -0700 (PDT)
Message-ID: <28d561ba-a4d4-4a16-a6f9-5d39a344cd06@gmail.com>
Date: Mon, 19 May 2025 15:55:18 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LVM2 test breakage
To: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
 <73ff7f5f-6f09-66d8-9061-7840bc72d0df@huaweicloud.com>
 <0be9be18-9488-1edc-00bb-5a1b0414fd15@redhat.com>
 <81c5847a-cfd8-4f9f-892c-62cca3d17e63@redhat.com>
 <2ec7a2fd-13bd-08d7-8e8d-71ef83c3aa45@huaweicloud.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <2ec7a2fd-13bd-08d7-8e8d-71ef83c3aa45@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 19. 05. 25 v 13:07 Yu Kuai napsal(a):
> Hi,
> 
> 在 2025/05/19 18:45, Zdenek Kabelac 写道:
>> Dne 19. 05. 25 v 12:10 Mikulas Patocka napsal(a):
>>> On Mon, 19 May 2025, Yu Kuai wrote:
>>>
>>>> Hi,
>>>>
>>>> 在 2025/05/19 9:11, Yu Kuai 写道:
>>>>> Hi,
>>>>>
>>>>> 在 2025/05/17 0:00, Mikulas Patocka 写道:
>>>>>> Hi
>>>>>>
>>>>>> The commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c breaks the test
>>>>>> shell/lvcreate-large-raid.sh in the lvm2 testsuite.
>>>>>>
>>>>>> The breakage is caused by removing the line "read_bio->bi_opf = op |
>>>>>> do_sync;"
>>>>>>
>>>> Do I need some special setup to run this test? I got following
>>>> result in my VM, and I don't understand why it failed.
>>>>
>>>> Ask Zdenek Kabelac - he is expert in the testsuite.
>>>>
>>>> Mikulas
>>
>>
>> Hi
>>
>>
>> Lvm2 test suite is creating 'virtual' disk setup - it usually tries first 
>> build something with 'brd' - if this device is 'in-use' it fallback to 
>> create some files in LVM_TEST_DIR.
>>
>> This dir however must allow creation of device - by default nowdays /dev/shm 
>> & /tmp are mounted with  'nodev' mount option.
>>
>> So a dir which does allow dev creation must be passed to the test - so 
>> either remount dir without 'nodev' or set LVM_TEST_DIR to the filesystem 
>> which allows creation of devices.
> 
> Yes, I know that, and I set LVM_TEST_DIR to a new mounted nvme, as use
> can see in the attached log:
> 
> [ 0:02.335] ## DF_H:    /dev/nvme0n1     98G   64K   93G   1% /mnt/test

Hi

Please  check the output of 'mount' command whether your mount point /mnt/test
allows creation of devices  (i.e. does not use 'nodev' as setting for this 
mountpoint)


> 
>>
>> In 'lvm2/test'   run  'make help'  to see all possible settings - useful one 
>> could be LVM_TEST_AUX_TRACE  to expose shell traces from test internals - 
>> helps with debugging...
> The log do have shell trace, I think, it stoped here, I just don't know
> why :(
> 
> [ 0:01.709] ## - /root/lvm2/test/shell/lvcreate-large-raid.sh:31
> [ 0:01.710] ## 1 STACKTRACE() called from /root/lvm2/test/shell/lvcreate- 
> large-raid.sh:31
> 


Run:

   'make check_local T=lvcreate-large-raid LVM_TEST_AUX_TRACE=1  VERBOSE=1'

for more closer look why it is failing when preparing devices.
My best guess is the use of 'nodev' flag   (thus mount with '-o dev')


Regards

Zdenek

