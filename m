Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0937C3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 08:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjAOIlw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 03:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjAOIlu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 03:41:50 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B069EB475
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 00:41:48 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pGyaI-0008Nb-Ao;
        Sun, 15 Jan 2023 08:41:46 +0000
Message-ID: <37a150cb-286b-4137-bb72-08e2de21c851@youngman.org.uk>
Date:   Sun, 15 Jan 2023 08:41:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 03:12, H wrote:
> I need to transfer an existing CentOS 7 non-RAID setup using one single SSD to a mdadm RAID1 using two much larger SSDs. All three disks exist in the same computer at the same time. Both the existing SSD and the new ones use LVM and LUKS and the objective is to preserve the OS, all other installed software and data etc. Thus no new installation should be needed.
> 
> Since all disks, partitions, LUKS etc have their unique UUIDs I have not figured out how to do this and could use help and advice.

Most of this should just happen automagically. The main thing you need 
to know is the UUIDs of your filesystem partitions. However, I don#t 
know LUKS, so I can't tell you what will happen there.

I don't remember any special setup for my LVM/RAID. If, when you boot 
the old system, everything is visible to it, there should be no problem 
switching over ...
> 
> In preparation for the above, I have:
> 
> - Used rsync with the flags -aAXHv to copy all files on the existing SSD to an external harddisk for backup.
> 
> - Partitioned the new SSDs as desired, including LVM and LUKS. My configuration uses one RAID1 for /boot, another RAID1 partition for /boot/efi, and a third one for the rest which also uses LVM and LUKS. I actually used a DVD image of Centos 7 (minimal installation) to accomplish this which also completed the minimal installation of the OS on the new disks. It boots as expected and the RAID partitions seem to work as expected.

Are your /boot and /boot/efi using superblock 1.0? My system is 
bios/grub, so not the same, but I use plain partitions here because 
otherwise you're likely to get in a circular dependency - you need efi 
to boot, but the system can't access efi until it's booted ... oops!
> 
> Since I want to actually move my existing installation from the existing SSDs, I am not sure whether I should just use rsync to copy everything from the old SSD to the new larger ones. However, I expect that to also transfer all OS files using the old, now incorrect UUIDs, to the new disks after which nothing will work, thus I have not yet done that. I could erase the minimal installation of the OS on the new disks before rsyncing but have not yet done so.
> 
Most filesytems are capable of growing. WORKING FROM A RESCUE DISK I 
would use dd to copy the filesystems (root in particular), then grow them.

> I fully expect to have to do some manual editing of files but am not quite sure of all the files I would need to edit after such a copy. I have some knowledge of linux but could use some help and advice. For instance, I expect that /etc/fstab and /etc/crypttab would need to be edited reflecting the UUIDs of the new disks, partitions and LUKS, but which other files? Grub2 would also need to be edited I would think.
> 
> The only good thing is that since both the old disk and the new disks are in the same computer, no other hardware will change.
> 
> Is there another, better (read: simpler) way of accomplishing this transfer?
> 
> Finally, since I do have a backup of the old SSD and there is nothing of value on the new mdadm RAID1 disks, except the partition information, I do have, if necessary, the luxury of multiple tries. What I cannot do, however, is to make any modifications to the existing old SSD since I cannot afford not being able to go back to the old SSD if necessary.
> 
Okay, baby steps. Try to boot the OLD system from the NEW efi. I suspect 
you'll fail. Fix that.

Copy the old root filesystem to the new. Fix the new efi/grub to boot 
into the new root.

Now you can simply copy all the old filesystems like /home etc across. 
Provided they are not mounted, you don't need a rescue disk, you can do 
it with the live system.


Actually, my preferred way, though, would be to (a) fix the efi problem. 
(b) copy all the file systems across. (c) remove the old SSD. (d) with a 
rescue disk handy, just try and boot into the new system, fixing it 
problem by problem. Very similar to my baby steps above, just using a 
live CD to recover the system rather than worrying about having two live 
systems which could interfere with each other without me realising 
what's going on. That's my worry about your approach - if you're not 
clear about EXACTLY what's happening, it's easy to make a mistake, and 
then you're wondering what the hell's going on, because your mental 
model is out of touch with reality. Been there done that! :-)

Cheers,
Wol

