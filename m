Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61575C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 01:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488C360F70
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 01:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhKDBnt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:43:49 -0400
Received: from sender12-1.zoho.eu ([185.20.211.225]:17263 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhKDBnt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Nov 2021 21:43:49 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635990062; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=RBsGNKmh/FWkpclygQefhAMT6EsOaQJYCBr29VVw4ElsvOKXJY175jwPEEKGMmj+bYDHaIH0schfYGYcew47GQdzzUW4vhCyPTEUE8nps2cBOFb8/rumpz/M4lpq7MMXH7K2vTEDsASJ1fdyfj1OR8aaUT8xRaHANrDJuBGnLck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635990062; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ouILKSfalGqJy1ddEqxf28bugCy9THnV5MwVTofryy8=; 
        b=eVAXmJm7v7+jXv9Yx+AjAPNSTvh0bTG5aALYYEAJB7+q/wOpnsYVV+x3MlOYEJt8cK7E8GSbrUOb6pxTu5mOw4BUgFZmRJi8OlI2L3B4VPR6n4kzGgfsLMe7emeaOnySF/IoebXFIoExC54f7n5ZAYojtt4etqvfZo9p8kdpFq8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635990061915185.34937496424425; Thu, 4 Nov 2021 02:41:01 +0100 (CET)
Subject: Re: [PATCH] mdopen: use safe functions in create_mddev
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210921075257.10668-1-mariusz.tkaczyk@linux.intel.com>
 <c8239095-aec5-142f-77e8-d0e71e8caf3b@trained-monkey.org>
 <e6a6f841-1fe8-5cee-edf9-84a98d9b22c7@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <274f67c4-9dc2-cb1e-1187-9dc4d0329795@trained-monkey.org>
Date:   Wed, 3 Nov 2021 21:41:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e6a6f841-1fe8-5cee-edf9-84a98d9b22c7@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/3/21 5:08 AM, Tkaczyk, Mariusz wrote:
>> The switch to using NAME_MAX has some side effects I am a little
>> concerned about, however the code is also really tricky to get your head
>> around (not your fault).
>>
> My first idea was to rewrite it at all but there is more nits
> (like --name parameter and config). It is not a task for rc stage.

Agree lets look at this after 4.2

>>> @@ -188,35 +209,48 @@ int create_mddev(char *dev, char *name, int
>>> autof, int trustworthy,
>>>       parts = autof >> 3;
>>>       autof &= 7;
>>>   -    strcpy(chosen, "/dev/md/");
>>> -    cname = chosen + strlen(chosen);
>>> +    if (chosen_size <= strlen(dev_md_path) + cname_size) {
>>> +        dprintf("Chosen buffer is to small.\n");
>>> +        return -1;
>>> +    }
>>
>> cname_size = NAME_MAX = 255
>>
>> Ie. if something calls create_mddev() with a chosen_size smaller than
>> 263, this check will fail, which seems rather arbitrary. It does look
>> like we always use a chosen_name[1024] which is silly wasteful, but
>> there much be a better solution to this. Maybe malloc() and return the
>> buffer instead of relying on those large stack frames?
>
> With malloc, I will need to add free() everywhere, I don't think
> that it is good option.
> I agree that this check can be removed, especially that now it is
> always called with size 1024.

I'd love to get rid of those 1024 byte arrays too.

>>> +    strncpy(chosen, dev_md_path, chosen_size);
>>> +    cname = chosen + strlen(dev_md_path);
>>>         if (dev) {
>>> -        if (strncmp(dev, "/dev/md/", 8) == 0) {
>>> -            strcpy(cname, dev+8);
>>> -        } else if (strncmp(dev, "/dev/", 5) == 0) {
>>> -            char *e = dev + strlen(dev);
>>> +        if (strncmp(dev, dev_md_path, 8) == 0)
>>> +            strncpy(cname, dev+8, cname_size);
>>
>> sizeof(dev_md_path) instead of the hardcoded 8?
>>
>>> +        else if (strncmp(dev, dev_md_path, 5) == 0) {
>>> +            const char *e = dev + 5 + strnlen(dev + 5, NAME_MAX);
>>> +>              while (e > dev && isdigit(e[-1]))
>>>                   e--;>              if (e[0])
>>>                   num = strtoul(e, NULL, 10);
>>> -            strcpy(cname, dev+5);
>>> +            strncpy(cname, dev + 5, cname_size);
>>>               cname[e-(dev+5)] = 0;
>>> +
>>>               /* name *must* be mdXX or md_dXX in this context */
>>>               if (num < 0 ||
>>> -                (strcmp(cname, "md") != 0 && strcmp(cname, "md_d")
>>> != 0)) {
>>> +                (strncmp(cname, "md", 2) != 0 &&
>>> +                 strncmp(cname, "md_d", 4) != 0)) {
>>>                   pr_err("%s is an invalid name for an md device. 
>>> Try /dev/md/%s\n",
>>>                       dev, dev+5);
>>>                   return -1;
>>>               }
>>> -            if (strcmp(cname, "md") == 0)
>>> +            if (strncmp(cname, "md", 2) == 0)
>>>                   use_mdp = 0;
>>>               else
>>>                   use_mdp = 1;
>>>               /* recreate name: /dev/md/0 or /dev/md/d0 */
>>> -            sprintf(cname, "%s%d", use_mdp?"d":"", num);
>>> +            snprintf(cname, cname_size, "%s%d",
>>> +                 use_mdp ? "d" : "", num);
>>>           } else
>>> -            strcpy(cname, dev);
>>> +            strncpy(cname, dev, cname_size);
>>> +        /*
>>> +         * Force null termination for long names.
>>> +         */
>>> +        cname[cname_size - 1] = '\0';
>>>             /* 'cname' must not contain a slash, and may not be
>>>            * empty.
>>
>> My head started spinning by the time I got to here.
>>
>> The more I think about it, the more I think we should allocate an
>> appropriate buffer in here and return that, rather than play all those
>> bounds checking games.
>>
>> Thoughts?
>>
> We need to return mdfd too, so cannot return from here.

We can still return it in a pointer argument.

> First we need to determine how it should work.
> The code now is quite unpredictable but it is working for
> years. I just tried to fix static code analysis errors for
> now. My concerns are here:
> #mdadm -CR /dev/mdx --name=test ...
> #mdadm -CR name --name=test ...
> #mdadm -CR /dev/md/name --name=test ...
> 
> We can define volume by *dev and *name (--name=) and it
> is not well defined how it should behave. I will need
> to start with determining it first and later adapt
> other stuff (assemble and incremental).
> 
> So, it requires separate discussion and will
> be a release blocker.

Yes this is why reading the code made my head spin :)

Cheers,
Jes

