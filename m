Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF79C4332F
	for <linux-raid@archiver.kernel.org>; Thu, 24 Nov 2022 00:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiKXACI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 19:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKXACH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 19:02:07 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690658F3DB
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 16:02:05 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id m4so105948vsc.6
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 16:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5grP4pDljZ3lEutpEPXavSJ72Eu2P4gDFrCaILH78Sk=;
        b=lH6wR+/iLDzs+KYVkWFPGptjfNtd9TERrDQehhvprp5GzmcO9CfjVc1zAbZuoe1Qhs
         AKtnrieKnOvoE3mz56oETFDVgG7ZfI9scMP/JvhJYLgsy0sVWOIERX6+mArbfjVZyaUK
         ciUm6ayAwy7ihJ7GOe+mz9+Zm9Ej9kn57IXBkPfbPkwEeIsZwjamBPggyRqKzJxuXEUR
         vDXKOzhPUTSRyi5MLfZshpq7uItzCdIZdz2t13oxx2h6ucEObh1C7jRsR8/M2gy5MUvb
         IewBTIGKVT0QtBmNrt8FetFiGNkrmZ8eJjoXadwVO7Lt79FyMThj87uCjTbkvQJze0rw
         3R1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5grP4pDljZ3lEutpEPXavSJ72Eu2P4gDFrCaILH78Sk=;
        b=ZZo5ny4hbaUo4IZYcAiQD149QknDkzgyGqe6CsKF/pg0Q6FQKn7z5nwJWnw7rnB+DU
         G1xrFZLVVgBkR/etW5T5mGMP9+Dp6NXYH7Jiw0t0Jg0sHT0m3wyN3se4uSkTCQ3YlQ+E
         We/rj2Nob6S6wLSCrQRULVtpme1SUfiS6ebPUwsG2axplr6Ynj7kE2KHrZwmQ52PPCD2
         xawD1/Wes+525JifeCfzZYISWjEM78KO2Jii3fKTXf14Pc+PdAdnqUccCEFPeFkWC/t5
         q99Jb5JjD4rawtk5zadSpkhY+cXDNbwaVs5htqAPC4jb9MJTSRDejJMrSZgYrjoe32Td
         /SsA==
X-Gm-Message-State: ANoB5plj2itATdmTyTZURNU5BcFuKIExNKUGQ4ShY0M6j2TplMvZcR1m
        VrSBK6VLiOtd+2n77oyIK3CfHs3Z3gLcoM48zY2Ark3K
X-Google-Smtp-Source: AA0mqf6ONCz0xDV1fntwgN8PRd5jf6GotzAbf3aElZvWofGj49i9CDYAgEFLZrYNvP57fRIXg8TksQIOdwGFwJVia7g=
X-Received: by 2002:a05:6102:1d9:b0:3b0:5b84:6182 with SMTP id
 s25-20020a05610201d900b003b05b846182mr6763253vsq.9.1669248124289; Wed, 23 Nov
 2022 16:02:04 -0800 (PST)
MIME-Version: 1.0
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
In-Reply-To: <20221124032821.628cd042@nvm>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 23 Nov 2022 18:01:52 -0600
Message-ID: <CAAMCDedMhATuEPx8yFzAwxf5zS7CXFhz6702rmUCg7pXQX4qSA@mail.gmail.com>
Subject: Re: how do i fix these RAID5 arrays?
To:     Roman Mamedov <rm@romanrm.net>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have used the slicing scheme.    A couple of advantages are that the
smaller grows will finish in a reasonable time (vs a single
grow/replace that takes a week or more).

And the drives often have small ranges of sectors that have read
errors causing only a single partition to get thrown out and have to
be re-added and that smaller chunk rebuild much faster.

I have also had SATA cabling/interface issues that caused a few
temporary failures to happen and those errors do not generally result
in all the partitions getting kicked out, leaving a much smaller
re-add.

And another advantage is that you aren't limited to the exact same
sizes of devices.

 I use LVM on a 4 section raid built very similar to his, except mine
is a linear lvm so no raid0 seek issues.

I think we need to see a grep -E 'md5|sdk' /var/log/messages to see
where sdk went.

I have never see devices get removed straight away, mine go to failed
and then I have to remove them and re-add them when one does have an
issue.


On Wed, Nov 23, 2022 at 4:41 PM Roman Mamedov <rm@romanrm.net> wrote:
>
> On Wed, 23 Nov 2022 22:07:36 +0000
> David T-G <davidtg-robot@justpickone.org> wrote:
>
> >   diskfarm:~ # mdadm -D /dev/md50
> >   /dev/md50:
> >              Version : 1.2
> >        Creation Time : Thu Nov  4 00:56:36 2021
> >           Raid Level : raid0
> >           Array Size : 19526301696 (18.19 TiB 19.99 TB)
> >         Raid Devices : 6
> >        Total Devices : 6
> >          Persistence : Superblock is persistent
> >
> >          Update Time : Thu Nov  4 00:56:36 2021
> >                State : clean
> >       Active Devices : 6
> >      Working Devices : 6
> >       Failed Devices : 0
> >        Spare Devices : 0
> >
> >               Layout : -unknown-
> >           Chunk Size : 512K
> >
> >   Consistency Policy : none
> >
> >                 Name : diskfarm:10T  (local to host diskfarm)
> >                 UUID : cccbe073:d92c6ecd:77ba5c46:5db6b3f0
> >               Events : 0
> >
> >       Number   Major   Minor   RaidDevice State
> >          0       9       51        0      active sync   /dev/md/51
> >          1       9       52        1      active sync   /dev/md/52
> >          2       9       53        2      active sync   /dev/md/53
> >          3       9       54        3      active sync   /dev/md/54
> >          4       9       55        4      active sync   /dev/md/55
> >          5       9       56        5      active sync   /dev/md/56
>
> It feels you haven't thought this through entirely. Sequential writes to this
> RAID0 array will alternate across all member arrays, and seeing how those are
> not of independent disks, but instead are "vertical" across partitions on the
> same disks, it will result in a crazy seek load, as first 512K is written to
> the array of the *51 partitions, second 512K go to *52, then to *53,
> effectively requiring a full stroke of each drive's head across the entire
> surface for each and every 3 *megabytes* written.
>
> mdraid in the "linear" mode, or LVM with one large LV across all PVs (which
> are the individual RAID5 arrays), or multi-device Btrfs using "single" profile
> for data, all of those would avoid the described effect.
>
> But I should clarify, the entire idea of splitting drives like this seems
> questionable to begin with, since drives more often fail entirely, not in part,
> so you will not save any time on rebuilds; and the "bitmap" already protects
> you against full rebuilds due to any hiccups such as a power cut; or even if a
> drive failed in part, in your current setup, or even in the proposed ones I
> mentioned above, losing even one RAID5 of all these, would result in a
> complete loss of data anyway. Not to mention what you have seems like an insane
> amount of complexity.
>
> To summarize, maybe it's better to blow away the entire thing and restart from
> the drawing board, while it's not too late? :)
>
> >   diskfarm:~ # mdadm -D /dev/md5[13456] | egrep '^/dev|active|removed'
> >   /dev/md51:
> >        0     259        9        0      active sync   /dev/sdb51
> >        1     259        2        1      active sync   /dev/sdc51
> >        3     259       16        2      active sync   /dev/sdd51
> >        -       0        0        3      removed
> >   /dev/md53:
> >        0     259       11        0      active sync   /dev/sdb53
> >        1     259        4        1      active sync   /dev/sdc53
> >        3     259       18        2      active sync   /dev/sdd53
> >        -       0        0        3      removed
> >   /dev/md54:
> >        0     259       12        0      active sync   /dev/sdb54
> >        1     259        5        1      active sync   /dev/sdc54
> >        3     259       19        2      active sync   /dev/sdd54
> >        -       0        0        3      removed
> >   /dev/md55:
> >        0     259       13        0      active sync   /dev/sdb55
> >        1     259        6        1      active sync   /dev/sdc55
> >        3     259       20        2      active sync   /dev/sdd55
> >        -       0        0        3      removed
> >   /dev/md56:
> >        0     259       14        0      active sync   /dev/sdb56
> >        1     259        7        1      active sync   /dev/sdc56
> >        3     259       21        2      active sync   /dev/sdd56
> >        -       0        0        3      removed
> >
> > that are obviously the sdk (new disk) slice.  If md52 were also broken,
> > I'd figure that the disk was somehow unplugged, but I don't think I can
> > plug in one sixth of a disk and leave the rest unhooked :-)  So ...  In
> > addition to wondering how I got here, how do I remove the "removed" ones
> > and then re-add them to build and grow and finalize this?
>
> If you want to fix it still, without dmesg it's hard to say how this could
> have happened, but what does
>
>   mdadm --re-add /dev/md51 /dev/sdk51
>
> say?
>
> --
> With respect,
> Roman
