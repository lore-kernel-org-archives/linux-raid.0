Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C5BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 07:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82CFD61212
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 07:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhJSHD0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 03:03:26 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17299 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhJSHD0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Oct 2021 03:03:26 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634626866; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=RLZhNvqUOu6Aw42CfkynceYpMLq8pdEx7hOZJPqH5FdDHiW4vNap2POHnkn3Bb2b6O5XqXwSR6aEh/BliGWEDIz574/8CHOVp0B1saPhDyJ/YNpD704sF3IzwCi1NSPYC/oCdo8LedeB5Utv9npuUwkzbue0vbZ3VpeOFVZe6IE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634626866; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=KVwULKdkZkuTfUNGp4hpcVq1/GhdVgbZFvuim69SXjI=; 
        b=CVvPKSPNM9PEotKj7I+cSJcpl5YrGE31AALGK8NDUgQRdTteTImg5sQN3ml0VZ2l9d0ymhp/rGwgCKeKee/6Na0Ey0E6lEwBNpDWaTZLIglaPlva5HTIOGAfl2G8lqg7WFDLPuUHOoL0XzD2e8kW2HnugOK0vss6CjMuvk3FK2w=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.109.156.142] (163.114.130.5 [163.114.130.5]) by mx.zoho.eu
        with SMTPS id 1634626864170651.5160066546595; Tue, 19 Oct 2021 09:01:04 +0200 (CEST)
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     Xiao Ni <xni@redhat.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>, Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1634289920-5037-1-git-send-email-xni@redhat.com>
 <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com>
 <CALTww28pOiSBMA3ozM+CpM2E4mNFf2kpfGO5o3zN1oEu21tYCw@mail.gmail.com>
 <34bc33db-101f-9306-01fe-6d6dde23a695@linux.intel.com>
 <CALTww2-1SL=3XStCOgUpKRnaeDE06Bm5vzMOCwr2cr0-u37CVw@mail.gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <988d06d3-e803-1392-77f3-9539a11a6673@trained-monkey.org>
Date:   Tue, 19 Oct 2021 03:01:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CALTww2-1SL=3XStCOgUpKRnaeDE06Bm5vzMOCwr2cr0-u37CVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/18/21 9:05 AM, Xiao Ni wrote:
> On Mon, Oct 18, 2021 at 7:52 PM Tkaczyk, Mariusz
> <mariusz.tkaczyk@linux.intel.com> wrote:
>>
>> There is a code:
>>         if (create && !regular && !preferred) {
>>                 static char buf[30]; <- this variable will survive retry.
>>                 snprintf(buf, sizeof(buf), "%d:%d", major, minor);
>>                 regular = buf;
>>         }
>> but seems that it is not a case for this scenario. I suspected that
>> this was used because when gathering container name:
>>
>>                 container = map_dev_preferred(major(devid), minor(devid),
>>                                               1, c->prefer);
>>
>> 'create' is explicitly set to 1. That is why I expect to have 'container'
>> declared in static area. Make sense?
>>
> 
> I c.
> 
>>
>>>>
>>>> This whole block should be moved from Detail() code to separate
>>>> function, which determines if device or replacement is in sync.
>>>
>>> A good suggestion. Put it into the change I mentioned above, is it ok?
>>>
>> Agree. So, will you take care about all improvements later (after release)?
>>
> 
> I plan to do this after you talk about them. If you want to fix them, I can help
> to review too. I'll ping you when I'm ready to do this to check if you
> start doing
> it.

Xiao, Mariusz,

I'll ignore this one for now, based on your discussion. Please yell if
you disagree.

Thanks,
Jes

