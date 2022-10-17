Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21182C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 17 Oct 2022 22:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJQWrQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Oct 2022 18:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJQWrO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Oct 2022 18:47:14 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBF07E820
        for <linux-raid@vger.kernel.org>; Mon, 17 Oct 2022 15:47:13 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a6so15798485ljq.5
        for <linux-raid@vger.kernel.org>; Mon, 17 Oct 2022 15:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46SOu3wehoV281SU2rn+A8kZeWjlgK+ht7EYaxw2aVc=;
        b=BE3h2DdApirYkJUkOwnVeczGtRrvfpHkKknF8hxnOdwy+en0xS75c9v1TnxDW9ciIq
         fQhuODqKGes1ZjIU1DZiJ3R965Mx1AWsk1OkY2PqtNd/s75JolDEFnrdwRY2wdtOnYP2
         ibf6cBKwqn/HPpkZzjvUAaumoaOaAUDM9MlfGbXhsWSPTgGF2NNBtKI5bNJLM1chjcSp
         ufKz9PLOLVH7EE1tbE1DE5JXzSyBDp2kh0uQlfpDlDxo/TOWhzsUTjTZIidqEQVyNv7k
         b1xdV57rNKTJMxG8Lcb/e/I/Mjq0ByJnBvGb+4GgB3RjA8+x47qzMvHX0VeJ5/6KfiwE
         zpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46SOu3wehoV281SU2rn+A8kZeWjlgK+ht7EYaxw2aVc=;
        b=yN/QWS7rXLFQxVWNcnGMljhoqjOchLF6Ay97O+RVEPxybmK+ydh84Lg/Un2u3E7YQC
         bhHdPYYNooRImKs4cIryH5WmDAtDr1uM28g6EdqXYSA1eRzzvBq/7x4egUs6ljw0d7z6
         S3pH67bDWoGvY/yXQdkNtEQ87eoawmVGJ86Xf2O5VYbp8crJLEvRU/gaOWpe5HceXC3O
         qhUvemdqIX2fuhQwh2Vjs86/rgDhodFS8qytPPZgOxOk7UeFGIanjrPSyu4CeRI2fO9H
         wKpnlxm+/zfsotZ8BidSK80V7i9Cs6lbVJXobP1F2YmZGUAwS7NbjovIK75C7UqodFm2
         A+Zg==
X-Gm-Message-State: ACrzQf29ggeXioooQjZrEHB8MiCCiBEF/wPERwdPTzgigsnh0dr67IQ7
        YgH3zK7Ym3jH5LucFUI+IotmD/VUOJD+znI77MpYgGenDRo=
X-Google-Smtp-Source: AMsMyM4A1qQ10dVM5LtKqLFPdBhdLaumXhQ8S4/5CzNDfGDcKng2kUkC0tgIG36+fq//L+HHel5/Smxeo8VA+gXob7c=
X-Received: by 2002:a2e:a7c1:0:b0:26f:c204:eecb with SMTP id
 x1-20020a2ea7c1000000b0026fc204eecbmr20104ljp.344.1666046831502; Mon, 17 Oct
 2022 15:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <CACZftsg4Cg5UM8derE46m2JgHWFAoNYFvDXbFKfoU4Jrbmhx_g@mail.gmail.com>
 <499878ba-c52a-0041-e4b1-697bce7c9fba@youngman.org.uk>
In-Reply-To: <499878ba-c52a-0041-e4b1-697bce7c9fba@youngman.org.uk>
From:   Steve Kolk <stevekolk@gmail.com>
Date:   Mon, 17 Oct 2022 18:46:56 -0400
Message-ID: <CACZftsgxix6fQQE8dS0nnYvxPOgv10PQE8wt6z=WBeytcOaAdw@mail.gmail.com>
Subject: Re: Rebuilding mdadm RAID array after OS drive failure
To:     anthony <antmbox@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Oct 16, 2022 at 6:22 PM anthony <antmbox@youngman.org.uk> wrote:
>
> On 16/10/2022 22:38, Steve Kolk wrote:
> > I have a system that was running Ubuntu 18.04 server with a 5 drive
> > RAID 6 array using mdadm. I had a hard drive failure, but instead of
> > the array it was the OS hard drive that completely failed. I also do
> > not have access to the original mdadm.conf file.
> >
> > In an attempt to get my array back up, I booted Ubuntu 22.04 from a
> > USB and tried to assemble and mount the array.  It did not work.
> > Trying some diagnostic steps I found online, it seems to be claiming
> > that there is no md superblock on any of the drives.
>
>  From this site? https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> Try https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrog=
n

I set up 3 of the drives with overlays and tried forcing the assembly,
but I still get the same error. I haven't tried the steps under
"Irreversible mdadm failure recovery", is there where I need to go
next?

ubuntu@ubuntu:~$ echo $OVERLAYS
/dev/mapper/sda1 /dev/mapper/sdb1 /dev/mapper/sdc1
ubuntu@ubuntu:~$ sudo mdadm --assemble --force /dev/md1 $OVERLAYS
mdadm: no recogniseable superblock on /dev/mapper/sda1
mdadm: /dev/mapper/sda1 has no superblock - assembly aborted

> >
> > I've included the commands I ran and their output below. Does anyone
> > have any advice on what next steps I can take? I have no reason to
> > think these drives have failed mechanically (much less all of them). I
> > also tried with Ubuntu 18.04 and got the same results.
> >
> If you've got python 2.7, can you run lsdrv? Hopefully that will give us
> some more clues.

ubuntu@ubuntu:~$ ./dev/lsdrv/lsdrv
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 6 Series/C200
Series Chipset Family Desktop SATA Controller (IDE mode, ports 0-3)
(rev 05)
=E2=94=9Cscsi 0:0:0:0 ATA      WDC WD100EFAX-68
=E2=94=82=E2=94=94sda 9.10t [8:0] Empty/Unknown
=E2=94=82 =E2=94=9Csda1 9.10t [8:1] Empty/Unknown
=E2=94=82 =E2=94=82=E2=94=94dm-2 9.10t [253:2] Empty/Unknown
=E2=94=82 =E2=94=94sda9 8.00m [8:9] Empty/Unknown
=E2=94=9Cscsi 0:0:1:0 ATA      WDC WD100EFAX-68
=E2=94=82=E2=94=94sdb 9.10t [8:16] Empty/Unknown
=E2=94=82 =E2=94=9Csdb1 9.10t [8:17] Empty/Unknown
=E2=94=82 =E2=94=82=E2=94=94dm-0 9.10t [253:0] Empty/Unknown
=E2=94=82 =E2=94=94sdb9 8.00m [8:25] Empty/Unknown
=E2=94=9Cscsi 1:0:0:0 ATA      WDC WD100EFAX-68
=E2=94=82=E2=94=94sdc 9.10t [8:32] Empty/Unknown
=E2=94=82 =E2=94=9Csdc1 9.10t [8:33] Empty/Unknown
=E2=94=82 =E2=94=82=E2=94=94dm-1 9.10t [253:1] Empty/Unknown
=E2=94=82 =E2=94=94sdc9 8.00m [8:41] Empty/Unknown
=E2=94=94scsi 1:0:1:0 ATA      WDC WD100EFAX-68
 =E2=94=94sdd 9.10t [8:48] Empty/Unknown
  =E2=94=9Csdd1 9.10t [8:49] Empty/Unknown
  =E2=94=94sdd9 8.00m [8:57] Empty/Unknown
PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 6 Series/C200
Series Chipset Family Desktop SATA Controller (IDE mode, ports 4-5)
(rev 05)
=E2=94=94scsi 2:0:0:0 ATA      WDC WD100EFAX-68
 =E2=94=94sde 9.10t [8:64] Empty/Unknown
  =E2=94=9Csde1 9.10t [8:65] Empty/Unknown
  =E2=94=94sde9 8.00m [8:73] Empty/Unknown
PCI [pata_via] 03:00.0 IDE interface: VIA Technologies, Inc. VT6415
PATA IDE Host Controller
=E2=94=94scsi 4:x:x:x [Empty]
USB [usb-storage] Bus 002 Device 003: ID 0930:6545 Toshiba Corp.
Kingston DataTraveler 102/2.0 / HEMA Flash Drive 2 GB / PNY Attache
4GB Stick {000AEBFFB4C15B8A130501A6}
=E2=94=94scsi 6:0:0:0 Kingston DataTraveler 2.0
 =E2=94=94sdf 7.57g [8:80] Empty/Unknown
  =E2=94=94sdf1 7.57g [8:81] Empty/Unknown
   =E2=94=94Mounted as /dev/sdf1 @ /cdrom
Other Block Devices
=E2=94=9Cloop0 2.13g [7:0] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop0 @ /rofs
=E2=94=9Cloop1 61.96m [7:1] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop1 @ /snap/core20/1587
=E2=94=9Cloop2 4.00k [7:2] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop2 @ /snap/bare/5
=E2=94=9Cloop3 163.29m [7:3] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop3 @ /snap/firefox/1635
=E2=94=9Cloop4 91.69m [7:4] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop4 @ /snap/gtk-common-themes/1535
=E2=94=9Cloop5 400.80m [7:5] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop5 @ /snap/gnome-3-38-2004/112
=E2=94=9Cloop6 46.96m [7:6] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop6 @ /snap/snapd/16292
=E2=94=9Cloop7 284.00k [7:7] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop7 @ /snap/snapd-desktop-integration/1=
4
=E2=94=9Cloop8 45.86m [7:8] Empty/Unknown
=E2=94=82=E2=94=94Mounted as /dev/loop8 @ /snap/snap-store/582
=E2=94=9Cloop9 9.09t [7:9] Empty/Unknown
=E2=94=82=E2=94=94dm-2 9.10t [253:2] Empty/Unknown
=E2=94=9Cloop10 9.09t [7:10] Empty/Unknown
=E2=94=82=E2=94=94dm-0 9.10t [253:0] Empty/Unknown
=E2=94=9Cloop11 9.09t [7:11] Empty/Unknown
=E2=94=82=E2=94=94dm-1 9.10t [253:1] Empty/Unknown
=E2=94=9Cloop12 0.00k [7:12] Empty/Unknown
=E2=94=94loop13 0.00k [7:13] Empty/Unknown

> Provided the data itself isn't damaged, you should be able to retrieve
> your array. Read up the section on overlays, that will protect your data
> from being overwritten while you play around trying to recover it.
>
> The other thing I would do here, is five drives is a lot to try and get
> right. I'd pick just three drives, and try to get them to assemble
> correctly (using overlays for safety!). Once you've got three drives to
> give you a functional array, you can then try and get the other two
> correct before the final recovery.
>
> What can you remember about the system? What version of superblock? And
> something I've noticed that seems weird, why do your drives have
> partitions 1 & 9, but not 2-8? That is well odd ... Have you rebuilt the
> array in any way, or is it exactly as originally created? Etc etc the
> more information you can give us the better.

I do not know the version of superblock, after the disks were
partitioned I just used "sudo mdadm --create ..." and everything went
smoothly. I didn't use any special configuration as far as I know, so
I'm not sure why the partitioning is odd. I have not rebuilt the
array, it still has the same disks as when it was created and it has
not suffered any failures.

>
> Let us know how you get on with this, and then we'll come back with more.
>
> Cheers,
> Wol

Steve
