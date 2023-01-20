Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66293C004D4
	for <linux-raid@archiver.kernel.org>; Fri, 20 Jan 2023 02:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjATCvL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 21:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjATCvK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 21:51:10 -0500
X-Greylist: delayed 149 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 18:51:08 PST
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15AD12A
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 18:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
        :Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N6fEQ30ll9ZCJDtvXOUcJADFq+0WligXdr3xeVt+ytw=; b=Na60wU8ORzPAn5nMja4la9Hd+5
        Xfa36w9GZEKHHrBi5cB74RHWF43TEZMwNV333BZRs+55sKrqYUfiPqcgy85sybrBL8iPWWh3+Jdl7
        m6BeoK1D71wG6VVJeIqvL6qUssYzKjCfG3ct5yixRBvIiKuwqgROR62tx8BLhCPww+4Fd3gXnVTAW
        Lv15wubQCsJmeYBSJK1fJqro8svyfSPlCRSyh9deFfxgzcKQip4V6YbNY9x/4nnVZ2SVOYE94xEdJ
        BwmSGEOvi+gs43uJYkq+4Vdw64Rsmg+APWxd23cTUcjj+UzzCfhtuIQp29QWSLZPLiyRwOu3sceZQ
        g/CF+hXw==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1pIhUf-0002QH-83; Fri, 20 Jan 2023 02:51:05 +0000
Message-ID: <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
Date:   Thu, 19 Jan 2023 21:51:05 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/15/23 06:31, Pascal Hambourg wrote:
> On 15/01/2023 at 04:12, H wrote:
>> I need to transfer an existing CentOS 7 non-RAID setup using one 
>> single SSD to a mdadm RAID1 using two much larger SSDs. All three 
>> disks exist in the same computer at the same time. Both the existing 
>> SSD and the new ones use LVM and LUKS and the objective is to preserve 
>> the OS, all other installed software and data etc. Thus no new 
>> installation should be needed.
> (...)
>> What I cannot do, however, is to make any modifications to the 
>> existing old SSD since I cannot afford not being able to go back to 
>> the old SSD if necessary.
> 
> Too bad. Without that constraint, I would use pvmove to transparently 
> move LVM data from the old drive to the new ones.
> 
> Create EFI partitions on both new drives. Using RAID1 with metadata 1.0 
> (superblock at the end) with EFI partitions is a hack (corruption may 
> happen if the UEFI firmware or anything outside Linux RAID writes to any 
> of them).
> Create the RAID arrays for LVM and /boot.
> Create and open the new LUKS device in the RAID array with cryptsetup.
> Add the related line it in /etc/crypttab.
> Add the new encrypted device to the existing LVM volume group.
> Move away data from the old encrypted device to the new one with pvmove.
> Remove the old encrypted volume from the volume group with vgreduce.
> Delete the related line from /etc/crypttab.
> Copy data from the old /boot partition to the new /boot RAID array with 
> rsync, cp or so.
> Mount the new /boot RAID array and the EFI partitions on /boot, 
> /boot/efi and /boot/efi2 instead of the old partitions.
> Update /etc/fstab accordingly. Add the "nofail" option to the /boot/efi* 
> lines.
> Update the initramfs if it includes information from crypttab or fstab. 
> Make sure it includes RAID support.
> Run update-grub or grub-mkconfig to update grub.cfg.
> Reinstall GRUB on each EFI partition with grub-install.
> If CentOS system configuration manager or GRUB package supports multiple 
> EFI partitions, you can use that instead of reinstalling GRUB by hand.

FWIW, except for the raid of the EFI partitions, this is what I would 
do.  With the sweet benefit of no downtime.  Even the root fs can be 
moved this way, while running.

{ I have, in fact, done similar upgrades to running systems. }

Phil
