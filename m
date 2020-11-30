Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC92C83011
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 23:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A756420857
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 23:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbgK3XVz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 18:21:55 -0500
Received: from mail.thelounge.net ([91.118.73.15]:45691 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgK3XVz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 18:21:55 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4ClLnz6vbwzXVl;
        Tue,  1 Dec 2020 00:21:11 +0100 (CET)
To:     antlists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
 <2d0fcd02-9e3a-d11a-a1cf-a47c1b6ce2c3@thelounge.net>
 <e2a9d347-0703-07a6-0128-adf86b35b6f3@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
Message-ID: <885c2c55-2798-e277-07e7-77684e279cb5@thelounge.net>
Date:   Tue, 1 Dec 2020 00:21:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <e2a9d347-0703-07a6-0128-adf86b35b6f3@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 30.11.20 um 23:31 schrieb antlists:
> On 30/11/2020 21:49, Reindl Harald wrote:
>>
>>
>> Am 30.11.20 um 21:51 schrieb antlists:
>>> On 30/11/2020 20:05, David T-G wrote:
>>>> You don't see any "filesystem" or, more correctly, partition in your
>>>>
>>>>    fdisk -l
>>>>
>>>> output because you have apparently created your filesystem on the 
>>>> entire
>>>> device (hey, I didn't know one could do that!). 
>>>
>>> That, actually, is the norm. It is NOT normal to partition a raid array
>>
>> it IS normal for several reasons
>>
>> * you may end with a replacement disk which is subtle
>>    smaller and hence you normally make the partition
>>    a little smaller then the device
> 
> And what does that have to do with the price of tea in China? 
> Partitioning your array doesn't have any effect on whether or not said 
> array uses the whole disk or not.
>>
>> * in case of SSD you reserve some space for
>>    better wear-levelling
> 
> And putting a partition table in your array does exactly what to help that?
>>
>> * in case you ever need to reinstall your OS you
>>    want your data not in the same filesystem
> 
> Which is why I partition my disk. I use one raid for the OS, and another 
> for my data.
but than "fdisk -l" shows partitions - what the hell.....
that above you responded to has no partitions but the whole drive for 
the RAID
