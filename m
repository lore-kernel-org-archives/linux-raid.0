Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED31CC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 20:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDD6D61994
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 20:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245354AbhI3UkX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:40:23 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:24563 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhI3UkX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 30 Sep 2021 16:40:23 -0400
Received: from host86-157-192-80.range86-157.btcentralplus.com ([86.157.192.80] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mW0Ts-000CDF-FZ; Thu, 30 Sep 2021 19:08:29 +0100
Subject: Re: Missing superblock on two disks in raid5
To:     Clemens Kiehas <clemens@kiehas.at>, linux-raid@vger.kernel.org
References: <d0350f88-304f-040d-6901-76f72932bbbf@kiehas.at>
 <a66ec5ed-eeba-6c86-24b7-b3fd061082b9@kiehas.at>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <1241748e-5cfb-474d-3da1-a9f28ed691f2@youngman.org.uk>
Date:   Thu, 30 Sep 2021 19:11:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a66ec5ed-eeba-6c86-24b7-b3fd061082b9@kiehas.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 30/09/2021 18:21, Clemens Kiehas wrote:
> Hello,
> 
> until recently I was using Unraid with 8 disks in an XFS array.
> I installed Debian on a spare SSD on the same machine and started 
> migrating disk by disk from the Unraid array to a raid5 array using a 
> second server as temporay storage. So I switched between Debian and 
> Unraid a lot to copy data and remove/add drives from/to arrays.
> 
>  From the beginning I always had to assemble the array without /dev/sdd, 
> add it afterwards and let it rebuild - since the array was working fine 
> afterwards I didn't really think much of it.

Not wise - as you've found out it was trashing your redundancy ...

> Appearently Unraid always overwrote the superblock of that 1 (and later 
> 2) disks (/dev/sdc and /dev/sdd) when I switched between the two OSs and 
> now mdadm isn't recognizing those 2 disks and I can't assemble the array 
> obviously.
> At least that's what I think happened, since file tells me that the 
> first 32k bytes are XFS:
> # losetup -o 32768 -f /dev/sdd
> # file -s /dev/loop0
> /dev/loop0: SGI XFS filesystem data (blksz 4096, inosz 512, v2 dirs)

That feels good, but I'm not sure how to proceed from here.
> 
> Right now mdadm only assembles 5 (instead of 7) disks as spares into an 
> inactive array at boot:
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md0 : inactive sde[6](S) sdf1[5](S) sdg[1](S) sdh[3](S) sdi[8](S)
>        21487980896 blocks super 1.2
> unused devices: <none>
> 
> My system:
> Linux titan 5.10.0-8-amd64 #1 SMP Debian 5.10.46-4 (2021-08-03) x86_64 
> GNU/Linux
> mdadm - v4.1 - 2018-10-01
> 
> Maybe I could try to assemble it with assume-clean and read-only?
> I found some pages in the wiki but I'm not 100% sure that they will 
> solve my problem and I don't want to make things worse.
> https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
> 
The first page talks about overlays. THEY WILL PROTECT YOUR DATA.

Make sure every disk is overlayed, then try assembling the overlays with 
your assume-clean. You won't need read-only but do it if you like it 
then do.

If you can then mount and run a fsck or whatever it is over the file 
system and it says everything is clean, then you can redo it without the 
overlays and recover the array properly. If it's messed up, just tear 
down the overlays and you're back where you started.

If it doesn't work, come back and tell us what happened (if it does 
work, please let us know :-)

Cheers,
Wol
