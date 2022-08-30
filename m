Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A04C0502E
	for <linux-raid@archiver.kernel.org>; Tue, 30 Aug 2022 13:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiH3N2H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 Aug 2022 09:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiH3N1n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 Aug 2022 09:27:43 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834187D1E1
        for <linux-raid@vger.kernel.org>; Tue, 30 Aug 2022 06:27:37 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id i77so9187465ioa.7
        for <linux-raid@vger.kernel.org>; Tue, 30 Aug 2022 06:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Yp1AjpN4orz+NA5UxmleqLZON8Ypo+bzTK2xZJcWtdg=;
        b=HubUENRSyYgh4glsTq3tEuBgM2KCIOaiUYQuIqI5ACY3aPRLJ9ph2y+HxQQ162pJiS
         r0dFzfIk/+y7X5N6s7b7N6oqAWFWADY/znvwn/WmtRdniDLt+5HmHCKsFG/uSzkbCmtF
         tTZxQf9ZEbRnpJT2SKVW0hbmzOaXFma7EkIaq/jAgM8CF+boqtT6ZnZ+yp6eUooYBgKU
         k8ZUlaBvRNjn8110YV6TNsJ7Rs9jRLFGxxx1b9Wg4OvkV/+pTBJ9bgsEEDhrU3Rkqtl3
         vW/NT6aTcqH5fs+W6re/isUS/wi72QY/Uwq4NWqfymVQX7uKzyARVajOlpemQDWbfkwC
         mh2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Yp1AjpN4orz+NA5UxmleqLZON8Ypo+bzTK2xZJcWtdg=;
        b=ibX7e9hAG7reYOSQ1qxtbm/zuPuL/uXrqWJr3PrhAfTrZKuSYtDvQ+heQU6gcjkA6q
         fBBDWRNS/15HKkn2xkMtLLxXx9Y8ytwlqj2Yv4UABjT0mx2FCdVVqLcZ0nRQwyBQMVze
         tdIy93FrAz8VhGhS3bPso6cI8cNtuVttvZLONzbQ+YfvU+RdximQ54gIgIlNdNlfmOkB
         rFsCGKkFd0vQNlyPB8j0G53h3gesrx/0f3xc2wPEwkITwz336m8BMz2R371GQ+ftzOn+
         5stcQruYnxoBqAT+ZMURUyr/Fp8dwFI0/01oEA6yM2isPwTbEiszwaLciOiYxgJR3IsE
         Y+ew==
X-Gm-Message-State: ACgBeo3xnLWYy/1CARhTvelh2jXvrL8HRzzO9UbMsg3fuh0XEqkZN6vN
        m0yr5XgoRTv/UeJVqiV38AfDgTCxW1b44HjwVET6qDVurA==
X-Google-Smtp-Source: AA6agR4iXM2rYDT39nBJ2FMAhpoEpbPkFat3gaG5Y+29NPudZ4ayKYsFpg2ip6AgfGf0iUbxMVqGhS/xuEDU80kyexk=
X-Received: by 2002:a05:6602:1647:b0:689:d2ad:91c8 with SMTP id
 y7-20020a056602164700b00689d2ad91c8mr10747597iow.157.1661866056033; Tue, 30
 Aug 2022 06:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk> <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
 <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org> <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
 <25355.47062.897268.3355@quad.stoffel.home> <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
 <25355.50871.743993.605394@quad.stoffel.home> <CAKAPSkLQ4K1R_aD1=iURTFQmm_DXDMr=wx+VDET7DOUy+6Zp_Q@mail.gmail.com>
 <25357.13191.843087.630097@quad.stoffel.home> <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
 <CAKAPSkJhf8hWGTQiCne6BnMPYoum4hJT3diz9U1FGAfq=_N-nA@mail.gmail.com>
In-Reply-To: <CAKAPSkJhf8hWGTQiCne6BnMPYoum4hJT3diz9U1FGAfq=_N-nA@mail.gmail.com>
From:   Peter Sanders <plsander@gmail.com>
Date:   Tue, 30 Aug 2022 09:27:25 -0400
Message-ID: <CAKAPSkK1bTf+7GOxmB-odjr2zej6XBCT_VGhfNC1KnSXZHjeRw@mail.gmail.com>
Subject: Re: RAID 6, 6 device array - all devices lost superblock
To:     Eyal Lebedinsky <fedora@eyal.emu.id.au>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Tried with the /dev/mapper/sdx devices.

root@superior:/mnt/backup# mdadm --create /dev/md0 --level=raid6 -n 6
/dev/mapper/sdb  /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde
/dev/mapper/sdf /dev/mapper/sdg
mdadm: partition table exists on /dev/mapper/sdb
mdadm: partition table exists on /dev/mapper/sdc
mdadm: partition table exists on /dev/mapper/sdc but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sdd
mdadm: partition table exists on /dev/mapper/sdd but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sde
mdadm: partition table exists on /dev/mapper/sde but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sdf
mdadm: partition table exists on /dev/mapper/sdf but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/mapper/sdg
mdadm: partition table exists on /dev/mapper/sdg but will be lost or
       meaningless after creating array
Continue creating array? n
mdadm: create aborted.
root@superior:/mnt/backup#

Chickened out and aborted the create.
Are those expected messages for the mess I am in?

And the victory conditions would be a mountable file system that passes a fsck?


On Mon, Aug 29, 2022 at 7:53 PM Peter Sanders <plsander@gmail.com> wrote:
>
> Couple more questions.
>
> Mdadm -create ... Do I use the /dev/sdx or /dev/mapper/sdx name for
> the overlayed device?
>
> And reset the mapping between each create attempt by doing:
> remove the loop-device/overlay association
>    dmsetup remove on all devices
> remove the overlay files
>   rm
> remove the loop back devices
>   losetup -d ...
> rebuild the loop back devices
>   mknod -m 660 ...
> build the overlay files
>   truncate -s 300G overlay-...
> reassociate the loop-devices and the overlays
>   losetup... dmsetup..
>
> and try again.
>
> (Yeah, I recognize that there is code to do this (I think) in the
> article, but my script-fu is not up to fully understanding those
> examples.)
>
> On Mon, Aug 29, 2022 at 6:58 PM Eyal Lebedinsky <fedora@eyal.emu.id.au> wrote:
> >
> >
> > On 30/08/2022 07.45, John Stoffel wrote:
> > >>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
> > >
> > > Peter> Phil,
> > > Peter> fstab from the working config -
> > >
> > > Peter> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> > > Peter> # / was on /dev/sda1 during installation
> > > Peter> UUID=50976432-b750-4809-80ac-3bbdd2773163 /               ext4
> > > Peter> errors=remount-ro 0       1
> > > Peter> # /home was on /dev/sda6 during installation
> > > Peter> UUID=eb93a2c4-0190-41fa-a41d-7a5966c6bc47 /home           ext4
> > > Peter> defaults        0       2
> > > Peter> # /var was on /dev/sda5 during installation
> > > Peter> UUID=d1aa6d1f-3ee9-48a8-9350-b15149f738c4 /var            ext4
> > > Peter> defaults        0       2
> > > Peter> /dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0
> > > Peter> /dev/sr1        /media/cdrom1   udf,iso9660 user,noauto     0       0
> > > Peter> # raid array
> > > Peter> /dev/md0    /mnt/raid6    ext4    defaults    0    2
> > >
> > > Peter> No LVM, one large EXT4 partition
> > >
> > > Peter> I have several large files ( NEF and various mpg files) I can identify
> > > Peter> and have backup copies available.
> > >
> > > Peter> I have the overlays created. 300G for each of the six drives.
> > >
> > > So that's good.  Now you have to try and figure out which order they
> > > were created in.  As the docs show, you setup the overlayfs on top of
> > > each of the six drives.
> > >
> > > Keep track by noting the drive serial numbers, since Linux can move
> > > them around and change drive letters on reboots.
> > >
> > >
> > > Then using the overlays, do an:
> > >
> > >       mdadm --create /dev/md0 --level=raid6 -n 6 /dev/sd[bcdefg]
> > >       fsck -n /dev/md0
> > >
> > > and see what you get.  If it doesn't look like a real filesystem, then
> > > you can break it down, and then modify the order you give the drive
> > > letters, like:
> > >
> > >        /dev/sd[cdefge]
> > >
> > > and rinse and repeat as it goes.  Not fun... but should hopefully fix
> > > things for you.
> > >
> > > John
> >
> > An aside, I would think the way to specify a list in a nominated order is something like
> >
> > $ echo /dev/sd{c,d,a,b}
> > /dev/sdc /dev/sdd /dev/sda /dev/sdb
> >
> > rather than
> >
> > $ echo /dev/sd[cdab]
> > /dev/sda /dev/sdb /dev/sdc /dev/sdd
> >
> > which will be in sorting order, regardless of the order of the letter.
> >
> > --
> > Eyal Lebedinsky (fedora@eyal.emu.id.au)
