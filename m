Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034D9C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jan 2022 20:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349041AbiARUBE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jan 2022 15:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349013AbiARUAo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Jan 2022 15:00:44 -0500
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E0AC061574
        for <linux-raid@vger.kernel.org>; Tue, 18 Jan 2022 12:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fnq+uSh9mXYVj3sp/rH4rzFx4DS1MibCx5l7Nj0NgL8=; b=KHEMOP7H0NLZYn6Ld04Etlholy
        myiJ8QDyzWhAY9u39RebqC+AppQcMD1DiJraCyKfijSQjtMuokgp3PE+4TmHJ6XfSbfR4a3hFfnrB
        OAh6lf1phRsAJ7kEkyIOyFsMJ4StMplc2Rek/9UO6K9iDqau1yvJZ2kXJ26FLcVJIuzDn766iUK3g
        OhCJtMimuGKUrkR+5JcVWApKFvrBRxQVaGVL5k5Wbt7RmHhYd/L/wt3U6WsGd1VqF3OEo7xuopNWl
        c/CcK9ebowdEUO134WIWyJr5RITzWjMxfBnPn2vlnnE7pFKlE+rBB6cTzQ16KCrkKon1d93e6qPBB
        ArOU16jQ==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1n9ueo-0001E5-Gf; Tue, 18 Jan 2022 20:00:42 +0000
Subject: Re: The mysterious case of the disappearing superblock ...
To:     anthony <antmbox@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
Cc:     NeilBrown <neilb@suse.com>
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <d5fe9e4e-0593-9ebd-255b-7f28bc4fb272@turmel.org>
Date:   Tue, 18 Jan 2022 15:00:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Anthony,

On 1/18/22 2:51 PM, anthony wrote:
> You all know the story of how the cobbler's children are the worst shod, 
> I expect :-) Well, the superblock to my raid (containing /home, etc) has 
> disappeared, and I don't have a backup ... (well I do but it's now well 
> out of date).

Glitch when writing something else.  Who knows.

> So, a new hard drive is on order, for backup ...
> 
> Firstly, given that superblocks seem to disappear every now and then, 
> does anybody have any ideas for something that might help us track it 
> down? The 1.2 superblock is 4K into the device I believe? So if I copy 
> the first 8K ( dd if=/dev/sda4 of=sda4.img bs=4K count=2 ) of each 
> partition, that might help provide any clues as to what's happened to 
> it? What am I looking for? What is the superblock supposed to look like?

Well, I've gone to the kernel code for the structure definition a few 
times, but never really got much out of it that mdadm -E didn't supply.

Those seem to be missing from your mail, at least for the still-working 
drives....

Wait: they're gone from all three?

> Secondly, once I've backed up my partitions, I obviously need to do 
> --create --assume-clean ... The only snag is, the array has been 
> rebuilt, so I doubt my data offset is the default. The history of the 
> array is simple. It's pretty new, so it will have been created with the 
> latest mdadm, and was originally a mirror of sda4 and sdb4.
> 
> A new drive was added and the array upgraded to raid-5, and I BELIEVE 
> the order is sdc4, sda4, sdb1 - sdb1 being the new drive that was added.

No mdadm -E at all?

Never ran lsdrv and tucked away the output?

> Am I safe to assume that sdc4 and sda4 will have the same data offset? 
> What is it likely to be? And seeing as it was the last added am I safe 
> to assume that sdb1 is the last drive, so all I have to do is see which 
> way round the other two should be?

Not safe.  But there's only six combinations.

> At least the silver lining behind this, is that having been forced to 
> recover my own array, I'll understand it much better helping other 
> people recover theirs!
> 
> Cheers,
> Wol

Phil
