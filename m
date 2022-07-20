Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31194C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 19:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiGTTut (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 15:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiGTTus (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 15:50:48 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFACDDA3
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 12:50:47 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id m10so10376920qvu.4
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 12:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vtqmJAjfsLlcRgTgK9CFqWW19fnaxlJLkMWbzKiJfRw=;
        b=SJZEHKkDqec+IwCmAKtIltzFdsAGQuXFCRjSZJHpjlsPaUaKTr1SWo8yeW9KwYoTV3
         TD3NDHjxfCLf2L6HjXo0N9+Knrr+mAV3d6jA/RzxTSFqFeV7gLOORaahdUfQYNprQmZm
         zxcJwITZ9pIWNGM5N2qbEV97qItQeOTg5pO/VHQ60bFv3A+avzmPNApGpLkkxP/o4Yr3
         DgfusfXb7X4xv/IRfr1T1q1ShEqDB56jXgTd9uXHozVLuDfYJvcCFZ3KaZo6rdBctJwg
         YrARzPHgSWIwSQkF7xhxgWxvkxtXqxMJII0l56E/jmoF1TnwyAMRJt/NNtd7bjke9/ro
         6GLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vtqmJAjfsLlcRgTgK9CFqWW19fnaxlJLkMWbzKiJfRw=;
        b=ouREGMt81BdsBU3awleezxT2HO4boRajkHsK0tE5JbK3uwAmWMrxAbXxVvWEeiTCux
         IBeoq9TxhtXB+dU80UWPRcL0r9857u9uwXwB8McoVGycLWL+fEsGyG/NGcLyojYSjkWt
         NyIrSCCQ3pyMNnhSyIMEMRzSzvQJjYiZBG6DFyv66DNgO2su3K3SwpLAm4innteXqvMu
         QUMiGjCo1Dc1ak2x9Nuh/mTgNWsHTlBwomwFUHWdOWXNrPjOAiMRYzfEoCGJxzDq0l/U
         s1/0V8H+UTJz4RcGQwo8Uw2QOpFWP6bHQDh/SwLMPHn9kTwff1J9AputdSVCnYBNYH9u
         dfsQ==
X-Gm-Message-State: AJIora/N2DF/+wWDvjD1wcM0oTRMhaNQS5GdM1WkNDRfbHnXzia13jZV
        reJ1OLWsMz75YY7qXBAXB/JJzZgie3lxCNFS6d0wdZtuf90=
X-Google-Smtp-Source: AGRyM1urGchBmCKlBDIcYnfo7ycZtlpmzNTklZiraYIWhGuVCgZzcEqNAw4wnKAPaMRPTfHCVAgpZ81RPebzlMBLgFk=
X-Received: by 2002:a05:6214:240e:b0:473:fdb6:7507 with SMTP id
 fv14-20020a056214240e00b00473fdb67507mr7171225qvb.3.1658346647049; Wed, 20
 Jul 2022 12:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <87o7xmsjcv.fsf@esperi.org.uk> <fed30ed9-68e3-ce8b-ec27-45c48cf6a7a1@linux.dev>
 <8735evpwrf.fsf@esperi.org.uk>
In-Reply-To: <8735evpwrf.fsf@esperi.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 20 Jul 2022 14:50:36 -0500
Message-ID: <CAAMCDeenbs5R6e_kuQR_zsv50eh49O2w4h-+BAg1xU9y0_BZ1Q@mail.gmail.com>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
To:     Nix <nix@esperi.org.uk>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

try a fdisk -l /dev/sda4   (to see if there is a partition on the
partition).   That breaking stuff comes and goes.

So long as it does not show starts and stops you are ok.

It will look like this, if you are doing all of the work on your disk
then the mistake was probably not made.

In the below you could have an LVM device on sdfe1 (2nd block, or a
md-raid device) that the existence of the partition table hides.

And if the sdfe1p1 is found and configured then it blocks/hides
anything on sdfe1, and that depends on kernel scanning for partitions
and userspace tools scanning for partitions

fdisk -l /dev/sdfe

Disk /dev/sdfe: 128.8 GB, 128849018880 bytes, 251658240 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 16384 bytes / 16777216 bytes
Disk label type: dos
Disk identifier: 0xxxxxx

    Device Boot      Start         End      Blocks   Id  System
/dev/sdfe1           32768   251658239   125812736   83  Linux

08:34 PM # fdisk -l /dev/sdfe1

Disk /dev/sdfe1: 128.8 GB, 128832241664 bytes, 251625472 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 16384 bytes / 16777216 bytes
Disk label type: dos
Disk identifier: 0xxxxxxx

      Device Boot      Start         End      Blocks   Id  System
/dev/sdfe1p1           32768   251625471   125796352   8e  Linux LVM

My other though was that maybe some change caused the partition type
to start get used for something and if the type was wrong then ignore
it.

you might try a file -s /dev/sde1 against each partition that should
have mdadm and make sure it says mdadm and that there is not some
other header confusing the issue.

I tried on some of mine and some of my working mdadm's devices report
weird things.

On Wed, Jul 20, 2022 at 12:31 PM Nix <nix@esperi.org.uk> wrote:
>
> On 19 Jul 2022, Guoqing Jiang spake thusly:
>
> > On 7/18/22 8:20 PM, Nix wrote:
> >> So I have a pair of RAID-6 mdraid arrays on this machine (one of which
> >> has a bcache layered on top of it, with an LVM VG stretched across
> >> both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
> >> rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
> >> anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
> >> simply didn't find anything to assemble, and after that nothing else was
> >> going to work. But rebooting into 5.16 worked fine, so everything was
> >> (thank goodness) actually still there.
> >>
> >> Alas I can't say what the state of the blockdevs was (other than that
> >> they all seemed to be in /dev, and I'm using DEVICE partitions so they
> >> should all have been spotte
> >
> > I suppose the array was built on top of partitions, then my wild guess is
> > the problem is caused by the change in block layer (1ebe2e5f9d68?),
> > maybe we need something similar in loop driver per b9684a71.
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index c7ecb0bffda0..e5f2e55cb86a 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5700,6 +5700,7 @@ static int md_alloc(dev_t dev, char *name)
> >         mddev->queue = disk->queue;
> >         blk_set_stacking_limits(&mddev->queue->limits);
> >         blk_queue_write_cache(mddev->queue, true, true);
> > +       set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
> >         disk->events |= DISK_EVENT_MEDIA_CHANGE;
> >         mddev->gendisk = disk;
> >         error = add_disk(disk);
>
> I'll give it a try. But... the arrays, fully assembled:
>
> Personalities : [raid0] [raid6] [raid5] [raid4]
> md125 : active raid6 sda3[0] sdf3[5] sdd3[4] sdc3[2] sdb3[1]
>       15391689216 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
>
> md126 : active raid6 sda4[0] sdf4[5] sdd4[4] sdc4[2] sdb4[1]
>       7260020736 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
>       bitmap: 0/2 pages [0KB], 1048576KB chunk
>
> md127 : active raid0 sda2[0] sdf2[5] sdd2[3] sdc2[2] sdb2[1]
>       1310064640 blocks super 1.2 512k chunks
>
> unused devices: <none>
>
> so they are on top of partitions. I'm not sure suppressing a partition
> scan will help... but maybe I misunderstand.
>
> --
> NULL && (void)
