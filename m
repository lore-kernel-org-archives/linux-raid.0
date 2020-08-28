Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0860EC433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8DC120838
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 22:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XslhTe7O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgH1WkX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 18:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgH1WkV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 18:40:21 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBA5C061264
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 15:40:21 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id h17so572641otl.9
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 15:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=rH1EF2kwKnK1yAHlkiYDFMmgxnN8YkXyPiSmQ1uVDwg=;
        b=XslhTe7O1dhe6KOuDThWDCf4FWEfuPEnnDNqD8Y9C72lHv1jTTZqt+iFaVbKHy7rJg
         R9lOFXlOhFmFrqIbNOAijUaM+KYUrgkiO+rOw6OCQ0vlBTMmCrwEus754tnLw+MwicfJ
         wB8She+DbgWlkxhAg38BvbxSG1lmEX/vfjIyFIIsxgisGgLgkLClkHgy+W86Anjib35N
         VQWqNvPZNnDCV0NePAyJn5/LGcTzqWgdWPLo5UJKoxq89rOFwsPqtGWHqws1Vkx4C2LH
         wRd7kF0B4z5RLDCWH3dq4w1xN5Be3MHBUTG9AdfA1ARjMFbmKaMoqtjXxIgSU2b4tOXw
         1ABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rH1EF2kwKnK1yAHlkiYDFMmgxnN8YkXyPiSmQ1uVDwg=;
        b=sKfnUl4vDPosgp86yCZ9+RAL8gh6c+MLTRnpQZgc9IQqMEcca4dacPe3iEEYtJxtvY
         87F+ToKEngrN8fbt0mzqCFtkLuW+LCv+AHnnoMUqDhM41n/GMORgusmzlnp+MQcWS8uP
         v5FDPRmV+T9E3gZ0PNDpCN2DBBbGytLMo3dThpJvSQVvnh2pr1qPqcM3xrHIo3Lhw2J7
         DiR9mIek617+LlyV2mxT8g5fQvM0MQO0NLdbboDT1wxIKeh4BVyZFNXrOX4ZnRFoyxNM
         cQdWbSI59PVPWO0PQ54YtaQb/hSNhjsbWo20v8L7E3NW15BTL5PdEgc/XAZ0j3SkkxHK
         XYwg==
X-Gm-Message-State: AOAM533pl9Xo0yG60BEEn42JSsOil9XNPXJQe1voFixUl9nAm10h2bDx
        sHFxljGAz4F6Y5jBZbGpDSK2FH8c7kA=
X-Google-Smtp-Source: ABdhPJwKGuDoMIgd8UaeDPwHBwKqJxP+QwrxYGu+0NWI4Chlu38C8nr9Fxr469sSDvKbOOLzFrdwSQ==
X-Received: by 2002:a05:6830:1242:: with SMTP id s2mr560796otp.167.1598654419441;
        Fri, 28 Aug 2020 15:40:19 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id o3sm194040oom.26.2020.08.28.15.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 15:40:19 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     antlists <antlists@youngman.org.uk>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
Date:   Fri, 28 Aug 2020 17:40:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/28/20 5:12 PM, antlists wrote:
> On 28/08/2020 18:25, Ram Ramesh wrote:
>> I am mainly looking for IOP improvement as I want to use this RAID in 
>> mythtv environment. So multiple threads will be active and I expect 
>> cache to help with random access IOPs.
>
> ???
>
> Caching will only help in a read-after-write scenario, or a 
> read-several-times scenario.
>
> I'm guessing mythtv means it's a film server? Can ALL your films (or 
> at least your favourite "watch again and again" ones) fit in the 
> cache? If you watch a lot of films, chances are you'll read it from 
> disk (no advantage from the cache), and by the time you watch it again 
> it will have been evicted so you'll have to read it again.
>
> The other time cache may be useful, is if you're recording one thing 
> and watching another. That way, the writes can stall in cache as you 
> prioritise reading.
>
> Think about what is actually happening at the i/o level, and will 
> cache help?
>
> Cheers,
> Wol

Mythtv is a sever client DVR system. I have a client next to each of my 
TVs and one backend with large disk (this will have RAID with cache). At 
any time many clients will be accessing different programs and any 
scheduled recording will also be going on in parallel. So you will see a 
lot of seeks, but still all will be based on limited threads (I only 
have 3 TVs and may be one other PC acting as a client) So lots of IOs, 
mostly sequential, across small number of threads. I think most cache 
algorithms should be able to benefit from random access to blocks in SSD.

Do you see any flaws in my argument?

Regards
Ramesh

