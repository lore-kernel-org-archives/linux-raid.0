Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1285C4363D
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 22:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E76206BE
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 22:56:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UG1Xmu3r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgJFW4W (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 18:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgJFW4W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 18:56:22 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB2BC061755
        for <linux-raid@vger.kernel.org>; Tue,  6 Oct 2020 15:56:21 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b22so69582lfs.13
        for <linux-raid@vger.kernel.org>; Tue, 06 Oct 2020 15:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WvuPJfo8THvT06jiwO8gWEhl7RnaRaTIWtPcPxS6S1Q=;
        b=UG1Xmu3rM6GDtp01bXoc8/S57/sEiQ4uAiHmRLaPh2Um65iNgYTnCyn98aSjvi6LLY
         wmNknkq32hpYy/Xs/X69Q0eogYM9MjIcFHllMj5MtKGHhRK+99mIkY2Ma7p860h0MrHd
         ipka/pTRbZIdtzv6aAe99isiFxGOw2osimCi2TDcjM0UOmfX5rmbSKiPOxCMB+lZPrdI
         nH7rRXQbssBBHK4P5ldlqeu17eIe0x2lgtZiaFG0SGb1QAmg4SRjI9l3HO1SyPDODRhD
         Z+LT8IBRyNPLiibc8zmLTPQ0RC1CPnYaoaCCDjMJvp8lX35P4YdyAR+zH0FmF2OfVMgW
         xA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WvuPJfo8THvT06jiwO8gWEhl7RnaRaTIWtPcPxS6S1Q=;
        b=cwIyTQES7fbmLnU3M0PesO3oOfjIOuWMoRUySa4mV3/u7eGaPpIA5QFODleCrtqWDv
         t6QsYzRC4FCZBTUS86CUeTxP/+GYESAFb+wTjLlLBpVpj77MmGuR8J1y09fyfK1GS4HL
         rfxmuy6XCzdFXafZVMkVj0TUq/NlDB77h0Zg9joubjYk/tFkukaqccyGnjKkNQ56IG4W
         42CnXl/MOa3MEzFt4k2EIIzz3VJhzSZ1XlivY0AuGUd+zqeU0HJwJlWYmjTF7B3MPWct
         nMyB44tSljYHdVLj1Lq8XW5J4xmi/09Lgdoj5meg6fL67SGVyDXSGUA/Bm6SBQgYChvZ
         f7ag==
X-Gm-Message-State: AOAM533TETUhzzAEuUo8dZGyTZtkJt0yCAajO7/4ww5m1zabl13WG+Or
        ROD8e23uycWcYpat9S5qYZSaMbZJWOFFlT+XFLY=
X-Google-Smtp-Source: ABdhPJy5NRZKlc/QdsAUkjMOSaT0/woUkxsZ7nZa64nU/oMljAALMnrIRq82KewFUIoJQhRLLIWElX2f8Xq6VS9s9sM=
X-Received: by 2002:ac2:5e87:: with SMTP id b7mr22929lfq.151.1602024980293;
 Tue, 06 Oct 2020 15:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <202010061607.096G7CgT4052287@epjdn.zq3q.org> <1f21b8cb-a9eb-74e8-24b5-550d016b6473@thelounge.net>
In-Reply-To: <1f21b8cb-a9eb-74e8-24b5-550d016b6473@thelounge.net>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 6 Oct 2020 17:56:09 -0500
Message-ID: <CAAMCDefgEd7dbEKNix41cLDfaXvmWZ3m02P5Y4aeTHm+JQTqyQ@mail.gmail.com>
Subject: Re: pls help/review: fed 32 | LVM over raid1, on SSDs & spinning disks
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     linux-raid@zq3q.org, Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Nothing seems to care about the partition type(LVM or md).  My working
md partitions have the following types:
Microsoft basic data
Linux Raid
Linux Filesystem
All successfully reform into a working raid6 after reboot.


On Tue, Oct 6, 2020 at 12:05 PM Reindl Harald <h.reindl@thelounge.net> wrote:
>
>
>
> Am 06.10.20 um 18:07 schrieb linux-raid@zq3q.org:
> > Is it possible to get the 2MiB "bios boot" partition into raid1?
> > This seems to be the most vulnerable part of my setup.
> should be no problem when you have the same partitioning on all disks,
> "BIOS boot" normally have no writes at boot time
>
> RAID1 is handeled like a single disk at early boot
>
> the only thing you need to do manually is install the bootloaer on all
> disks and don#t forget repeat it after replace one
>
> the only thing i am not sure is the partition type, until now my setups
> are MBR and sda1 is a RAID1 over all 4 disks
>
> [root@srv-rhsoft:~]$ fdisk -l /dev/sda
> Disk /dev/sda: 1.84 TiB, 2000398934016 bytes, 3907029168 sectors
> Disk model: Samsung SSD 860
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Disk identifier: 0x000d9ef2
>
> Device     Boot    Start        End    Sectors  Size Id Type
> /dev/sda1  *        2048    1026047    1024000  500M fd Linux raid
> autodetect
> /dev/sda2        1026048   31746047   30720000 14.7G fd Linux raid
> autodetect
> /dev/sda3       31746048 3906971647 3875225600  1.8T fd Linux raid
> autodetect
>
> [root@srv-rhsoft:~]$ df
> Filesystem     Type  Size  Used Avail Use% Mounted on
> /dev/md1       ext4   29G  7.4G   22G  26% /
> /dev/md2       ext4  3.6T  1.2T  2.5T  33% /mnt/data
> /dev/md0       ext4  485M   49M  432M  11% /boot
