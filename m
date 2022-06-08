Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62A3C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 17:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiFHRGi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 13:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344109AbiFHRBY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 13:01:24 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8953D9F99
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 09:52:51 -0700 (PDT)
Received: from host86-156-102-78.range86-156.btcentralplus.com ([86.156.102.78] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nyyvJ-0009jq-BY;
        Wed, 08 Jun 2022 17:52:49 +0100
Message-ID: <b14b62c9-1494-935f-f9f0-43f8083e8547@youngman.org.uk>
Date:   Wed, 8 Jun 2022 17:52:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Misbehavior of md-raid RAID on failed NVMe.
Content-Language: en-GB
To:     Pavel <pavel2000@ngs.ru>, linux-raid@vger.kernel.org
References: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 08/06/2022 04:48, Pavel wrote:
> Hi, linux-raid community.
> 
> Today we found a strange and even scaring behavior of md-raid RAID based 
> on NVMe devices.
> 
> We ordered new server, and started data transfer (using dd, filesystems 
> was unmounted on source, etc - no errors here).

Did you dd the raid device (/dev/md0 for example), or the individual 
nvme devices?
> 
> While data in transfer, kernel started IO errors reporting on one of 
> NVMe devices. (dmesg output below)
> But md-raid not reacted on them in any way. RAID array not went into any 
> failed state, and "clean" state reported all the time.

This is actually normal, correct and expected behaviour. If the raid 
layer does not report a problem to dd, the data should have copied 
correctly. And raid really only reports problems if it gets write failures.
> 
> Based on earlier practice, we trusted md-raid and thought things goes ok.
> After data transfer finished, server was turned off and cables was 
> replaced on suspicion.
> 
> After OS started on this new server, we found MySQL crashes.
> Thorough checksum check showed us mismatches on files content.
> (Of course, we did checksumming of untouched files, not MySQL database 
> files)
> 
> So, there is data-loss possible when NVMe device behaves wrong.
> We think, md-raid has to remove failed device from raid in a such case.
> That it didn't happen is wrong behaviour, so want to inform community 
> about finding.
> 
> Hope, this will help to make kernel ever better.
> Thanks for your work.

Unfortunately, you're missing a lot of detail to help us diagnose the 
problem. What raid level are you using, for starters. It sounds like 
there is a problem, but as Mariusz implies, it looks like a faulty nVME 
device. And if that device is lying to linux, as appears likely (my 
guess is that raid is trying to fix the data, and the drive is just 
losing the writes), then there is precious little we can do about it.

Cheers,
Wol
