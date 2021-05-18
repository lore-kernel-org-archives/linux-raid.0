Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6B1C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 17:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F4660FE3
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 17:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345315AbhERRsk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 13:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbhERRsk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 13:48:40 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685CBC061573
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 10:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eT9R6GJCM8t/EZbiQIzpi6p2448lhLwREnn/wHIKDZw=; b=Pk0pJPRxrQuGGK0SZuwMFcImD0
        mrziu5iaOlslL8O4TOHxgLgsu5exnQsso/a+3GcilOYqRTQllKssUGPvE1RjNADYQ63k7MlunKaeH
        QWZOxmDy/0smAbDabzhtWz7hNu7JEC5uYaOnV3vu4ZKG0topqGVSPu8QeF0G9T5mtLmVDWC8yhQRu
        yuh8NirBB4oNv3CF5RgoxEz6riQEXs3SMlk64Fyp+FYV5b/wbT/lu8I2l+blBxAO5oJHba9OO/VMx
        dERz8tFk4Bk4LO/LUnnMTTPX5f3/IC80ehZ/VLtIoMDEY8uV1ZzvNm5xOKVtStpQRDqs93b20YCbW
        9WROYuqw==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lj3oN-0001Xb-Sy; Tue, 18 May 2021 17:47:19 +0000
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Christopher Thomas <youkai@earthlink.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
Date:   Tue, 18 May 2021 13:47:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517181905.6f976f1a@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/17/21 9:19 AM, Roman Mamedov wrote:
> On Mon, 17 May 2021 05:36:42 -0500
> Roger Heflin <rogerheflin@gmail.com> wrote:
> 
>> When I look at my 1.2 block, the mdraid header appears to start at 4k, and
>> the gpt partition table starts at 0x0000 and ends before 4k.
>>
>> He may be able to simply delete the partition and have it work.
> 
> Christopher wrote that he tried:
> 
> chris@ursula:~$ sudo /sbin/mdadm --verbose --assemble /dev/md0
> /dev/sdb /dev/sdc /dev/sdd
> mdadm: looking for devices for /dev/md0
> mdadm: Cannot assemble mbr metadata on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
> 
> I would have expected mdadm when passed entire devices (not partitions) to not
> even look if there are any partitions, and directly proceed to checking if
> there's a superblock at its supposed location. But maybe indeed, from the
> messages it looks like it bails before that, on seeing "mbr metadata", i.e.
> the enclosing MBR partition table of GPT.
> 

The Microsoft system partition starts on top of the location for v1.2 
metadata.

Just another reason to *never* use bare drives.

Sorry, Christopher.  You will have to experiment with --create.  Use 
overlays.

Phil
