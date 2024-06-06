Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258C41C68E
	for <linux-raid@vger.kernel.org>; Thu,  6 Jun 2024 02:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717642089; cv=none; b=QMBjIiqQsjxnH5UyOWuQpMY8iBAIXta6mlPEqnwdoUksBhCvVV41ztNkmP9rUlbSMjI+Au2abr4mc/dj046yhVNIqxasvRXUvVgvSdbn+zHXivzADoFPfQ6XMpZ2mCHiYmEwLB6/hM6xFlcPlXgG0f8uym4E8x65CkWc9uHmAk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717642089; c=relaxed/simple;
	bh=5NSZrFpB/GonGD46gDAy0SbbwmVebNNq7DJjorbO0dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XLCQIO+ZMVHzyDl9sRh7DrmC78mkm7HWvbinCbT4tB2VmOL08A332c+/UcdidFRFlQGRM2aknsF3jJDsSjA2iRAJL/iC6zaVgeJe7go+54retYtRsqwVN+22deiXUgx5BWGrzqD0+VRR1XlgRtHkNyUtq9Mkv3RubW/sgZYpDsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LE1C+HyZ; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LE1C+HyZ"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2e6f2534e41so4801911fa.0
        for <linux-raid@vger.kernel.org>; Wed, 05 Jun 2024 19:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717642085; x=1718246885; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N0jfz+nnR88SF/3jl+2qqnrwZqfMXV0m/DMzFLp5rwQ=;
        b=LE1C+HyZm0yqa161sPPvKWPOxJsDLFefLlWrYnlhoQHYeUmwTyy5YbRQcLOlz9UCd9
         9BL1AEyIuY0oyGV1ckWyITw9wLGuL3aJJWmOunRi0i+helQrqRCSmjbCyKwjAQyh2WCK
         TUpOsCxG7E9nImGUVz71jTFgCsYEWihH+zgQrktt2fXswx/2XGBvin50HJeDxVnX5AHv
         dc2Fd6kJue8H5cEU33oUg44U3U6O+fk0lelP9X3X3ToS2PA5vav2ELGYSxao2uZqeDvp
         iD2eLwT18GLPgxSo+0NQW8c3tyQegrHXyOYYtQEuIwoKrUq6+GlvqrX7Xm4HXSiwjj9H
         XzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717642085; x=1718246885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N0jfz+nnR88SF/3jl+2qqnrwZqfMXV0m/DMzFLp5rwQ=;
        b=QpqSdG+jz82myJ0Gib8Pxm1pguYMgTiz+t3QQrZvngpXequx5wSnjFPGSD8qUP2RcD
         q+WhK46YLhSdGMzk4T6ia85okl4cVHzLLF6e4GzFeISIfZUmpe78fwxC2qvW1Yh8aPyP
         knEk126iIXx0ZK6TDkNlbyi6Vb8r2WZVc5TMZZnheSG3ESKKau47eAo+AsN7ds6yOJ+W
         DoZlXHzSwoTSRW+q5aC0O7NW02eT/SlK9gtxTiu/mznl/lN4tyiNmPRTEkZVq8cNuvkc
         HZq878kiT7asK5YrlSe4YwVx3EPmVA7CPFvE6OfO2QmPm+4cISk4/9Ktocc6RrUCw9yv
         lw5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWTPZLx3mH/ARZ6ugYqKdoRDfASDLe4FNHLjEpPawYp3AnALCeHyVd3m1Ujt0dF/1E3Aj5N8WO733FHYKjd+hSV9Qeq/O322oMR2A==
X-Gm-Message-State: AOJu0YwAj7AN4LQOND36BA+g4Xnz8dU8bjEZNqFDTSIq0xT9camnHp8O
	za0tEf9FtNn3wPt5sq2WFna7OFC0tajt9bqozAeB0eaV9/M/0LCNOXP4r5Xp6DE=
X-Google-Smtp-Source: AGHT+IGazauN7aYw4PWByspyMiWDy+JywTjNvJ4Lkfm0DiySPRKfR6McZKYIQ8XSsbXI4yyAp55L5Q==
X-Received: by 2002:a05:651c:2224:b0:2ea:8188:5bdf with SMTP id 38308e7fff4ca-2eac7a52b99mr29005151fa.36.1717642085173;
        Wed, 05 Jun 2024 19:48:05 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2806cfa62sm2240261a91.48.2024.06.05.19.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 19:48:04 -0700 (PDT)
Message-ID: <41da824f-f3e5-429f-a701-5feddf8b2ed1@suse.com>
Date: Thu, 6 Jun 2024 10:48:00 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH dlm/next 8/8] md-cluster: use DLM_LSFL_SOFTIRQ for
 dlm_new_lockspace()
To: Alexander Aring <aahringo@redhat.com>, teigland@redhat.com,
 yukuai3@huawei.com, song@kernel.org
Cc: gfs2@lists.linux.dev, linux-raid@vger.kernel.org
References: <20240603215558.2722969-1-aahringo@redhat.com>
 <20240603215558.2722969-9-aahringo@redhat.com>
 <CAK-6q+i18_oHfdh6Odfidi0y4hWiR9bn_svWf2BwPqnLwdEFGQ@mail.gmail.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <CAK-6q+i18_oHfdh6Odfidi0y4hWiR9bn_svWf2BwPqnLwdEFGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/6/24 02:54, Alexander Aring wrote:
> Hi,
> 
> On Mon, Jun 3, 2024 at 5:56 PM Alexander Aring <aahringo@redhat.com> wrote:
>>
>> Recently the DLM subsystem introduced the flag DLM_LSFL_SOFTIRQ for
>> dlm_new_lockspace() to signal the capability to handle DLM ast/bast
>> callbacks in softirq context to avoid an additional context switch due
>> the DLM callback workqueue.
>>
>> The md-cluster implementation only does synchronized calls above the
>> async DLM API. That synchronized API should may be also offered by DLM,
>> however it is very simple as md-cluster callbacks only does a complete()
>> call for their wait_for_completion() wait that is occurred after the
>> async DLM API call. This patch activates the recently introduced
>> DLM_LSFL_SOFTIRQ flag that allows that the DLM callbacks are executed in
>> a softirq context that md-cluster can handle. It is reducing a
>> unnecessary context workqueue switch and should speed up DLM in some
>> circumstance.
>>
> 
> Can somebody with a md-cluster environment test it as well? All I was
> doing was (with a working dlm_controld cluster env):
> 
> mdadm --create /dev/md0 --bitmap=clustered --metadata=1.2
> --raid-devices=2 --level=mirror /dev/sda /dev/sdb
> 
> sda and sdb are shared block devices on each node.
> 
> Create a /etc/mdadm.conf with the content mostly out of:
> 
> mdadm --detail --scan
> 
> on each node.
> 
> Then call mdadm --assemble on all nodes where not "mdadm --create ..." happened.
> I hope that is the right thing to do and I had with "dlm_tool ls" a
> UUID as a lockspace name with some md-cluster locks being around.

The above setup method is correct.
SUSE doc [1] provides more details on assembling the clustered array.

[1]: https://documentation.suse.com/fr-fr/sle-ha/15-SP5/html/SLE-HA-all/cha-ha-cluster-md.html#sec-ha-cluster-md-create

> 
> To bring this new flag upstream, would it be okay to get this through
> dlm-tree? I am requesting here for an "Acked-by" tag from the md
> maintainers.
> 

I compiled & tested the dlm-tree [2] with SUSE CI env, and didn't see these
patches introduce new issue.

[2]: https://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git/log/?h=next

Thanks,
Heming
