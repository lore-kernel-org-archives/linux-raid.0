Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C998180A67
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 22:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713478304; cv=none; b=EMy0sUViZuUYCBJ6QeQxPQ+nTbqgMIk/Nt5qteYMY+Am9OiloYVm0YiMh3DbmoPptP8gVP6E5jKk3C+NT8sncE71ByKn/ldZcoj0mQg8IophkiIdrSiq9eUORV4/gv8wTiIjZaTAWrNnn1VY4YhgUGBynKJJQ5oJBHJpdmolu9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713478304; c=relaxed/simple;
	bh=t/S72qIZ7Jld3RwRIzhJwUC/TUtFoXHCRG0T4dLhWOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=s3DUXB2If96pkK7MS/+IRHpdZwFo1MTw+/P/h1uH6OqqXiHFSQVL6jstV2HuVnatc/w145kzM4mSYXsKqmmJIrWgMWpucQUt0BOmVC/iIcbuiWurwe2UH6PcAFhC8jq5RecIFnLRnUTpX7nojk7MJBZU2QAZfR+yr5DmYi1FkMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OObTT4v6; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OObTT4v6"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-343cfa6faf0so1253986f8f.0
        for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 15:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713478301; x=1714083101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QgDVo1+A/LAJ3SzhZM1O+bAYlxviDxFyyFZa94m4i/o=;
        b=OObTT4v6DUknMc38mZF0PdpIjB7TRMo3VHV6QARwUA2ukiN7S/jM18wTOdSE5cNGhx
         aJfD5T7nY5DhwDBIWv1vTgb2Mk0BDY6KGBvxtUdyXtGKmzw/ZT8Bn/m8eY8QGkDQlgTz
         79Av/F3kDjnpZJuLbRpyQFzoN2ajbtMY6/rCS4J/Krv7WPGvcHfFoyMzici4k/BFd0gB
         IzMMXU8lU09NMoCd4+TsxyfmfoibVnJS4D5+YAzVB28VHjbGSe0CdM0BEeqCj0XsStj/
         0Mh7yI6A2i1w7yWMy5wpKiph7kKXGLK58KdIGpTjc0yqi2QaJ5ffpcLl0+5ajhTualSh
         z1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713478301; x=1714083101;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QgDVo1+A/LAJ3SzhZM1O+bAYlxviDxFyyFZa94m4i/o=;
        b=ws3kRNmBI45C5dLGCzoRsKVSMWGjlUOFLqAY6+ADOLLsmHB597G2fgV6Ci/nm/P4qu
         c0RPiAn1iBewik6iYIM3Iv0LFKS3Y1ffWcxPeBGhSMXpKPXYLLtZw5awsshVx2sBKTXA
         VMnuQ+KZHxo6/nmZOQwGRPXzGjxl3XuWElLob8qUZVNXLhhVEH7uRIamlZls4QO/yFNG
         C8J+6itc1Px6UvUfuIxbcbku0Wq99VnRGCPFYp9KPqEMzIi0aOJ9hZ5WCj2RUBz3t2nn
         DapQomQ8awQeyU7qkW3LQQ9jx4/8piwWFpvESP40vIqE+1NNlWuiZ5qTq9wgQB6XDcGp
         OBbw==
X-Forwarded-Encrypted: i=1; AJvYcCVTpUdxAOqhfXKj5kmZXMnrDLGkdIXEGxyFMJPGCasIC8YErrr46fW45XSqdTtLWnjE5xoQQHBPWM3M79jfdk5lov4uTNIO7ntO5g==
X-Gm-Message-State: AOJu0Yw1t3fIk1FEEMYW0PXiMCz9GArouAUoEukEhWdFsSvc1Rvf+WAY
	a4BQ2YkNdsD7fkBGaBsRqeqPoevHCTUdeBWOyg8Jn1k3hF1Piw/x1+y36A==
X-Google-Smtp-Source: AGHT+IEtZ4ySq4vGsmd6yZECzHlczYtUlTG3MRBV1ry7otl0aUvym3RYCd1f7mJAMf4Bg+jlHRWmqA==
X-Received: by 2002:a05:6000:e8c:b0:34a:43e2:92e6 with SMTP id dz12-20020a0560000e8c00b0034a43e292e6mr147719wrb.66.1713478300955;
        Thu, 18 Apr 2024 15:11:40 -0700 (PDT)
Received: from ?IPV6:2a02:3102:6876:11:5b51:e1db:2186:dbe4? (dynamic-2a02-3102-6876-0011-5b51-e1db-2186-dbe4.310.pool.telefonica.de. [2a02:3102:6876:11:5b51:e1db:2186:dbe4])
        by smtp.gmail.com with ESMTPSA id v10-20020a5d590a000000b003437ad152f9sm2791763wrd.105.2024.04.18.15.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Apr 2024 15:11:38 -0700 (PDT)
Message-ID: <49b2cb82-a827-46c8-9cba-5b9891dcf2e5@gmail.com>
Date: Fri, 19 Apr 2024 00:11:18 +0200
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
 <5a4a9b82-2082-4d25-906d-ee01b10fad65@gmail.com>
 <cffea7de-edf4-c97b-3fc7-c87038123593@huaweicloud.com>
Content-Language: en-US
From: =?UTF-8?Q?Sven_K=C3=B6hler?= <sven.koehler@gmail.com>
In-Reply-To: <cffea7de-edf4-c97b-3fc7-c87038123593@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.04.24 um 09:31 schrieb Li Nan:
> 
> 
> 在 2024/4/14 5:37, Sven Köhler 写道:
> 
> [...]
> 
>>>
>>> I used your command and config, updated kernel and mdadm, but raid also
>>> created correctly after reboot.
>>>
>>> My OS is fedora, it may have been affected by some other system tools? I
>>> have no idea.
>>
>> The Arch kernel has RAID autodetection enabled. I just tried to 
>> reproduce it. While mdadm will not consider /dev/sd[ab] as members, 
>> the kernel's autodetection will. For that you have to reboot.
>>
> 
> It is not about autodetection. Autodetection only deals with the devices in
> list 'all_detected_devices', device is added to it by blk_add_partition().
> So sdx will not be added to this list, and will not be autodetect.

I apologize. It's not the kernel autodetection. Arch Linux is using udev 
rules to re-assemble mdadm array during boot. The udev rules execute

   /usr/bin/mdadm -If $name

where $name is likely a device like /dev/sda. I'm not sure yet whether 
the udev rules have changed or mdadm has changed.

I will continue digging.

