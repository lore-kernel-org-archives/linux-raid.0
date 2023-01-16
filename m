Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849E7C46467
	for <linux-raid@archiver.kernel.org>; Mon, 16 Jan 2023 12:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjAPMXX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Jan 2023 07:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjAPMXV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Jan 2023 07:23:21 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7FF1CF62
        for <linux-raid@vger.kernel.org>; Mon, 16 Jan 2023 04:23:18 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pHOWD-0009xp-3L;
        Mon, 16 Jan 2023 12:23:17 +0000
Message-ID: <02c27a6b-1675-16ca-5261-78b02f7142f4@youngman.org.uk>
Date:   Mon, 16 Jan 2023 12:23:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Fwd: RAID 5 growing hanged at 0.0%
Content-Language: en-GB
To:     Tiago Afonso <tiaafo@gmail.com>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
References: <CAMnA3U1b6n34SzNh9RQROyP-=AkN9ZsLunm_aokV+BDAeR2vrw@mail.gmail.com>
 <CAMnA3U00_JONs-e8afbUE+EOf2Zex0wOKSaWc1YxeF5hQh5nQQ@mail.gmail.com>
 <3199b9d7-3974-a953-e101-f48d8661fd2b@youngman.org.uk>
 <CAMnA3U0NfnunoTfQJ5VmkRVWFP3KCXU4ZZgmY7zTMHaHrL2CUw@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAMnA3U0NfnunoTfQJ5VmkRVWFP3KCXU4ZZgmY7zTMHaHrL2CUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16/01/2023 12:04, Tiago Afonso wrote:
> I'm now at this state.
> Regarding (2): Yeah, I know that. I'm slowly replacing them with REDs.

IS THAT A PLAIN RED!

That's probably what's causing the rebuild to hang if so !!!

Your log contained four drives, all blues. Modern WD Reds are SMR 
drives, rebuilding a raid will cause them to hang ...

That's why I don't touch WD.

Oh - and if the fifth drive isn't available, that could be causing the 
revert-reshape to fail.


 > Then tried to assemble it back with just 4 HDDs, the original 4 HDDs:

 > root@openmediavault:~# mdadm --assemble --force /dev/md127 /dev/sda
 > /dev/sdb /dev/sdd /dev/sde
 > mdadm: Marking array /dev/md127 as 'clean'
 > mdadm: /dev/md127 has been started with 4 drives (out of 5).

This takes it well out of my comfort zone. I'm sure all the information 
is there, and it's probably just a case of clearing the degraded flag, 
but that force was not a wise idea. You've just mucked up the drive 
configuration data and now pretty much everything will fail.

When the experts chime in they should be able to sort it, but I'm now 
well out of my depth. Maybe just forcing the fifth drive back in, but no 
I am NOT suggesting you try ...

Cheers,
Wol
