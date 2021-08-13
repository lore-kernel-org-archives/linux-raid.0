Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E2DC4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 19:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B256460F91
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 19:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhHMTUQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 15:20:16 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17024 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhHMTUQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Aug 2021 15:20:16 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1628882379; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=AmA0XrOFT2V9uLOu3yBVjesPdVsRD5vYEeTt31XWp9BvaT3OJfST0xJP2XB1l1NAqMxsH2HuzPmCyWzl2HZoWkhV5+eiiTDZw8vQtwGCCuG0npaOQKj1xcrXH9/LyTm0g02k1SjUW//l2JlNoIn7fb4bvnxikr1ZfLzQcUyWMjY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1628882379; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LVzDEycAYPy9t2qeFS8gn6vkVZo9GHF1DYyjTT8ld6E=; 
        b=S/dml7QsgrmWZu5oBSVT/H5jlRWG4LJAMde0XyE0/7pLMXIcuz880KKGjOTwPbsZmowfLdufkyPsUrGH+E8tgxbtGJuUz32+6CzwuaqyPWmXKvYuAMU0gxnfInbINDhANN9SXJVbmgkO4vyhEwuNDMOT5yJX/GNnbarZVmj3Hqc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1628882377554278.15009580085894; Fri, 13 Aug 2021 21:19:37 +0200 (CEST)
Subject: Re: [PATCH V2] Fix return value from fstat calls
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        NeilBrown <neilb@suse.de>
Cc:     Nigel Croxon <ncroxon@redhat.com>, xni@redhat.com,
        linux-raid@vger.kernel.org
References: <20210810151507.1667518-1-ncroxon@redhat.com>
 <20210811190930.1822317-1-ncroxon@redhat.com>
 <162872237888.31578.18083659195262526588@noble.neil.brown.name>
 <346e8651-d861-45c7-9058-68008e691b93@Canary>
 <162881060124.15074.6150940509008984778@noble.neil.brown.name>
 <5b71689a-6d07-0dfd-a4b6-26322ee3136e@linux.intel.com>
 <162883915010.1695.14187049458830945568@noble.neil.brown.name>
 <fe98561f-7f8f-45fa-bafa-e7f553a0f162@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <bd40b084-a3ac-c003-07bb-39ad4dada4a6@trained-monkey.org>
Date:   Fri, 13 Aug 2021 15:19:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <fe98561f-7f8f-45fa-bafa-e7f553a0f162@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/13/21 3:45 AM, Tkaczyk, Mariusz wrote:
> On 13.08.2021 09:19, NeilBrown wrote:
>> On Fri, 13 Aug 2021, Tkaczyk, Mariusz wrote:
>>>
> 
>> Error handling that is buggy, or that is hard to maintain is not better
>> than nothing.  If I can't guarantee that we never pass a bad file
>> descriptor, then you cannot guarantee that the error handling has no
>> bugs.   Less code generally means less bugs.
>>
>> Any attempt to try to handle an error that should not be able to happen
>> other than crashing is fairly pointless - you cannot guess the real
>> cause, so you cannot know how to repair.  Just printing a message and
>> continuing could be as bad as not checking the error.
>> As error handling, I meant any error verification. It doesn't indicate
> that we should return status and end gracefully. exit() is elegant
> solution in this case, totally agree.

Just catching up here on this.

I totally agree that we need to work on catching errors and exiting
properly. It will also help returning error codes from this more silly
error handling cases to keep the certification people happy. This is a
much bigger job than just these checks though.

I don't think Nigel's patch is really harmful, but I don't think it adds
any real value either, without returning the actual error codes from
fstat and parsing them op the stack properly.

Jes


