Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D2AC433FE
	for <linux-raid@archiver.kernel.org>; Fri, 30 Sep 2022 05:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiI3FXk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Sep 2022 01:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiI3FXh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Sep 2022 01:23:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB3612889B
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 22:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664515413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f/RDSK31Z+Sg4YDG+YoeSfPbie/AyHwm2btPCvtDATo=;
        b=S4mKglF15S0zgx++my59ZCEkQh9Riv5wPOikY5sw3o++lxW+Hr6qTX6CLEQVG5SiL9drrm
        +1yJG5jNzDHfcn3HSOGVjW1cTSPMa7Wzz46aPy344nOgCu18jTNLEgGDs2JDBJUqgYW8FQ
        evBEd5JdGRV8CvQgPybHBbAyhl+i4Ng=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-225-Nd842QSaNbeAytjcpFB51Q-1; Fri, 30 Sep 2022 01:23:30 -0400
X-MC-Unique: Nd842QSaNbeAytjcpFB51Q-1
Received: by mail-pj1-f70.google.com with SMTP id ru14-20020a17090b2bce00b00205cc5a4e8eso1694218pjb.6
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 22:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=f/RDSK31Z+Sg4YDG+YoeSfPbie/AyHwm2btPCvtDATo=;
        b=cgVCEuB9G49mFgxhPMXhnscXYkbSo9Geu9ZKii0gkH2mTg1OlAtLPZICfP7Mz+QsXi
         x+4l3OSXX6YX0jyFLBK+SJDQXEms+UKl636eHBhXYYK04xs/9bEPCz1lFu6z0lOBnSZ9
         i0Loct3f3fpevYTRg+R3bWw6IC/7Wa9RK6SpvJRxWmQOxv+e7lPV2M+1OL+8un/Z7Bjn
         c0bh/YxC0/wJ7cLt/4ssg1QGMlzkzgNC5VU8ZUBacnZuNBfGyG9mwRrGsOWKD+AaGFCz
         2KpLHh1dvpRCjw6KT70VWZ4Y1I2Y1S4w2FQOVdFID7HbEs5vsaIk5JGVc+6yTaNAgYRE
         wDfg==
X-Gm-Message-State: ACrzQf0w8aVnS1cAg06WtMkE3jyJ9fRpUdlo3b094ABUsmMTV1Ig9Lay
        KefYwnl0xy1KUh0l+gR9iv30XJn3X23y7KshbvtUVi/7uOSJCpNj4xHasK9QVeqQCpbL+0VyFck
        htz8jStpelZZ3h9TC3iZVZg==
X-Received: by 2002:a17:90b:4b84:b0:202:ec40:8643 with SMTP id lr4-20020a17090b4b8400b00202ec408643mr20146478pjb.86.1664515409051;
        Thu, 29 Sep 2022 22:23:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7UXmPoA+WtqTwm0dw9Jp/W6A8RrJ+KPsk0z4pTBacpxBJyKxvTCccAoeR6R07ON8k59RX2DQ==
X-Received: by 2002:a17:90b:4b84:b0:202:ec40:8643 with SMTP id lr4-20020a17090b4b8400b00202ec408643mr20146453pjb.86.1664515408736;
        Thu, 29 Sep 2022 22:23:28 -0700 (PDT)
Received: from [10.72.12.204] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fu1-20020a17090ad18100b001fd6066284dsm740533pjb.6.2022.09.29.22.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 22:23:28 -0700 (PDT)
Message-ID: <9d7c13e8-f553-b648-6026-e815bbc48a08@redhat.com>
Date:   Fri, 30 Sep 2022 13:23:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [PATCH mdadm v3 5/7] mdadm: Add --write-zeros option for Create
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220921204356.4336-1-logang@deltatee.com>
 <20220921204356.4336-6-logang@deltatee.com>
 <20220923132006.000006ce@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
In-Reply-To: <20220923132006.000006ce@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2022/9/23 下午7:20, Mariusz Tkaczyk 写道:
> Hi Logan,
> One comment from my side.
>
> Thanks,
> Mariusz
>
> On Wed, 21 Sep 2022 14:43:54 -0600
> Logan Gunthorpe <logang@deltatee.com> wrote:
>
>> Add the --write-zeros option for Create which will send a write zeros
>> request to all the disks before assembling the array. After zeroing
>> the array, the disks will be in a known clean state and the initial
>> sync may be skipped.
>>
>> Writing zeroes is best used when there is a hardware offload method
>> to zero the data. But even still, zeroing can take several minutes on
>> a large device. Because of this, all disks are zeroed in parallel using
>> their own forked process and a message is printed to the user. The main
>> process will proceed only after all the zeroing processes have completed
>> successfully.
>>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>>
>> fixup! mdadm: Add --write-zeros option for Create
>> ---
>> diff --git a/mdadm.h b/mdadm.h
>> index 1ab31564efef..c7e00195d8c8 100644
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -273,6 +273,9 @@ static inline void __put_unaligned32(__u32 val, void *p)
>>   
>>   #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
>>   
>> +#define KIB_TO_BYTES(x)	((x) << 10)
>> +#define SEC_TO_BYTES(x)	((x) << 9)
>> +
>>   extern const char Name[];
>>   
>>   struct md_bb_entry {
>> @@ -387,6 +390,8 @@ struct mdinfo {
>>   		ARRAY_UNKNOWN_STATE,
>>   	} array_state;
>>   	struct md_bb bb;
>> +
>> +	pid_t zero_pid;
>>   };
> mdinfo is  used  for raid properties. It is used for both system (sysfs_read())
> and metadata(getinfo_super()). zero_pid property doesn't fit well there, it is
> used once during creation. Could you please add it to mddev_dev struct or add
> it to local array /list?


Hi Logan

I have the same question about this.

Beside this problem, the others are good for me. By the way, it needs to 
pull to the latest upstream. Now

it has conficts when mergeing v3 patch.

Regards

Xiao

>

