Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB5227733
	for <linux-raid@vger.kernel.org>; Fri, 28 Jun 2024 12:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719577972; cv=none; b=tkPLEr9EvnWMnfYoyPi8pWDHR0rWtmfMw1nQizPo6Auwc+qoEjKpfshd1u6GNT/DTwyZH2yP8mxo5ujDAWaFn2IUlIKQvGhhG1OTsc8qWQwTo/JbI6G7N1GLyaAdZ9mhYRSv3rIQUMNCcX7uyW/Q/yAFxWDmnGQaNmWeSaI9dTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719577972; c=relaxed/simple;
	bh=iaBPWmAjxAs03uC00Lov24sHq3gppOdkjxtT/eZ421Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ID+3eEQ99kIYjpkr3SAtJOCQb1vmBiFydYc7V24h2I7s69kjuBiJKU6lNSrifX+dOhbIHYujZ9f+qOJWxSp39YHr05Mt5j9MUOylry6dyu/yN1iVE2guBhLwIcDGEAqWKpvfsyBkBS8O9xK/Szmv+k72qpYK5mdV0mDA+vtq21Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eAUVNxdV; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eAUVNxdV"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ec50a5e230so4922731fa.0
        for <linux-raid@vger.kernel.org>; Fri, 28 Jun 2024 05:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719577968; x=1720182768; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mJPA9fgz+OJ8Ymx+i1jiIj5Tq92+x5Q8SL/1PxunX8M=;
        b=eAUVNxdVCkeNxUyDfOZWjX/O1HbIKa78ywAApF5fzRrLg1zbDK2Yghy0eTD9Ul/jLa
         CJXLf1FdiSP10I3Gqk7t3rRPs5sKzEh9PoNIPEH+zFf29KHEBOzOtGKQ0WCGa957MeHj
         r86j7p/FdQAUCcWercXWLHvktikf/qnRGJucRRT0bmIwlL3X+jtfPcS7UN2P2YRzTLXM
         /VtrN5GqynD9GPvCZkj0J1+gv68wZnHszoPOL8Mj7F5Y+CZM8R2CdKAVARtHlcRoD5+5
         OjEtRNT78DCsKUaVpbfZRCRFLCv0mZzlcRbvYzQT63iwweXCb8FcorDO1p8De5kgBqh2
         dULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719577968; x=1720182768;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJPA9fgz+OJ8Ymx+i1jiIj5Tq92+x5Q8SL/1PxunX8M=;
        b=b0sRBcGIQjdu+Ky4aW7wm9vdVevPgXQQ86vxB7etaU/fehVkH2mUG4EIWt6cuoWKiV
         50tZZq5wKYXykOEPXyI/4ju/C8XArM2OXKni/3XgASX47owOD0n50rM+ll3+tzaf9c0t
         8S/UtJuplrqxOXfn2DY7GCSa2SutVFQHgZl+GxdLCBaGkR/usDShDfMsmn5F5v2VZ6uS
         pBOKHYr/3fPE4fSUG+9aN8mtxe+thpazCY0u4R2iGNmLz5Tm8MRQr0mJuFU9v/9R8z2o
         OZ8c1UPkwDee33vs92vnD7uTBSugMhYOLgw107WD+KQX95bbBZSdhK3GbRE4g3sJ3K+7
         BB/A==
X-Forwarded-Encrypted: i=1; AJvYcCWewz7Okb5q3raE7zbLcXrIaFZ/bEkdDcNWTN5vuvqkeN7l91zkDYabjNdLbS7+9n0vd7211KbNDmpYLPI2LtFwuXlEb3mxwHehwg==
X-Gm-Message-State: AOJu0Yyw1Ip0NUy0UuBFUfvpE1jYWApBz8ZWvMolD7wnaAMFR/4IYkFR
	OAVMJBrDOVk+/CyEQLxSNDQO+pfLVGtqFV8WZgbu9r0keOmeRiGcN72/c7jLxp/FhsaGpkQMFYe
	Gq/M=
X-Google-Smtp-Source: AGHT+IGrZzMtsS5mfR3c34ME57D5t8wS3W7COC40NooBeVsHKV8lIxxSbGZi347GZP+f4Zn6iurd1g==
X-Received: by 2002:a2e:7c0a:0:b0:2ed:136b:755b with SMTP id 38308e7fff4ca-2ed136b79d4mr50544061fa.53.1719577968214;
        Fri, 28 Jun 2024 05:32:48 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70802959452sm1505621b3a.90.2024.06.28.05.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jun 2024 05:32:47 -0700 (PDT)
Message-ID: <02e5b14e-aa94-430f-8e6f-f918f79a5cfb@suse.com>
Date: Fri, 28 Jun 2024 20:32:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] md-cluster: fix hanging issue while a new disk adding
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <35996c3b-fe02-f745-676b-202505763306@huaweicloud.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <35996c3b-fe02-f745-676b-202505763306@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/27/24 20:52, Yu Kuai wrote:
> Hi,
> 
> 在 2024/06/12 10:19, Heming Zhao 写道:
>> The commit 1bbe254e4336 ("md-cluster: check for timeout while a
>> new disk adding") is correct in terms of code syntax but not
>> suite real clustered code logic.
>>
>> When a timeout occurs while adding a new disk, if recv_daemon()
>> bypasses the unlock for ack_lockres:CR, another node will be waiting
>> to grab EX lock. This will cause the cluster to hang indefinitely.
>>
>> How to fix:
>>
>> 1. In dlm_lock_sync(), change the wait behaviour from forever to a
>>     timeout, This could avoid the hanging issue when another node
>>     fails to handle cluster msg. Another result of this change is
>>     that if another node receives an unknown msg (e.g. a new msg_type),
>>     the old code will hang, whereas the new code will timeout and fail.
>>     This could help cluster_md handle new msg_type from different
>>     nodes with different kernel/module versions (e.g. The user only
>>     updates one leg's kernel and monitors the stability of the new
>>     kernel).
>> 2. The old code for __sendmsg() always returns 0 (success) under the
>>     design (must successfully unlock ->message_lockres). This commit
>>     makes this function return an error number when an error occurs.
>>
>> Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk adding")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> Reviewed-by: Su Yue <glass.su@suse.com>
>> ---
>>   drivers/md/md-cluster.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index 8e36a0feec09..27eaaf9fef94 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -130,8 +130,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
>>               0, sync_ast, res, res->bast);
>>       if (ret)
>>           return ret;
>> -    wait_event(res->sync_locking, res->sync_locking_done);
>> +    ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
>> +                60 * HZ);
> 
> Let's not use magic number directly, it's better to define a marco. BTW,
> 60s looks too long for me.

got it, will create a define:
#define WAIT_DLM_LOCK_TIMEOUT 30 * HZ

In my view, the shortest time should be 30s. because there is a clustered env.
Node A is waiting for node B to release the lock.
We should consider:
- network traffic (node A and B are not in the same build)
- another node's udev event handling time: NEW_DEV_TIMEOUT 5000

>>       res->sync_locking_done = false;
> 
> And I tried to find, if setting this value on failure is ok. However,
> I'm lost and I really don't know. Can you explain this?

This code logic is the same as dlm_lock_sync_interruptible(). We can
see that regardless of success or failure, '->sync_locking_done' is
set to false in dlm_lock_sync_interruptible().

>> +    if (!ret) {
>> +        pr_err("locking DLM '%s' timeout!\n", res->name);
>> +        return -EBUSY;
>> +    }
>>       if (res->lksb.sb_status == 0)
>>           res->mode = mode;
>>       return res->lksb.sb_status;
>> @@ -744,12 +749,14 @@ static void unlock_comm(struct md_cluster_info *cinfo)
>>   static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>   {
>>       int error;
>> +    int ret = 0;
>>       int slot = cinfo->slot_number - 1;
>>       cmsg->slot = cpu_to_le32(slot);
>>       /*get EX on Message*/
>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>>       if (error) {
>> +        ret = error;
> 
> You can return error directly in this branch.

OK

>>           pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
>>           goto failed_message;
>>       }
>> @@ -759,6 +766,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>       /*down-convert EX to CW on Message*/
>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
>>       if (error) {
>> +        ret = error;
>>           pr_err("md-cluster: failed to convert EX to CW on MESSAGE(%d)\n",
>>                   error);
>>           goto failed_ack;
>> @@ -767,6 +775,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>       /*up-convert CR to EX on Ack*/
>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
>>       if (error) {
>> +        ret = error;
>>           pr_err("md-cluster: failed to convert CR to EX on ACK(%d)\n",
>>                   error);
>>           goto failed_ack;
>> @@ -775,6 +784,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>       /*down-convert EX to CR on Ack*/
>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
>>       if (error) {
>> +        ret = error;
>>           pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
>>                   error);
>>           goto failed_ack;
>> @@ -789,7 +799,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>           goto failed_ack;
>>       }
>>   failed_message:
>> -    return error;
>> +    return ret;
> 
> And I'll suggest just to change dlm_unlock_sync(), not to change all the
> other places.
> 

I have a different viewpoint, the clustermd code has been running for about 10
years, and no bugs have been reported from SUSE customers for about 1 year. I am
inclined to keep the current code style. If we change dlm_unlock_sync(), many
places will need to be rewritten, which may introduce new bugs. From the callers
of this func (__sendmsg()), which handle the return value, we know it's
definitely wrong because the return value of __sendmsg() is always true.

-Heming
