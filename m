Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7859DC433DB
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 22:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CF2264EC0
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 22:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZWSI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 Feb 2021 17:18:08 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17191 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZWSF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 Feb 2021 17:18:05 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614376855; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=gPyQhjQUI4bN83Bi2emrGMiDVyfWKvFHUJj6w2wfrbxq/1DjqvY7HQuf9AagQyYuf/VQANSEbVEcA3D1Dx/E0IXUCWhMjfwjrSrS2nV3iEMiWLd2l+kaotjcLO+y/aY42AIxK69b2Grgld3ZpndvBXKZ/OhWd5moAox9lodfx8s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1614376855; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=a1Rde4eBWm6EXuXbUjb4cEe4GgJbU+uCymWhJyUGo4s=; 
        b=BL9EMxLgXHwseq/xiMZ6I2snhltV1uA9RqkucTi/cxOCKO98FufQ3bu3zGhcbzODgEgkUPRq/To1rBZ9tjJEurKA6+6iEYv1UgIa1RWdwI53fTIuV/6lBuo3mtmVy2rdv5a1SBrxLNDy96PofFABK10vTiT08+Zv3qtCiWWK8Rw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1614376854417479.3483357691222; Fri, 26 Feb 2021 23:00:54 +0100 (CET)
Subject: Re: [PATCH 1/1] mdadm/bitmap: locate bitmap calcuate bitmap position
 wrongly
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        Xiao Ni <xni@redhat.com>
Cc:     ncroxon@redhat.com, heinzm@redhat.com, linux-raid@vger.kernel.org
References: <1603865064-27404-1-git-send-email-xni@redhat.com>
 <95046dfe-c770-8950-c720-6b1d30bb1789@suse.com>
 <f0616f2c-7156-8717-349d-7dcf349fd421@redhat.com>
 <779a49d4-43d8-2f8b-59ec-6d45d61cc3f9@suse.com>
 <73df4806-177a-9aca-4968-61c593e3333d@trained-monkey.org>
 <78bd8657-b033-734a-15dc-634ba09804b4@suse.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <816e5dd9-6da3-47be-0937-36ea65031260@trained-monkey.org>
Date:   Fri, 26 Feb 2021 17:00:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <78bd8657-b033-734a-15dc-634ba09804b4@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/25/20 8:43 PM, heming.zhao@suse.com wrote:
> On 11/26/20 7:18 AM, Jes Sorensen wrote:
>> On 10/30/20 2:44 AM, heming.zhao@suse.com wrote:
>>> You are right. Only cluster case can trigger your patch code.
>>> Hardcode 4096 is correct.
>>
>> Just catching up, was the conclusion the original patch was correct?
>>
>> Thanks,
>> Jes
>>
> Xiao's patch (original patch) is correct.
> 
> Thanks.

Applied!

Thanks,
Jes


>>
>>> On 10/30/20 1:53 PM, Xiao Ni wrote:
>>>> Hi Heming
>>>>
>>>> The cluster raid is only supported by super 1.2, so we don't need to consider the old system when
>>>> it's a cluster raid.
>>>>
>>>> Regards
>>>> Xiao
>>>>
>>>> On 10/28/2020 08:29 PM, heming.zhao@suse.com wrote:
>>>>> Hello Xiao,
>>>>>
>>>>> My review comment:
>>>>> You code only work in modern system. the boundary is 4k not 512, because using hardcode 4k to call calc_bitmap_size
>>>>>
>>>>> In current cluster env, if bitmap area beyond 4K size (or 512 in very old system), locate_bitmap1
>>>>> will return wrong address.
>>>>>
>>>>> Please refer write_bitmap1() to saparate 512 & 4096 case.
>>>>>
>>>>> On 10/28/20 2:04 PM, Xiao Ni wrote:
>>>>>> Now it only adds bitmap offset based on cluster nodes. It's not right. It needs to
>>>>>> add per node bitmap space to find next node bitmap position.
>>>>>>
>>>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>>>>> ---
>>>>>>     super1.c | 12 +++++++++---
>>>>>>     1 file changed, 9 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/super1.c b/super1.c
>>>>>> index 8b0d6ff..b5b379b 100644
>>>>>> --- a/super1.c
>>>>>> +++ b/super1.c
>>>>>> @@ -2582,8 +2582,9 @@ add_internal_bitmap1(struct supertype *st,
>>>>>>     static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>>>>>>     {
>>>>>> -    unsigned long long offset;
>>>>>> +    unsigned long long offset, bm_sectors_per_node;
>>>>>>         struct mdp_superblock_1 *sb;
>>>>>> +    bitmap_super_t *bms;
>>>>>>         int mustfree = 0;
>>>>>>         int ret;
>>>>>> @@ -2598,8 +2599,13 @@ static int locate_bitmap1(struct supertype *st, int fd, int node_num)
>>>>>>             ret = 0;
>>>>>>         else
>>>>>>             ret = -1;
>>>>>> -    offset = __le64_to_cpu(sb->super_offset);
>>>>>> -    offset += (int32_t) __le32_to_cpu(sb->bitmap_offset) * (node_num + 1);
>>>>>> +
>>>>>> +    offset = __le64_to_cpu(sb->super_offset) + __le32_to_cpu(sb->bitmap_offset);
>>>>>> +    if (node_num) {
>>>>>> +        bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
>>>>>> +        bm_sectors_per_node = calc_bitmap_size(bms, 4096) >> 9;
>>>>>> +        offset += bm_sectors_per_node * node_num;
>>>>>> +    }
>>>>>>         if (mustfree)
>>>>>>             free(sb);
>>>>>>         lseek64(fd, offset<<9, 0);
>>>>>>
>>>>
>>>
>>
>>
> 


