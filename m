Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE723AD
	for <linux-raid@vger.kernel.org>; Sat, 13 Apr 2024 21:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713044255; cv=none; b=EyhRqAhBLwCkUSj/rrogjrpPAlocAMyt2QuB1JvyaD1Q2y2atQrwNklzbfJqi9MO54Ut3MwEi63libzx00Gfao63qGSNbWvepZGlYRP/iLhzR9enYsiWXrPiSu4VfGzKRFAEpdIS7CTEKlJ+33Q5IE6yAcD96UtdRfHtv87nFOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713044255; c=relaxed/simple;
	bh=O+hZ05wOc1ohb/d+zxkUd5Ql92fBtriCwZ5Shl/scEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZwgzYnb6qjuNQwbD3WweOqOuBI3h/esQs6nsmBDabti9R2KGEoGqQGu3VjuY7wstrAUqSTExwNMeyc2L1bt5kHrsseXIry7rval+zq7NTFB8JblRxMO5QOvdqgvhWsJjMLho5bfiTTGCkN19tTrdeUrKd+0dceHrlUDTGvy6x8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3SxiLiG; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3SxiLiG"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56e47843cc7so1897531a12.0
        for <linux-raid@vger.kernel.org>; Sat, 13 Apr 2024 14:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713044252; x=1713649052; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j4Uhrsw0SR63fKGKAGLbucrNWYHY5YC4syREBugWIZE=;
        b=Z3SxiLiG3O5qaymll5vfX2piP6WprVv1TDh54cet77YJJ4lXMo/T0EDdbL9txdJah6
         T+35ld/UPzjzIh+RrAA02y1USyM/XEzuqyAzKrZyCmVd3sKeDj5kgPGhjWkslsSQ+3+L
         vUId5F2K8+krn190jFn9iidb72AKIxoEL7b0RX2QDvRjnhKmg3CKrEb+4le3sejYRssh
         ecyoZtFqJLawz1/3rfN0Vpc4dAeBP2lWYT+x8kklnBtl75mcYCnDXPojO4/s9zmzXBFX
         8afeQe88bEQJMP1WmPmyxbxC/8BZVuZv+LDfttiHj3V+mUjCrIFPLH3KtyTVOsSBA3xj
         NwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713044252; x=1713649052;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j4Uhrsw0SR63fKGKAGLbucrNWYHY5YC4syREBugWIZE=;
        b=MJN/Jf6iFhKbh/b3hDXUImhOl01JDOXrmumeVYnaXP1XGSVPAiiMXO/EScXTmp3d+I
         pfocEThJRGjjA+/L/HScubDXq5NPrjQDCyRGIBoWUOJn06b2uxSS7l/LUv8mNYwO+f2O
         vS0mWX4uumvnotdLORKeqoRS4FbDuqnSVoXMS0rBuPI9daUu9RW8HlbICRSV9RJSdzOE
         AOcps2OpBw/TFgULqj6LIQ2hpKqZIOtp1R7Z8/V4CN+XY4hXMJsMc/tX0jZiS9QPtF+p
         IuP3rm5ger0zKqPokHJhPSg3myDkevEUs/6GYVoLHGJVIej0Y/e4eZgJT9iKdAYWrj+Z
         HrwA==
X-Forwarded-Encrypted: i=1; AJvYcCViOpxl3e2HAoG5tqjgRMOMjfb9SrzkgpTmUVzDADFgDS3kr7dypNGbj564HcW1HDcABnO9pQrFNV26onWAKmekzrTwzGUfa7+cLg==
X-Gm-Message-State: AOJu0Yxni/ElzPMDuh54UVAk1FYRTcqBcnRIKX4S2+sVIl2XAgyndHlj
	Fdp15Er4BZDshzFCfQIdxGTWNLiKCdqNQjNeDm08sl1MQIdiMQ2c
X-Google-Smtp-Source: AGHT+IE9KStywl4PsvmbqZm7d7i1/3H9zLhRCG/EVj6G+tgZ5zI/IwW6gmVyxkw4NrJfUU7Wy1uxlg==
X-Received: by 2002:a50:a453:0:b0:568:9936:b2e with SMTP id v19-20020a50a453000000b0056899360b2emr3719321edb.24.1713044251914;
        Sat, 13 Apr 2024 14:37:31 -0700 (PDT)
Received: from ?IPV6:2a02:3102:6876:11:5b51:e1db:2186:dbe4? (dynamic-2a02-3102-6876-0011-5b51-e1db-2186-dbe4.310.pool.telefonica.de. [2a02:3102:6876:11:5b51:e1db:2186:dbe4])
        by smtp.gmail.com with ESMTPSA id b9-20020a0564021f0900b0056e59d747b0sm2961205edb.40.2024.04.13.14.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Apr 2024 14:37:31 -0700 (PDT)
Message-ID: <5a4a9b82-2082-4d25-906d-ee01b10fad65@gmail.com>
Date: Sat, 13 Apr 2024 23:37:12 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: regression: drive was detected as raid member due to metadata on
 partition
To: Li Nan <linan666@huaweicloud.com>, linux-raid@vger.kernel.org
References: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
 <90ebc7c2-624c-934b-1b5b-e8efccfda209@huaweicloud.com>
 <08a82e10-dc6b-41f9-976a-e86a59cfd54d@gmail.com>
 <fe14b4b4-9ab2-93f5-85a8-3416d79dffa2@huaweicloud.com>
Content-Language: en-US
From: =?UTF-8?Q?Sven_K=C3=B6hler?= <sven.koehler@gmail.com>
In-Reply-To: <fe14b4b4-9ab2-93f5-85a8-3416d79dffa2@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Am 11.04.24 um 04:25 schrieb Li Nan:
> Hi,
>
> 在 2024/4/11 4:59, Sven Köhler 写道:
>> Hi,
>>
>> Am 10.04.24 um 03:56 schrieb Li Nan:
>>> Hi, Köhler
>>>
>>> 在 2024/4/9 7:31, Sven Köhler 写道:
>
> [...]
>
>>
>> I should have mentioned the mdadm and kernel version. I am using 
>> mdadm 4.3-2 and linux-lts 6.6.23-1 on Arch Linux.
>>
>> I created the array very similar to what you did:
>> mdadm --create /dev/md4 --level=6 --raid-devices=4 --metadata=0.90 
>> /dev/sd[abcd]4
>>
>> My mdadm.conf looks like this:
>> DEVICE partitions
>> ARRAY /dev/md/4 metadata=0.90  UUID=...
>>
>> And /proc/partitions looks like this:
>>
>> major minor  #blocks  name
>>     8        0 2930266584 sda
>>     8        1    1048576 sda1
>>     8        2   33554432 sda2
>>     8        3   10485760 sda3
>>     8        4 2885176775 sda4
>>     8       16 2930266584 sdb
>>     8       17    1048576 sdb1
>>     8       18   33554432 sdb2
>>     8       19   10485760 sdb3
>>     8       20 2885176775 sdb4
>>     8       32 2930266584 sdc
>>     8       33    1048576 sdc1
>>     8       34   33554432 sdc2
>>     8       35   10485760 sdc3
>>     8       36 2885176775 sdc4
>>     8       48 2930266584 sdd
>>     8       49    1048576 sdd1
>>     8       50   33554432 sdd2
>>     8       51   10485760 sdd3
>>     8       52 2885176775 sdd4
>>
>>
>> Interestingly, sda, sdb, etc. are included. So "DEVICE partitions" 
>> actually considers them.
>>
>
> I used your command and config, updated kernel and mdadm, but raid also
> created correctly after reboot.
>
> My OS is fedora, it may have been affected by some other system tools? I
> have no idea.

The Arch kernel has RAID autodetection enabled. I just tried to 
reproduce it. While mdadm will not consider /dev/sd[ab] as members, the 
kernel's autodetection will. For that you have to reboot.

I used this ISO in a VM with 2 harddisks to reproduce the issue: 
https://mirror.informatik.tu-freiberg.de/arch/iso/2024.04.01/archlinux-2024.04.01-x86_64.iso


Kind Regards,
   Sven

