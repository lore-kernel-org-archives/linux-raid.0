Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644EBC6FA82
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 19:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiIJTbW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Sep 2022 15:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIJTbV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Sep 2022 15:31:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E1B33A06
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 12:31:19 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p18so4824614plr.8
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 12:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=YiNFiu3VJ5dVEETKI0D1SeV2wHHo/JFux2U20saISxA=;
        b=ZinWzaclBKhdt9dOkacsBp9pFOUoElLR9OPo4N6YP3NiEowvD4irkYqp3DIUZNVWfd
         UI3AZ0Gyxa0RV/F6A0OcpwQ9rxxmSo3nXyFF1UJ3V+hr90VmQnAZVHlW1c8iPxsilMvV
         Rf+pzuet2HmEfnpZYbNoPjw4Y5j8VNO6pL/ej7Rn2TRncD1H5r46lPCy/SY1dwxBcSGS
         Xiw6gsBVTRBpcKH3jLS6NCZtO0Z4qLwQm9022g9/p0qWQs55m8mQ7eJZRbnr66M7hLHj
         n7qXvsrDgP5HX8t96j31gMpyKnjw+tTda9/z4seZoMesrtVSWABVGK19XBs6RERXrf3a
         8DcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YiNFiu3VJ5dVEETKI0D1SeV2wHHo/JFux2U20saISxA=;
        b=bazkJZXpIwiPnGl6iBZvBZBE4kDzQ9/4Ua/W4Af+mLlNSSRMqTe80tj/Yn9TuihSfY
         hYH0gETBf4B4f1Prvu3QZSmtwJHtl/s0VSqv1NLkQByDmobrfXJM/zzT1Mw478ICnZOh
         i115kC8+w6pM0mQi2bncmQorQRq3Zf5U5EqZUOMHOD9cSslJqrGAyGpB8W+rp/3DvHtV
         5E1WhlRWWmeDwf7TQp3b93IQOxLbPpMVzSdDg9rnL1v6McUl2RmZ/hW2aO3gv23ttYWJ
         dQOQwKu3lveKCsRm9I4r/FLpnul0pbUCmeGDT4/7lVJQrFqPwXoueLTF+vMKexgwlNMW
         wG1Q==
X-Gm-Message-State: ACgBeo0Frh4dkZ7JyrJ46pN8x+ywL4c8RwUp+KAMnH8OxqMkrGN19l+6
        /EE2oUkO38WzPDw7A99AAd+VKfLUvZaVUa/wXP6pwZeGQCs=
X-Google-Smtp-Source: AA6agR6H8HOPLw6LvckxnVuDzc7ujQtrC6asErH7IkYVWrAn1GOIeKYKkrtar5XP5xG62TskfUyqw62kfu0RMr96/UI=
X-Received: by 2002:a17:903:32ce:b0:178:e03:b35b with SMTP id
 i14-20020a17090332ce00b001780e03b35bmr7432059plr.119.1662838278867; Sat, 10
 Sep 2022 12:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org> <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org> <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com> <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org>
In-Reply-To: <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org>
From:   Luigi Fabio <luigi.fabio@gmail.com>
Date:   Sat, 10 Sep 2022 15:30:37 -0400
Message-ID: <CAJJqR23RE3Hfrm-bkiyMm3OjUTCFhXsRvBXr4H8563t1VyY=0g@mail.gmail.com>
Subject: Re: RAID5 failure and consequent ext4 problems
To:     Phil Turmel <philip@turmel.org>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Phil,
thank you BTW for your continued assistance. Here goes:

On Sat, Sep 10, 2022 at 11:18 AM Phil Turmel <philip@turmel.org> wrote:
> Yes.  Same kernels are pretty repeatable for device order on bootup as
> long as all are present.  Anything missing will shift the letter
> assignments.
We need to keep this in mind, though the described boot log scsi
target -> letter assignment seem to indicate that we're clear as
discussed. This is relevant since I have re--created the array.

> Okay, that should have saved you.  Except, I think it still writes all
> the meta-data.  With v1.2, that would sparsely trash up to 1/4 gig at
> tbe beginning of each device.
I dug into the docs and the wiki and ran some experiments on another
machine. Apparently, what 1.2 does with my kernel and my mdadm is use
sectors 9 to 80 of each device. Thus, it borked 72 512-byte sectors ->
36 kB -> 9 ext3 blocks per device, sparsely as you say.
This is 'fine' even with a 128kB chunk, the first one doesn't really
matter because yes, fsck detects that it nuked the block group
descriptors but the superblock before them is fine (indeed, tune2fs
and dumpe2fs work 'as expected') and then goes to a backup and is
happy, even declaring the fs clean.
Therefore out of the 12 'affected' areas, one doesn't matter for
practical purposes and we have to wonder about the others.  Arguably,
one of those should also be managed by parity but I have no idea how
that will work out - it may be very important actually at the time of
any future resync.
Now, these are all in the first block of each device, which would form
the first 1408 kB of the filesystem (128kB chunk, remember the
original creation is *old*), since I believe mdraid preserves
sequence, therefore the chunks are in order.
We know the following from dumpe2fs:
---
Group 0: (Blocks 0-32767) csum 0x45ff [ITABLE_ZEROED]
  Primary superblock at 0, Group descriptors at 1-2096
  Block bitmap at 2260 (+2260), csum 0x824f8d47
  Inode bitmap at 2261 (+2261), csum 0xdadef5ad
  Inode table at 2262-2773 (+2262)
  0 free blocks, 8179 free inodes, 2 directories, 8179 unused inodes
---
So the first 2097 blocks are backed up group descriptors - this is
*way* more than the 1408 kB therefore with restored BGDs (fsck -s
32768, say) we should be... fine?

Now, if OTOH I do an -nf, all sorts of weird stuff happens but I have
to wonder whether that's because the BGDs are not happy. I am tempted
to run an overlay *for the fsck*, what do you think?

> Well, yes.  But doesn't matter for assembly attempts, with always go by
> the meta-data.  Device order only ever matters for --create when recreating.
Sure, but keep in mind, my --create commands nuked the original 0.90
metadata as well, so we need to be sure that the order is correct or
we'll have a real jumble,
Now, the cables have not been moved and the boot logs confirm that the
scsi targets correspond, so we should have the order correct and the
parameters are correct from the previous logs. Therefore, we 'should'
have the same dataspa

> If you consistently used -o or --assume-clean, then everything beyond
> ~3G should be untouched, if you can get the order right.  Have fsck try
> backup superblocks way out.
fsck grabs a backup 'magically' and seems to be happy, unless I -nf it
then ... all sorts of bad stuff happens.

> Please use lsdrv to capture names versus serial numbers.  Re-run it
> before any --create operation to ensure the current names really do
> match the expected serial numbers.  Keep track of ordering information
> by serial number.  Note that lsdrv will reliably line up PHYs on SAS
> controllers, so that can be trusted, too.
Thing is... I can't find lsdrv. As in: there is no lsdrv binary,
apparently, in Debian stable or in Debian testing. Where do I look for
it?

> Superblocks other than 0.9x and 1.0 place a bad block log and a written
> block bitmap between the superblock and the data area.  I'm not sure if
> any of the remain space is wiped.  These would be written regardless of
> -o or --assume-clean.  Those flags "protect" the *data area* of the
> array, not the array's own metadata.
Yes - this is the damage I'm talking about above. From the logs, the
'area' is 4096 sectors of which 4016 remain 'unused'. Therefore 80
sectors, with the first 8 not being touched (and the proof is that the
superblock is 'happy', though interestingly this should not be the
case because the gr0 superblock is offset by 1024 bytes -> the last
1024 bytes of the superblock should be borked too.
From this, my math above.


>  > From, I think, the second --create of /dev/123, before I added the
>  > bitmap=none. This should, however, not have written anything with -o
>  > and --assume-clean, correct?
> False assumption.  As described above.
Two different things: what I meant was that even with that bitmap
message, the only thing that would have been written is the metadata.
linux raid documentation states repeatedly that with -o no resyncing
or parity reconstruction would be performed. Yes, agreed, the 1.2
metadata got written, but it's the only thing that got written from
when the array was stopped by the error, if I am reading the docs
correctly?

> Okay.  To date, you've only done create with -o or --assume-clean?
>
> If so, it is likely your 0.90 superblocks are still present at the ends
> of the disks.
Problem is, if you look at my previous email, as I mentioned above I
have ALSO done --create with --metadata=0.90, which overwrote the
original blocks.
HOWEVER, I do have the logs of the original parameters and I have at
least one drive - the old sdc - which was spit out before this whole
thing, which becomes relevant to confirm that the parameter log is
correct (multiple things seem to coincide, so I think we're OK there).

Given all the above, however, if we get the parameters to match we
should get a filesystem that corresponds to before the event after the
first 1408kB - and those don't matter insofar as we have redundant
backups in ext4 for at least the first 2060 blocks >> 1408 kB.

The thing that I do NOT understand is that if this is the case, fsck
with -s <high> should render a FS without any errors.. therefore why
am I getting inode metadata checksum errors? This is why I had
originarily posted in linux-ext4 ...

Thanks,
L
