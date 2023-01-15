Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4752CC3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 11:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjAOLkI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 06:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjAOLkG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 06:40:06 -0500
X-Greylist: delayed 469 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 15 Jan 2023 03:40:02 PST
Received: from smtp-delay1.nerim.net (mailhost-d3-m0.internext.fr [78.40.49.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 764BE8A57
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 03:40:02 -0800 (PST)
Received: from mallaury.nerim.net (smtp-100-sunday.noc.nerim.net [178.132.17.100])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id A8004C65E7
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 12:32:12 +0100 (CET)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id B5CBBDB17F;
        Sun, 15 Jan 2023 12:32:03 +0100 (CET)
Message-ID: <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
Date:   Sun, 15 Jan 2023 12:31:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
Content-Language: en-US
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 at 04:12, H wrote:
> I need to transfer an existing CentOS 7 non-RAID setup using one single SSD to a mdadm RAID1 using two much larger SSDs. All three disks exist in the same computer at the same time. Both the existing SSD and the new ones use LVM and LUKS and the objective is to preserve the OS, all other installed software and data etc. Thus no new installation should be needed.
(...)
> What I cannot do, however, is to make any modifications to the existing old SSD since I cannot afford not being able to go back to the old SSD if necessary.

Too bad. Without that constraint, I would use pvmove to transparently 
move LVM data from the old drive to the new ones.

Create EFI partitions on both new drives. Using RAID1 with metadata 1.0 
(superblock at the end) with EFI partitions is a hack (corruption may 
happen if the UEFI firmware or anything outside Linux RAID writes to any 
of them).
Create the RAID arrays for LVM and /boot.
Create and open the new LUKS device in the RAID array with cryptsetup.
Add the related line it in /etc/crypttab.
Add the new encrypted device to the existing LVM volume group.
Move away data from the old encrypted device to the new one with pvmove.
Remove the old encrypted volume from the volume group with vgreduce.
Delete the related line from /etc/crypttab.
Copy data from the old /boot partition to the new /boot RAID array with 
rsync, cp or so.
Mount the new /boot RAID array and the EFI partitions on /boot, 
/boot/efi and /boot/efi2 instead of the old partitions.
Update /etc/fstab accordingly. Add the "nofail" option to the /boot/efi* 
lines.
Update the initramfs if it includes information from crypttab or fstab. 
Make sure it includes RAID support.
Run update-grub or grub-mkconfig to update grub.cfg.
Reinstall GRUB on each EFI partition with grub-install.
If CentOS system configuration manager or GRUB package supports multiple 
EFI partitions, you can use that instead of reinstalling GRUB by hand.
