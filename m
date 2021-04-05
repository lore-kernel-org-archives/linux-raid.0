Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF08C433ED
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 18:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39018611BE
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 18:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhDESAf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 14:00:35 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:52584 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237515AbhDESAe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 5 Apr 2021 14:00:34 -0400
Received: from host86-156-102-23.range86-156.btcentralplus.com ([86.156.102.23] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lTT2T-0008gG-5q; Mon, 05 Apr 2021 18:29:26 +0100
Subject: Re: bitmaps on xfs (was "Re: how do i bring this disk back into the
 fold?")
To:     Roger Heflin <rogerheflin@gmail.com>,
        David T-G <davidtg-robot@justpickone.org>
Cc:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20210328021210.GA1415@justpickone.org>
 <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk>
 <20210402050554.GF1415@justpickone.org>
 <CAAMCDecNM8X9tdWo-WKpQA3BE=_J=XKc1D75rcQiQN0owZ9kJQ@mail.gmail.com>
 <20210405034659.GG1415@justpickone.org>
 <CAAMCDecX3nawcYC4hFX+VjQTiHPaZDUb1RcM66=OBFoxhLwY4Q@mail.gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <5f58e78d-8d8c-c66c-7674-79832e22f200@youngman.org.uk>
Date:   Mon, 5 Apr 2021 18:29:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAAMCDecX3nawcYC4hFX+VjQTiHPaZDUb1RcM66=OBFoxhLwY4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 05/04/2021 12:30, Roger Heflin wrote:
>>    diskfarm:~ # grep /mnt/ssd /etc/fstab
>>    LABEL=diskfarm-ssd      /mnt/ssd        xfs     defaults        0  0
>>
>> will work for my bitmap files target, since all I see is that it must be
>> an ext2 or ext3 (not ext4? old news?) device.

Bear in mind you're better off using a journal (and bitmaps and journals 
are incompatible).

"not ext4" seems odd to me because - from a kernel point of view - ext's 
2 and 3 no longer longer exist.
>>
> I don't know, I have always done mine internal.   I could see some
> advantage to have it on a SSD vs internally.  I may have to try that,
> I am about to do some array reworks to go from all 3tb disks to start
> using some 6tb disks.   If the file was pre-allocated I would not
> think it would matter which.    The page is dated 2011 so that would
> have been old enough that no one tested ext4/xfs.
> 
Umm... don't use all the space on your 6TB disks. I'm planning to build 
my arrays on dm-integrity, which will make raid 5 a bit more trustworthy.

> I was going to tell you you could just create a LV and format it ext3
> and use it, but I see it appears you are using direct partitions only.

Ny new system? 4TB disks, with one terabyte raided and lvm on top for 
root partitions (I'll be configuring it multi-boot or VMs...). Then 
three terabytes with dm-integrity at the bottom, then raid, then lvm on 
top for /home and backup snapshots.

Cheers,
Wol
