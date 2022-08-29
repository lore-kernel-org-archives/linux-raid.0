Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2169EECAAD4
	for <linux-raid@archiver.kernel.org>; Mon, 29 Aug 2022 23:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiH2XyB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 Aug 2022 19:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiH2Xx5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 Aug 2022 19:53:57 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EAE247
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 16:53:55 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c4so7969196iof.3
        for <linux-raid@vger.kernel.org>; Mon, 29 Aug 2022 16:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=WsUBzn61bWOWrxPqWei61xkXq2buctF6YYTDyL61LDQ=;
        b=cTbkQud5GBOdoLerrcjlQlj3xrRd90gOBT+QHihX1QeANL4CB8tmmi1ZSxAIY24yoe
         pIdGoR0DMMoBZz08AEChlMWXyEzhtYuKS+umclSw0zwyRuNMwHv6bW7coaG74+8d7LZ8
         8W+9ryn6o6QpZzE+ChNpiYqy8wFGIqLwelGIAaVhd+y0kvMc3gnSZ1zQyG0kkW4CoVyZ
         a7HZGoyoFKzV0puFeHwOuioco7lfFJ7oNH6VlsM5FBIAEExf6nys85KFzQh96L3kAGOf
         sfh1sfO5sdqZUaiIhZF4u93gr7nv4/UU8ZVQcR/WqvkQWNYHaip7PuhmkdscuqUzaN1F
         3lIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=WsUBzn61bWOWrxPqWei61xkXq2buctF6YYTDyL61LDQ=;
        b=Ks2pKLWVKBDgSltxc+q5JyLu3iWCvdIqUtwbbDU7+vcvD23b3oEn+GSC22f4SzBwdF
         qZJoeLca9zvV198EFqhYoPYnoGjD69tBE8WLUn/LYHV9qA9jycMKMrMrkOYH2anUmb8I
         V/GaGT2wdyLKws7dwc+Gwia6v3nJ6vQbJPiJDz2/SgmRmQkEM0awA5HyYj+zo3kcOfyK
         ScILkyrgyRKR3pnEiMlyy4hJvfDGgE9/viNBkOXivtjCQsmtqwR+88fYpSjuMN7lTgGL
         yx1wWbJ5GN9FoNqRMkzBvIoOlskjDaFYCDojADvo3nPxeQ4lHl9OWkcNb1N+H1x9yrxN
         jCTA==
X-Gm-Message-State: ACgBeo3MqIKNh/cF0x/uh7TvvUHFX1M8CuJ7fr9HhIP3QnVF/hgATBEv
        RzmNUC5TjzS5KPIWwDYNA+8C6Fq1MgUNhwuRgX0TWSf+NQ==
X-Google-Smtp-Source: AA6agR6KghRHmEJvnEFlK3eiYPmhr2cuVUeC+PNL2bKS5howDc0UxT25Yugk7MFR1xx1w+TbyYQ6cEpeqmWm6roFc8M=
X-Received: by 2002:a05:6602:2c4c:b0:689:94f:cbe with SMTP id
 x12-20020a0566022c4c00b00689094f0cbemr9817632iov.139.1661817235259; Mon, 29
 Aug 2022 16:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk> <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
 <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org> <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
 <25355.47062.897268.3355@quad.stoffel.home> <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
 <25355.50871.743993.605394@quad.stoffel.home> <CAKAPSkLQ4K1R_aD1=iURTFQmm_DXDMr=wx+VDET7DOUy+6Zp_Q@mail.gmail.com>
 <25357.13191.843087.630097@quad.stoffel.home> <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
In-Reply-To: <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
From:   Peter Sanders <plsander@gmail.com>
Date:   Mon, 29 Aug 2022 19:53:44 -0400
Message-ID: <CAKAPSkJhf8hWGTQiCne6BnMPYoum4hJT3diz9U1FGAfq=_N-nA@mail.gmail.com>
Subject: Re: RAID 6, 6 device array - all devices lost superblock
To:     Eyal Lebedinsky <fedora@eyal.emu.id.au>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Couple more questions.

Mdadm -create ... Do I use the /dev/sdx or /dev/mapper/sdx name for
the overlayed device?

And reset the mapping between each create attempt by doing:
remove the loop-device/overlay association
   dmsetup remove on all devices
remove the overlay files
  rm
remove the loop back devices
  losetup -d ...
rebuild the loop back devices
  mknod -m 660 ...
build the overlay files
  truncate -s 300G overlay-...
reassociate the loop-devices and the overlays
  losetup... dmsetup..

and try again.

(Yeah, I recognize that there is code to do this (I think) in the
article, but my script-fu is not up to fully understanding those
examples.)

On Mon, Aug 29, 2022 at 6:58 PM Eyal Lebedinsky <fedora@eyal.emu.id.au> wrote:
>
>
> On 30/08/2022 07.45, John Stoffel wrote:
> >>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
> >
> > Peter> Phil,
> > Peter> fstab from the working config -
> >
> > Peter> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> > Peter> # / was on /dev/sda1 during installation
> > Peter> UUID=50976432-b750-4809-80ac-3bbdd2773163 /               ext4
> > Peter> errors=remount-ro 0       1
> > Peter> # /home was on /dev/sda6 during installation
> > Peter> UUID=eb93a2c4-0190-41fa-a41d-7a5966c6bc47 /home           ext4
> > Peter> defaults        0       2
> > Peter> # /var was on /dev/sda5 during installation
> > Peter> UUID=d1aa6d1f-3ee9-48a8-9350-b15149f738c4 /var            ext4
> > Peter> defaults        0       2
> > Peter> /dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0
> > Peter> /dev/sr1        /media/cdrom1   udf,iso9660 user,noauto     0       0
> > Peter> # raid array
> > Peter> /dev/md0    /mnt/raid6    ext4    defaults    0    2
> >
> > Peter> No LVM, one large EXT4 partition
> >
> > Peter> I have several large files ( NEF and various mpg files) I can identify
> > Peter> and have backup copies available.
> >
> > Peter> I have the overlays created. 300G for each of the six drives.
> >
> > So that's good.  Now you have to try and figure out which order they
> > were created in.  As the docs show, you setup the overlayfs on top of
> > each of the six drives.
> >
> > Keep track by noting the drive serial numbers, since Linux can move
> > them around and change drive letters on reboots.
> >
> >
> > Then using the overlays, do an:
> >
> >       mdadm --create /dev/md0 --level=raid6 -n 6 /dev/sd[bcdefg]
> >       fsck -n /dev/md0
> >
> > and see what you get.  If it doesn't look like a real filesystem, then
> > you can break it down, and then modify the order you give the drive
> > letters, like:
> >
> >        /dev/sd[cdefge]
> >
> > and rinse and repeat as it goes.  Not fun... but should hopefully fix
> > things for you.
> >
> > John
>
> An aside, I would think the way to specify a list in a nominated order is something like
>
> $ echo /dev/sd{c,d,a,b}
> /dev/sdc /dev/sdd /dev/sda /dev/sdb
>
> rather than
>
> $ echo /dev/sd[cdab]
> /dev/sda /dev/sdb /dev/sdc /dev/sdd
>
> which will be in sorting order, regardless of the order of the letter.
>
> --
> Eyal Lebedinsky (fedora@eyal.emu.id.au)
