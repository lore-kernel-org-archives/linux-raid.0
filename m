Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D593C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 18:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiKYSBD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Nov 2022 13:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiKYSBC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Nov 2022 13:01:02 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175EF53EE2
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 10:01:00 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id m4so4851483vsc.6
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 10:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/LL1WMbKOrdrSidc74HdTw3D4Azr/QPDbmmg3dDll7E=;
        b=BDWPdv/6OXXQdZNPvhutLPhwn/eTnbZ5OFJMvl78iCI8qH14jTNUjTwSzoytP+s6pP
         Q+umAXuLs7lp52fGIU2Ya93EAVxK549CxpfRkz5pzNG3U4MzjNpxhUfs560sPkXFFWDm
         U4fOBtWbEQucaL2AZyadf0oHk5f3hyGX/za4p8D7IBmRZq/lHFsE5VRPuYtD7sU6Y7HL
         Q6tG2b66oQwwP09GCvcqj1Y21dsCNwAobNddgIXLRBESKMOAGrrkbYO72+VUa6SofalQ
         NkC1pyyDbJ26Ncjkdf+iQ8c4hirkljBB2m4aS2hbNbpkyxzFILuZi/vM3+QLFiM3ofYs
         j6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LL1WMbKOrdrSidc74HdTw3D4Azr/QPDbmmg3dDll7E=;
        b=NjJ7+CiRyRLtLtncM0rMvZuwnI1j2UvYiDPcjhrZAxpY+QeCxuwzE2jGGRBYYCE+LK
         ng4JwaGAd7ZkXzYlggvd30klOl9EDybXuHAUCX9fabrqOc+fofdJiUCHICFjTTk/GVjm
         jrcPDaTStNGQXq93vzOz7w8AOTvekrec5J5/6XwaPhcC8NsSDaWwE7KHa0xGUjm7hyGD
         PmvTwFbUbdI/UhZ7zQtnywyuwgp1XuSbpeJpiFRpFsCXySviyTdRfVXS5f8cGJGQI6Nl
         mq5z0L3Z3rdS/QDCGmd90PFNpHiLBUcuZhmBlrStlpikUrykXZ9RpfnRLmcC3MaQtoBl
         kzxQ==
X-Gm-Message-State: ANoB5pkPL23PmFg5/Sfpw5bPFLndQLuA73rqsw5+T05ijhWAd0xJFJMt
        /V6x5XUaEPWe9gcinlR9bmKb+cm5PUtX22ekLZl7d3G9
X-Google-Smtp-Source: AA0mqf7iwHFTYYGNFhbnyDG2Qwk2hThoBzLAdCrTb6io26V4j6PYKFlRuXFImAm7NcHD/lR7M5I2uu94F9Z5ykh3bac=
X-Received: by 2002:a05:6102:25a:b0:3af:2625:b2bd with SMTP id
 a26-20020a056102025a00b003af2625b2bdmr10627610vsq.40.1669399259121; Fri, 25
 Nov 2022 10:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo> <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
In-Reply-To: <20221125133050.GH19721@jpo>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 25 Nov 2022 12:00:47 -0600
Message-ID: <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
Subject: Re: about linear and about RAID10 (was "Re: how do i fix these RAID5 arrays?")
To:     David T-G <davidtg-robot@justpickone.org>
Cc:     Linux RAID list <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

You do not want to stripe 2 partitions on a single disk, you want that linear.

With a stripe write on 4 striped partitions you get this.
Write a stripe for each disk on part1, then do a 8-10ms seek, then
write the next stripe on part2 and then seek back to part1 and repeat.

With Linear you get:
write a stripe, (there usually won't be any seek, and if there is it
will be a single track seek and much quicker), then write the next
stripe.

If the head data rate is 200MB/sec (ballpark typical for a disk) then
that 10ms could write 2MB of data.   So the larger the stripe size the
less you waste % wise on the seeks).  But if say the block per disk
is 256K, then that write takes around 1.25ms and the seek to the next
one takes 10ms so the seeks significantly reduce you read/write rates.

do a dd if=/dev/mdXX of=/dev/null bs=1M count=100 iflag=direct  on one
of the raid5s of the partitions and then on the raid1 device over
them.  I would expect the raid device over them to be much slower, I
am not sure how much but 5x-20x.

On Fri, Nov 25, 2022 at 7:36 AM David T-G <davidtg-robot@justpickone.org> wrote:
>
> Wol, et al --
>
> ...and then Wol said...
> % On 24/11/2022 21:10, David T-G wrote:
> % > How is linear different from RAID0?  I took a quick look but don't quite
> % > know what I'm reading.  If that's better then, hey, I'd try it (or at
> % > least learn more).
> %
> % Linear tacks one drive on to the end of another. Raid-0 stripes across all
> % drives. Both effectively combine a bunch of drives into one big drive.
>
> Ahhhhh...  I gotcha.  Thanks.
>
>
> %
> ...
> %
> % That's why there's raid-10. Note that outside of Linux (and often inside)
> % when people say "raid-10" they actually mean "raid 1+0". That's two striped
> % raid-0's, mirrored.
>
> That's basically what I have on the web server:
>
>   jpo:~ # mdadm -D /dev/md41 | egrep '/dev|Level'
>   /dev/md41:
>           Raid Level : raid1
>          0       8       17        0      active sync   /dev/sdb1
>          1       8       34        1      active sync   /dev/sdc2
>   jpo:~ # mdadm -D /dev/md42 | egrep '/dev|Level'
>   /dev/md42:
>           Raid Level : raid1
>          0       8       18        0      active sync   /dev/sdb2
>          1       8       33        1      active sync   /dev/sdc1
>   jpo:~ # mdadm -D /dev/md40 | egrep '/dev|Level'
>   /dev/md40:
>           Raid Level : raid0
>          0       9       41        0      active sync   /dev/md/md41
>          1       9       42        1      active sync   /dev/md/md42
>   jpo:~ #
>   jpo:~ #
>   jpo:~ # parted /dev/sdb p
>   Model: ATA ST4000VN008-2DR1 (scsi)
>   Disk /dev/sdb: 4001GB
>   Sector size (logical/physical): 512B/4096B
>   Partition Table: gpt
>   Disk Flags:
>
>   Number  Start   End     Size    File system  Name                    Flags
>    1      1049kB  2000GB  2000GB               Raid1-1
>    2      2000GB  4001GB  2000GB               Raid1-2
>    4      4001GB  4001GB  860kB   ext2         Seag4000-ZDHB2X37-ext2
>
>   jpo:~ # parted /dev/sdc p
>   Model: ATA ST4000VN008-2DR1 (scsi)
>   Disk /dev/sdc: 4001GB
>   Sector size (logical/physical): 512B/4096B
>   Partition Table: gpt
>   Disk Flags:
>
>   Number  Start   End     Size    File system  Name                    Flags
>    1      1049kB  2000GB  2000GB               Raid1-2
>    2      2000GB  4001GB  2000GB               Raid1-1
>    4      4001GB  4001GB  860kB                Seag4000-ZDHBKZTG-ext2
>
>
> %
> ...
> %
> % Either version (10, or 1+0), gives you get the speed of striping, and the
> % safety of a mirror. 10, however, can use an odd number of disks, and disks
> % of random sizes.
>
> That's still magic to me :-)  Mirroring (but not doubling up the
> redundancy) on an odd number of disks?!?
>
>
> %
> % Cheers,
> % Wol
>
>
> HAND
>
> :-D
> --
> David T-G
> See http://justpickone.org/davidtg/email/
> See http://justpickone.org/davidtg/tofu.txt
>
