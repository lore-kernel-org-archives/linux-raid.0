Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7A1C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jan 2022 20:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347785AbiARULO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jan 2022 15:11:14 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:44775 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348818AbiARULK (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 Jan 2022 15:11:10 -0500
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2022 15:11:09 EST
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antmbox@youngman.org.uk>)
        id 1n9uot-000A18-A6;
        Tue, 18 Jan 2022 20:11:07 +0000
Message-ID: <aeb5522f-b9af-7675-308a-e2b2fdc797b6@youngman.org.uk>
Date:   Tue, 18 Jan 2022 20:11:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: The mysterious case of the disappearing superblock ...
Content-Language: en-GB
To:     Phil Turmel <philip@turmel.org>,
        Linux RAID <linux-raid@vger.kernel.org>
Cc:     NeilBrown <neilb@suse.com>
References: <2fa7a4a8-b6c2-ac2f-725b-31620984efce@youngman.org.uk>
 <d5fe9e4e-0593-9ebd-255b-7f28bc4fb272@turmel.org>
From:   anthony <antmbox@youngman.org.uk>
In-Reply-To: <d5fe9e4e-0593-9ebd-255b-7f28bc4fb272@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18/01/2022 20:00, Phil Turmel wrote:
>> Firstly, given that superblocks seem to disappear every now and then, 
>> does anybody have any ideas for something that might help us track it 
>> down? The 1.2 superblock is 4K into the device I believe? So if I copy 
>> the first 8K ( dd if=/dev/sda4 of=sda4.img bs=4K count=2 ) of each 
>> partition, that might help provide any clues as to what's happened to 
>> it? What am I looking for? What is the superblock supposed to look like?
> 
> Well, I've gone to the kernel code for the structure definition a few 
> times, but never really got much out of it that mdadm -E didn't supply.
> 
Well, I was hoping if I looked at it with a hex editor, and knew what I 
was looking for where, I might get a clue ...

> Those seem to be missing from your mail, at least for the still-working 
> drives....
> 
> Wait: they're gone from all three?

mdadm --examine ...
No md superblock detected

Ouch!

And no, all the stuff I tell people they should do, I haven't ... I had 
so much grief with systemd, and dm-integrity, and getting stuff working, 
that I never got round to being sensible ... :-(

Cheers,
Wol
