Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF69BC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C65161212
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhJSG6g convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 02:58:36 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17294 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJSG6g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Oct 2021 02:58:36 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634626576; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=buS0sCGEAVMrnJH8TS31K090llf+MCpS9T28FANIqC3Ck8cclpsLTmFsb8of6geds8bSyq77AZ6HslaLODvMjGYRBYn/kH1BMZrMit0837o4LDrPobemK63V9sULRobu34lcOvD1C5BgjAcjROBYA+3GVaC4VnymS+MUDv6gcqY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634626576; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=xELkPKP6Iqbx3ZUTWwDu7TSVt8osYTCji1AgnE1A+K0=; 
        b=EPIBKf95PE61uLaV9OEJuFFGo5kS6LZD/ZwPdLNCl8WMXSHcsUUMjSVK/5g58X5d6Na06CacTWCZBokLPA8Ge1yPpBlC6cMfvpVwVQAgjgD5L+1FxRL1C59k2Jw2VngEJKxSL7vBK93xq9rr8w6i52Wz+Cyo9u+wygZEZW+VuEo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.109.156.142] (163.114.130.5 [163.114.130.5]) by mx.zoho.eu
        with SMTPS id 1634626574602766.148163870942; Tue, 19 Oct 2021 08:56:14 +0200 (CEST)
Subject: Re: [PATCH] imsm: Remove possibility for get_imsm_dev to return NULL
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210920111032.19195-1-mateusz.grzonka@intel.com>
 <be5f8bd5-9434-a403-a982-fd41cf1fe9a2@trained-monkey.org>
 <85b62315-4651-cb9e-5001-6d2faa8bbfc8@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <956fa46d-e4a7-f518-dad7-ded868ee825e@trained-monkey.org>
Date:   Tue, 19 Oct 2021 02:56:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <85b62315-4651-cb9e-5001-6d2faa8bbfc8@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/14/21 3:32 AM, Tkaczyk, Mariusz wrote:
> Hi Jes,
> 
> On 08.10.2021 18:05, Jes Sorensen wrote:
>> On 9/20/21 7:10 AM, Mateusz Grzonka wrote:
>>> Returning NULL from get_imsm_dev or __get_imsm_dev will cause segfault.
>>> Guarantee that it never happens.
>>>
>>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
>>> ---
>>>   super-intel.c | 122 +++++++++++++++++++-------------------------------
>>>   1 file changed, 46 insertions(+), 76 deletions(-)
>>>
>>> diff --git a/super-intel.c b/super-intel.c
>>> index 83ddc000..2c3df58a 100644
>>> --- a/super-intel.c
>>> +++ b/super-intel.c
>>> @@ -858,30 +858,29 @@ static struct imsm_dev *__get_imsm_dev(struct
>>> imsm_super *mpb, __u8 index)
>>>       void *_mpb = mpb;
>>>         if (index >= mpb->num_raid_devs)
>>> -        return NULL;
>>> +        goto error;
>>>         /* devices start after all disks */
>>>       offset = ((void *) &mpb->disk[mpb->num_disks]) - _mpb;
>>>   -    for (i = 0; i <= index; i++)
>>> +    for (i = 0; i <= index; i++, offset += sizeof_imsm_dev(_mpb +
>>> offset, 0))
>>>           if (i == index)
>>>               return _mpb + offset;
>>> -        else
>>> -            offset += sizeof_imsm_dev(_mpb + offset, 0);
>>> -
>>> -    return NULL;
>>> +error:
>>> +    pr_err("matching failed, index: %u\n", index);
>>> +    abort();
>>>   }
>>
>> Can we please fix the error handling properly instead of throwing in
>> abort() and assert() to avoid it. That's really sloppy in my book.
> 
> This situation is unexpected and shall never happen. I don't see any
> advantage of handling it. Abort() is the most elegant solution.
> If it happens, it shall fail loudly. Verifying that we don't get
> NULL in each place where it is called is harmful and unnecessary.
> 
> Passing wrong index means that code is broken and we definitely cannot
> continue.

If we are to fail with abort() at a bare minimum add some comments in
the code explaining why it's done.

Thanks,
Jes

