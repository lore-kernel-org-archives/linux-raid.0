Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F8F73444
	for <linux-raid@vger.kernel.org>; Thu,  6 Jun 2024 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717714567; cv=none; b=he99uvq198/Wo3D8ttlE1Yi++JDk89L+jNhTNk5Qb+WtgYozCjDTOg4+rSx5opDZxHaOWMYm4gIHquoWt+HhEjBfpbtZJN77S7Hpe8Z+RIla+xmNCQWKo0DosCjpXVXzQv5u+LK4MEuS96o5ozNpiEYbrTfRsS/ieykqmKgB+94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717714567; c=relaxed/simple;
	bh=zfAJG/dx/KFbiaQWm7ckdwQg8HMwx0/Tpc294oA8f9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3AMAgx403lcZvvcFE/DI1XcAZ0+3LD/oRmR2ZFqRykFnAGsh53/ef+Z5JDdHl1AsxX+txzRpAO1mGF1ur7pWhMNIXrmAHwkb7HXkM52Tn7YW61PuZvfBxOaXGurM9d+eL7jJhxJ4aTEswViHxAB97YMQfKRGLrrOBedxZRzCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MDGRHWbq; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MDGRHWbq"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ead2c6b553so19172591fa.0
        for <linux-raid@vger.kernel.org>; Thu, 06 Jun 2024 15:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717714563; x=1718319363; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wbs9P3xx67wtMJaRxm+g35qxE1ZC9ShgycTHRHTMd/0=;
        b=MDGRHWbqLPlZa37r6Hp7dZ2O4c7J6gYDmHzHK1/36AYv4qPu0LAa8JJcLfJqQZmCTL
         NWLt2sjbtsWJbGu2mQR7uq3pHd5kwr0jyxcznzMSg2Mw+4E5IrdX38vUN/+iX4NrxAYH
         xdaHNZX10igxAJi49ixrli3A4Q8A4QrN9rljL9HaOU3Jy/qw/y5ONZfdGjPhL7hr18EP
         Oq+5woyznFWRyVbH67YiQshVVqSEgExe2bH2w9i5ZwPlmQGLkT7KsdtBUOTpIKPAk2/9
         zaS3RJLeqh6KVREuR0KQK9/7inwZG68r+/vpJpaZ3BxEOHhcKTEoegFS1o+gBaW3x9Ii
         EJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717714563; x=1718319363;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wbs9P3xx67wtMJaRxm+g35qxE1ZC9ShgycTHRHTMd/0=;
        b=lzK5oavIK+NxSuChL/sMV4SrX35GKjA8bLi5ipk3uODlW3bghQ3BZr/gv+JDx2WRfm
         wsfbj0uJWkWSktC67nQk8P0GAvMWDeMQp8F65GaKRV97gpmORn6AHCr2njMts21Ol72S
         F19g9Xo7ZlR8YRzuxSJVXPZLyM6Wi2w9w82MYK4ehVoNOfu4HVHF30D0inlLq0JieHCu
         7bAqCncXWyt96XcLO+H6rLdRp6uQepzjja7BZGlpuVv56krzDv2tVEQzLXwwQu/5twk4
         6Hkkv++9NcolMU6gc3uVLOPSlTVhs5nSUtNj9KfPhHqMT11N1pZmiuXo6Sw48lAsY6j9
         5Y2w==
X-Forwarded-Encrypted: i=1; AJvYcCXFYT9T21LaQF2LgNTVNgDkwHITOG9QHBQeu6bWzG7Lnugr5T0q59eqycJVOg++nS6arTeXoCBeH0rpI/7QQWoA9GzrtqFw714kyg==
X-Gm-Message-State: AOJu0Yw2QPsRGL/qZ5sD8nuti+8CNEmPct2EoXlX3GPDcI4XFPOKGcJO
	cXp0TQ2zqslIJaNJFz/+7yi99GdyDnFpWq5Y5f8n6ZwlzppzKul+B4F/KvUuluQ=
X-Google-Smtp-Source: AGHT+IFRoEqtOm0yBbVkLY6IAaHoO2ld+VdSDl2ACdRQg+LI9L5GcqN6rdfFi/Yx03Au0JrnqNijSw==
X-Received: by 2002:a05:651c:d2:b0:2ea:7f78:6d56 with SMTP id 38308e7fff4ca-2eadce258dbmr7409261fa.3.1717714562633;
        Thu, 06 Jun 2024 15:56:02 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6de221268cesm1618305a12.38.2024.06.06.15.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 15:56:02 -0700 (PDT)
Message-ID: <b8a06dae-23f8-4684-b969-5d9ca409917b@suse.com>
Date: Fri, 7 Jun 2024 06:55:58 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH dlm/next 8/8] md-cluster: use DLM_LSFL_SOFTIRQ for
 dlm_new_lockspace()
To: Alexander Aring <aahringo@redhat.com>, yukuai3@huawei.com, song@kernel.org
Cc: teigland@redhat.com, gfs2@lists.linux.dev, linux-raid@vger.kernel.org
References: <20240603215558.2722969-1-aahringo@redhat.com>
 <20240603215558.2722969-9-aahringo@redhat.com>
 <CAK-6q+i18_oHfdh6Odfidi0y4hWiR9bn_svWf2BwPqnLwdEFGQ@mail.gmail.com>
 <41da824f-f3e5-429f-a701-5feddf8b2ed1@suse.com>
 <CAK-6q+j0rbQ2CZ9y9wxZBUxsgGV03nF+ahVZPJEQPoUW-Mc8nQ@mail.gmail.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <CAK-6q+j0rbQ2CZ9y9wxZBUxsgGV03nF+ahVZPJEQPoUW-Mc8nQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/6/24 22:33, Alexander Aring wrote:
> Hi Heming,
> 
> On Wed, Jun 5, 2024 at 10:48 PM Heming Zhao <heming.zhao@suse.com> wrote:
>>
>> On 6/6/24 02:54, Alexander Aring wrote:
>>> Hi,
>>>
>>> On Mon, Jun 3, 2024 at 5:56 PM Alexander Aring <aahringo@redhat.com> wrote:
>>>>
>>>> Recently the DLM subsystem introduced the flag DLM_LSFL_SOFTIRQ for
>>>> dlm_new_lockspace() to signal the capability to handle DLM ast/bast
>>>> callbacks in softirq context to avoid an additional context switch due
>>>> the DLM callback workqueue.
>>>>
>>>> The md-cluster implementation only does synchronized calls above the
>>>> async DLM API. That synchronized API should may be also offered by DLM,
>>>> however it is very simple as md-cluster callbacks only does a complete()
>>>> call for their wait_for_completion() wait that is occurred after the
>>>> async DLM API call. This patch activates the recently introduced
>>>> DLM_LSFL_SOFTIRQ flag that allows that the DLM callbacks are executed in
>>>> a softirq context that md-cluster can handle. It is reducing a
>>>> unnecessary context workqueue switch and should speed up DLM in some
>>>> circumstance.
>>>>
>>>
>>> Can somebody with a md-cluster environment test it as well? All I was
>>> doing was (with a working dlm_controld cluster env):
>>>
>>> mdadm --create /dev/md0 --bitmap=clustered --metadata=1.2
>>> --raid-devices=2 --level=mirror /dev/sda /dev/sdb
>>>
>>> sda and sdb are shared block devices on each node.
>>>
>>> Create a /etc/mdadm.conf with the content mostly out of:
>>>
>>> mdadm --detail --scan
>>>
>>> on each node.
>>>
>>> Then call mdadm --assemble on all nodes where not "mdadm --create ..." happened.
>>> I hope that is the right thing to do and I had with "dlm_tool ls" a
>>> UUID as a lockspace name with some md-cluster locks being around.
>>
>> The above setup method is correct.
>> SUSE doc [1] provides more details on assembling the clustered array.
>>
> 
> yea, I saw that and mostly cut it down into the necessary steps in my
> development setup.
> 
> Thanks for confirming I did something right here.
> 
>> [1]: https://documentation.suse.com/fr-fr/sle-ha/15-SP5/html/SLE-HA-all/cha-ha-cluster-md.html#sec-ha-cluster-md-create
>>
>>>
>>> To bring this new flag upstream, would it be okay to get this through
>>> dlm-tree? I am requesting here for an "Acked-by" tag from the md
>>> maintainers.
>>>
>>
>> I compiled & tested the dlm-tree [2] with SUSE CI env, and didn't see these
>> patches introduce new issue.
>>
> 
> Thanks for doing that. So that means you tried the dlm-tree with this
> patch series applied?

Yes.

-Heming

> 
> Song or Yu, can I get an "Acked-by" from you and an answer if it is
> okay that this md-cluster.c patch goes upstream via dlm-tree?
> 
> Thanks.
> 
> - Alex
> 

