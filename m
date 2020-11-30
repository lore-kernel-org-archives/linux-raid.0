Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBB7C64E7B
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 14:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79F652076C
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 14:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgK3OrB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 09:47:01 -0500
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:50418 "EHLO
        smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726886AbgK3OrA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 09:47:00 -0500
Received: from [212.54.42.134] (helo=smtp10.tb.mail.iss.as9143.net)
        by smtpq1.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kjkRS-0001vF-Sl; Mon, 30 Nov 2020 15:46:14 +0100
Received: from 94-214-94-139.cable.dynamic.v4.ziggo.nl ([94.214.94.139] helo=imail.office.romunt.nl)
        by smtp10.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kjkRS-0003In-Hx; Mon, 30 Nov 2020 15:46:14 +0100
Received: from [192.168.30.63] (arya.office.romunt.nl [192.168.30.63])
        by imail.office.romunt.nl (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 0AUD5vrZ014832;
        Mon, 30 Nov 2020 14:05:58 +0100
Subject: =?UTF-8?Q?Re=3a_=e2=80=9croot_account_locked=e2=80=9d_after_removin?=
 =?UTF-8?Q?g_one_RAID1_hard_disc?=
To:     Reindl Harald <h.reindl@thelounge.net>,
        antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
 <5FC4DEED.9030802@youngman.org.uk>
 <832e1194-cc76-b8f8-cb59-2e6bedaeb4dc@thelounge.net>
 <a5288edf-0f77-d813-2f68-995dc4be2ca5@youngman.org.uk>
 <2fbc2ed0-9d0b-cbd1-7ec9-435633131d7d@thelounge.net>
 <20b1b87d-f20d-81e6-efd7-f95e998471b4@youngman.org.uk>
 <cba9270d-78d4-f8aa-9f34-fce0fbb15acf@thelounge.net>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <e4143d4b-bddc-7150-77a7-e7dc3f7eda25@grumpydevil.homelinux.org>
Date:   Mon, 30 Nov 2020 15:46:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <cba9270d-78d4-f8aa-9f34-fce0fbb15acf@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Virus-Scanned: clamav-milter 0.102.3 at hermes
X-Virus-Status: Clean
X-SourceIP: 94.214.94.139
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.4 cv=HZuq8gI8 c=1 sm=1 tr=0 ts=5fc505b6 a=MLz4jdL9LhxtSH7CRyKX8g==:17 a=IkcTkHD0fZMA:10 a=nNwsprhYR40A:10 a=5KLPUuaC_9wA:10 a=WJEWgjpcUfoA:10 a=kZZ36MqhxPbGT_Y0GI8A:9 a=QEXdDO2ut3YA:10
X-Ziggo-Spam-Status: No
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 30-11-2020 14:53, Reindl Harald wrote:
>
>
> Am 30.11.20 um 14:47 schrieb antlists:
>> On 30/11/2020 13:16, Reindl Harald wrote:
>>>
>>>
>>> Am 30.11.20 um 14:11 schrieb antlists:
>>>> On 30/11/2020 12:13, Reindl Harald wrote:
>>>>> but i fail to see the difference and to understand why reality and 
>>>>> superblock disagree,
>>>>
>>>> In YOUR case the array was degraded BEFORE shutdown. In the OP's 
>>>> case, the array was degraded AFTER shutdown
>>>
>>> no, no and no again!
>>>
>>> * the array is full opertional
>>> * smartd fires a warning
>>
>> Ahhh ... but you said in your previous post(s) "the disk died". Not 
>> that it was just a warning.
>>
>>> * the machine is shut down
>>> * after that the drive is replaced
>>> * so the array get degraded AFTER shutdown
>>> * at power-on RAID partitions are missing
>>>
>> But we've had a post in the last week or so of someone who's array 
>> behaved exactly as I described. So I wonder what's going on ...
>>
>> I need to get my test system up so I can play with these sort of 
>> things...
>
> and that's why i asked since when it's that broken
>
> i expect a RAID simply coming up as nothign happened as long there are 
> enough disks remaining to have the complete dataset
>
> it's also not uncommon that a disk dies between power-cycles aka 
> simply don't come up again which is the same as replace it when the 
> machine is powered off
>
> i replaced a ton of disks in Linux RAID1/RAID10 setups over the years 
> that way and in some cases i cloed machines by put 2 out of 4 RAID10 
> disks in a new machine and insert 2 blank disks in both
>
> * spread the disks between both machines
> * power on
> * login via SSH
> * start rebuild the array on both
> * change hostname and network config of one
>
> for me it's an ordinary event a RAID has to cope without interaction 
> *before* boot to a normal OS state and if it doesn't it's a serious bug
>
Same thing here...

which is also why i am saying that in addition to the normal behavior of 
debian initrd, i think the OP has made another mistake. This should just 
work.
