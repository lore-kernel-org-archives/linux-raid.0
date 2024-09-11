Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633DB14EC56
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044154; cv=none; b=JGvr72d5WW2+O2QpTG5AtRIn2RU/GlmcOkspLeO2EaT/1y9mIL0KKzgD0Gulpbxe7GHy51lnTlc/KxOS9paU75vwJ4+3MQcg2FnE9/KeiN6vmJsL96Yso5kMX8iborjviVWo0/ZyN9SRw2eUWqipTVUobzjQGRuvnZzalFN8IVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044154; c=relaxed/simple;
	bh=5HQgs6SycoyA9cGAEXF8GRha/NyDpyQFG9/RNaMtnYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g4VSDiapKmuvbXDMYoqOnp1h4nTrT8B3sBBJuHJxvhG0Fq9yT2gM8IT+zCTmyj4zpQad7H8fT/DPu2yDlWDPKtcuS+8YVKuYeeZ8b56qYDJZ7xWIh+a+RYUGE+A6agVsNeYjgfekaoZ/6R3ggjVxqzvNf3wot3yraiAtaTKw5/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CSSC+tEV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CSSC+tEV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gw1XAMyrh4q2MbA6NOn6cDlDH3qIMtpHD2I1w9q9Oe0=;
	b=CSSC+tEVvUag/sCr5dhKYlHhidgc/LmIbNsZfWU3w0ATXy4cl0CNaKrXZ64ICPGWRJOw8c
	wN1UtLAdwjy7Q5GJHeaq2T7e5Gg4/YPFYfJxFAmFDAZp7ll2jSq0VxczmFd/rdnWDOo0Ro
	LIL3BWN5v8pV5fgZ4PiNa8iDaticyrQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-OQnnUPMVNjKnEi9XFl8mlw-1; Wed, 11 Sep 2024 04:42:30 -0400
X-MC-Unique: OQnnUPMVNjKnEi9XFl8mlw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-718e82769aeso2795924b3a.0
        for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 01:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726044149; x=1726648949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gw1XAMyrh4q2MbA6NOn6cDlDH3qIMtpHD2I1w9q9Oe0=;
        b=ZjyncAv6bk7akaOFRwhWSE76mwGhEoDXbdp6gv3UBFRDBSwOnhLo6KYJ+wNCNVlb+v
         7bkMBNArDM15Z1VpEXOcnXLu1W4YsHYVWUk5vE8cLUPm7fZkdxmqez0uSWqLFxJ5mctu
         Y+l+DuZ+2+Q9FkkNuLHpb6darjEGDhzTl6dPpxcAbHHTRoG5WL8cEUa/eCvsbeVZGNgR
         PrpLf1+shfVLn11CVmDGFV1SPsSAM8Z4bIdRwsWC9WQe1JJBshlFv4jbGA9YeBLtu00Z
         oxEArOI3r3oTYtUiBr/E5fUtEVFVvIOgo9q2hKaV90xa7S/ZyNvvH3geWzS08q0tn9ZW
         NOJA==
X-Gm-Message-State: AOJu0YzLvYFcw63Y1zRa65lIN2AXIWT1J3DA6zFD8b9k+ZpeBcD+Dyp0
	1tWom6LN9PeQnjvlRiO3zzT64dAgbndQXRWAz+VXaJZpzZ8qoZZ6r3Yv4icbHZSRY+xfVj1m0RJ
	lz53RJqkrilZFTiFegTQxC0Pk6VgpdAcJuVWyHbSyzEykwTUVfqANYAtRb1Q=
X-Received: by 2002:a05:6a00:9a1:b0:713:f127:ad5f with SMTP id d2e1a72fcca58-71916e98be4mr3904713b3a.22.1726044148681;
        Wed, 11 Sep 2024 01:42:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpOvgqyF+dWvfdbUquEhMv/Ztv4ADSoMEfGRb9+S4TZutlokbdhA3YuXpRWAJ6a+6C1PP9vA==
X-Received: by 2002:a05:6a00:9a1:b0:713:f127:ad5f with SMTP id d2e1a72fcca58-71916e98be4mr3904677b3a.22.1726044148140;
        Wed, 11 Sep 2024 01:42:28 -0700 (PDT)
Received: from [10.72.120.25] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7190900482esm2608044b3a.92.2024.09.11.01.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 01:42:27 -0700 (PDT)
Message-ID: <87faa501-40de-4607-835b-e9c4f3b1d908@redhat.com>
Date: Wed, 11 Sep 2024 16:42:22 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] mdadm/Grow: sleep a while after removing disk in
 impose_level
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>
References: <20240828021150.63240-1-xni@redhat.com>
 <20240828021150.63240-5-xni@redhat.com>
 <20240902121359.00007a84@linux.intel.com>
 <CALTww29ApVRidDFfgM7N-yM0NqBa2_X5yu3uWPTAZ1aGe_QHNg@mail.gmail.com>
 <20240903092214.00000d1d@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20240903092214.00000d1d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/9/3 下午3:22, Mariusz Tkaczyk 写道:
> On Tue, 3 Sep 2024 08:53:42 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
>> On Mon, Sep 2, 2024 at 6:14 PM Mariusz Tkaczyk
>> <mariusz.tkaczyk@linux.intel.com> wrote:
>>> On Wed, 28 Aug 2024 10:11:44 +0800
>>> Xiao Ni <xni@redhat.com> wrote:
>>>   
>>>> It needs to remove disks when reshaping from raid456 to raid0. In
>>>> kernel space it sets MD_RECOVERY_RUNNING. And it will fail to change
>>>> level. So wait sometime to let md thread to clear this flag.
>>>>
>>>> This is found by test case 05r6tor0.
>>>>
>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>>> ---
>>>>   Grow.c | 6 ++++++
>>>>   1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/Grow.c b/Grow.c
>>>> index 2a7587315817..aaf349e9722f 100644
>>>> --- a/Grow.c
>>>> +++ b/Grow.c
>>>> @@ -3028,6 +3028,12 @@ static int impose_level(int fd, int level, char
>>>> *devname, int verbose) makedev(disk.major, disk.minor));
>>>>                        hot_remove_disk(fd, makedev(disk.major, disk.minor),
>>>> 1); }
>>>> +             /*
>>>> +              * hot_remove_disk lets kernel set MD_RECOVERY_RUNNING
>>>> +              * and it can't set level. It needs to wait sometime
>>>> +              * to let md thread to clear the flag.
>>>> +              */
>>>> +             sleep_for(5, 0, true);
>>>   
>> Hi Mariusz
>>
>>> Shouldn't we check sysfs is shorter intervals? I know that is the simplest
>>> way but big sleeps are generally not good.
>>>
>>> I will merge it if you don't want to rework it but you need to add log that
>>> we are waiting 5 second for the user to not panic that it is frozen.
>> Which sysfs do you mean? If we have a better way, I want to choose it.
>>
> If we are sending hot remove to the disk, we can check if there is path
> available: /sys/block/<mddev>/md/dev-{devnm}
> if not, then device has been finally removed.
> Eventually, we can see same in mdstat but checking path looks simpler to me.
>
> Thanks,
> Mariusz


Hi Mariusz

I check you method and it doesn't work. There are two steps in kernel 
space and they are async.

1. remove disk including remove the sysfs directory, set 
MD_RECOVERY_NEEDED and wake up md thread

2. Because MD_RECOVERY_NEEDED is set, kernel space sets 
MD_RECOVERY_RUNNING and queue a sync work. It doesn't do anything and 
clear MD_RECOVERY_RUNNING

So there is a time window. It depends on machines. Sometimes it fails 
when setting new level because MD_RECOVERY_RUNNING is set. Maybe we can 
add some check when removing disk. If it doesn't need to do 
sync/recovery, we don't need to set MD_RECOVERY_NEEDED. But now, we can 
add a sleep here as a solution. I'll add a log here to give admin.

Best Regards

Xiao


