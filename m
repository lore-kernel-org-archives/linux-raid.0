Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01340C54EBE
	for <linux-raid@archiver.kernel.org>; Mon, 16 Jan 2023 11:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjAPLpf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Jan 2023 06:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjAPLpD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Jan 2023 06:45:03 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170321CAD0
        for <linux-raid@vger.kernel.org>; Mon, 16 Jan 2023 03:45:00 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pHNv8-00088Y-Ct;
        Mon, 16 Jan 2023 11:44:59 +0000
Message-ID: <3199b9d7-3974-a953-e101-f48d8661fd2b@youngman.org.uk>
Date:   Mon, 16 Jan 2023 11:44:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Fwd: RAID 5 growing hanged at 0.0%
Content-Language: en-GB
To:     Tiago Afonso <tiaafo@gmail.com>, linux-raid@vger.kernel.org
References: <CAMnA3U1b6n34SzNh9RQROyP-=AkN9ZsLunm_aokV+BDAeR2vrw@mail.gmail.com>
 <CAMnA3U00_JONs-e8afbUE+EOf2Zex0wOKSaWc1YxeF5hQh5nQQ@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
In-Reply-To: <CAMnA3U00_JONs-e8afbUE+EOf2Zex0wOKSaWc1YxeF5hQh5nQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16/01/2023 11:12, Tiago Afonso wrote:
> Hi,
> 
> Long story short, the bigger story is here:
> https://forum.openmediavault.org/index.php?thread/45829-raid-5-growing-hanged-at-0-0/
> I had a 4x4TB raid5 configuration and I added a new 4TB drive in order
> to grow the array as 5x4TB raid5. I did this via openmediavault GUI
> (my mistake, maybe I should have checked tutorials and more info on
> how to do it properly). The reshape started but hung right at the
> beginning.
> 
> root@openmediavault:~# cat /proc/mdstat Personalities : [raid6]
> [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10] md127 :
> active raid5 sdh[4] sdg[7] sdf[6] sde[5] sdi[8] 11720661504 blocks
> super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
> [>....................] reshape = 0.0% (1953276/3906887168)
> finish=2008857.0min speed=32K/sec bitmap: 6/30 pages [24KB], 65536KB
> chunk
> 
> I forced shutdown the process by pulling the power, as it was not
> letting me stop the process otherwise. Even put the disks in another
> machine to no avail. The problem seems to be that the array was not
> healthy and there were bad-blocks, and I think that is why it keeps
> stopping the reshape. The bad-blocks are in two of the HDDs and it
> seems they are the same block. Now I'm stuck. I'm unable to reshape
> back to 4 HDDs (I did try this) or access the data.
> 
> How can I get out of this situation and recover the data back even if
> not all data?
> 
> I read the wiki, but I don't have much experience in linux or raid.
> I'm afraid of doing something that puts me in an even worse situation.
> 
> Attached are some commands output.
> 
> 
> Thank you.

Thanks. Looks like you've done your homework :-)

I was about to say this looks like a well-known problem, and then I saw 
the mdadm version and the kernel. You should not be getting that problem 
with something this up-to-date.

The good news is this still looks like that problem, but the question is 
what on earth is going on. Can you boot into a rescue disk rather than 
the mediavault stuff?

The array is clean but degraded. Not knowing what you've done, I'm not 
sure how to put the array together again, but the really good news is it 
looks like - because the reshape never started - it shouldn't be a hard 
job to retrieve everything. Then we can start sorting things out from there.

I'm going to bring in the two experts - they might take a little while 
to respond - but in the meantime two points to ponder ...

(1) raid badblocks are a mis-feature, as soon as we get the array back, 
we want them gone.
(2) "SCT Error Recovery not supported" - Your blues are not suitable 
raid drives. I've got Barracudas, and you shouldn't use those in raid 
either, so it's not immediately serious, but you want something like a 
Seagate IronWolf, or Toshiba N300. I avoid WD for precisely this reason 
- they tend to advertise stuff as suitable when it isn't.

If you can afford it (they're not cheap) you might consider getting four 
decent raid drives, backing up your existing drives, and then fixing it 
when the experts chime in. I'm guessing an "assemble no-bad-blocks 
force" will fix everything, but I'm hesitant to say "go ahead and try it".

Cheers,
Wol
