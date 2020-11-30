Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFB1C63777
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 00:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58D3A207FF
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 00:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgLAAAH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 19:00:07 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:31611 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbgLAAAG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 19:00:06 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kjt4m-0006Ik-59; Mon, 30 Nov 2020 23:59:24 +0000
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
To:     Reindl Harald <h.reindl@thelounge.net>,
        David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
 <2d0fcd02-9e3a-d11a-a1cf-a47c1b6ce2c3@thelounge.net>
 <e2a9d347-0703-07a6-0128-adf86b35b6f3@youngman.org.uk>
 <885c2c55-2798-e277-07e7-77684e279cb5@thelounge.net>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <4829b8e2-5ba5-8ba8-6853-88d36f438c71@youngman.org.uk>
Date:   Mon, 30 Nov 2020 23:59:24 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <885c2c55-2798-e277-07e7-77684e279cb5@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/11/2020 23:21, Reindl Harald wrote:
>> And putting a partition table in your array does exactly what to help 
>> that?
>>>
>>> * in case you ever need to reinstall your OS you
>>>    want your data not in the same filesystem
>>
>> Which is why I partition my disk. I use one raid for the OS, and 
>> another for my data.
> but than "fdisk -l" shows partitions - what the hell.....
> that above you responded to has no partitions but the whole drive for 
> the RAID

Yup - the raid sits directly on top of the hard drive - AND IS ITSELF 
PARTITIONED.

Both of those are not normal - it is not normal for a raid to sit on 
bare drives, and it is not normal for a raid to contain partitions.

(Although there's nothing actually wrong with either :-)

Cheers,
Wol
