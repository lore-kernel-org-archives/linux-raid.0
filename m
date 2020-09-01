Return-Path: <SRS0=9hr8=CK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D5FC433E6
	for <linux-raid@archiver.kernel.org>; Tue,  1 Sep 2020 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4984A204EC
	for <linux-raid@archiver.kernel.org>; Tue,  1 Sep 2020 16:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NFP0OwUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbgIAQMu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgIAQMn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Sep 2020 12:12:43 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A17C061244
        for <linux-raid@vger.kernel.org>; Tue,  1 Sep 2020 09:12:43 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id d189so1615554oig.12
        for <linux-raid@vger.kernel.org>; Tue, 01 Sep 2020 09:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vSowRDySCBCLZb875Nn8TxVIbhjyHUkDyOz5jt4Gi8k=;
        b=NFP0OwUTUiMmh0WwXpCh3dCXqMRHfyHp5msgZy7tAUizLF9C/4U1dQpp+WdU5vb5Dy
         XG+twL91B9NB7jyMGMOHEkjt7T5dm04RK3o4OHUelqttgEzQtIFgGAfHczPnA9NEiOv/
         BsWYa3m9CNLAvOnDknZZx52xz0MU1WgVbCUJcA/zfLTObXHw61Ct+guUYr/BfW6xCObd
         UNemK7lxqQQ7CK9EuSbVg2F8HXa+Kcuo0cL3gLAVXbRpW4oV6eK2vlYBfg5hURVQ97Ym
         Nv1aK9jDFSUUpXIuut1UPrB4kjUq1+P7zY+ksXfC4D6Oou7Zb4plZ784nQBNZDjcnstP
         RzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vSowRDySCBCLZb875Nn8TxVIbhjyHUkDyOz5jt4Gi8k=;
        b=RN6g6bsLk/LVf3h20gDjC7Ntp+Cl5r3mNsxRWYpmUINUkWrNsww033fB+hQMGcpnGQ
         TFGbx5dIosoRJSD8pfTT9h0MeWHiw3OvnhQ6CbyjryqXKeE5l0OBtqoXEC6Wp7926F3O
         q6bqC8JW+lM404uWUb6l/8qMqsbe/PmIy69fvTB9p8C9tjrZ+lWdby8GBI47XuBqg5KI
         WE1AZCpBLw+3HMflU6GEm8+SV8Y7PmYnMq9YUFR7EMLHX8OqHJ7KJ5FSYl99h0tfheut
         yiycnbZqIpQxCX9fyJ5UBWoS7diaAbarZ22qSS2l5shfrI+o5YzvjE5KxM88nRToASrg
         MwMA==
X-Gm-Message-State: AOAM530GONLqGOTkGgEsI5z2WrYS2GJ7yzWBQsjPBjrOH8iAK6365zyY
        jAR7SlN4Oj0VjQDMSqZZEW+C2KziKmw=
X-Google-Smtp-Source: ABdhPJz5A/MTq003hc+7u9DNzSTfJGTKToBck3+B3IaAMo8nFHW6fyKH+LnTSo9R3JCjiUEOXcAvvg==
X-Received: by 2002:aca:4157:: with SMTP id o84mr1633270oia.4.1598976761566;
        Tue, 01 Sep 2020 09:12:41 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id q15sm250937otl.65.2020.09.01.09.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 09:12:41 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Drew <drew.kay@gmail.com>
Cc:     antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
 <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
 <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com>
Date:   Tue, 1 Sep 2020 11:12:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/29/20 5:36 PM, Drew wrote:
> I know what you and Wols are talking about and I think it's actually
> two separate things. Wol's is referring to traditional read caching
> where it only benefits if you are reading the same thing over and over
> again, cache hits. For streaming it won't help as you'll never hit the
> cache.
>
> What you are talking about is a write cache, something I have seen
> implemented before. Basically the idea is for writes to hit the SSD's
> first, the SSD acting as a cache or buffer between the filesystem and
> the slower RAID array. To the end process they're just writing to a
> disk, they don't see the SSD buffer/cache. QNAP implements this in
> their NAS chassis, just not sure what the exact implementation is in
> their case.
>
> On Fri, Aug 28, 2020 at 9:14 PM R. Ramesh <rramesh@verizon.net> wrote:
>> On 8/28/20 7:01 PM, Roger Heflin wrote:
>>> Something I would suggest, I have found improves my mythtv experience
>>> is:  Get a big enough SSD to hold 12-18 hours of the recording or
>>> whatever you do daily, and setup the recordings to go to the SSD.    i
>>> defined use the disk with the highest percentage free to be used
>>> first, and since my raid6 is always 90% plus the SSD always gets used.
>>> Then nightly I move the files from the ssd recordings directory onto
>>> the raid6 recordings directory.  This also helps when your disks start
>>> going bad and getting badblocks, the badblocks *WILL* cause mythtv to
>>> stop recording shows at random because of some prior choices the
>>> developers made (sync often, and if you get more than a few seconds
>>> behind stop recording, attempting to save some recordings).
>>>
>>> I also put daily security camera data on the ssd and copy it over to
>>> the raid6 device nightly.
>>>
>>> Using the ssd for recording much reduces the load on the slower raid6
>>> spinning disks.
>>>
>>> You would have to have a large number of people watching at the same
>>> time as the watching is relatively easy load, compared to the writes.
>>>
>>> On Fri, Aug 28, 2020 at 5:42 PM Ram Ramesh <rramesh2400@gmail.com> wrote:
>>>> On 8/28/20 5:12 PM, antlists wrote:
>>>>> On 28/08/2020 18:25, Ram Ramesh wrote:
>>>>>> I am mainly looking for IOP improvement as I want to use this RAID in
>>>>>> mythtv environment. So multiple threads will be active and I expect
>>>>>> cache to help with random access IOPs.
>>>>> ???
>>>>>
>>>>> Caching will only help in a read-after-write scenario, or a
>>>>> read-several-times scenario.
>>>>>
>>>>> I'm guessing mythtv means it's a film server? Can ALL your films (or
>>>>> at least your favourite "watch again and again" ones) fit in the
>>>>> cache? If you watch a lot of films, chances are you'll read it from
>>>>> disk (no advantage from the cache), and by the time you watch it again
>>>>> it will have been evicted so you'll have to read it again.
>>>>>
>>>>> The other time cache may be useful, is if you're recording one thing
>>>>> and watching another. That way, the writes can stall in cache as you
>>>>> prioritise reading.
>>>>>
>>>>> Think about what is actually happening at the i/o level, and will
>>>>> cache help?
>>>>>
>>>>> Cheers,
>>>>> Wol
>>>> Mythtv is a sever client DVR system. I have a client next to each of my
>>>> TVs and one backend with large disk (this will have RAID with cache). At
>>>> any time many clients will be accessing different programs and any
>>>> scheduled recording will also be going on in parallel. So you will see a
>>>> lot of seeks, but still all will be based on limited threads (I only
>>>> have 3 TVs and may be one other PC acting as a client) So lots of IOs,
>>>> mostly sequential, across small number of threads. I think most cache
>>>> algorithms should be able to benefit from random access to blocks in SSD.
>>>>
>>>> Do you see any flaws in my argument?
>>>>
>>>> Regards
>>>> Ramesh
>>>>
>> I was hoping SSD caching would do what you are suggesting without daily
>> copying. Based on Wol's comments, it does not. May be I misunderstood
>> how SSD caching works.  I will try it any way and see what happens. If
>> it does not do what I want, I will remove caching and go straight to disks.
>>
>> Ramesh
>
>
After thinking through this, I really like the idea of simply recording 
programs to SSD and move one file at a time based on some aging 
algorithms of my own. I will move files back and forth as needed during 
overnight hours creating my own caching effect. As long as I keep the 
original (renamed) and cache the ones needed with correct name, mythtv 
will find the cached copy. When mythtv complains about something 
missing, I can manually look at the renamed backup copy and make the 
corrections. Unless my thinking is badly broken, this should work.

I really wished overlay fs had a nice merge/clean feature that will 
allow us to move overlay items to underlying file system and start over 
the overlay. All I need is file level caching and not block level caching.

Ramesh

