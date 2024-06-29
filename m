Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FD820B35
	for <linux-raid@vger.kernel.org>; Sat, 29 Jun 2024 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719662344; cv=none; b=mHAvi+IfFsxYsRZUyDxl2b9dMorV1ZedHB0qgrAJ7pibfWoNdA25CwbgwQOLW6fPrui9jQOP8k8+8bk7OLwkEXTJuaAqQ4POF3OphoZ0V2WOqJ1yNYkup1el1K6vwLs8dpCUNr20zXd5Vlxwna5CSAduwc43NP4BPbWsr/1GbJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719662344; c=relaxed/simple;
	bh=hOJyk6JfG5nr2LVDp/krsrn5pKsr+ZrrXSSLHWhmixM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ML3n5xwy863d6qtxixjLE17ZKwvdfgUJfzWLUqMb+kBUEQb6cgJKL+RauUy++dkZRab+jQVR39CiGT8a2IHhIkkL5wkwRbN2Jf7WnY/0syqG/cl5M8HacH4UjH6DCNZe9wXfqW/D5Y39aYpIxv7FAFGH1EjTTftn04/SfwdN0zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VIGeIZGn; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VIGeIZGn"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2ec3f875e68so15378741fa.0
        for <linux-raid@vger.kernel.org>; Sat, 29 Jun 2024 04:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719662340; x=1720267140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kl/adR57vWq4L06PUoxUa1WbF9lJ9fVZxGtxuj9YM6A=;
        b=VIGeIZGnHnYODeP3HyOMoDdxOx0VBEYxPualnbuBjGZR45Nc56U8B/Q6iYLNAATWWf
         RZLb2sXvXCXSD9E/9Z8hSddS6oCb6nGGzOtbeCyM5sz5eZM9ChJVFZALmV3C3N04NeQS
         go9IM5XGYuzMwn3Lei2gjxJLmzaD4N1fdILPWc9tH4wqP9oLwSd5ZBY9FhghqiDE3mbL
         IidlMHKyIJxjCOxdUvk7Ufz/4F952eBn+5xBt2vn6ZvD44IU4VZBkOxXXW84fqPVFbuB
         o9ZcBNHo4JNMXhAy4JuD+TJvmDXIhZIohd63DZiN0yJnLjRADLIgRleyTlKPbGXsLPrm
         DZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719662340; x=1720267140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kl/adR57vWq4L06PUoxUa1WbF9lJ9fVZxGtxuj9YM6A=;
        b=g651zVx5L0SQcR91q33HFDJiGyT9KlQSj4lKhqb0zEkE/Dcw5QqcrjmUQVQDuOqi+7
         iY13OhP8hi6A+yWFTjq15ZpTcefRNe/8dsqdesBwCHb1rjdkzOFYMv+MrILlU68dvpkR
         Sf6sTgy2/GRRk2OhknhG8jkSQBw7h5M+iiCw+cmbvQTttCnb8UIqxO8nCv+fO8xqKN0w
         7+t/FwzQUWJZuXT8P2pg8szBq2iZ8Hzue3jI7V92GXIq58HLI7hd5xxHbCgNl3SR+0zS
         7RBOBLcRACLOpkgLcURGLyZIzV8U0jGwW0gWTWRFLgT1j8cMX4Bk9ThFM1Az5+Iombso
         JOYg==
X-Forwarded-Encrypted: i=1; AJvYcCU+X0d6rJiweYhxSs+wsCvny4azbo1fvJQseO+af0p8wG2XIfpZG8hPOA5v10uzWZclBk1hX1C35aLMl3+4ZwviqCW5VXcyCMXsQA==
X-Gm-Message-State: AOJu0YyztpzIDLZL0cdxAcpDfLdlznTyknFOQR1/KHQa8iCPjcOjxAts
	xMDp2Jy6klb+KChSqOoePZDeoy8iN7nw/+YTOBDnpfWuoxwbGm472s6lPs+FNXQ=
X-Google-Smtp-Source: AGHT+IH8asJqwYH7DbS9xWajBS7JlNcr1tnJL1xrXJg/ZRJXAp+7eKt7SZIihwmTHNUEFDUTgdHLZA==
X-Received: by 2002:a2e:9f03:0:b0:2ec:541b:4b4e with SMTP id 38308e7fff4ca-2ee5e6ba6fdmr6013161fa.32.1719662340122;
        Sat, 29 Jun 2024 04:59:00 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-708042be4e6sm3138637b3a.153.2024.06.29.04.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jun 2024 04:58:59 -0700 (PDT)
Message-ID: <3360e170-6a64-40e7-a213-e816cd725d31@suse.com>
Date: Sat, 29 Jun 2024 19:58:55 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] md-cluster: fix hanging issue while a new disk adding
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <35996c3b-fe02-f745-676b-202505763306@huaweicloud.com>
 <02e5b14e-aa94-430f-8e6f-f918f79a5cfb@suse.com>
 <72588c14-cfd0-e927-50e2-00519a9b77e0@huaweicloud.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <72588c14-cfd0-e927-50e2-00519a9b77e0@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/29/24 09:42, Yu Kuai wrote:
> Hi,
> 
> 在 2024/06/28 20:32, Heming Zhao 写道:
>> On 6/27/24 20:52, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2024/06/12 10:19, Heming Zhao 写道:
>>>> The commit 1bbe254e4336 ("md-cluster: check for timeout while a
>>>> new disk adding") is correct in terms of code syntax but not
>>>> suite real clustered code logic.
>>>>
>>>> When a timeout occurs while adding a new disk, if recv_daemon()
>>>> bypasses the unlock for ack_lockres:CR, another node will be waiting
>>>> to grab EX lock. This will cause the cluster to hang indefinitely.
>>>>
>>>> How to fix:
>>>>
>>>> 1. In dlm_lock_sync(), change the wait behaviour from forever to a
>>>>     timeout, This could avoid the hanging issue when another node
>>>>     fails to handle cluster msg. Another result of this change is
>>>>     that if another node receives an unknown msg (e.g. a new msg_type),
>>>>     the old code will hang, whereas the new code will timeout and fail.
>>>>     This could help cluster_md handle new msg_type from different
>>>>     nodes with different kernel/module versions (e.g. The user only
>>>>     updates one leg's kernel and monitors the stability of the new
>>>>     kernel).
>>>> 2. The old code for __sendmsg() always returns 0 (success) under the
>>>>     design (must successfully unlock ->message_lockres). This commit
>>>>     makes this function return an error number when an error occurs.
>>>>
>>>> Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk adding")
>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>> Reviewed-by: Su Yue <glass.su@suse.com>
>>>> ---
>>>>   drivers/md/md-cluster.c | 14 ++++++++++++--
>>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>>> index 8e36a0feec09..27eaaf9fef94 100644
>>>> --- a/drivers/md/md-cluster.c
>>>> +++ b/drivers/md/md-cluster.c
>>>> @@ -130,8 +130,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
>>>>               0, sync_ast, res, res->bast);
>>>>       if (ret)
>>>>           return ret;
>>>> -    wait_event(res->sync_locking, res->sync_locking_done);
>>>> +    ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
>>>> +                60 * HZ);
>>>
>>> Let's not use magic number directly, it's better to define a marco. BTW,
>>> 60s looks too long for me.
>>
>> got it, will create a define:
>> #define WAIT_DLM_LOCK_TIMEOUT 30 * HZ
>>
>> In my view, the shortest time should be 30s. because there is a clustered env.
>> Node A is waiting for node B to release the lock.
>> We should consider:
>> - network traffic (node A and B are not in the same build)
>> - another node's udev event handling time: NEW_DEV_TIMEOUT 5000
>>
>>>>       res->sync_locking_done = false;
>>>
>>> And I tried to find, if setting this value on failure is ok. However,
>>> I'm lost and I really don't know. Can you explain this?
>>
>> This code logic is the same as dlm_lock_sync_interruptible(). We can
>> see that regardless of success or failure, '->sync_locking_done' is
>> set to false in dlm_lock_sync_interruptible().
>>
>>>> +    if (!ret) {
>>>> +        pr_err("locking DLM '%s' timeout!\n", res->name);
>>>> +        return -EBUSY;
>>>> +    }
>>>>       if (res->lksb.sb_status == 0)
>>>>           res->mode = mode;
>>>>       return res->lksb.sb_status;
>>>> @@ -744,12 +749,14 @@ static void unlock_comm(struct md_cluster_info *cinfo)
>>>>   static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>>   {
>>>>       int error;
>>>> +    int ret = 0;
>>>>       int slot = cinfo->slot_number - 1;
>>>>       cmsg->slot = cpu_to_le32(slot);
>>>>       /*get EX on Message*/
>>>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>>>>       if (error) {
>>>> +        ret = error;
>>>
>>> You can return error directly in this branch.
>>
>> OK
>>
>>>>           pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
>>>>           goto failed_message;
>>>>       }
>>>> @@ -759,6 +766,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>>       /*down-convert EX to CW on Message*/
>>>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
>>>>       if (error) {
>>>> +        ret = error;
>>>>           pr_err("md-cluster: failed to convert EX to CW on MESSAGE(%d)\n",
>>>>                   error);
>>>>           goto failed_ack;
>>>> @@ -767,6 +775,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>>       /*up-convert CR to EX on Ack*/
>>>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
>>>>       if (error) {
>>>> +        ret = error;
>>>>           pr_err("md-cluster: failed to convert CR to EX on ACK(%d)\n",
>>>>                   error);
>>>>           goto failed_ack;
>>>> @@ -775,6 +784,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>>       /*down-convert EX to CR on Ack*/
>>>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
>>>>       if (error) {
>>>> +        ret = error;
>>>>           pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
>>>>                   error);
>>>>           goto failed_ack;
>>>> @@ -789,7 +799,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>>           goto failed_ack;
>>>>       }
>>>>   failed_message:
>>>> -    return error;
>>>> +    return ret;
>>>
>>> And I'll suggest just to change dlm_unlock_sync(), not to change all the
>>> other places.
>>>
>>
>> I have a different viewpoint, the clustermd code has been running for about 10
>> years, and no bugs have been reported from SUSE customers for about 1 year. I am
>> inclined to keep the current code style. If we change dlm_unlock_sync(), many
>> places will need to be rewritten, which may introduce new bugs. From the callers
>> of this func (__sendmsg()), which handle the return value, we know it's
>> definitely wrong because the return value of __sendmsg() is always true.
> 
> That's not what I mean... Let me show you the code:
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index eb9bbf12c8d8..11a3c9960a22 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -744,6 +744,7 @@ static void unlock_comm(struct md_cluster_info *cinfo)
>   static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>   {
>          int error;
> +       int unlock_error;
>          int slot = cinfo->slot_number - 1;
> 
>          cmsg->slot = cpu_to_le32(slot);
> @@ -781,13 +782,9 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>          }
> 
>   failed_ack:
> -       error = dlm_unlock_sync(cinfo->message_lockres);
> -       if (unlikely(error != 0)) {
> +       while ((unlock_error = dlm_unlock_sync(cinfo->message_lockres)))
>                  pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
> -                       error);
> -               /* in case the message can't be released due to some reason */
> -               goto failed_ack;
> -       }
> +                       unlock_error);
>   failed_message:
>          return error;
> 

Your idea/code is better. I will use them in v2 patch.

Thanks,
Heming

