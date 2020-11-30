Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2BAC83013
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 11:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9528B20679
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 11:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgK3L17 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 06:27:59 -0500
Received: from smtpq5.tb.mail.iss.as9143.net ([212.54.42.168]:53372 "EHLO
        smtpq5.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726810AbgK3L16 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 30 Nov 2020 06:27:58 -0500
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2020 06:27:57 EST
Received: from [212.54.42.136] (helo=smtp12.tb.mail.iss.as9143.net)
        by smtpq5.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kjh57-00062o-VR; Mon, 30 Nov 2020 12:10:57 +0100
Received: from 94-214-94-139.cable.dynamic.v4.ziggo.nl ([94.214.94.139] helo=imail.office.romunt.nl)
        by smtp12.tb.mail.iss.as9143.net with esmtp (Exim 4.90_1)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kjh57-0000kp-PB; Mon, 30 Nov 2020 12:10:57 +0100
Received: from [192.168.30.63] (arya.office.romunt.nl [192.168.30.63])
        by imail.office.romunt.nl (8.15.2/8.15.2/Debian-14~deb10u1) with ESMTP id 0AU9UjJ7013175;
        Mon, 30 Nov 2020 10:30:46 +0100
Subject: =?UTF-8?Q?Re=3a_=e2=80=9croot_account_locked=e2=80=9d_after_removin?=
 =?UTF-8?Q?g_one_RAID1_hard_disc?=
To:     Reindl Harald <h.reindl@thelounge.net>,
        antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <bc15926a-8bf4-14ae-bd67-ae14d915d4c0@youngman.org.uk>
 <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <ef7d7b4c-d7d2-1bff-8b13-2187889162af@grumpydevil.homelinux.org>
Date:   Mon, 30 Nov 2020 12:10:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <0fd4f7e5-b71d-0c53-baca-d483d7872981@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Virus-Scanned: clamav-milter 0.102.3 at hermes
X-Virus-Status: Clean
X-SourceIP: 94.214.94.139
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.4 cv=fshi2H0f c=1 sm=1 tr=0 ts=5fc4d341 a=MLz4jdL9LhxtSH7CRyKX8g==:17 a=IkcTkHD0fZMA:10 a=nNwsprhYR40A:10 a=5KLPUuaC_9wA:10 a=WJEWgjpcUfoA:10 a=jqUOrJaacwje6ZZu6L0A:9 a=QEXdDO2ut3YA:10
X-Ziggo-Spam-Status: No
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 30-11-2020 11:31, Reindl Harald wrote:
>
>
> Am 30.11.20 um 10:27 schrieb antlists:
>>> I read that a single RAID1 device (the second is missing) can be 
>>> accessed without any problems. How can I do that?
>>
>> When a component of a raid disappears without warning, the raid will 
>> refuse to assemble properly on next boot. You need to get at a 
>> command line and force-assemble it
>
> since when is it broken that way?
>
> from where should that commandlien come from when the operating system 
> itself is on the for no vali dreason not assembling RAID?
>
> luckily the past few years no disks died but on the office server 300 
> kilometers from here with /boot, os and /data on RAID1 this was not 
> true at least 10 years
>
> * disk died
> * boss replaced it and made sure
>   the remaining is on the first SATA
>   port
> * power on
> * machine booted
> * me partitioned and added the new drive
>
> hell it's and ordinary situation for a RAID that a disk disappears 
> without warning because they tend to die from one moment to the next
>
> hell it's expected behavior to boot from the remaining disks, no 
> matter RAID1, RAID10, RAID5 as long as there are enough present for 
> the whole dataset
>
> the only thing i expect in that case is that it takes a little longer 
> to boot when soemthing tries to wait until a timeout for the missing 
> device / componenzt
>
>
The behavior here in the post is rather debian specific. The initrd from 
debian refuses to continue  if it cannot get all partitions mentioned in 
the fstab. On top i suspect an error in the initrd that the OP is using 
which leads to the raid not coming up with a single disk.

The problems from the OP have imho not much to do with raid, and a lot 
with debian specific issues/perhaps a mistake from the OP

Cheers

Rudy
