Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B91C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 18:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2277A60D07
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 18:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbhERScv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 14:32:51 -0400
Received: from mail.thelounge.net ([91.118.73.15]:55857 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244333AbhERSco (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 14:32:44 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Fl4Mc2vjkzXN3;
        Tue, 18 May 2021 20:31:24 +0200 (CEST)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Christopher Thomas <youkai@earthlink.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
 <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
Date:   Tue, 18 May 2021 20:31:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 18.05.21 um 19:47 schrieb Phil Turmel:
> On 5/17/21 9:19 AM, Roman Mamedov wrote:
>> On Mon, 17 May 2021 05:36:42 -0500
>> Roger Heflin <rogerheflin@gmail.com> wrote:
>>
>>> When I look at my 1.2 block, the mdraid header appears to start at 
>>> 4k, and
>>> the gpt partition table starts at 0x0000 and ends before 4k.
>>>
>>> He may be able to simply delete the partition and have it work.
>>
>> Christopher wrote that he tried:
>>
>> chris@ursula:~$ sudo /sbin/mdadm --verbose --assemble /dev/md0
>> /dev/sdb /dev/sdc /dev/sdd
>> mdadm: looking for devices for /dev/md0
>> mdadm: Cannot assemble mbr metadata on /dev/sdb
>> mdadm: /dev/sdb has no superblock - assembly aborted
>>
>> I would have expected mdadm when passed entire devices (not 
>> partitions) to not
>> even look if there are any partitions, and directly proceed to 
>> checking if
>> there's a superblock at its supposed location. But maybe indeed, from the
>> messages it looks like it bails before that, on seeing "mbr metadata", 
>> i.e.
>> the enclosing MBR partition table of GPT.
>>
> 
> The Microsoft system partition starts on top of the location for v1.2 
> metadata.
> 
> Just another reason to *never* use bare drives

the most important is that you have no guarantee that a replacement 
drive years later is 100% identical in size

leave some margin and padding around the used space solves that problem 
entirely and i still need to hear a single valid reason for using 
unpartitioned drives in a RAID


