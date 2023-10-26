Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECC8C25B70
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344732AbjJZVsL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjJZVsK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:48:10 -0400
Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AF7128
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698356879; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=XpWY+q90v2lCFfmgeetG8OP7luqqLT+t+a0HZMi3HOcdZe7T4xmPRZ7/FieG6i/vw8UdFFi4nHDrQiqFDuO40g4NPnwwbbDDBsF0kvHF8Dx+yxQIj/1Xc/mGNMyZ6GAgwEO4LFW9KvSd0qHwhgYxB88yAasRRBNijm/3V0UhF6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698356879; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=pM7iWP3wwItOEpMXU0Zv6i/6zQd6zx0RMccnfeY7ZJM=; 
        b=esRMUj2B7oAxsibSLMktdszy82CFDysOl12Si3QPcyD1cSLE/Nxt5hWWuV32YcqJD2FiL75Cv07iVvlHD8/dD4vHJuUy98OSLziWeITTX3LG+KYQy3nWCK1JGZ3x2fSPIgdhk0mBwfdh3dQt/cPY35vAfuncIzmzGetiZLRukjc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698356877197283.3672767171728; Thu, 26 Oct 2023 23:47:57 +0200 (CEST)
Date:   Thu, 26 Oct 2023 17:47:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/1] mdadm/ddf: Abort when raid disk is smaller in
 getinfo_super_ddf
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org
References: <20231011130332.78933-1-xni@redhat.com>
 <CALTww28hforasc+v3GUWPdoyFyvFZOK8KXeZBKykr_u-2T3K9A@mail.gmail.com>
 <20231013104810.00003a60@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <86076df3-1453-bda9-107b-747cc3625b93@trained-monkey.org>
In-Reply-To: <20231013104810.00003a60@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/13/23 04:48, Mariusz Tkaczyk wrote:
> On Wed, 11 Oct 2023 21:25:37 +0800
> Xiao Ni <xni@redhat.com> wrote:
> 
>> Sorry, the title should be [PATCH 1/1] mdadm/ddf: Abort when raid disk
>> is smaller than 0 in getinfo_super_ddf
>>
>> If you want me to send v2, I can do it.
>>
>> Best Regards
>> Xiao
>>
>>
>> On Wed, Oct 11, 2023 at 9:06 PM Xiao Ni <xni@redhat.com> wrote:
>>>
>>> The metadata is corrupted when the raid_disk<0. So abort directly.
>>> This also can avoid a building error:
>>> super-ddf.c:1988:58: error: array subscript -1 is below array bounds of
>>> ‘struct phys_disk_entry[0]’
>>>
>>> Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>>> Ackedy-by: Xiao Ni <xni@redhat.com>
>>> ---
>>>  super-ddf.c | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/super-ddf.c b/super-ddf.c
>>> index 7213284e0a59..7b98333ecd51 100644
>>> --- a/super-ddf.c
>>> +++ b/super-ddf.c
>>> @@ -1984,12 +1984,14 @@ static void getinfo_super_ddf(struct supertype *st,
>>> struct mdinfo *info, char *m info->disk.number =
>>> be32_to_cpu(ddf->dlist->disk.refnum); info->disk.raid_disk = find_phys(ddf,
>>> ddf->dlist->disk.refnum);
>>>
>>> +               if (info->disk.raid_disk < 0)
>>> +                       return;
>>> +
>>>                 info->data_offset = be64_to_cpu(ddf->phys->
>>>                                                   entries[info->disk.raid_disk].
>>>                                                   config_size);
>>>                 info->component_size = ddf->dlist->size - info->data_offset;
>>> -               if (info->disk.raid_disk >= 0)
>>> -                       pde = ddf->phys->entries + info->disk.raid_disk;
>>> +               pde = ddf->phys->entries + info->disk.raid_disk;
>>>                 if (pde &&
>>>                     !(be16_to_cpu(pde->state) & DDF_Failed) &&
>>>                     !(be16_to_cpu(pde->state) & DDF_Missing))
>>> --
>>> 2.32.0 (Apple Git-132)
>>>  
>>
> 
> Hi Xiao,
> I don't see a need to send v2. Moving to awaiting upstream:
> 
> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Applied!

Thanks,
Jes



