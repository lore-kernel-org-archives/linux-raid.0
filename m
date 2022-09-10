Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4305C6FA83
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 20:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIJUNZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Sep 2022 16:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIJUNZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Sep 2022 16:13:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A43340BF7
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:13:22 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 202so4625279pgc.8
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=0lGmhhpcggq6u/FSCq6UuXyren+NB77QmFIJM6hHnX4=;
        b=aXvMk4cnKV26GjkQDbH7e5z/DPholkeBFES80Q0vJKJakbIYzSghuSfLmbfLSIEnQ+
         2WRh3qUgwiNF+pBuh6XFpYai4f6OUJ4hw8GpUH3TW474SPhVvTrD2uKTXOL5NXF/cNdl
         e9cYFwy1lpIj4ivF1pMiXej/ZTTxhTnbz2xLpsLI3Ia/eFlB9f62AYmZkcezTEKNkF1H
         JPlwRVN2tzEPrAJoWplXipOpiS67u4QI5U0I6ou9no2VGdcQIqNeXpN8IVyo8h8iIZSq
         LRd//QRv8qx1OfLkQzwGWMMeXsKQZ5gZCz/i9PTZ4YseOG4IQA4U1Rqc6T9tNNPYXREC
         LpUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=0lGmhhpcggq6u/FSCq6UuXyren+NB77QmFIJM6hHnX4=;
        b=YSIKv3uODd902QPsTles0zGlEwTphw3hXlLXtAJapQdKUQcBkzzMy3JvrS440zICaj
         4W3aj/RWBK2RjteO3xbNugYTfzloZYzhv2Ah8t1Wlif5i7nG0ELbQBpR00VLn9RO9Q87
         20zt+uYKjQzRMBSeUThBUjkcOWtAKmwcCXm4AV9SMTSrOnIgnsSaFWHPMiTnRcWB5cwY
         O3aNW54mzsQDkjnnpHQtiWzb5KruiAe+XNP3d3f7ZF+Vw5gSB0H5g/hOpBRxjlmU/ZfH
         HYFUFdSZ+LVreNUM5LimKZNImxHo5fuvAY4hhczFsDVSuJjMEE4yOQQLtrTnEuNOT2Bh
         VTIA==
X-Gm-Message-State: ACgBeo3E9MNYzNn4fzkPQI5iUqYpKLDOoMGor3QkaQrFvkjR0LB7ZkHh
        XV2XwRqdS0kOWb0LtgrrZ7DJY2GRO41liV1Q6iii3obcs9E=
X-Google-Smtp-Source: AA6agR4GYzGVu7gW1uo4tDqUkeiMHPqf/OGcoPhbynvkOJ/9FTQloExxQlEgE8JflgpavtRKSy9FqqP0B4tM5zCepVk=
X-Received: by 2002:a05:6a00:24ca:b0:541:1b89:a4a7 with SMTP id
 d10-20020a056a0024ca00b005411b89a4a7mr5158405pfv.36.1662840801186; Sat, 10
 Sep 2022 13:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org> <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org> <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org> <CAJJqR23RE3Hfrm-bkiyMm3OjUTCFhXsRvBXr4H8563t1VyY=0g@mail.gmail.com>
 <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
In-Reply-To: <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
From:   Luigi Fabio <luigi.fabio@gmail.com>
Date:   Sat, 10 Sep 2022 16:12:40 -0400
Message-ID: <CAJJqR20PcvMs5e3cKXf8DtLF_nVthii4rbkFLPYZ4QT7mpj0Kg@mail.gmail.com>
Subject: Re: RAID5 failure and consequent ext4 problems
To:     Phil Turmel <philip@turmel.org>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Following up, I found:

>> The backup ext4 superblocks are never updated by the kernel, only after
>> a successful e2fsck, tune2fs, resize2fs, or other userspace operation.
>>
>> This avoids clobbering the backups with bad data if the kernel has a bug
>> or device error (e.g. bad cable, HBA, etc).
So therefore, if we restore a backup superblock (and its attendant
data) what happens to any FS structure that was written to *after*
that time? That is to say, in this case, after Aug 18th?
Is the system 'smart enough' to do something or will I have a big fat
mess? I mean, reversion to 08/18 would be great, but I can't imagine
that the FS can do that, it would have to have copies of every inode.

This does explain how I get so many errors when fsck grabs the backup
superblock... the RAID part we solved just fine, it's the rest we have
to deal with.

Ideas are welcome.

On Sat, Sep 10, 2022 at 3:55 PM Luigi Fabio <luigi.fabio@gmail.com> wrote:
>
> Well, I found SOMETHING of decided interest: when I run dumpe2fs with
> any backup superblock, this happens:
>
> ---
> Filesystem created:       Tue Nov  4 08:56:08 2008
> Last mount time:          Thu Aug 18 21:04:22 2022
> Last write time:          Thu Aug 18 21:04:22 2022
> ---
>
> So the backups have not been updated since boot-before-last? That
> would explain why, when fsck tries to use those backups, it comes up
> with funny results.
>
> Is this ...as intended, I wonder? Does it also imply that any file
> that was written to > aug 18th will be in an indeterminate state? That
> would seem to be the implication.
>
> On Sat, Sep 10, 2022 at 3:30 PM Luigi Fabio <luigi.fabio@gmail.com> wrote:
> >
> > Hello Phil,
> > thank you BTW for your continued assistance. Here goes:
> >
> > On Sat, Sep 10, 2022 at 11:18 AM Phil Turmel <philip@turmel.org> wrote:
> > > Yes.  Same kernels are pretty repeatable for device order on bootup as
> > > long as all are present.  Anything missing will shift the letter
> > > assignments.
> > We need to keep this in mind, though the described boot log scsi
> > target -> letter assignment seem to indicate that we're clear as
> > discussed. This is relevant since I have re--created the array.
> >
> > > Okay, that should have saved you.  Except, I think it still writes all
> > > the meta-data.  With v1.2, that would sparsely trash up to 1/4 gig at
> > > tbe beginning of each device.
> > I dug into the docs and the wiki and ran some experiments on another
> > machine. Apparently, what 1.2 does with my kernel and my mdadm is use
> > sectors 9 to 80 of each device. Thus, it borked 72 512-byte sectors ->
> > 36 kB -> 9 ext3 blocks per device, sparsely as you say.
> > This is 'fine' even with a 128kB chunk, the first one doesn't really
> > matter because yes, fsck detects that it nuked the block group
> > descriptors but the superblock before them is fine (indeed, tune2fs
> > and dumpe2fs work 'as expected') and then goes to a backup and is
> > happy, even declaring the fs clean.
> > Therefore out of the 12 'affected' areas, one doesn't matter for
> > practical purposes and we have to wonder about the others.  Arguably,
> > one of those should also be managed by parity but I have no idea how
> > that will work out - it may be very important actually at the time of
> > any future resync.
> > Now, these are all in the first block of each device, which would form
> > the first 1408 kB of the filesystem (128kB chunk, remember the
> > original creation is *old*), since I believe mdraid preserves
> > sequence, therefore the chunks are in order.
> > We know the following from dumpe2fs:
> > ---
> > Group 0: (Blocks 0-32767) csum 0x45ff [ITABLE_ZEROED]
> >   Primary superblock at 0, Group descriptors at 1-2096
> >   Block bitmap at 2260 (+2260), csum 0x824f8d47
> >   Inode bitmap at 2261 (+2261), csum 0xdadef5ad
> >   Inode table at 2262-2773 (+2262)
> >   0 free blocks, 8179 free inodes, 2 directories, 8179 unused inodes
> > ---
> > So the first 2097 blocks are backed up group descriptors - this is
> > *way* more than the 1408 kB therefore with restored BGDs (fsck -s
> > 32768, say) we should be... fine?
> >
> > Now, if OTOH I do an -nf, all sorts of weird stuff happens but I have
> > to wonder whether that's because the BGDs are not happy. I am tempted
> > to run an overlay *for the fsck*, what do you think?
> >
> > > Well, yes.  But doesn't matter for assembly attempts, with always go by
> > > the meta-data.  Device order only ever matters for --create when recreating.
> > Sure, but keep in mind, my --create commands nuked the original 0.90
> > metadata as well, so we need to be sure that the order is correct or
> > we'll have a real jumble,
> > Now, the cables have not been moved and the boot logs confirm that the
> > scsi targets correspond, so we should have the order correct and the
> > parameters are correct from the previous logs. Therefore, we 'should'
> > have the same dataspa
> >
> > > If you consistently used -o or --assume-clean, then everything beyond
> > > ~3G should be untouched, if you can get the order right.  Have fsck try
> > > backup superblocks way out.
> > fsck grabs a backup 'magically' and seems to be happy, unless I -nf it
> > then ... all sorts of bad stuff happens.
> >
> > > Please use lsdrv to capture names versus serial numbers.  Re-run it
> > > before any --create operation to ensure the current names really do
> > > match the expected serial numbers.  Keep track of ordering information
> > > by serial number.  Note that lsdrv will reliably line up PHYs on SAS
> > > controllers, so that can be trusted, too.
> > Thing is... I can't find lsdrv. As in: there is no lsdrv binary,
> > apparently, in Debian stable or in Debian testing. Where do I look for
> > it?
> >
> > > Superblocks other than 0.9x and 1.0 place a bad block log and a written
> > > block bitmap between the superblock and the data area.  I'm not sure if
> > > any of the remain space is wiped.  These would be written regardless of
> > > -o or --assume-clean.  Those flags "protect" the *data area* of the
> > > array, not the array's own metadata.
> > Yes - this is the damage I'm talking about above. From the logs, the
> > 'area' is 4096 sectors of which 4016 remain 'unused'. Therefore 80
> > sectors, with the first 8 not being touched (and the proof is that the
> > superblock is 'happy', though interestingly this should not be the
> > case because the gr0 superblock is offset by 1024 bytes -> the last
> > 1024 bytes of the superblock should be borked too.
> > From this, my math above.
> >
> >
> > >  > From, I think, the second --create of /dev/123, before I added the
> > >  > bitmap=none. This should, however, not have written anything with -o
> > >  > and --assume-clean, correct?
> > > False assumption.  As described above.
> > Two different things: what I meant was that even with that bitmap
> > message, the only thing that would have been written is the metadata.
> > linux raid documentation states repeatedly that with -o no resyncing
> > or parity reconstruction would be performed. Yes, agreed, the 1.2
> > metadata got written, but it's the only thing that got written from
> > when the array was stopped by the error, if I am reading the docs
> > correctly?
> >
> > > Okay.  To date, you've only done create with -o or --assume-clean?
> > >
> > > If so, it is likely your 0.90 superblocks are still present at the ends
> > > of the disks.
> > Problem is, if you look at my previous email, as I mentioned above I
> > have ALSO done --create with --metadata=0.90, which overwrote the
> > original blocks.
> > HOWEVER, I do have the logs of the original parameters and I have at
> > least one drive - the old sdc - which was spit out before this whole
> > thing, which becomes relevant to confirm that the parameter log is
> > correct (multiple things seem to coincide, so I think we're OK there).
> >
> > Given all the above, however, if we get the parameters to match we
> > should get a filesystem that corresponds to before the event after the
> > first 1408kB - and those don't matter insofar as we have redundant
> > backups in ext4 for at least the first 2060 blocks >> 1408 kB.
> >
> > The thing that I do NOT understand is that if this is the case, fsck
> > with -s <high> should render a FS without any errors.. therefore why
> > am I getting inode metadata checksum errors? This is why I had
> > originarily posted in linux-ext4 ...
> >
> > Thanks,
> > L
