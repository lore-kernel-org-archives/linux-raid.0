Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A8AC433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 17:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ABED208C9
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 17:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSnSpqSV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgH1R0A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1RZz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 13:25:55 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145ECC061264
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 10:25:55 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i11so1535301otr.5
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 10:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=HeBESBySQLtukT7aeFJ5TrEP1KGogvz/ex2ccG6e4D0=;
        b=CSnSpqSVqu7+KaORS2kDgMmjzgtXf6XLWfZZFQnLAbQmpd4TJdFwGCPD5OCWbRhRGN
         Xy7EhjbhLtn29rMg1dTkZPrpTR7jatfZ2B3rwsS/rZaN+SPYwe3oPiwvzeZjzEzWKlaH
         xneKfdN2U6doXLa4eyP7uChhACPfdfYTSgAn3mX9qTh2DzQ0yzZl2SUQkOo3SptJT+I+
         5mlR6xfDEouL74o75t98XTA1vYTowxveA22j9SHRCMW5DOqn4xemSWSykRjPWa5Re70E
         NOdZ5JwvFHHTCHkaUpBWBT0loOMkMZsYBeXnmPPo8ZXsbsxnawjTI7d4x0kw++1RiA7s
         acpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HeBESBySQLtukT7aeFJ5TrEP1KGogvz/ex2ccG6e4D0=;
        b=Hnal1eHi+nLVD2qFsK8FcmdDpMMvZS96s/esEUGxn0fVwm9MqS/RbysOyMswUdQbiH
         9zTWN8wB+zuwfX8dT+eyTmjDwJ+tC/CWUHM6q4T69GeKPNtmk5LuBDHMoJT4zhqs80Cs
         JqzDxg/LkivCJEfhBqIMMTC2wDdO+NMRT4kUGeRXAsQKORru4m8rPe357ecXlUgCtlM6
         0eFgPWetjhcyakjczAY6XgQBnpMZTzcwMVByXW6eQJEjlymJ7LBbrtB8cR9/kgYOGrME
         8L6llnRQJCW/X1HRVSMpiZ97UBt2qKsSVaPJJwMaoddbioi2J5anl8msspLFMiz+KrHg
         /fXg==
X-Gm-Message-State: AOAM531A8XAXWg9+0vohjI4kDvrqLJZQOwaK3xi69SEPipM224Np4bvS
        MflVv+mi9RThAXuoX8S5jJctwTMK4x0=
X-Google-Smtp-Source: ABdhPJxS2KqzIyJ1l539vGSt51za6ifUlKnJOLSt0XgDTSwSFYGhVfZ/aZ95W1OA12iOUZ8BPsZNmg==
X-Received: by 2002:a9d:6b0c:: with SMTP id g12mr2030322otp.315.1598635553290;
        Fri, 28 Aug 2020 10:25:53 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id d79sm293553oig.25.2020.08.28.10.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 10:25:52 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     antlists <antlists@youngman.org.uk>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
Date:   Fri, 28 Aug 2020 12:25:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/28/20 10:26 AM, antlists wrote:
> On 28/08/2020 03:31, R. Ramesh wrote:
>> I want to build new raid using the 16/14tb drives. Since I am 
>> building new raid, I thought I could explore caching options. I see a 
>> mention of LVM cache and few other bcache/xyzcache etc.
>>
>> Is anyone of them better than other or no cache is safer. Since I 
>> switched over to NVME boot drives, I have quite a few SATA SSDs lying 
>> around that I can put to good use, if I cache using them.
>
> Sounds like a fun idea. Just make sure you're getting CMR not SMR 
> drives, but I'm not aware of SMR that large ...
>
> Hopefully I'm going to do some work on it soon, but look at 
> dm-integrity to make sure you don't get a dodgy mirror. You can add 
> dm-integrity retrospectively, so if you leave a bit of unused space on 
> the drive, I think you can tell dm-integrity where to put its checksums.
>
> Cheers,
> Wol
Yes, no SMR. I plan to get only enterprise helium drives (seagate exos 
X14 or X16).

I googled on RAID cache performance. I did not get too many interesting 
hits. A couple that find seem to indicate that LVM cache shows no 
performance improvement. Can't understand why. May be SATA limits (SSD = 
500MB and disk could be as high as 200M and with raid1 that might go up 
as we have two disks to read etc)

I am mainly looking for IOP improvement as I want to use this RAID in 
mythtv environment. So multiple threads will be active and I expect 
cache to help with random access IOPs.

Regards
Ramesh

