Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CD5ECAAD5
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 17:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiH1RRB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 13:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiH1RRA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 13:17:00 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDCD2CDF1
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 10:16:58 -0700 (PDT)
Received: from host86-128-157-135.range86-128.btcentralplus.com ([86.128.157.135] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oSLu4-0006x1-FV;
        Sun, 28 Aug 2022 18:16:57 +0100
Message-ID: <64746727-8555-291d-d569-c562fc58c55f@youngman.org.uk>
Date:   Sun, 28 Aug 2022 18:16:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: RAID 6, 6 device array - all devices lost superblock
Content-Language: en-GB
To:     Peter Sanders <plsander@gmail.com>, Phil Turmel <philip@turmel.org>
Cc:     John Stoffel <john@stoffel.org>, NeilBrown <neilb@suse.com>,
        linux-raid@vger.kernel.org
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
 <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
 <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org>
 <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/08/2022 18:01, Peter Sanders wrote:
> It was set up on the device level, not partitions.  (I remember getting 
> some advice on the web that device was better than partition... Yay for 
> internet advice)

Well, it really SHOULDN'T matter. Except there's plenty of crap software 
that says "ooh a disk with no partition table - it must be empty - let's 
initialise it without asking the user whether it's okay". Or, as in your 
case, it seems like your mobo has wiped the start of the disk for some 
reason. We now recommend partitions, not because it's better, but as a 
defensive mechanism against the idiots out there ... :-(
> 
> I'm surveying my other disks to see what I have available to do the 
> overlay attempt.
> 
> What are the size of the overlay files going to end up being?

I'm not sure what the recommendation is, I think it used to be about 
10%, but I think you'll get away with much less. If you have the space 
ELSEWHERE eg your system partition, try and allow about 1% ie 60GB per 
drive. So you want about 360GB of free space if possible.

I don't think it's dangerous if you don't allow enough space - you'll 
just hit a "disk full" on your overlays which will be a frustration but 
not a disaster. So just give it as much room as you can afford.
> 
> I did run into UEFI vs AHCI issues early in the process.. they are all 
> set to non-UEFI.
> 
> OS update was onto a new SSD...
> 
Cheers,
Wol
