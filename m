Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658F7C64E8A
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA4420674
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 09:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389921AbgLAJVN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:21:13 -0500
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:60962 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390694AbgLAJTa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Dec 2020 04:19:30 -0500
Received: from [212.54.42.135] (helo=smtp11.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kk1o4-0001tb-GB; Tue, 01 Dec 2020 10:18:44 +0100
Received: from 94-214-94-139.cable.dynamic.v4.ziggo.nl ([94.214.94.139] helo=imail.office.romunt.nl)
        by smtp11.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kk1o4-0007q3-5i; Tue, 01 Dec 2020 10:18:44 +0100
Received: from [192.168.30.63] (arya.office.romunt.nl [192.168.30.63])
        by imail.office.romunt.nl (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 0B19IdcG003294;
        Tue, 1 Dec 2020 10:18:40 +0100
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
To:     c.buhtz@posteo.jp, antlists <antlists@youngman.org.uk>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
 <1914ec9a6f74130a8e6399c08edefdc1@posteo.de>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <556990c8-4405-3148-9d47-a85ba8aa9735@grumpydevil.homelinux.org>
Date:   Tue, 1 Dec 2020 10:18:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <1914ec9a6f74130a8e6399c08edefdc1@posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Virus-Scanned: clamav-milter 0.102.3 at hermes
X-Virus-Status: Clean
X-SourceIP: 94.214.94.139
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.4 cv=RMMNo6u+ c=1 sm=1 tr=0 ts=5fc60a74 a=MLz4jdL9LhxtSH7CRyKX8g==:17 a=IkcTkHD0fZMA:10 a=zTNgK-yGK50A:10 a=WJEWgjpcUfoA:10 a=LwaNNyJcRUxv8f4PGe4A:9 a=QEXdDO2ut3YA:10
X-Ziggo-Spam-Status: No
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 01-12-2020 09:45, c.buhtz@posteo.jp wrote:
> I think my missunderstand depends also on my bad english?
>
> Am 30.11.2020 21:51 schrieb antlists:
>> On 30/11/2020 20:05, David T-G wrote:
>>> You don't see any "filesystem" or, more correctly, partition in your
>>>
>>>    fdisk -l
>>>
>>> output because you have apparently created your filesystem on the 
>>> entire
>>> device (hey, I didn't know one could do that!).
>>
>> That, actually, is the norm. It is NOT normal to partition a raid array.
>
> In my understanding you are contradicting yourself here.
> Is there a difference between
>   "create filesystem on the entire device"
> and
>   "partition a raid array"
> ?
Yes, they are not the same.

   "create filesystem on the entire device"
you create a filesystem on the raw device, like with "mkfs.xfs /dev/sdc" 
or "mkfs.xfs /dev/md0"

a lot of people do this with raid devices, but it is rarely if ever done 
directly on HDD. afaik most installers will do this with raid devices, 
but never with normal HDD

"partition a raid array"
this means creating a partition table on the raid array, i.e. "fdisk 
/dev/md0" and creating partitions on it.
Here opinions differ. I am someone who often does this, and has 
production machines with partitioned raid :)

wols thinks it is not to be done.

Cheers

Rudy
