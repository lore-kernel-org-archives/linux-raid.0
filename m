Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B6FC433FE
	for <linux-raid@archiver.kernel.org>; Tue, 18 Oct 2022 07:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJRHE3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Oct 2022 03:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJRHEZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Oct 2022 03:04:25 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEC9289
        for <linux-raid@vger.kernel.org>; Tue, 18 Oct 2022 00:04:20 -0700 (PDT)
Received: from host86-161-232-249.range86-161.btcentralplus.com ([86.161.232.249] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1okgeA-0006Ga-4T;
        Tue, 18 Oct 2022 08:04:18 +0100
Message-ID: <6e6fa554-adb4-18f3-894e-e65ebcf9ccef@youngman.org.uk>
Date:   Tue, 18 Oct 2022 08:04:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Rebuilding mdadm RAID array after OS drive failure
Content-Language: en-GB
To:     Steve Kolk <stevekolk@gmail.com>, anthony <antmbox@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
References: <CACZftsg4Cg5UM8derE46m2JgHWFAoNYFvDXbFKfoU4Jrbmhx_g@mail.gmail.com>
 <499878ba-c52a-0041-e4b1-697bce7c9fba@youngman.org.uk>
 <CACZftsgxix6fQQE8dS0nnYvxPOgv10PQE8wt6z=WBeytcOaAdw@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CACZftsgxix6fQQE8dS0nnYvxPOgv10PQE8wt6z=WBeytcOaAdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/10/2022 23:46, Steve Kolk wrote:
> I set up 3 of the drives with overlays and tried forcing the assembly,
> but I still get the same error. I haven't tried the steps under
> "Irreversible mdadm failure recovery", is there where I need to go
> next?
> 
> ubuntu@ubuntu:~$ echo $OVERLAYS
> /dev/mapper/sda1 /dev/mapper/sdb1 /dev/mapper/sdc1
> ubuntu@ubuntu:~$ sudo mdadm --assemble --force /dev/md1 $OVERLAYS
> mdadm: no recogniseable superblock on /dev/mapper/sda1
> mdadm: /dev/mapper/sda1 has no superblock - assembly aborted

Sounds like you haven't understood what you're supposed to do.

The whole point of overlays is it is meant to protect the underlying 
device while you do stuff that could be destructive.

What you should be doing is setting up the overlays, then running "mdadm 
--create". It sounds like if you run exactly the same command as when 
you created the array, you'll get the original back.

Read up carefully on overlays to make sure you really understand what 
you're doing. And then when you create the array with the overlays, if 
you're doing as I suggested with three drives, make sure you tell it 
it's a five drive array, and tell it two of the drives are missing.

I'm just going to work, but whatever you do, DO NOT DO ANYTHING THAT 
WILL ACTUALLY WRITE TO THE DRIVES.

Cheers,
Wol
