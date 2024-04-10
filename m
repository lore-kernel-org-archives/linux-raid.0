Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25F3181BBC
	for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 20:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712782789; cv=none; b=QEmW4a7lVUKvTpKhfPfDfmVmVwIEXDm31Q5OE07XoA9P5ITTAlGhBcYrQZ3tiE2zgZ3ECOWWIirxvFEvcn3YStJ5zYpOlt9/AK1kV3lZikgynZ/qKW5pk9BypHKSuogCd3pUBb5fo/Ze8eBzHNNIJzGiON+r3oqUPcBUyPouRcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712782789; c=relaxed/simple;
	bh=kyDoJ8rfjlrxKt0LekznWQMrFWieLGUXM5wyvxpP0/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WcZ6cqBcHDK1Y5928fkJvfv9mw0esHmU7/DX96G5ThBTd8qJMU8gq3Z1r4XjXb8sI30Y4eAXZWwp/jD8GCFugC3587O1fG+FkDZ1Ths2PXQwqXakWdjQhX7OeH1PFuuz2TXkqBAgs1y/TyHVHHIxy0HhZjlT1yC/xuUicCEa3jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B/EWRNCT; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B/EWRNCT"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5200afe39eso223160966b.1
        for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 13:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712782786; x=1713387586; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZWydfXvACLNJQgQCF+RX9ft0Sk1EDj5PgNNkQfEFpgM=;
        b=B/EWRNCTWnVluDRplIsHjJxP3qNSkTOoEgA71D/LekkT6rMp8O+xhs2/gk5pkrZjsC
         F2P/LJDU/LpDRsQ/oZa4fTNDBic/eUUxXfGdy19uUV+eIqjw1XvfiwBkkqUCvqvVi5UH
         bh3PmmkWN5wCAhnXYYzUYMFuyLADuslQRNkXm0Zgjl85Y3xj2UXvN5q3AA8vy4MJ/LRO
         nDjmQMnDzgDLXWFQjV3F0XA9LKVzSLa8DdwWowIopell6sKji2+s65n8n07+3ndkmXqK
         M15lZxVzqT1Oe+J3RXEZdbgidDF0aGmW2cxYnoRUAiyMW5w3ohJvGJ3ILyhb/0S1f57L
         lqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712782786; x=1713387586;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWydfXvACLNJQgQCF+RX9ft0Sk1EDj5PgNNkQfEFpgM=;
        b=wO2mo9nYJHLQ5lYzMFw3IZjCtbKV8v4JXL9/l6WlEjfFwKFClxYs0A8R39lmg1PGKa
         cXBtYQiqZJnsqN7DfLZKZJzdgx4kVsb4m7K5lESFuRsoWS5mrZONp7Wp9dVYzaqekhah
         7ZlCykRveZI/pBh2J/E+QMZWLaSsEVcl5mArdZy9jLn89n50Jjcy0QVol3hzPgLm23+A
         ZiZxYMggZg+8dWmrwbLtK5xAQ4Mg/VvPXqOSip0gv7J8F6PpSbeuhdEy70cWL8S6hzdz
         kcPGy8L+T8ys+aX1nPifhK7aRX7UQN9T8J8Z85VxN9AKDS03D29elTx2frizzwaw2QRG
         G5zg==
X-Forwarded-Encrypted: i=1; AJvYcCXH134v7ZMrxlQyjHZ8kwmA+EHjq9Tj2OqjqXvTgRoKMRneR2x1h/vLy9e572COgYK+feChuhpJS86ICBdI+gbchTWs+bVq7aZbJw==
X-Gm-Message-State: AOJu0YwRkGZLI085ewBKuK/n0C/D6I8H831gy7qVrDdePwHlrF5oVAqr
	lipUiiDU4rU5JrLksnwTXnTCv0L/oBEmMeSJfctPBThGxOEv3DLAitO5Jg==
X-Google-Smtp-Source: AGHT+IE25RcBKPwsoyd4YDuGADGbbN0dNcoBR5ztrOzT+8KMyUgN1KF/hf5HjdfNvD2s1zMefW7xbQ==
X-Received: by 2002:a17:907:76a4:b0:a51:c720:5107 with SMTP id jw4-20020a17090776a400b00a51c7205107mr2780827ejc.22.1712782785622;
        Wed, 10 Apr 2024 13:59:45 -0700 (PDT)
Received: from ?IPV6:2a02:3102:6876:11:5b51:e1db:2186:dbe4? (dynamic-2a02-3102-6876-0011-5b51-e1db-2186-dbe4.310.pool.telefonica.de. [2a02:3102:6876:11:5b51:e1db:2186:dbe4])
        by smtp.gmail.com with ESMTPSA id s6-20020a170906354600b00a51ce104a50sm48015eja.148.2024.04.10.13.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 13:59:45 -0700 (PDT)
Message-ID: <08a82e10-dc6b-41f9-976a-e86a59cfd54d@gmail.com>
Date: Wed, 10 Apr 2024 22:59:25 +0200
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
Content-Language: en-US
From: =?UTF-8?Q?Sven_K=C3=B6hler?= <sven.koehler@gmail.com>
In-Reply-To: <90ebc7c2-624c-934b-1b5b-e8efccfda209@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Am 10.04.24 um 03:56 schrieb Li Nan:
> Hi, Köhler
> 
> 在 2024/4/9 7:31, Sven Köhler 写道:
>> Hi,
>>
>> I was shocked to find that upon reboot, my Linux machine was detecting 
>> /dev/sd[abcd] as members of a raid array. It would assign those 
>> members to /dev/md4. It would not run the raid arrays /dev/mdX with 
>> members /dev/sda[abcd]X for X=1,2,3,4 as it usually did for the past 
>> couple of years.
>>
>> My server was probably a unicorn in the sense that it used metadata 
>> version 0.90. This version of software RAID metadata is stored at the 
>> _end_ of a partition. In my case, /dev/sda4 would be the last 
>> partition on drive /dev/sda. I confirmed with mdadm --examine that 
>> metadata with the identical UUID would be found on both /dev/sda4 and 
>> /dev/sda.
>>
> 
> I am trying to reproduce it, but after reboot, md0 started with members
> /dev/sd[bc]2 correctly. And mdadm will waring if assemble by 'mdadm -A'.
> 
>    # mdadm -CR /dev/md0 -l1 -n2 /dev/sd[bc]2 --metadata=0.9
>    # mdadm -S --scan
>    # mdadm -A --scan
>    mdadm: WARNING /dev/sde2 and /dev/sde appear to have very similar 
> superblocks.
>          If they are really different, please --zero the superblock on one
>          If they are the same or overlap, please remove one from the
>          DEVICE list in mdadm.conf.
>    mdadm: No arrays found in config file or automatically
> 
> Can you tell me how you create and config the RAID?

I should have mentioned the mdadm and kernel version. I am using mdadm 
4.3-2 and linux-lts 6.6.23-1 on Arch Linux.

I created the array very similar to what you did:
mdadm --create /dev/md4 --level=6 --raid-devices=4 --metadata=0.90 
/dev/sd[abcd]4

My mdadm.conf looks like this:
DEVICE partitions
ARRAY /dev/md/4 metadata=0.90  UUID=...

And /proc/partitions looks like this:

major minor  #blocks  name
    8        0 2930266584 sda
    8        1    1048576 sda1
    8        2   33554432 sda2
    8        3   10485760 sda3
    8        4 2885176775 sda4
    8       16 2930266584 sdb
    8       17    1048576 sdb1
    8       18   33554432 sdb2
    8       19   10485760 sdb3
    8       20 2885176775 sdb4
    8       32 2930266584 sdc
    8       33    1048576 sdc1
    8       34   33554432 sdc2
    8       35   10485760 sdc3
    8       36 2885176775 sdc4
    8       48 2930266584 sdd
    8       49    1048576 sdd1
    8       50   33554432 sdd2
    8       51   10485760 sdd3
    8       52 2885176775 sdd4


Interestingly, sda, sdb, etc. are included. So "DEVICE partitions" 
actually considers them.


>> Here's what I think went wrong: I believe either the kernel or mdadm 
>> (likely the latter) was seeing the metadata at the end of /dev/sda and 
>> ignored the fact that the location of the metadata was actually owned 
>> by a partition (namely /dev/sda4). The same happened for /dev/sd[bcd] 
>> and thus I ended up with /dev/md4 being started with members 
>> /dev/sda[abcd] instead of members /dev/sda[abcd]4.
>>
>> This behavior started recently. I saw in the logs that I had updated 
>> mdadm but also the Linux kernel. mdadm and an appropriate mdadm.conf 
>> is part of my initcpio. My mdadm.conf lists the arrays with their 
>> metadata version and their UUID.
>>
>> Starting a RAID array with members /dev/sda[abcd] somehow removed the 
>> partitions of the drives. The partition table would still be present, 
>> but the partitions would disappear from /dev. So /dev/sda[abcd]1-3 
>> were not visible anymore and thus /dev/md1-3 would not be started.
>>
>> I strongly believe that mdadm should ignore any metadata - regardless 
>> of the version - that is at a location owned by any of the partitions. 
>> While I'm not 100% sure how to implement that, the following might 
>> also work: first scan the partitions for metadata, then ignore if the 
>> parent device has metadata with a UUID previously found.
>>
>>
>> I did the right thing and converted my RAID arrays to metadata 1.2, 
>> but I'd like to save other from the adrenaline shock.
>>
>>
>>
>> Kind Regards,
>>    Sven
>>
>> .
> 
