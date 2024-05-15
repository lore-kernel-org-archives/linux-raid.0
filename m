Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DED4CB58
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 17:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715794986; cv=none; b=glifv6TeH99yNupwDOAYmhcbys6LtZAwmvHoyrJMet3yQbAYbIMgMw8fFAmFXCTrdOEfeQXUx75k7nna2EpzQsVgWLDortUagdPy5rmZS6JnrUQvPFT1LJo5QdhXnac57ADwXUXhJh5lKaG8HyIjVbng1q9XVEQo68dyvq1qjyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715794986; c=relaxed/simple;
	bh=c15gIcAexpZS/JUGxBDHg/+s1QYkHJet5ANXnfTfoMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEuoc5dxG3JjRNZMccRJbDo7Pc/Z4D7eWx/rNTm9GrkNtx6WWh42byKrEzJbC3qOpwyeArXaATTD3W936p5fmxkFevQuAggT6i2etfriWiI9nOWYU5XE19foInPIxYueUdQ5sD29s2cBg9LJcpQoj1EQ9qJEnib7XnlBXelARw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SGNUMjwQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGNUMjwQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715794984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dGViqbhhY2m0sTya6PcmAEaHoC4oTHzeuV6Gu59rwm0=;
	b=SGNUMjwQHKA6Sn7lDYt9QpR5aE39BsUaxfym2/E1YyziYAfQoN+zI5uHxdLKd1xx7NnMGR
	S8A9eaVYOM7c4kKfbIStfaWB1O8LqiUcHr/CqN9G6f2WvBxsOlS4ejtaYPOzfDkDulJ/fi
	uzaGF8jw0VUYs/iPf4zhOCgx8zI66rk=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-FqE2B27UNIuvuEdMqahPEg-1; Wed, 15 May 2024 13:42:57 -0400
X-MC-Unique: FqE2B27UNIuvuEdMqahPEg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3c9a9094719so2766399b6e.0
        for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 10:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715794976; x=1716399776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGViqbhhY2m0sTya6PcmAEaHoC4oTHzeuV6Gu59rwm0=;
        b=SmZT1HjyfchD+u3JdOpgvi5qGKfW/TBHjUU6QdL8E0sN5zmZIGc+9KWf7JZx05Bz+K
         6TPSiRpd6sZRNIf9yfCq1+MpT5o4wLnQZLZLBw1mn8SrsiKf4zDRX07ERnISDHEwfwnI
         uuMWIPaNJqRwlRt5lqj9cPtDMHx6eaCHkhVvvfL1W3H2UAx4nPK/rEQJatgYAP0sBdtd
         aqdEQJlDrWvjIhXrxcGInmqxGyDVq6rKf2jluPZRDqELdzVkP4lm3ae/xtkocLHwkHMf
         AFzi6nIS1JBXSk7jWiuQKXl6DGBEFq/WB2tJL1So8SNK9cKASqGDsctlpshyeaIRiIzS
         mXVQ==
X-Gm-Message-State: AOJu0Yx9jF38t3oNUI58ILP40N/22Sb9FknnoPYeRt/o3dSWt4VWGhHy
	+5J4RhdfTn6PW9th0N9a5ElUEbW7DqIpAYevK+KfDFh1bk0D51Bew3ONCvcMjLvkrO3zs4URFlW
	mxhA87ow3C1v/NAK3CHmF9Tas5YkG3C7THC2HKkxfhVhClBD7DOCeceo518o=
X-Received: by 2002:a05:6808:302c:b0:3c9:3d98:8098 with SMTP id 5614622812f47-3c9970ba37cmr19780261b6e.45.1715794975923;
        Wed, 15 May 2024 10:42:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmGhUGNNoIQxBUePw3I4w2Yddo38KOPWFTN70NYTYJuWR5A1n71PA2PFfXejE6qgwF8Yi+7g==
X-Received: by 2002:a05:6808:302c:b0:3c9:3d98:8098 with SMTP id 5614622812f47-3c9970ba37cmr19780183b6e.45.1715794973950;
        Wed, 15 May 2024 10:42:53 -0700 (PDT)
Received: from [192.168.50.193] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf27519esm703114485a.1.2024.05.15.10.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 10:42:53 -0700 (PDT)
Message-ID: <779c434a-bbbe-4345-842d-607d8ea83a8c@redhat.com>
Date: Wed, 15 May 2024 13:42:52 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] add checking of return status on fstat calls
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
 Xiao Ni <xni@redhat.com>, Jes Sorensen <jes@trained-monkey.org>
References: <bc9e94e6-96c5-411b-977b-30aea31cf9c3@redhat.com>
 <20240515144501.000048ad@linux.intel.com>
Content-Language: en-US
From: Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <20240515144501.000048ad@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/15/24 8:45 AM, Mariusz Tkaczyk wrote:
> On Wed, 15 May 2024 07:55:57 -0400
> Nigel Croxon <ncroxon@redhat.com> wrote:
>
>>  From 99c48231fe50845f622572d10fbb91a5ece0501f Mon Sep 17 00:00:00 2001
>> From: Nigel Croxon <ncroxon@redhat.com>
>> Date: Fri, 10 May 2024 09:08:02 -0400
>> Subject: [PATCH] add checking of return status on fstat calls
>>
>> There are a few places we don't check the return status when
>> calling fstat for success. Clean up the calls by adding a
>> check before continuing.
>>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>> ---
> Hi Nigel,
> I'm observing following errors:
>
> warning: Patch sent with format=flowed; space at the end of lines might be lost.
> Applying: add checking of return status on fstat calls
> error: corrupt patch at line 16
> Patch failed at 0001 add checking of return status on fstat calls
> ----
>
> Probably you need to rebase patch to current main.
>
> I also see, some checkpatch issues like "rv=0".
> At this moment, you can just fork the github repo:
> https://github.com/md-raid-utilities/mdadm
>
> and open pull request, then checkpatch will be automatically run for you :)
>
> Thanks,
> Mariusz
>
Hello Mariusz,

https://github.com/md-raid-utilities/mdadm/pull/7

-Nigel


