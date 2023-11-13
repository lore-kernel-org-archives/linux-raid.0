Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E26C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 12:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjKMM1A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 07:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjKMM07 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 07:26:59 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B162E10FC
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 04:26:56 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-7a68b87b265so167750639f.2
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 04:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699878416; x=1700483216; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aRf7G+3r7X17YFL4bIIbubHrrQhPAB7yZop//76yFE=;
        b=SWczGofGuIo5ASzStZ//zoI3grZcmCx/Idkh5PTwej1mWr+yjf5Eo3oPBeqWDUsfYq
         z1hqUHx9/cEKRWXW8ppJIi377XXB9sltvpAy0AcFpPmD7e0Lxsw7mtG45aSbeSTrwLcB
         8c5rlGGV4heIIB0LJrHbpcTAnRRyJElgPYk1oASL4TKpY92RwGlWDBrY7eBtvjCVGCzT
         PGR/jq8Y2lQtbWfLja/bVjVG4jMfwd+XHoEdCvC36vFEy0LRTc/iofp5hdWB5JXoRxgr
         6ELrSHsPeyacdFapJ0OhEc69EzXTfy7kUhFmo9hjaT9rIyMqpWR7MHOunNf/655TxvQF
         XAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699878416; x=1700483216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aRf7G+3r7X17YFL4bIIbubHrrQhPAB7yZop//76yFE=;
        b=QxgakqJmBSAHsWlJ25o5Vxh4Y6/TghReAptfY42AI5t7KyvP1pDlMD+HaKW/+uV5b+
         jf7XKCTvOstiwGfDdFzWAT4q4oBbLd8cLOsY+evbp+8FV3ixDgcIWFaJtFwc/GVv75Es
         Ex2h5kDXRp4uFOTENKLJg1bLmZ7izQm7KPN43ah/2mGbgabKrOYuTdO9rzYa7F2YGVvu
         d/9uEZpN3gnC9jXbbu/cf/d+prXZH6GLxwvSb+scLapUendtKV8NsnwXvuyUW5sgnqgL
         vxOCtbTQ7cjBdArtqr2YssDRcPHFR9nyqPCfxdzHftH9bfsyKhZhaiLkhdgJd7+FIncH
         tMtg==
X-Gm-Message-State: AOJu0YyMs3hackQQkZbwPsWXL1EsITNMB6rMdEUtfmDaZc09XGoSkgms
        OYbZtB729Gmrg3KZjQK7uFQ3NwTvn5CEoiMo5488snYj
X-Google-Smtp-Source: AGHT+IGsPhGaYsQNCAWiJ3iQX2CcnhiXObfN0aje5RZoOQgAiPQnhB/zqwsFEdg+QGK6orIzcxbnWG30Yc+yMBE3808=
X-Received: by 2002:a05:6602:2e02:b0:79f:b2c5:e8b with SMTP id
 o2-20020a0566022e0200b0079fb2c50e8bmr9327750iow.20.1699878415892; Mon, 13 Nov
 2023 04:26:55 -0800 (PST)
MIME-Version: 1.0
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au> <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
 <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au> <ZVHIPNwC2RKTVmok@vault.lan>
 <182d07c8-a76e-430d-90e8-6df8c1f1c54d@eyal.emu.id.au> <ZVHqbnFRU4bXBDNQ@vault.lan>
 <60e4892e-f6b3-4f0a-956d-09555d8ee147@eyal.emu.id.au>
In-Reply-To: <60e4892e-f6b3-4f0a-956d-09555d8ee147@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 13 Nov 2023 06:26:45 -0600
Message-ID: <CAAMCDecgi7kHkLWHaAZ1nP4obvVrzj5zaGFk8Ow-GdxkHZ_oAQ@mail.gmail.com>
Subject: Re: extremely slow writes to array [now not degraded]
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The tuen2fs'es are setting changes only and are designed to be
reversible and non-destructive.

You could note the stride value, umount, make the change, and remount
and see if that fixes the issue and that would expected to be safe.

If something went wrong (about all I have ever seen go wrong is some
of the settings need the fstab entry changed and/or cannot be turned
off for all fses of the same type (ie ext2/3 and be turned off but not
ext4) so are invalid and fail the mount until you revert the setting
with tune2fs), you umount, but the stride setting back and remount.

On Mon, Nov 13, 2023 at 3:36=E2=80=AFAM <eyal@eyal.emu.id.au> wrote:
>
> On 13/11/2023 20.20, Johannes Truschnigg wrote:
> > Interesting data; thanks for providing it. Unfortunately, I am not fami=
liar
> > with that part of kernel code at all, but there's two observations that=
 I can
> > contribute:
> >
> > According to kernel source, `ext4_mb_scan_aligned` is a "special case f=
or
> > storages like raid5", where "we try to find stripe-aligned chunks for
> > stripe-size-multiple requests" - and it seems that on your system, it m=
ight be
> > trying a tad too hard. I don't have a kernel source tree handy right no=
w to
> > take a look at what might have changed in the function and any of its
> > calle[er]s during recent times, but it's the first place I'd go take a =
closer
> > look at.
>
> Maybe someone else is able to look into this part? One hopes.
>
> > Also, there's a recent Kernel bugzilla entry[0] that observes a similar=
ly
> > pathological behavior from ext4 on a single disk of spinning rust where=
 that
> > particular function appears in the call stack, and which revolves aroun=
d an
> > mkfs-time-enabled feature which will, afaik, happen to also be set if
> > mke2fs(8) detects md RAID in the storage stack beneath the device it is
> > supposed to format (and which SHOULD get set, esp. for parity-based RAI=
D).
> >
> > Chances are you may be able to disable this particular optimization by =
running
> > `tune2fs -E stride=3D0` against the filesystem's backing array (be warn=
ed that I
> > did NOT verify if that might screw your data, which it very well could!=
!) and
> > remounting it afterwards, to check if that is indeed (part of) the unde=
rlying
> > cause to the poor performance you see. If you choose to try that, make =
sure to
> > record the current stride-size, so you may re-apply it at a later time
> > (`tune2fs -l` should do).
>
> No, I am not ready to take this chance, but here is the relevant data any=
way (see below).
> However, maybe I could boot into an older kernel, but the oldest I have i=
s 6.5.7, not that far behind.
>
> The fact that recently the machine crashed and the array was reassembled =
may have offered an opportunity
> for some setting to go out of wack. This is above my pay grade...
>
> tune2fs 1.46.5 (30-Dec-2021)
> Filesystem volume name:   7x12TB
> Last mounted on:          /data1
> Filesystem UUID:          378e74a6-e379-4bd5-ade5-f3cd85952099
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr dir_index filetype needs_r=
ecovery extent 64bit flex_bg sparse_super large_file huge_file dir_nlink ex=
tra_isize metadata_csum
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              57220480
> Block count:              14648440320
> Reserved block count:     0
> Overhead clusters:        4921116
> Free blocks:              2615571465
> Free inodes:              55168125
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Group descriptor size:    64
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         128
> Inode blocks per group:   8
> RAID stride:              128
> RAID stripe width:        640
> Flex block group size:    16
> Filesystem created:       Fri Oct 26 17:58:35 2018
> Last mount time:          Mon Nov 13 16:28:16 2023
> Last write time:          Mon Nov 13 16:28:16 2023
> Mount count:              7
> Maximum mount count:      -1
> Last checked:             Tue Oct 31 18:15:25 2023
> Check interval:           0 (<none>)
> Lifetime writes:          495 TB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     32
> Desired extra isize:      32
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      7eb08e20-5ee6-46af-9ef9-2d1280dfae98
> Journal backup:           inode blocks
> Checksum type:            crc32c
> Checksum:                 0x3590ae50
>
> > [0]: https://bugzilla.kernel.org/show_bug.cgi?id=3D217965
> >
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
